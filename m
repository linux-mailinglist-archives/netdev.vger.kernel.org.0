Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E126ABD2
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgIOS1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgIOSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2559AC06178B
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:54 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lo4so6431823ejb.8
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KnJ0qwOr2NHhoAZtAD4MhEOftqhwxT9jsD4NwYcUMCY=;
        b=SN5hL75UZ9OXVHPJg8oLOlAK9SSDCXC4ehFixsnxeoUMwYZYTR+zB837SlKY3ecJoQ
         ddoj1cXQPVYgs1gSrymT72V0Tksog9waSIPhSDnfCupbwlftbtqLGob1K2fRvFDOrnXs
         o0iMLL8/9DCeSNxGMJcu55JJC6Xhghi7qkIbZSVlWSmywiIAloIlKa8D+zPl+lQaYthQ
         lXnwLNSCm9eGQ4HeIEj5nlmWQst1j9PaRCvun3HhC1vHn80f1WoIXDDg/XATzNEnrByV
         Kon8V6mz/6EdVaDJcVCfosM7heLZCe10U5INpShxoFs9Dh6rHoaPm7yyguzCGT8FHpWM
         OWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KnJ0qwOr2NHhoAZtAD4MhEOftqhwxT9jsD4NwYcUMCY=;
        b=XtOIAc/hcteKLzh7VDODGR/QFxriO1AH6I5YpVCy//NcNCOerHr9eLxiMK3HpK1Phs
         jMes3fw1TOE0pfcbETVo1aqJqIZq+i7qpnnDxlRlxW18OInfBi4Yie+8ycnqI17K7Znf
         M36ecmiQLPccOxOSPa71OFNq9kRlC6c5+hWkNWgFH+5dOkLtAIglEHt2H7+E7T9da9vw
         a/4B9Ai9i2zpd2wBlzz7sXieANFB+5wUOIzT2BMAS+Bzw8nDK+4qIyppedi6R9AXk04Q
         N6aXM8l+7L9bW3PnqDI4u+T98Iw/GC4J+7/zH+/GSonLaXF+Bh/vogIgFAtqlVO3kZ/K
         baDA==
X-Gm-Message-State: AOAM531tErXXvYb8hLqxlHRlgd0+IUI4ANwidy+5aap2XjB36KDu2h3h
        kOgB2+KgdtDKDTuHSj6RZ5k=
X-Google-Smtp-Source: ABdhPJwiS9UIRP0oHg2Q4Ia3wYn2gg1n/2gmum5llcDHCLsLbQRGGerIHOGEpa+XMXtPrDrmhSm0oA==
X-Received: by 2002:a17:906:8559:: with SMTP id h25mr21142763ejy.536.1600194172839;
        Tue, 15 Sep 2020 11:22:52 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 3/7] net: dsa: seville: fix buffer size of the queue system
Date:   Tue, 15 Sep 2020 21:22:25 +0300
Message-Id: <20200915182229.69529-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The VSC9953 Seville switch has 2 megabits of buffer split into 4360
words of 60 bytes each.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 2d6a5f5758f8..83a1ab9393e9 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1018,7 +1018,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
 	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 128 * 1024,
+	.shared_queue_sz	= 2048 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
-- 
2.25.1

