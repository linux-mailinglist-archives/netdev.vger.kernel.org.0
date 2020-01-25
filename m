Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11121496EE
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 18:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgAYReZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 12:34:25 -0500
Received: from correo.us.es ([193.147.175.20]:35452 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAYReZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 12:34:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5409812C1E7
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44A88DA713
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3A41ADA70F; Sat, 25 Jan 2020 18:34:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18156DA705;
        Sat, 25 Jan 2020 18:34:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 25 Jan 2020 18:34:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E19C942EE38E;
        Sat, 25 Jan 2020 18:34:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/7] netfilter: nft_osf: add missing check for DREG attribute
Date:   Sat, 25 Jan 2020 18:34:09 +0100
Message-Id: <20200125173415.191571-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200125173415.191571-1-pablo@netfilter.org>
References: <20200125173415.191571-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reports just another NULL deref crash because of missing test
for presence of the attribute.

Reported-by: syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com
Fixes:  b96af92d6eaf9fadd ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index f54d6ae15bb1..b42247aa48a9 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -61,6 +61,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 	int err;
 	u8 ttl;
 
+	if (!tb[NFTA_OSF_DREG])
+		return -EINVAL;
+
 	if (tb[NFTA_OSF_TTL]) {
 		ttl = nla_get_u8(tb[NFTA_OSF_TTL]);
 		if (ttl > 2)
-- 
2.11.0

