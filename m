Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED3C21C9FC
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 17:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgGLP3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 11:29:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46194 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728840AbgGLP3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 11:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594567752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFrF3EbQ76BoanXtBOwfOHtU1KUbzMZo9fz3ulVTvys=;
        b=d4t3fuR3ZJZvqLXt39DlKKlnulhq4qqwqt4HV+tN9TK8ro/irU7yip5V1fafweT7Dkv6k2
        cLvVhfhO5laXAf5XoaoJ8dmh56joiqUIcUAdk5UJVqVNtCLNsRIAEzJQFs7kusYgumv5i/
        litlmKW1daDA7Oa0hyCvPh3Bi0kh88c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-YgHa_-TAM9C7v0U8PDB5Zg-1; Sun, 12 Jul 2020 11:29:09 -0400
X-MC-Unique: YgHa_-TAM9C7v0U8PDB5Zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A35418FF67E;
        Sun, 12 Jul 2020 15:29:07 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BB9F74F4D;
        Sun, 12 Jul 2020 15:29:03 +0000 (UTC)
Date:   Sun, 12 Jul 2020 09:29:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
Subject: Re: [PATCH 2/7] kvm/vfio: detect assigned device via irqbypass
 manager
Message-ID: <20200712092902.5960f340@x1.home>
In-Reply-To: <1594565366-3195-2-git-send-email-lingshan.zhu@intel.com>
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
        <1594565366-3195-2-git-send-email-lingshan.zhu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 22:49:21 +0800
Zhu Lingshan <lingshan.zhu@intel.com> wrote:

> We used to detect assigned device via VFIO manipulated device
> conters. This is less flexible consider VFIO is not the only
> interface for assigned device. vDPA devices has dedicated
> backed hardware as well. So this patch tries to detect
> the assigned device via irqbypass manager.
> 
> We will increase/decrease the assigned device counter in kvm/x86.
> Both vDPA and VFIO would go through this code path.
> 
> This code path only affect x86 for now.

No it doesn't, it only adds VFIO support to x86, but it removes it from
architecture neutral code.  Also a VFIO device does not necessarily
make use of the irqbypass manager, this depends on platform support and
enablement of this feature.   Therefore, NAK.  Thanks,

Alex
 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  virt/kvm/vfio.c    |  2 --
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2..20c07d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>  {
>  	struct kvm_kernel_irqfd *irqfd =
>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +	int ret;
>  
>  	irqfd->producer = prod;
> +	kvm_arch_start_assignment(irqfd->kvm);
> +	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
> +					 prod->irq, irqfd->gsi, 1);
> +
> +	if (ret)
> +		kvm_arch_end_assignment(irqfd->kvm);
>  
> -	return kvm_x86_ops.update_pi_irte(irqfd->kvm,
> -					   prod->irq, irqfd->gsi, 1);
> +	return ret;
>  }
>  
>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 8fcbc50..111da52 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -226,7 +226,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>  		list_add_tail(&kvg->node, &kv->group_list);
>  		kvg->vfio_group = vfio_group;
>  
> -		kvm_arch_start_assignment(dev->kvm);
>  
>  		mutex_unlock(&kv->lock);
>  
> @@ -254,7 +253,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>  				continue;
>  
>  			list_del(&kvg->node);
> -			kvm_arch_end_assignment(dev->kvm);
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
>  			kvm_spapr_tce_release_vfio_group(dev->kvm,
>  							 kvg->vfio_group);

