Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977F122116B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGOPnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGOPnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:43:11 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF74C061755;
        Wed, 15 Jul 2020 08:43:10 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u25so1322855lfm.1;
        Wed, 15 Jul 2020 08:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=irlNVEVgL3b659SmPZcMJRl5cSWSjkxsHANDUsS6bEY=;
        b=YhvIU93ZAedMmUhsNYI3M3crKIN2/G1r4MLUnsHm/dSq9XmKH7oBbfulHlqGiS4H7+
         +6Yz2BIon7EAclrDBHGPO0Hj8J3X+U902mcsPGYyrOrPqlhKLqBEgrzdb4FIliyOUSKh
         dHFwJ1LkQ+s3IY0SmgC0bM4J3mY4Vhn+Z1MoY2rG3ei2QKlakp3UOpeWfCWS5aKznrdx
         KmCUU4ipXJSR/OFbsX03Awmm+RwUHr7zKKvpyuGCf2gR3x10hUkDvq7FhyL8wcvzpDve
         nmzTghv8zkJqB/+zu0qRSX45UFt5l08MQJWiLLMo24/XoYECBzJHfZpUeioEeM/cBz9Y
         tLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=irlNVEVgL3b659SmPZcMJRl5cSWSjkxsHANDUsS6bEY=;
        b=JzTESOz60m3VR5I71NfZc9dQeBZbM7WNoPJqCU45yRXngfuKCDRLYe+eDyvUGOxRNd
         3hyROC35SR1OWLVgB/K5Os4UzRNh9blSOO6uBGvjNbKVBu+GXhEGDRim/eeVVWy9jwNk
         nwRG2dwUuDsRNKAnWvYOuiRVpUXPQa+bJxu2bkdpOPd8TCZbR0yPdR/CxnfI5/JNejwI
         Wr17eb3sXDAOE62hyB6QbjKY20IVSHFV98ln/TQBkuvL6p8v6M04TWPmgc9zo/okBEM+
         M8AjeFmA2slQYDeL+HifkhBT9B1qQ9dqF1Jjqy+eOn79aiqL7x0+Lrxy0b75q6dGd84F
         1K8w==
X-Gm-Message-State: AOAM531WJ+8hdauHxT751Yn7kFh/hD1shMF4o5MEkfugixC9rC5AQ4v0
        2+gFU9Fl7pYDluq7uu7hRUu4T6Lh
X-Google-Smtp-Source: ABdhPJw45TqAutQiNNGcMJPjWBO17zupJo+rP2MEtpG+jOHPotRo4L75Nx9jGynGPu7pnUYaF79sGw==
X-Received: by 2002:a19:6b15:: with SMTP id d21mr5100636lfa.42.1594827788741;
        Wed, 15 Jul 2020 08:43:08 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id c6sm563955lff.77.2020.07.15.08.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 08:43:07 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH net-next v2 2/4] net: fec: initialize clock with 0 rather than current kernel time
Date:   Wed, 15 Jul 2020 18:42:58 +0300
Message-Id: <20200715154300.13933-3-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715154300.13933-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200715154300.13933-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initializing with 0 makes it much easier to identify time stamps from
otherwise uninitialized clock.

Initialization of PTP clock with current kernel time makes little sense as
PTP time scale differs from UTC time scale that kernel time represents.
It only leads to confusion when no actual PTP initialization happens, as
these time scales differ in a small integer number of seconds (37 at the
time of writing.)

Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index fda306b3e21f..4bec7e66a39b 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -264,7 +264,7 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
 	fep->cc.mult = FEC_CC_MULT;
 
 	/* reset the ns time counter */
-	timecounter_init(&fep->tc, &fep->cc, ktime_to_ns(ktime_get_real()));
+	timecounter_init(&fep->tc, &fep->cc, 0);
 
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 }
-- 
2.10.0.1.g57b01a3

