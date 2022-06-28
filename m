Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7081655EE9A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiF1Txp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiF1Tu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B5D2E09A;
        Tue, 28 Jun 2022 12:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445797; x=1687981797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Ah1nON265YzupnBokZWEAPrUTKFeqbKYbnG7bxwujc=;
  b=jwhXTTPL30RP0omRzUFU22r8Yf9xPM/I6tu8rjW1UH7q6Sv1HjWTCtt5
   Vo+f1XqD+IrkNxKDGNieFdMG3arpimjIrx6OglobAdvUEeoZQxC9jTtMx
   b3+Q53oroBwN7cQ4tuWYnUIy/cNZeLcqW2+lOmRdWrT9jpqfgyvAj7KPc
   ed8lfyg1KnguQ+EdUUa7Qzdxl/42MByB41u+ntiB5tzJY1YRhBMq4KxEp
   1dmJeI+XDH8Ol1oBls2exCoIuskSfgrEW0X/Y77n7R2wjvjKFxZATdU8r
   O+t3PQpqMZZvJQAYbAYwUGPtLe5cEA0KpYOWBggEsJ+dXLAuWdf1wpHo9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280596029"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280596029"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="594927639"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2022 12:49:53 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9h022013;
        Tue, 28 Jun 2022 20:49:51 +0100
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
Subject: [PATCH RFC bpf-next 43/52] net, xdp: build XDP generic metadata on Generic (skb) XDP path
Date:   Tue, 28 Jun 2022 21:48:03 +0200
Message-Id: <20220628194812.1453059-44-alexandr.lobakin@intel.com>
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

Now that the core has the routine to make XDP generic metadata from
the skb fields and &net_device stores meta_thresh, provide XDP
generic metadata to BPF programs running on Generic/skb XDP path.
skb fields are being updated from the metadata after BPF program
exits (if it's still there).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 net/bpf/dev.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index 350ebdc783a0..f4187b357a0c 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -1,7 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <net/xdp_meta.h>
 #include <trace/events/xdp.h>
 
+enum {
+	GENERIC_XDP_META_GEN,
+
+	/* Must be last */
+	GENERIC_XDP_META_NONE,
+	__GENERIC_XDP_META_NUM,
+};
+
+static const char * const generic_xdp_meta_types[__GENERIC_XDP_META_NUM] = {
+	[GENERIC_XDP_META_GEN]	= "struct xdp_meta_generic",
+};
+
 DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 
 static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
@@ -27,17 +40,33 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
+static void generic_xdp_handle_meta(struct xdp_buff *xdp, struct sk_buff *skb,
+				    const struct xdp_attachment_info *info)
+{
+	if (xdp->data_end - xdp->data < READ_ONCE(info->meta_thresh))
+		return;
+
+	switch (READ_ONCE(info->drv_cookie)) {
+	case GENERIC_XDP_META_GEN:
+		xdp_build_meta_generic_from_skb(skb);
+		xdp->data_meta = skb_metadata_end(skb) - skb_metadata_len(skb);
+		break;
+	default:
+		break;
+	}
+}
+
 u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 			     struct bpf_prog *xdp_prog)
 {
 	void *orig_data, *orig_data_end, *hard_start;
 	struct net_device *dev = skb->dev;
 	struct netdev_rx_queue *rxqueue;
+	u32 metalen, orig_metalen, act;
 	bool orig_bcast, orig_host;
 	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
-	u32 metalen, act;
 	int off;
 
 	/* The XDP program wants to see the packet starting at the MAC
@@ -62,6 +91,9 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
+	generic_xdp_handle_meta(xdp, skb, &dev->xdp_info);
+	orig_metalen = xdp->data - xdp->data_meta;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	/* check if bpf_xdp_adjust_head was used */
@@ -105,11 +137,15 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 	case XDP_REDIRECT:
 	case XDP_TX:
 		__skb_push(skb, mac_len);
-		break;
+		fallthrough;
 	case XDP_PASS:
 		metalen = xdp->data - xdp->data_meta;
-		if (metalen)
+		if (metalen != orig_metalen)
 			skb_metadata_set(skb, metalen);
+		if (metalen)
+			xdp_populate_skb_meta_generic(skb);
+		else if (orig_metalen)
+			skb_metadata_nocomp_clear(skb);
 		break;
 	}
 
@@ -244,10 +280,15 @@ static void dev_disable_gro_hw(struct net_device *dev)
 static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	bool old = !!rtnl_dereference(dev->xdp_info.prog_rcu);
-	int ret = 0;
+	int ret;
 
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
+		ret = xdp_meta_match_id(generic_xdp_meta_types, xdp->btf_id);
+		if (ret < 0)
+			return ret;
+
+		WRITE_ONCE(dev->xdp_info.drv_cookie, ret);
 		xdp_attachment_setup_rcu(&dev->xdp_info, xdp);
 
 		if (old && !xdp->prog) {
@@ -257,6 +298,8 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 			dev_disable_lro(dev);
 			dev_disable_gro_hw(dev);
 		}
+
+		ret = 0;
 		break;
 
 	default:
-- 
2.36.1

