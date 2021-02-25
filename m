Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4B5325839
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhBYU6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 15:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbhBYU4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 15:56:49 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3655BC061756;
        Thu, 25 Feb 2021 12:55:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d11so6570223wrj.7;
        Thu, 25 Feb 2021 12:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gGeiCXi9fncQbgdOkein4PEFDuIaKN1LLJnxOvXBDMM=;
        b=hC3k2bnILIbFDlmLQj6taWy3YqMFYqbx9MxWspc11zj06KDxmsAJzyTXNCmtheGN7c
         UgoHDLxyikxX7G4C/TvNP2k9zqFwdWFENMwpoPwayD1NCyjvMOk8nSrwMTqYiy7jjqLW
         7lKKuISU7nhpABCglLY246MeGuzyEH6IU44w8GEBsExTO3PPCkPWp1J9WhPLVsQu7c9d
         xruEmzNuc1ZAZetLRpdGZJkBf5Mkpn8xvvuqMjCUfC84RsFLuvHvkoz65sRlD4fGYFVC
         48LBowCgYbwHPDVNnlYVTOdqmwv9Th0QTlEA1TKwEqt/qD9lp5BZeAA3HyITzgw/+XEv
         tpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gGeiCXi9fncQbgdOkein4PEFDuIaKN1LLJnxOvXBDMM=;
        b=qDHlbCgh1x/JB+qpY6bx1Kvqr1cOHWyYffHJ3dBBY8koKVSiQVmqaHqTGweaoDJPMt
         oqWeAWDyr8XhX5tt7naLYVwxPGEHk8kGCQyn0Y2fZCn3hhwNU4kV25yerBQVd7QLZCHs
         2bo5y9paRhrxfeD1EKYj4x4kzFYX/SWhTY6BoVQxkYwyHonob0t5xGNymcRSCof7TgTv
         ZT3Se1/1gfnnmLdKZnRq9XwtDJdMsRifu6G45MSvHAZ6ost3uNsUCe02Z8O0xvZVGX7t
         JmarT38hQRz9uBVKsbdNw3QUK9rWTgDtJdBcQBkp4obL/Amo3gijRZ39aJK93tzXF7hI
         jdzw==
X-Gm-Message-State: AOAM533/Yut2m/ahfc7G/ayeuUEmVOUGY3p4w1qLrvMjXYyd/oznf2V/
        FrZR7onH5mwyrUc1jfn2uBLiK3hJLTr3Tuex
X-Google-Smtp-Source: ABdhPJyhHb3ktF8jY/ZSSENuBSi2FGt2kdv8J21HKvHX/n05p91aPq03clUwqtLfyFPUVdpvwrG4NA==
X-Received: by 2002:a5d:6152:: with SMTP id y18mr2133239wrt.381.1614286542701;
        Thu, 25 Feb 2021 12:55:42 -0800 (PST)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id a21sm9948083wmb.5.2021.02.25.12.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:55:42 -0800 (PST)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 1/1] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Thu, 25 Feb 2021 21:55:19 +0100
Message-Id: <20210225205518.16781-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When accessing the timecounter register on an i.MX8MQ the kernel hangs.
This is only the case when the interface is down. This can be reproduced
by reading with 'phc_ctrl eth0 get'.

Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
the igp clock is disabled when the interface is down and leads to a
system hang.

So we check if the ptp clock status before reading the timecounter
register.

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
---
v2:
 - add mutex (thanks to Richard)

 drivers/net/ethernet/freescale/fec_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 2e344aada4c6..22f5e800c2d7 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -377,9 +377,15 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u64 ns;
 	unsigned long flags;
 
+	mutex_lock(&fep->ptp_clk_mutex);
+	/* Check the ptp clock */
+	if (!adapter->ptp_clk_on)
+		mutex_unlock(&fep->ptp_clk_mutex);
+		return -EINVAL;
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	ns = timecounter_read(&adapter->tc);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
-- 
2.30.0

