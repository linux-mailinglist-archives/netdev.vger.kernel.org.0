Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F77C229E6D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgGVRXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGVRXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:23:45 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AD3C0619DC;
        Wed, 22 Jul 2020 10:23:45 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o1so1341514plk.1;
        Wed, 22 Jul 2020 10:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=waZLpv1oY9JdxGCqz+hGEo0vyh0IdaCvW7suryCs2O4=;
        b=UGKz/h4VX3Fs9zNxByZNcOHlX2WV4UskJvDTWBLqRIwV0gDQBpQMb9+KOtli5YhmV0
         2OVFWOF6YewsefBrJXmusr7/Tj+nnx7rI9uHh5B3+In79uwNsCn9/CqzFqqp6Te8p0ut
         yUF91epQqT9NOlC51H9gpIDtF+Nxuu0m6uLtphiK0xRtwNnTCNnWaJxoV3RkawM3ZfF+
         vaLsrPjC+bcyG6pXB2jvyDqVe9ur/E6T9EknTEqcTSp/U4Kml/Piy5TFam1y4xNW3Nb5
         fCcJfw6W4jTXStKbmv7+40ZjOcJ4c9ZU8IAYM9zI0dcaufFQrghfLo9IjsIoZBeQtVx2
         rlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=waZLpv1oY9JdxGCqz+hGEo0vyh0IdaCvW7suryCs2O4=;
        b=SU2vzPDGu7C1Gcm/AijOGoVYC9x9JU5QF8eWK3cPAGtOZ7FsZuTVpyc2+YK2Ca2gH6
         j5f9tSPTmCNYO63ForpCcIkikTucZiK1gSMWOEMuZ6mFe/URKYiFUoN8wikpGfRS/GdU
         e3N5JSXqPRiuML3RfAoupK7u6MBwhxzx8tPmr4NL9m5tFS/YhcsslqAVLRvse7nEkI6Z
         747BQTTSKwE5mfaBD8GRKqxREAJrL82e10aLaC4yPPPiXvG2jHFmXjOdYi5zQrKJ6MWD
         UejR2nVTnoK2QuNIc29c60iBHUNeVVs4JM7jcfwvx7E9jOnMALIZJ1G4hjCjzLY6I1yQ
         8s3w==
X-Gm-Message-State: AOAM530TvmSyvKoDzOFU3oQIm7+hBcrfyu9KbboA//M1zWgmpgQrWPgE
        jwPfe0dfL16HXTZuBwQ1og==
X-Google-Smtp-Source: ABdhPJy6aYd0ygn6rYVmUTmeka9L5VF55m1dib1vjw01B8MXvNkLDfPybsTJrjoTlV7N8pWvDHnqeQ==
X-Received: by 2002:a17:90a:368c:: with SMTP id t12mr455311pjb.90.1595438624469;
        Wed, 22 Jul 2020 10:23:44 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:cdb:f8f:507e:560d:bcc3:7e82])
        by smtp.gmail.com with ESMTPSA id x10sm197567pfp.80.2020.07.22.10.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:23:43 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     isdn@linux-pingi.de, davem@davemloft.net, arnd@arndb.de,
        gregkh@linuxfoundation.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrianov@ispras.ru, ldv-project@linuxtesting.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] drivers: isdn: capi: Fix data-race bug
Date:   Wed, 22 Jul 2020 22:53:29 +0530
Message-Id: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

In capi_init(), after register_chrdev() the file operation callbacks
can be called. However capinc_tty_init() is called later.
Since capiminors and capinc_tty_driver are initialized in
capinc_tty_init(), their initialization can race with their usage
in various callbacks like in capi_release().

Therefore, call capinc_tty_init() before register_chrdev to avoid
such race conditions.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 drivers/isdn/capi/capi.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 85767f52fe3c..7e8ab48a15af 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1332,7 +1332,7 @@ static int __init capinc_tty_init(void)
 	return 0;
 }
 
-static void __exit capinc_tty_exit(void)
+static void capinc_tty_exit(void)
 {
 	tty_unregister_driver(capinc_tty_driver);
 	put_tty_driver(capinc_tty_driver);
@@ -1420,29 +1420,28 @@ static int __init capi_init(void)
 	if (ret)
 		return ret;
 
+	if (capinc_tty_init() < 0) {
+		kcapi_exit();
+		return -ENOMEM;
+	}
+
 	major_ret = register_chrdev(capi_major, "capi20", &capi_fops);
 	if (major_ret < 0) {
 		printk(KERN_ERR "capi20: unable to get major %d\n", capi_major);
+		capinc_tty_exit();
 		kcapi_exit();
 		return major_ret;
 	}
 	capi_class = class_create(THIS_MODULE, "capi");
 	if (IS_ERR(capi_class)) {
 		unregister_chrdev(capi_major, "capi20");
+		capinc_tty_exit();
 		kcapi_exit();
 		return PTR_ERR(capi_class);
 	}
 
 	device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi20");
 
-	if (capinc_tty_init() < 0) {
-		device_destroy(capi_class, MKDEV(capi_major, 0));
-		class_destroy(capi_class);
-		unregister_chrdev(capi_major, "capi20");
-		kcapi_exit();
-		return -ENOMEM;
-	}
-
 	proc_init();
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
-- 
2.17.1

