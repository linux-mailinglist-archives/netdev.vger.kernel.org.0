Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542DE3FEAA1
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 10:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243655AbhIBIcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 04:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhIBIb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 04:31:59 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB0C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 01:31:01 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s12so2155984ljg.0
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 01:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUiAfSITq6W7njnqVRK/mA6fpjG3fTsAcCU4D+dTTVU=;
        b=TOVeLzPFPcIGAHOAa3nS9nUtQGqfF89UMXfj5K8qnlkb54AK6G/xJRy3bV1nhXXexn
         nVJ/fZe93t0cotImcc4aGMEZ7aj0ophB4ITfW8D4O4njqjmiOZ9s49d/1t7EOXEdWyis
         ngyk98JgqzJSusABCMScQgI3L2js/YoxVUJ6s7N4Ypz7ikH0tcfCkZ9kgWFb39mDXq5Q
         hC0GrTSfgVBXVbcA5qPR5ED1v3WyNbPagqH3L+jIpu3cYc4g6WkgQBXGRncIqQ1rk2xd
         cH0cBZOnORYOW5xoxUL8+usd+iBvMqn1wNtwQJ1NI1NYxo7g7WQsT4FMXQdcL6Q13uBh
         SXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUiAfSITq6W7njnqVRK/mA6fpjG3fTsAcCU4D+dTTVU=;
        b=VDWHDze/3npp9R14OCMPIhDzaANGyRfuaXRxisDhtieDEUCB1lf5uJEzzSGgUqSogY
         8MwNYcsJbUr/FCgRNzg5BZSk+1BVST71UMj+vot3eS/yM6oAKqmqWAqHENNEekMTlmx5
         +ff8cWhJgPhyS6cRqEy8Xw3ENY6T8WS8MTSNs1EsLHbcNd7ryc8zcHoAAAt+jaB6uBb7
         h9aIONEIpWRbe097iSgT2V3Z0lXcaHVHtHfxbPAelSzyBK+RB1glE2k+uBI48xmfvQj3
         vvVXLPKtKIfWHR9XAUQHNmzInJtd6o5TD93JK6WG3bZiQ5OcXZIPgelT1mQV7/OP5CAZ
         6l/g==
X-Gm-Message-State: AOAM530u91bEhwWCOcyqN+qboPqmGRUEdR+xjLGd//XEibha5enPeQrO
        hocXN2WumP/uk6sWBf/3k0c=
X-Google-Smtp-Source: ABdhPJwUZ29iEbuxHCu2/LnOTi9dI2ii3RDDV8iubOJoejo6W6b6VWm4fPYeYWhYacX1xOGk6wSuPA==
X-Received: by 2002:a2e:8789:: with SMTP id n9mr1561519lji.428.1630571459334;
        Thu, 02 Sep 2021 01:30:59 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id 131sm137042ljj.52.2021.09.02.01.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 01:30:58 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net 1/2] net: dsa: b53: Fix calculating number of switch ports
Date:   Thu,  2 Sep 2021 10:30:50 +0200
Message-Id: <20210902083051.18206-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210901092141.6451-1-zajec5@gmail.com>
References: <20210901092141.6451-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It isn't true that CPU port is always the last one. Switches BCM5301x
have 9 ports (port 6 being inactive) and they use port 5 as CPU by
default (depending on design some other may be CPU ports too).

A more reliable way of determining number of ports is to check for the
last set bit in the "enabled_ports" bitfield.

This fixes b53 internal state, it will allow providing accurate info to
the DSA and is required to fix BCM5301x support.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bd1417a66cbf..dcf9d7e5ae14 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2612,9 +2612,8 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = 5;
 	}
 
-	/* cpu port is always last */
-	dev->num_ports = dev->cpu_port + 1;
 	dev->enabled_ports |= BIT(dev->cpu_port);
+	dev->num_ports = fls(dev->enabled_ports);
 
 	/* Include non standard CPU port built-in PHYs to be probed */
 	if (is539x(dev) || is531x5(dev)) {
-- 
2.26.2

