Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E80E55EE46
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiF1TyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiF1TvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD623B;
        Tue, 28 Jun 2022 12:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445811; x=1687981811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ufgJOb+TezFSxWKDyYwF8u0ehQj1wQzhK8T9FWSr3eU=;
  b=LfXKIyab3d+L51y9sjQI6XC/tWQnm16jbae18+N3+TXqh/OCcAn63WRW
   dCoXDn5GYqmrQltNAKqKIzsaoralX89cQuFoZ03EnSqyo2mflyw9pXEl0
   /MW5IT8bVpgGSadP6EUXoo2ZNa37P0j1IrKDNg4oznvaRMC1gKElXfyw0
   k+HkXRkHhEAeKhxcuuQAefVDL33IqSXwvkHXkW5O68eI+Nkwx2IuHRH6V
   0S6rzekNxy+9L0wf4VBZXoGMhUzdaI/9VjRdPFUdSawuZH/Ep12jnThfG
   apHzKTjWRtuqqg6ZlnARaiDEI82AR7j1XQOwDJBsj6gGOAsZhwBMTV70H
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368147011"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="368147011"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="617303166"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 28 Jun 2022 12:49:50 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9f022013;
        Tue, 28 Jun 2022 20:49:48 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 41/52] net, xdp: replace net_device::xdp_prog pointer with &xdp_attachment_info
Date:   Tue, 28 Jun 2022 21:48:01 +0200
Message-Id: <20220628194812.1453059-42-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To have access and store not only BPF prog pointer, but also
auxiliary params on Generic (skb) XDP path, replace it with
an &xdp_attachment_info struct and use xdp_attachment_setup_rcu()
(since Generic XDP code RCU-protects the pointer already).
This slightly changes the struct &net_device cacheline layout, but
nothing performance-critical.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/netdevice.h |  7 +++----
 net/bpf/dev.c             | 11 ++++-------
 net/core/dev.c            |  4 +++-
 net/core/rtnetlink.c      |  2 +-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 60df42b3f116..1c033c164257 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2168,7 +2168,7 @@ struct net_device {
 	unsigned int		num_rx_queues;
 	unsigned int		real_num_rx_queues;
 
-	struct bpf_prog __rcu	*xdp_prog;
+	struct xdp_attachment_info xdp_info;
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
 #define GRO_LEGACY_MAX_SIZE	65536u
@@ -2343,9 +2343,8 @@ struct net_device {
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
-		return true;
-	return false;
+	return !(dev->features & NETIF_F_GRO) ||
+	       rcu_access_pointer(dev->xdp_info.prog_rcu);
 }
 
 #define	NETDEV_ALIGN		32
diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index 82948d0536c8..cc43f73929f3 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -242,19 +242,16 @@ static void dev_disable_gro_hw(struct net_device *dev)
 
 static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 {
-	struct bpf_prog *old = rtnl_dereference(dev->xdp_prog);
-	struct bpf_prog *new = xdp->prog;
+	bool old = !!rtnl_dereference(dev->xdp_info.prog_rcu);
 	int ret = 0;
 
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		rcu_assign_pointer(dev->xdp_prog, new);
-		if (old)
-			bpf_prog_put(old);
+		xdp_attachment_setup_rcu(&dev->xdp_info, xdp);
 
-		if (old && !new) {
+		if (old && !xdp->prog) {
 			static_branch_dec(&generic_xdp_needed_key);
-		} else if (new && !old) {
+		} else if (xdp->prog && !old) {
 			static_branch_inc(&generic_xdp_needed_key);
 			dev_disable_lro(dev);
 			dev_disable_gro_hw(dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 62bf6ee00741..e57ae87d619e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5055,10 +5055,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	__this_cpu_inc(softnet_data.processed);
 
 	if (static_branch_unlikely(&generic_xdp_needed_key)) {
+		struct bpf_prog *prog;
 		int ret2;
 
 		migrate_disable();
-		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		prog = rcu_dereference(skb->dev->xdp_info.prog_rcu);
+		ret2 = do_xdp_generic(prog, skb);
 		migrate_enable();
 
 		if (ret2 != XDP_PASS) {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 500420d5017c..72f696b12df2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1451,7 +1451,7 @@ static u32 rtnl_xdp_prog_skb(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	generic_xdp_prog = rtnl_dereference(dev->xdp_prog);
+	generic_xdp_prog = rtnl_dereference(dev->xdp_info.prog_rcu);
 	if (!generic_xdp_prog)
 		return 0;
 	return generic_xdp_prog->aux->id;
-- 
2.36.1

