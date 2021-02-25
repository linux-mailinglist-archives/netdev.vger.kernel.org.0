Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48576325510
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhBYSBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233755AbhBYR7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 12:59:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F73964DE8;
        Thu, 25 Feb 2021 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614275918;
        bh=kkEUBtk21fzvQ+eByMWisdjrqhC+DKiVgrkLgH0ss/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ev8I77FFegc2EdWHko9oWR26IKdMF6+y2de4p0n8wL3eoj2h3N3kPlco84vQb4Ua2
         I/ND8Raybh6OjAgIDKQwYtn4/Rub1R8ufc/dK8Yhrhii8kQVKhbB+YzPyhAYxCALSR
         EKpalFu3yn6QUgcNqEa/yQAZ4LJQt/nzdNd/6GOnq0xGbP/r06vVf56CG1LtWR8I/n
         cx3rE5IpLMAQOe+tYk/kI+BcNjTfj50Wolh+y2bxxyIaM+ZQ/tXDyJQfR/yc25JENz
         +//LzlT/UmhktjLycSIn5K0hWtTI6pq4vw2kQL39hWP/iBJjT4qCw1jmRXDKnK24eR
         PyUCV6l4hRGzw==
Date:   Thu, 25 Feb 2021 10:58:36 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 1/2] mt76: mt7915: fix unused 'mode' variable
Message-ID: <20210225175836.GA23011@24bbad8f3778>
References: <20210225145953.404859-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225145953.404859-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:59:14PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out a possible corner case in the mt7915_tm_set_tx_cont()
> function if called with invalid arguments:
> 
> drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:593:2: warning: variable 'mode' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:597:13: note: uninitialized use occurs here
>         rateval =  mode << 6 | rate_idx;
>                    ^~~~
> drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:506:37: note: initialize the variable 'mode' to silence this warning
>         u8 rate_idx = td->tx_rate_idx, mode;
>                                            ^
> 
> Change it to return an error instead of continuing with invalid data
> here.
> 
> Fixes: 3f0caa3cbf94 ("mt76: mt7915: add support for continuous tx in testmode")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7915/testmode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
> index 7fb2170a9561..aa629e1fb420 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
> @@ -543,6 +543,7 @@ mt7915_tm_set_tx_cont(struct mt7915_phy *phy, bool en)
>  		tx_cont->bw = CMD_CBW_20MHZ;
>  		break;
>  	default:
> +		return -EINVAL;

Remove the break if we are adding a return?

>  		break;
>  	}
>  
> @@ -591,6 +592,7 @@ mt7915_tm_set_tx_cont(struct mt7915_phy *phy, bool en)
>  		mode = MT_PHY_TYPE_HE_MU;
>  		break;
>  	default:
> +		return -EINVAL;
>  		break;
>  	}
>  
> -- 
> 2.29.2
> 
