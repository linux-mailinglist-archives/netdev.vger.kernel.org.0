Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64D3C6DAD
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhGMJpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbhGMJpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 05:45:04 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2D1C0613DD;
        Tue, 13 Jul 2021 02:42:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v7so21128928pgl.2;
        Tue, 13 Jul 2021 02:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fWMP9fQRTobWKqa9AEAof4IRXVKYtteX5duYf7hZbc=;
        b=qXb2LQCtkyInsqxC5JJn1LnL4RjpgOltJlhN+455aYKGiBphUoR/xgs5IABM2A2tSB
         hS+QLZB7fJYT72pUGaGqTyGHcXSun35PHsIrFf0pwS/8TvxXTMOH+aTg6TlRQFaCJzKq
         oX+7/PfIYZBln0A03jbea6oNez3fEikd0UEsRREPcEujeTne2N+HnU4b2gEkWGktWBqL
         LE/xywaqshZvL1zZ1SKOToInMLNN+Fbnz30gE7OHjptaW74H/muLCCWJHpliSYMuACOP
         coVsldI2wnlPmqJOJI0+GhxhU51Nfya/BoaR7UzgR5W7TG65lQdgQXvyVnSBUruphR9d
         0KvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fWMP9fQRTobWKqa9AEAof4IRXVKYtteX5duYf7hZbc=;
        b=PocTL4l+Yn4nTtzcwBITf1pZrc9CN+0cTv3PcF+cav8HUUM/KixgUAYuUBQN+B5JBd
         kchA7sIjam0ArTLslLjiAfbTo4xC6Ii3FVwwButYH/XcDltORwzq71+Q+XybakhcCXbF
         +m9OE3WNcNuTkvZnIe+nw7NcDQMpSgUI3T+Jv1qNleDk8Hk7ygCLjcB9qiBKMFfGQnXU
         cfnvx3tSNVuTU4ecdF4XnlqLgShq7uCStvypyVx5PFku2O9RplX2fqklWCMg+SzHAtkm
         Pwnqk8o4SoHUzPln2th1O4yWoTk03lE3vPYqi3YdwTa7RctDqtkR46jC4C5WACJn3xVW
         61Lg==
X-Gm-Message-State: AOAM533ahTkqsgqUnsHYOyw661OojsJjbJfyyBRrGeOnQpAlYBOqZOwb
        K4fOOt3UJ1yOGTJFKXnUHC4=
X-Google-Smtp-Source: ABdhPJyyDhrO5NGkQ2bzwhZfOXDZTJ8z3m998PSHfA79sGP2hZe7o45tHI6Iv6mumGQWyVv6oZ3lEg==
X-Received: by 2002:a63:5351:: with SMTP id t17mr3378618pgl.315.1626169334332;
        Tue, 13 Jul 2021 02:42:14 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id s2sm18558087pgr.12.2021.07.13.02.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 02:42:13 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] audit: fix memory leak in nf_tables_commit
Date:   Tue, 13 Jul 2021 17:41:57 +0800
Message-Id: <20210713094158.450434-1-mudongliangabcd@gmail.com>
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
Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
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
+			nf_tables_commit_free(adl);
 			return ret;
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -8517,6 +8528,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
 				nf_tables_commit_chain_prepare_cancel(net);
+				nf_tables_commit_free(adl);
 				return ret;
 			}
 		}
-- 
2.25.1

