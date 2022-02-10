Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363114B0858
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiBJIbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:31:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbiBJIbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:31:50 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B63A115C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:31:47 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id ch26so9494568edb.12
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5HYctMBlbUcF9ELod876PiSjtl+wZnwlHpBP7i180qk=;
        b=4W/BEEtH+1u66zjUlg4i2buOw0kWN7KslsuQrXrs1aoBF7XRoS/XyLbdULBOvzjoMT
         ins3ef8qYhlshV9+4JrVgxpTcOlD1Z8rw4ZqH1UnEqKnW+PcD52kneTOgDNX16W7F+2V
         XH4xaYi8qs3mcZHKcJKRSceaMVlzwlt1WKtb5wGZ2lL08nvwFNxHQ/sfhy3ZKmHp/Gzt
         DUh2dZ2EuIsFdZDYNYd61JGy5o8fGmHq93ganHtWDC0PfyCKdoakDFNlr8JWE6kBXh41
         Ha9b5YRx+36+UFJsKwrEOuYDyzxtZC404qHuszZ6tuxQgrhmtd55868dn+z1HZLd+2Eq
         t81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5HYctMBlbUcF9ELod876PiSjtl+wZnwlHpBP7i180qk=;
        b=txpw91y9iDguhL+BsAbqgAzbGFD/a8qIDLPnaI0TaL/JbOcUmFs3XEReKX4OdHwuai
         UkCJESyXMJHaE3jZ1PmvhbfMUjOpBKUSHh5akZb7AMLxJqkTP/0lPdIH9WgrdUmQlBCp
         0ksD0f2Dig/PNdU5Tyk9wl6my5rA4xxPNfnsVrZ+0LD7n2DGkjBFHpGRXg1mCpdQrFte
         18lpXphv/FQFKicBn3yEDRt8rM1vFDvxr/7CjcUB4Mc2htIfE7MYLVwIFRV+t96bmJoa
         G3TjNuUpD1gA0oTIlGGjoGJV1dnDE0PIZ2GIRmumVpTDKK2leu2lZfGp4Bm1ljStta6R
         UOyw==
X-Gm-Message-State: AOAM530TT7lz20UkcuuRGaOF2lIcim6OJZhTSG3eut1mQTVKfAKsYUJ7
        JwMmVCq3QSGHES8mgWCOApblLw==
X-Google-Smtp-Source: ABdhPJwkXWdDIgFnjmrqo4fAjO79Uexv7RWGiFdCHB/qPMBgT6O3kyw4f4gWUqmqti/XKFNiaJkzog==
X-Received: by 2002:a05:6402:2691:: with SMTP id w17mr7107853edd.126.1644481905658;
        Thu, 10 Feb 2022 00:31:45 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id gq1sm5882254ejb.58.2022.02.10.00.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 00:31:45 -0800 (PST)
Message-ID: <fed43e8d-de8c-aa76-1451-877cf4cc76d2@blackwall.org>
Date:   Thu, 10 Feb 2022 10:31:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 5/5] net: bridge: Refactor bridge port in
 locked mode to use jump labels
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <schultz.hans+lkml@gmail.com>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <20220209130538.533699-6-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220209130538.533699-6-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 15:05, Hans Schultz wrote:
> From: Hans Schultz <schultz.hans+lkml@gmail.com>
> 
> As the locked mode feature is in the hot path of the bridge modules
> reception of packets, it needs to be refactored to use jump labels
> for optimization.
> 
> Signed-off-by: Hans Schultz <schultz.hans+lkml@gmail.com>
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---

Why two (almost) identical sign-offs?

Also, as Ido mentioned, please fold this patch into patch 01.

>  net/bridge/br_input.c   | 22 ++++++++++++++++++----
>  net/bridge/br_netlink.c |  6 ++++++
>  net/bridge/br_private.h |  2 ++
>  3 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 469e3adbce07..6fc428d6bac5 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -23,6 +23,18 @@
>  #include "br_private.h"
>  #include "br_private_tunnel.h"
>  
> +static struct static_key_false br_input_locked_port_feature;
> +
> +void br_input_locked_port_add(void)
> +{
> +	static_branch_inc(&br_input_locked_port_feature);
> +}
> +
> +void br_input_locked_port_remove(void)
> +{
> +	static_branch_dec(&br_input_locked_port_feature);
> +}
> +
>  static int
>  br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> @@ -91,10 +103,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  				&state, &vlan))
>  		goto out;
>  
> -	if (p->flags & BR_PORT_LOCKED) {
> -		fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> -		if (!(fdb_entry && fdb_entry->dst == p))
> -			goto drop;
> +	if (static_branch_unlikely(&br_input_locked_port_feature)) {
> +		if (p->flags & BR_PORT_LOCKED) {
> +			fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> +			if (!(fdb_entry && fdb_entry->dst == p))
> +				goto drop;
> +		}
>  	}
>  
>  	nbp_switchdev_frame_mark(p, skb);
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 7d4432ca9a20..e3dbe9fed75c 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -860,6 +860,7 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
>  static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
>  			     int attrtype, unsigned long mask)
>  {
> +	bool locked = p->flags & BR_PORT_LOCKED;
>  	if (!tb[attrtype])
>  		return;
>  
> @@ -867,6 +868,11 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
>  		p->flags |= mask;
>  	else
>  		p->flags &= ~mask;
> +
> +	if ((p->flags & BR_PORT_LOCKED) && !locked)
> +		br_input_locked_port_add();
> +	if (!(p->flags & BR_PORT_LOCKED) && locked)
> +		br_input_locked_port_remove();
>  }
>  
>  /* Process bridge protocol info on port */
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2661dda1a92b..0ec3ef897978 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -832,6 +832,8 @@ void br_manage_promisc(struct net_bridge *br);
>  int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
>  
>  /* br_input.c */
> +void br_input_locked_port_add(void);
> +void br_input_locked_port_remove(void);
>  int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
>  rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
>  

