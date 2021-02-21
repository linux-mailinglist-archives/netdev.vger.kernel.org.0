Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2B83208FD
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 07:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBUGwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 01:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhBUGwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 01:52:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D0F64F02;
        Sun, 21 Feb 2021 06:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613890289;
        bh=6tU+OEyIZ9Q0azKSBcpf+eNh2D54XEvVY+pvHyOOAHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ouT1MBHATkEFsCXgb4IX0Df802ldGF4zkZSF3ogUZKPLcOZEIwMODccmEX2pWfMcL
         Aq8EQozhq7ku6niXNMVwoH8x2OEtIgvijsaEp/EvMMrMN4blFUJbVZ5ySnczEtauiK
         56REhO/2b8Y8j00dVUziABZV2QudvUw8cGuj+NCXYVT1c7Nla/iJ9Jb4eJbJ1e7Uvt
         AKG2KxcR1ltY02gkXSmmOdin7fF46t+sOuDpVRTqXFxcqpILUCeXa3t+G27+B84/BQ
         Ewr4hjU8ZKu4J9ytlPNs9mt1HEKylZSViRZg0OU9TrmkCqwwlDW3EDsZiZOJ632YKR
         2w0vs2BWfVxDw==
Date:   Sun, 21 Feb 2021 08:51:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR
 laptop
Message-ID: <YDIC7RGqq5sFA0pG@unreal>
References: <20210220084602.22386-1-chenhaoa@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220084602.22386-1-chenhaoa@uniontech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 04:46:02PM +0800, Hao Chen wrote:
> When the laptop HONOR MagicBook 14 sleep to S3/S4, the laptop can't
> resume.
> The dmesg of kernel report:
> "[   99.990168] pcieport 0000:00:01.2: can't change power state
> from D3hot to D0 (config space inaccessible)
> [   99.993334] rtw_pci 0000:01:00.0: can't change power state
> from D3hot to D0 (config space inaccessible)
> [  104.435004] rtw_pci 0000:01:00.0: mac power on failed
> [  104.435010] rtw_pci 0000:01:00.0: failed to power on mac"
> When try to pointer the driver.pm to NULL, the problem is fixed.
> This driver hasn't implemented pm ops yet.It makes the sleep and
> wake procedure expected when pm's ops not NULL.
>
> Fixed: commit e3037485c68e ("rtw88: new Realtek 802.11ac driver")
>
> Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
> index 3845b1333dc3..b4c6762ba7ac 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
> @@ -25,7 +25,7 @@ static struct pci_driver rtw_8822ce_driver = {
>  	.id_table = rtw_8822ce_id_table,
>  	.probe = rtw_pci_probe,
>  	.remove = rtw_pci_remove,
> -	.driver.pm = &rtw_pm_ops,
> +	.driver.pm = NULL,

The NULL is the default, it is enough to delete ".driver.pm = &rtw_pm_ops," line.

Thanks

>  	.shutdown = rtw_pci_shutdown,
>  };
>  module_pci_driver(rtw_8822ce_driver);
> --
> 2.20.1
>
>
>
