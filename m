Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91AE462B9E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbhK3EXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238140AbhK3EXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:23:55 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8319EC061574;
        Mon, 29 Nov 2021 20:20:36 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id s37so8670189pga.9;
        Mon, 29 Nov 2021 20:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fCSTrj/Ah8qdnBVomdm8hlVtn7d/6AtWYHymihwvGjA=;
        b=VXj8vUok0VJa3A92OwcTRlQnwiV6Rp5RqOQ1T5QRsTkRkMFjuxCLARGmF4Yr1avjmE
         HUUDJ9nsGG6kR04bHg8V8eNzB26a0fe0dK2n5i2k/J+rTcS/Tviiay2QTRjSQJDg/Gd3
         dARYQphEvtmCG9n9/wTIx/4MHb3u8+CX2Vp+0uAR+jD0MjgYVRcAzgvtgc6UOA0QklMx
         Cma+f2i0zgbZWFE9pMF4fLSR/Z4dgZ3fchEjQU1B1evpFicyKwsdd/KMb1aO7OSCWNgu
         blASR+DUWlZthN/E9ln5s+L68Ce5Xep9PYBKTTq/BnBftI5/puzEgUQkHx7810b2OP3v
         D53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fCSTrj/Ah8qdnBVomdm8hlVtn7d/6AtWYHymihwvGjA=;
        b=cqauRfn3jY18B0RtJo3UKTtSJzxNVMIAYtLtTS4MiRfyurYIrYlrJSUsnxEDqbNDlY
         VwNzcqppLjiCeV6jnv1CjCRBBRkvuA+ZgqhxdEQcpNYq/wYWTRbTfee4MgP5mzTF+Iwt
         11Wrk0AHg7QLxxzdTbTsdsIhMerF87WkQ9COFiOGz3UEFug4w4ffBi2sHlZhmdZogpaa
         ReWyXMOuEzlnyiGAEDLlW+4oRDjQmE+nGjcd9TH9kJNhwnpfHca/8jlR5mTXY8btv8gf
         KHaeISqXaUaXNdldMfD8xxnUX58p8paCf1G1zQVt69/4j7XEh5rWQvoTGk3T6ygbscV0
         vZog==
X-Gm-Message-State: AOAM530BvUX1OrEu2Q4nSCKCOWOIZTnI7HPZlcdoKkANmEyOVbN2cOIh
        FsFpqFwikw7nh0hwHSIHaxM=
X-Google-Smtp-Source: ABdhPJx1KIzIBda81s5eRywA7YhzAb/SraPtKnO+FhQwPRWUTmcDnPbQAdlr4lB8xHzryxxY16aWXQ==
X-Received: by 2002:a63:8749:: with SMTP id i70mr24621682pge.511.1638246033833;
        Mon, 29 Nov 2021 20:20:33 -0800 (PST)
Received: from localhost.localdomain ([94.177.118.4])
        by smtp.gmail.com with ESMTPSA id d7sm20388971pfj.91.2021.11.29.20.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:20:33 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dpaa2-eth: add error handling code for dpaa2_eth_dl_register
Date:   Tue, 30 Nov 2021 12:20:21 +0800
Message-Id: <20211130042021.869529-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit bbb9ae25fc67 ("dpaa2-eth: Register devlink instance at the end
of probe") moves dpaa2_eth_dl_register at the end of dpaa2_eth_probe.
However, dpaa2_eth_dl_register can return errno when memory allocation or
devlink_register fails.

Fix this by adding error handling code for dpaa2_eth_dl_register

Fixes: bbb9ae25fc67 ("dpaa2-eth: Register devlink instance at the end of probe")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 6451c8383639..4bb2b838fa50 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4442,7 +4442,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	err = dpaa2_eth_dl_alloc(priv);
 	if (err)
-		goto err_dl_register;
+		goto err_dl_alloc;
 
 	err = dpaa2_eth_dl_traps_register(priv);
 	if (err)
@@ -4462,17 +4462,26 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	dpaa2_dbg_add(priv);
 #endif
 
-	dpaa2_eth_dl_register(priv);
+	err = dpaa2_eth_dl_register(priv);
+	if (err < 0) {
+		dev_err(dev, "dpaa2_eth_dl_register failed\n");
+		goto err_dl_register;
+	}
 	dev_info(dev, "Probed interface %s\n", net_dev->name);
 	return 0;
 
+err_dl_register:
+#ifdef CONFIG_DEBUG_FS
+	dpaa2_dbg_remove(priv);
+#endif
+	unregister_netdev(net_dev);
 err_netdev_reg:
 	dpaa2_eth_dl_port_del(priv);
 err_dl_port_add:
 	dpaa2_eth_dl_traps_unregister(priv);
 err_dl_trap_register:
 	dpaa2_eth_dl_free(priv);
-err_dl_register:
+err_dl_alloc:
 	dpaa2_eth_disconnect_mac(priv);
 err_connect_mac:
 	if (priv->do_link_poll)
-- 
2.25.1

