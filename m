Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B663BAB9B
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 07:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGDFjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 01:39:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:28858 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhGDFjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 01:39:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10034"; a="208679126"
X-IronPort-AV: E=Sophos;i="5.83,323,1616482800"; 
   d="scan'208";a="208679126"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2021 22:37:02 -0700
X-IronPort-AV: E=Sophos;i="5.83,323,1616482800"; 
   d="scan'208";a="561502755"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.249.95.249]) ([10.249.95.249])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2021 22:36:58 -0700
Subject: Re: [Intel-wired-lan] [PATCH 2/2] igc: wait for the MAC copy when
 enabled MAC passthrough
To:     Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Edri, Michael" <michael.edri@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210702045120.22855-2-aaron.ma@canonical.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <613e2106-940a-49ed-6621-0bb00bc7dca5@intel.com>
Date:   Sun, 4 Jul 2021 08:36:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702045120.22855-2-aaron.ma@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/2021 07:51, Aaron Ma wrote:
> Such as dock hot plug event when runtime, for hardware implementation,
> the MAC copy takes less than one second when BIOS enabled MAC passthrough.
> After test on Lenovo TBT4 dock, 600ms is enough to update the
> MAC address.
> Otherwise ethernet fails to work.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 606b72cb6193..c8bc5f089255 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -5468,6 +5468,9 @@ static int igc_probe(struct pci_dev *pdev,
>   	memcpy(&hw->mac.ops, ei->mac_ops, sizeof(hw->mac.ops));
>   	memcpy(&hw->phy.ops, ei->phy_ops, sizeof(hw->phy.ops));
>   
> +	if (pci_is_thunderbolt_attached(pdev) > +		msleep(600);
I believe it is a bit fragile. I would recommend here look for another 
indication instead of delay. Can we poll for a 'pci_channel_io_normal' 
state? (igc->pdev->error_state == pci_channel_io_normal)
> +
>   	/* Initialize skew-specific constants */
>   	err = ei->get_invariants(hw);
>   	if (err)
> 
Thanks Aaron,
sasha
