Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5783418CE19
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 13:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCTMzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 08:55:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58656 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCTMzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 08:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9sJuQlZdjTLh4p9vc8U/OzHYsApB7N+ztV93SXfUXTY=; b=S+msKOf2a1fh8blY+Rww+BWM12
        nVEZN4NzwFV6andPM4+8lKK11q/OicWX2iQkylcgiiXoJXlNoBsNsuH3Hsp2RR8RDPZL2TdcCODPS
        uXqwQjWFKzeQTHtaizkhr7Eo97mIjvh21zbrPXi93EqkofUUhGO+C6IK+RNwVwfqauDddv3GldqOZ
        jfFfEHZEnFgz//yhDOiVCZfQldh+E+9GX+YRXaUAVYRX5jQUgr/PHWQVGE7cyWwVF36aIaotjD5Zk
        0y7RVQesMd3sxQR2DC76m8acC4k0uK2OUV9rbi/RfYT8M2tZQ3jZP6DJGye+lpHGnC+0OB1EyRrvO
        hrIvLsLg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFHAv-0000xV-Ux; Fri, 20 Mar 2020 12:54:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 40E9C305C92;
        Fri, 20 Mar 2020 13:54:55 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0E42E2858D5B2; Fri, 20 Mar 2020 13:54:55 +0100 (CET)
Date:   Fri, 20 Mar 2020 13:54:55 +0100
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
Message-ID: <20200320125455.GE20696@hirez.programming.kicks-ass.net>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-3-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320085527.23861-3-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 01:55:26AM -0700, Davidlohr Bueso wrote:
> -	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
> -				       (!vcpu->arch.pause)));
> +	rcuwait_wait_event(*wait,
> +			   (!vcpu->arch.power_off) && (!vcpu->arch.pause),
> +			   TASK_INTERRUPTIBLE);

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

Are these yet more instances that really want to be TASK_IDLE ?

