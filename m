Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEB299917
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390827AbgJZVus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:50:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42764 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390765AbgJZVus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 17:50:48 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603749045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jS5TKaNLYCMODDgdbkh4zfnY1pna4ZfDovtmHgoblw0=;
        b=xmvetfBh/b8it/gGdv6/tmOnqnOEnxpqZNuaMEjYXVD8e5w1SzFCTU0vLGBfZkJBo7mCyp
        5LU+bz1ZakdwSEcEKTdTJeoOjKSZi3diDze0VNxZh31ITYZ7INMYmDexzBL9NUsBYDrlzc
        pgx+n3wmT93XEyzAy7PdO0XjwH2gI7i83oHB7D6fRZAN9DKSDzjjzUQumFfOuc4W8og+ut
        pGcTRmDz8ZjE2g0779DoZjckwZexxDKE80woVLktgum1x+3oa5ZRz3TgOFznwbN/ZgXwGd
        DHUtO4WURxSnPpZTpxPgkIoDW6xhjwjCvV6cVhgGRId/pKZseyjUKfuO+G24cA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603749045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jS5TKaNLYCMODDgdbkh4zfnY1pna4ZfDovtmHgoblw0=;
        b=FkMYb/ULW2VY1knuhDf/d4xcNo4ong2VK1Op/5A5qZ9KUjo9kHg99nFyLlbbWsG1H+R2KR
        lxMKvWCmJ/ao+VBA==
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <85b5f53e-5be2-beea-269a-f70029bea298@intel.com>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <20201026173012.GA377978@fuller.cnet> <875z6w4xt4.fsf@nanos.tec.linutronix.de> <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com> <87v9ew3fzd.fsf@nanos.tec.linutronix.de> <85b5f53e-5be2-beea-269a-f70029bea298@intel.com>
Date:   Mon, 26 Oct 2020 22:50:45 +0100
Message-ID: <87lffs3bd6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 14:11, Jacob Keller wrote:
> On 10/26/2020 1:11 PM, Thomas Gleixner wrote:
>> On Mon, Oct 26 2020 at 12:21, Jacob Keller wrote:
>>> Are there drivers which use more than one interrupt per queue? I know
>>> drivers have multiple management interrupts.. and I guess some drivers
>>> do combined 1 interrupt per pair of Tx/Rx..  It's also plausible to to
>>> have multiple queues for one interrupt .. I'm not sure how a single
>>> queue with multiple interrupts would work though.
>> 
>> For block there is always one interrupt per queue. Some Network drivers
>> seem to have seperate RX and TX interrupts per queue.
> That's true when thinking of Tx and Rx as a single queue. Another way to
> think about it is "one rx queue" and "one tx queue" each with their own
> interrupt...
>
> Even if there are devices which force there to be exactly queue pairs,
> you could still think of them as separate entities?

Interesting thought.

But as Jakub explained networking queues are fundamentally different
from block queues on the RX side. For block the request issued on queue
X will raise the complete interrupt on queue X.

For networking the TX side will raise the TX interrupt on the queue on
which the packet was queued obviously or should I say hopefully. :)

But incoming packets will be directed to some receive queue based on a
hash or whatever crystallball logic the firmware decided to implement.

Which makes this not really suitable for the managed interrupt and
spreading approach which is used by block-mq. Hrm...

But I still think that for curing that isolation stuff we want at least
some information from the driver. Alternative solution would be to grant
the allocation of interrupts and queues and have some sysfs knob to shut
down queues at runtime. If that shutdown results in releasing the queue
interrupt (via free_irq()) then the vector exhaustion problem goes away.

Needs more thought and information (for network oblivious folks like
me).

Thanks,

        tglx
