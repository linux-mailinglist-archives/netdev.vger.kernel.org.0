Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C309480C3C
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbhL1R7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 12:59:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:41226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236826AbhL1R7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 12:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640714344; x=1672250344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=56iBqMnFfuEGbxHOaBPfXUpYlm/LVQBqtojIADnKuV8=;
  b=D1HoI/T/X2Zz4ZapoXq6D27gzugCDgzk2dyriEwMfsQG314OJ1JJ0M/z
   bEna1QdlaO63H2Oync4gY5bnYNWXTVil9VJgFaPy+TyhzPDyl7bVURYi3
   MqoFPRWEQo2/vaSL5DHHaJEmpQGgH/q43hRKg3mJzy4YDxvud3noZgv4D
   BJ6SCa64Moa7nsmTAeCF9/6+4qRpCu7eULwJx/SfUHPPVmni2SYlN140j
   XFB90RC/8KwTkVtWCbzhEhhNjZnHGm3R0zCEKxYop0WqH3C0xyiz1O0VN
   gyNR/2wSFpT3oZgFGVJEqVN/5GORHjbmFmEY2fXdxgcQjwACvUhSX2ETO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="228705150"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="228705150"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 09:59:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="589072003"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 28 Dec 2021 09:59:03 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 4/9] iavf: switch to napi_build_skb()
Date:   Tue, 28 Dec 2021 09:58:10 -0800
Message-Id: <20211228175815.281449-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
References: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order
to save some cycles on freeing/allocating skbuff_heads on every
new Rx or completed Tx.
iavf driver runs Tx completion polling cycle right before the Rx
one and uses napi_consume_skb() to feed the cache with skbuff_heads
of completed entries, so it's never empty and always warm at that
moment. Switch to the napi_build_skb() to relax mm pressure on
heavy Rx.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index a0b1c18a3273..8cbe7ad1347c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1366,7 +1366,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 	net_prefetch(va);
 
 	/* build an skb around the page buffer */
-	skb = build_skb(va - IAVF_SKB_PAD, truesize);
+	skb = napi_build_skb(va - IAVF_SKB_PAD, truesize);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.31.1

