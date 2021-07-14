Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B23C7CF3
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 05:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbhGNDaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 23:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbhGNDaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 23:30:20 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BACFC0613DD;
        Tue, 13 Jul 2021 20:27:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h4so951420pgp.5;
        Tue, 13 Jul 2021 20:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fs0dJT+CYtli8VWxcsALtkdK7y7s0huk1WucGWBqsvg=;
        b=YSVZAGnid/hf0YZB3FKd81E5KtbuHdAr1ntK7uDTCuLdrCiu17CzsABDEyrexyZBB0
         NSCmaRJLH0A4eEqMeFnes4OPXneQnKo67Tz6HrvZiwSG8QTd/NExNwBps5ob788rhEes
         4osgtYqhCUHqxBwRy544Q8zvlTTH8eWC4HcH5oF3M10dx1jgmkBSNAgpGBH9uqfeb0ko
         vgXn5en82qCD5ltJf8Rd5aTdg7Vy/jBBbN/lMV50qn9FY9Y3Dai/WGQ82zC/+mdBlFzY
         Fm4yuuss0StGwxvC7+TdhisOx3XRxPC3uM1QjYVZCLyvoEdhYa3UPSYS5HEUiplt9BFP
         RM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fs0dJT+CYtli8VWxcsALtkdK7y7s0huk1WucGWBqsvg=;
        b=g2KzBKO4T755A1DDgGsd5pdwN0+l5EpM4Sfg45gob9/XC+UMn3mtya5U86WdZW/N9L
         KLqH+G/NqoR1ZqPgGqYkfUav3dMRdXvwdalCb0KMnz70SHN93Y0hPOC6+3eclPZ/MeFE
         1E3w4C6PqzcR5JgL3c3igPtelHQjpmCtAF/qUPuiWe4qiiGiRrFmHo4uW7Hqp16GbPZp
         zTQn2qaXN/sHvNttm65ooHCpCs+QHtiF/1z0stTI37tLd/uzJ5dwA54FmI/0PGCnNx71
         HUN2ejdLjAITUmyNEqgWh8KfSVrDu8dWUL3/0iCErX3/KWl22GPRAQiZ16QNNQ/qw7ir
         O5fA==
X-Gm-Message-State: AOAM530y4g4+AdGJSp5qLgdpLyNPpLZNLwgLhxDP79+BR5PA4TFFzqoD
        VnTlst1Te6s0Et7rgltzBvc=
X-Google-Smtp-Source: ABdhPJyYf0JB4m1nI00mva8ZpxAX1QnLnXslGkHvDbaqxDffMUnUHADBFActTNwYhoi4pl5IQtC+IA==
X-Received: by 2002:a65:6a42:: with SMTP id o2mr7141072pgu.316.1626233248729;
        Tue, 13 Jul 2021 20:27:28 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id y5sm596970pfn.87.2021.07.13.20.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 20:27:28 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] audit: fix memory leak in nf_tables_commit
Date:   Wed, 14 Jul 2021 11:27:03 +0800
Message-Id: <20210714032703.505023-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
free the adp variable.

Fix this by adding nf_tables_commit_audit_free which frees 
the linked list with the head node adl.

backtrace:
  kmalloc include/linux/slab.h:591 [inline]
  kzalloc include/linux/slab.h:721 [inline]
  nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
  nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
  nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
  nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
  netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
  netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
  sock_sendmsg_nosec net/socket.c:702 [inline]
  sock_sendmsg+0x56/0x80 net/socket.c:722

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: fix the compile issue
v2->v3: modify the added function to a new name
 net/netfilter/nf_tables_api.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 390d4466567f..7f45b291be13 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8444,6 +8444,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
 	return 0;
 }
 
+static void nf_tables_commit_audit_free(struct list_head *adl)
+{
+	struct nft_audit_data *adp, *adn;
+
+	list_for_each_entry_safe(adp, adn, adl, list) {
+		list_del(&adp->list);
+		kfree(adp);
+	}
+}
+
 static void nf_tables_commit_audit_collect(struct list_head *adl,
 					   struct nft_table *table, u32 op)
 {
@@ -8508,6 +8518,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
 		if (ret) {
 			nf_tables_commit_chain_prepare_cancel(net);
+			nf_tables_commit_audit_free(&adl);
 			return ret;
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -8517,6 +8528,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
 				nf_tables_commit_chain_prepare_cancel(net);
+				nf_tables_commit_audit_free(&adl);
 				return ret;
 			}
 		}
-- 
2.25.1

