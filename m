Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57D75815AF
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbiGZOtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiGZOtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:49:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5407ADFD5;
        Tue, 26 Jul 2022 07:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658846950; x=1690382950;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zyxa8AaE+D9EWdSI2SVfiEoyB6sklDmOxEaanIlc9fU=;
  b=AwhewTZ6FY7OKl2NligZiYiA1Qcj9AAw2AJA4VCmslXLbVRvsJT2cFKC
   mYLsGFZzkxLCOdmJa0tj1qAZCm67Cra3h611kTIPBKVwP4MORd1CY1yC4
   CC1cB15ftMOs8xUVX8xeyWwokqmjbfEoodAlEJeRgSTb3F2VaykTjSCr9
   5G53kr0HxQpgr52ZqQ6cpden8L9Bu0i3fMSNh6YTDGlqWbO5+FTkf+v1v
   G5ANJk6+oOaZYXjAS6jR3IeVyHHNYs0914gjwpT/n6ucqVrRDBxsTKN+L
   FvcmGxpEnTpP/WHVycq199R4xKJtFc0jo+lm76yeyE0fPfpeOk6NJJpkn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="374272279"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="374272279"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 07:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="550429112"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 26 Jul 2022 07:49:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E2D3BF1; Tue, 26 Jul 2022 17:49:16 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v1 1/1] firewire: net: Make use of get_unaligned_be48(), put_unaligned_be48()
Date:   Tue, 26 Jul 2022 17:49:06 +0300
Message-Id: <20220726144906.5217-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we have a proper endianness converters for BE 48-bit data use
them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/firewire/net.c | 14 ++------------
 include/net/firewire.h |  3 +--
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index dcc141068128..af22be84034b 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -201,15 +201,6 @@ struct fwnet_packet_task {
 	u8 enqueued;
 };
 
-/*
- * Get fifo address embedded in hwaddr
- */
-static __u64 fwnet_hwaddr_fifo(union fwnet_hwaddr *ha)
-{
-	return (u64)get_unaligned_be16(&ha->uc.fifo_hi) << 32
-	       | get_unaligned_be32(&ha->uc.fifo_lo);
-}
-
 /*
  * saddr == NULL means use device source address.
  * daddr == NULL means leave destination address (eg unresolved arp).
@@ -1306,7 +1297,7 @@ static netdev_tx_t fwnet_tx(struct sk_buff *skb, struct net_device *net)
 		max_payload        = peer->max_payload;
 		datagram_label_ptr = &peer->datagram_label;
 
-		ptask->fifo_addr   = fwnet_hwaddr_fifo(ha);
+		ptask->fifo_addr   = get_unaligned_be48(ha->uc.fifo);
 		ptask->generation  = generation;
 		ptask->dest_node   = dest_node;
 		ptask->speed       = peer->speed;
@@ -1494,8 +1485,7 @@ static int fwnet_probe(struct fw_unit *unit,
 	ha.uc.uniq_id = cpu_to_be64(card->guid);
 	ha.uc.max_rec = dev->card->max_receive;
 	ha.uc.sspd = dev->card->link_speed;
-	ha.uc.fifo_hi = cpu_to_be16(dev->local_fifo >> 32);
-	ha.uc.fifo_lo = cpu_to_be32(dev->local_fifo & 0xffffffff);
+	put_unaligned_be48(dev->local_fifo, ha.uc.fifo);
 	dev_addr_set(net, ha.u);
 
 	memset(net->broadcast, -1, net->addr_len);
diff --git a/include/net/firewire.h b/include/net/firewire.h
index 2442d645e412..8fbff8d77865 100644
--- a/include/net/firewire.h
+++ b/include/net/firewire.h
@@ -13,8 +13,7 @@ union fwnet_hwaddr {
 		__be64 uniq_id;		/* EUI-64			*/
 		u8 max_rec;		/* max packet size		*/
 		u8 sspd;		/* max speed			*/
-		__be16 fifo_hi;		/* hi 16bits of FIFO addr	*/
-		__be32 fifo_lo;		/* lo 32bits of FIFO addr	*/
+		u8 fifo[6];		/* FIFO addr			*/
 	} __packed uc;
 };
 
-- 
2.35.1

