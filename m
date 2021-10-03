Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA8F42026F
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 17:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhJCPwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 11:52:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230426AbhJCPww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 11:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=dmK1FUbaXAr6g43SCZN2tvUZWQMtcgPGMFkjZylNkqc=; b=R8Vk+btzI9zVOf2HZ8Orb0m2G9
        qu2+e1p39cxmfXqCX/0tIyGCt+ruN/JwpGblIqCbBGsla+eUh+bVQXuB2wwkaX9HXgYEyDX4r3nL7
        nxcy94x/Ri4+r0NkVsAQXD7O9aUsqzp8pRKJcrj1ttK5s87Wa95fRtMEsthKW6dISqwc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mX3lX-009P3N-02; Sun, 03 Oct 2021 17:51:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] dsa: tag_dsa: Fix mask for trunked packets
Date:   Sun,  3 Oct 2021 17:50:53 +0200
Message-Id: <20211003155053.2241209-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A packet received on a trunk will have bit 2 set in Forward DSA tagged
frame. Bit 1 can be either 0 or 1 and is otherwise undefined and bit 0
indicates the frame CFI. Masking with 7 thus results in frames as
being identified as being from a trunk when in fact they are not. Fix
the mask to just look at bit 2.

Fixes: 5b60dadb71db ("net: dsa: tag_dsa: Support reception of packets from LAG devices")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/tag_dsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 77d0ce89ab77..e5127b7d1c6a 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -210,7 +210,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	cmd = dsa_header[0] >> 6;
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
-		trunk = !!(dsa_header[1] & 7);
+		trunk = !!(dsa_header[1] & 4);
 		break;
 
 	case DSA_CMD_TO_CPU:
-- 
2.33.0

