Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBC7191CB8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgCXWcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:32:33 -0400
Received: from correo.us.es ([193.147.175.20]:34614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728653AbgCXWcc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:32:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 286BBFB38D
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:31:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18F68DA801
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:31:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EB394DA3AD; Tue, 24 Mar 2020 23:31:54 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EB06DA3C2;
        Tue, 24 Mar 2020 23:31:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 23:31:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E56D142EF42B;
        Tue, 24 Mar 2020 23:31:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/7] netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
Date:   Tue, 24 Mar 2020 23:32:19 +0100
Message-Id: <20200324223220.12119-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324223220.12119-1-pablo@netfilter.org>
References: <20200324223220.12119-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set skb->tc_redirected to 1, otherwise the ifb driver drops the packet.
Set skb->tc_from_ingress to 1 to reinject the packet back to the ingress
path after leaving the ifb egress path.

This patch inconditionally sets on these two skb fields that are
meaningful to the ifb driver. The existing forward action is guaranteed
to run from ingress path.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fwd_netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index ddd28de810b6..74f050ba6bad 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -28,6 +28,10 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
 
+	/* These are used by ifb only. */
+	pkt->skb->tc_redirected = 1;
+	pkt->skb->tc_from_ingress = 1;
+
 	nf_fwd_netdev_egress(pkt, oif);
 	regs->verdict.code = NF_STOLEN;
 }
-- 
2.11.0

