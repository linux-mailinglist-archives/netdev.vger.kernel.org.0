Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B133B141772
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 13:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgARMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 07:19:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46924 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgARMTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 07:19:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so25070846wrl.13
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 04:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hz/8dXPws7d5iMdrw8SGJ61WlzMyk+Wl6aF2DDx5EdI=;
        b=fTChtD7N0XlKRLoHx7KJr9gWUDmVveI6mrEkQli8XXjJk3uw8IyaFhDpJrt0AjVJeN
         JX32+E1h9CX0wmM22XwYpACSUnq2VA7VxnZH2BWdifY46CxrNBxA6Co7bW5CK6FStM4j
         PsStKB3cH+LLWqZRcNekTvRZ1wu0Zvmco+aNNibzf5yd1f/a4jAozGtS6rCuCPNQfRH8
         +Xbn+qPV3F7jBxm+hP4kMqD9Z/YTReq12hx1jK2bSBo/fxWQ+hDipLROAi73pX2pen6w
         zniphWgygcydCsEKINmBifV54UILnfQebu6z0mG8CI4Rirpph9O99XfteN92ZBgGImf4
         qQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hz/8dXPws7d5iMdrw8SGJ61WlzMyk+Wl6aF2DDx5EdI=;
        b=DBIUdbRl7NBzH03nmLdBmRFEYASudL2ook4zgg59kaZFsj6O7gmwpt9lCOyWZ/qjKK
         JsU92BExGuc/KL77c0usUiyT6gRMq8i4zmvntVas/HlD7hjYcGg4/6WdX4Jc08laEwrd
         KbIytOz+6YxEs6AyuAOQxoUCsqj1AfSXuEpleUI+/JK5OoecNcI7WQabTTSlL3uO9XaO
         wP/sM1HKpLALeEZnLWufiQs9asyEpkO2qi3pU3CSsJHrbSAmQ4KZKZSU2tVtCIXRHNd7
         +4VLRtB3Uz6DbqKOhc2XZS6XNjLMtaHcW4hYFp9xzAiM5XXAzNRorIK3D3EmYxmW1U2L
         zcxQ==
X-Gm-Message-State: APjAAAVVIHLEnqMZfo2CV2SJ2xJM+MTOowTQ6U7wGznU2Y5Y71WQ2dfk
        ZsXbyvvgPKoozgSVjGajnieV1E7D
X-Google-Smtp-Source: APXvYqxKT1xFpKdQNtQINSoovrRCDSZJarpMJdkyezptiPzekCk0WgKSbE+nATSmsyquLBSGgHUIwg==
X-Received: by 2002:a5d:4749:: with SMTP id o9mr8092319wrs.242.1579349957075;
        Sat, 18 Jan 2020 04:19:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e6sm40100238wru.44.2020.01.18.04.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 04:19:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, linux@armlinux.org.uk,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Alex Marginean <alexandru.marginean@nxp.com>
Subject: [PATCH v2 net-next] net: phylink: allow in-band AN for USXGMII
Date:   Sat, 18 Jan 2020 14:19:15 +0200
Message-Id: <20200118121915.7762-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

USXGMII supports passing link information in-band between PHY and MAC PCS,
add it to the list of protocols that support in-band AN mode.

Being a MAC-PHY protocol that can auto-negotiate link speeds up to 10
Gbps, we populate the initial supported mask with the entire spectrum of
link modes up to 10G that PHYLINK supports, and we let the driver reduce
that mask in its .phylink_validate method.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- copied netdev list
- Reordered USXGMII with 10GKR

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index efabbfa4a6d3..40da85c70eba 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -298,6 +298,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 2500baseX_Full);
 			break;
 
+		case PHY_INTERFACE_MODE_USXGMII:
 		case PHY_INTERFACE_MODE_10GKR:
 		case PHY_INTERFACE_MODE_10GBASER:
 			phylink_set(pl->supported, 10baseT_Half);
-- 
2.17.1

