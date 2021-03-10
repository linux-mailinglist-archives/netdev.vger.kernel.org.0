Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8A3334719
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhCJSqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhCJSqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 13:46:23 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DD6C061760;
        Wed, 10 Mar 2021 10:46:22 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t29so12590740pfg.11;
        Wed, 10 Mar 2021 10:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umEZPV5CAitiF3CaKWHbRD8mqopRGuNGXvMM/a+lJik=;
        b=u83raowevz6maKXYwXHyPSkM+s7xlabyLUUmelIs0ijZPXZxXas6wUzm8hfCh85hDQ
         t8wj5pOf9JZRgut+tqQhvvTDULU0U9lAim5wUiAIDIU9POnI/FkYDHI2BBj3ff/Ey9mq
         Hhw9bWOY0zPnvWh2oxklVPZHNYrw5L6buom3Pv9ob5xi16e+g7/82q3h+mlzyD3wIyKn
         jQOw28JKpoU9SThPHBGSvdmaCchptBBTFpuIH5vKvYGMU2Zbax5aAt79XK2hzVdtUmqP
         yS8KrSfFH7CvbBu58Dv3UQO0npOAZnfLhnfTm/4BWsoWuF/suHX3H5S13WSHQ9TFtf4d
         gM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umEZPV5CAitiF3CaKWHbRD8mqopRGuNGXvMM/a+lJik=;
        b=lwYWsb7Iuql3vBPM9L9sgqvBbWMiPIuAOAFZKt65YV/nK413DQVF0sN5VFBpSg8Lam
         7FPhk8yKRSMZw4AACu6IRnwvHBbRF/2u/mMGYJC28pYll/pGMx34zcTb2Q5iUWTQCMjB
         hLiuyP8F/7g/K18uhQs4fbwWlV/2usJpe+KOBlQzd7iEHY8y0wQK/nkExJZif+kx0pOp
         7ZmgwRaz41oJoMkJ4cQK/ZqhOFMHrvEVFoVU6eOO5km04/RftknhWqKF4bEWtsIvii5R
         f7gSmBzILa9JSkP05CrJekx3LMruI3d8syCCpZjLf62UjRAc6YKs0RajAHs16H8eFeOE
         yHOA==
X-Gm-Message-State: AOAM533X5TxLQngBx8h4vIjTw4jshQQGjP3+FHASLkI//lNphpUoub2L
        CTy8x6MUsTc640jEe+GivW+/SQWytNw=
X-Google-Smtp-Source: ABdhPJxb00lEPMeidAWxnRdnACu8JqOLx5wmQQj+DTKer3sWIdNQlHuzNMY/rKt7HiaivpKVXZU84w==
X-Received: by 2002:a62:184b:0:b029:1f4:4f14:5c1c with SMTP id 72-20020a62184b0000b02901f44f145c1cmr3890236pfy.77.1615401982087;
        Wed, 10 Mar 2021 10:46:22 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gm9sm135192pjb.13.2021.03.10.10.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 10:46:21 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: VLAN filtering is global to all users
Date:   Wed, 10 Mar 2021 10:46:10 -0800
Message-Id: <20210310184610.2683648-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bcm_sf2 driver uses the b53 driver as a library but does not make
usre of the b53_setup() function, this made it fail to inherit the
vlan_filtering_is_global attribute. Fix this by moving the assignment to
b53_switch_alloc() which is used by bcm_sf2.

Fixes: 7228b23e68f7 ("net: dsa: b53: Let DSA handle mismatched VLAN filtering settings")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a162499bcafc..eb443721c58e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1105,13 +1105,6 @@ static int b53_setup(struct dsa_switch *ds)
 			b53_disable_port(ds, port);
 	}
 
-	/* Let DSA handle the case were multiple bridges span the same switch
-	 * device and different VLAN awareness settings are requested, which
-	 * would be breaking filtering semantics for any of the other bridge
-	 * devices. (not hardware supported)
-	 */
-	ds->vlan_filtering_is_global = true;
-
 	return b53_setup_devlink_resources(ds);
 }
 
@@ -2664,6 +2657,13 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	ds->ops = &b53_switch_ops;
 	ds->untag_bridge_pvid = true;
 	dev->vlan_enabled = true;
+	/* Let DSA handle the case were multiple bridges span the same switch
+	 * device and different VLAN awareness settings are requested, which
+	 * would be breaking filtering semantics for any of the other bridge
+	 * devices. (not hardware supported)
+	 */
+	ds->vlan_filtering_is_global = true;
+
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 
-- 
2.25.1

