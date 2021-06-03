Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98B339AEA4
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFCX3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:29:32 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:1091 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCX3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 19:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622762867; x=1654298867;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=7ofG02ZB3R9ItNYAJX7AOjZDSEYR5bDQ9ZvKLyyiy6M=;
  b=s4NMXVO77pvXXOzL6ItqV0+U/phI6tQWM0ia443Om1cx37MmlxxJCtjr
   Yvf2Y4bVgAHVhXLPlGod7ZVD/Acyg8qWO9czjI7AHB7eA6daJEvo5nGtV
   ZfAVn/LWvNlPoskfE4NzdPz1PwT9DU1UddnFipRXO7RnHoYcOSjWxVPBu
   4=;
X-IronPort-AV: E=Sophos;i="5.83,246,1616457600"; 
   d="scan'208";a="116516910"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 03 Jun 2021 23:27:45 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 4C241A1D18;
        Thu,  3 Jun 2021 23:27:43 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 3 Jun 2021 23:27:42 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 3 Jun 2021 23:27:42 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Thu, 3 Jun 2021 23:27:42 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 72A74409AC; Thu,  3 Jun 2021 23:27:42 +0000 (UTC)
Date:   Thu, 3 Jun 2021 23:27:42 +0000
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
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Message-ID: <20210603232742.GB14368@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
 <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <33380567-f86c-5d85-a79e-c1cd889f8ec2@oracle.com>
 <20210528215008.GA19622@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <1ff91b30-3963-728e-aefb-57944197bdde@oracle.com>
 <20210602193743.GA28861@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <2cb71322-9d3d-395e-293b-24888f5be759@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2cb71322-9d3d-395e-293b-24888f5be759@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 04:11:46PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 6/2/21 3:37 PM, Anchal Agarwal wrote:
> > On Tue, Jun 01, 2021 at 10:18:36AM -0400, Boris Ostrovsky wrote:
> >>
> > The resume won't fail because in the image the xen_vcpu and xen_vcpu_info are
> > same. These are the same values that got in there during saving of the
> > hibernation image. So whatever xen_vcpu got as a value during boot time registration on resume is
> > essentially lost once the jump into the saved kernel image happens. Interesting
> > part is if KASLR is not enabled boot time vcpup mfn is same as in the image.
> 
> 
> Do you start the your guest right after you've hibernated it? What happens if you create (and keep running) a few other guests in-between? mfn would likely be different then I'd think.
> 
>
Yes, I just run it in loops on a single guest and I am able to see the issue in
20-40 iterations sometime may be sooner. Yeah, you could be right and this could
definitely happen more often depending what's happening on dom0 side.
> > Once you enable KASLR this value changes sometimes and whenever that happens
> > resume gets stuck. Does that make sense?
> >
> > No it does not resume successfully if hypercall fails because I was trying to
> > explicitly reset vcpu and invoke hypercall.
> > I am just wondering why does restore logic fails to work here or probably I am
> > missing a critical piece here.
> 
> 
> If you are not using KASLR then xen_vcpu_info is at the same address every time you boot. So whatever you registered before hibernating stays the same when you boot second time and register again, and so successful comparison in xen_vcpu_setup() works. (Mostly by chance.)
>
That's what I thought so too.
> 
> But if KASLR is on then this comparison not failing should cause xen_vcpu pointer in the loaded image to become bogus because xen_vcpu is now registered for a different xen_vcpu_info address during boot.
> 
The reason for that I think is once you jump into the image that information is
getting lost. But there is  some residue somewhere that's causing the resume to
fail. I haven't been able to pinpoint the exact field value that may be causing
that issue.
Correct me if I am wrong here, but even if hypothetically I put a hack to tell the kernel
somehow re-register vcpu it won't pass because there is no hypercall to
unregister it in first place? Can the resumed kernel use the new values in that
case [Now this is me just throwing wild guesses!!]

> 
> >>> Another line of thought is something what kexec does to come around this problem
> >>> is to abuse soft_reset and issue it during syscore_resume or may be before the image get loaded.
> >>> I haven't experimented with that yet as I am assuming there has to be a way to re-register vcpus during resume.
> >>
> >> Right, that sounds like it should work.
> >>
> > You mean soft reset or re-register vcpu?
> 
> 
> Doing something along the lines of a soft reset. It should allow you to re-register. Not sure how you can use it without Xen changes though.
> 
No not without xen changes. It won't work. I will have xen changes in place to
test that on our infrastructure. 

--
Anchal
> 
> 
> -boris
> 
