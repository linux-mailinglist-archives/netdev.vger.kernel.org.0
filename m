Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BABC41B7FE
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242630AbhI1UJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242120AbhI1UJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 16:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13EEA61157;
        Tue, 28 Sep 2021 20:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632859693;
        bh=2q54bLyOqMkKWDejBRp+5bRZfTrKTSWJcV2n/WM7O5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=SJlILrO3fJ9ue8UvYpapX4ojkALIQWP0IhyvgGUEnmc2bU4/eR9Oz1WHf91TFCvXA
         +AvaFLotNIk6GNVMTzMiHUmE0SECnG/DaFsMeYfbeJ4HnUD4sgFtdp1R5TXABKq/V5
         4Gltdrd5KbjraDvTp7Dojw2UaOlvPdW7DYea08nUCxmciYyaMtdgK79OJikk1fI3dS
         IQxjaLHV0wfoBer0BAfg32is1dAvMuIslQlV94SxW032Uh3Itk0NL7NQX8SiKEicB1
         kZRIFonoYbzHfn7L/mtYQNU1K3C/vNR3V9ujP6yh2gmx56PtY428rmLhwG6a55K51M
         NJoYyJGhopiig==
Date:   Tue, 28 Sep 2021 15:08:11 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Vadym Kochan <vkochan@marvell.com>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Simon Horman <simon.horman@corigine.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210928200811.GA724823@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210928192936.w5umyzivi4hs6q3r@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 09:29:36PM +0200, Uwe Kleine-König wrote:
> On Tue, Sep 28, 2021 at 12:17:59PM -0500, Bjorn Helgaas wrote:
> > [+to Oliver, Russell for eeh_driver_name() question below]
> > 
> > On Mon, Sep 27, 2021 at 10:43:22PM +0200, Uwe Kleine-König wrote:
> > > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > 
> > > struct pci_dev::driver holds (apart from a constant offset) the same
> > > data as struct pci_dev::dev->driver. With the goal to remove struct
> > > pci_dev::driver to get rid of data duplication replace getting the
> > > driver name by dev_driver_string() which implicitly makes use of struct
> > > pci_dev::dev->driver.

> > Also, would you mind using "pci_dev.driver" instead of
> > "pci_dev::driver"?  AFAIK, the "::" operator is not actually part of
> > C, so I think it's more confusing than useful.
> 
> pci_dev.driver doesn't work either in C because pci_dev is a type and
> not a variable.

Sure, "pci_dev.driver" is not strictly acceptable C unless you have a
"struct pci_dev pci_dev", but it's pretty common.
