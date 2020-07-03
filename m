Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A74213436
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGCGcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCGcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 02:32:17 -0400
X-Greylist: delayed 581 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jul 2020 23:32:17 PDT
Received: from vps3.drown.org (vps3.drown.org [IPv6:2600:3c00::f03c:91ff:fedf:5654])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF0CC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 23:32:17 -0700 (PDT)
X-Envelope-From: dan-netdev@drown.org
Received: from vps3.drown.org (localhost [IPv6:::1])
        (Authenticated sender: dan@drown.org)
        by vps3.drown.org (Postfix) with ESMTPSA id 9994E2FC4F3
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 01:22:35 -0500 (CDT)
Date:   Fri, 3 Jul 2020 01:22:34 -0500
From:   Daniel Drown <dan-netdev@drown.org>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] net/xen-netfront: add kernel TX timestamps
Message-ID: <20200703062234.GA31682@vps3.drown.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds kernel TX timestamps to the xen-netfront driver.  Tested with chrony
on an AWS EC2 instance.

Signed-off-by: Daniel Drown <dan-netdev@drown.org>
---
 drivers/net/xen-netfront.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 860a0cce346d..ed995df19247 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -754,6 +754,9 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	/* First request has the packet length. */
 	first_tx->size = skb->len;
 
+	/* timestamp packet in software */
+	skb_tx_timestamp(skb);
+
 	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
 	if (notify)
 		notify_remote_via_irq(queue->tx_irq);
@@ -2411,6 +2414,7 @@ static const struct ethtool_ops xennet_ethtool_ops =
 	.get_sset_count = xennet_get_sset_count,
 	.get_ethtool_stats = xennet_get_ethtool_stats,
 	.get_strings = xennet_get_strings,
+	.get_ts_info = ethtool_op_get_ts_info,
 };
 
 #ifdef CONFIG_SYSFS
-- 
2.21.3

