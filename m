Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675C918CCAC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgCTLVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:21:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34515 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgCTLVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584703259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/3NXaZ2sRQX1DOuwaMBeQJLBn8vkE3WrE+NitGKiqA=;
        b=b0m6s63SvoOQFUMtcR474SKLjefYOkwW92QYD0IGnUATNRPnbzsU1XvLRdUdoj0BAge97d
        /ZHW03CEFv55Bhpm8AQKRjwg9SRHgI3kEqAumZixuB4CC/fmD2l3wjMVZEjz2QoFsl021T
        S7DvUuWWpJwsELO8L3Hmk4qXTU4nYSI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-7zoNV9VWO8GP3HqCCDWyfg-1; Fri, 20 Mar 2020 07:20:57 -0400
X-MC-Unique: 7zoNV9VWO8GP3HqCCDWyfg-1
Received: by mail-wr1-f72.google.com with SMTP id u12so2486246wrw.10
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 04:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/3NXaZ2sRQX1DOuwaMBeQJLBn8vkE3WrE+NitGKiqA=;
        b=VW5YzeGfuc220XA3Tr76B1Jw1vWHVVLwp7LZ9iZmwzxZuNsyXycm9Xg/U9Uts+kr6u
         T8VjZ+8UJjngW0Ysb+dIwfpkoVkVJT7vs0mErKP4vYRanMNk8AFVe2jgXrOeS6fzUx0W
         KJCbwOuDZZxQwqgRZBns6KmHDp2Dss0IK+18HfXjQH465DIrZ+tEG7sbL1rKqRumbN1Y
         5bZO0q2+qXBfj18W0XZm0vqmhc/dPLklevL9UlRiLkU1G9rOcl08alwmMqDdFzNy+QaK
         /5tI8f5HI6QwOs8f+Tvd830mJnX3hnvIEHWwNgtM1iLTGCvi69FtEhqaa7d7h7CLK/G9
         jlQw==
X-Gm-Message-State: ANhLgQ3FolF44O7oD5ByF+h6TzpRY5I/YywzrD2GjQdSg+tPOPHX0Uzb
        hs7VToL121+6odqdviAf8PD6lnwX+wZXM1KRxfTwcQyo+GKtiVGodeqVCc/ArhFQa3g8+c3edIo
        a5i958S4h5ImhU5it
X-Received: by 2002:a7b:c185:: with SMTP id y5mr9591190wmi.179.1584703256194;
        Fri, 20 Mar 2020 04:20:56 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuSOEQTHzVsVT/ip5Zea40OMJaocP0teB9e+S0wZpsO4/tb7JdwYPz+IBInWzuFqQnCpGnDmg==
X-Received: by 2002:a7b:c185:: with SMTP id y5mr9591008wmi.179.1584703254449;
        Fri, 20 Mar 2020 04:20:54 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id s1sm7897400wrp.41.2020.03.20.04.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 04:20:53 -0700 (PDT)
Subject: Re: [PATCH 18/15] kvm: Replace vcpu->swait with rcuwait
To:     Davidlohr Bueso <dave@stgolabs.net>, tglx@linutronix.de
Cc:     arnd@arndb.de, balbi@kernel.org, bhelgaas@google.com,
        bigeasy@linutronix.de, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Davidlohr Bueso <dbueso@suse.de>,
        Paul Mackerras <paulus@ozlabs.org>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-3-dave@stgolabs.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2343d524-b600-2696-06a5-33c0d191a630@redhat.com>
Date:   Fri, 20 Mar 2020 12:20:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320085527.23861-3-dave@stgolabs.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/20 09:55, Davidlohr Bueso wrote:
> Only compiled and tested on x86.

It shows :) as the __KVM_HAVE_ARCH_WQP case is broken.  But no problem, 
Paul and I can pick this up and fix it.

