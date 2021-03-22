Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646EF3435F3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 01:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCVA0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 20:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVA0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 20:26:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25359C061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 17:26:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x21so17264422eds.4
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 17:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdLVcIBXx0ShCvSRbe9mCmmJlII/2Cv9N1vwDZYXYCY=;
        b=c1FM6rmsCqFy2yiHWr30xdXUlEAXu0P6STL2vj1sHbydZc3/TEBRZT0gbFySFGxKHy
         sUx70fkiLCOTOX4JgIAmvDNwMlYQLGzkKBzCn307v+r+Hb6lJFy+rWUu9E3XEW7mHGzt
         OZBV4N9IoHhDz9Fs2PrplxRy1a4a34ZbeL3C1z8kQ8wHI4PnjQtvWoVooBasWIotgqv1
         RSYUHRcaGB1Q/EffVCDu7rwdNGrWe23kqqIsd9D/7jCZjlJjDGgh/bYYyqMUdRNwwkk6
         JNHKdGt6PM390v9HUIG5Gp3zNeY0cvK6GnRA6Xxg8YWTuqyuQCZraI8YeyO9RMDDHZmD
         8Urg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdLVcIBXx0ShCvSRbe9mCmmJlII/2Cv9N1vwDZYXYCY=;
        b=R5AcNGQo4aNYAswvEXqQjSR0U8ytRY7Y8LoOEITbVqEIJEBxplJBF9CgH3Fqc94vQn
         lCHkv7EVzHTNlVZQNOFfPtecUGVluTj4zsdD6C7TFv7zoScKO/kb4mrow4DGBKXh0PLW
         yb2/dAv3CnC+vx1vJaHrESMjFZwRXhKlgcTaS8PGDBpBKK+ncArK+XTaiLCZC6qTq75P
         ZT6cFd2aNTRREMb0TtQTXPewcpnzTwMgFEwrFe5TUTbMhxyuy4sE9pJ6Lkc32eWDnQiX
         c82iqQjxuyTOEIhHwMG5vdBzlQNQHGx54KKcHqH+JjlJKjlXRSTvNW7M4XFm+bMsOOKH
         CSBQ==
X-Gm-Message-State: AOAM532IzQRSZxsEG/6VKdDC5j8udi93oDuR/ghjhX9VpRRnaoQx0maQ
        A+QypGVo0WJVSgd6EfAXhE4=
X-Google-Smtp-Source: ABdhPJyW2jwUXryGCNbEBN2fkQQ8tuXCwsVL0yccD7eozPY704X5+sO3mVY9TqPx80TnwyUr6Wzbng==
X-Received: by 2002:a05:6402:3047:: with SMTP id bu7mr22886609edb.227.1616372807672;
        Sun, 21 Mar 2021 17:26:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id c12sm6000882edx.54.2021.03.21.17.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 17:26:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: ipconfig: ic_dev can be NULL in ic_close_devs
Date:   Mon, 22 Mar 2021 02:26:37 +0200
Message-Id: <20210322002637.3412657-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ic_close_dev contains a generalization of the logic to not close a
network interface if it's the host port for a DSA switch. This logic is
disguised behind an iteration through the lowers of ic_dev in
ic_close_dev.

When no interface for ipconfig can be found, ic_dev is NULL, and
ic_close_dev:
- dereferences a NULL pointer when assigning selected_dev
- would attempt to search through the lower interfaces of a NULL
  net_device pointer

So we should protect against that case.

The "lower_dev" iterator variable was shortened to "lower" in order to
keep the 80 character limit.

Fixes: f68cbaed67cb ("net: ipconfig: avoid use-after-free in ic_close_devs")
Fixes: 46acf7bdbc72 ("Revert "net: ipv4: handle DSA enabled master network devices"")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ipv4/ipconfig.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 47db1bfdaaa0..bc2f6ca97152 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -309,7 +309,7 @@ static int __init ic_open_devs(void)
  */
 static void __init ic_close_devs(void)
 {
-	struct net_device *selected_dev = ic_dev->dev;
+	struct net_device *selected_dev = ic_dev ? ic_dev->dev : NULL;
 	struct ic_device *d, *next;
 	struct net_device *dev;
 
@@ -317,16 +317,18 @@ static void __init ic_close_devs(void)
 	next = ic_first_dev;
 	while ((d = next)) {
 		bool bring_down = (d != ic_dev);
-		struct net_device *lower_dev;
+		struct net_device *lower;
 		struct list_head *iter;
 
 		next = d->next;
 		dev = d->dev;
 
-		netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
-			if (dev == lower_dev) {
-				bring_down = false;
-				break;
+		if (selected_dev) {
+			netdev_for_each_lower_dev(selected_dev, lower, iter) {
+				if (dev == lower) {
+					bring_down = false;
+					break;
+				}
 			}
 		}
 		if (bring_down) {
-- 
2.25.1

