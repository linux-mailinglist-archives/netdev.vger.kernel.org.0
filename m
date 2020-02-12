Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9FC15B194
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgBLUG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 15:06:28 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46305 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgBLUG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 15:06:28 -0500
Received: by mail-pf1-f193.google.com with SMTP id k29so1748369pfp.13;
        Wed, 12 Feb 2020 12:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B5E+DB4+vknXt88petGEGI+dIA4MgxXGZFZRi0jSQkc=;
        b=aJiaddZTO7Hg7BNimGLLTGUBqNLBZOj0cNtWV/YmN+qhdYCfTQ52ZCVoKC7w0h23ny
         UqNGD3iJo7AysaIjnH4YPQdN0f62CG+i/yZCF1/Zs54Px4vvNZ3hUzZKQass1O0RX6Oh
         MQMFiux29AAgrp9Yacl0GLeEFXJ6uPDXkIUPLT3QxYzeqgOYLkF0yeNFeFWrCaMX0yyb
         alcUP7IfbwiAEyEAnnncoM4TosiULvfev5y6nzvF71Ux9da6yT9Pt2PrE5xtejcPxKAp
         K90piSZN1VlwX57Q3mOU7/AtYWsS29z5hMsZ8hfJVZxPkOskgfZx+r8Lj9a6sgkd6FyS
         d6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B5E+DB4+vknXt88petGEGI+dIA4MgxXGZFZRi0jSQkc=;
        b=f2zhLTwWOUhbQOpPYIv8xlQ444I+l7hJLHosnytsF9sqD78N+H6ZOfeaae76U5xJgi
         5Fn8TdPSaHQU+9CdJXC0u4W8+5VOc5FTnMlQcjnEErFWsaL1yYTRNf4t2ztm55BhA7wz
         jF/Fx+NhpGxg6j1F2yDtTM4sS9k9leT0wrioCenMKh12qDpYtY1p2cyj7UX08GfO7hZd
         faMyf9WxUHuy85nF0fPkRh1GAp85KlmWjDCxfXdEnCX6B9xRgvxhBRv1PQ5eN+FrKvi8
         Z0sxRdM0Xdgt2M9NpS2mJScFIChdxxYZm/Kh77hGYzV4sBIy3hD8QbfiqMjIVzRkIjSY
         at6w==
X-Gm-Message-State: APjAAAX9l8M7FuNRCMjw8Pj0n+g9n+pwl2EslPg0fAAcNxzp7mGu0BG9
        Ds9GtH9AptEF5sIN6aI7UXguDFNU
X-Google-Smtp-Source: APXvYqwdieK8nyzLx+4nfdeVsv0hkcfU+KuNygTwMkohZq4AersD7fPV0sqJtCIiuyJYlBAe34n1Cg==
X-Received: by 2002:a63:2a13:: with SMTP id q19mr13455341pgq.82.1581537987047;
        Wed, 12 Feb 2020 12:06:27 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x7sm77557pfp.93.2020.02.12.12.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 12:06:26 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, hkallweit1@gmail.com, michal.vokac@ysoft.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: Treat VLAN ID 0 as PVID untagged
Date:   Wed, 12 Feb 2020 12:05:55 -0800
Message-Id: <20200212200555.2393-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN ID 0 is special by all kinds and is really meant to be the default
ingress and egress untagged VLAN. We were not configuring it that way
and so we would be ingress untagged but egress tagged.

When our devices are interfaced with other link partners such as switch
devices, the results would be entirely equipment dependent. Some
switches are completely fine with accepting an egress tagged frame with
VLAN ID 0 and would send their responses untagged, so everything works,
but other devices are not so tolerant and would typically reject a VLAN
ID 0 tagged frame.

Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Hi all,

After looking at all DSA drivers and how they implement port_vlan_add()
I think this is the right change to do, but would appreciate if you
could test this on your respective platforms to ensure this is not
problematic.

Thank you


 net/dsa/slave.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 088c886e609e..d3a2782eb94d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1100,6 +1100,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct bridge_vlan_info info;
+	u16 flags = 0;
 	int ret;
 
 	/* Check for a possible bridge VLAN entry now since there is no
@@ -1118,7 +1119,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_add(dp, vid, 0);
+	/* VLAN ID 0 is special and should be the default egress and ingress
+	 * untagged VLAN, make sure it gets programmed as such.
+	 */
+	if (vid == 0)
+		flags = BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGGED;
+
+	ret = dsa_port_vid_add(dp, vid, flags);
 	if (ret)
 		return ret;
 
-- 
2.17.1

