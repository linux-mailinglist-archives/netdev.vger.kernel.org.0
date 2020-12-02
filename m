Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35C02CBD12
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLBMeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgLBMeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:34:36 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1362EC0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:33:50 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id f18so3424618ljg.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLizZ4UdUCyVcfP2HmrWjFnwcFxh8nxr6cVF2v4pr4U=;
        b=D3sDHiZnzEHBDFKUW6bO9d56LfBCoFAe5W1v71Tehnnjf6jS52tf+Qb0OoV1Ajfvsc
         iwREHxlJGfzh3ezdwnWNLRS+hUPXyH0vQyH+ukIQu4Ur3WHp1pn6NIoraM9zcD9SBuj8
         ykf8LjG0kpEc+TNoAIb5hDDkvQzBuUW7lyie2yyxqu2km4HQkO8TXDBdgkMPfasn4bcv
         PpyJIAqAC7m2v/sK5XfuDYDNRWXPOvQ/xGyNB7y1bvKH/B9ZpKspNTd8HVxNvu6/fAxq
         LqT0p9IqHLyulFYOUTvg+kPNWHsLrqQ3QRSxVSTSIcnldFhL9PLv/yvWoPHb0/BDKtFD
         lkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLizZ4UdUCyVcfP2HmrWjFnwcFxh8nxr6cVF2v4pr4U=;
        b=or3N9TpOuE7ima/+Fr49sem1ptAOFz1OR/b9ihixwC3vyfEWQgiEENkjrhs67aROal
         ZHsU6dPwdIyeoRO7w4xodCw5adInaL+cAEwTTra2Lm2uVKTBwC2v6o8OSDv3nh6uzYhY
         fYGDO+bTUvjkA3pmL8Pwsx8VurH6zHOYADVZ4jQ1BmMt3AzGojz75qkTCBodLYfSaHmk
         kT593hm6aOtB5ZrbBUIZP/ReUEC4H38uLyaQvRLbRguIXdablTnlucrEc7OPpwecl9In
         w+ZoIkrO8fSNpz2H2cQT69hsNHRw26aZ5v/1oSXJjLMfZcI9qp3K3rK/ZTMyDKv5Y4Xu
         JiDg==
X-Gm-Message-State: AOAM531ycNfyLhUSf55ODESMSVF+2iTTDyjQSM4SFzIdV2tF6RJ2kJt6
        Z8E8mc8kswH+ahWBSyIpxq5liAwktA6mrA==
X-Google-Smtp-Source: ABdhPJxaanSx6dq5qJsIXNfeAzNrKCk9kjCmC2y4smzebtoSSC625s2on1zm/fGqBjgpsz4CzZbq9Q==
X-Received: by 2002:a2e:3012:: with SMTP id w18mr1079470ljw.380.1606912428441;
        Wed, 02 Dec 2020 04:33:48 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id m7sm439230ljb.8.2020.12.02.04.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:33:47 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org, pablo@netfilter.org
Cc:     laforge@gnumonks.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 1/5] gtp: set initial MTU
Date:   Wed,  2 Dec 2020 13:33:41 +0100
Message-Id: <20201202123345.565657-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GTP link is brought up with a default MTU of zero.  This can lead to
some rather unexpected behaviour for users who are more accustomed to
interfaces coming online with reasonable defaults.

This patch sets an initial MTU for the GTP link of 1500 less worst-case
tunnel overhead.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..5a048f050a9c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -612,11 +612,16 @@ static const struct net_device_ops gtp_netdev_ops = {
 
 static void gtp_link_setup(struct net_device *dev)
 {
+	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
+					  sizeof(struct udphdr) +
+					  sizeof(struct gtp0_header);
+
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
+	dev->mtu = ETH_DATA_LEN - max_gtp_header_len;
 
 	/* Zero header length. */
 	dev->type = ARPHRD_NONE;
@@ -626,11 +631,7 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->features	|= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	/* Assume largest header, ie. GTPv0. */
-	dev->needed_headroom	= LL_MAX_HEADER +
-				  sizeof(struct iphdr) +
-				  sizeof(struct udphdr) +
-				  sizeof(struct gtp0_header);
+	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-- 
2.27.0

