Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A994B2242EA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgGQSI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:08:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28610 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726938AbgGQSI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595009308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPhFSCTfpcpWkz9CIuqaJPhW6IIR42pEKKIJvtsM+sg=;
        b=OyN1wNuDZnL6Fe8ymhiJn/36NXXaDpM6o4VxYzr+jU+qZO3asetYnS6Bm5XPjwAg7OBvjM
        eo1sXNs55Lbe7vT/jkiebQLRjz6xxMhvvvJRzcKjmiRS6L6LLQHQ+4qer9JtEUttc27LEb
        ALk9nzOIWDAApMw56BHtgVwX+E6nSw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-k1gwiikpOm2kITgryY5lnA-1; Fri, 17 Jul 2020 14:08:26 -0400
X-MC-Unique: k1gwiikpOm2kITgryY5lnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81B8780183C;
        Fri, 17 Jul 2020 18:08:25 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0026779D1D;
        Fri, 17 Jul 2020 18:08:21 +0000 (UTC)
Date:   Fri, 17 Jul 2020 12:08:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V2 2/6] kvm: detect assigned device via irqbypass
 manager
Message-ID: <20200717120821.3c2a56db@x1.home>
In-Reply-To: <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
        <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 19:23:45 +0800
Zhu Lingshan <lingshan.zhu@intel.com> wrote:

> vDPA devices has dedicated backed hardware like
> passthrough-ed devices. Then it is possible to setup irq
> offloading to vCPU for vDPA devices. Thus this patch tries to
> manipulated assigned device counters via irqbypass manager.
> 
> We will increase/decrease the assigned device counter in kvm/x86.
> Both vDPA and VFIO would go through this code path.
> 
> This code path only affect x86 for now.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
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


Why isn't there a matching end-assignment in the del_producer path?  It
seems this only goes one-way, what happens when a device is
hot-unplugged from the VM or the device interrupt configuration changes.
This will still break vfio if it's not guaranteed to be symmetric.
Thanks,

Alex

