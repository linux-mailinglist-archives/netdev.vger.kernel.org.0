Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6733892DA
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354958AbhESPov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242076AbhESPos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 11:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A055C611BD;
        Wed, 19 May 2021 15:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621439008;
        bh=DMr8lSulIAPylUxWoxAnCkPFFhWH0Kf0bTYVbrlD5oU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZBsRsLtvL3OG+6gDXNSRZE+UBQZ7qyYaRl7IaaqFCLr8JAtCBcGwvWaCkCAfZCR39
         PDJB2FUHo1Pj09dgtXv9TM4S31AMMet7lAA1fFh7FJDx3uiBMvKMoC1X9pFQn+sAlc
         TPSaFn7VgzCBug6b+05DyFrIApccSbS6J65rG2tvl9cNFFci0VSW87F5Cb6mnf8Weh
         caOHUdyc3bU4PPYxoMNvwjOt6/nEi3/nISlh6NSEYaxeCkonnLEwBvlbZVP2r3XFAz
         wLU/S5EQr/i7vykRTT5cOJLEWDZooAikUHjeiN4K74s8Sh9bDwsbOhBrf+Pr8ePnvo
         33YvVjgLHfQhQ==
Date:   Wed, 19 May 2021 18:43:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH v5 06/22] i40e: Register auxiliary devices to provide RDMA
Message-ID: <YKUyHBegLKDlYYoN@unreal>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
 <20210514141214.2120-7-shiraz.saleem@intel.com>
 <YKUJ4rnZf4u4qUYc@unreal>
 <20210519134349.GK1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519134349.GK1002214@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 10:43:49AM -0300, Jason Gunthorpe wrote:
> On Wed, May 19, 2021 at 03:51:46PM +0300, Leon Romanovsky wrote:
> > On Fri, May 14, 2021 at 09:11:58AM -0500, Shiraz Saleem wrote:
> > > Convert i40e to use the auxiliary bus infrastructure to export
> > > the RDMA functionality of the device to the RDMA driver.
> > > Register i40e client auxiliary RDMA device on the auxiliary bus per
> > > PCIe device function for the new auxiliary rdma driver (irdma) to
> > > attach to.
> > > 
> > > The global i40e_register_client and i40e_unregister_client symbols
> > > will be obsoleted once irdma replaces i40iw in the kernel
> > > for the X722 device.
> > > 
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > >  drivers/net/ethernet/intel/Kconfig            |   1 +
> > >  drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
> > >  drivers/net/ethernet/intel/i40e/i40e_client.c | 152 ++++++++++++++++++++++----
> > >  drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
> > >  4 files changed, 136 insertions(+), 20 deletions(-)
> > 
> > The amount of obfuscation in this driver is astonishing.
> > 
> > I would expect that after this series, the i40e_client_add_*() would
> > be cleaned, for example simple grep of I40E_CLIENT_VERSION_MAJOR
> > shows that i40e_register_client() still have no-go code.
> 
> While it would be nice to see i40e fully cleaned I think we agreed to
> largely ignore it as-is so long as the new driver's aux implementation
> was sane.

It is hard to say, the code is so obfuscated with many layers in between.

For example, I tried to follow where and how they use IDA index that is used
in aux device creation and went lost. Sometimes they take it from PF, sometimes
from the client from different allocation pool.

If client logic goes, we will see less code which should be similar for
netdev and RDMA. It is not the case now.

Thanks

> 
> Jason
