Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F262934EA
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404011AbgJTGXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:23:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbgJTGXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603175009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYBBFaywtQ+WHSPP8mqHtlCXgzq0Xbm6CyO640a+IUg=;
        b=ZgYnZwNHN5zFaq8R/fEilz6BTb9ik2PsSD+6T8sEx//L7IlAi26gcLNbmCBqyfuMobcGjG
        AmXF+22fZ/iHpTIersjFke7I3u/X+DPecTAngdgSE7fPRk/bO4YMowybu/rlIchtBFibqZ
        S3i6nZjJ2GxrF1CjrpCEq9HOmdw3Jm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-v9xI-lB8Obado3FWNetisw-1; Tue, 20 Oct 2020 02:23:27 -0400
X-MC-Unique: v9xI-lB8Obado3FWNetisw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E63D85EE94;
        Tue, 20 Oct 2020 06:23:24 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A389461983;
        Tue, 20 Oct 2020 06:23:16 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: not register a IRQ bypass producer if
 unsupported or disabled
To:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, mst@redhat.com
References: <20201019090657.131-1-zhenzhong.duan@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7ef3b498-bdc5-4a3d-d23b-ad58205ae1b7@redhat.com>
Date:   Tue, 20 Oct 2020 14:23:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019090657.131-1-zhenzhong.duan@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/19 下午5:06, Zhenzhong Duan wrote:
> If Post interrupt is disabled due to hardware limit or forcely disabled
> by "intremap=nopost" parameter, return -EINVAL so that the legacy mode IRQ
> isn't registered as IRQ bypass producer.


Is there any side effect if it was still registered?


>
> With this change, below message is printed:
> "vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -22"


I may miss something, but the patch only touches vhost-vDPA instead of VFIO?

Thanks


>
> ..which also hints us if a vfio or vdpa device works in PI mode or legacy
> remapping mode.
>
> Add a print to vdpa code just like what vfio_msi_set_vector_signal() does.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
> ---
>   arch/x86/kvm/svm/avic.c | 3 +--
>   arch/x86/kvm/vmx/vmx.c  | 5 ++---
>   drivers/vhost/vdpa.c    | 5 +++++
>   3 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ac830cd..316142a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -814,7 +814,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   
>   	if (!kvm_arch_has_assigned_device(kvm) ||
>   	    !irq_remapping_cap(IRQ_POSTING_CAP))
> -		return 0;
> +		return ret;
>   
>   	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
>   		 __func__, host_irq, guest_irq, set);
> @@ -899,7 +899,6 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   		}
>   	}
>   
> -	ret = 0;
>   out:
>   	srcu_read_unlock(&kvm->irq_srcu, idx);
>   	return ret;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f0a9954..1fed6d6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7716,12 +7716,12 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   	struct kvm_lapic_irq irq;
>   	struct kvm_vcpu *vcpu;
>   	struct vcpu_data vcpu_info;
> -	int idx, ret = 0;
> +	int idx, ret = -EINVAL;
>   
>   	if (!kvm_arch_has_assigned_device(kvm) ||
>   		!irq_remapping_cap(IRQ_POSTING_CAP) ||
>   		!kvm_vcpu_apicv_active(kvm->vcpus[0]))
> -		return 0;
> +		return ret;
>   
>   	idx = srcu_read_lock(&kvm->irq_srcu);
>   	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
> @@ -7787,7 +7787,6 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   		}
>   	}
>   
> -	ret = 0;
>   out:
>   	srcu_read_unlock(&kvm->irq_srcu, idx);
>   	return ret;
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 62a9bb0..b20060a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -107,6 +107,11 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>   	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>   	vq->call_ctx.producer.irq = irq;
>   	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> +	if (unlikely(ret))
> +		dev_info(&vdpa->dev,
> +		"irq bypass producer (token %p) registration fails: %d\n",
> +		vq->call_ctx.producer.token, ret);
> +
>   	spin_unlock(&vq->call_ctx.ctx_lock);
>   }
>   

