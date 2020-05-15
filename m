Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE01D5B80
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgEOV3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:04 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55098 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgEOV25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:28:57 -0400
Received: by mail-pj1-f68.google.com with SMTP id s69so1476674pjb.4;
        Fri, 15 May 2020 14:28:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJHZT4MFB+sxpA2IE8Rn7gYtD/Qc3TQAcYIYNGZYEvg=;
        b=phgAbbNGhP6J6HCS81WASgrpY9Nrx5oVe49i1im1AEYCMmyduUplIcxbSk128lbn5z
         TU2mr1DIJBXRCn0klJ41zaK7+lstVO2R1X9Mt3moIhbF1Z2I2T1IaKpUnEJ/hEV6+b/H
         ZT1TabezFw8DNFr/6SUEIU+ShgnsNkOOShmjegw3aXW3+dPT3rahU/pTRJ3jem3C/UHU
         nwfLtdSsE3FiPQ13tMm7pqTCk5DHaVzSj8uGfDs+Or0WM7VGkpITCN/69O64+202a897
         RiLjpzheuUA9YMRXoR4QSwImyHDd4RymJKRryVL+VOogvxc0LBBast66Ir0BpeFcKCYF
         dh7g==
X-Gm-Message-State: AOAM5307VsbEQwiBDwxoBXLSrs66/8AOC2cJSWO81u8LqRTHytElmFSm
        FdNIdsjE6atRICRr2kTle1Y=
X-Google-Smtp-Source: ABdhPJyXGdNJ50o8iXun3oJYb5kOl4qAS44k7tBrK+zhGB5FrkYaAMjM2mxcrnwWQ+1fLrVtkOdV0w==
X-Received: by 2002:a17:902:9f97:: with SMTP id g23mr5721810plq.30.1589578136986;
        Fri, 15 May 2020 14:28:56 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id m9sm2450255pgd.1.2020.05.15.14.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id CB94E41EDA; Fri, 15 May 2020 21:28:49 +0000 (UTC)
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
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Subject: [PATCH v2 05/15] bna: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:36 +0000
Message-Id: <20200515212846.1347-6-mcgrof@kernel.org>
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

Cc: Rasesh Mody <rmody@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bfa_ioc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index e17bfc87da90..b3f44a912574 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -927,6 +927,7 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_initfail_sync_entry(struct bfa_iocpf *iocpf)
 {
+	module_firmware_crashed();
 	bfa_nw_ioc_debug_save_ftrc(iocpf->ioc);
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
-- 
2.26.2

