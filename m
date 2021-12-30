Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44605481C03
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 13:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbhL3M0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 07:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhL3M0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 07:26:35 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DBEC061574;
        Thu, 30 Dec 2021 04:26:33 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 196so21284720pfw.10;
        Thu, 30 Dec 2021 04:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=AlZcCMoJjFYZAvzPn7pUk3yUkEsqxoQZGmBCqnTuRDc=;
        b=jBhp7aBh2xdhDcSElxrQTbeRh/3NtfT5iCVD7X+bsfTaSMoJFqaCZkYYxC5TAE/k7Q
         6dfcpV8HNhYgEZ1GjAThFKvm/Jw7pSmXk1Nbl/QkiCQDz0vP8DBImv80Czf+lTd7BSmt
         VJVgQ+ASW/DeXvqDokJ6OQNv2+saZNszU5pBp0U2K/Bg1BVCDd5siwE6S0849z5U0SXU
         NpglYR1xDtrIOpinjGQvXo8p0kVNdJx657+8KAQ3JCFtRcBB62nRfShIzYkoVCl76qKM
         PRrIKtu4L+PXNtm+lqyk7SSSYv2VugEraDvDjFGEWYiKgwaIfFoCJAsJHukXuHD2WF1t
         pBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AlZcCMoJjFYZAvzPn7pUk3yUkEsqxoQZGmBCqnTuRDc=;
        b=VNrxXUHQRD4MFakgGPCj3jUWOKvok+ztidQG5w+HsePp/xAIpssL4ZlVp0yGclvRbj
         8WzQk8aE6joX2NPnNHv+/jCphzgi/pJgPoC9gv2ItcdgkRTBugG77PPeuxUnmzBGGfl8
         hdAzIiO91pMZX6q95bFAZr5PhNcL9vO+TdKGFDHEqvAzR/RDcQXlBuRxUxiCPJhCUWij
         oeaYg8tfGod9Wd4cP0ZBziLAEEWZGGNApNWz6LkNZ7zlBeFZp2YNJnAWLCQRrmiUY9+i
         aqhYPng8IaoW+YOGUbkLZtALELcRciDjjE9aYZdI0F4yjyxRNYwMr4rt/hunJ6yv7w6A
         aGpw==
X-Gm-Message-State: AOAM530/fe1nb/9swhNlBorb6EFZ1Njws9Y8L9+F4KHrNy3jRngqZNr/
        a6iRCkzPLkq8Hrqouhtbweg=
X-Google-Smtp-Source: ABdhPJzkTgfsMIIczH49mDOaUK/Jh+DGJr8H5IQFN56Sn9GyI6DvZHyXx8xqMbG0KRBdIS/TuDNR3A==
X-Received: by 2002:a63:413:: with SMTP id 19mr27372546pge.382.1640867193163;
        Thu, 30 Dec 2021 04:26:33 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id w9sm22452943pge.18.2021.12.30.04.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 04:26:32 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igal Liberman <igal.liberman@freescale.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fsl/fman: Fix missing put_device() call in fman_port_probe
Date:   Thu, 30 Dec 2021 12:26:27 +0000
Message-Id: <20211230122628.22619-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the and error handling paths.

Fixes: 18a6c85fcc78 ("fsl/fman: Add FMan Port Support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0dbc7d..4c9d05c45c03 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1805,7 +1805,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	err = of_property_read_u32(port_node, "cell-index", &val);
@@ -1813,7 +1813,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
 			__func__, port_node);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 	port_id = (u8)val;
 	port->dts_params.id = port_id;
@@ -1847,7 +1847,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	}  else {
 		dev_err(port->dev, "%s: Illegal port type\n", __func__);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.type = port_type;
@@ -1861,7 +1861,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
 				__func__);
 			err = -EINVAL;
-			goto return_err;
+			goto put_device;
 		}
 		port->dts_params.qman_channel_id = qman_channel_id;
 	}
@@ -1871,7 +1871,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
 			__func__);
 		err = -ENOMEM;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.fman = fman;
@@ -1896,6 +1896,8 @@ static int fman_port_probe(struct platform_device *of_dev)
 
 	return 0;
 
+put_device:
+	put_device(&fm_pdev->dev);
 return_err:
 	of_node_put(port_node);
 free_port:
-- 
2.17.1

