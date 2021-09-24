Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365D9417DA6
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345097AbhIXWNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49794 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345246AbhIXWNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:13:01 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 476FD63EB8;
        Sat, 25 Sep 2021 00:10:05 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 10/15] netfilter: nf_tables: Fix oversized kvmalloc() calls
Date:   Sat, 25 Sep 2021 00:11:08 +0200
Message-Id: <20210924221113.348767-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
limits the max allocatable memory via kvmalloc() to MAX_INT.

Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 33e771cd847c..b9546defdc28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4336,7 +4336,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 	alloc_size = sizeof(*set) + size + udlen;
-	if (alloc_size < size)
+	if (alloc_size < size || alloc_size > INT_MAX)
 		return -ENOMEM;
 	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)
-- 
2.30.2

