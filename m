Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E38427EA9
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 06:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhJJEFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 00:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhJJEFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 00:05:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0A5C061766
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 21:03:46 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id np13so10554748pjb.4
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 21:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RTK044YznKzFHcCkxWKc1Ef3a2DvXF6Ivtyihwf1/Zc=;
        b=dCVU+luIy2Y+SeTO3OZwNwPgNvvl6Y7s73jVpJ3rimTLpO/JxzTpqXpvv8v0p045PN
         zclDlKBJ8BfIHFsBrzjB8JF1KqxXn/eQSm4B5HhInfL5j+vXnySi6dqOqlzVHDnWB7Vi
         xLOQNMI2xny5PPeJgp2d2fF1G94bHSj8qgyICsT6WFhfDxbhbJESFedmSaY3CUwZl4GM
         RMFyMu6yniMS5g2uh+0Hu6FkwYOU39ntmq0va83DnMZOHKmffywhB0FLp7Ed9WR4pPuQ
         4DbCD9NXalBmsGi4D7uCdFw+i8ICzQ1PT+HX2TBaKRxIVungPEr6Ymp0r63eNVzmnPm/
         MChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RTK044YznKzFHcCkxWKc1Ef3a2DvXF6Ivtyihwf1/Zc=;
        b=4aR7Ut0xkM228eR4XoqgE9gONkbbu6TH4U5NAbwt0HlPI3OmZn1UBKTT9irdBsGZ8P
         mg1NvzOLWRtgaFxobGfoBp/+SkZMxpO+Y3cn2jYnewYl9ydaWugQe7lqxtM6Pmihfxan
         468lav46yQn9asWx9wLGIazEnq4+OxmRznN22XGixZILlXGo6VS9LH2QkWQGk68MCrFL
         cgd2zgE/x1S9cxl3DUYRaBV5DOmo4K4QvK7IF4EvuXrcFv72+dBEner0BJ1VAsGDxmqP
         M+JVsMbmAVbeGBSvo6SiNg4TjBHP03EYFu0G13LUTlkIJph93cxV4thoHFk/6YdNGITZ
         dnlA==
X-Gm-Message-State: AOAM533OupiAMcSLyx/mt/ENVQlO9xabNMmM16q+YRSa+akZWqk3O1/k
        IEAI/p6AEgYO8+F18gxIuLA=
X-Google-Smtp-Source: ABdhPJwvlgbUh/HMId8C5ltTCBrzk2/P8+Nyb5QzT+9fUyoPLK9HoFF11803hMlxpvwtt8P3+6jvMg==
X-Received: by 2002:a17:902:7843:b0:13d:c728:69c9 with SMTP id e3-20020a170902784300b0013dc72869c9mr17526848pln.55.1633838626349;
        Sat, 09 Oct 2021 21:03:46 -0700 (PDT)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id m6sm3507763pff.189.2021.10.09.21.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 21:03:46 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     michael.chan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] mlxsw: spectrum: use netif_is_macsec() instead of open code
Date:   Sun, 10 Oct 2021 13:03:29 +0900
Message-Id: <20211010040329.1078-4-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211010040329.1078-1-claudiajkang@gmail.com>
References: <20211010040329.1078-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open code which is dev->priv_flags & IFF_MACSEC has already defined as
netif_is_macsec(). So use netif_is_macsec() instead of open code.
This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79163208dfd..9192544fe356 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5236,7 +5236,7 @@ static inline void netif_keep_dst(struct net_device *dev)
 static inline bool netif_reduces_vlan_mtu(struct net_device *dev)
 {
 	/* TODO: reserve and use an additional IFF bit, if we get more users */
-	return dev->priv_flags & IFF_MACSEC;
+	return netif_is_macsec(dev);
 }
 
 extern struct pernet_operations __net_initdata loopback_net_ops;
-- 
2.25.1

