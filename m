Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C054518AA91
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCSCOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSCOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 22:14:30 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC15620724;
        Thu, 19 Mar 2020 02:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584584070;
        bh=mnmbIvwXRXeVZwXHiD1l6aYXPQ0wT/XLVQnoqpDCjec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jHAYvbDenxTEoTUI5QBqY/S4cjR+GBYNXWSEmEkQqCJE/6n5uL77OSRH1OUr0cYyO
         UFeuEtACAjr/PlvYbCImrYSi6sSbWGM6/5tH0gVtsJjajkD0XXcP7/v6pc7RCwqNIr
         EHhXdLTxPKY41izavWVEhqtAYoRZ1NiCJC3c9WyQ=
Date:   Wed, 18 Mar 2020 19:14:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
Message-ID: <20200318191427.20b1ec5f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CACKFLikpaDrykkzsUNgRdUejQSM4S3M==+TVnRxMCA54DRFFOQ@mail.gmail.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAACQVJqSMsMNChPssuw850HVYXYJAYx=HcwYXGrG3FsMgVQf1g@mail.gmail.com>
        <20200318130441.42ac70b5@kicinski-fedora-PC1C0HJN>
        <cc554929-9dbb-998e-aa83-0e5ccb6c3867@intel.com>
        <CACKFLikpaDrykkzsUNgRdUejQSM4S3M==+TVnRxMCA54DRFFOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 17:47:26 -0700 Michael Chan wrote:
> On Wed, Mar 18, 2020 at 5:05 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> > On 3/18/2020 1:04 PM, Jakub Kicinski wrote:  
> > > We're just getting rid of driver versions, with significant effort,
> > > so starting to extend devlink info with driver stuff seems risky.
> > > How is driver information part of device info in the first place?
> > >
> > > As you said good driver and firmware will be modular and backward
> > > compatible, so what's the meaning of the API version?
> > >
> > > This field is meaningless.
> >
> > I think I agree with Jakub here. I assume, if it's anything like what
> > the ice driver does, the firmware has an API field used to communicate
> > to the driver what it can support. This can be used by the driver to
> > decide if it can load.
> >
> > For example, if the major API number increases, the ice driver then
> > assumes that it must be a very old driver which will not work at all
> > with that firmware. (This is mostly kept as a safety hatch in case no
> > other alternative can be determined).
> >
> > The driver can then use this API number as a way to decide if certain
> > features can be enabled or not.
> >
> > I suppose printing the driver's "expected" API number makes sense, but I
> > think the stronger approach is to make the driver able to interoperate
> > with any previous API version. Newer minor API numbers only mean that
> > new features exist which the driver might not be aware of. (for example,
> > if you're running an old driver).
> 
> Agreed.  Our driver is backward and forward compatible with all
> production firmware for the most part.  The idea is that the effective
> API version number is the minimum of the driver's API and firmware's
> API.  For example, if firmware is at v1.5 and driver is at v1.4, then
> the effective or operating API is v1.4.  The new features after v1.4
> are unused because the driver does not understand those new features.
> Similarly, a newer driver running on older firmware will have the
> older firmware's API as the effective API.  The driver will not use
> the new features that the firmware doesn't understand.
> 
> So if there is only one API version to report, reporting the min.
> makes the most sense to the user in our case.  It is similar to a Gen4
> PCIe card currently operating in a Gen3 slot.

Sounds reasonable. 
