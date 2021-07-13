Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC53C70E3
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhGMNGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbhGMNGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 09:06:53 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F3C0613DD;
        Tue, 13 Jul 2021 06:04:02 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k20so14581458pgg.7;
        Tue, 13 Jul 2021 06:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wICO7mAwhqJD1edb3nvOclBABQKgJ4d++G/031aYfk4=;
        b=NeSEYEwpwaMAY/u6wfT8YqxYJ29jDeD4nKlvqwUM2Q2EhDJhGPqnAJL7BXdPCC6YdD
         XkDaCKAWWILQJkAQG32yIaGA6opOub7y7pgqeaQOxxBgJlqElvz1PAMQINvdgzlgu5mi
         EcRgCskZ56y6pKWRQRoQ68lK0iBp5vdb9jVecO/RlowkRnxISCaz1EnLSL5lnTkoMkoK
         hhq4+N2HO2HyudtZyuEoR92SLtA7bbU/sdKgr7M/xYQ/Q4X4/KmUhoPCP2lbZhhTRZTA
         MJk4spuP6i+GyS2+YhdYkCOqPu3XcAsXrOQieeByWWQ7+8WG5J6mfkM/kODxrpClgYbD
         9bJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wICO7mAwhqJD1edb3nvOclBABQKgJ4d++G/031aYfk4=;
        b=QenehPU+/eEtkT12s0KmDsdJnrtuuyCGHBs5NvQ1kv7DQOirkGzSLD8hM1ddj2T586
         SztqzrhLm8jcciXetuiu+N+HSS3VNt+jpPREhXiZe76ZmTEN6mgEp0Us4T2EEimo5b3M
         lxnnMQPTGmW0JuLm85xvIqK3reGeQ3yG6GQIPKThYOdG5ZyBMKt3/fJ6+qJfrbDru5P2
         EChGb/WSFzLxMB5XRRav1hqKt/J3M4oi7RtiTD+WJXwVzpTlZOPN/eWuFjarC/Wff3at
         SGE2+EICJrHetMH4Mif6F0Dkcr/cBVjlakgJGXorX0LjZyNe4IJIc2KLRinybaZnthl/
         AhGg==
X-Gm-Message-State: AOAM532HpTmuQy2Bih1tFb3cSry77RNKf2PUSTevHwwIFS2ZLM6733YL
        ZG+MWU/okno9xE39zfmItPg=
X-Google-Smtp-Source: ABdhPJxHvb2e9OGV+rWBRwtvIifXpJ70kyVgCHmlO0ZAbHm20/q1TEey5dmlakW8q1Gl8ileAPwlyg==
X-Received: by 2002:a63:f64d:: with SMTP id u13mr4256994pgj.156.1626181441973;
        Tue, 13 Jul 2021 06:04:01 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id w2sm3184238pjf.2.2021.07.13.06.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 06:04:01 -0700 (PDT)
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
Subject: [PATCH v2] audit: fix memory leak in nf_tables_commit
Date:   Tue, 13 Jul 2021 21:03:44 +0800
Message-Id: <20210713130344.473646-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
free the adp variable.

Fix this by freeing the linked list with head adl.

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
 net/netfilter/nf_tables_api.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 390d4466567f..7f45b291be13 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8444,6 +8444,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
 	return 0;
 }
 
+static void nf_tables_commit_free(struct list_head *adl)
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
+			nf_tables_commit_free(&adl);
 			return ret;
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -8517,6 +8528,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
 				nf_tables_commit_chain_prepare_cancel(net);
+				nf_tables_commit_free(&adl);
 				return ret;
 			}
 		}
-- 
2.25.1

