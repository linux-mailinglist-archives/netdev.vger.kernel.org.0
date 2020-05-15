Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6101D5B9B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgEOVaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:30:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41782 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgEOV3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id 23so1592594pfy.8;
        Fri, 15 May 2020 14:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xBkpYn0OGRXJFLEKv1YJxgMkLUAuINcwhwjSKqfiGiY=;
        b=m30sbDf77Zi/njTeLobRWD016F37cTQ8m/G0f51ZK5biDp25HiBDwGAxuo2WImwvbb
         d4BoLWrZb5scx0nhWdgCa+RQ0d+aS/v37Nkg6W5gB0i7YPZHx6iXODjiHcKUG9imGugm
         baK23zRzhw+xFwa9PrH9vu/Mp05p1iIH/VO8GUVE/GRD1QIwFGXWxLz80hDxxHvDrO8f
         mgXnyVBpDLS7yXqo2qNW5W3Opx1v4kvA+hBcJRGlT2AwjlS96oTdZT7k+uC1bDS05fWr
         5HWQXuAg+GXrA1PhJ+f0dW95ghV3wnUESHltzegIu+g53gP7lgmtyXIStNBDmK4O0ExB
         l9Tw==
X-Gm-Message-State: AOAM5336AFOIF49CJJ/Lo4SqpHT724gjcPOW8qwhJqcnG5IL3oUenlZG
        lgGV4zeb1LpFrdJH4CltuZI=
X-Google-Smtp-Source: ABdhPJySutDUwh/Hlrvw1b9svILaoMn5tvR1dnM8imuIRFA9bR+HSq1C9aBBC60X0+Qj6CPPZAUuwA==
X-Received: by 2002:a63:42c4:: with SMTP id p187mr5038674pga.153.1589578141509;
        Fri, 15 May 2020 14:29:01 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y7sm2681182pfq.21.2020.05.15.14.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 053B742337; Fri, 15 May 2020 21:28:50 +0000 (UTC)
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
        GR-everest-linux-l2@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 09/15] qed: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:40 +0000
Message-Id: <20200515212846.1347-10-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
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
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 9624616806e7..aea200d465ef 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -566,6 +566,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		DP_NOTICE(p_hwfn,
 			  "The MFW failed to respond to command 0x%08x [param 0x%08x].\n",
 			  p_mb_params->cmd, p_mb_params->param);
+		module_firmware_crashed();
 		qed_mcp_print_cpu_info(p_hwfn, p_ptt);
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
-- 
2.26.2

