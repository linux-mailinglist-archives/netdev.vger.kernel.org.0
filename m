Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BAA5FE8D5
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJNGSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiJNGSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:18:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0F31BB96B
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 23:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A07D5B82213
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97643C4347C;
        Fri, 14 Oct 2022 06:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665728221;
        bh=UMtPUk7Rm58CovtFtLXEBhBJ4JPVwQ+YShAY+I+0b1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOw17Ur9cVKRhFKchMbNzbXViccidojux6dwSi9xEfqmX741EjjVfymEUTJ58EMsD
         OMo0I5En7ELYnRqu5yqNX0ixw7ZBOVbCFQE8tzZip4XyPG3mQ9EZtbscjT3F60/04t
         6XgfUXIJ+mouuWn2quOfCB+zQUeYwaV4fti4L6bqkJ69lzB+T+W4JPeM/S5xu822V3
         dWJmK3dKYfTF4eY6M2NnKzVqGVOvqJ0U74pve8x4FLZP5afkgkXxFOPUH2Chao3wru
         o+4LK7enGJSQKau+L5LljfopaFwrK7Hlu7FbuOEMDJpe7wvmiz48Mj2NR8+vDzpiu1
         mYs0V6K2e0hAw==
Date:   Fri, 14 Oct 2022 09:16:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 3/5] macsec: fix secy->n_rx_sc accounting
Message-ID: <Y0j+2J2uBqrhqRtg@unreal>
References: <cover.1665416630.git.sd@queasysnail.net>
 <1879f6c8a7fcb5d7bb58ffb3d9fed26c8d7ec5cb.1665416630.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1879f6c8a7fcb5d7bb58ffb3d9fed26c8d7ec5cb.1665416630.git.sd@queasysnail.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 04:15:41PM +0200, Sabrina Dubroca wrote:
> secy->n_rx_sc is supposed to be the number of _active_ rxsc's within a
> secy. This is then used by macsec_send_sci to help decide if we should
> add the SCI to the header or not.
> 
> This logic is currently broken when we create a new RXSC and turn it
> off at creation, as create_rx_sc always sets ->active to true (and
> immediately uses that to increment n_rx_sc), and only later
> macsec_add_rxsc sets rx_sc->active.
> 
> Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  drivers/net/macsec.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 0d6fe34b91ae..cdee342e42cd 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -1413,7 +1413,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
>  	return NULL;
>  }
>  
> -static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
> +static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
> +					 bool active)
>  {
>  	struct macsec_rx_sc *rx_sc;
>  	struct macsec_dev *macsec;
> @@ -1437,7 +1438,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
>  	}
>  
>  	rx_sc->sci = sci;
> -	rx_sc->active = true;
> +	rx_sc->active = active;
>  	refcount_set(&rx_sc->refcnt, 1);
>  
>  	secy = &macsec_priv(dev)->secy;
> @@ -1876,6 +1877,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
>  	struct macsec_rx_sc *rx_sc;
>  	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
>  	struct macsec_secy *secy;
> +	bool active = true;
>  	int ret;
>  
>  	if (!attrs[MACSEC_ATTR_IFINDEX])
> @@ -1897,15 +1899,16 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
>  	secy = &macsec_priv(dev)->secy;
>  	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
>  
> -	rx_sc = create_rx_sc(dev, sci);
> +
> +	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
> +		active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);

You don't need !! to assign to bool variables and can safely omit them.

thanks

> +
> +	rx_sc = create_rx_sc(dev, sci, active);
>  	if (IS_ERR(rx_sc)) {
>  		rtnl_unlock();
>  		return PTR_ERR(rx_sc);
>  	}
>  
> -	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
> -		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
> -
>  	if (macsec_is_offloaded(netdev_priv(dev))) {
>  		const struct macsec_ops *ops;
>  		struct macsec_context ctx;
> -- 
> 2.38.0
> 
