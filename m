Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7507C4AF741
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbiBIQy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiBIQy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:54:27 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60899C0613C9;
        Wed,  9 Feb 2022 08:54:29 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aee30.dynamic.kabel-deutschland.de [95.90.238.48])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3D88861E6478B;
        Wed,  9 Feb 2022 17:54:26 +0100 (CET)
Message-ID: <c496b425-7e8a-a0d9-b27a-990b54743a01@molgen.mpg.de>
Date:   Wed, 9 Feb 2022 17:54:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Print PHY register address when
 MDI read/write fails
Content-Language: en-US
To:     Chen Yu <yu.c.chen@intel.com>
References: <20220209234302.50833-1-yu.c.chen@intel.com>
Cc:     intel-wired-lan@osuosl.org, Len Brown <len.brown@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todd Brandt <todd.e.brandt@intel.com>,
        "David S. Miller" <davem@davemloft.net>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220209234302.50833-1-yu.c.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Chen,


First, your system time is incorrect, and the message date from the future.


Am 10.02.22 um 00:43 schrieb Chen Yu:
> There is occasional suspend error from e1000e which blocks the
> system from further suspending:

Please add a blank line here.

Also, please document the specific board/configuration in question.

> [   20.078957] PM: pci_pm_suspend(): e1000e_pm_suspend+0x0/0x780 [e1000e] returns -2
> [   20.078970] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x170 returns -2
> [   20.078974] e1000e 0000:00:1f.6: PM: pci_pm_suspend+0x0/0x170 returned -2 after 371012 usecs
> [   20.078978] e1000e 0000:00:1f.6: PM: failed to suspend async: error -2

Please add a blank line her.e

> According to the code flow, this might be caused by broken MDI read/write to PHY registers.
> However currently the code does not tell us which register is broken. Thus enhance the debug
> information to print the offender PHY register for easier debugging.

Please reflow for 75 characters per line, and maybe even paste the new 
messages, if you have a system, where you can reproduce that on.

> Reported-by: Todd Brandt <todd.e.brandt@intel.com>
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> ---
>   drivers/net/ethernet/intel/e1000e/phy.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> index 0f0efee5fc8e..fd07c3679bb1 100644
> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -146,11 +146,11 @@ s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
>   			break;
>   	}
>   	if (!(mdic & E1000_MDIC_READY)) {
> -		e_dbg("MDI Read did not complete\n");
> +		e_dbg("MDI Read PHY Reg Address %d did not complete\n", offset);
>   		return -E1000_ERR_PHY;
>   	}
>   	if (mdic & E1000_MDIC_ERROR) {
> -		e_dbg("MDI Error\n");
> +		e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
>   		return -E1000_ERR_PHY;
>   	}
>   	if (((mdic & E1000_MDIC_REG_MASK) >> E1000_MDIC_REG_SHIFT) != offset) {
> @@ -210,11 +210,11 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
>   			break;
>   	}
>   	if (!(mdic & E1000_MDIC_READY)) {
> -		e_dbg("MDI Write did not complete\n");
> +		e_dbg("MDI Write PHY Reg Address %d did not complete\n", offset);
>   		return -E1000_ERR_PHY;
>   	}
>   	if (mdic & E1000_MDIC_ERROR) {
> -		e_dbg("MDI Error\n");
> +		e_dbg("MDI Write PHY Red Address %d Error\n", offset);
>   		return -E1000_ERR_PHY;
>   	}
>   	if (((mdic & E1000_MDIC_REG_MASK) >> E1000_MDIC_REG_SHIFT) != offset) {

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
