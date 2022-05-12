Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C97524EE8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354761AbiELN40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352058AbiELN4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:56:01 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4627026AE1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:55:57 -0700 (PDT)
Received: from [192.168.0.7] (ip5f5aeace.dynamic.kabel-deutschland.de [95.90.234.206])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4ECAF61EA1923;
        Thu, 12 May 2022 15:55:54 +0200 (CEST)
Message-ID: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
Date:   Thu, 12 May 2022 15:55:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Intel-wired-lan] [PATCH v2 2/2] igb_main: Assign random MAC
 address instead of fail in case of invalid one
Content-Language: en-US
To:     lixue liang <lianglixue@greatwall.com.cn>
References: <20220512093918.86084-1-lianglixue@greatwall.com.cn>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220512093918.86084-1-lianglixue@greatwall.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Lixue,


Thank you for sending version 2. Some more minor nits.

Am 12.05.22 um 11:39 schrieb lixue liang:
> In some cases, when the user uses igb_set_eeprom to modify the MAC
> address to be invalid, the igb driver will fail to load. If there is no
> network card device, the user must modify it to a valid MAC address by
> other means.
> 
> Since the MAC address can be modified ,then add a random valid MAC address
> to replace the invalid MAC address in the driver can be workable, it can
> continue to finish the loading ,and output the relevant log reminder.

Please add the space after the comma.

> Reported-by: kernel test robot <lkp@intel.com>

This line is confusing. Maybe add that to the version change-log below 
the `---`.

> Signed-off-by: lixue liang <lianglixue@greatwall.com.cn>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index a513570c2ad6..746233befade 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3359,10 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	eth_hw_addr_set(netdev, hw->mac.addr);
>   
>   	if (!is_valid_ether_addr(netdev->dev_addr)) {
> -		eth_random_addr(netdev->dev_addr);
> -		memcpy(hw->mac.addr, netdev->dev_addr, netdev->addr_len);
> -		dev_info(&pdev->dev,
> -			 "Invalid Mac Address, already got random Mac Address\n");
> +		eth_hw_addr_random(netdev);
> +		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
> +		dev_err(&pdev->dev,
> +			"Invalid MAC Address, already assigned random MAC Address\n");

Please spell it MAC address.

>   	}
>   
>   	igb_set_default_mac_filter(adapter);


Kind regards,

Paul
