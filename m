Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740AA3993AC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 21:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhFBTjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 15:39:39 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:11381 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhFBTji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 15:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622662675; x=1654198675;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=Oo1yVpiLpXAxmPuTnGP3FETyige1IcwNMzEh/RjZTOE=;
  b=pWoHpVQKA+5JMjVkQoR/4AV5YbA3674jGIMH+eN5M6CSeM5uG4jHCX+t
   e6lkoA3rutBjSTW4lRaePjd/pDt7L7VVPVwU86jiaJuB26+gMNKBJrk5V
   B2Szj+0WfawXi0IZylJdWbECTCtnNDrFpLOZfy7T89zgyquy8ULd0m/GF
   U=;
X-IronPort-AV: E=Sophos;i="5.83,242,1616457600"; 
   d="scan'208";a="128919057"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 02 Jun 2021 19:37:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 977FCA1C5C;
        Wed,  2 Jun 2021 19:37:46 +0000 (UTC)
Received: from EX13D07UWA002.ant.amazon.com (10.43.160.77) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 2 Jun 2021 19:37:44 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D07UWA002.ant.amazon.com (10.43.160.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 2 Jun 2021 19:37:44 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Wed, 2 Jun 2021 19:37:44 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 5C62340124; Wed,  2 Jun 2021 19:37:43 +0000 (UTC)
Date:   Wed, 2 Jun 2021 19:37:43 +0000
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
        "anchalag@amazon.com" <anchalag@amazon.com>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Message-ID: <20210602193743.GA28861@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
 <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <33380567-f86c-5d85-a79e-c1cd889f8ec2@oracle.com>
 <20210528215008.GA19622@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <1ff91b30-3963-728e-aefb-57944197bdde@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1ff91b30-3963-728e-aefb-57944197bdde@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 10:18:36AM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 5/28/21 5:50 PM, Anchal Agarwal wrote:
> 
> > That only fails during boot but not after the control jumps into the image. The
> > non boot cpus are brought offline(freeze_secondary_cpus) and then online via cpu hotplug path. In that case xen_vcpu_setup doesn't invokes the hypercall again.
> 
> 
> OK, that makes sense --- by that time VCPUs have already been registered. What I don't understand though is why resume doesn't fail every time --- xen_vcpu and xen_vcpu_info should be different practically always, shouldn't they? Do you observe successful resumes when the hypercall fails?
> 
> 
The resume won't fail because in the image the xen_vcpu and xen_vcpu_info are
same. These are the same values that got in there during saving of the
hibernation image. So whatever xen_vcpu got as a value during boot time registration on resume is
essentially lost once the jump into the saved kernel image happens. Interesting
part is if KASLR is not enabled boot time vcpup mfn is same as in the image.
Once you enable KASLR this value changes sometimes and whenever that happens
resume gets stuck. Does that make sense?

No it does not resume successfully if hypercall fails because I was trying to
explicitly reset vcpu and invoke hypercall.
I am just wondering why does restore logic fails to work here or probably I am
missing a critical piece here.
> >
> > Another line of thought is something what kexec does to come around this problem
> > is to abuse soft_reset and issue it during syscore_resume or may be before the image get loaded.
> > I haven't experimented with that yet as I am assuming there has to be a way to re-register vcpus during resume.
> 
> 
> Right, that sounds like it should work.
> 
You mean soft reset or re-register vcpu?

-Anchal
> 
> -boris
> 
> 
