Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E4B5F2F0C
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiJCKwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJCKwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:12 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2362E5302D
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s2so3398697edd.2
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MLLT0DBq3qYfb0FI3RhPrSoc4c7bXFy4BPeqput8f2o=;
        b=0P8x5tB6qPIv3AWlhYbHt9pRsIncnaesoso6/v9TFH3bxf+YEsll/Cch8cJ09uL9ug
         HRUkrhQRTF2vLp2Wgpo1i/Oe11lwft+P5zSDwOLVQdw14+mz3PBcEfJFaE0durRiTEa8
         7wigcGOc5DWPDhyDfXLgt9XnXrKlHs7O7y73MpvPRDlMz/MEyL//n2UvBGB2OMXm82X4
         YHtFuWXXLmM8zfcroKCj+ULdnxEdoAKkNpCcOrv5XwkeP6Md3zPspn6tc+C7x95F0kyP
         eJ50NiHdT/N0hmaeHkPC/34WHC+D562cTfjegd3ZRLtv37DL8S+3tsu9qffTBRYbpWC1
         n2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MLLT0DBq3qYfb0FI3RhPrSoc4c7bXFy4BPeqput8f2o=;
        b=Wt+EhDk/HAE9BG1b+AFMGj0MLq6uzuM/kXKzIKOr1v3cS1ExaI2quWVaYmWoBX6Ifs
         QF/he67SURXTghlzqlM2br+6dkjNdiBp4lECxmSTH1Ly12602IT0k2/9g22P6Ro3Arxy
         Vpk5nWfXBWwXdg62pnauBPPRXowh/O+QPcmONgTOYO6uJP6chdFZIMeRYTJWowydm+r6
         u0RP1A8BrQOfcg+svlUz+4hmh+iZyC7ayFdebkknVcF5V0f/MaVgbZ25pP8wo12gEYJL
         ZFrIkai9ISBrOObqLO7YXkcsIiNZTnE4/aRh/wZIbkuCkMmbWr8Ks+gVqcPI+hHsUYW6
         RpNQ==
X-Gm-Message-State: ACrzQf3sB8w35G4+/CY2ZYxDk0rTeEzOqE1aw+G68fZIFPExm2/LQm8V
        QHS0Qo0bg5TuZaSy+3ObgP9EFfH2ptrmwmS4NKU=
X-Google-Smtp-Source: AMsMyM5AOAFzFVau2+CxIivkvgORGO9577M362oCwpGLjnGQM6pIvmansc0Nhr3LXJh7GPFsPhmwbw==
X-Received: by 2002:aa7:d556:0:b0:451:f7e6:5121 with SMTP id u22-20020aa7d556000000b00451f7e65121mr18313552edr.188.1664794329685;
        Mon, 03 Oct 2022 03:52:09 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090623e100b0078080a97edbsm5230683ejg.111.2022.10.03.03.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:09 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 03/13] net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
Date:   Mon,  3 Oct 2022 12:51:54 +0200
Message-Id: <20221003105204.3315337-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_netdev_checks() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 63 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 218cb1cdb50e..e49ec10d613f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9994,33 +9994,6 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
-static void __devlink_port_type_set(struct devlink_port *devlink_port,
-				    enum devlink_port_type type,
-				    void *type_dev)
-{
-	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
-
-	if (type == DEVLINK_PORT_TYPE_NOTSET)
-		devlink_port_type_warn_schedule(devlink_port);
-	else
-		devlink_port_type_warn_cancel(devlink_port);
-
-	spin_lock_bh(&devlink_port->type_lock);
-	devlink_port->type = type;
-	switch (type) {
-	case DEVLINK_PORT_TYPE_ETH:
-		devlink_port->type_eth.netdev = type_dev;
-		break;
-	case DEVLINK_PORT_TYPE_IB:
-		devlink_port->type_ib.ibdev = type_dev;
-		break;
-	default:
-		break;
-	}
-	spin_unlock_bh(&devlink_port->type_lock);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-}
-
 static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 					    struct net_device *netdev)
 {
@@ -10058,6 +10031,38 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 	}
 }
 
+static void __devlink_port_type_set(struct devlink_port *devlink_port,
+				    enum devlink_port_type type,
+				    void *type_dev)
+{
+	struct net_device *netdev = type_dev;
+
+	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
+
+	if (type == DEVLINK_PORT_TYPE_NOTSET) {
+		devlink_port_type_warn_schedule(devlink_port);
+	} else {
+		devlink_port_type_warn_cancel(devlink_port);
+		if (type == DEVLINK_PORT_TYPE_ETH && netdev)
+			devlink_port_type_netdev_checks(devlink_port, netdev);
+	}
+
+	spin_lock_bh(&devlink_port->type_lock);
+	devlink_port->type = type;
+	switch (type) {
+	case DEVLINK_PORT_TYPE_ETH:
+		devlink_port->type_eth.netdev = netdev;
+		break;
+	case DEVLINK_PORT_TYPE_IB:
+		devlink_port->type_ib.ibdev = type_dev;
+		break;
+	default:
+		break;
+	}
+	spin_unlock_bh(&devlink_port->type_lock);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+}
+
 /**
  *	devlink_port_type_eth_set - Set port type to Ethernet
  *
@@ -10067,9 +10072,7 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev)
 {
-	if (netdev)
-		devlink_port_type_netdev_checks(devlink_port, netdev);
-	else
+	if (!netdev)
 		dev_warn(devlink_port->devlink->dev,
 			 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
 			 devlink_port->index);
-- 
2.37.1

