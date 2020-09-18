Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C12826EA44
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIRBHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIRBHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3746BC061788
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:40 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u21so5861152eja.2
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=63XTGrK5gzi1vWJvflWPFM9+keo4NDgShJ9JleCT+cg=;
        b=lnucAtgW/t6E9KKpKidHxxaYhng22J+8hLPNRxKbNNGmhuaBjJ/jg8PVpVmxTsWHqC
         Gg+MszJOEeicvXsnVkZZAXlVeNth4gho0l/wcIQ1yVltKuyRVlEEi21u/veE5mkltjxP
         9CNxVMWQKVfyRUfA3CcvJrS1UuIAJtWYHHj+NS1VhNSqvCeBXdZaZQNwiFrm3uZ5prta
         BJAzx8CNBJ2P3HBsACgdO/3IaDHowVOii6iB3hFlJ6aVffETCONM03bScPanG80jyYOJ
         BgrX7z599TYsBUuePZiRmf7ddngGksqYShPM2FwI4mpBzno4JZjKWRoFNihIodB8+11M
         YZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=63XTGrK5gzi1vWJvflWPFM9+keo4NDgShJ9JleCT+cg=;
        b=eYzI2yBCqIeqdkJm6173ZKiPdk6fNQ+vRocD4l3oyn3HPc6xvU2Ck4OugjbmN3ZLm8
         VU62wnMy2MdFqXEDkW2J4smUMNOzk/1GL9garsqmYaXKpCMh34YDNDb2FmxEO8UfVEYz
         ukPWK9zLYaQf+lLHz/Lf13rcKraD3pwQkb6Q/n7chxIVlfdyhAe+WPPYbiFQ/EBKZrUp
         X+MHJlL9XJb19+yk6izah1/22fw41+khObXlqPLvPuyGI6zu6aTgF/Td3pRqmisJsIyC
         9kP5OMrUlJFlEPiNce2ghbjmkbYIfxlApnCepyljHulinltPGpfV31B05y4yyzO+0oUV
         qASw==
X-Gm-Message-State: AOAM532gwcO3kZ42MX0MeTzgPDJR/mL2SWy1dHVR34d+tiw+r3suTsXJ
        veW2ucQvnuQomXBQQosFMkU=
X-Google-Smtp-Source: ABdhPJwXgID4T9sOPaU8509uqOoCZd9hgYGnrPkJPwuKYZqFTnJ3/isfi10N+Pjo0NZm/zNvfBdecA==
X-Received: by 2002:a17:906:af92:: with SMTP id mj18mr33094990ejb.242.1600391258961;
        Thu, 17 Sep 2020 18:07:38 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 3/8] net: dsa: seville: fix buffer size of the queue system
Date:   Fri, 18 Sep 2020 04:07:25 +0300
Message-Id: <20200918010730.2911234-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The VSC9953 Seville switch has 2 megabits of buffer split into 4360
words of 60 bytes each.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
None.

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

