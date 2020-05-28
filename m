Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982EB1E5D29
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387859AbgE1K3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387740AbgE1K3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 06:29:01 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AE0A208A7;
        Thu, 28 May 2020 10:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590661740;
        bh=lJCv+y3Stmi60RqMCVzfyZuka7AvcVB3eQtCkL3vvxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rm3chmkmSkSOn7CkNK4xlgDwPHp1fdW1d5tTlE/evovRynijUTTr+GDaNr/G+l6Ne
         OB61g//Nb+NsNrJXlGT8eNzq+Xg3KtykW0fyno/VyOPyeTWaieG/kMiPPey/ajTmue
         uIj7pqMQhl+oNqq9mxyvEDhapSNq//Z1w9MsuMaI=
Received: by pali.im (Postfix)
        id 27B5A7B2; Thu, 28 May 2020 12:28:58 +0200 (CEST)
Date:   Thu, 28 May 2020 12:28:58 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: Parse all API_VER_ID properties
Message-ID: <20200528102858.riwsja5utqix6wqo@pali>
References: <20200521123444.28957-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200521123444.28957-1-pali@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 21 May 2020 14:34:44 Pali Rohár wrote:
> During initialization of SD8997 wifi chip kernel prints warnings:
> 
>   mwifiex_sdio mmc0:0001:1: Unknown api_id: 3
>   mwifiex_sdio mmc0:0001:1: Unknown api_id: 4
> 
> This patch adds support for parsing all api ids provided by SD8997
> firmware.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 17 +++++++++++++++--
>  drivers/net/wireless/marvell/mwifiex/fw.h     |  2 ++
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 

Hello! Could you please look at this trivial patch?

> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 7e4b8cd52..589cc5eb1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -1581,8 +1581,21 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
>  					adapter->fw_api_ver =
>  							api_rev->major_ver;
>  					mwifiex_dbg(adapter, INFO,
> -						    "Firmware api version %d\n",
> -						    adapter->fw_api_ver);
> +						    "Firmware api version %d.%d\n",
> +						    adapter->fw_api_ver,
> +						    api_rev->minor_ver);
> +					break;
> +				case UAP_FW_API_VER_ID:
> +					mwifiex_dbg(adapter, INFO,
> +						    "uAP api version %d.%d\n",
> +						    api_rev->major_ver,
> +						    api_rev->minor_ver);
> +					break;
> +				case CHANRPT_API_VER_ID:
> +					mwifiex_dbg(adapter, INFO,
> +						    "channel report api version %d.%d\n",
> +						    api_rev->major_ver,
> +						    api_rev->minor_ver);
>  					break;
>  				default:
>  					mwifiex_dbg(adapter, FATAL,
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
> index a415d73a7..6f86f5b96 100644
> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
> @@ -1052,6 +1052,8 @@ struct host_cmd_ds_802_11_ps_mode_enh {
>  enum API_VER_ID {
>  	KEY_API_VER_ID = 1,
>  	FW_API_VER_ID = 2,
> +	UAP_FW_API_VER_ID = 3,
> +	CHANRPT_API_VER_ID = 4,
>  };
>  
>  struct hw_spec_api_rev {
> -- 
> 2.20.1
> 
