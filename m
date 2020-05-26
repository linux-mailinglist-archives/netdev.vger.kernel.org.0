Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36321E24BD
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbgEZO6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:58:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41241 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731329AbgEZO63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:58:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id 23so10275852pfy.8;
        Tue, 26 May 2020 07:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zOBEOlJCwRVyUrO7obeZe7+iAPzekeZt6xLUEcXHiBo=;
        b=fB9kZm2G9Rp8RvFcUXr4rCAPuPVhHxrs/FXHsq01bDMMgOW7uk986PiLItQ5MBSmHO
         icbm9oJVhhBlUkOSkA9sEOdNG30wV2ZK6E4gzR90rngkYrOdCDzkpkI2QsNlInjUo8eV
         n2Hl7lkQZu7B7NNUXwj8kowXnVrQnuB1alGk91d6+ox/em53RojapiEz78gYvfqJDVeK
         QvK2MLrsKhpolA2iyUMXpo+G344ff44623xwDBmns4Pbr1AyLWE52FOFCLK0hcq4kK3q
         2XZMQmS12rSXD/Bwar+yq2lES2fNG4nv12AuqXiKhgQbeEn12/CvyzGIxu0K1UBCN133
         0anA==
X-Gm-Message-State: AOAM532hOOhYLBXm+CYWjjwk2+S6cH9U3PQKWj5MtS6azAges8XRrLO1
        3xtvn5HTbdDAwuR56yKcdU95DJ6z076xcQ==
X-Google-Smtp-Source: ABdhPJwyAWMg1yexMnblWfdQ7VyVHIrCuOdJwfRphdA8vbRbaf+ut1fp4wVPS21hw2wOXnMej7dj6g==
X-Received: by 2002:aa7:998a:: with SMTP id k10mr21781972pfh.127.1590505107892;
        Tue, 26 May 2020 07:58:27 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id r69sm15995450pfc.209.2020.05.26.07.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:58:25 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id B4A6F422E5; Tue, 26 May 2020 14:58:18 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     michael.chan@broadcom.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, akpm@linux-foundation.org,
        arnd@arndb.de, rostedt@goodmis.org, mingo@redhat.com,
        aquini@redhat.com, cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, derosier@gmail.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 6/8] bnxt_en: use new taint_firmware_crashed()
Date:   Tue, 26 May 2020 14:58:13 +0000
Message-Id: <20200526145815.6415-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200526145815.6415-1-mcgrof@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb46325..776a7ae0ef7f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -121,6 +121,7 @@ static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
 	if (!priv_ctx)
 		return -EOPNOTSUPP;
 
+	taint_firmware_crashed();
 	bp->fw_health->fatal = true;
 	event = fw_reporter_ctx->sp_event;
 	if (event == BNXT_FW_RESET_NOTIFY_SP_EVENT)
-- 
2.26.2

