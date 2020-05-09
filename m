Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218981CBD72
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgEIEgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:18 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55657 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgEIEgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:16 -0400
Received: by mail-pj1-f66.google.com with SMTP id k7so229117pjs.5;
        Fri, 08 May 2020 21:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0XUPR8gTRBaK/zVNrQDrzctO9dsoRkXZA68QpWb+cw=;
        b=hJ0h2BDp55l7fsTlVfnT9HPmIM8rGMSS2nIYaU6P5Xz/m4ewUhNIT2dernZJNy2ulm
         UJueO0sAGESaVpd+TKmt6ziykKlHrgGW/wRflARfQF093mDTFWGg4xVf6jPlLCdrtKN/
         VgEnOQZSEJRS7wTGGFTeQbcW9sGu91vc+eQBKFV19JEU1zd/MW9E3wQDdpUVs1yviBSU
         VFAWF74ajS4jdeG3WagsBf56lTT2XGTktTFtZHXSzn9cVd8JQGV/GzRY8XvoDP0aHWwB
         Jmb7e1RbUule8TUmeNQIJpUomFA4Kb+ePi9YAzmiQP2X627izT2GtlD7AAPGnW9ZDUoT
         RMJQ==
X-Gm-Message-State: AGi0PuYOhFrYUlLMLALcR8Mhj8upw071mYQfGQTIENMJGvC4+gyURe+e
        97XW1UXrgPHCw0FV9KpA10s=
X-Google-Smtp-Source: APiQypIpLPKRngDi2nwKB/l9ruVNOfAboQdFftzYLEjRsOGUFsV5rsG+XovjkSD/u+zzSn9mOCV65w==
X-Received: by 2002:a17:90a:498a:: with SMTP id d10mr10105139pjh.194.1588998974401;
        Fri, 08 May 2020 21:36:14 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 1sm3248272pff.151.2020.05.08.21.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:07 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 34880422E5; Sat,  9 May 2020 04:36:01 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH 09/15] qed: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:46 +0000
Message-Id: <20200509043552.8745-10-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
References: <20200509043552.8745-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f4eebaabb6d0..9cc6287b889b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7854,6 +7854,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 						 REGDUMP_HEADER_SIZE,
 						 &feature_size);
 		if (!rc) {
+			module_firmware_crashed();
 			*(u32 *)((u8 *)buffer + offset) =
 			    qed_calc_regdump_header(cdev, PROTECTION_OVERRIDE,
 						    cur_engine,
@@ -7869,6 +7870,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		rc = qed_dbg_fw_asserts(cdev, (u8 *)buffer + offset +
 					REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
+			module_firmware_crashed();
 			*(u32 *)((u8 *)buffer + offset) =
 			    qed_calc_regdump_header(cdev, FW_ASSERTS,
 						    cur_engine, feature_size,
@@ -7906,6 +7908,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
 				 REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
+			module_firmware_crashed();
 			*(u32 *)((u8 *)buffer + offset) =
 			    qed_calc_regdump_header(cdev, GRC_DUMP,
 						    cur_engine,
-- 
2.25.1

