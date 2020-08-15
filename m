Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2E24543E
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgHOWSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:18:55 -0400
Received: from correo.us.es ([193.147.175.20]:38930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728838AbgHOWSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDF34DA89B
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE3A9DA840
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3F69DA72F; Sat, 15 Aug 2020 12:32:15 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE348DA73F;
        Sat, 15 Aug 2020 12:32:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C2FF242EF4E0;
        Sat, 15 Aug 2020 12:32:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/8] netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian
Date:   Sat, 15 Aug 2020 12:31:54 +0200
Message-Id: <20200815103201.1768-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

On big-endian machine, the returned register data when the exthdr is
present is not being compared correctly because little-endian is
assumed. The function nft_cmp_fast_mask(), called by nft_cmp_fast_eval()
and nft_cmp_fast_init(), calls cpu_to_le32().

The following dump also shows that little endian is assumed:

$ nft --debug=netlink add rule ip recordroute forward ip option rr exists counter
ip
  [ exthdr load ipv4 1b @ 7 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x01000000 ]
  [ counter pkts 0 bytes 0 ]

Lastly, debug print in nft_cmp_fast_init() and nft_cmp_fast_eval() when
RR option exists in the packet shows that the comparison fails because
the assumption:

nft_cmp_fast_init:189 priv->sreg=4 desc.len=8 mask=0xff000000 data.data[0]=0x10003e0
nft_cmp_fast_eval:57 regs->data[priv->sreg=4]=0x1 mask=0xff000000 priv->data=0x1000000

v2: use nft_reg_store8() instead (Florian Westphal). Also to avoid the
    warnings reported by kernel test robot.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 07782836fad6..3c48cdc8935d 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -44,7 +44,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		nft_reg_store8(dest, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
@@ -141,7 +141,7 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 
 	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		nft_reg_store8(dest, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
-- 
2.20.1

