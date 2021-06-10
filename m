Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773123A37D0
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhFJX27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJX26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:28:58 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A6C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:26:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ci15so1629427ejc.10
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aszyaYZsJcZYQj2Xj4LwuEfwn7jbhFlbU+YBkgFvQ3Q=;
        b=ljavh+DxOM0rbbFw5h/Oa0VEcoODQr8jw9WFrSjY35ePWwW4euYDNf3POa/OL/QBlN
         Pp+VPDcfn9zChfB4bg57AzyfCaZ/TRUmkuGIR9e4iJ/0q0Ojw4BoG7Q7wZhTPVXj46tG
         0r3C4HfMfYx/8/Ohmx/s4PXbFrK3kbzJsucBfXSXGCjuz15kgdRi+RVFfgaOIKRbKKHv
         AIYCpCxV5MhCp43NYxNkB5xsIIyKOJtnuHoWU3TwDc4IloxQk+ge91V5QkRUIVufZO3p
         T11OVPRJRidL9Yw6hFCt/2UWdEW4zHxbqTaOn9G4180xJse904dqWGTwp8sfkGFOVvCJ
         AZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aszyaYZsJcZYQj2Xj4LwuEfwn7jbhFlbU+YBkgFvQ3Q=;
        b=ClMyFz/6dgmHEnvmXLxnndxJxw1O9KECs8cxHTzbe9n6eOTEtW/qmxYXo4v+goQ4Il
         BMh35/E43kmSOn0KKWBQIoK32iNrM9WVtY6tvdn6W3WOSGnshXVX9tDuJw3699aa21Li
         S6QKvIimrL9qPMXdwBr9zOY8qJP72cJc1hOlrk966JdMiz5+1a2SAHfNdmYI0CT4aGD+
         lTbREyGgwO4LXjzsITAc1Kss6pgDYHNGRdFlbWHExLBha0cT++VMO/Oc0t6WqRqMzkW0
         fuilEQoNvTRULvHN5jZnNLuYe/xjatr8YQzMBLMx+fV2VuWDVlFPloU12W9qO1SGDh7V
         QxgA==
X-Gm-Message-State: AOAM530YbuifcNQTIggwfPk2Li0z4Vw44MkNEQdobPlzbOROEB8aEwMw
        eopERuIiIPHjNU6wEUBTxgY=
X-Google-Smtp-Source: ABdhPJzso/R7uH5KOSWGjUb0Tj5Ev9EbsOSXyNouOESQug9hPVpHvoSRUO9LZEr9Cz6hJypUo4k3tg==
X-Received: by 2002:a17:906:f9d1:: with SMTP id lj17mr781607ejb.345.1623367603982;
        Thu, 10 Jun 2021 16:26:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 01/10] net: dsa: sja1105: enable the TTEthernet engine on SJA1110
Date:   Fri, 11 Jun 2021 02:26:20 +0300
Message-Id: <20210610232629.1948053-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As opposed to SJA1105 where there are parts with TTEthernet and parts
without, in SJA1110 all parts support it, but it must be enabled in the
static config. So enable it unconditionally. We use it for the tc-taprio
and tc-gate offload.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 9881ef134666..86563e6fd85f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -675,6 +675,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 */
 		.tpid = ETH_P_SJA1105,
 		.tpid2 = ETH_P_SJA1105,
+		/* Enable the TTEthernet engine on SJA1110 */
+		.tte_en = true,
 	};
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-- 
2.25.1

