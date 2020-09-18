Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2E26EA49
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgIRBHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIRBHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:41 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70577C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:41 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i22so5844451eja.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JhTFGyHSOYaDmD7ZbQ4GySgnyfZ0q7Iyo42XR1Uixhs=;
        b=C9ATBbyM3A7zv712Gcu8I7X04taxbRcI8OrjDckjme0y9CQJeg1jMdvxCVDGfgkFEw
         yw/PqvcrWs0+c2mcl1qKPtDmdPExKhjqCgD/MwDpxeYcqUQnXP5nejINyIJ1D/uijUrH
         z2UyclUGNmGZaWwYEPm0b5HDYeO871CRDDYEbvKRI6K384xv/9BaFOQOcW6JestISB75
         qyO+PgLeww3MGsBMbUvq2nAQ+Vjw5njUq9RYg7QumLuNbm40zy8UgtDbHRUaXMp8twWb
         UsHgR25gZGJEFsJsngQMlI6JbiCIa5Mkiyt27JxY4+EKaxmtHcu8OMqOrVXqUpbIKGz5
         yurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JhTFGyHSOYaDmD7ZbQ4GySgnyfZ0q7Iyo42XR1Uixhs=;
        b=Jr56hknDXb0IyoVZxiSFKmRnp0AczxqHkZvpLBuQEj4A/ohCegMV0BBI7SfzO+Kzgu
         uUM8nAwRQgPOALkKcAEQVJjZKCqnh3Jx/x8IAzASAVoluKh0XgJ9G64n8SuyWvxVq37+
         rZwu2/3y63IFs9Y2QdS3tMnvd9R+UgTK2PwEQP6Z7TnV8on+YBN0XOUAhoWYxlmKp4nY
         YT/Vwb/6Pw2nphHB2m8tTjlo4F7MNLoybx371IdV9bP2pmgC91nV2mO5zj4szJ7Ul7Sa
         NwuujYPwxaDU3z83Vnc3KdyKQNGl8YkA85Serjz1F2oE7hH1af24RIaZpp6NlJP5QiXa
         aE4w==
X-Gm-Message-State: AOAM530Z7mbgoRybtrV6sIug9iHk8s1t4MmUtJLo2K3nR/mq5G55dGqP
        E5vC0Xhj6F9EBUKShTGUv30=
X-Google-Smtp-Source: ABdhPJyIkDROlfwHurVgSb6o5vfY6bOFuGWY7PcfanmLZiFR52yEzZeKQzI52Lf1vSxUdLdtzcWLzg==
X-Received: by 2002:a17:906:4819:: with SMTP id w25mr33283093ejq.300.1600391260092;
        Thu, 17 Sep 2020 18:07:40 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 4/8] net: mscc: ocelot: check for errors on memory allocation of ports
Date:   Fri, 18 Sep 2020 04:07:26 +0300
Message-Id: <20200918010730.2911234-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Do not proceed probing if we couldn't allocate memory for the ports
array, just error out.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
Stopped leaking the 'ports' OF node.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 65408bc994c4..904ea299a5e8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -993,6 +993,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
+	if (!ocelot->ports) {
+		err = -ENOMEM;
+		goto out_put_ports;
+	}
 
 	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
-- 
2.25.1

