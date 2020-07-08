Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1078B2191C2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgGHUpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgGHUpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:45:06 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA5FC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:45:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b25so52202121ljp.6
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojDpkbjQrjWztNHKGgvu+G2UteIlDr/ArJVF6vvQsJk=;
        b=El4Q5n+po7v0ra5+zSmgGUc6EHuDg+Ju2ewgZ0RTrQKT/Vwb39HLsrY//bLDXcZYHP
         uQTVfGct6ZaZAEaPquElqwqB+x+1/JYgCNyvdnSpHRZzgizmYxCqukaHCosmohZse92I
         rbw/NgIYocxT6paA47n16nGUMni8aNpmaj75x9NvrKIPewJOqdgYW/Fz6KjRpqLYT76g
         Ih+4hPPuGCYdgtTN+0EgEqL44E1fh+ApIBzg1miBlgf1bQh/plJg7cIHjws7FTXL3Fr9
         PLgYgE9gMUjgNspmHR5qwGBAN2Z15+3eUqcHjTFQs0/dwCiEvGygnZBdT+6LYuxgvGi2
         WmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojDpkbjQrjWztNHKGgvu+G2UteIlDr/ArJVF6vvQsJk=;
        b=hpR13NOc7mO1mdaRwXPXgGqLEUWWeA8AIO2/96pb/fA84TSBSnIuFxYi4x7YyyABJh
         23sw4b4/IwfaM5YjiMMuPSpcyQTBonbMxiO6QWYOb/p2/URsUHsj7ONlJ8GuKGP1LCtp
         noJXFkKXP1bKrXqhtUetOJi6hDqXLUZOEJJQ7I24wPH5MC3hDTfE0fApisE1yMfKymBi
         cpOSPzX18pkGSNrCXtNqaB7+9/9CTdEr82QwtkWkLCw6Q+Q/+OxwKAYcxViSdvKEauZx
         u8rhqgWfdMv7zkDLKVJuE3SzEowHSBQaZFeya5hceK6BuJSgP+6EznvXfvQkM3/Bvtyw
         QMhQ==
X-Gm-Message-State: AOAM533Mj3TCk4XEf4RhFciygup0h5u4eeCmTCbxVZQ8b5mWLv0ECuqx
        lfHy6S12L/zzn4O5e16b+bjS5A==
X-Google-Smtp-Source: ABdhPJylKGEAOxr354oLI4xo8WwyHzHhGIBiBIFZM8y4+UHntDL7wKaLIXb4l+AODst12bADF1Ls3Q==
X-Received: by 2002:a2e:870b:: with SMTP id m11mr21650732lji.269.1594241104928;
        Wed, 08 Jul 2020 13:45:04 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id i10sm206688ljg.80.2020.07.08.13.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 13:45:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 2/3 v1] net: dsa: rtl8366: Fix VLAN set-up
Date:   Wed,  8 Jul 2020 22:44:55 +0200
Message-Id: <20200708204456.1365855-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708204456.1365855-1-linus.walleij@linaro.org>
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alter the rtl8366_vlan_add() to call rtl8366_set_vlan()
inside the loop that goes over all VIDs since we now
properly support calling that function more than once.
Augment the loop to postincrement as this is more
intuitive.

The loop moved past the last VID but called
rtl8366_set_vlan() with the port number instead of
the VID, assuming a 1-to-1 correspondence between
ports and VIDs. This was also a bug.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 2997abeecc4a..8f40fbf70a82 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -397,7 +397,7 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		int pvid_val = 0;
 
 		dev_info(smi->dev, "add VLAN %04x\n", vid);
@@ -420,13 +420,13 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 			if (ret < 0)
 				return;
 		}
-	}
 
-	ret = rtl8366_set_vlan(smi, port, member, untag, 0);
-	if (ret)
-		dev_err(smi->dev,
-			"failed to set up VLAN %04x",
-			vid);
+		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
+		if (ret)
+			dev_err(smi->dev,
+				"failed to set up VLAN %04x",
+				vid);
+	}
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 
-- 
2.26.2

