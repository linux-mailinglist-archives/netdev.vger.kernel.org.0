Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74C355EE91
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiF1Tv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiF1Tuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8353A713;
        Tue, 28 Jun 2022 12:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445757; x=1687981757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UA7ojFhtLpSWs3CIAGleRKPCFOtCm25p70d35QFcy9U=;
  b=ZIPZUwJrQuf24f83SkKWjkmKrYpt9BlkXkmmNTKV4IuMaIkALTxSFV59
   1qwn9rIIkhMnc18ePfHo/9THxKnh8TMTvyXoO//3fZ2EUWxR7VGafYe1R
   5qeDise7WSAKolsgpaIFIJ7Pei9k1MM8ytBXX7vnhOJs+usYVGLLZzK/t
   PG//VZ+4ghSrxVJivWg0/p0MC9efp9fAVEOogI8t2vcZd/byoWAvKHZEf
   Iobr8zJRd7MBCDIVfQMFTZv/Fga1Nte4o1AQUDBrNJ9TQVPPXcoyo3K9Y
   NN9fuIQkkivwCyz1PuDEC4O1BNjAGqkJkDsSpprlaS0LahZF8lNRm8Ea2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280595783"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280595783"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="594927476"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2022 12:49:05 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr97022013;
        Tue, 28 Jun 2022 20:49:03 +0100
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
Subject: [PATCH RFC bpf-next 07/52] net, xdp: remove redundant arguments from dev_xdp_{at,de}tach_link()
Date:   Tue, 28 Jun 2022 21:47:27 +0200
Message-Id: <20220628194812.1453059-8-alexandr.lobakin@intel.com>
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

dev_xdp_attach_link(): the sole caller always passes %NULL as
@extack and @link->dev as @dev, so they both can be omitted.
The very same story with dev_xdp_detach_link(): remove both
@dev and @extack as they both can be obtained inside the
function itself.
This decreases stack usage with no functional changes.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 net/bpf/dev.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index 68a7b2c49392..0010b20719e8 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -534,17 +534,14 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 	return 0;
 }
 
-static int dev_xdp_attach_link(struct net_device *dev,
-			       struct netlink_ext_ack *extack,
-			       struct bpf_xdp_link *link)
+static int dev_xdp_attach_link(struct bpf_xdp_link *link)
 {
-	return dev_xdp_attach(dev, extack, link, NULL, NULL, link->flags);
+	return dev_xdp_attach(link->dev, NULL, link, NULL, NULL, link->flags);
 }
 
-static int dev_xdp_detach_link(struct net_device *dev,
-			       struct netlink_ext_ack *extack,
-			       struct bpf_xdp_link *link)
+static int dev_xdp_detach_link(struct bpf_xdp_link *link)
 {
+	struct net_device *dev = link->dev;
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
 
@@ -570,7 +567,7 @@ static void bpf_xdp_link_release(struct bpf_link *link)
 	 * already NULL, in which case link was already auto-detached
 	 */
 	if (xdp_link->dev) {
-		WARN_ON(dev_xdp_detach_link(xdp_link->dev, NULL, xdp_link));
+		WARN_ON(dev_xdp_detach_link(xdp_link));
 		xdp_link->dev = NULL;
 	}
 
@@ -709,7 +706,7 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		goto unlock;
 	}
 
-	err = dev_xdp_attach_link(dev, NULL, link);
+	err = dev_xdp_attach_link(link);
 	rtnl_unlock();
 
 	if (err) {
-- 
2.36.1

