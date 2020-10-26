Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E742997B8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 21:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgJZULF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 16:11:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42196 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730303AbgJZULE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 16:11:04 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603743062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+PS6gYDSMvwJoN1FTHRdqvfX6lNIJ+gYdIEt2bNoQ8=;
        b=kdQzswCGzg3Z+6EV7q0nZNMNXJ8qc9zZqXMPiqOeSORB6v2cw6FuaMmBBBt3doPeVr32cL
        3Yc6LqeIgyNTfswN6zM6Aj84d6/Sb2E/hCRNiO2jZt4GEkAoOHzd8BTnn/XkFoJr1WsqKE
        sizuxIbXYyMhe21s0gUlWhv9xlStvpfjpV5bOp/neVVPm7i+Jauf8Pz3jDa0cfiOc8ZYFn
        pisu4H5ia1WUolOQKfrKF7nWkcH5WpR1ub7fhRk2dvExBoucgRUnvdwe9//eYaRIN/KjW7
        cHdP5iVEDTNMYJWdZd2Fy39vXX0oWbq9HDQj5ctUlZR2viB/IAiV+nXli6769g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603743062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+PS6gYDSMvwJoN1FTHRdqvfX6lNIJ+gYdIEt2bNoQ8=;
        b=75kDgynk1PiCyVqyRR1lvYBAb/SvfUPyH4B4xZqU8aMuSg9TGlvtaEz7zktx1sVq92mIKw
        qpgsGbcLl8lpunAQ==
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
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <20201026173012.GA377978@fuller.cnet> <875z6w4xt4.fsf@nanos.tec.linutronix.de> <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com>
Date:   Mon, 26 Oct 2020 21:11:02 +0100
Message-ID: <87v9ew3fzd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 12:21, Jacob Keller wrote:
> On 10/26/2020 12:00 PM, Thomas Gleixner wrote:
>> How does userspace know about the driver internals? Number of management
>> interrupts, optimal number of interrupts per queue?
>
> I guess this is the problem solved in part by the queue management work
> that would make queues a thing that userspace is aware of.
>
> Are there drivers which use more than one interrupt per queue? I know
> drivers have multiple management interrupts.. and I guess some drivers
> do combined 1 interrupt per pair of Tx/Rx..  It's also plausible to to
> have multiple queues for one interrupt .. I'm not sure how a single
> queue with multiple interrupts would work though.

For block there is always one interrupt per queue. Some Network drivers
seem to have seperate RX and TX interrupts per queue.

Thanks,

        tglx
