Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9244FFA33
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiDMPc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDMPcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:32:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9907F377F9;
        Wed, 13 Apr 2022 08:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863834; x=1681399834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s2NRM68uI3Xf1aRNp8SErdefczkOuptyPRLP2SdbgSY=;
  b=E6O9HCPm0mQiaCw5obIhPcz3AMKwJG9eM1ZR93Bh2lCOTH1uPrGXAoP8
   XI5PzS/hLLSlCB5VwbLLP9eqCYVESx5qQUSyaG04olJjSxwnQofNHZXJc
   HSK0kdncU+rphfgHWZGR+01fUcDo+mPDRTP62x08hh5c8kNz87VGflHx/
   78/TYg6rAVoL+eoRg2brGkBIGUCouw1Cdky3jcVpK97bAeX1tC4HUWxWo
   zqQdWKPUflFj5DvbwF5RMM5dB+nnpZ/1IH4QIaiuy4/qawma40GzVjyRw
   T/XtpSk/H52FkYvORjAmh47NgxLFwPHBbO40HwBiotpN0vj1GXPHvxceB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544175"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544175"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318202"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:31 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v2 bpf-next 02/14] xsk: diversify return codes in xsk_rcv_check()
Date:   Wed, 13 Apr 2022 17:30:03 +0200
Message-Id: <20220413153015.453864-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
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

Return codes can be counted in a nice way via bpftrace oneliner that
Jesper has shown:

bpftrace -e 'tracepoint:xdp:xdp_redirect* {@err[-args->err] = count();}'

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
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

