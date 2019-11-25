Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553D8108C0D
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfKYKpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:45:45 -0500
Received: from foss.arm.com ([217.140.110.172]:48054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbfKYKpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 05:45:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75B93328;
        Mon, 25 Nov 2019 02:45:43 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6BDB43F52E;
        Mon, 25 Nov 2019 02:45:38 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v8 2/8] psci: let arm_smccc_1_1_invoke available by modules
Date:   Mon, 25 Nov 2019 18:45:00 +0800
Message-Id: <20191125104506.36850-3-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191125104506.36850-1-jianyong.wu@arm.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export arm_smccc_1_1_get_conduit and apply it to get conduit
in arm_smccc_1_1_invoke, then modules can use this arm_smccc_1_1_invoke.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/firmware/psci/psci.c | 1 +
 include/linux/arm-smccc.h    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 5f31f1bea1af..cf509171422c 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -71,6 +71,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
 		return SMCCC_CONDUIT_NONE;
 	}
 }
+EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
 
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 701fa1da6b4a..6f82c87308ed 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -373,7 +373,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
  * The return value also provides the conduit that was used.
  */
 #define arm_smccc_1_1_invoke(...) ({					\
-		int method = psci_ops.conduit;				\
+		int method = arm_smccc_1_1_get_conduit();		\
 		switch (method) {					\
 		case PSCI_CONDUIT_HVC:					\
 			arm_smccc_1_1_hvc(__VA_ARGS__);			\
-- 
2.17.1

