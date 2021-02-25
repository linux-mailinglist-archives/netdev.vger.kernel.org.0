Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5498D325879
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhBYVQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhBYVQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 16:16:21 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB375C06174A;
        Thu, 25 Feb 2021 13:15:40 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a11so2515415wmd.5;
        Thu, 25 Feb 2021 13:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pOO48CRVDwuK4MdBDmN0ZaayDswN2bcw5RsSh3NXzK4=;
        b=H50sSvw9F8zkWIzdOX+9Q/1CIiSrcErSJudYopuz3opDJ+GKFS4T1VZNHrzsvuu26+
         jKxCxB2Nlxxr3s13+aKQwU/zAIoESDMuzV9X/41WMEEA76KxPRZngAmBRsJECJyXyF1l
         v1By6iya2G5cPQ/gyAkJFMMXyXt9WEz5geGKRPBei8uH/axjY2WQVkz+h2iced85vA7q
         SLO6XOmztohvkl+rC781l2jXCvtAExWFRgcZ1sXVOQbpBl6ITUlonF4dGefZFAwo1w1v
         AlknttOPWpdIWgAaUF1DSYcDVEn1DfvWNYIUhlO0UioOeVKAwUEKwWOs2kpWwrHHEfcX
         itWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pOO48CRVDwuK4MdBDmN0ZaayDswN2bcw5RsSh3NXzK4=;
        b=Xx0REBX0rtqe5hHzMlAXxKSn2ck1K1SG5gLg48MEIlnBIktp5CWrEMBuUmH9UlomPd
         Nl3Uzc133d9EKf+rJJbpdfiNaZeVYhuuGa9qDWIXJb/NiJQmeZYk1CUxTotv7CnblGl+
         pmV8Vz3DOab1w4sUomjPyyw2bDbkqa7Ie9AicW12fSeWjwdlh4tuLAiDtc6DUNnWQzcj
         OmviVnAxZhzjb/kiz/cK2I0eB8P6S8qCmi7RxbDZZ1+UT1LjNHXNu4SDsKmgY6u6LG8f
         1+1U5gpNWkKidDLBoocz0cYPQQGVqu2oDCVnIeqomIGO/fmr/Y5g/wpSzRZrApZB9Tkj
         0cfg==
X-Gm-Message-State: AOAM530OAAHbwBbcSi2xgTYzr7+Gv7yjI3qBbELkljrAUfMSO0Br5Lz+
        GeeOZ/rNDBUGu8thUFBze0Bd5JCX/SAoylrx
X-Google-Smtp-Source: ABdhPJw2bmmrZ6V3DJtiCOw/Q64l19Wv131uwA+GqkvuG7FI/02eU3nX/58yd9vBQPhJRnqRov1+5w==
X-Received: by 2002:a1c:9a46:: with SMTP id c67mr230998wme.159.1614287739208;
        Thu, 25 Feb 2021 13:15:39 -0800 (PST)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id s124sm8636373wms.40.2021.02.25.13.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 13:15:38 -0800 (PST)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 1/1] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Thu, 25 Feb 2021 22:15:16 +0100
Message-Id: <20210225211514.9115-1-heiko.thiery@gmail.com>
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

v3:
I did a mistake and did not test properly
 - add parenteses
 - fix the used variable

 drivers/net/ethernet/freescale/fec_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 2e344aada4c6..1753807cbf97 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -377,9 +377,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u64 ns;
 	unsigned long flags;
 
+	mutex_lock(&adapter->ptp_clk_mutex);
+	/* Check the ptp clock */
+	if (!adapter->ptp_clk_on) {
+		mutex_unlock(&adapter->ptp_clk_mutex);
+		return -EINVAL;
+	}
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	ns = timecounter_read(&adapter->tc);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+	mutex_unlock(&adapter->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
-- 
2.30.0

