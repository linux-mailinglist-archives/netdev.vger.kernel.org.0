Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D057AB5FCC
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 11:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfIRJFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 05:05:51 -0400
Received: from foss.arm.com ([217.140.110.172]:37806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfIRJFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 05:05:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75E90337;
        Wed, 18 Sep 2019 02:05:50 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E06CF3F59C;
        Wed, 18 Sep 2019 02:05:49 -0700 (PDT)
Date:   Wed, 18 Sep 2019 10:05:48 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 13/26] e1000: Use PCI_STD_NUM_BARS
Message-ID: <20190918090547.GZ9720@e119886-lin.cambridge.arm.com>
References: <20190916204158.6889-1-efremov@linux.com>
 <20190916204158.6889-14-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916204158.6889-14-efremov@linux.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 11:41:45PM +0300, Denis Efremov wrote:
> To iterate through all possible BARs, loop conditions refactored to the
> *number* of BARs "i < PCI_STD_NUM_BARS", instead of the index of the last
> valid BAR "i <= BAR_5". This is more idiomatic C style and allows to avoid
> the fencepost error.
> 
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000.h      | 1 -
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
> index c40729b2c184..7fad2f24dcad 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000.h
> +++ b/drivers/net/ethernet/intel/e1000/e1000.h
> @@ -45,7 +45,6 @@
>  
>  #define BAR_0		0
>  #define BAR_1		1
> -#define BAR_5		5

No issue with this patch. However I noticed that at least 5 of the network
drivers have these same definitions, which are identical to the pci_barno enum
of include/linux/pci-epf.h. There are mostly used with pci_ioremap_bar and
pci_resource_** macros. I wonder if this is an indicator that these defintions
should live in the core.

Thanks,

Andrew Murray

>  
>  #define INTEL_E1000_ETHERNET_DEVICE(device_id) {\
>  	PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
> index f703fa58458e..db4fd82036af 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
> @@ -977,7 +977,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto err_ioremap;
>  
>  	if (adapter->need_ioport) {
> -		for (i = BAR_1; i <= BAR_5; i++) {
> +		for (i = BAR_1; i < PCI_STD_NUM_BARS; i++) {
>  			if (pci_resource_len(pdev, i) == 0)
>  				continue;
>  			if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
> -- 
> 2.21.0
> 
