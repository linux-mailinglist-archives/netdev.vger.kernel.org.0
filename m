Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324AE2231E8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 06:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgGQEB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 00:01:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725300AbgGQEB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 00:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594958517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GnU865a+lrjDGK+CDwUgz8/N+HiB0/YUZTXlDxqFfkc=;
        b=Lnpoc3BAXud4leKJwabzAB77uXBySJEM4yjCK1gLgecj3xCS/6mvTEj/dhdY7Nn7n2MGkU
        EodA5HwTGdkbhTAwBtft+SnaiIXusxvy/4mSpqe4JEe5wkQPakque+zpZdzAmkpwp1c4vy
        vjVgnEIaY9tzCYFVvXBRjlSw/mYk46c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-AwkVz91IP9mfwhYFxiVpqg-1; Fri, 17 Jul 2020 00:01:53 -0400
X-MC-Unique: AwkVz91IP9mfwhYFxiVpqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0BCE1888AB4;
        Fri, 17 Jul 2020 04:01:51 +0000 (UTC)
Received: from [10.72.12.157] (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EB7D78A59;
        Fri, 17 Jul 2020 04:01:34 +0000 (UTC)
Subject: Re: [PATCH V2 2/6] kvm: detect assigned device via irqbypass manager
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f8e0ced4-2883-e022-8fd0-1224987ebef1@redhat.com>
Date:   Fri, 17 Jul 2020 12:01:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/16 下午7:23, Zhu Lingshan wrote:
> vDPA devices has dedicated backed hardware like
> passthrough-ed devices. Then it is possible to setup irq
> offloading to vCPU for vDPA devices. Thus this patch tries to
> manipulated assigned device counters via irqbypass manager.


This part needs some tweak, e.g why assigned device could be detected 
through this way.


>
> We will increase/decrease the assigned device counter in kvm/x86.


And you need explain why we don't need similar thing in other arch.

Thanks


> Both vDPA and VFIO would go through this code path.
>
> This code path only affect x86 for now.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2..20c07d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>   {
>   	struct kvm_kernel_irqfd *irqfd =
>   		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +	int ret;
>   
>   	irqfd->producer = prod;
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
>   }
>   
>   void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,

