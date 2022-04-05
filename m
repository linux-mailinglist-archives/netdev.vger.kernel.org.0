Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A9A4F3C22
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbiDEMEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380413AbiDELme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919F27A984;
        Tue,  5 Apr 2022 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156807; x=1680692807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p1+NR/7VTk0cYvvXKQl9NZ7o3wjyOAZfYrZa6u+J7uU=;
  b=ELzHwRHkBWhgUJULdKHQ1PY+Sv9hslYGlEP59T8JJgcMi83uaiECioKr
   JMgvEK51uTp83jR6dgRNK2cBhf4lG2VQqw9AEv4rgrHpPnEyqnEECzMUf
   rHI0op1U//Jn4yX9z5tB5Gn+9UDBHcIYiJriytuNmAHnUy7mwot1srh3j
   Hmv4DaR5UYTL7aeZi+maG6PrItYH00RvLylMrtfDHkUqT6/uNOXmU/neJ
   LzfOwPclZcl+YCi+uNmdVqeskCftXASC/Msjz2wm/l6FrhJMjXYi3A6PJ
   Zh0ssrcR/+j0JwEzPGjAw52ac7UWCBbHfqC8Te/7kYSMLunkHEx2VbcdM
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307956"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307956"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570805"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:45 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 02/10] xsk: diversify return codes in xsk_rcv_check()
Date:   Tue,  5 Apr 2022 13:06:23 +0200
Message-Id: <20220405110631.404427-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inspired by patch that made xdp_do_redirect() return values for XSKMAP
more meaningful, return -ENXIO instead of -EINVAL for socket being
unbound in xsk_rcv_check() as this is the usual value that is returned
for such event. In turn, it is now possible to easily distinguish what
went wrong, which is a bit harder when for both cases checked, -EINVAL
was returned.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f75e121073e7..040c73345b7c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -217,7 +217,7 @@ static bool xsk_is_bound(struct xdp_sock *xs)
 static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	if (!xsk_is_bound(xs))
-		return -EINVAL;
+		return -ENXIO;
 
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
-- 
2.33.1

