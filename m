Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F1613C53
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiJaRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiJaRkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:40:13 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D88113CD4;
        Mon, 31 Oct 2022 10:39:58 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id AB716C0007;
        Mon, 31 Oct 2022 17:39:55 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net-next] net: tun: bump the link speed from 10Mbps to 10Gbps
Date:   Mon, 31 Oct 2022 18:39:53 +0100
Message-Id: <20221031173953.614577-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10Mbps link speed was set in 2004 when the ethtool interface was
initially added to the tun driver.  It might have been a good
assumption 18 years ago, but CPUs and network stack came a long way
since then.

Other virtual ports typically report much higher speeds.  For example,
veth reports 10Gbps since its introduction in 2007.

Some userspace applications rely on the current link speed in
certain situations.  For example, Open vSwitch is using link speed
as an upper bound for QoS configuration if user didn't specify the
maximum rate.  Advertised 10Mbps doesn't match reality in a modern
world, so users have to always manually override the value with
something more sensible to avoid configuration issues, e.g. limiting
the traffic too much.  This also creates additional confusion among
users.

Bump the advertised speed to at least match the veth.

Alternative might be to explicitly report UNKNOWN and let the user
decide on a right value for them.  And it is indeed "the right way"
of fixing the problem.  However, that may cause issues with bonding
or with some userspace applications that may rely on speed value to
be reported (even though they should not).  Just changing the speed
value should be a safer option.

Users can still override the speed with ethtool, if necessary.

RFC discussion is linked below.

Link: https://lore.kernel.org/lkml/20221021114921.3705550-1-i.maximets@ovn.org/
Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-July/051958.html
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 27c6d235cbda..48bb4a166ad4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3514,7 +3514,7 @@ static void tun_default_link_ksettings(struct net_device *dev,
 {
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
-	cmd->base.speed		= SPEED_10;
+	cmd->base.speed		= SPEED_10000;
 	cmd->base.duplex	= DUPLEX_FULL;
 	cmd->base.port		= PORT_TP;
 	cmd->base.phy_address	= 0;
-- 
2.37.3

