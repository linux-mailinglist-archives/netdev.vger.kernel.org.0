Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A90162982
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgBRPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:35:25 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35479 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgBRPfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:35:25 -0500
Received: by mail-qk1-f195.google.com with SMTP id v2so19907544qkj.2
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 07:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=afX3KgJkWGEW0W8JceKePdfDS4ix1ghc1PEha2UnpqQ=;
        b=b+VqMWcRqMbYGasbeh74gyfhHyS5wGN3hyLrh/sfXi0JsBSuJFfbIZXxLmOnHTOhaS
         xjfeHgNAu8IgUjhk06iRYMJtWMLwpYY7xAilEq0lNkZRqio2kE2m9w+TSwklM0e+axQ+
         3GY7gypVaFw9IjZ7EFl9eaCBlwrv8Twwsv/qo/hJBzZblJ27aDUAttLK5+gYAic6mtpP
         t9S4XdWgXgUuGKUpZa0hXAXQAGb0jX2fetI8Yq2HVBtu1B4LyR/XR/sVNkq0sn0w3Xoq
         bLCKSVsRYiP4DqMKjYD+uKA+vACdUPnebxU+orWVSEXVSFKBPdRof1qjUcNuahh2FsNR
         ShBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=afX3KgJkWGEW0W8JceKePdfDS4ix1ghc1PEha2UnpqQ=;
        b=AQ3gKMx9VvrqV+s6tcF5UibcWMyo3JlY0yyWruuV3KSwFePDuq8OxCtuZE1p1TAT+Z
         nHTN9B/oXPPnNyblJcTm8JptODW2gLgnkI5TQga7pwoEe3pEKsQWLfFWMc8ZHWJULpaB
         rSQ0/fA37BLBNsm02H+/GTMCsYgcooMCrF3rpfPtepjnc+mD425J+zgLHcNO1RYMhZCe
         AqwuTV6Yzbddnm4R68Lp/L3BRPINp8l1CuPehw0YkFpEQ6QhRTSeKXdgoHSJa+u0vgac
         CZ18a1kckinZfsB+oYaJDAGENUMHCwLBjB6aY6RtndMubl5DthY3a0TJuEqnh4+CNIto
         adWA==
X-Gm-Message-State: APjAAAXHctelp7+2xA+H42RwZVaXFSCfLwEU4jw2M2XHdzX4MX3BxeAj
        5XKcv+evGZWpG8d+C5ksH7U=
X-Google-Smtp-Source: APXvYqyx4IAxe2tt5MaGScmYfS2Okgff/t1OOnY/aRXuQqxK1Qu0P5Phhdmp034Bw/Y78sZ5LqtFww==
X-Received: by 2002:a37:c84:: with SMTP id 126mr19674888qkm.372.1582040124235;
        Tue, 18 Feb 2020 07:35:24 -0800 (PST)
Received: from fabio-Latitude-E5450.nxp.com ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id q25sm2064223qkc.60.2020.02.18.07.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 07:35:23 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 net-next] net: fec: Prevent unbind operation
Date:   Tue, 18 Feb 2020 12:34:44 -0300
Message-Id: <20200218153444.4899-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After performing an unbind/bind operation the network is no longer
functional on i.MX6 (which has a single FEC instance):

# echo 2188000.ethernet > /sys/bus/platform/drivers/fec/unbind
# echo 2188000.ethernet > /sys/bus/platform/drivers/fec/bind
[   10.756519] pps pps0: new PPS source ptp0
[   10.792626] libphy: fec_enet_mii_bus: probed
[   10.799330] fec 2188000.ethernet eth0: registered PHC device 1
# udhcpc -i eth0
udhcpc: started, v1.31.1
[   14.985211] fec 2188000.ethernet eth0: no PHY, assuming direct connection to switch
[   14.993140] libphy: PHY fixed-0:00 not found
[   14.997643] fec 2188000.ethernet eth0: could not attach to PHY

On SoCs with two FEC instances there are some cases where one FEC instance
depends on the other one being present. One such example is i.MX28, which
has the following FEC dependency as noted in the comments:

	/*
	 * The i.MX28 dual fec interfaces are not equal.
	 * Here are the differences:
	 *
	 *  - fec0 supports MII & RMII modes while fec1 only supports RMII
	 *  - fec0 acts as the 1588 time master while fec1 is slave
	 *  - external phys can only be configured by fec0
	 *
	 * That is to say fec1 can not work independently. It only works
	 * when fec0 is working. The reason behind this design is that the
	 * second interface is added primarily for Switch mode.
	 *
	 * Because of the last point above, both phys are attached on fec0
	 * mdio interface in board design, and need to be configured by
	 * fec0 mii_bus.
	 */

Prevent the unbind operation to avoid these issues.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Prevent unbind operation.

 drivers/net/ethernet/freescale/fec_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4432a59904c7..12edd4e358f8 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3793,6 +3793,7 @@ static struct platform_driver fec_driver = {
 		.name	= DRIVER_NAME,
 		.pm	= &fec_pm_ops,
 		.of_match_table = fec_dt_ids,
+		.suppress_bind_attrs = true,
 	},
 	.id_table = fec_devtype,
 	.probe	= fec_probe,
-- 
2.17.1

