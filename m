Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECDD4EF3BA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347932AbiDAOwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349834AbiDAOqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:46:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAF11EB82C;
        Fri,  1 Apr 2022 07:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 795DB60B8C;
        Fri,  1 Apr 2022 14:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49A2C34112;
        Fri,  1 Apr 2022 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823788;
        bh=66sFSy8wNULr2MfX4IcAY9QzAY5sLQeRa4oJ/F55KYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hc7kzNbV3s+ZLPb4DQ+GvWLrKyfRy+7QHil9m2skrIRv2hy3nNwhG0epiQtdQIxvN
         qfjEiWUpkP5bFjC+6pZmPLDCtXiVEK+8rpPTtUNXh0bcGh6V2oeDBrqOvNSBK4fyX6
         ur5XMNLPjmb2UE/JDRtMmEu3yZix4rnV4BfmUqY7AnFO2gnw9kKZNxOJegfJ6Bs/Fb
         yWuIx2+SLs+BYr3S6PRcT1IHOj0MQiVxlvotuocttew74RlVZF8bposgaqY7IFY2d/
         zPwD5zVUVKhkQ3qiPZkstQTOUy/JHiMnk22pFBIh1IuX+MfhEPxj7uHW7oRFkB9x74
         FKIc4CjmYOSfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Leonardo=20M=C3=B6rlein?= <freifunk@irrelefant.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 078/109] macvtap: advertise link netns via netlink
Date:   Fri,  1 Apr 2022 10:32:25 -0400
Message-Id: <20220401143256.1950537-78-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a02192151b7dbf855084c38dca380d77c7658353 ]

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
Link: https://lore.kernel.org/r/20220228003240.1337426-1-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.34.1

