Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4233F55EEC1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiF1Tvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FFF62FA;
        Tue, 28 Jun 2022 12:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445769; x=1687981769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SutG8vtwjgxHponFr0JSgxWBk/og3Hhe0diuNsWKHbE=;
  b=MTibYOcQnodnkJWUOqTgp6T/m8KOaAMZuCjoqwkBhxDSAFVJeuGWDzA0
   gluNCtMqofVjmVOy5+RApv0SdK1VgM/ebRjUcu3Fhd7U011/mCYSnlcTX
   w11c8ieCNDmU/dirMoiGk99Z7MizVZxMEudaEhjbH8niNuSRfxyuoj/Sq
   GPj4rTkSIzlEktthH8uuMAmNoy7omx0/Bn+kWUwszpe9EhMYnpthfUieE
   mZm1pNzIhT/nbo/bjJigZtA0FDKH1dya4lQB9eJH4Ci3HIsIllDTc93YO
   72mPI5jR/ZRiC00Z775Zvm0WxiJhdD5c0UDJTg7nH/Q0cu65A3CatPToJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368146910"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="368146910"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="732883398"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2022 12:49:25 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9M022013;
        Tue, 28 Jun 2022 20:49:23 +0100
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
Subject: [PATCH RFC bpf-next 22/52] net, skbuff: add ability to skip skb metadata comparison
Date:   Tue, 28 Jun 2022 21:47:42 +0200
Message-Id: <20220628194812.1453059-23-alexandr.lobakin@intel.com>
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

Some XDP metadata fields maybe be unique from frame to frame, not
necessarily indicating that it's from a different flow. This
includes frame checksums, timestamps etc.
The drivers usually carry the metadata to skbs along with the
payload, and the GRO layer tries to compare the metadata of
the frames. This not only leads to perf regressions (esp. given
that metadata can now be larger than 32 bytes -> a slower call to
memmp() will be used), but also breaks frame coalescing at all.
To avoid that, add an skb flag indicating that the metadata can
carry unique values and thus should not be compared. If at least
one of the skbs passed to skb_metadata_differs() carries it, the
function will then immediately return reporting that they're
identical.
The underscored version of the function is not affected, allowing
to explicitly compare the meta if needed. The flag is being cleared
on pskb_expand_head() when the skb_shared_info::meta_len gets
zeroed.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/skbuff.h | 18 ++++++++++++++++++
 net/core/skbuff.c      |  1 +
 2 files changed, 19 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a825ea7f375d..1c308511acbb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -509,6 +509,11 @@ enum {
 	 * charged to the kernel memory.
 	 */
 	SKBFL_PURE_ZEROCOPY = BIT(2),
+
+	/* skb metadata may contain unique values such as checksums
+	 * and we should not compare it against others.
+	 */
+	SKBFL_METADATA_NOCOMP = BIT(3),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
@@ -4137,6 +4142,9 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
 
 	if (!(len_a | len_b))
 		return false;
+	if ((skb_shinfo(skb_a)->flags | skb_shinfo(skb_b)->flags) &
+	    SKBFL_METADATA_NOCOMP)
+		return false;
 
 	return len_a != len_b ?
 	       true : __skb_metadata_differs(skb_a, skb_b, len_a);
@@ -4152,6 +4160,16 @@ static inline void skb_metadata_clear(struct sk_buff *skb)
 	skb_metadata_set(skb, 0);
 }
 
+static inline void skb_metadata_nocomp_set(struct sk_buff *skb)
+{
+	skb_shinfo(skb)->flags |= SKBFL_METADATA_NOCOMP;
+}
+
+static inline void skb_metadata_nocomp_clear(struct sk_buff *skb)
+{
+	skb_shinfo(skb)->flags &= ~SKBFL_METADATA_NOCOMP;
+}
+
 struct sk_buff *skb_clone_sk(struct sk_buff *skb);
 
 #ifdef CONFIG_NETWORK_PHY_TIMESTAMPING
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 00bf35ee8205..5b23fc7f1157 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1750,6 +1750,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	atomic_set(&skb_shinfo(skb)->dataref, 1);
 
 	skb_metadata_clear(skb);
+	skb_metadata_nocomp_clear(skb);
 
 	/* It is not generally safe to change skb->truesize.
 	 * For the moment, we really care of rx path, or
-- 
2.36.1

