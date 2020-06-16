Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12361FADC2
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgFPKUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:20:31 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46915 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726052AbgFPKUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 06:20:31 -0400
Received: from [192.168.0.6] (ip5f5af4df.dynamic.kabel-deutschland.de [95.90.244.223])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DD048206442E6;
        Tue, 16 Jun 2020 12:20:27 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: continue to init phy even when
 failed to disable ULP
To:     Aaron Ma <aaron.ma@canonical.com>, jeffrey.t.kirsher@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vitaly.lifshits@intel.com,
        kai.heng.feng@canonical.com, sasha.neftin@intel.com
References: <20200616100512.22512-1-aaron.ma@canonical.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <74391e62-7226-b0f8-d129-768b88f13160@molgen.mpg.de>
Date:   Tue, 16 Jun 2020 12:20:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200616100512.22512-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Aaron,


Thank you for your patch.

(Rant: Some more fallout from the other patch, which nobody reverted.)

Am 16.06.20 um 12:05 schrieb Aaron Ma:
> After commit "e1000e: disable s0ix entry and exit flows for ME systems",
> some ThinkPads always failed to disable ulp by ME.

Please add the (short) commit hash from the master branch.

s/ulp/ULP/

Please list one ThinkPad as example.

> commit "e1000e: Warn if disabling ULP failed" break out of init phy:

1.  Please add the closing quote ".
2.  Please add the commit hash.

> error log:
> [   42.364753] e1000e 0000:00:1f.6 enp0s31f6: Failed to disable ULP
> [   42.524626] e1000e 0000:00:1f.6 enp0s31f6: PHY Wakeup cause - Unicast Packet
> [   42.822476] e1000e 0000:00:1f.6 enp0s31f6: Hardware Error
> 
> When disable s0ix, E1000_FWSM_ULP_CFG_DONE will never be 1.
> If continue to init phy like before, it can work as before.
> iperf test result good too.
> 
> Chnage e_warn to e_dbg, in case it confuses.

s/Chnage/Change/

Please leave the level warning, and improve the warning message instead, 
so a user knows what is going on.

Could you please add a `Fixes:` tag and the URL to the bug report?

> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>   drivers/net/ethernet/intel/e1000e/ich8lan.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index f999cca37a8a..63405819eb83 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -302,8 +302,7 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
>   	hw->dev_spec.ich8lan.ulp_state = e1000_ulp_state_unknown;
>   	ret_val = e1000_disable_ulp_lpt_lp(hw, true);
>   	if (ret_val) {
> -		e_warn("Failed to disable ULP\n");
> -		goto out;
> +		e_dbg("Failed to disable ULP\n");
>   	}
>   
>   	ret_val = hw->phy.ops.acquire(hw);
> 

Kind regards,

Paul
