Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADED638E33C
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhEXJ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhEXJ1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291D1C06138A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r11so31048948edt.13
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rR70am4AsqwLDccH8qea+nzFbDBLYY7dCPQZwgCCRog=;
        b=sGZAdbyHGB9VNwTHW8rZTswNfkIq/6R3lWabD1lJiEmJNSB6SfjjKKjQK083gHIGvO
         sAcTjwZSlMtNb2qmms2AVmmoXveSvSlsiENnVY7tnDot5jI6iff2siu4T041GuAtluHX
         A5tj9sV5bGN+xT+pFMsJXFe9p0u07DvPbLIRsqk87sIO99Fjase24Tzd0dpy07i5bdKX
         pfXzDCwIpaUMjPWmPOVFkK7LKSBVrobBRE+iDPqqZ+LGEx6iiq5xyJFSp30xwOto1ezM
         zLGDkT5fYppFPZtqnXv1Kke0Ovz7s+RUqhy8azOR0HpPQZIbuDlKcnR/DIGsGvruOsfa
         g5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rR70am4AsqwLDccH8qea+nzFbDBLYY7dCPQZwgCCRog=;
        b=NTuoPDHqDcIl86EkE5r9GEseccoSY+Ob0mTFVT7cm2nZe34GRWLmgi/1Y9gUKXr7WK
         PREUXCOj2+OhyGHEz2p6eUWHCyRvDsF2wHkiv+mm91Qtr/HqErxUubHF96HSS7vbnwT4
         EFy5PVQs4BbC953N6fxq5WKLmUZKb0FksljULfKT7cFo1Dtk7SS2ad6bgWg0cLWwS6j1
         ito083oCrdSssXECLuEFuhp4xDzdYqbJeK1hLtiTKU0NQeujSLzXj3T/hVDX39IIJeDo
         Ftb89ehxT4RDPsfiJfH1MufCIgjXD1E2HRUv1H6FMPZkstOGXf8+opWbS3UmJgU92JVZ
         oASw==
X-Gm-Message-State: AOAM5326WjrCppqFt9bYbg4ZWbiFf6f3JD+vfuqLMOSfGqUZjM8jGy9R
        BWR4DePGO7o2tRt8BOXml34=
X-Google-Smtp-Source: ABdhPJwEeVcj0yJz5NFAbLcqFMQndKekz2CtYGlOCO7N9K8k1M17K98cRGKTybnzCVUBspZ+MdLX5A==
X-Received: by 2002:aa7:db48:: with SMTP id n8mr24744817edt.11.1621848335730;
        Mon, 24 May 2021 02:25:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 2/6] net: dsa: sja1105: call dsa_unregister_switch when allocating memory fails
Date:   Mon, 24 May 2021 12:25:23 +0300
Message-Id: <20210524092527.874479-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
References: <20210524092527.874479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Unlike other drivers which pretty much end their .probe() execution with
dsa_register_switch(), the sja1105 does some extra stuff. When that
fails with -ENOMEM, the driver is quick to return that, forgetting to
call dsa_unregister_switch(). Not critical, but a bug nonetheless.

Fixes: 4d7525085a9b ("net: dsa: sja1105: offload the Credit-Based Shaper qdisc")
Fixes: a68578c20a96 ("net: dsa: Make deferred_xmit private to sja1105")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 405024b637d6..2248152b4836 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3646,8 +3646,10 @@ static int sja1105_probe(struct spi_device *spi)
 		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
 					 sizeof(struct sja1105_cbs_entry),
 					 GFP_KERNEL);
-		if (!priv->cbs)
-			return -ENOMEM;
+		if (!priv->cbs) {
+			rc = -ENOMEM;
+			goto out_unregister_switch;
+		}
 	}
 
 	/* Connections between dsa_port and sja1105_port */
@@ -3672,7 +3674,7 @@ static int sja1105_probe(struct spi_device *spi)
 			dev_err(ds->dev,
 				"failed to create deferred xmit thread: %d\n",
 				rc);
-			goto out;
+			goto out_destroy_workers;
 		}
 		skb_queue_head_init(&sp->xmit_queue);
 		sp->xmit_tpid = ETH_P_SJA1105;
@@ -3682,7 +3684,8 @@ static int sja1105_probe(struct spi_device *spi)
 	}
 
 	return 0;
-out:
+
+out_destroy_workers:
 	while (port-- > 0) {
 		struct sja1105_port *sp = &priv->ports[port];
 
@@ -3691,6 +3694,10 @@ static int sja1105_probe(struct spi_device *spi)
 
 		kthread_destroy_worker(sp->xmit_worker);
 	}
+
+out_unregister_switch:
+	dsa_unregister_switch(ds);
+
 	return rc;
 }
 
-- 
2.25.1

