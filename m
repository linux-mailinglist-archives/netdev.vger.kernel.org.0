Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F075A39AC
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 21:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiH0TMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 15:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiH0TMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 15:12:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6484DF14E7;
        Sat, 27 Aug 2022 12:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CRZqPZ0CsJnbLBgq0fHZrQhxCISGhcMs7TmVXtYQckM=; b=WyrT+VxxQPukJxBRdRmbYAgwsg
        gCgQRmHiKVN7qyRTKGAw+U9pPBNxKQOQ7DmbjyrTgO+fEn2+ix1FgdWzqFQFkUIiivoH0JEW2GYu1
        s8gZcmuMKuuros8c4c2UFAZnLivSPW3D6883DaeamrtIChVB4JR4rOYA4I+3I6sNHfk8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oS1Dx-00EnYY-O0; Sat, 27 Aug 2022 21:12:05 +0200
Date:   Sat, 27 Aug 2022 21:12:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 3/5] net: ipqess: Add out-of-band DSA tagging
 support
Message-ID: <Ywpshc/9+8T0W5Zj@lunn.ch>
References: <20220826154650.615582-1-maxime.chevallier@bootlin.com>
 <20220826154650.615582-4-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826154650.615582-4-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -409,6 +412,12 @@ static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
>  			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD),
>  					       rd->rrd4);
>  
> +		if (netdev_uses_dsa(rx_ring->ess->netdev)) {
> +			tag_info.dp = FIELD_GET(IPQESS_RRD_PORT_ID_MASK, rd->rrd1);
> +			tag_info.proto = DSA_TAG_PROTO_OOB;
> +			dsa_oob_tag_push(skb, &tag_info);
> +		}
> +
>  		napi_gro_receive(&rx_ring->napi_rx, skb);
>  
>  		rx_ring->ess->stats.rx_packets++;
> @@ -713,6 +722,22 @@ static void ipqess_rollback_tx(struct ipqess *eth,
>  	tx_ring->head = start_index;
>  }
>  
> +static void ipqess_process_dsa_tag_sh(struct ipqess *ess, struct sk_buff *skb,
> +				      u32 *word3)
> +{
> +	struct dsa_oob_tag_info tag_info;
> +
> +	if (!netdev_uses_dsa(ess->netdev))
> +		return;
> +
> +	if (dsa_oob_tag_pop(skb, &tag_info))
> +		return;
> +
> +	*word3 |= tag_info.dp << IPQESS_TPD_PORT_BITMAP_SHIFT;
> +	*word3 |= BIT(IPQESS_TPD_FROM_CPU_SHIFT);
> +	*word3 |= 0x3e << IPQESS_TPD_PORT_BITMAP_SHIFT;
> +}

Using netdev_uses_dsa() here will work, but you are on the fast
path. You are following a lot of pointers, which could be bad on the
cache. You might want to consider caching this as a bool in struct
ipqess. Maybe update the cache on NETDEV_CHANGEUPPER?

	Andrew
