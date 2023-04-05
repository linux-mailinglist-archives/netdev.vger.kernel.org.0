Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541FF6D7467
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbjDEGdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbjDEGdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:33:09 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D9F30FF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:33:08 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d20so4679325ioe.4
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680676388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DVEvhQ63v2M8qGMNfqrKQ30XTMTVWTaguYlJhV5s4BY=;
        b=mZ8B1QOEIdhtqQEU3KFDl0C4NSq+9hcnsWKxJS+uUznfpbmwdq8jmW8cON38YzWLPM
         70DQKGTzh6VcFAwuRdUdtbzN8iyJnB7kMxePT8A0yBQReOTHdxssJlpqY5VKwUfDFFjk
         pTrHq3jj1jgVK4qeae3tCEG1655cZy/ftveXRptXIpCUM3pphbcPhdAFzhqonM3UmryZ
         TlWKKmYY+49omYElACnv0J3k/agjL20GtTZvs49YJO3VpENJcWFzFdDIEu1bE9tqxVlS
         /qb7EHmWk8qlEpzTvB4DjbjGnIjEbS1hE0wlIDsEA+hz6OvykVBv9UktwpRSj0yj+aOD
         fKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DVEvhQ63v2M8qGMNfqrKQ30XTMTVWTaguYlJhV5s4BY=;
        b=FGWMVwZ8UYDqSSdX2tWXf2lRndzAo0xxVLAwoQbVj+WMEmmei0txDMLHz5N1cC8LAr
         fqCmu/Mh+/EUaPGo5/qxI1EtyV9JNKTRCAwzBw4SqJIXNhq1//DUZG/siJRWi5kbKVKS
         MjGt2qKHOYp/4hIZvlbRm7oHpcCGZOd+t7JyINRq0JfIyN01usxK3Np/z5bydqohC5Oo
         ZtEk12epsIexSrnyFNaxi4yExw3KmThtATl5tTRufRl67f1A0R+yKi5wLoT7mMcde2zm
         ojEh3s8PANqcWXL8Da+JO/vvRZbunXKc6RyIvoii+XsGXp4V+oWI2y729a0KdmHDHrPH
         bVzw==
X-Gm-Message-State: AAQBX9dxSAOEgcCioQk+VJSkCO17jM7OOP/ZBgZ39uXpDJBEtro1UOw3
        dSfyb1slHu+E+5NBvY5wi+o=
X-Google-Smtp-Source: AKy350bzANOKaQJjRP0TUnIOBIAaIqrEchpen6ShXmtFUKF190CUya58VCb1a7tA+dPJ4HyaDVO3sQ==
X-Received: by 2002:a6b:ee01:0:b0:74c:8b56:42bb with SMTP id i1-20020a6bee01000000b0074c8b5642bbmr1180347ioh.8.1680676387834;
        Tue, 04 Apr 2023 23:33:07 -0700 (PDT)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id c18-20020a5ea912000000b007594a835232sm3915104iod.13.2023.04.04.23.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 23:33:07 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v3 2/5] Add ifreq pointer field to kernel_hwtstamp_config structure
Date:   Wed,  5 Apr 2023 00:33:06 -0600
Message-Id: <20230405063306.36253-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Considering the stackable nature of drivers there will be situations
where a driver implementing ndo_hwtstamp_get/set functions will have
to translate requests back to SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs
to pass them to lower level drivers that do not provide
ndo_hwtstamp_get/set callbacks. To simplify request translation in
such scenarios let's include a pointer to the original struct ifreq
to kernel_hwtstamp_config structure.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 include/linux/net_tstamp.h | 1 +
 net/core/dev_ioctl.c       | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
index 063260475e77..bbb41f4fe985 100644
--- a/include/linux/net_tstamp.h
+++ b/include/linux/net_tstamp.h
@@ -20,6 +20,7 @@ struct kernel_hwtstamp_config {
 	int flags;
 	int tx_type;
 	int rx_filter;
+	struct ifreq *ifr;
 };
 
 static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kernel_cfg,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 736f310a0661..043f4363c98f 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -255,7 +255,7 @@ static int dev_eth_ioctl(struct net_device *dev,
 static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-	struct kernel_hwtstamp_config kernel_cfg;
+	struct kernel_hwtstamp_config kernel_cfg = {};
 	struct hwtstamp_config config;
 	int err;
 
@@ -265,6 +265,7 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
+	kernel_cfg.ifr = ifr;
 	err = ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
 	if (err)
 		return err;
@@ -281,7 +282,7 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 	struct netdev_notifier_hwtstamp_info info = {
 		.info.dev = dev,
 	};
-	struct kernel_hwtstamp_config kernel_cfg;
+	struct kernel_hwtstamp_config kernel_cfg = {};
 	struct netlink_ext_ack extack = {};
 	struct hwtstamp_config cfg;
 	int err;
@@ -290,6 +291,7 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 		return -EFAULT;
 
 	hwtstamp_config_to_kernel(&kernel_cfg, &cfg);
+	kernel_cfg.ifr = ifr;
 
 	err = net_hwtstamp_validate(&kernel_cfg);
 	if (err)
-- 
2.39.2

