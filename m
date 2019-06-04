Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4AE34E6F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfFDRJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:09:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50233 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbfFDRIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so870172wme.0;
        Tue, 04 Jun 2019 10:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I6Idixnme1vEn/kW5zpL9KgwW4R7ZFqlP4o7qPM8vRU=;
        b=ol3mAbycYkcJ6f8HyzNsrszRVScmJEStMKGCx1Dy5YZfDG8Sox1LtoMWHO7myGZIA1
         lKSKJIoWpPFngpMklRMsbUAYgANDL+cI0umPnJrFCBQ9zR9DEQOr229eGdMTk/F9Yp0b
         2gl/WIBP0QlibqZWf/z0Ws6gSfKcFQIhubydBGpBvFpilvKA6uD5I2rGSlUO6ucxHdL+
         lpssy0m5rp+7yg47NU6JBWnLub+ykXcuUY4pY/vOMMzwVkeWvRLw3fSAOoRPHMn/y4YZ
         GAuPIy9/SwKFnAq8seGMAZZ8qKNvViUH5fkkpWkATxUWJV/QnpHWvsh9XHln/PZwvI3C
         z7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I6Idixnme1vEn/kW5zpL9KgwW4R7ZFqlP4o7qPM8vRU=;
        b=SIik90Hk+pDO1fMV/0xBkjwNvOcXicmawtqr6aSUJRqn916V8dOU8RnchlAYrdsjRe
         UdCX3q2IOUN2Ex43Y21fYco+TMTQxjrNmRj9PyKZrx1M0qaMhU8aPR9Ij/8ii6lBbJCY
         c+v/jYNXUa3/W9LnK1p0cFMxG1cQLxjqSIRaos9JmiMeYSkdapt6/O5MBja+hHh2BQw5
         8UyMuzSNwfk3RHk3+/TA0uBWvi5JqPl7UsEz3bkku9TMDcOGi3YBCT2hr9WSZCWhQBVD
         Gs+bV5EOSoeGJfc0murwP88DztMAGIdS47CF0ReFM0fxYhP2dncziMMG1ooKkY9gR1nc
         MwQw==
X-Gm-Message-State: APjAAAXTv2/dYi6v6AkGC1UjTKJS3jiHAyR+P00uPRAj1tbpHW79LBux
        Ci3boDAG1IwQ1Qi1WZiC1HZ2elEnTBU=
X-Google-Smtp-Source: APXvYqzDLu5LgeNOWIrUnChpWET0Nr/leyAcjlptnG5yb9BSCZw8tSk75PkHT45uKhd0xdwyUg76Mg==
X-Received: by 2002:a1c:cc19:: with SMTP id h25mr6777930wmb.167.1559668088741;
        Tue, 04 Jun 2019 10:08:08 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 05/17] net: dsa: sja1105: Reverse TPID and TPID2
Date:   Tue,  4 Jun 2019 20:07:44 +0300
Message-Id: <20190604170756.14338-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From reading the P/Q/R/S user manual, it appears that TPID is used by
the switch for detecting S-tags and TPID2 for C-tags.  Their meaning is
not clear from the E/T manual.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 909497aa4b6f..0f34e713c408 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1421,8 +1421,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	if (enabled) {
 		/* Enable VLAN filtering. */
-		tpid  = ETH_P_8021Q;
-		tpid2 = ETH_P_8021AD;
+		tpid  = ETH_P_8021AD;
+		tpid2 = ETH_P_8021Q;
 	} else {
 		/* Disable VLAN filtering. */
 		tpid  = ETH_P_SJA1105;
@@ -1431,7 +1431,9 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
+	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
 	general_params->tpid = tpid;
+	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
 
 	rc = sja1105_static_config_reload(priv);
-- 
2.17.1

