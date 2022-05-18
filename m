Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1052AF84
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiERA6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiERA6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:58:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617F753E27
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=iKPxo6nmawUzIoV5U9tlyCQp6Vw6AUpCRQ4Ur98rVDI=; b=SwCsPL1wVop+erLd9VYQlzxibL
        a0Z+7K0bAwgPvSdzxnQ01eIe9P+DXZpF2J5TXPYikAJUbL6Fpbc0EhUNot5Bn1S7l+pTTvYcPDCWV
        82QeSKh4tkh+Ez/UBuaNtrJY3MnbquXZuQxuzNYKz0E49xZJZt+dmrnFQ7bRhg4YqoGY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nr81X-003Ejs-Vl; Wed, 18 May 2022 02:58:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net] net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.
Date:   Wed, 18 May 2022 02:58:40 +0200
Message-Id: <20220518005840.771575-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to stack bridges on top of each other. Consider the
following which makes use of an Ethernet switch:

       br1
     /    \
    /      \
   /        \
 br0.11    wlan0
   |
   br0
 /  |  \
p1  p2  p3

br0 is offloaded to the switch. Above br0 is a vlan interface, for
vlan 11. This vlan interface is then a slave of br1. br1 also has a
wireless interface as a slave. This setup trunks wireless lan traffic
over the copper network inside a VLAN.

A frame received on p1 which is passed up to the bridge has the
skb->offload_fwd_mark flag set to true, indicating that the switch has
dealt with forwarding the frame out ports p2 and p3 as needed. This
flag instructs the software bridge it does not need to pass the frame
back down again. However, the flag is not getting reset when the frame
is passed upwards. As a result br1 sees the flag, wrongly interprets
it, and fails to forward the frame to wlan0.

When passing a frame upwards, clear the flag. This is the Rx
equivalent of br_switchdev_frame_unmark() in br_dev_xmit().

Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

v2:
Extended the commit message with Ido obsersation of the equivelance of
br_dev_xmit().

Fixed up the comment.

This code has passed Ido test setup.

net/bridge/br_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 196417859c4a..68b3e850bcb9 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -39,6 +39,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
 	dev_sw_netstats_rx_add(brdev, skb->len);
 
 	vg = br_vlan_group_rcu(br);
+
+	/* Reset the offload_fwd_mark because there could be a stacked
+	 * bridge above, and it should not think this bridge it doing
+	 * that bridge's work forwarding out its ports.
+	 */
+	br_switchdev_frame_unmark(skb);
+
 	/* Bridge is just like any other port.  Make sure the
 	 * packet is allowed except in promisc mode when someone
 	 * may be running packet capture.
-- 
2.36.0

