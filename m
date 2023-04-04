Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEF66D580C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 07:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbjDDFgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 01:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjDDFgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 01:36:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB72019BD
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680586599; x=1712122599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IcggdPKUPIsCGF6iqUTJpuPMOfnElR9IlWqVOAvqu1s=;
  b=JWP6Y5vMqGISJdOwfy3fkxxlPgkMzQzPORP+1IHTH4eS2wNTFO/evajP
   Elt5sfiAbCcAPLmtZnXywp5T1WCGRG1rAH1Cyud5qdnNYyisLgnSkgj8+
   +dqO5XxrnbixkHRSuPUk1xOSG8Mk6j8zuILMQR5qyASHh5SZuVqgLiaKN
   NuhU4LR3mJIf0HZZWm5NLiiqSiVtENHuXySSs9DQ+J32Es2gZRi7wlzBv
   lW0XDcjdxpAAX+Memfmsq+KDkTyO/MfeqHMtd4GCn5Sx/7xvYDBOFqxhp
   lkgY++WYUM5fscs9I/wyKV9w9BAJbg/m8Ubh6naS24JoYrKD84+SS6Sa+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="340826310"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="340826310"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 22:36:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688760548"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="688760548"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2023 22:36:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 026C694; Tue,  4 Apr 2023 08:36:36 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] net: thunderbolt: Fix sparse warnings
Date:   Tue,  4 Apr 2023 08:36:35 +0300
Message-Id: <20230404053636.51597-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following warnings when the driver is built with sparse
checks enabled:

drivers/net/thunderbolt/main.c:767:47: warning: restricted __le32 degrades to integer
drivers/net/thunderbolt/main.c:775:47: warning: restricted __le16 degrades to integer
drivers/net/thunderbolt/main.c:776:44: warning: restricted __le16 degrades to integer
drivers/net/thunderbolt/main.c:876:40: warning: incorrect type in assignment (different base types)
drivers/net/thunderbolt/main.c:876:40:    expected restricted __le32 [usertype] frame_size
drivers/net/thunderbolt/main.c:876:40:    got unsigned int [assigned] [usertype] frame_size
drivers/net/thunderbolt/main.c:877:41: warning: incorrect type in assignment (different base types)
drivers/net/thunderbolt/main.c:877:41:    expected restricted __le32 [usertype] frame_count
drivers/net/thunderbolt/main.c:877:41:    got unsigned int [usertype]
drivers/net/thunderbolt/main.c:878:41: warning: incorrect type in assignment (different base types)
drivers/net/thunderbolt/main.c:878:41:    expected restricted __le16 [usertype] frame_index
drivers/net/thunderbolt/main.c:878:41:    got unsigned short [usertype]
drivers/net/thunderbolt/main.c:879:38: warning: incorrect type in assignment (different base types)
drivers/net/thunderbolt/main.c:879:38:    expected restricted __le16 [usertype] frame_id
drivers/net/thunderbolt/main.c:879:38:    got unsigned short [usertype]
drivers/net/thunderbolt/main.c:880:62: warning: restricted __le32 degrades to integer
drivers/net/thunderbolt/main.c:880:35: warning: restricted __le16 degrades to integer
drivers/net/thunderbolt/main.c:993:23: warning: incorrect type in initializer (different base types)
drivers/net/thunderbolt/main.c:993:23:    expected restricted __wsum [usertype] wsum
drivers/net/thunderbolt/main.c:993:23:    got restricted __be32 [usertype]

No functional changes intended.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt/main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 26ef3706445e..6a43ced74881 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -764,7 +764,7 @@ static bool tbnet_check_frame(struct tbnet *net, const struct tbnet_frame *tf,
 	 */
 	if (net->skb && net->rx_hdr.frame_count) {
 		/* Check the frame count fits the count field */
-		if (frame_count != net->rx_hdr.frame_count) {
+		if (frame_count != le32_to_cpu(net->rx_hdr.frame_count)) {
 			net->stats.rx_length_errors++;
 			return false;
 		}
@@ -772,8 +772,8 @@ static bool tbnet_check_frame(struct tbnet *net, const struct tbnet_frame *tf,
 		/* Check the frame identifiers are incremented correctly,
 		 * and id is matching.
 		 */
-		if (frame_index != net->rx_hdr.frame_index + 1 ||
-		    frame_id != net->rx_hdr.frame_id) {
+		if (frame_index != le16_to_cpu(net->rx_hdr.frame_index) + 1 ||
+		    frame_id != le16_to_cpu(net->rx_hdr.frame_id)) {
 			net->stats.rx_missed_errors++;
 			return false;
 		}
@@ -873,11 +873,12 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 					TBNET_RX_PAGE_SIZE - hdr_size);
 		}
 
-		net->rx_hdr.frame_size = frame_size;
-		net->rx_hdr.frame_count = le32_to_cpu(hdr->frame_count);
-		net->rx_hdr.frame_index = le16_to_cpu(hdr->frame_index);
-		net->rx_hdr.frame_id = le16_to_cpu(hdr->frame_id);
-		last = net->rx_hdr.frame_index == net->rx_hdr.frame_count - 1;
+		net->rx_hdr.frame_size = hdr->frame_size;
+		net->rx_hdr.frame_count = hdr->frame_count;
+		net->rx_hdr.frame_index = hdr->frame_index;
+		net->rx_hdr.frame_id = hdr->frame_id;
+		last = le16_to_cpu(net->rx_hdr.frame_index) ==
+		       le32_to_cpu(net->rx_hdr.frame_count) - 1;
 
 		rx_packets++;
 		net->stats.rx_bytes += frame_size;
@@ -990,8 +991,10 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
 {
 	struct thunderbolt_ip_frame_header *hdr = page_address(frames[0]->page);
 	struct device *dma_dev = tb_ring_dma_device(net->tx_ring.ring);
-	__wsum wsum = htonl(skb->len - skb_transport_offset(skb));
 	unsigned int i, len, offset = skb_transport_offset(skb);
+	/* Remove payload length from checksum */
+	u32 paylen = skb->len - skb_transport_offset(skb);
+	__wsum wsum = (__force __wsum)htonl(paylen);
 	__be16 protocol = skb->protocol;
 	void *data = skb->data;
 	void *dest = hdr + 1;
-- 
2.39.2

