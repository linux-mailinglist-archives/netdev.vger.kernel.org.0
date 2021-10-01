Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7925C41F455
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355677AbhJASI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJASIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2662DC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so7733554pjb.4
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OJccT3yh43x+0KpL8YBSmPSFH1USD3/pDREf3Taj91A=;
        b=5Q5PIqnh9QBeP751EkyAhe/irmNy53+4pHS08+HM9pe5tW/fUtGJWkjRsNbt2D111O
         fCOV0vdaon85GxB2okN3sBMWALmQIsqqcX6A0xaGs4I8jvkh3Bow9L+LiIS9znOq9a/H
         YEe7554RAiVxD45p8xvclwK7C81p0g0AasrtIIWrSB1uWwhqvVWIBkH8uvPpYf5YibwT
         5lKblesCyqk16zZj/VAMvP7jM7R4o34Z9mAJFmClHjRUJZp1HWWeJe8FmVbN72pZrNMF
         ux7BHDDAXcAM8X8KFI49eukr7nQZDPXuWIw1nOg1lzVv6+LphzPHX/lFsjm2DaJ4Oc3D
         4Zlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OJccT3yh43x+0KpL8YBSmPSFH1USD3/pDREf3Taj91A=;
        b=QGMLFzhxmRXzwJgTUyyuBB6WcXZXJVBzaN5FjM7eCbARDrJiJ/UGY83r2/1E5ZJAB7
         Bp3cE3T3D1ZEnwvfgH2Bvr8PHl+qo6pxPWEv7pnJt+JrjAflbXq1PsQaTzkKWNvRlHdg
         ELDNu1zWLmeGAN3c9yGULji+S9ecXWnpCXmMDCzzPXGeJ1bLU4sGACKRsCjcOZNevOV9
         hQrNUtTCTbDjnhy8HXvlElO3EZmexqDoaAcOMH4QghD99fwUn0FLX5fnvuJSskcWURGX
         75dqg3PdMU9D38EbVfv7Zlg4uQknCEZ88KxiNPAgiBCujowAIafO7yDD3mPmA45E1EeX
         zt3Q==
X-Gm-Message-State: AOAM530FQu5sYO+hKkYMLMsTcNPGxAaMlM6h0Ugv+AjX4cY4owsp9c6Y
        i86gPavgH1fZbT0HginCl+nHBw==
X-Google-Smtp-Source: ABdhPJwGDOemLC9xZAwl3FJrdoc9Y8clo2n7nd/luLEjtveVTolw1MCMFPVO/he6ntUL0iSwaQGzlg==
X-Received: by 2002:a17:90a:4483:: with SMTP id t3mr1754202pjg.44.1633111600250;
        Fri, 01 Oct 2021 11:06:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/7] ionic: check for binary values in FW ver string
Date:   Fri,  1 Oct 2021 11:05:52 -0700
Message-Id: <20211001180557.23464-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
References: <20211001180557.23464-1-snelson@pensando.io>
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

