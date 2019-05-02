Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8D11F18
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfEBPZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfEBPZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 11:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC2CE2081C;
        Thu,  2 May 2019 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810722;
        bh=u5BK6ImEGbM0YWKuKATM4tD/cWtn4clQb4UjM9HLQFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrFI1T1PHbi37HFqdl3kVLlwujQIoyY2aCDWg6tCuDAkBEN9szp28BVOoq297Hp/z
         +in1Noq/fyNeRYch/RtpI3yDs7kWsSaVtvCLwkF3IA0r1LZLZqIDcT3KA73f1yoj8w
         HKzDVOsj31Z7KruUYiJXOkG9ukLeWzfxXY2RcfWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 35/49] net: ethernet: ti: fix possible object reference leak
Date:   Thu,  2 May 2019 17:21:12 +0200
Message-Id: <20190502143328.292206371@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 75eac7b5f68b0a0671e795ac636457ee27cc11d8 ]

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/net/ethernet/ti/netcp_ethss.c:3661:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 3654, but without a corresponding object release within this function.
./drivers/net/ethernet/ti/netcp_ethss.c:3665:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 3654, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Wingman Kwok <w-kwok2@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 28cb38af1a34..ff7a71ca0b13 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3538,12 +3538,16 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 
 	ret = netcp_txpipe_init(&gbe_dev->tx_pipe, netcp_device,
 				gbe_dev->dma_chan_name, gbe_dev->tx_queue_id);
-	if (ret)
+	if (ret) {
+		of_node_put(interfaces);
 		return ret;
+	}
 
 	ret = netcp_txpipe_open(&gbe_dev->tx_pipe);
-	if (ret)
+	if (ret) {
+		of_node_put(interfaces);
 		return ret;
+	}
 
 	/* Create network interfaces */
 	INIT_LIST_HEAD(&gbe_dev->gbe_intf_head);
-- 
2.19.1



