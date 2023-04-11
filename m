Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5DF6DD653
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjDKJL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjDKJK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:10:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034933C2A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681204250; x=1712740250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UGzPkrCCdKAwn8inRum+3kkNx1UOeIU/xkT2TAn9pdw=;
  b=YcjVKOVKXGlpownAUkhhlW0HXzkaqkTwJbwyRgKbWFBKV//EjWHWyHVB
   Iq7cmMFuOB7HVMMu/scOfJW+2AzSwg4XlJlhRpV5JgNqzs6Ffp9TdoBnO
   J4AQmdpjAHVsVnaozvbMUvqPkCmOy+E/0LudngRiq7wSxfL0UeKiam7vs
   MlBt607P3IeO2hVtGDY5ga8f0MtUCEGFZt+Xdp751tXdElT1uDvOIGFHV
   td5gDaXvqFXQfabw36r5bL8npVup3KMQ4UzpZq7Ptlebj2BkSYQUAInFa
   QZhPqtrKFuUCNIwfnvheTA7X/uSg1OZv83rLzo3JAirv71ltCgcjbIVHq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="343568214"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="343568214"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 02:10:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="753066929"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753066929"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 02:10:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 4A1A787; Tue, 11 Apr 2023 12:10:49 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/3] net: thunderbolt: Fix sparse warnings in tbnet_check_frame() and tbnet_poll()
Date:   Tue, 11 Apr 2023 12:10:47 +0300
Message-Id: <20230411091049.12998-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
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

main.c:767:47: warning: restricted __le32 degrades to integer
main.c:775:47: warning: restricted __le16 degrades to integer
main.c:776:44: warning: restricted __le16 degrades to integer
main.c:876:40: warning: incorrect type in assignment (different base types)
main.c:876:40:    expected restricted __le32 [usertype] frame_size
main.c:876:40:    got unsigned int [assigned] [usertype] frame_size
main.c:877:41: warning: incorrect type in assignment (different base types)
main.c:877:41:    expected restricted __le32 [usertype] frame_count
main.c:877:41:    got unsigned int [usertype]
main.c:878:41: warning: incorrect type in assignment (different base types)
main.c:878:41:    expected restricted __le16 [usertype] frame_index
main.c:878:41:    got unsigned short [usertype]
main.c:879:38: warning: incorrect type in assignment (different base types)
main.c:879:38:    expected restricted __le16 [usertype] frame_id
main.c:879:38:    got unsigned short [usertype]
main.c:880:62: warning: restricted __le32 degrades to integer
main.c:880:35: warning: restricted __le16 degrades to integer

No functional changes intended.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/thunderbolt/main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 26ef3706445e..27f8573a2b6e 100644
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
-- 
2.39.2

