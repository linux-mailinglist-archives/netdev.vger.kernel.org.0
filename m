Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D727B3AFD5B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhFVGwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:52:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:54218 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230357AbhFVGwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 02:52:49 -0400
IronPort-SDR: jAHWt+u0Bh/O22IVizBuQCkwRSogPS8NF4riiylzGgH46+1QtFrm2JjUC0nCJw0m4p79nSGngR
 1KVu1QftVmfg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="228549729"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="228549729"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 23:50:29 -0700
IronPort-SDR: 8unCcfD5ddFdqBvR0Zig+AEb7mF+wfvk+nfcu68tYWrtcJNnPk1H4LOXccr7XEBA5YYYft4D1u
 Sg2smDxwYhHg==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="452498302"
Received: from unknown (HELO [10.185.169.18]) ([10.185.169.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 23:50:23 -0700
Subject: Re: [PATCH] igc: Fix an error handling path in 'igc_probe()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Edri, Michael" <michael.edri@intel.com>
References: <f24ae8234fedd1689fa0116038e10e4d3a033802.1623527947.git.christophe.jaillet@wanadoo.fr>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <ae67bbc1-3bd9-c64c-b507-d2fd30da08e0@intel.com>
Date:   Tue, 22 Jun 2021 09:50:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f24ae8234fedd1689fa0116038e10e4d3a033802.1623527947.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/2021 23:00, Christophe JAILLET wrote:
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
> 
> Fixes: c9a11c23ceb6 ("igc: Add netdev")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 3f6b6d4543a8..6389a41cacc1 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6057,6 +6057,7 @@ static int igc_probe(struct pci_dev *pdev,
>   err_ioremap:
>   	free_netdev(netdev);
>   err_alloc_etherdev:
> +	pci_disable_pcie_error_reporting(pdev);
>   	pci_release_mem_regions(pdev);
>   err_pci_reg:
>   err_dma:
> 
Thanks for this patch.
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
