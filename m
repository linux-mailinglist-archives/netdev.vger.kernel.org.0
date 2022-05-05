Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A792F51CC63
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 00:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384846AbiEEXDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386525AbiEEXDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:03:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CA85F26A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 15:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=FpzBqVWWDArtZuTKofltIIY/sswU/N9lGcHNVU+L2vo=; b=6EJkiI0YbtkKkB852OCGfp3/Ah
        8QSMwiQ27FSRexwFaTN1HjiUI/mHGtpoKirEdHYUrRys2byqN9JFpL2dZF/UJLRKzyXd1RP6ZwcD0
        MNSBtq0U/1eCJi7JDKWOAQXKCxN3Rx9SYMiKgpmGoXB4yGZ/2JwkniLnWUnslI3A//Mk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmkRd-001R5M-Mp; Fri, 06 May 2022 00:59:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.
Date:   Fri,  6 May 2022 00:59:04 +0200
Message-Id: <20220505225904.342388-1-andrew@lunn.ch>
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
vlan 11. This vlan interface is then a slave of br1. br1 also has
wireless interface as a slave. This setup trunks wireless lan traffic
over the copper network inside a VLAN.

A frame received on p1 which is passed up to the bridge has the
skb->offload_fwd_mark flag set to true, indicating it that the switch
has dealt with forwarding the frame out ports p2 and p3 as
needed. This flag instructs the software bridge it does not need to
pass the frame back down again. However, the flag is not getting reset
when the frame is passed upwards. As a result br1 sees the flag,
wrongly interprets it, and fails to forward the frame to wlan0.

When passing a frame upwards, clear the flag.

RFC because i don't know the bridge code well enough if this is the
correct place to do this, and if there are any side effects, could the
skb be a clone, etc.

Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/bridge/br_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 196417859c4a..9327a5fad1df 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -39,6 +39,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
 	dev_sw_netstats_rx_add(brdev, skb->len);
 
 	vg = br_vlan_group_rcu(br);
+
+	/* Reset the offload_fwd_mark because there could be a stacked
+	 * bridge above, and it should not think this bridge it doing
+	 * that bridges work forward out its ports.
+	 */
+	br_switchdev_frame_unmark(skb);
+
 	/* Bridge is just like any other port.  Make sure the
 	 * packet is allowed except in promisc mode when someone
 	 * may be running packet capture.
-- 
2.36.0

