Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A89C480C3A
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 18:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhL1R7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 12:59:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:41229 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhL1R7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 12:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640714344; x=1672250344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YK2NPgWUUXAmUYCO3ChcqFpTX8iRsAEMMmkSR0Tt0Ms=;
  b=AsEsejGDHvRIbym2R9xURnaui+Ssu1XNU+5/0iwCOIVvem+n7UYpj6Ps
   jeqPmf8qgfHBp2YKZ/AaYUZoG+AiUacrf6Ao65wQEtjDvb3CqNyOg9FNr
   hSRSh/MjRl0hiW4ZObpA0qTtTcVztFlZDLdCu1eAU/eD8aOdkroJbm/aF
   jJzyK3r70bQgzT5ALnG1TDuD6Un8wE2BVq0wU//7INo0ZJCZqvcz/jbxR
   42sGgrsYWx1E3kbyjFBSglxXIhQ7bQ2AA7dRo8fvJm0HgSsf0M96/8Rk5
   OBmSheuYgcdG3GTDZqEmMVOYU1RZm4QLWyH4ugXIgarJXsq5yh9eamvaJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="228705146"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="228705146"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 09:59:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="589071993"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 28 Dec 2021 09:59:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 2/9] e1000: switch to napi_build_skb()
Date:   Tue, 28 Dec 2021 09:58:08 -0800
Message-Id: <20211228175815.281449-3-anthony.l.nguyen@intel.com>
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
new Rx or completed Tx element.
e1000 driver runs Tx completion polling cycle right before the Rx
one. Now that e1000 uses napi_consume_skb() to put skbuff_heads of
completed entries into the cache, it will never empty and always
warm at that moment. Switch to the napi_build_skb() to relax mm
pressure on heavy Rx and increase throughput.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 975a145d48ef..3f5feb55cfba 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4384,7 +4384,7 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 		if (!skb) {
 			unsigned int frag_len = e1000_frag_len(adapter);
 
-			skb = build_skb(data - E1000_HEADROOM, frag_len);
+			skb = napi_build_skb(data - E1000_HEADROOM, frag_len);
 			if (!skb) {
 				adapter->alloc_rx_buff_failed++;
 				break;
-- 
2.31.1

