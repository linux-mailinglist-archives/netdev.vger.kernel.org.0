Return-Path: <netdev+bounces-2216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E33700BF6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77717281D4F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB372412F;
	Fri, 12 May 2023 15:30:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F5A24146;
	Fri, 12 May 2023 15:30:02 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1117BE702;
	Fri, 12 May 2023 08:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905374; x=1715441374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lrRJS0jP369ocGK4OM/oyS3+pmBq12NrPBpQcE0bU8o=;
  b=CJaToMacSeSP1eBor1kMx+dmf3EFVM1Pvk1zAZBcnwvi5ugX5+yPlC9F
   X74SDVP/GVtPS85JXtbzoUoX4FZXFWMTdrI/ZYG4ESA0Gf5Cp3xzkmtLS
   c75N5oMiSCdfzrv61EH5NR/COja1mWDmzWudZLbcmOe8O+Z+7ZxLp8L1h
   6suYMOs7xIfFkTH24GaKtF8KLl4GcwxhnrDY9VDL1tfpXu3vIV6EJYEVC
   HbfugCvAoyWzD+KRhzdSO7WOcivAwX3VspzwKQjTjTe3wx669QbRaXsFr
   e40SoLU/I82pzHI/tPhASkM4zIsNC8jFyBlOXlz7ZITA3JiShk0N9NhZg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="349653485"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="349653485"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:29:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="1030124604"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="1030124604"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2023 08:29:04 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id F37F935FB8;
	Fri, 12 May 2023 16:29:02 +0100 (IST)
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
	linux-kernel@vger.kernel.org,
	Aleksander Lobakin <aleksander.lobakin@intel.com>
Subject: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
Date: Fri, 12 May 2023 17:26:06 +0200
Message-Id: <20230512152607.992209-15-larysa.zaremba@intel.com>
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

From: Aleksander Lobakin <aleksander.lobakin@intel.com>

When using XDP hints, metadata sometimes has to be much bigger
than 32 bytes. Relax the restriction, allow metadata larger than 32 bytes
and make __skb_metadata_differs() work with bigger lengths.

Now size of metadata is only limited by the fact it is stored as u8
in skb_shared_info, so maximum possible value is 255. Other important
conditions, such as having enough space for xdp_frame building, are already
checked in bpf_xdp_adjust_meta().

The requirement of having its length aligned to 4 bytes is still
valid.

Signed-off-by: Aleksander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 include/linux/skbuff.h | 13 ++++++++-----
 include/net/xdp.h      |  7 ++++++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8ddb4af1a501..afcd372aecdf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4219,10 +4219,13 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
 {
 	const void *a = skb_metadata_end(skb_a);
 	const void *b = skb_metadata_end(skb_b);
-	/* Using more efficient varaiant than plain call to memcmp(). */
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 diffs = 0;
 
+	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    BITS_PER_LONG != 64)
+		goto slow;
+
+	/* Using more efficient variant than plain call to memcmp(). */
 	switch (meta_len) {
 #define __it(x, op) (x -= sizeof(u##op))
 #define __it_diff(a, b, op) (*(u##op *)__it(a, op)) ^ (*(u##op *)__it(b, op))
@@ -4242,11 +4245,11 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
 		fallthrough;
 	case  4: diffs |= __it_diff(a, b, 32);
 		break;
+	default:
+slow:
+		return memcmp(a - meta_len, b - meta_len, meta_len);
 	}
 	return diffs;
-#else
-	return memcmp(a - meta_len, b - meta_len, meta_len);
-#endif
 }
 
 static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0fbd25616241..f48723250c7c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -370,7 +370,12 @@ xdp_data_meta_unsupported(const struct xdp_buff *xdp)
 
 static inline bool xdp_metalen_invalid(unsigned long metalen)
 {
-	return (metalen & (sizeof(__u32) - 1)) || (metalen > 32);
+	typeof(metalen) meta_max;
+
+	meta_max = type_max(typeof_member(struct skb_shared_info, meta_len));
+	BUILD_BUG_ON(!__builtin_constant_p(meta_max));
+
+	return !IS_ALIGNED(metalen, sizeof(u32)) || metalen > meta_max;
 }
 
 struct xdp_attachment_info {
-- 
2.35.3


