Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998BA13EC5
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfEEKTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55382 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEEKTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id y2so11884793wmi.5
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2SXIl5d+k9wW3+zL3Yy+vOWraFbVEB814dakeVqHxYU=;
        b=rp1tEGRFhkUtXYpm5yjbvzbMKtHTAcujkKKTS1EGYGg9PliEl0wmMKX1e/qK6uz+Ux
         u6+uEJSjU8BM2ErBfX4yAMffdbA+kMq3vGG/LeoUlEs+l4kkLDEioq+cdL+VnmcmQhqV
         kaHyPmO6Z6siKwxunAgx5Xw+HGlBaiL5W0WD7q09Zrb5BCX76AmsAjP8iHVXj6XrcL7c
         AdDRiRSXSezxR1whN495jZaNqRdgiBfiYHVzd45vsj9k/75pS8j5niNyu1o3c2D0NIoY
         th2sqh3JaWTjff+dg02jtfZt4Qy63DVedZGppDHAmOYROZ/2iGE751fTe+xs7WOAhRyq
         5CGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2SXIl5d+k9wW3+zL3Yy+vOWraFbVEB814dakeVqHxYU=;
        b=numS52bvhoVZ/0XyIC1FUe8AgwOAzCj/Wr18my4AGuYx1u+gx0bFBlP5eDJtcj21Rr
         SPF7IZqxL6N99nQOlHjoNLNlVlgoImdTH/xrDDaoh5sQ0IsXnVLl7N9bAMT/WeZYhMuV
         0IB4ZmOslMl09Z0e1hJ9tKlNQqVmbDTVS6S6EYuwa+/j/7xjaHK5lujXrt+H4ANMPcsW
         xQVAJrquo4LlglwDvuZ9IZC/DYKm8/Fi2wU1lT33VSI3dBIrLzsPQDygmKECmNYcvUQy
         JQiCFK+18u+N148JTmrPcKCwUcpkQ4jj1gKw48nE+sW3asocEZJg0RKhx4wIRaDhB6k9
         TQkA==
X-Gm-Message-State: APjAAAWj2b4FU9RbQdFhctan8SG5L+KndxauPIzt9DkiB4PRmoiz2eZL
        mnuKP2R7rK6bnWka5BSqjy8=
X-Google-Smtp-Source: APXvYqxJ0uMmpMfMQNzw1xT8ig0LgFLFShtYyWbEgXj30Q4KOZHDXXhXv5GIB0hRWo+A23dJ0iGBIA==
X-Received: by 2002:a1c:9c03:: with SMTP id f3mr13195099wme.67.1557051580544;
        Sun, 05 May 2019 03:19:40 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 01/10] net: dsa: Call driver's setup callback after setting up its switchdev notifier
Date:   Sun,  5 May 2019 13:19:20 +0300
Message-Id: <20190505101929.17056-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows the driver to perform some manipulations of its own during
setup, using generic switchdev calls. Having the notifiers registered at
setup time is important because otherwise any switchdev transaction
emitted during this time would be ignored (dispatched to an empty call
chain).

One current usage scenario is for the driver to request DSA to set up
802.1Q based switch tagging for its ports.

There is no danger for the driver setup code to start racing now with
switchdev events emitted from the network stack (such as bridge core)
even if the notifier is registered earlier. This is because the network
stack needs a net_device as a vehicle to perform switchdev operations,
and the slave net_devices are registered later than the core driver
setup anyway (ds->ops->setup in dsa_switch_setup vs dsa_port_setup).

Luckily DSA doesn't need a net_device to carry out switchdev callbacks,
and therefore drivers shouldn't assume either that net_devices are
available at the time their switchdev callbacks get invoked.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>-
--
Changes in v3:
  - None.

Changes in v2:
  - None.

 net/dsa/dsa2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index bbc9f56e89b9..f1ad80851616 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -371,14 +371,14 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
-	err = ds->ops->setup(ds);
-	if (err < 0)
-		return err;
-
 	err = dsa_switch_register_notifier(ds);
 	if (err)
 		return err;
 
+	err = ds->ops->setup(ds);
+	if (err < 0)
+		return err;
+
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
 		if (!ds->slave_mii_bus)
-- 
2.17.1

