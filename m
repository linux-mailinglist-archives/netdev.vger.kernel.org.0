Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD6B6A32
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfIRSEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:04:51 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34180 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfIRSEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:04:51 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so1421185ion.1;
        Wed, 18 Sep 2019 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=upqoC8c2rSOEKiJW1ZDEjgjfH9qm+uaVc0P9OeAP7Hc=;
        b=HMJ/Xs+F/Jz81h1wXx16MJIjcONMtaLJl29Wci2Qi/GJPzK/I+rAXs/+B9YVaHUdjZ
         5/fF7OyepHwhNpnaiDkR/Pc1Adts0SnIrZVhdcPsAFvK3U/d5EVQee6e/Ma3AsQTwNI5
         SD2Rz7W4Qi012mc4eDiyBeMKcaQNDa4R7nDjjSnbgakvBCVLO8J7o5J0SMiEZi+2zArs
         XM0QKCip2qg5AA/D4S4gKHhir4UwW+hNlRGEv5MdNTmQ7GzBqmJCJ7feSRUxVyFAC3/t
         eDJfQPs37rpL7Fp8lqJAIcyzvMTSuaVQtg9RIJXNa850jrwpYH56JeUYKwpihg2d8QrH
         xxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=upqoC8c2rSOEKiJW1ZDEjgjfH9qm+uaVc0P9OeAP7Hc=;
        b=XpEaJpO2SDTt0kilP4b4bXRPGn+tKdama3n3KQef8dD6CXkULflUBbY8RBS50kcRbM
         db1wPCu0ZpM4ArBCePvl3Z4SxlSg7W2v7ueFKe2ZyoDY1awKKjG4caksiq98VvtAMJPk
         Q8s/JcVQmGmOqqghgziQu84cUmLg4jT2U/rbs3AfHWlUWvQg7hyat+6ttE/5k6KP8DBe
         qXyaWA/kaUGSpUAy1tdgqmXHCfHIy+yjnRhz1qfMcSOY/30PHWIwOVBYdJpDFy0MNWmo
         ot4dxcTLHgQnOk8QrvfXMrQvXuYMJ4eeBhiDeJg3cqSegwVYu1OKkggqnOuQtddu8eSK
         8mIA==
X-Gm-Message-State: APjAAAWIbGciqo1seYPFgme5VXA8/0zysT8E9bwCFWFoyMwjBBKk1pQE
        rY+TWzdFefPVGc357bP9Twr44KTZiL8=
X-Google-Smtp-Source: APXvYqwHs7c0OLT+gaaqTz2saOmiZoGr8G5n1g5ahrJeKQJo+RfAJ5OskK9SLwyF9bQhwlmMk3puuA==
X-Received: by 2002:a5d:8415:: with SMTP id i21mr6605162ion.86.1568829888964;
        Wed, 18 Sep 2019 11:04:48 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id s5sm4931032iol.71.2019.09.18.11.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 11:04:48 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     andrew@lunn.ch
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] net: dsa: sja1105: prevent leaking memory
Date:   Wed, 18 Sep 2019 13:04:38 -0500
Message-Id: <20190918180439.12441-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918172106.GN9591@lunn.ch>
References: <20190918172106.GN9591@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sja1105_static_config_upload, in two cases memory is leaked: when
static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
fails. In both cases config_buf should be released.

Fixes: 8aa9ebccae876 (avoid leaking config_buf)
Fixes: 1a4c69406cc1c (avoid leaking config_buf)

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 84dc603138cf..58dd37ecde17 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -409,7 +409,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	rc = static_config_buf_prepare_for_upload(priv, config_buf, buf_len);
 	if (rc < 0) {
 		dev_err(dev, "Invalid config, cannot upload\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 	/* Prevent PHY jabbering during switch reset by inhibiting
 	 * Tx on all ports and waiting for current packet to drain.
@@ -418,7 +419,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	rc = sja1105_inhibit_tx(priv, port_bitmap, true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to inhibit Tx on ports\n");
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out;
 	}
 	/* Wait for an eventual egress packet to finish transmission
 	 * (reach IFG). It is guaranteed that a second one will not
-- 
2.17.1

