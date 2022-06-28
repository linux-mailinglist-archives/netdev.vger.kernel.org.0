Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B971F55EE9B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiF1Txn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiF1Tu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C319B2DD7B;
        Tue, 28 Jun 2022 12:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445796; x=1687981796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g8Auyiv6wHbONHbwKT22jacyNDfM23OeRa/UWJqi3CM=;
  b=YdjyG9s+lBgEx52Mi0a3xSijbBo66ikErxkPW+n3P7LM4lonlSWU35e6
   p+thIwS3/BYJRLD4P+oOt7lninnwgGVcAlbK0aBA2u1Lrvc3t+bIXlQUg
   7LDJBg5dmeqtDzQlGO5Ib9ai/UCM+JYsu0xoRoblijEpc/jd3ttgOeJUf
   1y/MDyyrviQpTDIvCNd+wHjhLpHJpdwy9TOFuelfrKxuSp6YflzE7xlJa
   wqioBeOdP8JBda73K4GqUeedPyP8IR3vuMIsIt8I77tsZOIG16fFWZyhH
   Rrh1pzawgeya0e+mZCFGxTqvEvXNfNzrpUJnO+RQylwFFPm7VxILQcU4Y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="345828494"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="345828494"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="680182656"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2022 12:49:51 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9g022013;
        Tue, 28 Jun 2022 20:49:49 +0100
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
Subject: [PATCH RFC bpf-next 42/52] net, xdp: shortcut skb->dev in bpf_prog_run_generic_xdp()
Date:   Tue, 28 Jun 2022 21:48:02 +0200
Message-Id: <20220628194812.1453059-43-alexandr.lobakin@intel.com>
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

It's being used 3 times and more to come. Fetch it onto the stack
to reduce jumping back and forth.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 net/bpf/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index cc43f73929f3..350ebdc783a0 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -31,6 +31,7 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 			     struct bpf_prog *xdp_prog)
 {
 	void *orig_data, *orig_data_end, *hard_start;
+	struct net_device *dev = skb->dev;
 	struct netdev_rx_queue *rxqueue;
 	bool orig_bcast, orig_host;
 	u32 mac_len, frame_sz;
@@ -57,7 +58,7 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
 	eth = (struct ethhdr *)xdp->data;
-	orig_host = ether_addr_equal_64bits(eth->h_dest, skb->dev->dev_addr);
+	orig_host = ether_addr_equal_64bits(eth->h_dest, dev->dev_addr);
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
@@ -86,11 +87,11 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 	eth = (struct ethhdr *)xdp->data;
 	if ((orig_eth_type != eth->h_proto) ||
 	    (orig_host != ether_addr_equal_64bits(eth->h_dest,
-						  skb->dev->dev_addr)) ||
+						  dev->dev_addr)) ||
 	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
 		__skb_push(skb, ETH_HLEN);
 		skb->pkt_type = PACKET_HOST;
-		skb->protocol = eth_type_trans(skb, skb->dev);
+		skb->protocol = eth_type_trans(skb, dev);
 	}
 
 	/* Redirect/Tx gives L2 packet, code that will reuse skb must __skb_pull
-- 
2.36.1

