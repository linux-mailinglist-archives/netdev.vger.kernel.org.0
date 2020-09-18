Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9792B26FB07
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIRK6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIRK6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:06 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924C0C061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:06 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p9so7510447ejf.6
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F2NLpL00YCxqMeTeI3wXMbdxw7Wf1cHrmp8RVXPy5D0=;
        b=ZAKVH2xV+lrGtSTGpuzzCbLov+sV2b0ilMjOt5jpq635Eij3P1fzKrSKxl+rNdE0az
         bcWn2+oF84OXRtPtASLATT+uQTnnOtoSrZeBwCydJhRUD+/XjydgzjSvam+Ik3BH+RAG
         L1Ge6jX9jrShdfIN/u3ZnbQf4/p25V1W3/Exbv6MOi0S6/4TChQrVxuNYUAnXUiM+GgM
         XRQDkghfPClI3klJMgcL97oF8zl7fo8uQRf9glG+lBHw94ibfgpZHbrhapZF6bLJgR6C
         HSPcN/NiGc4OcpiTUtAG8OzlWBs0/wAHYA6gi02shWBx9wFUzgsNipFF51QxISwb+DfX
         rOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2NLpL00YCxqMeTeI3wXMbdxw7Wf1cHrmp8RVXPy5D0=;
        b=TF4JX8TKTUAyW+kC9SfKYmoqXZCyXEz67aI3yw/0x2inOXNTihFiYCDCe2x8ao7Kro
         dsYPdH95opLzr3BPkM9sWukDDGP2yTK3hVUMAd4xJQL/suPhJvBtawALps+dnBzA8fO7
         nZYgMfejHHTQTau1a0xOeheRqNKD4LSWMrQ9k5JP5NeQ2e+hXJ5cgMdGXxPAtN677jDr
         8Z/7hvk9+6eUOZL+bSLxuVYtI2gY4nqT2XGEYJ1Z/ZLfzNF/SNr3Vmr+9z1umAR433X9
         wN4l+JWgSliQp2vhwvmHKRYyw2AzWWl+w8CuNSuyN0N/me8VQbQIOV15rzGER4jB6Npv
         roQA==
X-Gm-Message-State: AOAM533IEllwAdnkouu41aXrXB+1yPMACCdTz4k+1/oT9LVXR8ayvwA/
        6UIym6DnUizpuIwppSWYA0I=
X-Google-Smtp-Source: ABdhPJzZ7WWDsg0Z+3ZlMdh9mmOWtlbb3HoDy7ZXJeXDd+Jdy78ELZzE/PvZjbHK35JmyJjzYB0o+w==
X-Received: by 2002:a17:906:1945:: with SMTP id b5mr19474432eje.102.1600426685251;
        Fri, 18 Sep 2020 03:58:05 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 02/11] net: dsa: seville: don't write to MEM_ENA twice
Date:   Fri, 18 Sep 2020 13:57:44 +0300
Message-Id: <20200918105753.3473725-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is another one of these right above the readx_poll_status.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 83a1ab9393e9..df5709326ce1 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -847,7 +847,6 @@ static int vsc9953_reset(struct ocelot *ocelot)
 	}
 
 	/* enable switch core */
-	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_ENA, 1);
 	ocelot_field_write(ocelot, SYS_RESET_CFG_CORE_ENA, 1);
 
 	return 0;
-- 
2.25.1

