Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40932D0C7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhCDKcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:32:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40693 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbhCDKbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:31:48 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lHlG5-0007eB-6j; Thu, 04 Mar 2021 10:31:05 +0000
Subject: Re: [PATCH net] net: mscc: ocelot: properly reject destination IP
 keys in VCAP IS1
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210304102943.865874-1-olteanv@gmail.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <1944c377-6397-0396-9089-5a3c9136daca@canonical.com>
Date:   Thu, 4 Mar 2021 10:31:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210304102943.865874-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/03/2021 10:29, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> An attempt is made to warn the user about the fact that VCAP IS1 cannot
> offload keys matching on destination IP (at least given the current half
> key format), but sadly that warning fails miserably in practice, due to
> the fact that it operates on an uninitialized "match" variable. We must
> first decode the keys from the flow rule.
> 
> Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_flower.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index c3ac026f6aea..a41b458b1b3e 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -540,13 +540,14 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
>  			return -EOPNOTSUPP;
>  		}
>  
> +		flow_rule_match_ipv4_addrs(rule, &match);
> +
>  		if (filter->block_id == VCAP_IS1 && *(u32 *)&match.mask->dst) {
>  			NL_SET_ERR_MSG_MOD(extack,
>  					   "Key type S1_NORMAL cannot match on destination IP");
>  			return -EOPNOTSUPP;
>  		}
>  
> -		flow_rule_match_ipv4_addrs(rule, &match);
>  		tmp = &filter->key.ipv4.sip.value.addr[0];
>  		memcpy(tmp, &match.key->src, 4);
>  
> 

Thanks, looks good to me.

Reviewed-by: Colin Ian King <colin.king@canonical.com>
