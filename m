Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E286B26FB06
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgIRK6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIRK6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:08 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E94C061788
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:07 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u21so7554043eja.2
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fPG9sy3hJUKg2BkfgCo5IP2CsejO3ze46jlb2573X0U=;
        b=u8mEi/9grs3sLI8wjEbm9RAyxMmVgIZb1ALN8FItd5LYyUuZ95b6K9gWXVc3tzjKnb
         lhAkigvZmIRBP5+n6BAL+DQZRzFmdNo+Y7gcqEJGGnFUeSmnjQAu7uD+TXOy5G0KUWyW
         X6QOHTV1TGUnA3zx2RR+8jp6UqQVFa0Qd/jshYmxOHmGgoUKUNQTpFagHksY5e/1PAN+
         HIA2SrHNONc6OYRd2AYlyCwE4zMaouPvhQt4P8ZnFeNIdThfc3aBDnxqb9AvifcFPu2f
         BXRA6VsBDZ/qYU7AYfBJibW3rTzn+DHdQ268Ok4qnBZlio00n2SWN+Ws9wYba1dkXIgL
         LuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fPG9sy3hJUKg2BkfgCo5IP2CsejO3ze46jlb2573X0U=;
        b=m3hbfM4IeVTESikMllu44wxlXR1TiJ614Q5rzCxa3Ki2LncPI55a4v3t6mDhJL3b5w
         dN83ATmhbr00qZKp02Zya1hxGuLT4lOXmOikfsYLMi1QPd0ThVn70ISfBgPhXDeeV/GA
         Tl0u3lUa5Px+ytaPNgV6qeqJDuwQWgAHMal+EOS7KSWBHD/aUFmPDaltKXa/UUgE6qld
         1m3QCjwnvztiSiQ6h2KG5qBdvo0nM3KDXHEH3Xlc0ujkh0aLkV6D995//WD0mmNtR0bv
         HAA3zAitQzmfBOVjBLpq/YHZWNgvisTUxp/b9LjMp61xOQo/nxztLDP1iSxhnO0eJfVO
         NXtA==
X-Gm-Message-State: AOAM531DeoqdgiIlKlt0z6F1hQ9kbtKAlzoi9kGJB+WrhB69/ZFIcaQr
        8b/n4PvyqWDK2VzJU8lP7+U=
X-Google-Smtp-Source: ABdhPJxJftlUHm9cbzcLw3Kx7HDVNMAbzgQuD2GFGGRPBv6lfWZMxQU1P6ovV7f7EyD4XrYRf5OPfA==
X-Received: by 2002:a17:907:2173:: with SMTP id rl19mr34750471ejb.514.1600426686412;
        Fri, 18 Sep 2020 03:58:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 03/11] net: dsa: seville: first enable memories, then initialize them
Date:   Fri, 18 Sep 2020 13:57:45 +0300
Message-Id: <20200918105753.3473725-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As per documentation, proper startup sequence is:
* Enable memories
* Initialize memories
* Enable core

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index df5709326ce1..a1f25f5e0efc 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -835,8 +835,8 @@ static int vsc9953_reset(struct ocelot *ocelot)
 	}
 
 	/* initialize switch mem ~40us */
-	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_INIT, 1);
 	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_ENA, 1);
+	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_INIT, 1);
 
 	err = readx_poll_timeout(vsc9953_sys_ram_init_status, ocelot, val, !val,
 				 VSC9953_SYS_RAMINIT_SLEEP,
-- 
2.25.1

