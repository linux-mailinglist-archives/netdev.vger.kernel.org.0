Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580E525C4E8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgICPUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgICL0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:26:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECCEC06125C
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 04:26:31 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o21so2532592wmc.0
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 04:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFkmXzoxFQr3rQkOqCpRjlsGMq8Wjt/8E28ck6dDdQs=;
        b=mojZWe+GGQsKSI72D6gE7qW/0BhSrYPChfgX6T7KX1UE54OXTQ0/XKl6KgEMky3mLr
         yP18CaZlf/Zr58kxi04UkIqaqvFaYfQItps49BVZ6jdldsjJrJ53+4qwtjVdbIznJvMX
         AAX7ABBHHVGBRdELS8ebNM1HetBGofML3Hwnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFkmXzoxFQr3rQkOqCpRjlsGMq8Wjt/8E28ck6dDdQs=;
        b=eQTSai9sVtXueNdYjWZSbkjY2szeg0OuKZjUsXMPcN86xM3DufNVUIDWUN4CvOe+jY
         3k53YJYeIT16QaXkBntuNWGs3Tu6kwLJqPdGvJ8Uyq7vmTFm869vLsNsjiEJ9PQVqZiZ
         9ZceBIPIalBciSSku43Gxkbgi2Rz5M/4s+bmPlZqDPYGzmIWNbwPudOoxFXk40McM5DM
         oKvdib/1yj41NPpQAz2mnjSxEm7ogWlT3U09HAb5hHKaTyUIP+1b/dEdUMQPQBBGbK7T
         BDCfZ0zRmNdRhLU6bf8Vmxi9Ux7+CoH06olmtzNCH4GnxRAx4+JbSfX/4p0WBkSJqeCq
         IBgQ==
X-Gm-Message-State: AOAM531/656HwHESi7Ui1+YrIJxPRe7aRXefED6WzOrxMgfMUsFKaWkg
        2tTVRtLhTIh2RTiRJRCrsOS5nQ==
X-Google-Smtp-Source: ABdhPJzUTgjmkY2Oc7W70P7vgCMdiYOFC0Pqwh6qiVL0W8fGOipUgWuUDlF3CDFFq/sxeNVl/BAsdA==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr2091468wmb.5.1599132388298;
        Thu, 03 Sep 2020 04:26:28 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id 71sm4312734wrm.23.2020.09.03.04.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 04:26:27 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 1/2] net: dsa: b53: Use dev_{err,info} instead of pr_*
Date:   Thu,  3 Sep 2020 12:26:20 +0100
Message-Id: <20200903112621.379037-2-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903112621.379037-1-pbarker@konsulko.com>
References: <20200903112621.379037-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows us to see which device the err or info messages are
referring to if we have multiple b53 compatible devices on a board.

As this removes the only pr_*() calls in this file we can drop the
definition of pr_fmt().

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/b53/b53_common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e731db900ee0..c2ecb1cdef3f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -17,8 +17,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/gpio.h>
@@ -2620,8 +2618,9 @@ int b53_switch_detect(struct b53_device *dev)
 			dev->chip_id = id32;
 			break;
 		default:
-			pr_err("unsupported switch detected (BCM53%02x/BCM%x)\n",
-			       id8, id32);
+			dev_err(dev->dev,
+				"unsupported switch detected (BCM53%02x/BCM%x)\n",
+				id8, id32);
 			return -ENODEV;
 		}
 	}
@@ -2651,7 +2650,8 @@ int b53_switch_register(struct b53_device *dev)
 	if (ret)
 		return ret;
 
-	pr_info("found switch: %s, rev %i\n", dev->name, dev->core_rev);
+	dev_info(dev->dev, "found switch: %s, rev %i\n",
+		 dev->name, dev->core_rev);
 
 	return dsa_register_switch(dev->ds);
 }
-- 
2.28.0

