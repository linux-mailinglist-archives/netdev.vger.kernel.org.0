Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795BE4F9719
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiDHNon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 09:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiDHNol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 09:44:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D786CFB91
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 06:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S7aWQ5gHiHgXuRxe1LKdHP6Sqbq1a2WnawhEN3X3FD8=; b=jwdj4Uz3QnPpSgXdMNGH3d1IdA
        5XJwe6cpbv2p66OfvsEw2DxaCPccS+z1s6z+5NVd5EdQ0knBda4ZJHMSNzbKHPAlJhYGqdqYZDg/r
        aurV+NeViPzVHZBebJQcDl4jNeEPb6wDKUhPalqARjixAINug1cL4XyvxRjrorLjnoC4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncosj-00Epql-VO; Fri, 08 Apr 2022 15:42:33 +0200
Date:   Fri, 8 Apr 2022 15:42:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH v2 net-next 2/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <YlA7yQ0NZi94ob/Q@lunn.ch>
References: <cover.1649405981.git.lorenzo@kernel.org>
 <86f4e67f3f2eaf13e588b4989b364b1616b5fcad.1649405981.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86f4e67f3f2eaf13e588b4989b364b1616b5fcad.1649405981.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -4732,9 +4732,13 @@ static void mvneta_ethtool_get_strings(struct net_device *netdev, u32 sset,
>  	if (sset == ETH_SS_STATS) {
>  		int i;
>  
> -		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++)
> -			memcpy(data + i * ETH_GSTRING_LEN,
> -			       mvneta_statistics[i].name, ETH_GSTRING_LEN);
> +		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++) {
> +			memcpy(data, mvneta_statistics[i].name,
> +			       ETH_GSTRING_LEN);
> +			data += ETH_GSTRING_LEN;
> +		}

You don't need to touch this loop, you can just do:

> +
> +		page_pool_ethtool_stats_get_strings(data +
				ETH_GSTRING_LEN * ARRAY_SIZE(mvneta_staticstics)));
>  	}
>  }
>  
> @@ -5392,6 +5412,14 @@ static int mvneta_probe(struct platform_device *pdev)
>  	pp->rxq_def = rxq_def;
>  	pp->indir[0] = rxq_def;
>  
> +	stats_len = ARRAY_SIZE(mvneta_statistics) +
> +		    page_pool_ethtool_stats_get_count();
> +	pp->ethtool_stats = devm_kzalloc(&pdev->dev,
> +					 sizeof(*pp->ethtool_stats) * stats_len,
> +					 GFP_KERNEL);

Why do you do this? The page_pool stats are never stored in
pp->ethtool_stats.

	Andrew
