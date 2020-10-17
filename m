Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C329148F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439424AbgJQVCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:02:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439411AbgJQVCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:02:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTtLX-002C1Q-Hv; Sat, 17 Oct 2020 23:02:35 +0200
Date:   Sat, 17 Oct 2020 23:02:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] staging: octeon: Drop on uncorrectable alignment
 or FCS error
Message-ID: <20201017210235.GU456889@lunn.ch>
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
 <20201016101858.11374-2-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016101858.11374-2-alexander.sverdlin@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index 2c16230..9ebd665 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -69,15 +69,17 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
>  	else
>  		port = work->word1.cn38xx.ipprt;
>  
> -	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
> +	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))

It would be nice to replace all these err_code magic numbers with #defines.

You should also replace 64 with ETH_ZLEN + ETH_FCS_LEN. I also wonder
if <= should be just < ?

>  		/*
>  		 * Ignore length errors on min size packets. Some
>  		 * equipment incorrectly pads packets to 64+4FCS
>  		 * instead of 60+4FCS.  Note these packets still get
>  		 * counted as frame errors.
>  		 */
> -	} else if (work->word2.snoip.err_code == 5 ||
> -		   work->word2.snoip.err_code == 7) {
> +		return 0;
> +
> +	if (work->word2.snoip.err_code == 5 ||
> +	    work->word2.snoip.err_code == 7) {
>  		/*
>  		 * We received a packet with either an alignment error
>  		 * or a FCS error. This may be signalling that we are
> @@ -108,7 +110,10 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
>  				/* Port received 0xd5 preamble */
>  				work->packet_ptr.s.addr += i + 1;
>  				work->word1.len -= i + 5;
> -			} else if ((*ptr & 0xf) == 0xd) {
> +				return 0;
> +			}
> +
> +			if ((*ptr & 0xf) == 0xd) {

The comments are not so clear what is going on here. Can this
incorrectly match a destination MAC address of xD:XX:XX:XX:XX:XX.

>  				/* Port received 0xd preamble */
>  				work->packet_ptr.s.addr += i;
>  				work->word1.len -= i + 4;

	Andrew
