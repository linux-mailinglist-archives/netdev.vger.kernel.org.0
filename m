Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B733B68B9
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 19:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbfIRRKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 13:10:31 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33754 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfIRRKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 13:10:31 -0400
Received: by mail-io1-f67.google.com with SMTP id m11so1053384ioo.0;
        Wed, 18 Sep 2019 10:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IA9cz2cnstDjDE8D3k/wYxfb+Hqrqr8YK2vvcmtOlpA=;
        b=KCwop/hq4bRWNnWJxM5F2WWFTNgjNmfnWBacsxlBJ/pMmVa4OUPyoKd06+aplQJYNb
         ou5CNu0/fmIsE4Atj6k2oJFeBvTDBWM0bo439ypcgyVm7NCeDC59k5PIYVZvwlwAAcMQ
         Lq9VPiCz7Qv6AmRof6NJ/de1sKXx9EtAt4SrjutMDHkMdzTWYjF4z3teasWGVCOoKDfw
         eVbtICMAU+IMFfcOaqvgDqL2/DulmQG89PAW7DGEpoIIVDpvr1BLD06LuJp5SoXE6Evy
         o+J6uzIrCBDw0iaHL9q+6XFOR9GDzJfJ6i+GjmAMRIVNxMZ3I+wtvhQ+xPeNgWNseowK
         lHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IA9cz2cnstDjDE8D3k/wYxfb+Hqrqr8YK2vvcmtOlpA=;
        b=C0eT87lZ3HxrEM1XwFqUltGkdJjSbVRkdH1OXbh0dhvXKujT5KY8JDUGUXdCirPIda
         +5yNvA/XswQLIl5YTD4ZlfykRG7P9h0bMvsL+McU1570v17kyo+yLRNtYawiSocImwqX
         7g+38KAOweuG1/bvZ4zAMSxoVTpzxKbw0iWgK4XxwZITj7WYF/NMwzTLVWtJGyngeQC1
         6Gz+UwD47/3xvIBixFcsNSWK8yejf5pRgxXbtTVPoJKfEhTyjAaJ1CGnPtUEniCy7nht
         ngwMcqhW2jDsXwfRTT4nSajkLt6g/xWRwmnhmfwcVa0LN5tIFQEX92wuwjR/kgpEFLxP
         blJA==
X-Gm-Message-State: APjAAAXpeekrSVOFAdBeOquUDvyTiKY2q0JXuG7n6BQgvxTcHAZhtK0J
        YHejAkMltqpV0fr6GJoD6dY=
X-Google-Smtp-Source: APXvYqw8+zE61o1DexA5bmeWOnlHLLxjRNRgYdM/nL7gk4p7asPonWuQXnAAqMX3GiM4sQHkVp50og==
X-Received: by 2002:a02:ac82:: with SMTP id x2mr6060322jan.18.1568826629493;
        Wed, 18 Sep 2019 10:10:29 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id a14sm863834ioo.85.2019.09.18.10.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 10:10:28 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: dsa: sja1105: prevent leaking memory
Date:   Wed, 18 Sep 2019 12:10:19 -0500
Message-Id: <20190918171020.5745-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sja1105_static_config_upload, in two cases memory is leaked: when
static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
fails. In both cases config_buf should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 84dc603138cf..80e86c714efb 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -408,8 +408,9 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 
 	rc = static_config_buf_prepare_for_upload(priv, config_buf, buf_len);
 	if (rc < 0) {
-		dev_err(dev, "Invalid config, cannot upload\n");
-		return -EINVAL;
+		dev_err(dev, "Invalid config, cannot upload\n");
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

