Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A40C2E8B6F
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 09:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbhACIlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 03:41:44 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38179 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbhACIlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 03:41:44 -0500
Received: from [192.168.0.6] (ip5f5aeaad.dynamic.kabel-deutschland.de [95.90.234.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id CEF6B20647B6A;
        Sun,  3 Jan 2021 09:41:00 +0100 (CET)
Subject: Re: [Intel-wired-lan] [PATCH] net: ixgbe: Fix memleak in
 ixgbe_configure_clsu32
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
References: <20210103080843.25914-1-dinghao.liu@zju.edu.cn>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kjlu@umn.edu
Message-ID: <aefe9de0-83b4-81b8-5d5b-674cb8ea97e8@molgen.mpg.de>
Date:   Sun, 3 Jan 2021 09:41:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210103080843.25914-1-dinghao.liu@zju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Dinghao,


Am 03.01.21 um 09:08 schrieb Dinghao Liu:
> When ixgbe_fdir_write_perfect_filter_82599() fails,
> input allocated by kzalloc() has not been freed,
> which leads to memleak.

Nice find. Thank you for your patches. Out of curiosity, do you use an 
analysis tool to find these issues?

> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 393d1c2cd853..e9c2d28efc81 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -9582,8 +9582,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
>   	ixgbe_atr_compute_perfect_hash_82599(&input->filter, mask);
>   	err = ixgbe_fdir_write_perfect_filter_82599(hw, &input->filter,
>   						    input->sw_idx, queue);
> -	if (!err)
> -		ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
> +	if (err)
> +		goto err_out_w_lock;
> +
> +	ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
>   	spin_unlock(&adapter->fdir_perfect_lock);
>   
>   	if ((uhtid != 0x800) && (adapter->jump_tables[uhtid]))

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

I wonder, in the non-error case, how `input` and `jump` are freed.

Old code:

>         if (!err)
>                 ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
>         spin_unlock(&adapter->fdir_perfect_lock);
> 
>         if ((uhtid != 0x800) && (adapter->jump_tables[uhtid]))
>                 set_bit(loc - 1, (adapter->jump_tables[uhtid])->child_loc_map);
> 
>         kfree(mask);
>         return err;

Should these two lines be replaced with `goto err_out`? (Though the name 
is confusing then, as it’s the non-error case.)

> err_out_w_lock:
>         spin_unlock(&adapter->fdir_perfect_lock);
> err_out:
>         kfree(mask);
> free_input:
>         kfree(input);
> free_jump:
>         kfree(jump);
>         return err;
> }

Kind regards,

Paul
