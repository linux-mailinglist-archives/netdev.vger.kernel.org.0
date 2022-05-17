Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF3529AB3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbiEQHYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiEQHYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E26AB43EDD
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652772244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPmZqh7n7v6xlEfU9svgT+nrb4qgkvil9x7H2S2V3is=;
        b=R5LbwLM1v2O/wyr6cHm6y/aKhLsKOyVZrEVeVHAAN5oW0cjAEgbMoxVUeYLOoVlsColRYT
        NOxS491m/sw8pQFkh/40sZvp3XnMtAjZeXudz9FJu/nfFOdvEcgA3+5U4+XGMoPPNLLdlG
        6nTW3WY1q5tukt1NUKjCeFMSTLeRrPM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-KZmNyLMLNJCKJKCCJt6OJQ-1; Tue, 17 May 2022 03:24:03 -0400
X-MC-Unique: KZmNyLMLNJCKJKCCJt6OJQ-1
Received: by mail-wr1-f70.google.com with SMTP id s8-20020adfecc8000000b0020d080b6fddso921630wro.20
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nPmZqh7n7v6xlEfU9svgT+nrb4qgkvil9x7H2S2V3is=;
        b=BmE0xLQVyhynAITQRbUnXM3K+3MuRsyxV7KrsP3J4xC4JCzldImXHyMb285RDdtvBo
         2Sfv+RloLhhahLmpVWh82b5Y9WVZZHvS2+JrfHrQb2aW/gopyd4J27heUHy0wnpFaEGD
         J2o5SzBAxYQmQxIFgdXmC7k1WkqvOE+R9iN74gQOGKwScBB98ExnZmInjUlJVxuPDf1t
         puIa+OaDx/iU5r93fg3C7ZgU5LpXbyP8Js6Y8WDjR9oqogC8pYxRt7tvl4KjBzC+B+er
         BJBr3hG3Ho9WGLDAt321OIHL0kxbmvPEZA4eoQdY+1K295xA5A/EYKHING+12/TjJi2b
         dobQ==
X-Gm-Message-State: AOAM531tdSZqZFPTMNuIY72sCjvFhoqeBp+jKNl8S8uS5+gkhlKKS2rj
        soEhR0jCEZvAyLf7lcfZB3hAlKiciXuhez9jEPQkwog37Jy/0/O+4QgHAmFCQoV9txF4grAnsb6
        JPBHrH3SG8e4Xen4P
X-Received: by 2002:a05:6000:10d2:b0:20d:e9d:5277 with SMTP id b18-20020a05600010d200b0020d0e9d5277mr5082693wrx.566.1652772242202;
        Tue, 17 May 2022 00:24:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBDs4ETCGxgajGFFLtOn+r0LasjWwvsUux1X0lP4g7VKmYv7Mt5c/pf4eRy7qWJawebLbf7A==
X-Received: by 2002:a05:6000:10d2:b0:20d:e9d:5277 with SMTP id b18-20020a05600010d200b0020d0e9d5277mr5082674wrx.566.1652772241927;
        Tue, 17 May 2022 00:24:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id j25-20020adfa799000000b0020c5253d8dbsm11291674wrc.39.2022.05.17.00.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 00:24:01 -0700 (PDT)
Message-ID: <0c47e205ee226bb539ec649c5dc866301c710b9d.camel@redhat.com>
Subject: Re: [PATCH RESEND net] bonding: fix missed rcu protection
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue, 17 May 2022 09:24:00 +0200
In-Reply-To: <YoMZvrPcgIm8k2b6@Laptop-X1>
References: <20220513103350.384771-1-liuhangbin@gmail.com>
         <20220516181028.7dbbf918@kernel.org> <YoMZvrPcgIm8k2b6@Laptop-X1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 11:42 +0800, Hangbin Liu wrote:
> On Mon, May 16, 2022 at 06:10:28PM -0700, Jakub Kicinski wrote:
> > Can't ->get_ts_info sleep now? It'd be a little sad to force it 
> > to be atomic just because of one upper dev trying to be fancy.
> > Maybe all we need to do is to take a ref on the real_dev?
> 
> Do you mean
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 38e152548126..b60450211579 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5591,16 +5591,20 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  	const struct ethtool_ops *ops;
>  	struct net_device *real_dev;
>  	struct phy_device *phydev;
> +	int ret = 0;
>  

You additionally need something alike the following:

	rcu_read_lock();
>  	real_dev = bond_option_active_slave_get_rcu(bond);
>  	if (real_dev) {
> +		dev_hold(real_dev)
		rcu_read_unlock();

>  		ops = real_dev->ethtool_ops;
>  		phydev = real_dev->phydev;
>  
>  		if (phy_has_tsinfo(phydev)) {
> -			return phy_ts_info(phydev, info);
> +			ret = phy_ts_info(phydev, info);
> +			goto out;
>  		} else if (ops->get_ts_info) {
> -			return ops->get_ts_info(real_dev, info);
> +			ret = ops->get_ts_info(real_dev, info);
> +			goto out;
>  		}
	} else {
		rcu_read_unlock();
>  	}

... or you will hit the initial RCU splat. Overall this will not put
atomicy constraint on get_ts_info.

Cheers,

Paol

>  
> @@ -5608,7 +5612,10 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  				SOF_TIMESTAMPING_SOFTWARE;
>  	info->phc_index = -1;
>  
> -	return 0;
> +out:
> +	if (real_dev)
> +		dev_put(real_dev);
> +	return ret;
>  }
> 
> 
> This look OK to me.
> 
> Vladimir, Jay, WDYT?
> 
> > 
> > Also please add a Link: to the previous discussion, it'd have been
> > useful to get the context in which Vladimir suggested this.
> 
> OK, I will.
> 
> Thanks
> Hangbin
> 

