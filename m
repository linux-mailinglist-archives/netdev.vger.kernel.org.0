Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920991D49F2
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 11:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEOJxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 05:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbgEOJxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 05:53:48 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDF4C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 02:53:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u6so1562223ljl.6
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 02:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=2uJwRm7S3b/6ckdE22S4OI30RjnK4rQk4wb497XjJdk=;
        b=OLh0v3IS/HYlPS9+eXRDTlPxEgp7Rrv2hj7wK+BuWnUD5LM5tSHA0LJUy1cNfrsC3j
         oarrL9J5FSvGpMAhXIrrkgno7z0b3IdUzhW6JNWxQmBvV6ewa4SXNNQ1q2P0HEMTGgNE
         Xt/Q7e0oncmakiEUcGK7hEOC0Nwr1r74mvP0Kbu0fp/g+x5LdsLMNPNyh2l0YQOxFThS
         cqlWAoWYoQfYDdO0b+Wm8lkdFcqRHR1sv3v+ihE1cu2S3pengIefJBwP00QRfeqhRYmv
         E09pYWxk5RH2T4G5XfHTKFrwZLhWMGKjvSOUNSY26NE96yoL5LvZi4f1parRIt8spW+Y
         w9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=2uJwRm7S3b/6ckdE22S4OI30RjnK4rQk4wb497XjJdk=;
        b=JNCDF/gmDfuCDyrCuXECUvY2spGEqPkMCjMkZMIEd3mRFQ7IubtusryI/VWCMDZB4E
         9l/0jDW8rmwvm5lFiuxHejoSLjBv2cbEYg1sLn+jmtkpDTvCNdHtSp0hrs5zLeokDBVN
         Y3ZpnwcMDhWInx5GWoLQVxghYT2DpO1uVtzzR0hFbCWlBY1ow1h3CIlEX3iJtPV/ZZiW
         4vbEte4WJoRz4uX/eNy/9HkasEjYpN+H17zrd8aNY/I7XMA3OpceOtygLe8foBX6zqMO
         plJnPtTp0oLPYfcaKuZQ9ubgU6eUdmvmENV7chV+plFD/iAfKct7CI9gmO4RNLn9aTNT
         lFPQ==
X-Gm-Message-State: AOAM531BpQ/wlnG9g5wtdDKgh4FCaFMfB+gmv1wk1Z5dSqINyU1rgMAr
        tJMRiiVqyb6VRvrOATmu8w2aeX38UvdJSQ==
X-Google-Smtp-Source: ABdhPJzTy9jF6fLs1tprX5Ovj5imiRnhrJIPl8O36QfZeLWlootWwoIsCjtDbujEbObB7pltBZJhPg==
X-Received: by 2002:a05:651c:54f:: with SMTP id q15mr1812200ljp.145.1589536423764;
        Fri, 15 May 2020 02:53:43 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w9sm893596ljw.39.2020.05.15.02.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 02:53:42 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch
Subject: [PATCH net-next] net: core: recursively find netdev by device node
Date:   Fri, 15 May 2020 11:52:52 +0200
Message-Id: <20200515095252.8501-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assumption that a device node is associated either with the
netdev's device, or the parent of that device, does not hold for all
drivers. E.g. Freescale's DPAA has two layers of platform devices
above the netdev. Instead, recursively walk up the tree from the
netdev, allowing any parent to match against the sought after node.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/core/net-sysfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 880e89c894f6..e353b822bb15 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1805,12 +1805,12 @@ static struct class net_class __ro_after_init = {
 #ifdef CONFIG_OF_NET
 static int of_dev_node_match(struct device *dev, const void *data)
 {
-	int ret = 0;
-
-	if (dev->parent)
-		ret = dev->parent->of_node == data;
+	for (; dev; dev = dev->parent) {
+		if (dev->of_node == data)
+			return 1;
+	}
 
-	return ret == 0 ? dev->of_node == data : ret;
+	return 0;
 }
 
 /*
-- 
2.17.1

