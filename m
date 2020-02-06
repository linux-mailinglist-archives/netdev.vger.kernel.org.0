Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CAE154BA3
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgBFTH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:07:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44502 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBFTH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:07:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so8503600wrx.11;
        Thu, 06 Feb 2020 11:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PoWolEQlO36yCFoBh6RNDlkIfLs5bAGA5n8VNBI0TGw=;
        b=ooSEc0/5Vy1Qws7kNcQ8ykf9IDS4AJyuHD98jJjfnnwBJy/hwAVNjIaUdLYEv0rMmR
         dk2aXgj/pf7246xFAr50Ca6vm4yw3NLtCKxJMRkDgMpAm4SC6wBOE48/meAO/RccWHvH
         WmlS55/YchK65M+OuN/gZ5xFPtzTQ1zLfWwShThEfrsayMAg8pI8x+IS6LLkD5frkJ/R
         SOb6+sxj1L7FIa/dq9Q2FHnbTDn88KxatM5OU0vloM//rWUTtpTeXGTKcjW2pYfy+Md2
         graRhxwW0gemUbsgU8wRPYEXNnEpDKODBWCmCR3WaMRLWA0IA858lZ/tokrLbmQZsrcf
         Xw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PoWolEQlO36yCFoBh6RNDlkIfLs5bAGA5n8VNBI0TGw=;
        b=SvlQ5S7kB2r39WkYS1PkWoNzOXUGyNQGLEy256kSLAXU0Y9NHJSCfrB0KJ+rY962wN
         MxmlYbQptFdT++ePi4ofArSD/PnDpvhJGFRhXCQ3TUAVe7vD6byS038ql3jvhCYy5HOS
         9FLKkoEKzZJPBkAt9I31slk9Oo0kxD/A68eG0oN3TC9PZcmHawC3X/2hsfK9AcnDgMcS
         JeVC/3b2cu05mVnqGuTaAd1d3IBxTuQDcGgjJdr9CTcgyayOvGqbRHdDv9X1tC8AZ+C8
         yuVMSdhasQl5MOiAlTyE3e0qnboemGQhPbq6EcpO+//2EDCvUPywLP5r6PbHV03wLamd
         KuvQ==
X-Gm-Message-State: APjAAAXsvawvzKEimL87oIktN0f9Rsdj9m2dPfot3S/BO9tzkz9Icyib
        eEgA+MZJvxsQq0rUt06UtPhgZeWW
X-Google-Smtp-Source: APXvYqx7SOX3tJGX66fu37nOlzftG7MZ25kFYVNYAUB5SIR/ZUrIu83nMxvYl22TDDv3Ljrlde4umA==
X-Received: by 2002:a5d:6388:: with SMTP id p8mr5157377wru.299.1581016073410;
        Thu, 06 Feb 2020 11:07:53 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i16sm215093wrr.71.2020.02.06.11.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:07:50 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()
Date:   Thu,  6 Feb 2020 11:07:45 -0800
Message-Id: <20200206190745.24032-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

b53_configure_vlan() is called by the bcm_sf2 driver upon setup and
indirectly through resume as well. During the initial setup, we are
guaranteed that dev->vlan_enabled is false, so there is no change in
behavior, however during suspend, we may have enabled VLANs before, so we
do want to restore that setting.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 060497512159..449a22172e07 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -693,7 +693,7 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_do_vlan_op(dev, VTA_CMD_CLEAR);
 	}
 
-	b53_enable_vlan(dev, false, ds->vlan_filtering);
+	b53_enable_vlan(dev, dev->vlan_enabled, ds->vlan_filtering);
 
 	b53_for_each_port(dev, i)
 		b53_write16(dev, B53_VLAN_PAGE,
-- 
2.17.1

