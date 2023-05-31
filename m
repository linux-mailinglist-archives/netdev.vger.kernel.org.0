Return-Path: <netdev+bounces-6924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BDA718B1F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E828E28158B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14CB3D384;
	Wed, 31 May 2023 20:24:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7997034CE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53ADC433D2;
	Wed, 31 May 2023 20:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685564688;
	bh=7r8nK+oO+zadbfBQmkkb4fRHaIJIBVonKzfYO5BLeJ8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=d1ewYAhFOgglzfl4VxYT6tvES1rLDUAGUGuYDf+vWFPrppA/pQmCxmrdqZ1EX/7NH
	 n0G6IGEqqCNLCv7dMvLTTjozqwyVgqEFuHm1r/YPSTYnaL2hwTj430Nu6yRA7cI8XW
	 CruOz9vwg6cp6Trv3cBsoC95rqTFU3PvOXdFNhJ6L2rWl/E6BnED05MzhnhJTy8qJl
	 azmTRWs3q6iQA/o2B0RyNVabhgl7/FVohnSKVwjF4VhehsRTEZ5SWVtONVzFX0I9In
	 R7GzTPZa8fzFWiKFXZnXjUolwBTwO4slzywzkHGRchdcG6ftqGNoC3dPHhirlEbav1
	 TOmgKmqgTpD3A==
Date: Wed, 31 May 2023 15:24:46 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Liu Peibao <liupeibao@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <ZHetDo5PozWdtrxP@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531165819.phx7uwlgtvnt3tvb@skbuf>

[+cc Loongson folks, thread at
https://lore.kernel.org/r/20230521115141.2384444-1-vladimir.oltean@nxp.com]

On Wed, May 31, 2023 at 07:58:19PM +0300, Vladimir Oltean wrote:
> On Wed, May 31, 2023 at 11:56:02AM -0500, Bjorn Helgaas wrote:
> > What bad things happen without this patch?
> 
> It's in the commit title: probing the entire device (PCI device!!!) is
> skipped if function 0 has status = "disabled". Aka PCIe functions 1, 2, 3, 4, ...

I guess I should have asked "what bad things happen without this patch
and without the DT 'disabled' status"?

I think 6fffbc7ae137 ("PCI: Honor firmware's device disabled status")
was basically a workaround for Loongson making a device visible in PCI
config space when it shouldn't have been [1].

6fffbc7ae137 [2] means we pretend the PCI device doesn't exist if DT
status is "disabled".  If the device happens to be Function 0, that
means we don't look for any more functions.  I guess that doesn't
matter for Loongson.  But it does matter for this NXP platform, where
we don't want to use Function 0, but we *do* want to use other
Functions.

There are several PCIe things that are required to be in Function 0
(MPS, ASPM, IDE, CMA/SPDM, etc), at least in certain cases.

What would happen if instead of making pci_setup_device() fail (as
both 6fffbc7ae137 and this patch do, which means the device doesn't
even show up in "lspci"), we just prevent drivers from binding to it,
e.g., by making pci_device_probe() fail?  The device would then appear
in "lspci" and the PCI core would configure things as usual, but no
drivers would be able to claim it.

Bjorn

[1] https://lore.kernel.org/all/20221114074346.23008-1-liupeibao@loongson.cn/
[2] https://git.kernel.org/linus/6fffbc7ae137

