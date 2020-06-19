Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D716200521
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgFSJbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:31:13 -0400
Received: from foss.arm.com ([217.140.110.172]:49152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731474AbgFSJbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 05:31:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2279D11B3;
        Fri, 19 Jun 2020 02:31:02 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E99253F71F;
        Fri, 19 Jun 2020 02:30:55 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        Wei.Chen@arm.com, jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via SMCCC
Date:   Fri, 19 Jun 2020 17:30:26 +0800
Message-Id: <20200619093033.58344-3-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619093033.58344-1-jianyong.wu@arm.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Will Deacon <will@kernel.org>

We can advertise ourselves to guests as KVM and provide a basic features
bitmap for discoverability of future hypervisor services.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 550dfa3e53cd..db6dce3d0e23 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -12,13 +12,13 @@
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
-	long val = SMCCC_RET_NOT_SUPPORTED;
+	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
 	gpa_t gpa;
 
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
-		val = ARM_SMCCC_VERSION_1_1;
+		val[0] = ARM_SMCCC_VERSION_1_1;
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
 		feature = smccc_get_arg1(vcpu);
@@ -28,10 +28,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			case KVM_BP_HARDEN_UNKNOWN:
 				break;
 			case KVM_BP_HARDEN_WA_NEEDED:
-				val = SMCCC_RET_SUCCESS;
+				val[0] = SMCCC_RET_SUCCESS;
 				break;
 			case KVM_BP_HARDEN_NOT_REQUIRED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val[0] = SMCCC_RET_NOT_REQUIRED;
 				break;
 			}
 			break;
@@ -41,31 +41,40 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			case KVM_SSBD_UNKNOWN:
 				break;
 			case KVM_SSBD_KERNEL:
-				val = SMCCC_RET_SUCCESS;
+				val[0] = SMCCC_RET_SUCCESS;
 				break;
 			case KVM_SSBD_FORCE_ENABLE:
 			case KVM_SSBD_MITIGATED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val[0] = SMCCC_RET_NOT_REQUIRED;
 				break;
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val = SMCCC_RET_SUCCESS;
+			val[0] = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
-		val = kvm_hypercall_pv_features(vcpu);
+		val[0] = kvm_hypercall_pv_features(vcpu);
 		break;
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		gpa = kvm_init_stolen_time(vcpu);
 		if (gpa != GPA_INVALID)
-			val = gpa;
+			val[0] = gpa;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+		val[0] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
+		val[1] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
+		val[2] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2;
+		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
 
-	smccc_set_retval(vcpu, val, 0, 0, 0);
+	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return 1;
 }
-- 
2.17.1

