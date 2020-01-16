Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7013EF04
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395223AbgAPSMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:12:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39285 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405277AbgAPRhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:37:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so20028578wrt.6
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 09:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=V6HTyyyZXgDWP7nZx8wsX6kxnYZJ/8kBbhBhkTS/Kzg=;
        b=RFbygifpIcMTgbcNDvv0Oz8D2Jvfs+nndyDMJxkdnVDwbUNaMeI6oaU8HWQgDXanoF
         jabNs9uUfxUrlDreMOxJtd37/UNR/FbHEu27degc2YK/T0l05pW/J6NIZq3DZwGOufg+
         fDQ4jE5P89D7ei72GXa/yE5wQankfvbmZ990+kGK0w6oX6wEp2yFBsui1qXJjJXmiXpJ
         xLVtyZcVHGcvT5TtJdXHebn/g+vAHwMirS8Me8y/cgQ6GJ106OLi4vMCaVaFb81y2Nuj
         0RqRXLIy10xIlZRJlZuLOZh4vydmkTO9FGIzFJTv3eNwY1FvKygxfhswPYYf4qCY1HK9
         q/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V6HTyyyZXgDWP7nZx8wsX6kxnYZJ/8kBbhBhkTS/Kzg=;
        b=PWp9mgT37QPkwidk7+GtlSdW5mYkA0FsFzWLOY4DTQnbTiyLfWARzjyeAbTt3FdfHY
         y50ib+bMgNJlQ4q6ojtX7qV8OMqKg0fKdRqYMw9fOrZwc5GmkRWEJazWjfx2aBaf64rN
         PDXGivqWFgX9VUlGqHnYk0Va81LlBss1t03TRfEEwiRcJ77WkUl0FEVn/gmyXlVSsDEE
         80iUDE75SAFVC+1aW0cuXkPRQ/Ax+Hzgdf4QlugfqrdSMbP08taodEfsJ2XGpjZS52RP
         CLppfiNx26+AGaO4tVwrFYy4f6RKT7pHmwjD455teKYcBhL5iL4ROSv503bisWkkHkdI
         bcyQ==
X-Gm-Message-State: APjAAAWgNQ6vSylO1P7KGuRXdvk0obUv3LtfWpWYUOh+QtAYeZV6v+Xp
        PN6Rd9OQgCPlJb34EvBYQWY=
X-Google-Smtp-Source: APXvYqyUmjpTRDpZq+djruYc4LjjsclPt+BPmyQz68KMCJDeq1JGPNuLj8vIspts3BhclvPXafuI5Q==
X-Received: by 2002:a5d:670a:: with SMTP id o10mr4612073wru.227.1579196221982;
        Thu, 16 Jan 2020 09:37:01 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id m10sm30224255wrx.19.2020.01.16.09.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 09:37:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: phylink: Allow 2.5BASE-T, 5GBASE-T and 10GBASE-T for the 10G link modes
Date:   Thu, 16 Jan 2020 19:36:56 +0200
Message-Id: <20200116173656.14118-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For some reason, PHYLINK does not put the copper modes for 802.3bz
(NBASE-T) and 802.3an-2006 (10GBASE-T) in the PHY's supported mask, when
the PHY-MAC connection is a 10G-capable one (10GBase-KR, 10GBase-R,
USXGMII). One possible way through which the cable side can work at the
lower speed is by having the PHY emit PAUSE frames towards the MAC. So
fix that omission.

Also include the 2500Base-X fiber mode in this list while we're at it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Resent to include netdev@vger.kernel.org in Cc (missed the first time).

 drivers/net/phy/phylink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f40d92ec32f8..e5a0f9c75042 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -308,6 +308,10 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 1000baseT_Half);
 			phylink_set(pl->supported, 1000baseT_Full);
 			phylink_set(pl->supported, 1000baseX_Full);
+			phylink_set(pl->supported, 2500baseT_Full);
+			phylink_set(pl->supported, 2500baseX_Full);
+			phylink_set(pl->supported, 5000baseT_Full);
+			phylink_set(pl->supported, 10000baseT_Full);
 			phylink_set(pl->supported, 10000baseKR_Full);
 			phylink_set(pl->supported, 10000baseCR_Full);
 			phylink_set(pl->supported, 10000baseSR_Full);
-- 
2.17.1

