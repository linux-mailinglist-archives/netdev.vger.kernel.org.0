Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735C931A00A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 14:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhBLNqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 08:46:21 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:8976 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhBLNqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 08:46:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1613137404;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
        From:Subject:Sender;
        bh=cFngUOkMDTZTgpB2woZWXYAVjS51UVB8L4YFZrHc25E=;
        b=erYAPKbBBi+Zuqxv5pnEZ+3nNNwM9P+PtyyZ6/+wnLwIn1iLFw00m5XKpn9EP2wU1j
        cU0wqqCwhXK7C1slGh+7pAhg+ApRPJJR9tbqnVnWN5/WVS2m+Z4Gd48ybwNe4mlpmXgA
        hNY0tSlQVV1trZ6bUQIsXF8OWM6LwjL3Tp2iSWodrdtMttU3K8rNx6JTeuuWhD0X2eVc
        4x8kWQtmiSgUymgezWD6bhZSBBQhQUvvMzjlfHqDoFr0UiisLjGOIA5gO7XAbbzU+xrc
        e3CdN9kk99zpunbmjSabCxp22u3XPHN72UqxKMOsqthYm7c1P2ELp39oVnS9MOEC0YhM
        vN5w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR8J8xpw10="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.17.1 DYNA|AUTH)
        with ESMTPSA id J0aa2dx1CDhCAKs
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 12 Feb 2021 14:43:12 +0100 (CET)
Subject: Re: [RFC PATCH net v2] net: introduce CAN specific pointer in the
 struct net_device
To:     Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210212125203.4901-1-o.rempel@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <baf26519-18d7-f3be-a5a6-4f89f8b102ce@hartkopp.net>
Date:   Fri, 12 Feb 2021 14:43:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212125203.4901-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oleksij,

nice cleanup - and I like the removal of the notifier in af_can.c :-)

Two questions/hints from my side:

On 12.02.21 13:52, Oleksij Rempel wrote:

> diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
> index d9281ae853f8..912401788d93 100644
> --- a/drivers/net/can/dev/dev.c
> +++ b/drivers/net/can/dev/dev.c
> @@ -239,6 +239,7 @@ void can_setup(struct net_device *dev)
>   struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
>   				    unsigned int txqs, unsigned int rxqs)
>   {
> +	struct can_ml_priv *can;

This should not be named 'can' but e.g. 'can_ml'.

'can' is already used for the struct netns_can:

$ git grep netns_can
include/net/net_namespace.h:    struct netns_can        can;
include/net/netns/can.h:struct netns_can {

which is also used in af_can.c and will create some naming confusion.

Maybe the latter could be renamed to can_ns too (later).

But 'can' alone does not tell what the variable is about IMO.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index bfadf3b82f9c..9a4c6d14098c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1584,6 +1584,16 @@ enum netdev_priv_flags {
>   #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
>   #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
>   
> +/**
> + * enum netdev_ml_priv_type - &struct net_device ml_priv_type
> + *
> + * This enum specifies the type of the struct net_device::ml_priv pointer.
> + */
> +enum netdev_ml_priv_type {
> +	ML_PRIV_NONE,
> +	ML_PRIV_CAN,
> +};
> +
>   /**
>    *	struct net_device - The DEVICE structure.
>    *
> @@ -1779,6 +1789,7 @@ enum netdev_priv_flags {
>    * 	@nd_net:		Network namespace this network device is inside
>    *
>    * 	@ml_priv:	Mid-layer private
> +	@ml_priv_type:  Mid-layer private type
>    * 	@lstats:	Loopback statistics
>    * 	@tstats:	Tunnel statistics
>    * 	@dstats:	Dummy statistics
> @@ -2100,6 +2111,7 @@ struct net_device {
>   		struct pcpu_sw_netstats __percpu	*tstats;
>   		struct pcpu_dstats __percpu		*dstats;
>   	};
> +	enum netdev_ml_priv_type	ml_priv_type;

I wonder if it makes more sense to *remove* ml_priv from this union in 
include/linux/netdevice.h and just put it behind the union:

/* mid-layer private */
union {
         void *ml_priv;
         struct pcpu_lstats __percpu *lstats;
         struct pcpu_sw_netstats __percpu *tstats;
         struct pcpu_dstats __percpu *dstats;
};

When doing git grep for ml_priv a bunch of users shows up - which all 
have nothing to do with statistics.

I just looks fishy to combine things into a union that have a completely 
different purpose - and we might finally run into similar problems like 
today.

Best regards,
Oliver

