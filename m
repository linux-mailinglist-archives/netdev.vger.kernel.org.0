Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C41E24F6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEZPHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:07:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43897 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgEZPHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:07:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id 185so1979276pgb.10;
        Tue, 26 May 2020 08:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L6RbYv5B1MYyKpilgE+iTClDmvIVUX2RuuOQOJ/aMVQ=;
        b=WNsW+JqxQqm1qgxF7HiiTvL2d/DCKjcYs294L0UiPjee0afDrntI3Dv7MkN3DB76Du
         mNXg/263fBRfosNnylqs89JZoQraoQPxshz2dELM0PkQKQ9+7weFdHVsWVfhs9hn4lVA
         txQyd6nhTuucLSYbP6J/HKM54X/VArZPLuQBEDrYsbjxQQo3teaKkXwEl8bFh8Pp5XEz
         SXJFJgsS3CCQU57kzkwFnMeqZyURJJYDQh0y39OViYK0iEK8zerZnUqa+Ax1gmUE+lv4
         REXXBKowtySHX40Bxnw4TEh/9IFy2n9fxy7Y9iVn8U1wQehKRaOzcbA4Kq2rKH+Gr7Zo
         qtGg==
X-Gm-Message-State: AOAM531ubOra4Ak3AP8d0Sf28+v1lbmilc6fvK83qiSUC5dF2LSGtB/i
        uWRNR+cjooxSQOmEcfIebiwG8KwnupR1zw==
X-Google-Smtp-Source: ABdhPJwU5ShAKbAvJXQtY62vZ1/Gh7rdLSj1+p4Kod680hhz3y98c6Kz9js7ZW4bm3wIfIjpQ2UATQ==
X-Received: by 2002:aa7:880f:: with SMTP id c15mr22560560pfo.94.1590505662105;
        Tue, 26 May 2020 08:07:42 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id k18sm15699602pfg.217.2020.05.26.08.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:07:40 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 0547C4230A; Tue, 26 May 2020 14:58:19 +0000 (UTC)
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
        linux-doc@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v3 8/8] qed: use new taint_firmware_crashed()
Date:   Tue, 26 May 2020 14:58:15 +0000
Message-Id: <20200526145815.6415-9-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200526145815.6415-1-mcgrof@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new taint_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 9624616806e7..dd4357b0b5d1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -566,6 +566,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		DP_NOTICE(p_hwfn,
 			  "The MFW failed to respond to command 0x%08x [param 0x%08x].\n",
 			  p_mb_params->cmd, p_mb_params->param);
+		taint_firmware_crashed();
 		qed_mcp_print_cpu_info(p_hwfn, p_ptt);
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
-- 
2.26.2

