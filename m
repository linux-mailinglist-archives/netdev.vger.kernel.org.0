Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBF2430301
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 16:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244374AbhJPOaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 10:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235901AbhJPOaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 10:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7526F6023F;
        Sat, 16 Oct 2021 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634394492;
        bh=UtxDaouKQps0itBNO4xcZJA5ANZ6urCvPOxooN5Kfz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h296bgRMaq4cIlUw7CSO4BK7lCUnZGTwwvLvhy3E1QMsZWeOe2m/3E5IunKwzPrUY
         fU1FfGQPBbR27F119gMJGvdSzk0vWleL/JpgHcqM0iSGA8Oesf4HsmUx7QMHczVQz9
         O6F9VBLoMxIc81L5Xc5//U9VZV7wd6hGVx4iBRiFBjAMe60yUNaMA5oUQpcESj6iY+
         wlNg8IFwd0txclVf8CzeWShgaJofbJr28TNk42Gs/1ppCKhUHW5DuzHdA5aqyrpKyj
         uVQqgjVN+vILInNtlKjiIplDVpPMjdXJ9HzRG90d3+7JhfXv4hGaxpD9TaG32FJzzK
         vveFXI8aqDtvA==
Received: by pali.im (Postfix)
        id DEEC77DE; Sat, 16 Oct 2021 16:28:09 +0200 (CEST)
Date:   Sat, 16 Oct 2021 16:28:09 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 4/5] mwifiex: Send DELBA requests according to spec
Message-ID: <20211016142809.tjezv4dpxrlmdp6v@pali>
References: <20211016103656.16791-1-verdre@v0yd.nl>
 <20211016103656.16791-5-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211016103656.16791-5-verdre@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 16 October 2021 12:36:55 Jonas Dreßler wrote:
> While looking at on-air packets using Wireshark, I noticed we're never
> setting the initiator bit when sending DELBA requests to the AP: While
> we set the bit on our del_ba_param_set bitmask, we forget to actually
> copy that bitmask over to the command struct, which means we never
> actually set the initiator bit.
> 
> Fix that and copy the bitmask over to the host_cmd_ds_11n_delba command
> struct.
> 
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

Hello! This looks like is fixing mwifiex_send_delba() function which was
added in initial mwifiex commit. So probably it should have following
tag:

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")

> ---
>  drivers/net/wireless/marvell/mwifiex/11n.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
> index b0695432b26a..9ff2058bcd7e 100644
> --- a/drivers/net/wireless/marvell/mwifiex/11n.c
> +++ b/drivers/net/wireless/marvell/mwifiex/11n.c
> @@ -657,14 +657,15 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
>  	uint16_t del_ba_param_set;
>  
>  	memset(&delba, 0, sizeof(delba));
> -	delba.del_ba_param_set = cpu_to_le16(tid << DELBA_TID_POS);
>  
> -	del_ba_param_set = le16_to_cpu(delba.del_ba_param_set);
> +	del_ba_param_set = tid << DELBA_TID_POS;
> +
>  	if (initiator)
>  		del_ba_param_set |= IEEE80211_DELBA_PARAM_INITIATOR_MASK;
>  	else
>  		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
>  
> +	delba.del_ba_param_set = cpu_to_le16(del_ba_param_set);
>  	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
>  
>  	/* We don't wait for the response of this command */
> -- 
> 2.31.1
> 
