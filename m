Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211962EB3EA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbhAEUHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:07:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50716 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAEUHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:07:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwsbQ-00GEDG-2g; Tue, 05 Jan 2021 21:06:48 +0100
Date:   Tue, 5 Jan 2021 21:06:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next] net: mvneta: fix error message when MTU too
 large for XDP
Message-ID: <X/TG2G3CaDhwWMHt@lunn.ch>
References: <20210105163833.389-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210105163833.389-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 05:38:33PM +0100, Marek Behún wrote:
> The error message says that "Jumbo frames are not supported on XDP", but
> the code checks for mtu > MVNETA_MAX_RX_BUF_SIZE, not mtu > 1500.
> 
> Fix this error message.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 563ceac3060f..8adbfa25465d 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4432,7 +4432,7 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
>  	struct bpf_prog *old_prog;
>  
>  	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> -		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> +		NL_SET_ERR_MSG_MOD(extack, "XDP is not supported with MTU > %d", dev->mtu);
>  		return -EOPNOTSUPP;

Hi Marek

In addition to the OMG, don't you actually want to print
MVNETA_MAX_RX_BUF_SIZE, not the dev->mtu?

			Andrew
