Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE6420271
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhJCPxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 11:53:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230426AbhJCPxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 11:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=uXu2riDUwV7yTnOtHxpidVzihTTM0n5SLysZ2BIzaZI=; b=sC8D3ETj1uLIy7RWyGAvzcruC7
        ypHh1FzPdqXYoqB9a5HrihWOGTmnwISMJzzaLN7GTxTgG06Mi+w5h+ctdFpZiflQ+ztx4bHxjw75b
        ILLRcSHR24LIoKtcTbOXlca4WlgUAfPiTZEzOTes8PR8wB5PjOqu6M8xdz+H4WEZzufA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mX3mF-009P4z-IE; Sun, 03 Oct 2021 17:51:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] dsa: tag_dsa: Handle !CONFIG_BRIDGE_VLAN_FILTERING case
Date:   Sun,  3 Oct 2021 17:51:41 +0200
Message-Id: <20211003155141.2241314-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_BRIDGE_VLAN_FILTERING is disabled, br_vlan_enabled() is
replaced with a stub which returns -EINVAL. As a result the tagger
drops the frame. Rather than drop the frame, use a pvid of 0.

Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/tag_dsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e5127b7d1c6a..8daa8b7787c0 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -149,7 +149,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 * inject packets to hardware using the bridge's pvid, since
 		 * that's where the packets ingressed from.
 		 */
-		if (!br_vlan_enabled(br)) {
+		if (IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING) &&
+		    !br_vlan_enabled(br)) {
 			/* Safe because __dev_queue_xmit() runs under
 			 * rcu_read_lock_bh()
 			 */
-- 
2.33.0

