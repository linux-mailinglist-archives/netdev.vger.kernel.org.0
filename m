Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B766442376
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhKAWfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbhKAWfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 18:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E128560E9C;
        Mon,  1 Nov 2021 22:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635805996;
        bh=QSOg14zJ7564Ds7UcOROZkmDP61KqIEGNfcLXTYnNLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DCLP8hScJ+WV4gOKF9pHgDcWWXFzpv0cTrjMrwIymdEl4iDuyaJ17V0J6lAOvDSbp
         ZUL0MPXxqmm0SQqMBWI5YlLCYxBeOmlNp76LL8YWNB2Oa7oAiFf2CQvttCh7B2Tlig
         4Hp4SHTQoe7dyrkTnNufBt1klwAomJk1j5A6rROFjNB0LWVcFjVd0ygckPW2C3nb/k
         yEBqnEi6Y8XotE5WKsX7ppBsYvZTkvbFnCDR9WxywOzJpy2n7S6sOHR3ZgRwEh2Yfc
         EdgB2aZTeuLY99ZNVcMDPdLH2p/4OWO6U03bS3T8ptkR6+grjbbiaw4IpKrSHmzAVw
         1+8D9HrhethBA==
Date:   Mon, 1 Nov 2021 17:33:14 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, logang@deltatee.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V11 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 device
Message-ID: <20211101223314.GA557567@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101220239.GA554641@bhelgaas>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 05:02:41PM -0500, Bjorn Helgaas wrote:
> On Sat, Oct 30, 2021 at 09:53:47PM +0800, Dongdong Liu wrote:
> > 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
> > field size from 8 bits to 10 bits.
> > 
> > PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
> > 10-Bit Tag Capabilities" Implementation Note:
> > 
> >   For platforms where the RC supports 10-Bit Tag Completer capability,
> >   it is highly recommended for platform firmware or operating software
> >   that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
> >   bit automatically in Endpoints with 10-Bit Tag Requester capability.
> >   This enables the important class of 10-Bit Tag capable adapters that
> >   send Memory Read Requests only to host memory.
> > 
> > It's safe to enable 10-bit tags for all devices below a Root Port that
> > supports them. Switches that lack 10-Bit Tag Completer capability are
> > still able to forward NPRs and Completions carrying 10-Bit Tags correctly,
> > since the two new Tag bits are in TLP Header bits that were formerly
> > Reserved.
> 
> Side note: the reason we want to do this to increase performance by
> allowing more outstanding requests.  Do you have any benchmarking that
> we can mention here to show that this is actually a benefit?  I don't
> doubt that it is, but I assume you've measured it and it would be nice
> to advertise it.

Hmmm.  I did a quick Google search looking for "nvme pcie 10-bit tags"
hoping to find some performance info, but what I *actually* found was
several reports of 10-bit tags causing breakage:

  https://www.reddit.com/r/MSI_Gaming/comments/exjvzg/x570_apro_7c37vh72beta_version_has_anyone_tryed_it/
  https://rog.asus.com/forum/showthread.php?115064-Beware-of-agesa-1-0-0-4B-bios-not-good!/page2
  https://forum-en.msi.com/index.php?threads/sound-blaster-z-has-weird-behaviour-after-updating-bios-x570-gaming-edge-wifi.325223/page-2
  https://gearspace.com/board/electronic-music-instruments-and-electronic-music-production/1317189-h8000fw-firewire-facts-2020-must-read.html
  https://www.soundonsound.com/forum/viewtopic.php?t=69651&start=12
  https://forum.rme-audio.de/viewtopic.php?id=30307

This is a big problem for me.

Some of these might be a broken BIOS that turns on 10-bit tags when
the completer doesn't support them.  I didn't try to debug them to
that level.  But the last thing I want is to enable 10-bit by default
and cause boot issues or sound card issues or whatever.

I'm pretty sure this is a show-stopper for wedging this into v5.16 at
this late date.  It's conceivable we could still do it if everything
defaulted to "off" and we had a knob whereby users could turn it on
via boot param or sysfs.

In any case, we (by which I'm afraid I mean "you" :)) need to
investigate the problem reports, figure out whether we will see
similar problems, and fix them before merging if we can.

Thanks to Krzysztof for pointing out the potential for issues like
this.

Bjorn
