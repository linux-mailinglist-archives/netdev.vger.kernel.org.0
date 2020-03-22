Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5495918EA7C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 17:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCVQe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 12:34:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:52958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgCVQe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 12:34:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93574AC24;
        Sun, 22 Mar 2020 16:34:24 +0000 (UTC)
Date:   Sun, 22 Mar 2020 09:33:17 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, arnd@arndb.de, balbi@kernel.org,
        bhelgaas@google.com, bigeasy@linutronix.de, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, rdunlap@infradead.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 18/15] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200322163317.mh4sygr7xcjptmjp@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-3-dave@stgolabs.net>
 <20200320125455.GE20696@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200320125455.GE20696@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020, Peter Zijlstra wrote:

>On Fri, Mar 20, 2020 at 01:55:26AM -0700, Davidlohr Bueso wrote:
>> -	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
>> -				       (!vcpu->arch.pause)));
>> +	rcuwait_wait_event(*wait,
>> +			   (!vcpu->arch.power_off) && (!vcpu->arch.pause),
>> +			   TASK_INTERRUPTIBLE);
>
>> -	for (;;) {
>> -		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>> -
>> -		if (kvm_vcpu_check_block(vcpu) < 0)
>> -			break;
>> -
>> -		waited = true;
>> -		schedule();
>> -	}
>> -
>> -	finish_swait(&vcpu->wq, &wait);
>> +	rcuwait_wait_event(&vcpu->wait,
>> +			   (block_check = kvm_vcpu_check_block(vcpu)) < 0,
>> +			   TASK_INTERRUPTIBLE);
>
>Are these yet more instances that really want to be TASK_IDLE ?

Hmm probably as it makes sense for a blocked vcpu not to be contributing to
the loadavg. So if this is the only reason to use interruptible, then yes we
ought to change it.

However, I'll make this a separate patch, given this (ab)use isn't as obvious
as the PS3 case, which is a kthread and therefore signals are masked.

Thanks,
Davidlohr
