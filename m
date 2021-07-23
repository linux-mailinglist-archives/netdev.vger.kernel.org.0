Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567573D37D4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhGWJAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhGWJAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:00:51 -0400
X-Greylist: delayed 94 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Jul 2021 02:41:25 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC6DC061575;
        Fri, 23 Jul 2021 02:41:25 -0700 (PDT)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 78A512E198D;
        Fri, 23 Jul 2021 12:39:46 +0300 (MSK)
Received: from iva8-5ba4ca89b0c6.qloud-c.yandex.net (iva8-5ba4ca89b0c6.qloud-c.yandex.net [2a02:6b8:c0c:a8ae:0:640:5ba4:ca89])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id CFZnpdw2zJ-dj088eSL;
        Fri, 23 Jul 2021 12:39:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1627033186; bh=sN7C3HUF4CT+oTysV0poD5qgCG15k/0i+3fQFTFO4/g=;
        h=Cc:Message-Id:Date:Subject:To:From;
        b=T3UVjrlXrr5EuXmpA4sw/4UHQY2svfo/tAZ+huXCiNvoGKSWOu0XLt2XzQUqxDYIs
         hyN13AkNO5uviZfr2yKUIj1FlrsxUgpVM9LZrPeeamENX2o/JMEWfsQzB8YAfDLCn7
         k+4p9DrsGrgbl9JICokJpx5aUIjQQqaoVcBZOB+Y=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 172.31.93.162-vpn.dhcp.yndx.net (172.31.93.162-vpn.dhcp.yndx.net [172.31.93.162])
        by iva8-5ba4ca89b0c6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id oTYqu3ggUK-dj2urJdf;
        Fri, 23 Jul 2021 12:39:45 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     kafai@fb.com, edumazet@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     dmtrmonakhov@yandex-team.ru
Subject: [PATCH] tcp: use rto_min value from socket in retransmits timeout
Date:   Fri, 23 Jul 2021 12:39:38 +0300
Message-Id: <20210723093938.49354-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ca584ba07086 ("tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt")
adds ability to set rto_min value on socket less then default TCP_RTO_MIN.
But retransmits_timed_out() function still uses TCP_RTO_MIN and
tcp_retries{1,2} sysctls don't work properly for tuned socket values.

Fixes: ca584ba07086 ("tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt")
Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
---
 net/ipv4/tcp_timer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a9..66c4b97 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -199,12 +199,13 @@ static unsigned int tcp_model_timeout(struct sock *sk,
  *  @boundary: max number of retransmissions
  *  @timeout:  A custom timeout value.
  *             If set to 0 the default timeout is calculated and used.
- *             Using TCP_RTO_MIN and the number of unsuccessful retransmits.
+ *             Using icsk_rto_min value from socket or RTAX_RTO_MIN from route
+ *             and the number of unsuccessful retransmits.
  *
  * The default "timeout" value this function can calculate and use
  * is equivalent to the timeout of a TCP Connection
  * after "boundary" unsuccessful, exponentially backed-off
- * retransmissions with an initial RTO of TCP_RTO_MIN.
+ * retransmissions with an initial RTO of icsk_rto_min or RTAX_RTO_MIN.
  */
 static bool retransmits_timed_out(struct sock *sk,
 				  unsigned int boundary,
@@ -217,7 +218,7 @@ static bool retransmits_timed_out(struct sock *sk,
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
 	if (likely(timeout == 0)) {
-		unsigned int rto_base = TCP_RTO_MIN;
+		unsigned int rto_base = tcp_rto_min(sk);
 
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			rto_base = tcp_timeout_init(sk);
-- 
2.7.4

