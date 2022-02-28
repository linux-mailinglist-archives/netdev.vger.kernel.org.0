Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B974C6025
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 01:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiB1Aj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 19:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiB1Aj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 19:39:59 -0500
X-Greylist: delayed 391 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Feb 2022 16:39:21 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174573DA7B
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 16:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1646008366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2u6QEikKYhXFUY/8m+SwcUz0+YbjoU38CtX/reujbNA=;
        b=lHBOS/j+zeHyzZimR7VPIfAZWBT25WnM6o4MnBXQQq6Hj3UbDkp6f19A9Efww05c/NqCPy
        R/IcFEG+imeGwm3JCIBxV1MkhDqfNLi7NEn0Urk3equAebJfW7FwK+lb+Ibvg7PtxqaCsj
        h67nwvnBWlCD1c1nTWlV64q45+vbN9E=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Leonardo=20M=C3=B6rlein?= <freifunk@irrelefant.net>
Subject: [PATCH] macvtap: advertise link netns via netlink
Date:   Mon, 28 Feb 2022 01:32:40 +0100
Message-Id: <20220228003240.1337426-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign rtnl_link_ops->get_link_net() callback so that IFLA_LINK_NETNSID is
added to rtnetlink messages. This fixes iproute2 which otherwise resolved
the link interface to an interface in the wrong namespace.

Test commands:

  ip netns add nst
  ip link add dummy0 type dummy
  ip link add link macvtap0 link dummy0 type macvtap
  ip link set macvtap0 netns nst
  ip -netns nst link show macvtap0

Before:

  10: macvtap0@gre0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 500
      link/ether 5e:8f:ae:1d:60:50 brd ff:ff:ff:ff:ff:ff

After:

  10: macvtap0@if2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 500
      link/ether 5e:8f:ae:1d:60:50 brd ff:ff:ff:ff:ff:ff link-netnsid 0

Reported-by: Leonardo Mörlein <freifunk@irrelefant.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/macvtap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 6b12902a803f..cecf8c63096c 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -133,11 +133,17 @@ static void macvtap_setup(struct net_device *dev)
 	dev->tx_queue_len = TUN_READQ_SIZE;
 }
 
+static struct net *macvtap_link_net(const struct net_device *dev)
+{
+	return dev_net(macvlan_dev_real_dev(dev));
+}
+
 static struct rtnl_link_ops macvtap_link_ops __read_mostly = {
 	.kind		= "macvtap",
 	.setup		= macvtap_setup,
 	.newlink	= macvtap_newlink,
 	.dellink	= macvtap_dellink,
+	.get_link_net	= macvtap_link_net,
 	.priv_size      = sizeof(struct macvtap_dev),
 };
 
-- 
2.30.2

