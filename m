Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A44D29789B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 23:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465760AbgJWVA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 17:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S370824AbgJWVA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 17:00:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94939C0613CE;
        Fri, 23 Oct 2020 14:00:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603486852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0RSzWnnhjduTWCuacybUxNyH2jm/Ejki0DZB09ZfMEo=;
        b=uC/F8SS7ceachXOn7laO0v51Jz5qp/rU44VpsVtuP1Na+r9KOVItKiq2MvIK91/vJKqdM/
        Yon7/psKTWzxsjJayfT4a72WsiroXOtKf7tzvwjPn5Fri6uLj7pDlxOtFwe4DM4XqReG3m
        QiPGbJhJac2HT/rR70hkUr0UOq7Pn6lKWKmgnTr40/2fMqKA7qiZguR2dxaaMgmmeJGHzC
        bv6taa5peKBeMMjOF71Ta78FrppqLS9dSNpODsEjYibkDhoIylQ2mQwweYG4g9fc0pDJfr
        qKrJ7YsxMLUrh+7aRcH/GMIBQYf42IvPRrPsiYLISmDrqKxG2zoiTpaIIwOLxg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603486852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0RSzWnnhjduTWCuacybUxNyH2jm/Ejki0DZB09ZfMEo=;
        b=7RgxZS9baabbqKcQfsa0dn/XjSu7U/Vml4D0Og0NWaVNkzdzTSdGSZiL1/090nxRSD5pkh
        LfLURkRpikZlX+Dg==
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
References: <20200928183529.471328-5-nitesh@redhat.com> <20201016122046.GP2611@hirez.programming.kicks-ass.net> <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com> <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
Date:   Fri, 23 Oct 2020 23:00:52 +0200
Message-ID: <87ft6464jf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23 2020 at 09:10, Nitesh Narayan Lal wrote:
> On 10/23/20 4:58 AM, Peter Zijlstra wrote:
>> On Thu, Oct 22, 2020 at 01:47:14PM -0400, Nitesh Narayan Lal wrote:
>> So shouldn't we then fix the drivers / interface first, to get rid of
>> this inconsistency?
>>
> Considering we agree that excess vector is a problem that needs to be
> solved across all the drivers and that you are comfortable with the other
> three patches in the set. If I may suggest the following:
>
> - We can pick those three patches for now, as that will atleast fix a
> =C2=A0 driver that is currently impacting RT workloads. Is that a fair
> =C2=A0 expectation?

No. Blindly reducing the maximum vectors to the number of housekeeping
CPUs is patently wrong. The PCI core _cannot_ just nilly willy decide
what the right number of interrupts for this situation is.

Many of these drivers need more than queue interrupts, admin, error
interrupt and some operate best with seperate RX/TX interrupts per
queue. They all can "work" with a single PCI interrupt of course, but
the price you pay is performance.

An isolated setup, which I'm familiar with, has two housekeeping
CPUs. So far I restricted the number of network queues with a module
argument to two, which allocates two management interrupts for the
device and two interrupts (RX/TX) per queue, i.e. a total of six.

Now I reduced the number of available interrupts to two according to
your hack, which makes it use one queue RX/TX combined and one
management interrupt. Guess what happens? Network performance tanks to
the points that it breaks a carefully crafted setup.

The same applies to a device which is application specific and wants one
channel including an interrupt per isolated application core. Today I
can isolate 8 out of 12 CPUs and let the device create 8 channels and
set one interrupt and channel affine to each isolated CPU. With your
hack, I get only 4 interrupts and channels. Fail!

You cannot declare that all this is perfectly fine, just because it does
not matter for your particular use case.

So without information from the driver which tells what the best number
of interrupts is with a reduced number of CPUs, this cutoff will cause
more problems than it solves. Regressions guaranteed.

Managed interrupts base their interrupt allocation and spreading on
information which is handed in by the individual driver and not on crude
assumptions. They are not imposing restrictions on the use case.

It's perfectly fine for isolated work to save a data set to disk after
computation has finished and that just works with the per-cpu I/O queue
which is otherwise completely silent. All isolated workers can do the
same in parallel without trampling on each other toes by competing for a
reduced number of queues which are affine to the housekeeper CPUs.

Unfortunately network multi-queue is substantially different from block
multi-queue (as I learned in this conversation), so the concept cannot
be applied one-to-one to networking as is. But there are certainly part
of it which can be reused.

This needs a lot more thought than just these crude hacks.

Especially under the aspect that there are talks about making isolation
runtime switchable. Are you going to rmmod/insmod the i40e network
driver to do so? That's going to work fine if you do that
reconfiguration over network...

Thanks,

        tglx
