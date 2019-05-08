Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17E18117
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 22:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfEHUcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 16:32:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53762 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfEHUcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 16:32:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id 198so257246wme.3;
        Wed, 08 May 2019 13:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yXoCq52WK/5WcKuYnkcEnU7GH27HSxXAXhagjnUgejc=;
        b=rJ7dCHPHmkB6sj3u16jETs4XYf0fqcPTqOHDVXFPOLntCqivEbbQUm9d1T9uWO+Tpk
         5hCXsMg6efy9sYbikWeFBcnYg1xOo8swy2okTitTQXqWjpPNckiN9h49TE9R5FX6ZWTG
         amtKAXsv5KU7NFKr4EglJWGsVGm+M7NIK7PIjluw2i8ZgVODEybmZeBh8nBhJ3oSN9hP
         AFy/04hkuKjdJAZ/DcfydwDXCqYJbnRpFFEI2y1up6esSPp+Ia9tL0zWU3nShKwHphoQ
         KnFzKrtyxpInj0f1UcedH981tHZvKQp8jGHBjFuUFblvZsx/GW4Bp0978DbiatR0jggJ
         IFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yXoCq52WK/5WcKuYnkcEnU7GH27HSxXAXhagjnUgejc=;
        b=Xvc9/2AjVkURVlLaFISLiSanJH+hmR2l5Y+5/eazUU+v4loL2tpnyziEyTWi5uW6zh
         J77pmlMmK6BYACbj8gl0JDtJ5c+a3srOd77C1D8EzKG1CbBDFwr8sbN4QVeGYcr44T/k
         ivTsS+XmCm59HY9TRdeaQGclw659vQ26MRVQ7wLOnco0Cxnuzspdo50NHpwWhgT3pTqV
         TsoznqYIfTRS+W768lakaAVYvLaoieiVuiSf/msIp5exHCr+Got23zgBWNX1nhF2bc+U
         xKv99kNIl0p4DKNfAacZPA8FLFvVlU7vfIMNSr9IwtE2EFRzG/8o3YAUZibcQWPKFrqb
         iIJQ==
X-Gm-Message-State: APjAAAVfGzFl++wM02ZiHbMMwe1v6WgmZJ2oFAcuSgohNBgkcVcZpu20
        4d942ixyVivD8TytN/kI36o=
X-Google-Smtp-Source: APXvYqxDJXnDJQFOBuEh2GQ1jQd3sBskFKWWJ1M1pTTJx19h9ZXdFk6MzyD6KSgbIXLLw3FKXIn+ng==
X-Received: by 2002:a1c:771a:: with SMTP id t26mr134914wmi.14.1557347568058;
        Wed, 08 May 2019 13:32:48 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id d4sm36974164wrf.7.2019.05.08.13.32.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 13:32:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, dan.carpenter@oracle.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] net: dsa: sja1105: Don't return a negative in u8 sja1105_stp_state_get
Date:   Wed,  8 May 2019 23:32:25 +0300
Message-Id: <20190508203225.13275-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter says:

The patch 640f763f98c2: "net: dsa: sja1105: Add support for Spanning
Tree Protocol" from May 5, 2019, leads to the following static
checker warning:

        drivers/net/dsa/sja1105/sja1105_main.c:1073 sja1105_stp_state_get()
        warn: signedness bug returning '(-22)'

The caller doesn't check for negative errors anyway.

Fixes: 640f763f98c2: ("net: dsa: sja1105: Add support for Spanning Tree Protocol")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4ccdbc80f7be..46f76b4c5618 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1124,7 +1124,11 @@ static u8 sja1105_stp_state_get(struct sja1105_private *priv, int port)
 		return BR_STATE_LEARNING;
 	if (mac[port].ingress && mac[port].egress && mac[port].dyn_learn)
 		return BR_STATE_FORWARDING;
-	return -EINVAL;
+	/* This is really an error condition if the MAC was in none of the STP
+	 * states above. But treating the port as disabled does nothing, which
+	 * is adequate, and it also resets the MAC to a known state later on.
+	 */
+	return BR_STATE_DISABLED;
 }
 
 /* For situations where we need to change a setting at runtime that is only
-- 
2.17.1

