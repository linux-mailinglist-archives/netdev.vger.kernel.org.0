Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B30E3A686F
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhFNNy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:54:59 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:46938 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbhFNNy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:54:58 -0400
Received: by mail-ed1-f50.google.com with SMTP id s15so5696345edt.13
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mEcTY8JwQ7Jt+5N0wuOgBZ93Z7onKrfqbQ3X5Rv0UKE=;
        b=SGJZ8v5zhEBs2b58Ck8ty5DvAqjGp7Ju5zNCX5YMBsYLE1kPRyWRWoLpeZoZF86QW8
         cxt8UwLwYzpc8p/xHEvZuitX/f3gG6HnHIGUF9Vf5r/eZiG+PLKvTROjM97eKF3pWmy9
         Bvvh/UhTRgqTUpmfX8T3+01g73JCPyKaxXdtrpg00hcwlMu1u33VtEjQfb2HuBBnaxv3
         C37KIuOxJWXGIQA/Koy67G13d9yQC97dmC50vWZX+o8D5vIW+bGZe2ZtKUab3Xr9ajiH
         yqX38KtyrobACd7G0ElSSsMRQSZ4D56CTZuBCTW4AwRy35N95gKe567ficG9rNl9JxUc
         B11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mEcTY8JwQ7Jt+5N0wuOgBZ93Z7onKrfqbQ3X5Rv0UKE=;
        b=Nwi54T1g+vdTFt3CxO06xdWdfpS0sm+GQbhyut9/vrRGMNYfUKpkpVSV9ezn5BI8hb
         TUFapDu82O0nA7Zh2ZWLObmgLMPngmkdP8gptpNlrHlE6vQ0r/rDZZgNDDFxIa1DEzvQ
         j3Lb2Ydn3SHEk4riOIl0mgYXmx2o9O2R7sl/isUFBNnUrbVeO3XJCmSgNOWvzV4im4wX
         fJeOzr1K0ui8LHGSD1MToKW4Uhr2kN+nDMQJJcLZdmcL/btpEpR2FSxrrpkaF5DygnGA
         tJMDXA9Uc1PuBNv7LgJVPrL22EyWMcSVoDHuPAZDYDdGvtEQqSyrczhlIlGCZuuNNSVZ
         GvOg==
X-Gm-Message-State: AOAM5308oooMojaW00JzkvuWzfGI6GzlnZ9e3VStMgVm5BsKcZ4/vFCk
        4Ac6/C0kmL/6VUGrwXvJ7vg=
X-Google-Smtp-Source: ABdhPJzscNpGo73E2g/iRnCS3mni9USPp2DnqS48jauE/KjMyQB5Qqmp5nP8RlQxUu8Xvvrv0vaE+Q==
X-Received: by 2002:a50:ee18:: with SMTP id g24mr17213700eds.11.1623678715121;
        Mon, 14 Jun 2021 06:51:55 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id de19sm9120780edb.70.2021.06.14.06.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:51:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: sja1105: constify the sja1105_regs structures
Date:   Mon, 14 Jun 2021 16:50:50 +0300
Message-Id: <20210614135050.500826-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The struct sja1105_regs tables are not modified during the runtime of
the driver, so they can be made constant. In fact, struct sja1105_info
already holds a const pointer to these.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 7c493c6a839d..4aed16d23f21 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -404,7 +404,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	return rc;
 }
 
-static struct sja1105_regs sja1105et_regs = {
+static const struct sja1105_regs sja1105et_regs = {
 	.device_id = 0x0,
 	.prod_id = 0x100BC3,
 	.status = 0x1,
@@ -440,7 +440,7 @@ static struct sja1105_regs sja1105et_regs = {
 	.mdio_100base_t1 = SJA1105_RSV_ADDR,
 };
 
-static struct sja1105_regs sja1105pqrs_regs = {
+static const struct sja1105_regs sja1105pqrs_regs = {
 	.device_id = 0x0,
 	.prod_id = 0x100BC3,
 	.status = 0x1,
@@ -479,7 +479,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.mdio_100base_t1 = SJA1105_RSV_ADDR,
 };
 
-static struct sja1105_regs sja1110_regs = {
+static const struct sja1105_regs sja1110_regs = {
 	.device_id = SJA1110_SPI_ADDR(0x0),
 	.prod_id = SJA1110_ACU_ADDR(0xf00),
 	.status = SJA1110_SPI_ADDR(0x4),
-- 
2.25.1

