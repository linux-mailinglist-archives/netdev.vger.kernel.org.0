Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC56B274D31
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIVXRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:17:53 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:49591 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgIVXRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600816673; x=1632352673;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=5R3Krtkzle1NhoP1m+0L88WAV6llnORnKP70Telk+cY=;
  b=IJcFpl9QCXh26T5Vdj8LU31Kqbuf7YD4MU5ly6hdXCNM8ECbpQsJXwoo
   FJ9MraRYqA5ozZYnIEWY6YPa/OVCefsdYceX/r+zRCHC7fhL+PuMcvMto
   DC5/8KlrN1IAiOy0wLoQQesqBCuXq4heD/+pD/ar2w1xe8uyaQzVRYfnJ
   Y=;
X-IronPort-AV: E=Sophos;i="5.77,292,1596499200"; 
   d="scan'208";a="55658258"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 Sep 2020 23:17:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 84C6DA1C30;
        Tue, 22 Sep 2020 23:17:48 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 23:17:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 23:17:36 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 22 Sep 2020 23:17:36 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 81337408C3; Tue, 22 Sep 2020 23:17:36 +0000 (UTC)
Date:   Tue, 22 Sep 2020 23:17:36 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <boris.ostrovsky@oracle.com>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1598042152.git.anchalag@amazon.com>
 <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
 <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
 <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
 <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 12:18:05PM -0400, boris.ostrovsky@oracle.com wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 9/21/20 5:54 PM, Anchal Agarwal wrote:
> > Thanks for the above suggestion. You are right I didn't find a way to declare
> > a global state either. I just broke the above check in 2 so that once we have
> > support for ARM we should be able to remove aarch64 condition easily. Let me
> > know if I am missing nay corner cases with this one.
> >
> > static int xen_pm_notifier(struct notifier_block *notifier,
> >       unsigned long pm_event, void *unused)
> > {
> >     int ret = NOTIFY_OK;
> >     if (!xen_hvm_domain() || xen_initial_domain())
> >       ret = NOTIFY_BAD;
> >     if(IS_ENABLED(CONFIG_ARM64) && (pm_event == PM_SUSPEND_PREPARE || pm_event == HIBERNATION_PREPARE))
> >       ret = NOTIFY_BAD;
> >
> >     return ret;
> > }
> 
> 
> 
> This will allow PM suspend to proceed on x86.
Right!! Missed it.
Also, wrt KASLR stuff, that issue is still seen sometimes but I haven't had
bandwidth to dive deep into the issue and fix it. I seem to have lost your email
in my inbox hence covering the question here.
> 
> 
> -boris
> 
