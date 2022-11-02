Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822FC616EDF
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiKBUkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiKBUkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:40:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87EF5F55
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667421610; x=1698957610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VigHtcumZliwwaLdwgaXudJicyFuyZ21a7qhOyEdbh0=;
  b=L1U0lcLaFU33Edhy6eVctmuMjdJNaOuqW49scLIzUkVHr1oqR5qIwLLm
   6U/iGyUeZcw/HAYXvJTFddnZld5Kpj3X2FDomzHXwahSYXuooHbZ637SR
   TBfPQKUlwmjEwG2d4DdpIi6+1qQl/UGiMEZ6DnBZEoejxKOuorvP3lUPg
   vq6UJqAKjYQ/Fi8MQjJFntNsCBOKjSzSPdumuaTFsphrqpuw68pJMpzQT
   I4NpUA6L+Q1MauEFq5SaNJGC2vVnREs7oMjKEsuf0IQSlUTohehxx/+/H
   fvf5oA4p9Z5tBnlO1BoMPoe1B+hhyy+wtKa81cstwDpGOGJ18ahADocDY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="308234076"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="308234076"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 13:40:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="612385342"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="612385342"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2022 13:40:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next 5/6] e1000: Remove unnecessary use of kmap_atomic()
Date:   Wed,  2 Nov 2022 13:39:56 -0700
Message-Id: <20221102203957.2944396-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
References: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

buffer_info->rxbuf.page accessed in e1000_clean_jumbo_rx_irq() is
allocated using GFP_ATOMIC. Pages allocated with GFP_ATOMIC can't come from
highmem and so there's no need to kmap() them. Just use page_address().

I don't have access to a 32-bit system so did some limited testing on
qemu (qemu-system-i386 -m 4096 -smp 4 -device e1000e) with a 32-bit
Debian 11.04 image.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 61e60e4de600..da6e303ad99b 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4229,8 +4229,6 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 				 */
 				p = buffer_info->rxbuf.page;
 				if (length <= copybreak) {
-					u8 *vaddr;
-
 					if (likely(!(netdev->features & NETIF_F_RXFCS)))
 						length -= 4;
 					skb = e1000_alloc_rx_skb(adapter,
@@ -4238,10 +4236,9 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 					if (!skb)
 						break;
 
-					vaddr = kmap_atomic(p);
-					memcpy(skb_tail_pointer(skb), vaddr,
-					       length);
-					kunmap_atomic(vaddr);
+					memcpy(skb_tail_pointer(skb),
+					       page_address(p), length);
+
 					/* re-use the page, so don't erase
 					 * buffer_info->rxbuf.page
 					 */
-- 
2.35.1

