Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C878226EA45
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIRBHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgIRBHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:42 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E35C061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:42 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id r7so5781026ejs.11
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c64tId5xgICBlbaKMTOJbw93Luv1VYw2PFPoJlPVyqM=;
        b=iHl/EX0sAKx6iB97CRiz83kMaQZ+xG4tGXq0TZyeFSP7Ko1aN3x7ePsZeA3iXmJUcj
         FuMyJhom7qLkSz9y83vfirP3zS+aPeyH8DjzLbmWF9WMgsLJiKwDdSOZS1Gal6Qjq2gP
         sGXXqYQRq3SAro71b/YoipecWxhadA6OlGUX8wSi0AFxTDz/aJSjKsMWS+qGrsz3l/Vr
         Wl7JKMBIwFUTrDaRlDxU/lM0gy+ID34pY7mzwm6MwM7xQfw92K1ulOCmq9KTKSYMusal
         kDh4VK+x6uKWAQAu57GHwklysZfddhK6UBGKfNDd1vHO7nDwz8wX92/dRAJjtPxEmkIi
         V9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c64tId5xgICBlbaKMTOJbw93Luv1VYw2PFPoJlPVyqM=;
        b=b8mJx7y/hn3/RG29Tatfz1Nb1RnAIoD8V/i/qSwHyajiQdNzcrkIj+fpE1MjLiBaOn
         Ol3uk8SKEDYNYuS/w9gaxyDirItYHiBKIi+vRd74Ywb9xUck5hFYB4LL3kavN2cf0IFL
         LwZQ17KEFuytkWmy/sfvS7tZrOS1erF8a6pLdiX7BoNc5qBMkMjZNm0yoO6fu1uC80Ba
         0jA+dwSF6g8QI6B1+LPrlYoNRyQNIE3rqRxNu7gt4oro58xCnD3isOj9f+0CjFWlb1Ss
         p1H/b0H2ik1+HnjFhyBbZZLVWeyrDh3K4RKnAipMvejRr3b17wuLhJRbamThmctbtVFg
         8q2w==
X-Gm-Message-State: AOAM531zScVGFeFK51O01bVLWwQ4fbhIEuW1on4pwEFUOwAB/fBsjYLV
        7Lahi36IJGLfDlVIXvp0SBo=
X-Google-Smtp-Source: ABdhPJxT9ELQBsfK7xNfUdbTqXV5F3IAJA2skwQsy1h6U34CYnYM4R3otGWfdkRF/FSt82iCZLDChg==
X-Received: by 2002:a17:906:6411:: with SMTP id d17mr32843912ejm.93.1600391261231;
        Thu, 17 Sep 2020 18:07:41 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 5/8] net: mscc: ocelot: error checking when calling ocelot_init()
Date:   Fri, 18 Sep 2020 04:07:27 +0300
Message-Id: <20200918010730.2911234-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_init() allocates memory, resets the switch and polls for a status
register, things which can fail. Stop probing the driver in that case,
and propagate the error result.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
Stopped leaking the 'ports' OF node in the VSC7514 driver.

 drivers/net/dsa/ocelot/felix.c             | 5 ++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a1e1d3824110..f7b43f8d56ed 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -571,7 +571,10 @@ static int felix_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
-	ocelot_init(ocelot);
+	err = ocelot_init(ocelot);
+	if (err)
+		return err;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 904ea299a5e8..a1cbb20a7757 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1002,7 +1002,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
 	ocelot->vcap = vsc7514_vcap_props;
 
-	ocelot_init(ocelot);
+	err = ocelot_init(ocelot);
+	if (err)
+		goto out_put_ports;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
-- 
2.25.1

