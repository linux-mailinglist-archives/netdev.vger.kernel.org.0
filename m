Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 591AFDDC10
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfJTDUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:55 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44209 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfJTDU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:28 -0400
Received: by mail-qk1-f193.google.com with SMTP id u22so9052135qkk.11;
        Sat, 19 Oct 2019 20:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6L5GXEQf2TmKkQqvOj5hVJ0JGfsrXHOwa855xP48opA=;
        b=nYgFwAfG9IeAPQkw5LGeKx+etzNbngpM1Mld5rAXDsaEkKOIevDO8SUskffzBefvDL
         ek3u2PVhjRsR21BIrJ7TAUcGZM2N2lTKAgL/3zD/VInb8bPuyklhDLU3L36YSI2qXbV4
         WyArz3jTEL9UoqX4byDznnRPMkm/HxofMaPGnanKnTLlBRyHJzcVLATTO5Wttfoae8AZ
         BkX7wd3vAcETfBCtuStGpj21DKjAsWlalr/xJQ6xSffrHkQKNUMACH9cUXcQBkAU82Ui
         vr9qk67uk37CbPi/2NXMD92oYf7di8TOo+MH/HIRNRoRzWbT9iERszFZDmYo0EdJY7b/
         vv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6L5GXEQf2TmKkQqvOj5hVJ0JGfsrXHOwa855xP48opA=;
        b=JMZO2Lrs3YW+jGpIwpA2QASj43PVysXZ1Kfhg9qxI/0akBLewHcI3fIjMYaYxrsNrr
         nNwOlxW9d5+HDqzCcxy0P60zot4BEbrEZvlIKXSqb7ApeSUTmSk+4E6U/ZmhO4J6wZiA
         RYGZBI4aFh4BX0s1K8bvXpT5GesaIZqqzMpv/MPWcR3zET7XnakQDoWsni8oqZ6A6qrf
         xkzD1nVYo6V5JKSi1N691cTAZLA5/J/JJZknD/rrzuhwmLPHI8+Ts5/m1R7K63bbRfIa
         IE5m3sacCB4YOl2s+/YtG+PpNg+aV6iM3AdzyAFtFmxlGXKjd6oSI98Q6QubJ+8/mzf+
         hBbw==
X-Gm-Message-State: APjAAAW7b1tpoDmmcF+nIuLLmuuU10V+hqVN4W1yCRY8ydUlNGPIRZYk
        g/nfB1WQRAgAM6AJkRyoVKY=
X-Google-Smtp-Source: APXvYqzDWDVgJV5SGzc9MSkGZxKdfdxFVN9xTO3RvdAvQLh24QqV3ajaT1nIIbIg9OTjx8rwA3atKw==
X-Received: by 2002:a37:8101:: with SMTP id c1mr16605609qkd.287.1571541627190;
        Sat, 19 Oct 2019 20:20:27 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q16sm2602742qke.22.2019.10.19.20.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:26 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 14/16] net: dsa: sja1105: register switch before assigning port private data
Date:   Sat, 19 Oct 2019 23:19:39 -0400
Message-Id: <20191020031941.3805884-15-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like the dsa_switch_tree structures, the dsa_port structures will be
allocated on switch registration.

The SJA1105 driver is the only one accessing the dsa_port structure
after the switch allocation and before the switch registration.
For that reason, move switch registration prior to assigning the priv
member of the dsa_port structures.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4b0cb779f187..0ebbda5ca665 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2057,6 +2057,15 @@ static int sja1105_probe(struct spi_device *spi)
 
 	tagger_data = &priv->tagger_data;
 
+	mutex_init(&priv->ptp_data.lock);
+	mutex_init(&priv->mgmt_lock);
+
+	sja1105_tas_setup(ds);
+
+	rc = dsa_register_switch(priv->ds);
+	if (rc)
+		return rc;
+
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		struct sja1105_port *sp = &priv->ports[i];
@@ -2065,12 +2074,8 @@ static int sja1105_probe(struct spi_device *spi)
 		sp->dp = dsa_to_port(ds, i);
 		sp->data = tagger_data;
 	}
-	mutex_init(&priv->ptp_data.lock);
-	mutex_init(&priv->mgmt_lock);
 
-	sja1105_tas_setup(ds);
-
-	return dsa_register_switch(priv->ds);
+	return 0;
 }
 
 static int sja1105_remove(struct spi_device *spi)
-- 
2.23.0

