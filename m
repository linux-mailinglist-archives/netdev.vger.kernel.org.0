Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5159055EE71
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiF1Txs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiF1Tu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4952C11D;
        Tue, 28 Jun 2022 12:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445793; x=1687981793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7sizNGB2psf+Qq79FGgS+INcdvERhbHoOrovj1ZDfPY=;
  b=M/JQpYwzZJwJYLF9Tj5DbVX/0AwPNHPJB73ZyBrBDIdwyHCe49XBwpR5
   NgPfT55GO0dHoPYWA8eIO1XipcSEop4RGgEbj90jSUDC/j8AtQye8Kz3a
   yRRIJ2lX096Zwl9nkc/d1dI12k8xMX9U2NrQXg7CaAVKQPQ4OpVTactsB
   ECbtAaZa90vepE9sn+IYWrliZrLyBN57h39Mg5Mf0xZmSxInI6ySCFi+P
   DjRE2AsqqU26JByo0Mseb8piFLX0OEiZ8QMN5eIskMR1KfNPjoHWShBTg
   +YGPx9FztLnCnYbwpD05jmNx6IVx7oGj+oeiyDGWnwu6lyF8z9Mx3wpql
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="262242993"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="262242993"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="836809532"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2022 12:49:49 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9e022013;
        Tue, 28 Jun 2022 20:49:47 +0100
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
Subject: [PATCH RFC bpf-next 40/52] net, xdp: add an RCU version of xdp_attachment_setup()
Date:   Tue, 28 Jun 2022 21:48:00 +0200
Message-Id: <20220628194812.1453059-41-alexandr.lobakin@intel.com>
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

Currently, xdp_attachment_setup() uses plain assignments and puts
the previous BPF program before updating the pointer, rendering
itself dangerous for program hot-swaps due to pointer tearing and
potential use-after-free's.
At the same time, &xdp_attachment_info comes handy to use it in
drivers as a main container including hotpath -- the BTF ID and meta
threshold values are now being used there as well, not speaking of
reducing some boilerplate code.
Add an RCU-protected pointer to XDP program to that structure and an
RCU version of xdp_attachment_setup(), which will make sure that all
the values were not corrupted and that old BPF program was freed
only after the pointer was updated. The only thing left is that RCU
read critical sections might happen in between each assignment, but
since the relations between XDP prog, BTF ID and meta threshold are
not vital, it's totally fine to allow this.
A caller must ensure it's being executed under the RTNL lock. Reader
sides must ensure they're being executed under the RCU read lock.
Once all the current users of xdp_attachment_setup() are switched to
the RCU-aware version (with appropriate adjustments), the "regular"
one will be removed.
Partially inspired by commit fe45386a2082 ("net/mlx5e: Use RCU to
protect rq->xdp_prog").

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/xdp.h |  7 ++++++-
 net/bpf/core.c    | 28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 5762ce18885f..49e562e4fcca 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -379,7 +379,10 @@ int xdp_reg_mem_model(struct xdp_mem_info *mem,
 void xdp_unreg_mem_model(struct xdp_mem_info *mem);
 
 struct xdp_attachment_info {
-	struct bpf_prog *prog;
+	union {
+		struct bpf_prog __rcu *prog_rcu;
+		struct bpf_prog *prog;
+	};
 	union {
 		__le64 btf_id_le;
 		u64 btf_id;
@@ -391,6 +394,8 @@ struct xdp_attachment_info {
 struct netdev_bpf;
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf);
+void xdp_attachment_setup_rcu(struct xdp_attachment_info *info,
+			      struct netdev_bpf *bpf);
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
diff --git a/net/bpf/core.c b/net/bpf/core.c
index 65f25019493d..d444d0555057 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -557,6 +557,34 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 }
 EXPORT_SYMBOL_GPL(xdp_attachment_setup);
 
+/**
+ * xdp_attachment_setup_rcu - an RCU-powered version of xdp_attachment_setup()
+ * @info: pointer to the target container
+ * @bpf: pointer to the container passed to ::ndo_bpf()
+ *
+ * Protects sensitive values with RCU to allow program how-swaps without
+ * stopping an interface. Write side (this) must be called under the RTNL lock
+ * and reader sides must fetch any data only under the RCU read lock -- old BPF
+ * program will be freed only after a critical section is finished (see
+ * bpf_prog_put()).
+ */
+void xdp_attachment_setup_rcu(struct xdp_attachment_info *info,
+			      struct netdev_bpf *bpf)
+{
+	struct bpf_prog *old_prog;
+
+	ASSERT_RTNL();
+
+	old_prog = rcu_replace_pointer(info->prog_rcu, bpf->prog,
+				       lockdep_rtnl_is_held());
+	WRITE_ONCE(info->btf_id, bpf->btf_id);
+	WRITE_ONCE(info->meta_thresh, bpf->meta_thresh);
+
+	if (old_prog)
+		bpf_prog_put(old_prog);
+}
+EXPORT_SYMBOL_GPL(xdp_attachment_setup_rcu);
+
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 {
 	unsigned int metasize, totsize;
-- 
2.36.1

