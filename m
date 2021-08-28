Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948403FA78A
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhH1UpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 16:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhH1UpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 16:45:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29249C061756;
        Sat, 28 Aug 2021 13:44:12 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630183450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jqn7wYgtWLIqZ9aye1ornYrsbRPpzBUqOlOGcb6SmI8=;
        b=mqKN5AWhujtiGKZ6L81ViYtYwQZi+xkoocav2zijsXbog4utBtunya7RVvX83UM298WNU0
        g6b4QTbT6X2D/Uxjb06CtP0EKazlp+YTAyDYgoBOOcdeT7XUEUfMPxo2B7bgda1BhRXo21
        AZE5GrHgCMvNhfjGefKyXHemYvVxU8/PxkTF52lDqFLQoe9LgtmqcekJaGLc74ZOzZe+sz
        KGP1In38tJbTvDk7FoNPwAsrM6I01dg1bgBWAU9jddoa2YuKRb8JaluRwun7nAZXcWBm1f
        DAmPlfPDvhlKtwTNLFyxMdvDoH6M7EYHeohvn4MVVwk1vf0fNOyLfXDI4zifZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630183450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jqn7wYgtWLIqZ9aye1ornYrsbRPpzBUqOlOGcb6SmI8=;
        b=ez+HiTr9a13KmBngRjTOOnKKW3JeJJIguEpv3Zlr6LZei7W2GH62vHq5OMOZAn3KN3JGx0
        oEVaZ7hY/QX9bODA==
To:     Dexuan Cui <decui@microsoft.com>,
        'Saeed Mahameed' <saeed@kernel.org>,
        'Leon Romanovsky' <leon@kernel.org>
Cc:     "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
In-Reply-To: <draft-87h7fa1m37.ffs@tglx>
References: <draft-87h7fa1m37.ffs@tglx>
Date:   Sat, 28 Aug 2021 22:44:09 +0200
Message-ID: <87tuj9guzq.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dexuan,

On Sat, Aug 28 2021 at 01:53, Thomas Gleixner wrote:
> On Thu, Aug 19 2021 at 20:41, Dexuan Cui wrote:
>>> Sorry for the late response! I checked the below sys file, and the output is
>>> exactly the same in the good/bad cases -- in both cases, I use maxcpus=8;
>>> the only difference in the good case is that I online and then offline CPU 8~31:
>>> for i in `seq 8 31`;  do echo 1 >  /sys/devices/system/cpu/cpu$i/online; done
>>> for i in `seq 8 31`;  do echo 0 >  /sys/devices/system/cpu/cpu$i/online; done
>>> 
>>> # cat /sys/kernel/debug/irq/irqs/209

Yes, that looks correct.

>>
>> I tried the kernel parameter "intremap=nosid,no_x2apic_optout,nopost" but
>> it didn't help. Only "intremap=off" can work round the no interrupt issue.
>>
>> When the no interrupt issue happens, irq 209's effective_affinity_list is 5.
>> I modified modify_irte() to print the irte->low, irte->high, and I also printed
>> the irte_index for irq 209, and they were all normal to me, and they were
>> exactly the same in the bad case and the good case -- it looks like, with
>> "intremap=on maxcpus=8", MSI-X on CPU5 can't work for the NIC device
>> (MSI-X on CPU5 works for other devices like a NVMe controller) , and somehow
>> "onlining and then offlining CPU 8~31" can "fix" the issue, which is really weird.

Just for the record: maxcpus=N is a dangerous boot option as it leaves
the non brought up CPUs in a state where they can be hit by MCE
broadcasting without being able to act on it. Which means you're
operating the system out of spec.

According to your debug output the interrupt in question belongs to the
INTEL-IR-3 interrupt domain, which means it hangs of IOMMU3, aka DMAR
unit 3.

To which DMAR/remap unit are the other unaffected devices connected to?

Thanks,

        tglx

