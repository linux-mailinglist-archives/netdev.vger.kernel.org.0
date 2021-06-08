Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347CE39ED59
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhFHEGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:06:00 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:38411 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhFHEF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:59 -0400
Received: by mail-lf1-f44.google.com with SMTP id r5so29919923lfr.5;
        Mon, 07 Jun 2021 21:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P49wBkaDkamht0wn8kZscQTKx/D9qYCGtYJXiHNCtDE=;
        b=lcSN+Umc9GgwrvCbBZZQImUXPmJlL17VaxfHR4K0545GcFAqJqCZFOvx5NhwvpxPlB
         7wLHuRgmXgHYuK13V9kBt8gBORJrfbb6fVD02PAUi3MgFbSYcATr2uIVlcE7EOB5nSSq
         sKV/838A7Cr8au9l4K7i0rUGCKizvqcwRrERvZ1mC0vSSQ4MSWeB8zqywwooOLUWRzG/
         jgHqEsMUhO6Wqwf4VB8T98nD8pMAfsjWsPcV+jl16MRWBBa45HcwhZH3jKUwOxHHseRr
         5AEZHXTL+4U4l/K5cwBsPoOD9J7EIGUIFd3r1dfUtvSKL7EQLZv3iR3sGFLIN7OTPDqO
         dWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P49wBkaDkamht0wn8kZscQTKx/D9qYCGtYJXiHNCtDE=;
        b=ZcR1iTarjLrpqlIHp5Vzqo36MkQDaV7YeuqR2hakRloOzM0YBsFTZEzAEO9jY43QBm
         AZYrvgZesLHzY9AEJH0/GQjaQaBzhgtkD+g3Y3Ns5IwOi61FYqnh1tXbGWEnA+auVnnE
         htlZVOgB3XCIPnEbgl368CgevCOyT8pHgA6V/HxWlUPM/Zy29AgxDU7RtDU9ZkbZ9FjU
         aKzOdyzaQeKypMTH7fGsQOf41Voi5oh77WQevIOw2dvIM8GGNJW41IFiJuFeRJ12OEvQ
         6Bg9oFbVddREzGdlvDefhVsIH0Mnl6tEW/n338X8JQoDB7u936TUwKTEFwlJwnQd6Q7n
         UR9Q==
X-Gm-Message-State: AOAM530iuzEQSiVp97v4Q8x1QR1aq68/dzKJiYRJr3kYnWbZSeTueYVf
        r/2HAUp9WgXfQpeSAenUwko=
X-Google-Smtp-Source: ABdhPJxliUFhZSLoP6zAle7JYsWSmZOfOptpPgsAFeL4YxUS0+fQmNmXUUije4EP8sSgCfUucEw7YQ==
X-Received: by 2002:a05:6512:2186:: with SMTP id b6mr13480688lft.490.1623124975933;
        Mon, 07 Jun 2021 21:02:55 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:55 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/10] net: wwan: core: expand ports number limit
Date:   Tue,  8 Jun 2021 07:02:38 +0300
Message-Id: <20210608040241.10658-8-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we limit the total ports number to 256. It is quite common
for PBX or SMS gateway to be equipped with a lot of modems. In now days,
a modem could have 2-4 control ports or even more, what only accelerates
the ports exhausing rate.

To avoid facing the port number limitation issue reports, increase the
limit up the maximum number of minors (i.e. up to 1 << MINORBITS).

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 2844b17a724c..9346b2661eb3 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -14,7 +14,8 @@
 #include <linux/types.h>
 #include <linux/wwan.h>
 
-#define WWAN_MAX_MINORS 256 /* 256 minors allowed with register_chrdev() */
+/* Maximum number of minors in use */
+#define WWAN_MAX_MINORS		(1 << MINORBITS)
 
 static DEFINE_MUTEX(wwan_register_lock); /* WWAN device create|remove lock */
 static DEFINE_IDA(minors); /* minors for WWAN port chardevs */
@@ -634,7 +635,8 @@ static int __init wwan_init(void)
 		return PTR_ERR(wwan_class);
 
 	/* chrdev used for wwan ports */
-	wwan_major = register_chrdev(0, "wwan_port", &wwan_port_fops);
+	wwan_major = __register_chrdev(0, 0, WWAN_MAX_MINORS, "wwan_port",
+				       &wwan_port_fops);
 	if (wwan_major < 0) {
 		class_destroy(wwan_class);
 		return wwan_major;
@@ -645,7 +647,7 @@ static int __init wwan_init(void)
 
 static void __exit wwan_exit(void)
 {
-	unregister_chrdev(wwan_major, "wwan_port");
+	__unregister_chrdev(wwan_major, 0, WWAN_MAX_MINORS, "wwan_port");
 	class_destroy(wwan_class);
 }
 
-- 
2.26.3

