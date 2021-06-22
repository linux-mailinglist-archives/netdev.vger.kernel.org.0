Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8B33AFF54
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 10:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFVIeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 04:34:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:9523 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhFVIeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 04:34:07 -0400
IronPort-SDR: IPThxi2VB99ay812jsrB0XPHj1OqaMIBqIE8AXIZ6zb+imGGk96xbv26aOG4YJW3IYRwX0CwQB
 g/Skx8YTnTZg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194150643"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194150643"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 01:31:34 -0700
IronPort-SDR: JWFZFk1oPOMYrDwszmAKBB9hfqFqn3B9kATAqjc1YYWnE9dSSmT4N2lIRkf0QjbGCJ635WjV49
 1d5ilXF2yhqw==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="452528472"
Received: from unknown (HELO [10.185.169.18]) ([10.185.169.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 01:31:31 -0700
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Fix an error handling path in
 'e1000_probe()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        "Edri, Michael" <michael.edri@intel.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <2651bb1778490c45d963122619fe3403fdf6b9de.1623819901.git.christophe.jaillet@wanadoo.fr>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <9622d773-323a-3022-e447-0586defd3732@intel.com>
Date:   Tue, 22 Jun 2021 11:31:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2651bb1778490c45d963122619fe3403fdf6b9de.1623819901.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/2021 08:05, Christophe JAILLET wrote:
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
> 
> Fixes: 111b9dc5c981 ("e1000e: add aer support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 5435606149b0..c8aa69fd0405 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7662,6 +7662,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   err_ioremap:
>   	free_netdev(netdev);
>   err_alloc_etherdev:
> +	pci_disable_pcie_error_reporting(pdev);
>   	pci_release_mem_regions(pdev);
>   err_pci_reg:
>   err_dma:
> 
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
