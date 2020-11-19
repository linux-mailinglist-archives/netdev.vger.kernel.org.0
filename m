Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAA82B8962
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKSBOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:14:06 -0500
Received: from novek.ru ([213.148.174.62]:38874 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgKSBOF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:14:05 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A680E501633;
        Thu, 19 Nov 2020 04:14:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A680E501633
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605748456; bh=7VKNROS/i3WHXmOF7ozmuBHEHAdmOix+SRbryUXB07Q=;
        h=From:To:Cc:Subject:Date:From;
        b=k/Ji6OS3IllO6M3riDtSGtw9WFDFPhk7Ghe4Qc2p5vJtOZxsHNmy9bsLj6LbDY340
         FpFjzW8JYpWKfl45Ajh/8UvMWU1+gCww5UkWB2K//UXmFYw8RKIEThaOpU6Ujo0KHg
         WFK3HCGLzq/EjhIW/xgHqh1G+WLVRl+oHZP0iXKw=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net v2] net/tls: missing received data after fast remote close
Date:   Thu, 19 Nov 2020 04:13:52 +0300
Message-Id: <1605748432-19416-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case when tcp socket received FIN after some data and the
parser haven't started before reading data caller will receive
an empty buffer. This behavior differs from plain TCP socket and
leads to special treating in user-space.
The flow that triggers the race is simple. Server sends small
amount of data right after the connection is configured to use TLS
and closes the connection. In this case receiver sees TLS Handshake
data, configures TLS socket right after Change Cipher Spec record.
While the configuration is in process, TCP socket receives small
Application Data record, Encrypted Alert record and FIN packet. So
the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
SK_DONE bit set. The received data is not parsed upon arrival and is
never sent to user-space.

Patch unpauses parser directly if we have unparsed data in tcp
receive queue.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2fe9e2c..97c5f6e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1295,6 +1295,12 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 			return NULL;
 		}
 
+		if (skb_queue_empty(&sk->sk_receive_queue)) {
+			__strp_unpause(&ctx->strp);
+			if (ctx->recv_pkt)
+				return ctx->recv_pkt;
+		}
+
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return NULL;
 
-- 
1.8.3.1

