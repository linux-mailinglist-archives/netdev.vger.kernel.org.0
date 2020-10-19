Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31B292452
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 11:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgJSJHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 05:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgJSJHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 05:07:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CDEC0613CE;
        Mon, 19 Oct 2020 02:07:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b23so5655635pgb.3;
        Mon, 19 Oct 2020 02:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OYVQGqeoUsyygZEDJbsttq3Q79Q31R4DhEWJATOHDyo=;
        b=UJPKh1Ot7CsnAgaopJKem4Czo9cR5N+HS+cErFD1/h65tMj7tTSVXNy4WPLu5pNcAE
         SWnX5N0/822hEslNViFWWIMoqE9NSiD0ojggL5Ryw2F5M0YF/xip/4kpExLRv8L89n1B
         IU8P/IoH9lANK5Ko833aYINWTheWdBFBdksLSwJ73ckRA9PVtES1cR76AWVdbMaHP/j/
         SudfspxxZBmJYlpfRaf3CPWKVl2aQ2q3JY/yVat8tEhhqIJQcLgZt8JFjSYqOordc0AF
         aIGHQaREB0/sKeaCYIj7y4OCGkKk/PbRdm/QV54QS0UmtO2yhW+1TPlFsEWi5zHOps4d
         FgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OYVQGqeoUsyygZEDJbsttq3Q79Q31R4DhEWJATOHDyo=;
        b=lX5MhQaN70QtijSRIVr06uCuh+Vv/xTMgvA7/0qmNY7p3B+YzmK/maByQ54cYcBDqY
         J5LQBEph6vvg5aJ4G547Rf3Qb0QryyZP+2Eisu8UuS/38kPyh/VzK8z9zBE4vCry9+2p
         JRlokpEODBCu8k7wIzcf8Dhsbb1lLflSKNhoKWl1tRmW7VU3FNjgVuVU3oXxCG5H/toN
         C+AzK1k8V+fBVMSgIz5bJrc1Ad4BlPNP52y8H9FGgk/1JNbZqkJWi5xm6tm1zDt2Ds4V
         prJ9TUQLNjr9dKPxq7SAh+SJT9hq2iDOIx+7/2ZR8G24myzcLu7CbIaoHfFELASuT4s7
         ++GA==
X-Gm-Message-State: AOAM531aKdIc2FMF5iKZLQ3MVJIU5fJ+LL7GmCN7T5+Jo7nEGaFQ3S9C
        rKsbKIF4XUL+IR0Rd55i9uu6QT/0TSI=
X-Google-Smtp-Source: ABdhPJwKwqiTnb6aTiekUrUU1EAbnHPb2lAhuehaaEZngU1Dh1m6mNeXPLFqtvWtJAjeDQiI5juhlw==
X-Received: by 2002:a62:37c4:0:b029:155:ebd8:304c with SMTP id e187-20020a6237c40000b0290155ebd8304cmr16112104pfa.73.1603098440227;
        Mon, 19 Oct 2020 02:07:20 -0700 (PDT)
Received: from ZB-PF0YQ8ZU.360buyad.local ([137.116.162.235])
        by smtp.gmail.com with ESMTPSA id e1sm11263016pfd.198.2020.10.19.02.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 02:07:19 -0700 (PDT)
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
To:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, mst@redhat.com,
        jasowang@redhat.com, Zhenzhong Duan <zhenzhong.duan@gmail.com>
Subject: [PATCH 1/2] KVM: not register a IRQ bypass producer if unsupported or disabled
Date:   Mon, 19 Oct 2020 17:06:56 +0800
Message-Id: <20201019090657.131-1-zhenzhong.duan@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If Post interrupt is disabled due to hardware limit or forcely disabled
by "intremap=nopost" parameter, return -EINVAL so that the legacy mode IRQ
isn't registered as IRQ bypass producer.

With this change, below message is printed:
"vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -22"

..which also hints us if a vfio or vdpa device works in PI mode or legacy
remapping mode.

Add a print to vdpa code just like what vfio_msi_set_vector_signal() does.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
---
 arch/x86/kvm/svm/avic.c | 3 +--
 arch/x86/kvm/vmx/vmx.c  | 5 ++---
 drivers/vhost/vdpa.c    | 5 +++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ac830cd..316142a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -814,7 +814,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 
 	if (!kvm_arch_has_assigned_device(kvm) ||
 	    !irq_remapping_cap(IRQ_POSTING_CAP))
-		return 0;
+		return ret;
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
 		 __func__, host_irq, guest_irq, set);
@@ -899,7 +899,6 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		}
 	}
 
-	ret = 0;
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f0a9954..1fed6d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7716,12 +7716,12 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
-	int idx, ret = 0;
+	int idx, ret = -EINVAL;
 
 	if (!kvm_arch_has_assigned_device(kvm) ||
 		!irq_remapping_cap(IRQ_POSTING_CAP) ||
 		!kvm_vcpu_apicv_active(kvm->vcpus[0]))
-		return 0;
+		return ret;
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
@@ -7787,7 +7787,6 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		}
 	}
 
-	ret = 0;
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 62a9bb0..b20060a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -107,6 +107,11 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
 	vq->call_ctx.producer.irq = irq;
 	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
+	if (unlikely(ret))
+		dev_info(&vdpa->dev,
+		"irq bypass producer (token %p) registration fails: %d\n",
+		vq->call_ctx.producer.token, ret);
+
 	spin_unlock(&vq->call_ctx.ctx_lock);
 }
 
-- 
1.8.3.1

