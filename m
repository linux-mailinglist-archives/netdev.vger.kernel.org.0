Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E194567CD
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhKSCHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhKSCHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:07:12 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F6C061574;
        Thu, 18 Nov 2021 18:04:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g14so35797969edb.8;
        Thu, 18 Nov 2021 18:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5U+fmJZ5z4ee9LAYq89MnpSRpGij+LFUJBmX6S7mdDA=;
        b=EMBhsz7kTfVLqNRNNuECt3JvSen5Khg7xcbsKn8n6OlqgAGB+VF+IS7BAlzaVn+k/P
         e85lueG7xaVjTzUV1tg9oIbxthDnix6ZGoWteSDoth1DPBW54wihjKvaSfjqt8xsCYUn
         Voodk2TG+HiXawX4hd3P/qpKYahWEUAJxSqtPBd+wvMdwrtroJ8NSR2Ief/pnAKvYNSZ
         Qwf49ORF8tYBl0l/yl8RRdePWuSs0I30XM9VowJZFBguetPzeCUyz8/xuIWJZoiP0KjF
         XlxPazs+YKcJzSAN4mgNMZVeYSFmCyJ0DGtxXjX3RscyBDnvmOq11X0TI7LdLvdGB/ZX
         CnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5U+fmJZ5z4ee9LAYq89MnpSRpGij+LFUJBmX6S7mdDA=;
        b=IN7UNe4ZZG08dzXEKLzkdGiXOSPI3/DqKrro1oxzBglQ5I648MgFB6l5SzTLcCtyEv
         2jhOen/ssm5rKVuX2a7SrtUfQzV091ZuvZdxTT5lzAJmTcSsA9hdgWM+bsxgcWF9F1lZ
         4RVlkWwwzvqyzchHwEOr+FI8HTSfGMh+51OtVqeiFGpTnPAe3FPznZAIgWLzTiRi5i5x
         ep7so/BbMM/RqHUtgeIQ/GrHsP0Zjl4F6xpGPGBQjZGTrPJSR3hhxktBQaDDbKvZPc/l
         hYhPWy+Oq6kbgnf+idSDIICqs5J/1A6ZsWT8f4T6EQUvBWLvSH3adtzVFiBIpdJzKxKb
         qPUA==
X-Gm-Message-State: AOAM530Q+cisYg9EjjFJvqB6mT8N4Q2/+VKpDBK/HIBEIYdbATvnBbXy
        xBRCCRcfGbji2kDE6/q4yTI=
X-Google-Smtp-Source: ABdhPJzf5mz+1hgIDMHKvDOG9HsfeLaSKsD0PNHZKvb1XzC3zDDPwDa4SKqQ6TRJA7r2H5+RJV3lIA==
X-Received: by 2002:a17:906:9459:: with SMTP id z25mr2844815ejx.331.1637287449268;
        Thu, 18 Nov 2021 18:04:09 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id gz26sm539610ejc.100.2021.11.18.18.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:04:09 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>
Subject: [net PATCH 2/2] net: dsa: qca8k: fix MTU calculation
Date:   Fri, 19 Nov 2021 03:03:50 +0100
Message-Id: <20211119020350.32324-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119020350.32324-1-ansuelsmth@gmail.com>
References: <20211119020350.32324-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

qca8k has a global MTU, so its tracking the MTU per port to make sure
that the largest MTU gets applied.
Since it uses the frame size instead of MTU the driver MTU change function
will then add the size of Ethernet header and checksum on top of MTU.

The driver currently populates the per port MTU size as Ethernet frame
length + checksum which equals 1518.

The issue is that then MTU change function will go through all of the
ports, find the largest MTU and apply the Ethernet header + checksum on
top of it again, so for a desired MTU of 1500 you will end up with 1536.

This is obviously incorrect, so to correct it populate the per port struct
MTU with just the MTU and not include the Ethernet header + checksum size
as those will be added by the MTU change function.

Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d7bcecbc1c53..147ca39531a3 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1256,8 +1256,12 @@ qca8k_setup(struct dsa_switch *ds)
 		/* Set initial MTU for every port.
 		 * We have only have a general MTU setting. So track
 		 * every port and set the max across all port.
+		 * Set per port MTU to 1500 as the MTU change function
+		 * will add the overhead and if its set to 1518 then it
+		 * will apply the overhead again and we will end up with
+		 * MTU of 1536 instead of 1518
 		 */
-		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
+		priv->port_mtu[i] = ETH_DATA_LEN;
 	}
 
 	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
-- 
2.32.0

