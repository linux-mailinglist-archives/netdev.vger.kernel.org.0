Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DC917B125
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCEWDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCEWDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 17:03:25 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9599C206E2;
        Thu,  5 Mar 2020 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583445804;
        bh=Tt/HPiEN1be1bMXUc+FPnJLssyDI7hp8othHpI5TpjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j/r6DQ+LVFIvskEwrBNm8+TYYtrWcul/hQWjwT8CDH1JWoXwUZeHCrGIf01EhLDHK
         wnsmv41pSrdeTBoegrBvVdlS1XOOBj40h35CCd9avcV+0JwFW78vwgmVkv2CduLiHA
         m3cz9DvCPYCSYqmBDULRPZI179VRv7O2IjQGGo70=
Date:   Thu, 5 Mar 2020 14:03:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
Message-ID: <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200305052319.14682-8-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
        <20200305052319.14682-8-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Mar 2020 21:23:18 -0800 Shannon Nelson wrote:
> Add support for an additional device id.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

I have thought about this for a while and I wanted to ask you to say 
a bit more about the use of the management device.

Obviously this is not just "additional device id" in the traditional
sense where device IDs differentiate HW SKUs or revisions. This is the
same exact hardware, just a different local feature (as proven by the
fact that you make 0 functional changes).

In the past we (I?) rejected such extensions upstream from Netronome and
Cavium, because there were no clear use cases which can't be solved by
extending standard kernel APIs. Do you have any?

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
> index bb106a32f416..c8ff33da243a 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
> @@ -18,6 +18,7 @@ struct ionic_lif;
>  
>  #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
>  #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
>  
>  #define DEVCMD_TIMEOUT  10
>  
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> index 59b0091146e6..3dc985cae391 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> @@ -15,6 +15,7 @@
>  static const struct pci_device_id ionic_id_table[] = {
>  	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
>  	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
>  	{ 0, }	/* end of table */
>  };
>  MODULE_DEVICE_TABLE(pci, ionic_id_table);

