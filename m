Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0C63BD84F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhGFOhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 10:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhGFOhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 10:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F4A661AC0;
        Tue,  6 Jul 2021 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625581398;
        bh=kLVem+lC4RwgaSvlRxNWh6WClbsCqyCWUybrD/hsjdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dvBxQHrmw6EPUmkbmwxaVbFTYhRXd43UhsERgeVTjyeN1Rok/1RGCSSvjSJdC/5IL
         GrDuLOEZKo2AWon9u7+Be3SWrEOtuXBnZ3J/UgSLqU3q6dUA9JZObFM4oeEtq3LW7i
         8/JJaq8D+AMhDJy0bA4rtdwqp2b/CJLsEue/hs2EeqUFUHjX0nJN8e+gLNnugBJLf5
         GNx3/AIhIMoJalL/yvToUL/G1X9ikKh0hxME4PbsbFo07r8tOKQcvVUCC1vv5Hqzs3
         JyZEwbtjX2jukib2GAOPYALdIQ2ZqysUaG3sGtFAaHrURNkghH84UJ/OfEOCZrV3pH
         fM8gEFrTlWXpw==
Received: by pali.im (Postfix)
        id D17896E9; Tue,  6 Jul 2021 16:23:15 +0200 (CEST)
Date:   Tue, 6 Jul 2021 16:23:15 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Aaron Ma <aaron.ma@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210706142315.ve22wypovdezqnva@pali>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210704142808.f43jbcufk37hundo@pali>
 <20210705230212.GC142312@rocinante>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210705230212.GC142312@rocinante>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 06 July 2021 01:02:12 Krzysztof Wilczyński wrote:
> Hi Pali,
> 
> [...]
> > Aaron: can you check if pci_dev_is_disconnected() is really something
> > which should be used and it helps you?
> 
> While having a closer look, I've noticed that quite a few of the network
> drivers handle this somewhat, as I see that a lot of them have some sort
> of I/O error handles set where a check for "pci_channel_io_perm_failure"
> seem to be having place.  This is also true for this driver looking at
> the igc_io_error_detected().
> 
> Is this not working for the igc driver?  Or is this for something
> completely different?

I guess that this callback is called when Bridge receive some kind of
fatal error. Non-AER-aware bridges probably do not have to inform system
that error happened and kernel would not call this callback. So I guess
it depends on to which "machine" you need this network adapter.

So in my opinion this callback is there for PCI subsystem to inform
driver that error happened and let driver to do any hw specific recovery
if it is possible.

But I think problem described here can be slightly different. It is
needed to check if device is still alive or was disconnected.

> Having said all that, I am not an expert in network drivers, so pardon
> me if I am asking about something completely different, and I apologise
> if that is the case.
> 
> > Bjorn, Krzysztof: what do you think about lifting helper function
> > pci_dev_is_disconnected() to be available to all drivers and not only in
> > PCI subsystem?
> 
> No objections from me, if we believe it's useful and that it might
> encourage people to use a common API.  Currently, I can see at least
> five potential users of this helper.
> 
> 	Krzysztof
