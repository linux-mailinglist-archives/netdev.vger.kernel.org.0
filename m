Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9C3C163E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhGHPse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhGHPse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 11:48:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E64661483;
        Thu,  8 Jul 2021 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625759152;
        bh=is2esSXTGi4HPbNrzyvxZE08UDJJDrKAa6KsWAWVLfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=GX8McskDedTlTLJrVfjZb34JA8f5rdAJlKwE8m37vzrTJw9iA7vgMYepWYnsNnMsH
         0kACvi25IB6lVrfJJdKmiEVWplYdtYj9UY0gA5OC9MaeRoLK9GNiFMADkxtS8g3yFB
         GFnfz7UpqLQOnLACPm2SU+LdDawagvbYCpG2LLSGg8nJaOYa04GD1PIy9W2XL7h5yb
         t/pY3XBm0TWCaz62S7rhF/VXfTPo3BWvcpbNN7EPNXmmkaBmkHaa6MnXEGih6F6/QQ
         TOOKHQ1iV1cl1qdbiQHEfPlHKLT0T9da4NKyQM5MpP93odHDdHFbRksZNH3lJr0VeT
         FULhHpIlib+fA==
Date:   Thu, 8 Jul 2021 10:45:50 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Oliver O'Halloran <oohall@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210708154550.GA1019947@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOSf1CGVpogQGAatuY_N0db6OL2BFegGtj6VTLA9KFz0TqYBQg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 12:04:02PM +1000, Oliver O'Halloran wrote:
> On Thu, Jul 8, 2021 at 8:40 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > If we add the check as proposed in this patch, I think people will
> > read it and think this is the correct way to avoid MMIO errors.  It
> > does happen to avoid some MMIO errors, but it cannot avoid them all,
> > so it's not a complete solution and it gives a false sense of
> > security.
> 
> I think it's helpful to classify MMIO errors as either benign or
> poisonous with the poison MMIOs causing some kind of crash. Most of
> the discussions about pci_dev_is_disconnected(), including this one,
> seem to stem from people trying to use it to avoid the poison case. I
> agree that using pci_dev_is_disconnected() that way is hacky and
> doesn't really fix the problem, but considering poison MMIOs usually
> stem from broken hardware or firmware maybe we should allow it
> anyway. We can't do anything better and it's an improvement compared
> to crashing.

Apologies for rehashing what's probably obvious to everybody but me.
I'm trying to get a better handle on benign vs poisonous errors.

MMIO means CPU reads or writes to the device.  In PCI, writes are
posted and don't receive a response, so a driver will never see
writel() return an error (although an error may be reported
asynchronously via AER or similar).

So I think we're mostly talking about CPU reads here.  We expect a PCI
response containing the data.  Sometimes there's no response or an
error response.  The behavior of the host bridge in these error cases
is not defined by PCI, so what the CPU sees is not consistent across
platforms.  In some cases, the bridge handles this as a catastrophic
error that forces a system restart.

But in most cases, at least on x86, the bridge logs an error and
fabricates ~0 data so the CPU read can complete.  Then it's up to
software to recognize that an error occurred and decide what to do
about it.  Is this a benign or a poisonous error?

I'd say this is a benign error.  It certainly can't be ignored, but as
long as the driver recognizes the error, it should be able to deal
with it without crashing the whole system and forcing a restart.

Bjorn
