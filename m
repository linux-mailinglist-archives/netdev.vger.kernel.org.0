Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34327B6A94
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388835AbfIRSgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:36:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39341 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388801AbfIRSgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:36:00 -0400
Received: by mail-io1-f66.google.com with SMTP id a1so1561464ioc.6;
        Wed, 18 Sep 2019 11:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Yev8SSA/pBVow+fkvqFlYCmI/NlZ+cesqn/X9tiR1+Y=;
        b=rfTBlzZ5qal59TV+Kq9O+lufP4Vo5hp9nQBiTSAsKIPHPz73xXJDX+onAzG6ll5lhz
         hkj2F4b7+drOA20hM410PSSDMSdqlwheCDud5f7jFsxBylSYFIeoMzUqI+3//Uz4ahue
         NYtOsjVrLXrw/GFt7M02RQBSqYBJjNJ/kmG53whi8nUrbKTYywg2avSC26VQcQLrx7tD
         VrRqBLhPIA1H4YIpdhvxqZNVrC3OoYv46eAH3oeriJzjsrief5wNqL1jKOqXtht3gFP7
         KKz2ILY4oKga2AH/0SvrIiz6R6DfiJm9IMBcdD/Rtnkp6WG3+8QObICWTcD9cYgbSVNV
         e/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Yev8SSA/pBVow+fkvqFlYCmI/NlZ+cesqn/X9tiR1+Y=;
        b=dNd51/LYP9rexs89PzFZmerhqv8UfzUjLfE53M0wBGxML+PyxWAIZ/7CqKvYJkWbF4
         ko/hAkxCx+WOfF1HHinNmwdX/x7iLmbSYrOuD1OuFtoZmATl+0K4r0ifTMrm4PDRKhh7
         1gxiSTQtkPUbr786D25KcteQcln7lPwK+wzd/zP1QxHp4uhGJxDjJBIVbIQyQ9dsC2zV
         IwTrKe3elKck0QSIv0CZ7voDpfti9u7DF9kCGNt4EN6MhGx86ODrdtI73o6N35Nwydja
         2z1RMxRwLyIxzUeQirC0/uYaSjrHDeFr71wmiV91FSnaw6lmsBaa0l92B6W0E+T+3wtL
         vUGg==
X-Gm-Message-State: APjAAAXat4Cn+Zq8gx9OlQSjFkLQMIukrsND3HImnajCF6kQI70PESQf
        xYvzY5rCQgP8U0uuysljlWA=
X-Google-Smtp-Source: APXvYqzKG50ZRa+lucTV1pnAagiF0Rp+Szpt127wYbTuhc89xW+Y41XraMv1NXRpGdN9tNAsRgoHGw==
X-Received: by 2002:a6b:148b:: with SMTP id 133mr6636615iou.81.1568831758901;
        Wed, 18 Sep 2019 11:35:58 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id s201sm8348190ios.83.2019.09.18.11.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 11:35:58 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        jan.kiszka@siemens.com, Frank Iwanitz <friw@hms-networks.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 2/5] staging: fieldbus: move "offline mode" definition to fieldbus core
Date:   Wed, 18 Sep 2019 14:35:49 -0400
Message-Id: <20190918183552.28959-3-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918183552.28959-1-TheSven73@gmail.com>
References: <20190918183552.28959-1-TheSven73@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

anybus-s cards use the "offline mode" property to determine if
process memory should be clear, set, or frozen when the card
is offline.

Move this property to the fieldbus core, so that it can become
part of the future fieldbus config interface.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/staging/fieldbus/anybuss/anybuss-client.h | 11 ++++-------
 drivers/staging/fieldbus/anybuss/hms-profinet.c   |  2 +-
 drivers/staging/fieldbus/anybuss/host.c           |  6 +++---
 drivers/staging/fieldbus/fieldbus_dev.h           |  6 ++++++
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/fieldbus/anybuss/anybuss-client.h b/drivers/staging/fieldbus/anybuss/anybuss-client.h
index 0c4b6a1ffe10..8ee1f1baccf1 100644
--- a/drivers/staging/fieldbus/anybuss/anybuss-client.h
+++ b/drivers/staging/fieldbus/anybuss/anybuss-client.h
@@ -12,6 +12,9 @@
 #include <linux/types.h>
 #include <linux/poll.h>
 
