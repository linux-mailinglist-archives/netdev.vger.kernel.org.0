Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C9443E902
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhJ1Tey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 15:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhJ1Tey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 15:34:54 -0400
X-Greylist: delayed 999 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Oct 2021 12:32:26 PDT
Received: from mail-out04.uio.no (mail-out04.uio.no [IPv6:2001:700:100:8210::76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835BEC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 12:32:26 -0700 (PDT)
Received: from mail-mx11.uio.no ([129.240.10.83])
        by mail-out04.uio.no with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <asadsa@ifi.uio.no>)
        id 1mgAsD-00GCRi-FF; Thu, 28 Oct 2021 21:15:37 +0200
Received: from ti0187q162-6461.bb.online.no ([46.9.242.137] helo=debian.debian)
        by mail-mx11.uio.no with esmtpsa (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        user asadsa@ifi.uio.no (Exim 4.94.2)
        (envelope-from <asadsa@ifi.uio.no>)
        id 1mgAsC-000Dtk-Pd; Thu, 28 Oct 2021 21:15:37 +0200
From:   Asad Sajjad Ahmed <asadsa@ifi.uio.no>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        Bob Briscoe <research@bobbriscoe.net>,
        Asad Sajjad Ahmed <asadsa@ifi.uio.no>,
        Olga Albisser <olga@albisser.org>
Subject: [PATCH net-next] fq_codel: avoid under-utilization with ce_threshold at low link rates
Date:   Thu, 28 Oct 2021 21:15:00 +0200
Message-Id: <20211028191500.47377-1-asadsa@ifi.uio.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-UiO-SPF-Received: Received-SPF: neutral (mail-mx11.uio.no: 46.9.242.137 is neither permitted nor denied by domain of ifi.uio.no) client-ip=46.9.242.137; envelope-from=asadsa@ifi.uio.no; helo=debian.debian;
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: 3A3AE363430D2684A109B4ECB2A5A5011738EF7E
X-UiOonly: 3BFF8D308085BC77AF17C7E1D6961343C6FE044D
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit "fq_codel: generalise ce_threshold marking for subset of traffic"
[1] enables ce_threshold to be used in the Internet, not just in data
centres.

Because ce_threshold is in time units, it can cause poor utilization at
low link rates when it represents <1 packet.
E.g., if link rate <12Mb/s ce_threshold=1ms is <1500B packet.

So, suppress ECN marking unless the backlog is also > 1 MTU.

A similar patch to [1] was tested on an earlier kernel, and a similar
one-packet check prevented poor utilization at low link rates [2].

[1] commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset of traffic")

[2] See right hand column of plots at the end of:
https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf

Signed-off-by: Asad Sajjad Ahmed <asadsa@ifi.uio.no>
Signed-off-by: Olga Albisser <olga@albisser.org>
---
 include/net/codel_impl.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
index 137d40d8cbeb..4e3e8473e776 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -248,7 +248,8 @@ static struct sk_buff *codel_dequeue(void *ctx,
 						    vars->rec_inv_sqrt);
 	}
 end:
-	if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
+	if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
+	    *backlog > params->mtu) {
 		bool set_ce = true;
 
 		if (params->ce_threshold_mask) {
-- 
2.30.2

