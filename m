Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7562ED3A6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbhAGPim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbhAGPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:38:41 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13775C0612FA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 07:37:46 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qw4so10175503ejb.12
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 07:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wSlTJH1IrQjIkK9wwXjQD9+RWIaWzujTlZiX0OHScDg=;
        b=NzCzD4oGhNVAVswGn7+wiM33zT0B+bzf6SM8f285F9fX90+/l0j3Y6xMOLGYDOaxeR
         l+dOJs96rWudAHDOBIi6SxnNIZkz5kx4Df52vta4mUqfxtmEBWAT9lYZzOzwmgj3jRmx
         ZdTxfRC1RkMJGtrdk9eLaTtIfcKyG96AgAHRCNim7C7uadvQ8Ambxy6S0ikNJQQwNxBH
         2stozVYoEe2caBnbUovT3gg4d6FRiA9YFb6SMo4qWCwXoV/Itqj+PZ/bLJe74zLVzFmj
         W7N3AEjs8mICEjmfvHH7VgQQrtuAv8rEwsWkn+/7QiFxlGzBulCmRydQemDsdVowPoX4
         5YrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSlTJH1IrQjIkK9wwXjQD9+RWIaWzujTlZiX0OHScDg=;
        b=eOoLkQsBBUrjffLWh31yryycOatWW/UuqffWeT244FzVyB6L0m0OwNCReSwwRXTbXR
         HxM3tkIFWXIMZkyJNXOYaIc+57+37O90JVc22GiG+lEt+2a1RKfKyccovBsWBPzoDC5F
         UNYLb4aho2YQxCpwAJlNpEOcsGmDoGN1m2alLX7Su92KKhJf25xbMwMZ5j/Hl4OTJ8O/
         QcIqpIVjz0Q54liBJhSnIPyiMAscwBur2UJCxgQ4ZQk62ZFrWr5j55mU1jca9Mq8t9Md
         XxhTkNyfAPTlb5cmA0UWdw98i0nAUjf6ua77/yTHx9nmZKfYftO3SQej2W/WY3ioXelC
         Yt6g==
X-Gm-Message-State: AOAM532Kugpem4dWeApazO7ahpjYQGd0tQlgg2KFH64DG374OdXg9biC
        mKydseFUwr104031XDmOBmZUXG/h2uMMYQ==
X-Google-Smtp-Source: ABdhPJxspatP0cPspUU0wLc4oItmIea4ARC27R9DvqSe6hMRP9BZPl5gAAErYMLEL6MZxjjruD/ghQ==
X-Received: by 2002:a17:906:b56:: with SMTP id v22mr6700514ejg.145.1610033864793;
        Thu, 07 Jan 2021 07:37:44 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z9sm2574898eju.123.2021.01.07.07.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 07:37:44 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 4/6] dpaa2-eth: retry the probe when the MAC is not yet discovered on the bus
Date:   Thu,  7 Jan 2021 17:36:36 +0200
Message-Id: <20210107153638.753942-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107153638.753942-1-ciorneiioana@gmail.com>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The fsl_mc_get_endpoint() function now returns -EPROBE_DEFER when the
dpmac device was not yet discovered by the fsl-mc bus. When this
happens, pass the error code up so that we can retry the probe at a
later time.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f3f53e36aa00..3297e390476b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4042,6 +4042,10 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
 	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
+
+	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
+		return PTR_ERR(dpmac_dev);
+
 	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
-- 
2.29.2

