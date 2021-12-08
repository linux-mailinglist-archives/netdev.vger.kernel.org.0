Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D136046DAAF
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbhLHSIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhLHSIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:08:52 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B32C061746;
        Wed,  8 Dec 2021 10:05:20 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id p18so2374866wmq.5;
        Wed, 08 Dec 2021 10:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Epbrex27NOi0XD/ZzoUeut5KbCRaCgt3Myqrw3XtlNg=;
        b=B2igHsE9as6KzVFRPLpO3NK2UU58M5j8PZncUaimsB/6ET+PXR4euTL7WnEAm6z5mf
         Mp3+PUVW7aeipdia7E/XKOIVF6/cY41NjPbY4XJ7PVbB8h95l0idEPOMnFHrx1bgeaHY
         NISDWk8Ug7J59rYt+kRhioclh8FypGnSAHUbNRo6NXhOUJwRq7oN4DqEsslU1hdVgTYn
         vJh4YZ1TqUlb7k62dpWW75ZDSf5vernZA0q6NH+4Koi63Ne3WbP42+Zboscb3somyy3g
         ffxReH2C249oHL/esLZyFTLPawrOe6i04nTZ93rk4MXR1CL1+l1gTNoFS3q1gRLN3E+T
         7veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Epbrex27NOi0XD/ZzoUeut5KbCRaCgt3Myqrw3XtlNg=;
        b=tS/ldp9/Q85Qs9maEnvFSYyBqfBZs4MQwVoBRO1hA6OB6kdZDJ7rBTYTUgb6GoOW9E
         m6OvDgnaqTf5XJ9+ZdHWLQIJ9CHBOxjEbdIjk9vAfGWXwcIpJ4nJRuUwiB9X34A5iWBj
         uKpNNn5oh1x7vVGxmDxAi07SCtnhoTCEbgkLGozMektFjHGPI1NWEpYQNHoXir8ynQUY
         kANZlu1j8FSkpPDVyyLMIdECF/9j0iH9ZsHWd5+oX4yYbpO5xcth0LbScCEZsLUq+KxP
         OkA6x9DWS/n66VxEWij3g8E6S6P8qcDxtr86trr/nvq3y1AxdLkO6K7MkVNfpchtYlb9
         YMaA==
X-Gm-Message-State: AOAM532w1aC4obbD60qNlrPpMzimCEQbj2RpgJXx7dwLzHooe/4CrK8V
        B5X6vsNlwfAb5b07wjoPkDw=
X-Google-Smtp-Source: ABdhPJxSdpjBTx/WSo1iSIRFMScmG3ewnWJxqlZ0uMU8Ueney88faJcFCy8iUQMaGehddwv7F7aBSg==
X-Received: by 2002:a7b:c452:: with SMTP id l18mr227305wmi.46.1638986719059;
        Wed, 08 Dec 2021 10:05:19 -0800 (PST)
Received: from localhost.localdomain ([217.113.240.86])
        by smtp.gmail.com with ESMTPSA id n184sm6459185wme.2.2021.12.08.10.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 10:05:18 -0800 (PST)
From:   =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
To:     vladimir.oltean@nxp.com
Cc:     claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH] net: dsa: felix: Fix memory leak in felix_setup_mmio_filtering
Date:   Wed,  8 Dec 2021 19:05:09 +0100
Message-Id: <20211208180509.32587-1-jose.exposito89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Addresses-Coverity-ID: 1492897 ("Resource leak")
Addresses-Coverity-ID: 1492899 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
---
 drivers/net/dsa/ocelot/felix.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 327cc4654806..f1a05e7dc818 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -290,8 +290,11 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		}
 	}
 
-	if (cpu < 0)
+	if (cpu < 0) {
+		kfree(tagging_rule);
+		kfree(redirect_rule);
 		return -EINVAL;
+	}
 
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
-- 
2.25.1

