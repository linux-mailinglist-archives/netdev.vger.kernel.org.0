Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B57B390FAF
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhEZEmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:42:47 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:9330 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhEZEmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622004074; x=1653540074;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=IdCtA2fDzgAuC9RDi6qBLpDtVfX4igt+SD3WtXyHdbQ=;
  b=NFJkTKF0QYrUDv+L1pnabJ4P7YhWnr/daLSfQURvHaSceSWNXovyDFN2
   iweKxocvTPPqTqNnYoEOQ6Zr+brn5YrPcypXbfOgAR5D3GkV6XwwTZ049
   HFsU2C4sEk4bpAA62KdaOomaTNFTO1xJFNbtJCx9ycBqrf3UpTRWNyr4V
   I=;
X-IronPort-AV: E=Sophos;i="5.82,330,1613433600"; 
   d="scan'208";a="114662918"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 26 May 2021 04:41:12 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id 81C19C5C00;
        Wed, 26 May 2021 04:41:05 +0000 (UTC)
Received: from EX13D07UWA002.ant.amazon.com (10.43.160.77) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 04:40:39 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D07UWA002.ant.amazon.com (10.43.160.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 04:40:38 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 04:40:38
 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id B2A7240153; Wed, 26 May 2021 04:40:38 +0000 (UTC)
Date:   Wed, 26 May 2021 04:40:38 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
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
        <Shah@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        Amit <aams@amazon.de>,
        <Agarwal@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        Anchal <anchalag@amazon.com>
Message-ID: <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 06:23:35PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 5/21/21 1:26 AM, Anchal Agarwal wrote:
> >>> What I meant there wrt VCPU info was that VCPU info is not unregistered during hibernation,
> >>> so Xen still remembers the old physical addresses for the VCPU information, created by the
> >>> booting kernel. But since the hibernation kernel may have different physical
> >>> addresses for VCPU info and if mismatch happens, it may cause issues with resume.
> >>> During hibernation, the VCPU info register hypercall is not invoked again.
> >>
> >> I still don't think that's the cause but it's certainly worth having a look.
> >>
> > Hi Boris,
> > Apologies for picking this up after last year.
> > I did some dive deep on the above statement and that is indeed the case that's happening.
> > I did some debugging around KASLR and hibernation using reboot mode.
> > I observed in my debug prints that whenever vcpu_info* address for secondary vcpu assigned
> > in xen_vcpu_setup at boot is different than what is in the image, resume gets stuck for that vcpu
> > in bringup_cpu(). That means we have different addresses for &per_cpu(xen_vcpu_info, cpu) at boot and after
> > control jumps into the image.
> >
> > I failed to get any prints after it got stuck in bringup_cpu() and
> > I do not have an option to send a sysrq signal to the guest or rather get a kdump.
> 
> 
> xenctx and xen-hvmctx might be helpful.
> 
> 
> > This change is not observed in every hibernate-resume cycle. I am not sure if this is a bug or an
> > expected behavior.
> > Also, I am contemplating the idea that it may be a bug in xen code getting triggered only when
> > KASLR is enabled but I do not have substantial data to prove that.
> > Is this a coincidence that this always happens for 1st vcpu?
> > Moreover, since hypervisor is not aware that guest is hibernated and it looks like a regular shutdown to dom0 during reboot mode,
> > will re-registering vcpu_info for secondary vcpu's even plausible?
> 
> 
> I think I am missing how this is supposed to work (maybe we've talked about this but it's been many months since then). You hibernate the guest and it writes the state to swap. The guest is then shut down? And what's next? How do you wake it up?
> 
> 
> -boris
> 
To resume a guest, guest boots up as the fresh guest and then software_resume()
is called which if finds a stored hibernation image, quiesces the devices and loads 
the memory contents from the image. The control then transfers to the targeted kernel.
This further disables non boot cpus,sycore_suspend/resume callbacks are invoked which sets up
the shared_info, pvclock, grant tables etc. Since the vcpu_info pointer for each
non-boot cpu is already registered, the hypercall does not happen again when
bringing up the non boot cpus. This leads to inconsistencies as pointed
out earlier when KASLR is enabled.

Thanks,
Anchal
> 
> 
> >  I could definitely use some advice to debug this further.
> >
> >
> > Some printk's from my debugging:
> >
> > At Boot:
> >
> > xen_vcpu_setup: xen_have_vcpu_info_placement=1 cpu=1, vcpup=0xffff9e548fa560e0, info.mfn=3996246 info.offset=224,
> >
> > Image Loads:
> > It ends up in the condition:
> >  xen_vcpu_setup()
> >  {
> >  ...
> >  if (xen_hvm_domain()) {
> >         if (per_cpu(xen_vcpu, cpu) == &per_cpu(xen_vcpu_info, cpu))
> >                 return 0;
> >  }
> >  ...
> >  }
> >
> > xen_vcpu_setup: checking mfn on resume cpu=1, info.mfn=3934806 info.offset=224, &per_cpu(xen_vcpu_info, cpu)=0xffff9d7240a560e0
> >
> > This is tested on c4.2xlarge [8vcpu 15GB mem] instance with 5.10 kernel running
> > in the guest.
> >
> > Thanks,
> > Anchal.
> >> -boris
> >>
> >>
