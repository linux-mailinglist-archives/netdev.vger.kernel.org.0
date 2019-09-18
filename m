Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13CBB6EF1
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbfIRVjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:39:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41624 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732151AbfIRVjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:39:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id f20so1280003edv.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 14:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tjmYFINTFjWd8YCYLvlpF388HnkcWTIGJA+BVBS+ARo=;
        b=sr7iIbZdinAy3i+1WTNRU/zJLAjW9jT7p+UYRAcSdW3+fUVUGyvAOZAa6KzD9eLGXA
         Z04DBIA6VKEGkVLvAhNvTt93MhtvG6GTls+Q6aNxESDn0jUwNm2eWg6a3I7c0+rWPI4P
         1hSIPd+b6jinG1b8l7aPUc5qndctGsdqjI6LCgd7Ufk1BEKl71197tfH5uYADEqiYmtj
         D7RxHtahpza9JVd3HXQfztbVwQao8IUoKN2o7XLBT3cIRQgr1sNoSnrE2jOuFbrroC1O
         YsTWAIGBspdgWNpgNitza8SHitL2qUF9V+hJHhNuYR4jtK4eT/5fIlu7MejsivecfrH1
         baJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tjmYFINTFjWd8YCYLvlpF388HnkcWTIGJA+BVBS+ARo=;
        b=tUph7l1avL+2yf/VrSqiPWa2GqKJrnOO83wVCd9yXOzMmA5n2zjtLl8M5VomepH71r
         0UzX3NO2iX+Dd/cSwxywnNeGsm4uk01BM9JE93mN8ihOZrjXp77fA33Kr81XoUCgGAaZ
         UDDnGuFjsfCdUU7OWXpejbT9Iicv9BXNRbJzoQ9XqhOkkUo7WTaFEIGCKrnz9SGnhoTo
         K/ngxNRo+XTN9t6QXgIVBs8xAtYXDgQE+pgyss8It1UXjL5cszHnBtXB91wxQC9325aM
         r7psTt22HIVJra5pDNUHijJ5/eyn6uBl//7IzFSfgpQ81hsNAVbh43jydR+9ue7+n28V
         AMeA==
X-Gm-Message-State: APjAAAUVsbAHZBfe6gTh8do20BS5WXLm1TKbr+wqEP7puOjaNYHT+kwM
        QDU1GHMqOYYtEWYabdSzbUI=
X-Google-Smtp-Source: APXvYqzMn2F6IFYkMxTrYd3S0kHcdW6MKAyysyepm17ULMAANI/diAXE6+KrX+W/RnDYdyQ6P/nGew==
X-Received: by 2002:a50:ec84:: with SMTP id e4mr13036128edr.193.1568842759240;
        Wed, 18 Sep 2019 14:39:19 -0700 (PDT)
Received: from bfk-3-vm8-e4.cs.niisi.ras.ru (t109.niisi.ras.ru. [193.232.173.109])
        by smtp.gmail.com with ESMTPSA id 30sm1254975edr.78.2019.09.18.14.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 14:39:18 -0700 (PDT)
From:   Peter Mamonov <pmamonov@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, Peter Mamonov <pmamonov@gmail.com>
Subject: [PATCH RFC] net/phy: fix Marvell PHYs probe failure when HWMON and THERMAL_OF are enabled
Date:   Thu, 19 Sep 2019 00:38:37 +0300
Message-Id: <20190918213837.24585-1-pmamonov@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Some time ago I've discovered that probe functions of certain Marvell PHYs 
fail if both HWMON and THERMAL_OF config options are enabled. The root 
cause of this problem is a lack of an OF node for a PHY's built-in 
temperature sensor.  However I consider adding this OF node to be a bit 
excessive solution. Am I wrong? Below you will find a one line patch which 
fixes the problem. I've sent it to the releveant maintainers three weeks 
ago without any feedback yet. Could you, please, take a look at the problem 
and give your considerations on how to fix it properly?

Regards,
Peter

thermal: make thermal_zone_of_sensor_register return -ENODEV
 if a sensor OF node is missing

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

Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
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

