Return-Path: <netdev+bounces-2213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CE6700BEB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7A23280E3F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9BA14284;
	Fri, 12 May 2023 15:29:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296961427A;
	Fri, 12 May 2023 15:29:34 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769C310A27;
	Fri, 12 May 2023 08:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905352; x=1715441352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HYcETTLQrd7Q2kE/D+/Vk/4DhcDrCT+MKt7UQ1PXhqI=;
  b=AtWlfk5Ns/AAFJoaLyGKCklGR+VvhXiduzd7XifJDRjz1KyuRtVfukXR
   dBPtm9NuY9B+mEzw7UUAw1L99nUHbRlnU1uYIOk2oT+vEGs5yQoTVe+lQ
   4RME58aPYTUBTUn7wl7xIu5UGYLHZQTEN+WosaPyC6xVUbPIqPGVk5uiK
   aJKFG97zeHunzrAXAqsiRDABIal0+7LtshFZCMi4fdAbIy5gQ09X/2yOQ
   ew3yieQp75PGHD3v0BZv7lMtZMzJw8h2+K+Z5un+VHJs79elEKyXj8nqm
   /+6JKkBz7ufFp4ArCatOZzPMFg1Y+JS1H7AOg5RAq0P76equvfKAan3Cb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="349653433"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="349653433"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:29:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="1030124584"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="1030124584"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2023 08:28:57 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 0596335FB8;
	Fri, 12 May 2023 16:28:55 +0100 (IST)
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: bpf@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>,
	xdp-hints@xdp-project.net,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND bpf-next 11/15] xdp: Add checksum level hint
Date: Fri, 12 May 2023 17:26:03 +0200
Message-Id: <20230512152607.992209-12-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230512152607.992209-1-larysa.zaremba@intel.com>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement functionality that enables drivers to expose to XDP code,
whether checksums was checked and on what level.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 Documentation/networking/xdp-rx-metadata.rst |  3 +++
 include/linux/netdevice.h                    |  1 +
 include/net/xdp.h                            |  2 ++
 kernel/bpf/offload.c                         |  2 ++
 net/core/xdp.c                               | 12 ++++++++++++
 5 files changed, 20 insertions(+)

diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
index 73a78029c596..f74f0e283097 100644
--- a/Documentation/networking/xdp-rx-metadata.rst
+++ b/Documentation/networking/xdp-rx-metadata.rst
@@ -29,6 +29,9 @@ metadata is supported, this set will grow:
 .. kernel-doc:: net/core/xdp.c
    :identifiers: bpf_xdp_metadata_rx_stag
 
+.. kernel-doc:: net/core/xdp.c
+   :identifiers: bpf_xdp_metadata_rx_csum_lvl
+
 An XDP program can use these kfuncs to read the metadata into stack
 variables for its own consumption. Or, to pass the metadata on to other
 consumers, an XDP program can store it into the metadata area carried
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fdae37fe11f5..ddade3a15366 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1657,6 +1657,7 @@ struct xdp_metadata_ops {
 			       enum xdp_rss_hash_type *rss_type);
 	int	(*xmo_rx_ctag)(const struct xdp_md *ctx, u16 *vlan_tag);
 	int	(*xmo_rx_stag)(const struct xdp_md *ctx, u16 *vlan_tag);
+	int	(*xmo_rx_csum_lvl)(const struct xdp_md *ctx, u8 *csum_level);
 };
 
 /**
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 2db7439fc60f..0fbd25616241 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -393,6 +393,8 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 			   bpf_xdp_metadata_rx_ctag) \
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_STAG, \
 			   bpf_xdp_metadata_rx_stag) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_CSUM_LVL, \
+			   bpf_xdp_metadata_rx_csum_lvl) \
 
 enum {
 #define XDP_METADATA_KFUNC(name, _) name,
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 2c6b6e82cfac..8bd54fb4ac63 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -852,6 +852,8 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
 		p = ops->xmo_rx_ctag;
 	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_STAG))
 		p = ops->xmo_rx_stag;
+	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_CSUM_LVL))
+		p = ops->xmo_rx_csum_lvl;
 out:
 	up_read(&bpf_devs_lock);
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index eff21501609f..7dd45fd62983 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -762,6 +762,18 @@ __bpf_kfunc int bpf_xdp_metadata_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag
 	return -EOPNOTSUPP;
 }
 
+/**
+ * bpf_xdp_metadata_rx_csum_lvl - Get depth at which HW has checked the checksum.
+ * @ctx: XDP context pointer.
+ * @csum_level: Return value pointer.
+ *
+ * Returns 0 on success (HW has checked the checksum) or ``-errno`` on error.
+ */
+__bpf_kfunc int bpf_xdp_metadata_rx_csum_lvl(const struct xdp_md *ctx, u8 *csum_level)
+{
+	return -EOPNOTSUPP;
+}
+
 __diag_pop();
 
 BTF_SET8_START(xdp_metadata_kfunc_ids)
-- 
2.35.3


