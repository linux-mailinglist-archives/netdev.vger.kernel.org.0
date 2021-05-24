Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D338E33E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhEXJ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhEXJ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39C0C061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lz27so40717881ejb.11
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZJiSmhLNmHbbXW7xoiDmjsjrpJavH5ubtWmLGqLBR4M=;
        b=BXB7VRudEzI8UO/b+QQvqiGAJad1C7KkxGFts0Z0VsU7mJfHSsFZx+g9s2RKYScyuU
         yfmqPNyUU1IlPE9IpINEpSAyWYl+HeemPJ0kbRnYUZvVEXUktPPNlo9pV5amzJVoTROo
         vAMsWya7n1BSEHw+vtxnDFF3dwqJMZ/H0yUrvRAWxQzKM/AIfOZ9pYNdLVI5aZ0XmwFJ
         ZtiPZbKv1APSPZn8lp07PAxVLP0+dwwHU38axJp0hzbAWNFzPevsPG1fsYZEt+eduq0M
         nifbtlVig5bcw1Y/2wKOLD6kgjLiojHmhFTSxrFUqAGt1SNGWtlIt5sXNxZpMn5kbckW
         EjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZJiSmhLNmHbbXW7xoiDmjsjrpJavH5ubtWmLGqLBR4M=;
        b=hh9qdNyRyrYuDiwNtaqByF5YTkoKwu+ais3Ty6wW0cUEJP8G7nMWCLHu5L0OFHM9FD
         G1zg18XqUMYdTWNg7ebDpMcB/AkVsOiiMFsu1FOKeGtfH8YRMYW6sTo7GMt+LI28LkTf
         Vz3scuhgSI4Ffh4Uq5kPmoTXTJy+9rVVR6oUAmmUSTdbPUK1qa9Z29ddVSNJImsNIHmT
         zTWkA1iFasek8dCfAOJjpK2zdZYYcZOcrv1DGVCQjq9EYVe1xSvndKsQma339uOTqo1k
         6XCx7BSODZyV/p1/wc2zMEAyeQjLkMW8124i7ltmieHAyMt1KcoJeEZkumYqAd+oNM4H
         cnnA==
X-Gm-Message-State: AOAM533Qp7uZYAth87eNyYG6xxwF4Dp4d+EsvnFDLBtYsqZceY7CzIi1
        WrHi9qsIiJODT1a7nxMo2CDvMPMx9VM=
X-Google-Smtp-Source: ABdhPJw8Bj+cxbMuVonpAP/Rrj5T/eXsUpcRXKoppvvdpvOpFJorXvZrqe2rZj2dt1UstjljscGvqw==
X-Received: by 2002:a17:906:1806:: with SMTP id v6mr2392787eje.454.1621848337375;
        Mon, 24 May 2021 02:25:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 4/6] net: dsa: sja1105: error out on unsupported PHY mode
Date:   Mon, 24 May 2021 12:25:25 +0300
Message-Id: <20210524092527.874479-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
References: <20210524092527.874479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The driver continues probing when a port is configured for an
unsupported PHY interface type, instead it should stop.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c7a1be8bbddf..7f7e0424a442 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -207,6 +207,7 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 		default:
 			dev_err(dev, "Unsupported PHY mode %s!\n",
 				phy_modes(ports[i].phy_mode));
+			return -EINVAL;
 		}
 
 		/* Even though the SerDes port is able to drive SGMII autoneg
-- 
2.25.1

