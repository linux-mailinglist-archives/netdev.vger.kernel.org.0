Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488FF26FB0D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIRK6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgIRK6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:15 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B63FC061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:14 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z22so7495321ejl.7
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XCPXM1cG7U3MCbziuVA0nBNFMY+VjATKo3apGChd5y0=;
        b=hytelxy/JhJmBXB/v8bNNvLpLd5cdLPwTsYUaf60EobvPnavy0oWABY/OpVOjBcXmt
         tB8h0QYYzSX/40fLqaHKRykS0OmIqwRSBS89XAgJ+IfwkII6STLl41GK3xSifbUdeOXs
         7uYYNEd50I7JBsVSRg1jLu1zF/EAsWyt0Fk/WPavXF1VzNxGKP60IAAMdrlmMkvj3P3E
         WXdzwn/i4jygkjh5l4tP+GvOfjKOAYpFB7bZ5EZ/0KXgQ5RuSB87lsTDy7FY+l5WKI0c
         trTnWPcz/l86hxknU0JzXWeSQR5EHfw6zewn9DhJBoP69IL5iUoX09pLlSpxUx9Yw88R
         mAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XCPXM1cG7U3MCbziuVA0nBNFMY+VjATKo3apGChd5y0=;
        b=Tr/GkxNr/7Cgrh7I2I2wf0WjImLXMnkm0hlIfzYXPUyqOx1PttZx2TghyMAILULBRF
         aLd2V/ae2MLTJKbjbzsECwq6kHtUU1z0+UFseIgdnwkwIlD+qVc58YnB4vzJjoIR8EgR
         dx+Q2eDp3d7CnRuVFnWDEh/moVMIMwQwXUpBoroNVOnHTLikkf3agqwo8LcMjJK6DWx6
         eSO0G9uBXG9fLSMsGYY7bE4GrYmnfrxO04mn/GTN5SgTo43kdlBQwLGAq++KYGXDyYqH
         msPGRH+jLV5RzVw0jp7oLCszzI7cb+X2x0xUwOjX4sUtNtyJbqdfVc+5uSGB74FKNtDL
         mIgA==
X-Gm-Message-State: AOAM530KdVB4Vk2y8UKUvpvUed6OKlBWJWi5PQ8mfe2gG81XKc41K/Gc
        EBU8YiFsRZ2y+uJ3IhxoHiU=
X-Google-Smtp-Source: ABdhPJzzwZOf7oAX7fOFTrO4P41AniYRIaqcD6YpyIOeZ2mx08H7kIlZDhqtyy64GwqTKf2JsKtaEg==
X-Received: by 2002:a17:906:a101:: with SMTP id t1mr34576569ejy.203.1600426693280;
        Fri, 18 Sep 2020 03:58:13 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 09/11] net: mscc: ocelot: make ocelot_init_timestamp take a const struct ptp_clock_info
Date:   Fri, 18 Sep 2020 13:57:51 +0300
Message-Id: <20200918105753.3473725-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It is a good measure to ensure correctness if the structures that are
meant to remain constant are only processed by functions that thake
constant arguments.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 3 ++-
 include/soc/mscc/ocelot_ptp.h          | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 1e08fe4daaef..a33ab315cc6b 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -300,7 +300,8 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 }
 EXPORT_SYMBOL(ocelot_ptp_enable);
 
-int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info)
+int ocelot_init_timestamp(struct ocelot *ocelot,
+			  const struct ptp_clock_info *info)
 {
 	struct ptp_clock *ptp_clock;
 	int i;
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index 4a6b2f71b6b2..6a7388fa7cc5 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -53,6 +53,7 @@ int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 		      enum ptp_pin_function func, unsigned int chan);
 int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *rq, int on);
-int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info);
+int ocelot_init_timestamp(struct ocelot *ocelot,
+			  const struct ptp_clock_info *info);
 int ocelot_deinit_timestamp(struct ocelot *ocelot);
 #endif
-- 
2.25.1

