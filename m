Return-Path: <netdev+bounces-6588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA5EC7170AD
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A4E7281342
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C2E34CC8;
	Tue, 30 May 2023 22:27:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A66200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF59C4339B;
	Tue, 30 May 2023 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685485646;
	bh=cheXLQ8vzvhg3HHlEbp/nhH1v4qNXPvIuztE6YHAz8M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=LxJm7SB497PbN+6xSXHmc2pTJhHae0WzBcbxOtTgG3MRSh9p1dfYBRfUdQy7AyVRQ
	 1IezZSWPhIKD7XbfWiql8Plc+Ulv9e2XMV0Y9YzU+8zsQuv6SFrhqDkS6x4c+oZDWP
	 /L5OMnL+JMkyqRiQ4gYXhKTcO9jwWh5H7cLBy4aVIEnsrJ+3/NVsL0WDcE29kmRv45
	 38YRs0n+sv7VZwRllWBofAEQUQjc9UG0Jen3unekyfBRKw8j9GtCbYz+A/LwtVrVsM
	 vh/qbXD8fYjZaPnWr4d5573Wuyg+udrUB5D3tqXZmXDnOdKQv+rhIf4g6OnEvx+oIF
	 cwQuZSAvQLzsA==
Date: Tue, 30 May 2023 17:27:24 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <ZHZ4TFjFLrKeHPGi@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530220436.fooxifm47irxqlrj@skbuf>

On Wed, May 31, 2023 at 01:04:36AM +0300, Vladimir Oltean wrote:
> On Tue, May 30, 2023 at 04:58:55PM -0500, Bjorn Helgaas wrote:
> > Can you write this description in terms of PCI topology?  The
> > nitty-gritty SERDES details are not relevant at this level, except to
> > say that Function 0 is present in some cases but not others, and when
> > it is not present, *other* functions may be present.
> 
> No. It is to say that within the device, all PCIe functions (including 0)
> are always available and have the same number, but depending on SERDES
> configuration, their PCIe presence might be practically useful or not.
> So that's how function 0 may end having status = "disabled" in the
> device tree.
>
> > Sigh.  Per spec (PCIe r6.0, sec 7.5.1.1.9), software is not permitted
> > to probe for Functions other than 0 unless "explicitly indicated by
> > another mechanism, such as an ARI or SR-IOV Capability."
> > 
> > Does it "work" to probe when the spec prohibits it?  Probably.  Does
> > it lead to some breakage elsewhere eventually?  Quite possibly.  They
> > didn't put "software must not probe" in the spec just to make
> > enumeration faster.
> > 
> > So I'm a little grumpy about further complicating this already messy
> > path just to accommodate a new non-compliant SoC.  Everybody pays the
> > price of understanding all this stuff, and it doesn't seem in balance.
> > 
> > Can you take advantage of some existing mechanism like
> > PCI_SCAN_ALL_PCIE_DEVS or hypervisor_isolated_pci_functions() (which
> > could be renamed and made more general)?
> 
> Not responding yet to the rest of the email since it's not clear to me
> that you've understood function 0 is absolutely present and responds
> to all config space accesses - it's just disabled in the device tree
> because the user doesn't have something useful to do with it.

Ah, you're right, sorry I missed that.  Dispensing with the SERDES
details would make this more obvious.

Not sure why this needs to change the pci_scan_slot() path, since
Function 0 is present and enumerable even though it's not useful in
some cases.  Seems like something in pci_set_of_node() or a quirk
could do whatever you need to do.

Bjorn

