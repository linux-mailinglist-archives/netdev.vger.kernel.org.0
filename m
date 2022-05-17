Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF0B5298D8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiEQEhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 00:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiEQEhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 00:37:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668553AA52;
        Mon, 16 May 2022 21:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20948B80936;
        Tue, 17 May 2022 04:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B89C385B8;
        Tue, 17 May 2022 04:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652762220;
        bh=yqrFLKUyZSPOO62w2yYncUxQ/cjrWKNlIzELs9lP7vU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VDAy7fAWds24lPLb33S5Yc7u8cbzgx/sP436FkaTD/doVNGCTiN2ze8/iSqxGwMUX
         E3cc5xpta8piTbowEu9yvT5faQyKGaak7U9AbyPF4E2AcmsGsp1Mklshsy2Em7eg1M
         0tJ2+bM4wuodmpwGiKLlhIimlQFBWgdjTt9R2xhNUke0NOvckVBrBiRMGKG480D5P5
         CZPc3kmtaKu9HR9pCgHF0b9JupiwO+PWUEHkW0u/uCYofeqqzlnAQ+WBN/jSqp+6Dv
         Khwt6AAPY0+rPaLLTdhhtkoaBrKcX9WTwbCP92aeGBNO3XdgefXAjkss9bPwyvONq+
         ucqy1S7HlEadg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct net_device
References: <20220516215638.1787257-1-kuba@kernel.org>
Date:   Tue, 17 May 2022 07:36:54 +0300
In-Reply-To: <20220516215638.1787257-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Mon, 16 May 2022 14:56:38 -0700")
Message-ID: <87zgjgwza1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Most protocol-specific pointers in struct net_device are under
> a respective ifdef. Wireless is the notable exception. Since
> there's a sizable number of custom-built kernels for datacenter
> workloads which don't build wireless it seems reasonable to
> ifdefy those pointers as well.
>
> While at it move IPv4 and IPv6 pointers up, those are special
> for obvious reasons.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: johannes@sipsolutions.net
> CC: alex.aring@gmail.com
> CC: stefan@datenfreihafen.org
> CC: mareklindner@neomailbox.ch
> CC: sw@simonwunderlich.de
> CC: a@unstable.cc
> CC: sven@narfation.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-wpan@vger.kernel.org

[...]

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -8004,10 +8004,7 @@ int cfg80211_register_netdevice(struct net_device *dev);
>   *
>   * Requires the RTNL and wiphy mutex to be held.
>   */
> -static inline void cfg80211_unregister_netdevice(struct net_device *dev)
> -{
> -	cfg80211_unregister_wdev(dev->ieee80211_ptr);
> -}
> +void cfg80211_unregister_netdevice(struct net_device *dev);
>  
>  /**
>   * struct cfg80211_ft_event_params - FT Information Elements

[...]

> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -1374,6 +1374,12 @@ int cfg80211_register_netdevice(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(cfg80211_register_netdevice);
>  
> +void cfg80211_unregister_netdevice(struct net_device *dev)
> +{
> +	cfg80211_unregister_wdev(dev->ieee80211_ptr);
> +}
> +EXPORT_SYMBOL(cfg80211_unregister_netdevice);

Why moving this to a proper function? Just curious, I couldn't figure it
out.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
