Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3242518ED03
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 23:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCVWd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 18:33:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47612 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCVWd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 18:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zS+FVq9GRAqW8korIhuLbfacLrfQT3Nbm32pK6UBBgc=; b=RJgvyIj2PxYSWCGVEpK6gTGg/s
        +rX4ZIHdy8MbnOdAOy+rdpiPLxePo/GhIpvRmhZXSuedinY7g+jwczuq4zxIFOEtJ1A2k/TjaZ1FV
        SSHl7aBwkGX2nuyzzrjOwQEKStsafORwWMAC+D3Hybly/JkJqi9szuvm1yO4WzRzOWoVuhbcmSV5I
        wd7LHXncK1GOiQFEW/enb9ikH6MpnZtEHhRTb1ocvVPi91KT81dtipHRnm4xXq7/trST69peXntw1
        06xaLNePQu7/8kLriu1ISEBmE0y5MwH6O0omcRd6kkDkNotJlRm1OHXgIlelr8GRS8n3gPaiYhtQA
        aI33aYOA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jG99N-0001i9-0j; Sun, 22 Mar 2020 22:32:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A35803010CF;
        Sun, 22 Mar 2020 23:32:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6464C299F245C; Sun, 22 Mar 2020 23:32:49 +0100 (CET)
Date:   Sun, 22 Mar 2020 23:32:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Davidlohr Bueso <dave@stgolabs.net>
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
Message-ID: <20200322223249.GK20696@hirez.programming.kicks-ass.net>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-3-dave@stgolabs.net>
 <20200320125455.GE20696@hirez.programming.kicks-ass.net>
 <20200322163317.mh4sygr7xcjptmjp@linux-p48b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322163317.mh4sygr7xcjptmjp@linux-p48b>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 09:33:17AM -0700, Davidlohr Bueso wrote:
> On Fri, 20 Mar 2020, Peter Zijlstra wrote:
> 
> > On Fri, Mar 20, 2020 at 01:55:26AM -0700, Davidlohr Bueso wrote:
> > > -	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
> > > -				       (!vcpu->arch.pause)));
> > > +	rcuwait_wait_event(*wait,
> > > +			   (!vcpu->arch.power_off) && (!vcpu->arch.pause),
> > > +			   TASK_INTERRUPTIBLE);
> > 
> > > -	for (;;) {
> > > -		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> > > -
> > > -		if (kvm_vcpu_check_block(vcpu) < 0)
> > > -			break;
> > > -
> > > -		waited = true;
> > > -		schedule();
> > > -	}
> > > -
> > > -	finish_swait(&vcpu->wq, &wait);
> > > +	rcuwait_wait_event(&vcpu->wait,
> > > +			   (block_check = kvm_vcpu_check_block(vcpu)) < 0,
> > > +			   TASK_INTERRUPTIBLE);
> > 
> > Are these yet more instances that really want to be TASK_IDLE ?
> 
> Hmm probably as it makes sense for a blocked vcpu not to be contributing to
> the loadavg. So if this is the only reason to use interruptible, then yes we
> ought to change it.
> 
> However, I'll make this a separate patch, given this (ab)use isn't as obvious
> as the PS3 case, which is a kthread and therefore signals are masked.

The thing that was a dead give-away was that the return value of the
interruptible wait wasn't used.
