Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D9117F55C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgCJKt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:49:59 -0400
Received: from mailout2.hostsharing.net ([83.223.78.233]:36487 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgCJKt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:49:59 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 8F9CE10189CE9;
        Tue, 10 Mar 2020 11:49:57 +0100 (CET)
Received: from localhost (unknown [87.130.102.138])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 4C34761312B2;
        Tue, 10 Mar 2020 11:49:57 +0100 (CET)
X-Mailbox-Line: From 077e04669829f190988f3b2018d4eee40a42a36e Mon Sep 17 00:00:00 2001
Message-Id: <077e04669829f190988f3b2018d4eee40a42a36e.1583836647.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 10 Mar 2020 11:49:46 +0100
Subject: [PATCH net-next] pktgen: Allow on loopback device
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When pktgen is used to measure the performance of dev_queue_xmit()
packet handling in the core, it is preferable to not hand down
packets to a low-level Ethernet driver as it would distort the
measurements.

Allow using pktgen on the loopback device, thus constraining
measurements to core code.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 net/core/pktgen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index acc849df60b5..f2b3d8dd40f4 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2003,8 +2003,8 @@ static int pktgen_setup_dev(const struct pktgen_net *pn,
 		return -ENODEV;
 	}
 
-	if (odev->type != ARPHRD_ETHER) {
-		pr_err("not an ethernet device: \"%s\"\n", ifname);
+	if (odev->type != ARPHRD_ETHER && odev->type != ARPHRD_LOOPBACK) {
+		pr_err("not an ethernet or loopback device: \"%s\"\n", ifname);
 		err = -EINVAL;
 	} else if (!netif_running(odev)) {
 		pr_err("device is down: \"%s\"\n", ifname);
-- 
2.25.0

