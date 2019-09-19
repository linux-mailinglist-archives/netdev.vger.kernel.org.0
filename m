Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBBCB8390
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 23:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393052AbfISVmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 17:42:25 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44731 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390391AbfISVmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 17:42:25 -0400
Received: by mail-ed1-f67.google.com with SMTP id r16so4488669edq.11;
        Thu, 19 Sep 2019 14:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rJfVIsuRce4Ai7CJ2QwIU77L829dWEsJGjOrVU8L8gc=;
        b=kb7nfWMNsLquPqt/dqqfLNokRrDvcnwTlmcQcItBGUJMg2JhJPPqG+owJh8ufb8ALm
         G7yslkfNg+RyyxJC4I4XZEx9hy/GcpfqQQcgOnDMR6Cj9RWI8JI0b2WDmKvXRBONNbHF
         Ft1qwsMquwrh7oAVO2Mt/38Xi9829iCZJTSaYPnFEHkGixGiar8sJxGCCl/sDPcvOwmw
         LKEKTbNjGS7+ANgBwyuLm4gJMR7kiEHlgOyzUUvB5bqB9GQ+YhnyrLel7MbHL8FQUBsQ
         sz1F40Lke6JEXIPfx88hZYADus/zVX4EGh+Zv2OCRwop4n4EArIPtY67AIZ1k3YZ6mo8
         0OUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rJfVIsuRce4Ai7CJ2QwIU77L829dWEsJGjOrVU8L8gc=;
        b=N5vUlzsOUVbX9GsNAQHdDxeRTK9PBMeaz6ueyHQ7fzhQsqu1aFmgHw5dnHzx3KkYTj
         uEtFElE5UmAFTF+Wp5zyXhEZf3y3EojEYnf/w9Cz4abHqLALIe8/vxl1mbvfW0JwYcPP
         JTHqw4RLP/CW2uosVU6k29yxvAYZ6yQ9IR0Mdu4fk5y+iI+U0zd9pRL2ilZ70YArWi6u
         pXEScPrw9Oj+X+dq8X1+OwuoJ8Zh02si/YgcQ4zRs/q5Gs4B6lBtuVUJLgpfdJ+Rlkjy
         X8gbSMu3Q3gQKuBkHbkQZtFiqhXdG9LK2gaxFQJKZD3wmvJG25pTd3ZvtWQ/r4d1Hs9G
         2NAQ==
X-Gm-Message-State: APjAAAUGDxGUpWfe8UsoYO/SOMvlg2fXgNpg9DT7KA583xynsIKw0L8e
        lD3VS2pTlLWfoQgaZni9tUI=
X-Google-Smtp-Source: APXvYqx9gTPSHYVZG42FAtLQokBRrvnWgEQkadIYVlD6plPzKR1ppm74O2z0LDngeHPZcqouzrTUag==
X-Received: by 2002:a17:907:20a2:: with SMTP id pw2mr15933485ejb.163.1568929343201;
        Thu, 19 Sep 2019 14:42:23 -0700 (PDT)
Received: from bfk-3-vm8-e4.cs.niisi.ras.ru (t109.niisi.ras.ru. [193.232.173.109])
        by smtp.gmail.com with ESMTPSA id e39sm1863921edb.69.2019.09.19.14.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 14:42:22 -0700 (PDT)
From:   Peter Mamonov <pmamonov@gmail.com>
To:     rui.zhang@intel.com, edubezval@gmail.com, daniel.lezcano@linaro.org
Cc:     andrew@lunn.ch, davem@davemloft.net, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, Peter Mamonov <pmamonov@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH RFC] thermal: Fix broken registration if a sensor OF node is missing
Date:   Fri, 20 Sep 2019 00:40:58 +0300
Message-Id: <20190919214058.8243-1-pmamonov@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When devm_thermal_zone_of_sensor_register() is called from
hwmon_thermal_add_sensor() it is possible that the relevant sensor is
missing an OF node. In this case thermal_zone_of_sensor_register() returns
-EINVAL which causes hwmon_thermal_add_sensor() to fail as well. This patch
changes relevant return code of thermal_zone_of_sensor_register() to
-ENODEV, which is tolerated by hwmon_thermal_add_sensor().

Here is a particular case of such behaviour: the Marvell ethernet PHYs
driver registers hwmon device for the built-in temperature sensor (see
drivers/net/phy/marvell.c). Since the sensor doesn't have associated OF
node devm_hwmon_device_register() returns error which ultimately causes
failure of the PHY driver's probe function.

Fixes: 4e5e4705bf69 ("thermal: introduce device tree parser")
Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: stable@vger.kernel.org
---
 drivers/thermal/of-thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index dc5093be553e..34b0cc173f4a 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -493,7 +493,7 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
 
 	if (!dev || !dev->of_node) {
 		of_node_put(np);
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENODEV);
 	}
 
 	sensor_np = of_node_get(dev->of_node);
-- 
2.23.0

