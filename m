Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665CB34EB4B
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhC3Oza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhC3Oyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:54:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96438619CE;
        Tue, 30 Mar 2021 14:54:49 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lRFlX-004hoo-UE; Tue, 30 Mar 2021 15:54:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, Andre.Przywara@arm.com,
        steven.price@arm.com, lorenzo.pieralisi@arm.com,
        sudeep.holla@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        kernel-team@android.com, Mark Rutland <mark.rutland@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v19 5/7] clocksource: Add clocksource id for arm arch counter
Date:   Tue, 30 Mar 2021 15:54:28 +0100
Message-Id: <20210330145430.996981-6-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210330145430.996981-1-maz@kernel.org>
References: <20210330145430.996981-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com, kernel-team@android.com, mark.rutland@arm.com, andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianyong Wu <jianyong.wu@arm.com>

Add clocksource id to the ARM generic counter so that it can be easily
identified from callers such as ptp_kvm.

Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201209060932.212364-6-jianyong.wu@arm.com
---
 drivers/clocksource/arm_arch_timer.c | 2 ++
 include/linux/clocksource_ids.h      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d0177824c518..8f12e223703f 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -16,6 +16,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
+#include <linux/clocksource_ids.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
@@ -191,6 +192,7 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
 
 static struct clocksource clocksource_counter = {
 	.name	= "arch_sys_counter",
+	.id	= CSID_ARM_ARCH_COUNTER,
 	.rating	= 400,
 	.read	= arch_counter_read,
 	.mask	= CLOCKSOURCE_MASK(56),
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
index 4d8e19e05328..16775d7d8f8d 100644
--- a/include/linux/clocksource_ids.h
+++ b/include/linux/clocksource_ids.h
@@ -5,6 +5,7 @@
 /* Enum to give clocksources a unique identifier */
 enum clocksource_ids {
 	CSID_GENERIC		= 0,
+	CSID_ARM_ARCH_COUNTER,
 	CSID_MAX,
 };
 
-- 
2.29.2

