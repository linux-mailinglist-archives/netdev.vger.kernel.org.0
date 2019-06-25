Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1686251FA9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfFYAMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:55 -0400
Received: from mail.us.es ([193.147.175.20]:38004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbfFYAMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 672A2C04AA
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57FF8DA709
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4DADADA704; Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45606DA708;
        Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 12E254265A2F;
        Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/26] netfilter: nft_ct: fix null pointer in ct expectations support
Date:   Tue, 25 Jun 2019 02:12:25 +0200
Message-Id: <20190625001233.22057-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stéphane Veyret <sveyret@gmail.com>

nf_ct_helper_ext_add may return null, which must then be checked.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 06b52c894573..77dab1bdb3ca 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1232,6 +1232,10 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	help = nfct_help(ct);
 	if (!help)
 		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+	if (!help) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
 
 	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
 		regs->verdict.code = NFT_BREAK;
-- 
2.11.0