This is missing:

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 506e4df2d730..6e5d85ba588d 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -78,7 +78,7 @@ struct kvmppc_vcore {
 	struct kvm_vcpu *runnable_threads[MAX_SMT_THREADS];
 	struct list_head preempt_list;
 	spinlock_t lock;
-	struct swait_queue_head wq;
+	struct rcuwait wait;
 	spinlock_t stoltb_lock;	/* protects stolen_tb and preempt_tb */
 	u64 stolen_tb;
 	u64 preempt_tb;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1af96fb5dc6f..8c8122c30b89 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -754,7 +754,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto out_vcpu_uninit;
 
-	vcpu->arch.wqp = &vcpu->wq;
+	vcpu->arch.waitp = &vcpu->wait;
 	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
 	return 0;
 

and...

> -static inline struct swait_queue_head *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
> +static inline struct rcuwait *kvm_arch_vcpu_get_wait(struct kvm_vcpu *vcpu)
>  {
>  #ifdef __KVM_HAVE_ARCH_WQP
> -	return vcpu->arch.wqp;
> +	return vcpu->arch.wait;

... this needs to be vcpu->arch.waitp.  That should be it.

Thanks!

Paolo

>  #else
> -	return &vcpu->wq;
> +	return &vcpu->wait;
>  #endif
>  }
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 0d9438e9de2a..4be71cb58691 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -593,7 +593,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  	if (map.emul_ptimer)
>  		soft_timer_cancel(&map.emul_ptimer->hrtimer);
>  
> -	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
> +	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)
>  		kvm_timer_blocking(vcpu);
>  
>  	/*
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index eda7b624eab8..4a704866e9b6 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -579,16 +579,17 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		vcpu->arch.pause = false;
> -		swake_up_one(kvm_arch_vcpu_wq(vcpu));
> +		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
>  	}
>  }
>  
>  static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>  {
> -	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> +	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>  
> -	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
> -				       (!vcpu->arch.pause)));
> +	rcuwait_wait_event(*wait,
> +			   (!vcpu->arch.power_off) && (!vcpu->arch.pause),
> +			   TASK_INTERRUPTIBLE);
>  
>  	if (vcpu->arch.power_off || vcpu->arch.pause) {
>  		/* Awaken to handle a signal, request we sleep again later. */
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 15e5b037f92d..10b533f641a6 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -80,8 +80,7 @@ static void async_pf_execute(struct work_struct *work)
>  
>  	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
>  
> -	if (swq_has_sleeper(&vcpu->wq))
> -		swake_up_one(&vcpu->wq);
> +	rcuwait_wake_up(&vcpu->wait);
>  
>  	mmput(mm);
>  	kvm_put_kvm(vcpu->kvm);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce0e5c1..6b49dcb321e2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -343,7 +343,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  	vcpu->kvm = kvm;
>  	vcpu->vcpu_id = id;
>  	vcpu->pid = NULL;
> -	init_swait_queue_head(&vcpu->wq);
> +	rcuwait_init(&vcpu->wait);
>  	kvm_async_pf_vcpu_init(vcpu);
>  
>  	vcpu->pre_pcpu = -1;
> @@ -2465,9 +2465,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	ktime_t start, cur;
> -	DECLARE_SWAITQUEUE(wait);
> -	bool waited = false;
>  	u64 block_ns;
> +	int block_check = -EINTR;
>  
>  	kvm_arch_vcpu_blocking(vcpu);
>  
> @@ -2487,21 +2486,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  					++vcpu->stat.halt_poll_invalid;
>  				goto out;
>  			}
> +
>  			cur = ktime_get();
>  		} while (single_task_running() && ktime_before(cur, stop));
>  	}
>  
> -	for (;;) {
> -		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> -
> -		if (kvm_vcpu_check_block(vcpu) < 0)
> -			break;
> -
> -		waited = true;
> -		schedule();
> -	}
> -
> -	finish_swait(&vcpu->wq, &wait);
> +	rcuwait_wait_event(&vcpu->wait,
> +			   (block_check = kvm_vcpu_check_block(vcpu)) < 0,
> +			   TASK_INTERRUPTIBLE);
>  	cur = ktime_get();
>  out:
>  	kvm_arch_vcpu_unblocking(vcpu);
> @@ -2525,18 +2517,18 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> +	trace_kvm_vcpu_wakeup(block_ns, block_check < 0 ? false : true,
> +			      vcpu_valid_wakeup(vcpu));
>  	kvm_arch_vcpu_block_finish(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_block);
>  
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
>  {
> -	struct swait_queue_head *wqp;
> +	struct rcuwait *wait;
>  
> -	wqp = kvm_arch_vcpu_wq(vcpu);
> -	if (swq_has_sleeper(wqp)) {
> -		swake_up_one(wqp);
> +	wait = kvm_arch_vcpu_get_wait(vcpu);
> +	if (rcuwait_wake_up(wait)) {
>  		WRITE_ONCE(vcpu->ready, true);
>  		++vcpu->stat.halt_wakeup;
>  		return true;
> @@ -2678,7 +2670,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  				continue;
>  			if (vcpu == me)
>  				continue;
> -			if (swait_active(&vcpu->wq) && !vcpu_dy_runnable(vcpu))
> +			if (rcu_dereference(vcpu->wait.task) &&
> +			    !vcpu_dy_runnable(vcpu))
>  				continue;
>  			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
>  				!kvm_arch_vcpu_in_kernel(vcpu))
> 

