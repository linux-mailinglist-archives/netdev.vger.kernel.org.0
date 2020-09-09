Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740C5262CD1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgIIKEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIKEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:04:37 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B98C061756
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 03:04:37 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so2252654wrm.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 03:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGeU/vJL/f5HgWZfciM0jx6EU8z61LOkoh55rEs730Y=;
        b=pzRtUs8dWCx81NUeyb7kC2n1uGn/AwO0KBl3W+XCiucnIgQ/NNHmBeXyQIgNhnrYmJ
         ZkbjD0NuvbSSsIB18vRzBJ90O25PWv9SPlOwuT8smcdpvwmL9NvaZiCx7Hb/t6B8yZuv
         H45QNweUvdkz1BGDa4yt+0TUcyIknszbK8//M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGeU/vJL/f5HgWZfciM0jx6EU8z61LOkoh55rEs730Y=;
        b=hs0pC+Pcic+O/Xf1/P0Arp7sIoL7Q3D/L69wWIdUViClytwkiyYRCfFkKY3oUDFcuj
         VpY/gmxuzkisNTCqjZ7rpb3scXfk6zB96sfVcl71zpKkfcZPry15+dFXeRmqL0ULYAcn
         sF3/pbXRKW4n6MGu7qdZolAfufnB0F7Q5pQ1GnRHWQw88nfYlUhfHeqKQWY/60az3Wht
         sHfD7DsE3odpcQI1lcKNh+8vBhZ4rc3mSrrkvo2wxFQNdnAPFeYiJdvHG9Thf6OUSeJ1
         NWS1CgQbav4/dvIT1W1gtBx8OJDaXZl6PBl7FuuGivUoZTGCtBwi6Ate+WP/OPYSztjU
         32sw==
X-Gm-Message-State: AOAM5309eezwlBSQALTUodRhEoYvg579caCC1eUGXIX1G7nPHBqGcgkJ
        PftFdWmcX/npU7WAiXHwC0+/tw==
X-Google-Smtp-Source: ABdhPJwV7e5Tu7XexdXj8FFpbwPXswSxL1UrIH6lpUoRdjTUZJmw4zY4SXwosMwlHgq4mzWirnX2yw==
X-Received: by 2002:a05:6000:1ce:: with SMTP id t14mr2861161wrx.195.1599645875961;
        Wed, 09 Sep 2020 03:04:35 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id l16sm3828237wrb.70.2020.09.09.03.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:04:35 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v3 3/4] net: dsa: microchip: Disable RGMII in-band status on KSZ9893
Date:   Wed,  9 Sep 2020 11:04:16 +0100
Message-Id: <20200909100417.380011-4-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909100417.380011-1-pbarker@konsulko.com>
References: <20200909100417.380011-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't assume that the link partner supports the in-band status
reporting which is enabled by default on the KSZ9893 when using RGMII
for the upstream port.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index d9030820f406..b62dd64470a8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1235,6 +1235,9 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 			    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 				data8 |= PORT_RGMII_ID_EG_ENABLE;
+			/* On KSZ9893, disable RGMII in-band status support */
+			if (dev->features & IS_9893)
+				data8 &= ~PORT_MII_MAC_MODE;
 			p->phydev.speed = SPEED_1000;
 			break;
 		}
-- 
2.28.0

