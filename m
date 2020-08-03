Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5230E23ADF8
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHCUKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCUKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:10:48 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9762EC06174A;
        Mon,  3 Aug 2020 13:10:47 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l23so14447363edv.11;
        Mon, 03 Aug 2020 13:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2Svs2xsap0D+iwtzqAAgZhsDZhRE16VZFPPIiVLOyI=;
        b=OKAfvfOhKSj8fz49Grbl8Li0cDjorqzgzVm2Q967F1W8m6Iw9gp5iF2XpbgLWuB7J/
         Y0O/C3Lv9x+ILkKzxX9Ml/jS3RYXx3YDZ2T5IRekGreFvZME+6LUxk1fpHDqwpYwve5E
         koBP6W/wCk7gH8cPi2mIut44yWA+6njzvtW+cFapzUtCJs8DOJkNabsOIcI0/3zIG9x1
         6uJA66QsyVbqKNVlXHl7xmMjM/SfVA8usqCKS8uJm5nVme156upp0PrqWpuuGNlVgGRk
         s4fOODmFce+uTWTcbH2oUeUvkZDhC+e5NJUGWHCBMMwxsc+rbcof8HSOFmD7OasIqq9x
         c6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2Svs2xsap0D+iwtzqAAgZhsDZhRE16VZFPPIiVLOyI=;
        b=oXmnsDaJH1IgRXmicPGo75ZYEaI9r+Lwgt2St2ZaUmQqOOBS++zShYyK/qux9ZOdNV
         3cPZSRHXhxgN1tMjpPnHxyiM7deYgNs7HWyaLhksMVp6V3DzCA9Z+sI8U3BcrnfWQcrX
         dua1UR6hX1aX1w7M0P0PLjmfZVKttSCJaG/8nuHQphRxWBngS+2kTqf3sGYK/+4IelPN
         ndYP9bhLq/owyUwiE/L9wdH4qR4PGMBL2NMl6K8/L3eGzalALeC77SQVYC4WoQz1Mw21
         XK/EkDjPux9MgAAUhgFD7RLiBXdeZ1ccb3+R1ULjAfVLQmcYqqYGWaIE/P79KIKJHgQp
         Z11Q==
X-Gm-Message-State: AOAM532lEiHad+7wkMYe8SKPm/uvj/jMyvFHYo3w1Uz/W/brJkcHOL8s
        e6FoGgJxdRCKkQO5JBZZK7U=
X-Google-Smtp-Source: ABdhPJwkPI3VHwYVx+Px/6s55ydN+BQ2b/egkO4hNXXHgidFYr6woFBBt2M+SBze6UblPYPiBuidjQ==
X-Received: by 2002:a50:8ace:: with SMTP id k14mr18036474edk.0.1596485446273;
        Mon, 03 Aug 2020 13:10:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id u8sm16664049ejm.65.2020.08.03.13.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:10:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, ioana.ciornei@nxp.com, Jiafei.Pan@nxp.com,
        yangbo.lu@nxp.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: [PATCH net-next 2/2] enetc: use napi_schedule to be compatible with PREEMPT_RT
Date:   Mon,  3 Aug 2020 23:10:09 +0300
Message-Id: <20200803201009.613147-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803201009.613147-1-olteanv@gmail.com>
References: <20200803201009.613147-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiafei Pan <Jiafei.Pan@nxp.com>

The driver calls napi_schedule_irqoff() from a context where, in RT,
hardirqs are not disabled, since the IRQ handler is force-threaded.

In the call path of this function, __raise_softirq_irqoff() is modifying
its per-CPU mask of pending softirqs that must be processed, using
or_softirq_pending(). The or_softirq_pending() function is not atomic,
but since interrupts are supposed to be disabled, nobody should be
preempting it, and the operation should be safe.

Nonetheless, when running with hardirqs on, as in the PREEMPT_RT case,
it isn't safe, and the pending softirqs mask can get corrupted,
resulting in softirqs being lost and never processed.

To have common code that works with PREEMPT_RT and with mainline Linux,
we can use plain napi_schedule() instead. The difference is that
napi_schedule() (via __napi_schedule) also calls local_irq_save, which
disables hardirqs if they aren't already. But, since they already are
disabled in non-RT, this means that in practice we don't see any
measurable difference in throughput or latency with this patch.

Signed-off-by: Jiafei Pan <Jiafei.Pan@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f50353cbb4db..f78ca7b343d2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -270,7 +270,7 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
 
-	napi_schedule_irqoff(&v->napi);
+	napi_schedule(&v->napi);
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1

