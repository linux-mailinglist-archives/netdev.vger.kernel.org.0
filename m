Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385FA3684C3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhDVQ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232670AbhDVQ0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 12:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2BC61417;
        Thu, 22 Apr 2021 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619108769;
        bh=I2WaeiJyXXVput4O2vCSGgTUD62VIg+b5/9OZeNer4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ddbkm6nULFik6lQwyUg+f/HHVor/75WN2z3nfh4Oo6zHjiWZxu5/VAtCyW0ZGJKSJ
         LF/ux71hVBLC17FtLb/EmvHw9zQ86i6Ut0OztUwIODFKyTMcs60pwj7LU7M6JGbnI1
         z0y/Tl3WJESFarWx6KK2gVHPlYO6xI7a2dwEkc3wapcCL0pcj4w2guHsKvRQ0mn/oS
         jNT+pMOdh/CH1RfeQXiWCuD5R5bYhssn96MvoR699jvn23c256fBLaReArtohsEOPS
         cwAnXiPoxL1iqmCt7LuL2gMHZP0iJ/LYMOPJJWwsisXxcZqIFcGB6I7jdrNdLFFyF3
         5MaLju2cAyIXQ==
Date:   Thu, 22 Apr 2021 09:26:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 12/14] net: ethernet: mtk_eth_soc: reduce
 unnecessary interrupts
Message-ID: <20210422092608.6b8ed5ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210422040914.47788-13-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
        <20210422040914.47788-13-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 21:09:12 -0700 Ilya Lipnitskiy wrote:
> @@ -1551,8 +1551,9 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
>  		remain_budget -= rx_done;
>  		goto poll_again;
>  	}
> -	napi_complete(napi);
> -	mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
> +
> +	if (napi_complete(napi))
> +		mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);

Why not napi_complete_done(napi, rx_done + budget - remain_budget)?
(Modulo possible elimination of rx_done in this function.)