+/* move to <linux/fieldbus_dev.h> when taking this out of staging */
+#include "../fieldbus_dev.h"
+
 struct anybuss_host;
 
 struct anybuss_client {
@@ -61,12 +64,6 @@ anybuss_set_drvdata(struct anybuss_client *client, void *data)
 
 int anybuss_set_power(struct anybuss_client *client, bool power_on);
 
-enum anybuss_offl_mode {
-	AB_OFFL_MODE_CLEAR = 0,
-	AB_OFFL_MODE_FREEZE,
-	AB_OFFL_MODE_SET
-};
-
 struct anybuss_memcfg {
 	u16 input_io;
 	u16 input_dpram;
@@ -76,7 +73,7 @@ struct anybuss_memcfg {
 	u16 output_dpram;
 	u16 output_total;
 
-	enum anybuss_offl_mode offl_mode;
+	enum fieldbus_dev_offl_mode offl_mode;
 };
 
 int anybuss_start_init(struct anybuss_client *client,
diff --git a/drivers/staging/fieldbus/anybuss/hms-profinet.c b/drivers/staging/fieldbus/anybuss/hms-profinet.c
index 5446843e35f4..31c43a0a5776 100644
--- a/drivers/staging/fieldbus/anybuss/hms-profinet.c
+++ b/drivers/staging/fieldbus/anybuss/hms-profinet.c
@@ -96,7 +96,7 @@ static int __profi_enable(struct profi_priv *priv)
 		.output_io = 220,
 		.output_dpram = PROFI_DPRAM_SIZE,
 		.output_total = PROFI_DPRAM_SIZE,
-		.offl_mode = AB_OFFL_MODE_CLEAR,
+		.offl_mode = FIELDBUS_DEV_OFFL_MODE_CLEAR,
 	};
 
 	/*
diff --git a/drivers/staging/fieldbus/anybuss/host.c b/drivers/staging/fieldbus/anybuss/host.c
index f69dc4930457..549cb7d51af8 100644
--- a/drivers/staging/fieldbus/anybuss/host.c
+++ b/drivers/staging/fieldbus/anybuss/host.c
@@ -1022,13 +1022,13 @@ int anybuss_start_init(struct anybuss_client *client,
 	};
 
 	switch (cfg->offl_mode) {
-	case AB_OFFL_MODE_CLEAR:
+	case FIELDBUS_DEV_OFFL_MODE_CLEAR:
 		op_mode = 0;
 		break;
-	case AB_OFFL_MODE_FREEZE:
+	case FIELDBUS_DEV_OFFL_MODE_FREEZE:
 		op_mode = OP_MODE_FBFC;
 		break;
-	case AB_OFFL_MODE_SET:
+	case FIELDBUS_DEV_OFFL_MODE_SET:
 		op_mode = OP_MODE_FBS;
 		break;
 	default:
diff --git a/drivers/staging/fieldbus/fieldbus_dev.h b/drivers/staging/fieldbus/fieldbus_dev.h
index a10fc3b446dc..301dca3b8d71 100644
--- a/drivers/staging/fieldbus/fieldbus_dev.h
+++ b/drivers/staging/fieldbus/fieldbus_dev.h
@@ -15,6 +15,12 @@ enum fieldbus_dev_type {
 	FIELDBUS_DEV_TYPE_PROFINET,
 };
 
+enum fieldbus_dev_offl_mode {
+	FIELDBUS_DEV_OFFL_MODE_CLEAR = 0,
+	FIELDBUS_DEV_OFFL_MODE_FREEZE,
+	FIELDBUS_DEV_OFFL_MODE_SET
+};
+
 /**
  * struct fieldbus_dev - Fieldbus device
  * @read_area:		[DRIVER] function to read the process data area of the
-- 
2.17.1

