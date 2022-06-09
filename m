Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1635449BA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 13:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiFILHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 07:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiFILHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 07:07:19 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C7D2A788D
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:07:18 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A661761EA1928;
        Thu,  9 Jun 2022 13:07:16 +0200 (CEST)
Message-ID: <9d83c7c5-9699-1e21-ac8c-99ac55a75401@molgen.mpg.de>
Date:   Thu, 9 Jun 2022 13:07:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5] igb: Assign random MAC address instead of fail in case
 of invalid one
Content-Language: en-US
To:     Lixue Liang <lianglixuehao@126.com>
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
References: <20220609083904.91778-1-lianglixuehao@126.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220609083904.91778-1-lianglixuehao@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Lixue,


Thank you for all the iterations.

Am 09.06.22 um 10:39 schrieb Lixue Liang:
> From: Lixue Liang <lianglixue@greatwall.com.cn>
> 
> In some cases, when the user uses igb_set_eeprom to modify the MAC address
> to be invalid, or an invalid MAC address appears when with uninitialized
> samples, the igb driver will fail to load. If there is no network card
> device, the user could not conveniently modify it to a valid MAC address,
> for example using ethtool to modify.
> 
> Through module parameter to set，when the MAC address is invalid, a random
> valid MAC address can be used to continue loading and output relevant log
> reminders. In this way, users can conveniently correct invalid MAC address.

Maybe:

Add the module parameter `…` to control the behavior. When set to true, 
a random MAC address is assigned, and the driver can be loaded, allowing 
the user to correct the invalid MAC address.

> 
> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
> ---

[…]

> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..8162e8999ccb 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -238,8 +238,11 @@ MODULE_LICENSE("GPL v2");
>   
>   #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
>   static int debug = -1;
> +static unsigned int invalid_mac_address_allow;

Make it a boolean?

>   module_param(debug, int, 0);
> +module_param(invalid_mac_address_allow, uint, 0);

Name it `allow_invalid_mac_address`?

>   MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
> +MODULE_PARM_DESC(invalid_mac_address_allow, "Allow NIC driver to be loaded with invalid MAC address");
>   
>   struct igb_reg_info {
>   	u32 ofs;
> @@ -3359,9 +3362,16 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	eth_hw_addr_set(netdev, hw->mac.addr);
>   
>   	if (!is_valid_ether_addr(netdev->dev_addr)) {
> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
> -		err = -EIO;
> -		goto err_eeprom;
> +		if (!invalid_mac_address_allow) {
> +			dev_err(&pdev->dev, "Invalid MAC Address\n");

Correct the spelling in a patch in front of this patch?

> +			err = -EIO;
> +			goto err_eeprom;
> +		} else {
> +			eth_hw_addr_random(netdev);
> +			ether_addr_copy(hw->mac.addr, netdev->dev_addr);
> +			dev_err(&pdev->dev,
> +				"Invalid MAC address. Assigned random MAC address\n");
> +		}
>   	}
>   
>   	igb_set_default_mac_filter(adapter);


Kind regards,

Paul
