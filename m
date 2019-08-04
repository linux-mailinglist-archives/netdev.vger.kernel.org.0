Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6D880CF3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfHDWj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:39:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33546 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfHDWj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:39:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so82605000wru.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+ybPF93NFmDCg89BYaGli92BPUs/HrRuAhYnb6z8Bys=;
        b=afJIKANfzdRjJcndUSONeoavw7Ufi2NB3LuYuEe+AViqNhiuXQ6jzzC1prmO9YLLfi
         OncOrIHr6l/+okNBcH/tmHNeXHtzh59vF1ZMYFlO+iL0rL1vHn/KlfzUIiEFqES0LoU+
         g7QQY+SSt08DDJf0rce1T/BcTMZ4c8Dqa8EZcDodjHdFfI6C7DJyR8cQYAef66gyYOOv
         JUTm29frrv18oK/a+UjKVT5R4fnFLs25ELNXh5ny0PoLSiAyBXoYvcaHAG8uskcsGHTG
         io65Km4ODhqP0+GNyU1QQCZC4z6LN79JJ6gKsZmVhJ/URnsn4eW6WUPT7Ux8nlca7Jkm
         AgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+ybPF93NFmDCg89BYaGli92BPUs/HrRuAhYnb6z8Bys=;
        b=SoU1PLFgksHArzBOo8TOyNMCQdLsiw1Y1ON6XLh6/W8YnYXOD8zAcpIjSSL1K9+L4d
         peG1i9OLq5hq+q6oarHYQMIXc+y7gbrvWNeJc4/3fXRDfdscwYVK4o69eQEC9+SLhK7l
         WJ2Td1B6aRm4eaqDct30ZwBhEZLkYX33g9ucGMBCxWzTHeRvGAo9ao4VKuYIpn1l7SvN
         ld+gBb4MZOnSSJnJIQPUlL5obCMLtkyE7mJQKjIt/DLFDwB9GtXLr8oeIg08G6fslX/y
         q2svx20nQsc4m0bAahELtFdpTfwcD8xPUgrnleTv+xZQtq+mLYsY7TD4n3oYXiXlyL29
         3i7g==
X-Gm-Message-State: APjAAAVR/gzQRbnU+K4Xpj+aseNFjSWM3iEnMdyN/chlOCF/OFrXgBnJ
        jDq0ujQkE3Veu9bMRmBEBHw=
X-Google-Smtp-Source: APXvYqyTYRurOUcCpHCDgrsz/oJJXJxCte0XoegtPglZB/0OMh0RPbp40eqpPoRYvTBAhzQyfIowvQ==
X-Received: by 2002:adf:f851:: with SMTP id d17mr22318143wrq.77.1564958364860;
        Sun, 04 Aug 2019 15:39:24 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id j33sm187795615wre.42.2019.08.04.15.39.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:39:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 3/5] net: dsa: sja1105: Really fix panic on unregistering PTP clock
Date:   Mon,  5 Aug 2019 01:38:46 +0300
Message-Id: <20190804223848.31676-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190804223848.31676-1-olteanv@gmail.com>
References: <20190804223848.31676-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IS_ERR_OR_NULL(priv->clock) check inside
sja1105_ptp_clock_unregister() is preventing cancel_delayed_work_sync
from actually being run.

Additionally, sja1105_ptp_clock_unregister() does not actually get run,
when placed in sja1105_remove(). The DSA switch gets torn down, but the
sja1105 module does not get unregistered. So sja1105_ptp_clock_unregister
needs to be moved to sja1105_teardown, to be symmetrical with
sja1105_ptp_clock_register which is called from the DSA sja1105_setup.

It is strange to fix a "fixes" patch, but the probe failure can only be
seen when the attached PHY does not respond to MDIO (issue which I can't
pinpoint the reason to) and it goes away after I power-cycle the board.
This time the patch was validated on a failing board, and the kernel
panic from the fixed commit's message can no longer be seen.

Fixes: 29dd908d355f ("net: dsa: sja1105: Cancel PTP delayed work on unregister")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 7 +++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index fd036bf0a819..13c22f51d476 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1725,6 +1725,8 @@ static void sja1105_teardown(struct dsa_switch *ds)
 
 	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
 	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
+	sja1105_ptp_clock_unregister(priv);
+	sja1105_static_config_free(&priv->static_config);
 }
 
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
@@ -2182,9 +2184,7 @@ static int sja1105_remove(struct spi_device *spi)
 {
 	struct sja1105_private *priv = spi_get_drvdata(spi);
 
-	sja1105_ptp_clock_unregister(priv);
 	dsa_unregister_switch(priv->ds);
-	sja1105_static_config_free(&priv->static_config);
 	return 0;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index d19cfdf681af..d8e8dd59f3d1 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -369,16 +369,15 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv)
 		.mult = SJA1105_CC_MULT,
 	};
 	mutex_init(&priv->ptp_lock);
-	INIT_DELAYED_WORK(&priv->refresh_work, sja1105_ptp_overflow_check);
-
-	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
-
 	priv->ptp_caps = sja1105_ptp_caps;
 
 	priv->clock = ptp_clock_register(&priv->ptp_caps, ds->dev);
 	if (IS_ERR_OR_NULL(priv->clock))
 		return PTR_ERR(priv->clock);
 
+	INIT_DELAYED_WORK(&priv->refresh_work, sja1105_ptp_overflow_check);
+	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+
 	return sja1105_ptp_reset(priv);
 }
 
-- 
2.17.1

