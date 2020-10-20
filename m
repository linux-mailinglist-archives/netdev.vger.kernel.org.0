Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F1F293507
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404336AbgJTGca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730619AbgJTGc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603175548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUV7+7Yb5gWkt6R5BK6/Nubk0EIUzqlyn1lORobljU8=;
        b=Jz7RDHtXTXvhtf8nQIX8KEzgi4N9srlBn/yyO3DxUQ5wbJvmYAymYw4fz+9NMJauXb+saH
        AFKHqnLktoW1ZQjOw8Lp2hEHaXTNhXXwBqauILaffTB8OG6Updcvm+d04FKZDv1vu5qH8L
        onc33xfPjrdRlCOY7OzuNjXVEzG+hes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-TllFas1gNjWKqFl0xh-Dfg-1; Tue, 20 Oct 2020 02:32:24 -0400
X-MC-Unique: TllFas1gNjWKqFl0xh-Dfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E71A01006C8C;
        Tue, 20 Oct 2020 06:32:21 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E70976EF59;
        Tue, 20 Oct 2020 06:32:13 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: not link irqfd with a fake IRQ bypass producer
To:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, mst@redhat.com
References: <20201019090657.131-1-zhenzhong.duan@gmail.com>
 <20201019090657.131-2-zhenzhong.duan@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7eec99d5-e36b-ee5b-5b6c-1486e453a083@redhat.com>
Date:   Tue, 20 Oct 2020 14:32:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019090657.131-2-zhenzhong.duan@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/19 下午5:06, Zhenzhong Duan wrote:
> In case failure to setup Post interrupt for an IRQ, it make no sense
> to assign irqfd->producer to the producer.
>
> This change makes code more robust.


It's better to describe what issue we will get without this patch.

Thanks


>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
> ---
>   arch/x86/kvm/x86.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ce856e0..277e961 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10683,13 +10683,14 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>   		container_of(cons, struct kvm_kernel_irqfd, consumer);
>   	int ret;
>   
> -	irqfd->producer = prod;
>   	kvm_arch_start_assignment(irqfd->kvm);
>   	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
>   					 prod->irq, irqfd->gsi, 1);
>   
>   	if (ret)
>   		kvm_arch_end_assignment(irqfd->kvm);
> +	else
> +		irqfd->producer = prod;
>   
>   	return ret;
>   }

