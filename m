Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496B941F338
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354965AbhJARkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354317AbhJARkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6D1C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x8so6762086plv.8
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OJccT3yh43x+0KpL8YBSmPSFH1USD3/pDREf3Taj91A=;
        b=VcGgjul/qKZXSJ5JmW5AP5jbOO1JbhcV76xCz8mJFIz5EgBR2M2OVshS3yuqRKIB5/
         5fmXjscOsL/hvShKagcPYgi7+1yYlJUeYc45tdK8iZehVevqwRgF47U90wDl0UtKwO9n
         2moBl4x7LJ4S4fNGsekXoV87hmr1sUtyLi3Nm5GnVyuXtx9+BQkjFAr/vF0sVhQafi5G
         zUzkxnpcBLvyODYG9AyUinNhJviVYSoz5t5qrLyCqIV2SzJsvRj5DDqWkq0unQyiLSKh
         j4HY8dSEXjPDzDQnSxN7htsR/DWYKbrnqOCkQ0lJA+cG09ePsaQ7rwViCoZutMYFVkyk
         wa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OJccT3yh43x+0KpL8YBSmPSFH1USD3/pDREf3Taj91A=;
        b=Tc43FeM/g974aoJjw7KnWY5jJDT6+xZpB63+fB8MgwTH7UJR9mID4ah37r1khL/YRj
         F2CezJpEJhM7br9dJLMFAWQjxx0wQAGkPHdF89DICMokGFlBb/0gFgWeXmMGQVFsHmdk
         igpF7qyS+l/wkfHUuMfKkmRyC9pBE/9hQ4dxlEI88y3i5bIRHQpT1hquGSzX6XSft9hY
         5MRZYyImwwvbu0RD1TecpEWqwKFJSW+z+drxfs1BbpD8JaR3iojqf4L9e38wBE7ZdzpO
         +coZm/T8iyQsmQqf0fYFpKvX4+ly4OiKZGuvAbT4+bO842SpjaFaYIX8Mx8K/GFjJVER
         vFLQ==
X-Gm-Message-State: AOAM533pkeOwKp5DThZrpF1dUh1lALIRdss6x2cWmPvcQjJ9+v1WZqZS
        HPjUMrzIG+AWgSkqyvsHDGM3uA==
X-Google-Smtp-Source: ABdhPJzWpDbrpz3ZEZermykfbDReEI8CRNOJIi/z0bDmnglk+cCUSPiv+yEQfcktU23C58tEZT+lQQ==
X-Received: by 2002:a17:90a:181:: with SMTP id 1mr14686817pjc.214.1633109908436;
        Fri, 01 Oct 2021 10:38:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/7] ionic: check for binary values in FW ver string
Date:   Fri,  1 Oct 2021 10:37:53 -0700
Message-Id: <20211001173758.22072-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the PCI connection is broken, reading the FW version string
will only get 0xff bytes, which shouldn't get printed.  This
checks the first byte and prints only the first 4 bytes
if non-ASCII.

Also, add a limit to the string length printed when a valid
string is found, just in case it is not properly terminated.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_main.c    | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 6f07bf509efe..b6473c02c041 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/utsname.h>
 #include <generated/utsrelease.h>
+#include <linux/ctype.h>
 
 #include "ionic.h"
 #include "ionic_bus.h"
@@ -450,13 +451,23 @@ int ionic_identify(struct ionic *ionic)
 	}
 	mutex_unlock(&ionic->dev_cmd_lock);
 
-	dev_info(ionic->dev, "FW: %s\n", idev->dev_info.fw_version);
-
 	if (err) {
-		dev_err(ionic->dev, "Cannot identify ionic: %dn", err);
+		dev_err(ionic->dev, "Cannot identify ionic: %d\n", err);
 		goto err_out;
 	}
 
+	if (isprint(idev->dev_info.fw_version[0]) &&
+	    isascii(idev->dev_info.fw_version[0]))
+		dev_info(ionic->dev, "FW: %.*s\n",
+			 (int)(sizeof(idev->dev_info.fw_version) - 1),
+			 idev->dev_info.fw_version);
+	else
+		dev_info(ionic->dev, "FW: (invalid string) 0x%02x 0x%02x 0x%02x 0x%02x ...\n",
+			 (u8)idev->dev_info.fw_version[0],
+			 (u8)idev->dev_info.fw_version[1],
+			 (u8)idev->dev_info.fw_version[2],
+			 (u8)idev->dev_info.fw_version[3]);
+
 	err = ionic_lif_identify(ionic, IONIC_LIF_TYPE_CLASSIC,
 				 &ionic->ident.lif);
 	if (err) {
-- 
2.17.1

