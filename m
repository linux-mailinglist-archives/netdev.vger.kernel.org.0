Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470BA52363D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245153AbiEKOyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245135AbiEKOyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:54:04 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A5F1FC2DC
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:53:59 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E944F61E6478B;
        Wed, 11 May 2022 16:53:56 +0200 (CEST)
Message-ID: <f486b0a0-2f6b-13e9-e905-8ad9163020a7@molgen.mpg.de>
Date:   Wed, 11 May 2022 16:53:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: =?UTF-8?B?UmU6IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSF0gaWdiX21haW7vvJpB?=
 =?UTF-8?Q?dded_invalid_mac_address_handling_in_igb=5fprobe?=
Content-Language: en-US
To:     lixue liang <lianglixue@greatwall.com.cn>
References: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
In-Reply-To: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Lixue,


Thank you for the patch. Please tag patch iterations with a version. 
(Use `-v 2` in `git send-email` for example.)

Am 11.05.22 um 10:07 schrieb lixue liang:

Please use the normal colon : in the summary.

Also, please use imperative mood in present tense: Add …

But, in this case

Handle invalid MAC address …

is shorter. Or:

Assign random MAC address instead of fail in case of invalid one

> In some cases, when the user uses igb_set_eeprom to modify
> the mac address to be invalid, the igb driver will fail to load.
> If there is no network card device, the user must modify it to
> a valid mac address by other means. It is only the invalid
> mac address that causes the driver The fatal problem of

… MAC address causing the driver to failure. The fatal …

> loading failure will cause most users no choice but to trouble.

Maybe remove this sentence, or rephrase.

> Since the mac address may be changed to be invalid, it must
> also be changed to a valid mac address, then add a random
> valid mac address to replace the invalid mac address in the
> driver, continue to load the igb network card driver,
> and output the relevant log reminder. vital to the user.

Please reflow for 75 characters per line. (More words fit in one line.)

> Signed-off-by: lixue liang <lianglixue@greatwall.com.cn>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..a513570c2ad6 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	eth_hw_addr_set(netdev, hw->mac.addr);
>   
>   	if (!is_valid_ether_addr(netdev->dev_addr)) {
> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
> -		err = -EIO;
> -		goto err_eeprom;
> +		eth_random_addr(netdev->dev_addr);
> +		memcpy(hw->mac.addr, netdev->dev_addr, netdev->addr_len);
> +		dev_info(&pdev->dev,
> +			 "Invalid Mac Address, already got random Mac Address\n");

Is there a valid MAC address that should be only used for testing. Maybe 
that can be used. Maybe also log the address.

Lastly, please fully capitalize MAC.

>   	}
>   
>   	igb_set_default_mac_filter(adapter);


Kind regards,

Paul
