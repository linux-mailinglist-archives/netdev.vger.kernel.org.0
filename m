Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DEC607674
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJULtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJULtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:49:32 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592311E716;
        Fri, 21 Oct 2022 04:49:29 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id D57E71BF20E;
        Fri, 21 Oct 2022 11:49:26 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [RFE net-next] net: tun: 1000x speed up
Date:   Fri, 21 Oct 2022 13:49:21 +0200
Message-Id: <20221021114921.3705550-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Bump the advertised speed to at least match the veth.  10Gbps also
seems like a more or less fair assumption these days, even though
CPUs can do more.  Alternative might be to explicitly report UNKNOWN
and let the application/user decide on a right value for them.

Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-July/051958.html
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---

Sorry for the clickbait subject line.  Can change it to something more
sensible while posting non-RFE patch.  Something like:

  'net: tun: bump the link speed from 10Mbps to 10Gbps'

This patch is RFE just to start a conversation.

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

