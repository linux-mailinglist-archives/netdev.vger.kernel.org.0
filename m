Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92DD26ABC6
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgIOSZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgIOSXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:50 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768AAC061797
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id r7so6408397ejs.11
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eNLxoGrCqT/1fi4nginRZ1whGh9cbvf5JgI3Wa5mNBk=;
        b=KvgTpdc8Zu/zZgIylosbkjNw8urx2XxjO6X+Lcd/Z0lcjxTfdMREXDFjh2LIEdSk5m
         SwD9T8jTPG7TsPIixwfwtdvXBiA811g9yPbh7XV4TaE24BxP2mAUiQc8VW/c8/A7RsQb
         nP83l16RuLKh1xfRXEUQnowgTU3m541U1dpgh6RGp+/ZwWdR5iNx9oeHkzAbpRuESI3n
         fxWYZtwSy5876ISz9trWNh+pdS8W8bsXrxvZEEfmJi6HbmAP7wg/9Oy2DoKqFDB9/Mbc
         hX1BYS8pIM4n+fClzVNr+UhjMif+02WqWXBB9S+o9o6a6tMLbBdCWJjKr/txgvif92Xz
         EMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eNLxoGrCqT/1fi4nginRZ1whGh9cbvf5JgI3Wa5mNBk=;
        b=E+gFsACW5rFeyJQCfe51bRD4dPiViFoQ0tLYqKkiT8ue/QrmXDmvZKGWKP66Ifuz/c
         GZBL0u657/ivEkY1PfoK7R1VPgDThFVY1Ly6HblOOsjpekUgo1+2JkDXUPibqfMa5Nb1
         yzSSW9O0k3U+kLQuysfIF/E6cIfjtHxbTKgWkvgHBoU8uTsRS73p1y3yWgT/+iqgRZ/l
         QepdqJVTMqrw4Jw+UL0HFgzwxVswwfuONBciM+i0BQD1d41paCoKVZPE+Ko9Nq2ZhKFv
         tJ8S3+WJ5PocaPceoV5pjnhZBI515I0sPW/p7c0LspsSHBko4thE42Oq32uDcPifV9wc
         eC2A==
X-Gm-Message-State: AOAM531D08vL0jfwfpjuwMujstdtya0XrIXPvLYhwbV62sv89Q8VmlF6
        HkGMNtCqXeSZP5ei2T8bRUM=
X-Google-Smtp-Source: ABdhPJw5uxe+zFsfiDGyxWqRGvIg1QlPh1f6ThffFrLTlRsmiPNzfS5gPSCkjmpkrXdWAg8WLD1zSA==
X-Received: by 2002:a17:906:6993:: with SMTP id i19mr20718634ejr.26.1600194175159;
        Tue, 15 Sep 2020 11:22:55 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 5/7] net: mscc: ocelot: error checking when calling ocelot_init()
Date:   Tue, 15 Sep 2020 21:22:27 +0300
Message-Id: <20200915182229.69529-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_init() allocates memory, resets the switch and polls for a status
register, things which can fail. Stop probing the driver in that case,
and propagate the error result.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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
index 99872f1b7460..91a915d0693f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1000,7 +1000,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
 	ocelot->vcap = vsc7514_vcap_props;
 
-	ocelot_init(ocelot);
+	err = ocelot_init(ocelot);
+	if (err)
+		return err;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
-- 
2.25.1

