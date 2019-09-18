Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEFB6DBF
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbfIRUeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:34:18 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33063 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfIRUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:34:18 -0400
Received: by mail-io1-f68.google.com with SMTP id m11so2470800ioo.0;
        Wed, 18 Sep 2019 13:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9IWBIED/c4GASJ038QlDGqu4SqrvxE8hKvwQsqLUZa4=;
        b=QoTKl1+KspclxRLKJs53mnSW3VZpShxdb8ngFjSa/tcyLLEIQSK/Z3SPvePwrlLxWl
         4tDsdL/yg4C88v1jRDRs8YtnzrhgNLGBEONBIZ4ohBftKbiP5k3HPGPDtGcwD/FDRvqd
         +BpjA7o1OrYerTYSMIF+7YmB5vmXKgZY1axiLQHdiD72DkBUBbX4WvjIdHf05ZZ/rOtT
         FXqcB5Gx8gwcSovAYGYg+YK4GFNDxSsxDR8eITORNVcGm92YSbh/Q4CS+8zmcCtjwX8F
         4sVJ/RQDzIlTZTZoH5y4PMX07v/K0rTpR4rCpkfColqKUQ+agEK+N5SYOsWvqEc2Ed9J
         9nfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9IWBIED/c4GASJ038QlDGqu4SqrvxE8hKvwQsqLUZa4=;
        b=qvcIT7JWvl4T9CdjkBVcR5olp728kxBN5cHNBsyyvgmzBrI657++wcvhJOU08KlDw5
         pUCHWXnDnNu0LMV4IONB13tTr7b+8XejXL3sGfi/x/Vusje3bh0uKj0Khe+wZnxBtnH4
         N+T9Dr/fafaDi+sPIf9SZtwS6PvXUpKwu0/ATd04AInACHF3Fnnwn4ntvmP7EaPPqLtd
         giDB4e7iE57Fpfub1kWcRGSvyQH1NWpp7tZUvRkAcrZT1ZtF2jC+GqYpyRNeJ2n2nTev
         CvA2vM3NXkCc1TdP79p8//kP9r4i5q596YCkzC1JeGS/kYrkvpDMQDWfplJ2LBQdqQGo
         YY5Q==
X-Gm-Message-State: APjAAAUex0JfzGuzP9uCWhjFRbaPMV8H8TgWvZ/b2M9VBCDKdGPasBO7
        lbUsICZiqtXBLcEyUPB/POM=
X-Google-Smtp-Source: APXvYqwN5ASPlXHb7Xx0EY4KyrjfxjaU+9gArf7GdctKe87/si6eKNv8O5rgg//yq+Ub4xknEL9fMw==
X-Received: by 2002:a6b:b445:: with SMTP id d66mr3518619iof.269.1568838857077;
        Wed, 18 Sep 2019 13:34:17 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id x2sm5666528iob.74.2019.09.18.13.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 13:34:16 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     olteanv@gmail.com
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3] net: dsa: sja1105: prevent leaking memory
Date:   Wed, 18 Sep 2019 15:34:06 -0500
Message-Id: <20190918203407.23826-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com>
References: <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sja1105_static_config_upload, in two cases memory is leaked: when
static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
fails. In both cases config_buf should be released.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port
L2 switch")

Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during
switch reset")

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

