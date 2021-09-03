Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE436400351
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350011AbhICQbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:31:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58764 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349988AbhICQba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:31:30 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 51154600A9;
        Fri,  3 Sep 2021 18:29:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/5] netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex
Date:   Fri,  3 Sep 2021 18:30:16 +0200
Message-Id: <20210903163020.13741-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210903163020.13741-1-pablo@netfilter.org>
References: <20210903163020.13741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

Syzbot hit use-after-free in nf_tables_dump_sets. The problem was in
missing lock protection for nft_ct_pcpu_template_refcnt.

Before commit f102d66b335a ("netfilter: nf_tables: use dedicated
mutex to guard transactions") all transactions were serialized by global
mutex, but then global mutex was changed to local per netnamespace
commit_mutex.

This change causes use-after-free bug, when 2 netnamespaces concurently
changing nft_ct_pcpu_template_refcnt without proper locking. Fix it by
adding nft_ct_pcpu_mutex and protect all nft_ct_pcpu_template_refcnt
changes with it.

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 337e22d8b40b..99b1de14ff7e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -41,6 +41,7 @@ struct nft_ct_helper_obj  {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
 static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
+static DEFINE_MUTEX(nft_ct_pcpu_mutex);
 #endif
 
 static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
@@ -525,8 +526,10 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		break;
 #endif
 	default:
@@ -564,9 +567,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
-		if (!nft_ct_tmpl_alloc_pcpu())
+		mutex_lock(&nft_ct_pcpu_mutex);
+		if (!nft_ct_tmpl_alloc_pcpu()) {
+			mutex_unlock(&nft_ct_pcpu_mutex);
 			return -ENOMEM;
+		}
 		nft_ct_pcpu_template_refcnt++;
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		len = sizeof(u16);
 		break;
 #endif
-- 
2.20.1

