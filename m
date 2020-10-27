Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201C229C354
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760015AbgJ0Oaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:30:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47278 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759197AbgJ0O2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:28:18 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603808897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WHVWY8Pt2cBEbxM1Jxi63g2Hj3JS0/EEW2zyuVGEPSs=;
        b=2GQa6Ul8aOkAo3AXsA0aVITxroDZkL4AtCNdgNI3SDHsv3F+SU+7ED8PqGdbAeRfy0O4TB
        icKZgLCvuhTR1kJhp3uq+KN+rs4RZzZQK7odWgDfiXaSUfApcsaWUkjSb7TZbo1M0cF8Ys
        Ilcw/2OVZ4JEar/I/4TgEHp0ss+xXlb5kZcx2dZtVHI3WmN9kpwf10tXqdk4+lTtprnWUL
        rIX41oWtJ5VehAeaG/J+tjCqxsEdrZIip7AsZUAUd8upg+lfYoD61K8xt1A4hEOq0c51ET
        IqQ2a0jkuDj9QRkf8VK5YQABRVEB4rlGLAk8h9l8jbR5vJXlX+tBNT9AgUzSLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603808897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WHVWY8Pt2cBEbxM1Jxi63g2Hj3JS0/EEW2zyuVGEPSs=;
        b=iI4zzfmXqaQk8wTIlKzcoy2w3B7FkOtnUj2WNnQBCUCsHicUw1/TWMW/wUuiUSu0omFieQ
        T9rGsHQGnc8YCiBQ==
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
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
In-Reply-To: <586e249a-1078-9fe9-22d4-b3c1ec0a3a5e@intel.com>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <20201026173012.GA377978@fuller.cnet> <875z6w4xt4.fsf@nanos.tec.linutronix.de> <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com> <87v9ew3fzd.fsf@nanos.tec.linutronix.de> <85b5f53e-5be2-beea-269a-f70029bea298@intel.com> <87lffs3bd6.fsf@nanos.tec.linutronix.de> <959997ee-f393-bab0-45c0-4144c37b9185@redhat.com> <875z6w38n4.fsf@nanos.tec.linutronix.de> <586e249a-1078-9fe9-22d4-b3c1ec0a3a5e@intel.com>
Date:   Tue, 27 Oct 2020 15:28:16 +0100
Message-ID: <87mu07216n.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 16:08, Jacob Keller wrote:
> On 10/26/2020 3:49 PM, Thomas Gleixner wrote:
>> On Mon, Oct 26 2020 at 18:22, Nitesh Narayan Lal wrote:
>>> I don't think there is currently a way to control the enablement/disablement of
>>> interrupts from the userspace.
>> 
>> You cannot just disable the interrupt. You need to make sure that the
>> associated queue is shutdown or quiesced _before_ the interrupt is shut
>> down.
>
> Could this be handled with a callback to the driver/hw? I know Intel HW
> should support this type of quiesce/shutdown.

We can't have a callback from the interrupt shutdown code as you have to
wait for the queue to drain packets in flight. Something like this

     mark queue as going down (no more tx queueing)
     tell hardware not to route RX packets to it
     consume pending RX
     wait for already queued TX packets to be sent

Look what the block people did. They have a common multi-instance
hotplug state and they register each context (queue) as an instance. The
hotplug core invokes the corresponding callbacks when bringing a CPU up
or when shutting it down.

Thanks,

        tglx


