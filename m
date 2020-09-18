Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF03026FB08
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgIRK6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRK6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:06 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F797C06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:05 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z23so7441404ejr.13
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9OP1mRo71Vk0qTR/DvrQzjAovn7dQZQDwENlVj2lInA=;
        b=ImX2Wk/TaZwOGBvM9hOMXv05DK8bswHw7ZdJ/Jl+hM8q/WyhtRUs6z9qyr3+Gcag6S
         AmrvwP/EFYwBi+TvF9Fc3XAFbTiNZO7Ga3hGVjnaY/rydHbg1kE9smHyLg+Ta2yIIGQs
         e4ZFlIrjAM7vr40lR3UKZv/yYUwu4ySU+18XN0dRH6RmAPQa2gjkPjDQewyz1HeEehFS
         snNOwqYiiJj93OTOgCdoKiXHS6TBMHg136IOe4kGrsbsxZa0BvdYf3Z23/n1C4OIFgjz
         c1tz/iVJoEVn0naWX7HwbjlZ5t7ZzlKFgRL6TEBq3k3f28VURV1fmQ4VGKK/DyUlCy2w
         wwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9OP1mRo71Vk0qTR/DvrQzjAovn7dQZQDwENlVj2lInA=;
        b=U7393+MWoWhSRaNOQWxv39/YTxgaBpLFS3Dd4Rwiqzvztu++e2HnUo5rTgBa+fGC3c
         Ffe7nOEqupeI+QGYvrlXByDj6Tiu5kDxPIBP9cfQNvXi4A78sxvwyGUl+117kEAtQmku
         OAyDPl5PS6MOwiPVRurqIF8TQcN0C94OvSiUEsqdF89fKkOA6CRhexljL79mKk4Mv8xr
         Q3/EdMZKw3t6lIeGbSbTpYtH65G2TiApX2jr81QcKsIwjBCRgaq0gGqrfv/1eEOwgBKL
         A9MPFQJdNN+x9dotV1QaMzEBp5j3DMrL/P4s7dnLRBUkb6y7nXehZ2HAI9MkCd4gfL/4
         bW7w==
X-Gm-Message-State: AOAM5318pwqXGlu20/fiFdRttqFcsvgaMfmw+oPc99iEq5o2eXaZ4Sqn
        0yc9P1FX7FYRSJwrB5JvPU4EClRbANw=
X-Google-Smtp-Source: ABdhPJwAr0ExBmNUgC3LLI/44SOv+TU5lJ0Pd+FTWMDYaYygPTcOv2CKLzCBK6NDjVK5tUlGOpxKgg==
X-Received: by 2002:a17:906:e08f:: with SMTP id gh15mr34598137ejb.443.1600426684107;
        Fri, 18 Sep 2020 03:58:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 01/11] net: dsa: felix: use ocelot_field_{read,write} helpers consistently
Date:   Fri, 18 Sep 2020 13:57:43 +0300
Message-Id: <20200918105753.3473725-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since these helpers for regmap fields are available, use them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 126a53a811f7..397d24c9f7c2 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -727,7 +727,7 @@ static int vsc9959_gcb_soft_rst_status(struct ocelot *ocelot)
 {
 	int val;
 
-	regmap_field_read(ocelot->regfields[GCB_SOFT_RST_SWC_RST], &val);
+	ocelot_field_read(ocelot, GCB_SOFT_RST_SWC_RST, &val);
 
 	return val;
 }
@@ -742,7 +742,7 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	int val, err;
 
 	/* soft-reset the switch core */
-	regmap_field_write(ocelot->regfields[GCB_SOFT_RST_SWC_RST], 1);
+	ocelot_field_write(ocelot, GCB_SOFT_RST_SWC_RST, 1);
 
 	err = readx_poll_timeout(vsc9959_gcb_soft_rst_status, ocelot, val, !val,
 				 VSC9959_GCB_RST_SLEEP, VSC9959_INIT_TIMEOUT);
@@ -762,7 +762,7 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	}
 
 	/* enable switch core */
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+	ocelot_field_write(ocelot, SYS_RESET_CFG_CORE_ENA, 1);
 
 	return 0;
 }
-- 
2.25.1

