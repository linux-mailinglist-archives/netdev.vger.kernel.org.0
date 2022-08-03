Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A03588F7E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbiHCPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiHCPgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:36:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0792F17060;
        Wed,  3 Aug 2022 08:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B0D361719;
        Wed,  3 Aug 2022 15:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579EBC433D6;
        Wed,  3 Aug 2022 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659541011;
        bh=i38drUEUdPfEjjptdNAH2klVJmj1WMiJnFB99eG6ALI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DmnEVZbtOdB2RIRN4oTLg/UKo6LTRn+/97mP9xU+YFs04uU0nnpZ7uzzdhNrf12DK
         5cTT11ipOxIggWeNV1MTOpktzQe2sgAN9QdBtUZkebaYgoFFziqo/XB0Ek+2RZh7WK
         UD4FDLL/MNWS5I4eTgMoiKkJ7zIYMvIzJBtVXMU4NAXKOTZ3ris9RZx+GwKZmqxEWo
         wRnlTVlWbZzpYpECZlWMY5Rl063PF+Jlw0osHfBGgPl5zUt20UHhv2pjTFMeFC51az
         I/dEXsxKGODCvPIkhWBFxbEttTm0/kCGh42ylKv3GEPTPu5bgDLRGE/u1FdEqYoWZj
         uBAM6GX3leziQ==
Message-ID: <a7107bad-cb41-f612-2ff1-a67ab5830865@kernel.org>
Date:   Wed, 3 Aug 2022 09:36:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 net] geneve: fix TOS inheriting for ipv4
Content-Language: en-US
To:     Matthias May <matthias.may@westermo.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, linux-kernel@vger.kernel.org,
        jesse@nicira.com, pshelar@nicira.com, tgraf@suug.ch
References: <20220802122025.1364123-1-matthias.may@westermo.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220802122025.1364123-1-matthias.may@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/22 6:20 AM, Matthias May wrote:
> @@ -822,6 +823,7 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
>  		use_cache = false;
>  	}
>  	fl4->flowi4_tos = RT_TOS(tos);

Could make this optional with
	if (full_tos)
> +		*full_tos = tos;
>  
>  	dst_cache = (struct dst_cache *)&info->dst_cache;
>  	if (use_cache) {

...

> @@ -1137,6 +1140,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
>  {
>  	struct ip_tunnel_info *info = skb_tunnel_info(skb);
>  	struct geneve_dev *geneve = netdev_priv(dev);
> +	__u8 full_tos;
>  	__be16 sport;
>  
>  	if (ip_tunnel_info_af(info) == AF_INET) {
> @@ -1148,7 +1152,8 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
>  					  1, USHRT_MAX, true);
>  
>  		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
> -				      geneve->cfg.info.key.tp_dst, sport);
> +				      geneve->cfg.info.key.tp_dst, sport,
> +				      &full_tos);
>  		if (IS_ERR(rt))
>  			return PTR_ERR(rt);
>  

since this one is not used
