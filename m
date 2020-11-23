Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA472C10BF
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389766AbgKWQg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732948AbgKWQg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 11:36:28 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7CFC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 08:36:27 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id bo9so18430906ejb.13
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 08:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GYk3dJx34xIhJzh03gWspIBSARbL0ljd6SSr9H+RSk4=;
        b=d6RwES2RUQjTmJQeMK008Ue4vrXe7N1XH3bwqdSCDdwlREdkpbIq2RBG1+JI8v881b
         NyA0aWobqWK10VABaRMxB4Caiv3cbghNsiAI5ZoqAyHnuVTMktOdkSU0PUiqpM4XZHJh
         41pI0fTp8maiMuM47LHcgSuFKA+vyUoTjZ/4IRne+/DvJJbkcP8xX5hsuMC7+AwCttPR
         q5egwdirBlwu7eE9DaJbhpX4h0+c4UR3t77XSYjz9RKD32EwwubIEMEOVBKwhxmJ1RW0
         AiP+AqBsLUoX3RekqHX5Cyl1GbjNb9Re1XckWTvavtrtJde8la2cVP5BGnVbbuKNhezb
         ewMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GYk3dJx34xIhJzh03gWspIBSARbL0ljd6SSr9H+RSk4=;
        b=gDe3DvaI7D+wprS9olUZ0scrRTaG6HgK1mKOprcAruU0EQNSqP5cvkU2tv712n4UY4
         2bdWC2uz8Rd4EHshdN1nxI8nG2YiZgWxDMzyhqWXrB/XM/EEXVdR9VCb7iqh1OnrN6I9
         +5o6948xm3vo7A+28UHVUDUAwwFCGVO6exv4iEB/nYCI4goMcfTyYzhHAyEF0oj03R5d
         SNfmFoW41Jq38A0Jbqi17N2nWumq5Yuhz45a7H5kOSIia7oOibuUl7e6hroGx7lpIPu5
         rCykiiN/Nmoefs4kRX761kQiadOS6UB72DvngQ7Z6Um0Go0azcYo7zsQvel1fajaCnoQ
         lnCg==
X-Gm-Message-State: AOAM5312GFAIMWRCOQsHnVoq59k1QkrJZ79ygVNCpVk6R5VYOYwFcHWy
        3oPs6ZnFt93kQ7h9Qo5XZd4=
X-Google-Smtp-Source: ABdhPJwUjfUjsgzer/Xn8HLd69082y4UjkRXmf21Wj5tkgMGdFp+uqUbJfOQQoB2/t87xk96PeLOUw==
X-Received: by 2002:a17:906:179a:: with SMTP id t26mr395579eje.49.1606149386575;
        Mon, 23 Nov 2020 08:36:26 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id i90sm4754971edd.40.2020.11.23.08.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 08:36:26 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: Fix compile error due to missing devlink support
Date:   Mon, 23 Nov 2020 18:35:53 +0200
Message-Id: <20201123163553.1666476-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

The dpaa2 driver depends on devlink, so it should select
NET_DEVLINK in order to fix compile errors, such as:

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_eth_rx_err':
dpaa2-eth.c:(.text+0x3cec): undefined reference to `devlink_trap_report'
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_info_get':
dpaa2-eth-devlink.c:(.text+0x160): undefined reference to `devlink_info_driver_name_put'

Fixes: ceeb03ad8e22 ("dpaa2-eth: add basic devlink support")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index c0e05f71826d..ee7a906e30b3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -5,6 +5,7 @@ config FSL_DPAA2_ETH
 	select PHYLINK
 	select PCS_LYNX
 	select FSL_XGMAC_MDIO
+	select NET_DEVLINK
 	help
 	  This is the DPAA2 Ethernet driver supporting Freescale SoCs
 	  with DPAA2 (DataPath Acceleration Architecture v2).
-- 
2.28.0

