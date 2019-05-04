Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A984213A7C
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfEDN7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:59:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38826 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEDN7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:59:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id f2so4916322wmj.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ayIYSxG6qThnYCYT1YaBgiQ6EuXJ3DaEJwMfddDhfR0=;
        b=gtXHSqOarsh0JH5WIcUi6O2z5w8ap0PFlV3eXMWYY6ame0Y+h39njeR2XmCp+8+q0J
         nnCQvg4WVcyWtvJHXoLAS6WzOIeK/JTFzUZwz4QUxioPozQ0NYQqORO6adq3ul49eUD5
         wV8H5a9kDLOOA998wXhZSmLVPfF9SCV9QSg5MfR3xJVyxH21HIkiNYgQKzqQP85xKv06
         B019MD9A6blYN6/0CPFhEvMF4+4ONaWnZEpyDs9FJWgm1SNhcmAWBtQxd53ALHDJxuDK
         K8mq5/rwJ/UpDjVIK5GDf1oDsbcphj8cHze1u3MJPehufe1hB3jzl1jKWMeqhyVvui5k
         3g4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ayIYSxG6qThnYCYT1YaBgiQ6EuXJ3DaEJwMfddDhfR0=;
        b=A9JEzNVhn4knRvR+T7e2CZS0TJxN89zkCEzKzROGWVywkC2Fe8edUksJ1WltUoftis
         VpKz4kBZ2UTeETDyjsMDWF2duNr02RLCo19pbUgJsksH49XAkyZa6sI7Bkj59aAMfio3
         15l/fbe31ErvHsQGxWyckM1cw/BBAeWQQZ2HQCtVMSQOh+tcvh2uB6Fnm0c4bZsdPgju
         JmOjr+45SfqDdPAlx3Ef6Pr3yJtMMUSyx3ekCezSFxKiZWxQ5mIrC5quAhCMkJkWF2jU
         s34G83a5VvhNxN+ppgjfkjxCxuGXC+ipUC8q8OtDvJ1kEuvp9ziks6Lu3PShe7zlSTl0
         HUvQ==
X-Gm-Message-State: APjAAAV4c63YxRmPLqHsfEB9odWfZVnik/9cXzEU6PfSoQa81jSgduxg
        qMHanWbbJz33lMmJR5pbNr8=
X-Google-Smtp-Source: APXvYqzLKtSxuxoE/6+JnvqqgXFmMSlbUTxUdv07Gp88wujON17bJ6UnjsqHm5BGpC0vSz2GmaPorQ==
X-Received: by 2002:a1c:e08a:: with SMTP id x132mr10038113wmg.24.1556978385786;
        Sat, 04 May 2019 06:59:45 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s16sm5085940wrg.71.2019.05.04.06.59.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:59:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 1/9] net: dsa: Call driver's setup callback after setting up its switchdev notifier
Date:   Sat,  4 May 2019 16:59:11 +0300
Message-Id: <20190504135919.23185-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504135919.23185-1-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
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
---
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

