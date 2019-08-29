Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C81BA11E6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfH2GkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:40:11 -0400
Received: from foss.arm.com ([217.140.110.172]:39590 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfH2GkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 02:40:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 642F3360;
        Wed, 28 Aug 2019 23:40:09 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1347E3F246;
        Wed, 28 Aug 2019 23:42:27 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, Steve.Capper@arm.com,
        Kaly.Xin@arm.com, justin.he@arm.com, jianyong.wu@arm.com
Subject: [RFC PATCH 1/3] Export psci_ops.conduit symbol as modules will use it.
Date:   Thu, 29 Aug 2019 02:39:50 -0400
Message-Id: <20190829063952.18470-2-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829063952.18470-1-jianyong.wu@arm.com>
References: <20190829063952.18470-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If arm_smccc_1_1_invoke used in modules, psci_ops.conduit should
be export.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/firmware/psci/psci.c | 6 ++++++
 include/linux/arm-smccc.h    | 2 +-
 include/linux/psci.h         | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index f82ccd39a913..35c4eaab1451 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -212,6 +212,12 @@ static unsigned long psci_migrate_info_up_cpu(void)
 			      0, 0, 0);
 }
 
+enum psci_conduit psci_get_conduit(void)
+{
+	return psci_ops.conduit;
+}
+EXPORT_SYMBOL(psci_get_conduit);
+
 static void set_conduit(enum psci_conduit conduit)
 {
 	switch (conduit) {
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 552cbd49abe8..a6e4d3e3d10a 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -357,7 +357,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
  * The return value also provides the conduit that was used.
  */
 #define arm_smccc_1_1_invoke(...) ({					\
-		int method = psci_ops.conduit;				\
+		int method = psci_get_conduit();			\
 		switch (method) {					\
 		case PSCI_CONDUIT_HVC:					\
 			arm_smccc_1_1_hvc(__VA_ARGS__);			\
diff --git a/include/linux/psci.h b/include/linux/psci.h
index a8a15613c157..e5cedc986049 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -42,6 +42,7 @@ struct psci_operations {
 	enum smccc_version smccc_version;
 };
 
+extern enum psci_conduit psci_get_conduit(void);
 extern struct psci_operations psci_ops;
 
 #if defined(CONFIG_ARM_PSCI_FW)
-- 
2.17.1

