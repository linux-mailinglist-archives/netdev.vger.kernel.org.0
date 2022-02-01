Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF34A6501
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbiBAT1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:27:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242278AbiBAT1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 14:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wz74ecBRRy5osiptH6mAHo5InVXq8xkawwUnzut97j4=; b=h892aCtiyDGLi3SODvyrRwY9yS
        E+hNgBBdBFQs19EYya29T5I+/kReGFQhXiXfXi8MM94CBLfzjq+qteCzC5X0WUKApFy5a4d6pwxXh
        EufxTcUUHNRFE/jT64WlV5CXWM4RRiEd/TMTpsQEs3I+z0JbfxAoeXyAjC8zZWchYvY8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nEyoE-003qai-HN; Tue, 01 Feb 2022 20:27:22 +0100
Date:   Tue, 1 Feb 2022 20:27:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: Replace acpi_bus_get_device()
Message-ID: <YfmJmgE/KuS8G92w@lunn.ch>
References: <3151721.aeNJFYEL58@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3151721.aeNJFYEL58@kreacher>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 08:07:08PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Replace acpi_bus_get_device() that is going to be dropped with
> acpi_fetch_acpi_dev().
> 
> No intentional functional impact.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.c |    4 ++--
>  drivers/net/fjes/fjes_main.c                      |   10 +++-------
>  drivers/net/mdio/mdio-xgene.c                     |    8 +++-----
>  3 files changed, 8 insertions(+), 14 deletions(-)
> 
> Index: linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> ===================================================================
> --- linux-pm.orig/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> +++ linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> @@ -1407,9 +1407,9 @@ static acpi_status bgx_acpi_register_phy
>  {
>  	struct bgx *bgx = context;
>  	struct device *dev = &bgx->pdev->dev;
> -	struct acpi_device *adev;
> +	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);

Hi Rafael

Since this is part of the networking subsystem, reverse christmas tree
applies. Yes, this driver gets is wrong here, but we should not make
it even worse. Please put this variable first.

> Index: linux-pm/drivers/net/mdio/mdio-xgene.c
> ===================================================================
> --- linux-pm.orig/drivers/net/mdio/mdio-xgene.c
> +++ linux-pm/drivers/net/mdio/mdio-xgene.c
> @@ -280,15 +280,13 @@ static acpi_status acpi_register_phy(acp
>  				     void *context, void **ret)
>  {
>  	struct mii_bus *mdio = context;
> -	struct acpi_device *adev;
> +	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);

Here as well please.

With those changes, you can add my Reviewed-by:

Thanks
     Andrew
