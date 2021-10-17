Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F2A430728
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 10:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245028AbhJQILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 04:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhJQILK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 04:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D57F60F59;
        Sun, 17 Oct 2021 08:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634458139;
        bh=Vz/2aO/SIMqM/YfSkB1kYGreU/RsX8SFF/xBgFxyRRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2l/PD6AzZ8ETexRR9meM/HF0d61U4WnD0mkpmuYjUt3u4t750pwVif1r7IKwVxJF
         Uyb02llG+npCRafm6yxDH3TD+TEw6kWrdmf2Q67infHzckWj45tieMwhR8vrSL0tov
         /RDbKT5LTvTIzQsODukhKv8SCbuBrGSe1oL1sCZ5bkMPskpo1BSJKIA+iyNc/E2REP
         llPmDeRrDSt8snKOZ/t9qptpbs044hugNYv3SPaCPKpci3z8xTC6Celue8XhwWurWa
         SbVobtBGphJqgn8DwB8IL27N+iHb+VZVscgGfMlJ0HLL58k4aHxAVYCfrJwYCZ8Qpj
         C0MMHZj0jOS+w==
Received: by pali.im (Postfix)
        id C1E0110C4; Sun, 17 Oct 2021 10:08:56 +0200 (CEST)
Date:   Sun, 17 Oct 2021 10:08:56 +0200
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
Subject: Re: [PATCH v3 4/5] mwifiex: Send DELBA requests according to spec
Message-ID: <20211017080856.hy3cjszegur5gumy@pali>
References: <20211016153244.24353-1-verdre@v0yd.nl>
 <20211016153244.24353-5-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211016153244.24353-5-verdre@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 16 October 2021 17:32:43 Jonas Dreßler wrote:
> While looking at on-air packets using Wireshark, I noticed we're never
> setting the initiator bit when sending DELBA requests to the AP: While
> we set the bit on our del_ba_param_set bitmask, we forget to actually
> copy that bitmask over to the command struct, which means we never
> actually set the initiator bit.
> 
> Fix that and copy the bitmask over to the host_cmd_ds_11n_delba command
> struct.
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>

Acked-by: Pali Rohár <pali@kernel.org>

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
