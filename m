Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F082D23C241
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHDXmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:42:32 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:28313 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgHDXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596584551; x=1628120551;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=/JZsLbScAtVllbk3M4EYC9jSC+EH8BJFD7YNLkO2jbw=;
  b=ZCKW12nO5uz9aWo1YWbcZvs1SqWxkDxowEw2YV3KM5XV7vGNLwVlAsWG
   /8MmiHW6IJIN4ZXS49sKu+4RBBAMBpJz80aPfAL4CFFlXtytWU5hcrRTj
   1y8I6q26pr+45aTVmjWyic4e5esj1jWruZwoOuDPkqblNX/UinOTb7nzQ
   o=;
IronPort-SDR: tXSAvE3I+eAbNDPDnUOFaCSbmANsG665E5E2LDRc5x+gN2ZBKiLpEWpXlkrOemTAkQzeu7PQUy
 xDAgL7lVT3Tg==
X-IronPort-AV: E=Sophos;i="5.75,435,1589241600"; 
   d="scan'208";a="65620285"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Aug 2020 23:42:18 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 5A165A258A;
        Tue,  4 Aug 2020 23:42:11 +0000 (UTC)
Received: from EX13D10UWA002.ant.amazon.com (10.43.160.228) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 4 Aug 2020 23:42:02 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA002.ant.amazon.com (10.43.160.228) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 4 Aug 2020 23:42:01 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 4 Aug 2020 23:42:01 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 935F940362; Tue,  4 Aug 2020 23:42:01 +0000 (UTC)
Date:   Tue, 4 Aug 2020 23:42:01 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     Stefano Stabellini <sstabellini@kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200804234201.GA23820@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200721000348.GA19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <408d3ce9-2510-2950-d28d-fdfe8ee41a54@oracle.com>
 <alpine.DEB.2.21.2007211640500.17562@sstabellini-ThinkPad-T480s>
 <20200722180229.GA32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007221645430.17562@sstabellini-ThinkPad-T480s>
 <20200723225745.GB32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007241431280.17562@sstabellini-ThinkPad-T480s>
 <66a9b838-70ed-0807-9260-f2c31343a081@oracle.com>
 <20200730230634.GA17221@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <53b577a3-6af9-5587-7e47-485be38b3653@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53b577a3-6af9-5587-7e47-485be38b3653@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 10:13:48AM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 7/30/20 7:06 PM, Anchal Agarwal wrote:
> > On Mon, Jul 27, 2020 at 06:08:29PM -0400, Boris Ostrovsky wrote:
> >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>
> >>
> >>
> >> On 7/24/20 7:01 PM, Stefano Stabellini wrote:
> >>> Yes, it does, thank you. I'd rather not introduce unknown regressions so
> >>> I would recommend to add an arch-specific check on registering
> >>> freeze/thaw/restore handlers. Maybe something like the following:
> >>>
> >>> #ifdef CONFIG_X86
> >>>     .freeze = blkfront_freeze,
> >>>     .thaw = blkfront_restore,
> >>>     .restore = blkfront_restore
> >>> #endif
> >>>
> >>>
> >>> maybe Boris has a better suggestion on how to do it
> >>
> >> An alternative might be to still install pm notifier in
> >> drivers/xen/manage.c (I think as result of latest discussions we decided
> >> we won't need it) and return -ENOTSUPP for ARM for
> >> PM_HIBERNATION_PREPARE and friends. Would that work?
> >>
> > I think the question here is for registering driver specific freeze/thaw/restore
> > callbacks for x86 only. I have dropped the pm_notifier in the v3 still pending
> > testing. So I think just registering driver specific callbacks for x86 only is a
> > good option. What do you think?
> 
> 
> I suggested using the notifier under assumption that if it returns an
> error then that will prevent callbacks to be called because hibernation
> will be effectively disabled. But I haven't looked at PM code so I don't
> know whether this is actually the case.
>
I think this could be done. PM_HIBERNATION_PREPARE could return -ENOTSUPP
for arm and pvh dom0 when the notifier call chain is invoked for this case
in hibernate(). This will then be an empty notifier just for checking two
usecases.
Also, for pvh dom0, the earlier code didn't register any notifier,
with this approach you are suggesting setup the notifier for hvm/pvh dom0 and
arm but fail during notifier call chain during PM_HIBERNATION_PREPARE ?

I think still getting rid of suspend mode that was earlier a part of this
notifier is a good idea as it seems redundant as you pointed out earlier. 
> 
> The advantage of doing it in the notifier is that instead of adding
> ifdefs to each driver you will be able to prevent callbacks from a
> single place. Plus you can use this do disable hibernation for PVH dom0
> as well.
> 
> 
> 
> -boris
> 
Anchal
> 
> 
