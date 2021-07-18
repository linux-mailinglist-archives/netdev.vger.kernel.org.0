Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32653CCB75
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhGRWyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 18:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhGRWyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 18:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A05761029;
        Sun, 18 Jul 2021 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626648662;
        bh=E1GZ9wrZahjmOXpHUuWjVZgdMkfsdbwei1t/mYpy9C4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fClH3BDDoUNpc0wpEmkVw6BZObdB09nhHWUouGZ9Nt9+0dBTqhSvf4UBJTG5G88Py
         fnJ+3D9LUNTde008quKP3XAf/TjsMhADDwPJu6Ja42YByr3gBGr6cj+4r/7mODjot9
         46UFpgUH5FnrZROfr7kPRgTen5UPZxso8aXPvSbaaBTGcp276PXXNVrzlcdmz6V4Yf
         Oekv64bmFvz7I7WBOd5ljLtcuIsR6q1rbLFNJ/YMGoNT3WXuKPDExZzqxdm3DwMe7b
         e3uk7Ik4tE68dZdn/nsCHqJrvHVdf9EiV1CdRl2l+DSN3YHkbpBfHUf4hp3+Iik7Zc
         euDGV64UE/ULg==
Received: by pali.im (Postfix)
        id 448579EE; Mon, 19 Jul 2021 00:50:59 +0200 (CEST)
Date:   Mon, 19 Jul 2021 00:50:59 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Oliver O'Halloran <oohall@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210718225059.hd3od4k4on3aopcu@pali>
References: <CAOSf1CGVpogQGAatuY_N0db6OL2BFegGtj6VTLA9KFz0TqYBQg@mail.gmail.com>
 <20210708154550.GA1019947@bjorn-Precision-5520>
 <CAOSf1CHtHLyEHC58jwemZS6j=jAU2OrrYitkUYmdisJtuFu4dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOSf1CHtHLyEHC58jwemZS6j=jAU2OrrYitkUYmdisJtuFu4dw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 19 July 2021 02:31:10 Oliver O'Halloran wrote:
> On Fri, Jul 9, 2021 at 1:45 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > *snip*
> >
> > Apologies for rehashing what's probably obvious to everybody but me.
> > I'm trying to get a better handle on benign vs poisonous errors.
> >
> > MMIO means CPU reads or writes to the device.  In PCI, writes are
> > posted and don't receive a response, so a driver will never see
> > writel() return an error (although an error may be reported
> > asynchronously via AER or similar).
> >
> > So I think we're mostly talking about CPU reads here.  We expect a PCI
> > response containing the data.  Sometimes there's no response or an
> > error response.  The behavior of the host bridge in these error cases
> > is not defined by PCI, so what the CPU sees is not consistent across
> > platforms.  In some cases, the bridge handles this as a catastrophic
> > error that forces a system restart.
> >
> > But in most cases, at least on x86, the bridge logs an error and
> > fabricates ~0 data so the CPU read can complete.  Then it's up to
> > software to recognize that an error occurred and decide what to do
> > about it.  Is this a benign or a poisonous error?
> >
> > I'd say this is a benign error. It certainly can't be ignored, but as
> > long as the driver recognizes the error, it should be able to deal
> > with it without crashing the whole system and forcing a restart.
> 
> I was thinking more in terms of what the driver author sees rather
> than what's happening on the CPU side. The crash seen in the OP
> appears to be because the code is "doing an MMIO." However, the
> reasons for the crash have nothing to do with the actual mechanics of
> the operation (which should be benign). The point I was making is that
> the pattern of:
> 
> if (is_disconnected())
>     return failure;
> return do_mmio_read(addr);
> 
> does have some utility as a last-ditch attempt to prevent crashes in
> the face of obnoxious bridges or bad hardware. Granted, that should be
> a platform concern rather than something that should ever appear in
> driver code, but considering drivers open-code readl()/writel() calls
> there's not really any place to put that sort of workaround.
> 
> That all said, the case in the OP is due to an entirely avoidable
> driver bug and that sort of hack is absolutely the wrong thing to do.
> 
> Oliver

And do we have some solution for this kind of issue? There are more PCIe
controllers / platforms which do not like MMIO read/write operation when
card / link is not connected.

If we do not provide a way how to solve these problems then we can
expect that people would just hack ethernet / wifi / ... device drivers
which are currently crashing by patches like in this thread.

Maybe PCI subsystem could provide wrapper function which implements
above pattern and which can be used by device drivers?
