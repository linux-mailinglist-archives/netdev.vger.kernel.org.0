Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE015FC575
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJLMhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiJLMht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:37:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C2C707B;
        Wed, 12 Oct 2022 05:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JWy5RQWI5KogxEJb2DRzy4LpyNy0j033+Jo3GVosbOA=; b=Fv134si1BGJlyz8/5vUhVpOeHt
        JGZxF13SrLBknVXU4cPUZV8ynsEWqL0qnDm3KAgqOfYTJck4Mmq3Pdm/+nPsH2q23JRtCZoMm4411
        5LHiCQDf5PZOY7IMqEk2DFRRtuhwHkLp+yTeixw+IYp0HEl3omiw2fOMHHGSCtxQhSr4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiazO-001njB-Aj; Wed, 12 Oct 2022 14:37:34 +0200
Date:   Wed, 12 Oct 2022 14:37:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 2/2] net: dsa: qca8k: fix ethtool autocast mib for
 big-endian systems
Message-ID: <Y0a1Ditnr/ekKR39@lunn.ch>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <20221010111459.18958-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010111459.18958-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	struct qca8k_priv *priv = ds->priv;
>  	const struct qca8k_mib_desc *mib;
>  	struct mib_ethhdr *mib_ethhdr;
> -	int i, mib_len, offset = 0;
> -	u64 *data;
> +	__le32 *data2;
>  	u8 port;
> +	int i;
>  
>  	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
>  	mib_eth_data = &priv->mib_eth_data;
> @@ -1532,28 +1532,24 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
>  	if (port != mib_eth_data->req_port)
>  		goto exit;
>  
> -	data = mib_eth_data->data;
> +	data2 = (__le32 *)skb->data;
>  
>  	for (i = 0; i < priv->info->mib_count; i++) {
>  		mib = &ar8327_mib[i];
>  
>  		/* First 3 mib are present in the skb head */
>  		if (i < 3) {
> -			data[i] = mib_ethhdr->data[i];
> +			mib_eth_data->data[i] = le32_to_cpu(mib_ethhdr->data[i]);
>  			continue;
>  		}
>  
> -		mib_len = sizeof(uint32_t);
> -
>  		/* Some mib are 64 bit wide */
>  		if (mib->size == 2)
> -			mib_len = sizeof(uint64_t);
> -
> -		/* Copy the mib value from packet to the */
> -		memcpy(data + i, skb->data + offset, mib_len);
> +			mib_eth_data->data[i] = le64_to_cpu(*(__le64 *)data2);
> +		else
> +			mib_eth_data->data[i] = le32_to_cpu(*data2);

Are there any alignment guarantees? The old memcpy did not care if the
source has oddly alignment. But when you start dereferencing a pointed,
you need to be sure those pointers are aligned. You might want to use
get_unaligned_le32 and get_unaligned_le64.

	   Andrew
