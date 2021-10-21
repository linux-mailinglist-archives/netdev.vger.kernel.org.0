Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64843621D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhJUMyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:54:37 -0400
Received: from s2.neomailbox.net ([5.148.176.60]:14371 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhJUMyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 08:54:36 -0400
Subject: Re: [PATCH net-next] gre/sit: Don't generate link-local addr if
 addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net
References: <20211020200618.467342-1-ssuryaextr@gmail.com>
From:   Antonio Quartulli <a@unstable.cc>
Message-ID: <9bd488de-f675-d879-97aa-d27948494ed1@unstable.cc>
Date:   Thu, 21 Oct 2021 14:52:44 +0200
MIME-Version: 1.0
In-Reply-To: <20211020200618.467342-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 20/10/2021 22:06, Stephen Suryaputra wrote:
> When addr_gen_mode is set to IN6_ADDR_GEN_MODE_NONE, the link-local addr
> should not be generated. But it isn't the case for GRE (as well as GRE6)
> and SIT tunnels. Make it so that tunnels consider the addr_gen_mode,
> especially for IN6_ADDR_GEN_MODE_NONE.
> 
> Do this in add_v4_addrs() to cover both GRE and SIT only if the addr
> scope is link.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  net/ipv6/addrconf.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index d4fae16deec4..9e1463a2acae 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3110,6 +3110,9 @@ static void add_v4_addrs(struct inet6_dev *idev)
>  	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
>  
>  	if (idev->dev->flags&IFF_POINTOPOINT) {
> +		if (idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_NONE)
> +			return;
> +

Maybe I am missing something, but why checking the mode only for
pointtopoint? If mode is NONE shouldn't this routine just abort
regardless of the interface setup?

Cheers,

>  		addr.s6_addr32[0] = htonl(0xfe800000);
>  		scope = IFA_LINK;
>  		plen = 64;
> 

-- 
Antonio Quartulli
