Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A88738BDE0
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 07:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhEUF2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 01:28:40 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:33314 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhEUF2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 01:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621574836; x=1653110836;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=kDiMVanU/J46MBpWtTAkHD58jSy5mLoyYAH1XvH7tTU=;
  b=cGJtZxMCkCe4MQXsKizox2Im7O10DMSFVoBd7YGsYz6hcX5x4m8ZcFZG
   vD/BchT9PugvZB0vANu9JdsrHYv+95DrKxmK1M5dYfgC3wuiu2TqT83bM
   Wjy4QoWucejVmxe8U+ixOoxwm7sHbhL8kREZnQTaa1qbUmPruhO45DraG
   k=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="2533323"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 21 May 2021 05:27:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 84D9AA1E62;
        Fri, 21 May 2021 05:27:07 +0000 (UTC)
Received: from EX13D07UWA004.ant.amazon.com (10.43.160.32) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 05:26:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D07UWA004.ant.amazon.com (10.43.160.32) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 05:26:51 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 05:26:51
 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id F1AC340124; Fri, 21 May 2021 05:26:50 +0000 (UTC)
Date:   Fri, 21 May 2021 05:26:50 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <boris.ostrovsky@oracle.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        David <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        <anchalag@amazon.com>, <aams@amazon.com>
Message-ID: <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 08:43:58AM -0400, boris.ostrovsky@oracle.com wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> >>>>>>> Also, wrt KASLR stuff, that issue is still seen sometimes but I haven't had
> >>>>>>> bandwidth to dive deep into the issue and fix it.
> >>>> So what's the plan there? You first mentioned this issue early this year and judged by your response it is not clear whether you will ever spend time looking at it.
> >>>>
> >>> I do want to fix it and did do some debugging earlier this year just haven't
> >>> gotten back to it. Also, wanted to understand if the issue is a blocker to this
> >>> series?
> >>
> >> Integrating code with known bugs is less than ideal.
> >>
> > So for this series to be accepted, KASLR needs to be fixed along with other
> > comments of course?
> 
> 
> Yes, please.
> 
> 
> 
> >>> I had some theories when debugging around this like if the random base address picked by kaslr for the
> >>> resuming kernel mismatches the suspended kernel and just jogging my memory, I didn't find that as the case.
> >>> Another hunch was if physical address of registered vcpu info at boot is different from what suspended kernel
> >>> has and that can cause CPU's to get stuck when coming online.
> >>
> >> I'd think if this were the case you'd have 100% failure rate. And we are also re-registering vcpu info on xen restore and I am not aware of any failures due to KASLR.
> >>
> > What I meant there wrt VCPU info was that VCPU info is not unregistered during hibernation,
> > so Xen still remembers the old physical addresses for the VCPU information, created by the
> > booting kernel. But since the hibernation kernel may have different physical
> > addresses for VCPU info and if mismatch happens, it may cause issues with resume.
> > During hibernation, the VCPU info register hypercall is not invoked again.
> 
> 
> I still don't think that's the cause but it's certainly worth having a look.
> 
Hi Boris,
Apologies for picking this up after last year. 
I did some dive deep on the above statement and that is indeed the case that's happening. 
I did some debugging around KASLR and hibernation using reboot mode.
I observed in my debug prints that whenever vcpu_info* address for secondary vcpu assigned 
in xen_vcpu_setup at boot is different than what is in the image, resume gets stuck for that vcpu
in bringup_cpu(). That means we have different addresses for &per_cpu(xen_vcpu_info, cpu) at boot and after
control jumps into the image. 

I failed to get any prints after it got stuck in bringup_cpu() and
I do not have an option to send a sysrq signal to the guest or rather get a kdump.
This change is not observed in every hibernate-resume cycle. I am not sure if this is a bug or an 
expected behavior. 
Also, I am contemplating the idea that it may be a bug in xen code getting triggered only when
KASLR is enabled but I do not have substantial data to prove that.
Is this a coincidence that this always happens for 1st vcpu?
Moreover, since hypervisor is not aware that guest is hibernated and it looks like a regular shutdown to dom0 during reboot mode,
will re-registering vcpu_info for secondary vcpu's even plausible? I could definitely use some advice to debug this further.

 
Some printk's from my debugging:

At Boot:

xen_vcpu_setup: xen_have_vcpu_info_placement=1 cpu=1, vcpup=0xffff9e548fa560e0, info.mfn=3996246 info.offset=224,

Image Loads:
It ends up in the condition:
 xen_vcpu_setup()
 {
 ...
 if (xen_hvm_domain()) {
        if (per_cpu(xen_vcpu, cpu) == &per_cpu(xen_vcpu_info, cpu))
                return 0; 
 }
 ...
 }

xen_vcpu_setup: checking mfn on resume cpu=1, info.mfn=3934806 info.offset=224, &per_cpu(xen_vcpu_info, cpu)=0xffff9d7240a560e0

This is tested on c4.2xlarge [8vcpu 15GB mem] instance with 5.10 kernel running
in the guest.

Thanks,
Anchal.
> 
> -boris
> 
> 
