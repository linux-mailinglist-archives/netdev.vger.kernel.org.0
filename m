Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229FD1696FD
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 10:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgBWJKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 04:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgBWJKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 04:10:35 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B689D208C3;
        Sun, 23 Feb 2020 09:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582449034;
        bh=5UHebaNDgWyK4gzuBOT4a19AoeqbntwLXWRfN6H+Y40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S8sGEEUaeRwsUOG0FRyHyqXXusHIm+IVJZkk9AI6/r8pmbbUIfZJSby9QhRAx9Rrd
         YM4l7jnR0VxxrM4ebXJ+jHoP1h6u/5g1p1AYemABdPzdBUx3BtmzU+Amax58RLw2nU
         cE4+xUs5MtzpU3Sx00Jxikpri+DlG8B3jjc4/+sA=
Date:   Sun, 23 Feb 2020 11:10:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>
Subject: Re: [PATCH net-next 11/16] net/amazon: Ensure that driver version is
 aligned to the linux kernel
Message-ID: <20200223091031.GA422704@unreal>
References: <20200220145855.255704-1-leon@kernel.org>
 <20200220145855.255704-12-leon@kernel.org>
 <fb459df1-a1f7-964c-74a9-2f8e7a4ba26b@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb459df1-a1f7-964c-74a9-2f8e7a4ba26b@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 10:54:29AM +0200, Gal Pressman wrote:
> On 20/02/2020 16:58, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> >
> > Upstream drivers are managed inside global repository and released all
> > together, this ensure that driver version is the same as linux kernel,
> > so update amazon drivers to properly reflect it.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 -
> >  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 17 ++---------------
> >  drivers/net/ethernet/amazon/ena/ena_netdev.h  | 11 -----------
> >  3 files changed, 2 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > index ced1d577b62a..19262f37db84 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > @@ -404,7 +404,6 @@ static void ena_get_drvinfo(struct net_device *dev,
> >  	struct ena_adapter *adapter = netdev_priv(dev);
> >
> >  	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
> > -	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
> >  	strlcpy(info->bus_info, pci_name(adapter->pdev),
> >  		sizeof(info->bus_info));
> >  }
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > index 0b2fd96b93d7..4faf81c456d8 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > @@ -49,12 +49,9 @@
> >  #include <linux/bpf_trace.h>
> >  #include "ena_pci_id_tbl.h"
> >
> > -static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
> > -
> >  MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
> >  MODULE_DESCRIPTION(DEVICE_NAME);
> >  MODULE_LICENSE("GPL");
> > -MODULE_VERSION(DRV_MODULE_VERSION);
> >
> >  /* Time in jiffies before concluding the transmitter is hung. */
> >  #define TX_TIMEOUT  (5 * HZ)
> > @@ -3093,11 +3090,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
> >  	host_info->os_dist = 0;
> >  	strncpy(host_info->os_dist_str, utsname()->release,
> >  		sizeof(host_info->os_dist_str) - 1);
> > -	host_info->driver_version =
> > -		(DRV_MODULE_VER_MAJOR) |
> > -		(DRV_MODULE_VER_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
> > -		(DRV_MODULE_VER_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
> > -		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
> > +	host_info->driver_version = LINUX_VERSION_CODE;
>
> Hey Leon,
> I'm not sure it's safe to replace this one, adding ENA people..

I tried to avoid any changes in FW<->SW interfaces and in this case
probably missed the handling of this info to the FW.

So can you please help me and point to the relevant call stack?

It will be great too, to hear how do you distinguish between various
distribution and their driver versions based on that string.

Thanks
