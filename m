Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862E73529D2
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhDBKgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 06:36:46 -0400
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:49486 "EHLO
        rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBKgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 06:36:45 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2021 06:36:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1756; q=dns/txt; s=iport;
  t=1617359804; x=1618569404;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oX4Xjs6xIax6QT5FPvQicGpoHmruqb/WYUjrcq49PqY=;
  b=KSbOM3gmp86bVCvDoSrIZ6UoFOFfEe73/OIIXTxR2cZAo91FYKW9BndO
   ObrkMdKxNjN1wmOxkPOZxk2NqfxAy71gqsBjMNt6YUO66O1txvLAfcZ6/
   I6+v/9rjEuxskrEG7j8V9xBg6rGYCdT5M7ZCrvuPCzyFWjDyYBsGYb9D6
   Q=;
X-IronPort-AV: E=Sophos;i="5.81,299,1610409600"; 
   d="scan'208";a="610497171"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 02 Apr 2021 10:29:39 +0000
Received: from sjc-ads-2883.cisco.com (sjc-ads-2883.cisco.com [171.70.33.62])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 132ATd1v019823
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 2 Apr 2021 10:29:39 GMT
Received: by sjc-ads-2883.cisco.com (Postfix, from userid 725528)
        id 25BD2CC1251; Fri,  2 Apr 2021 03:29:39 -0700 (PDT)
From:   Ivan Khoronzhuk <ikhoronz@cisco.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, hch@lst.de,
        Ivan Khoronzhuk <ikhoronz@cisco.com>
Subject: [PATCH net] net: octeon: mgmt: fix xmit hang as busy
Date:   Fri,  2 Apr 2021 10:29:22 +0000
Message-Id: <20210402102922.8495-1-ikhoronz@cisco.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 171.70.33.62, sjc-ads-2883.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue happens only at appropriate circumstances, in my case I
faced it only while running crash kernel, when basic kernel worked
fine. The code inspection has shown tx_current_fill counter overflow,
after one packet or couple packets were sent. That's because tx
cleanup tasklet dequeued bunch of not correct packets afterwards when
it should only one. As result xmit queue counter becomes more than
tx ring size and xmit always returns NETDEV_TX_BUSY. The reason is in
some trash got by dma after ringing the bell. The wmb() in correct
place solved the issue, so reason likely in removal of
mips_swiotlb_ops which had an mb() after most of the operations and
the removal of the ops had broken the tx functionality of the driver
implicitly.

The patch has been tested on Octeon II.

Fixes: a999933db9ed ("MIPS: remove mips_swiotlb_ops")
Change-Id: I947c359d9451c75a693bc4a3f2958489503fc0ab
Signed-off-by: Ivan Khoronzhuk <ikhoronz@cisco.com>
---
Based on net/master

 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index ecffebd513be..be1c353b961c 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1315,6 +1315,10 @@ octeon_mgmt_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	spin_unlock_irqrestore(&p->tx_list.lock, flags);
 
+	/* Make sure there is no reorder of filling the ring and ringing
+	 * the bell
+	 */
+	wmb();
 	dma_sync_single_for_device(p->dev, p->tx_ring_handle,
 				   ring_size_to_bytes(OCTEON_MGMT_TX_RING_SIZE),
 				   DMA_BIDIRECTIONAL);
-- 
2.18.2

