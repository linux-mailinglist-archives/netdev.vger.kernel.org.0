Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799325F102E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiI3QnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiI3QnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443971879F1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664556178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i/Hi2H2QkXwsrhZWS4QrafWlR40mZ8RNk8o6d3aH3Lk=;
        b=a0BMdPr8lQqO3BxNn091FJAZLgmgEoCzgqUhcX/I/iiCQYd2g2qG1USAV1768zXxZdMF8/
        ug7j/x5HAkge8ajUVv4ftnE3+A1pUrhQAZMXEgMMIPVLrCNWRr5TWE3A7AFu4raw9LcbBu
        SgFScyPGfuziDCPuyetggrlhIDri2OQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-3wSyLbMSOCKt6QxhL6-g2A-1; Fri, 30 Sep 2022 12:42:57 -0400
X-MC-Unique: 3wSyLbMSOCKt6QxhL6-g2A-1
Received: by mail-wm1-f71.google.com with SMTP id g8-20020a05600c4ec800b003b4bcbdb63cso2298958wmq.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=i/Hi2H2QkXwsrhZWS4QrafWlR40mZ8RNk8o6d3aH3Lk=;
        b=5BXSqUyLxOnDGRK7RXVZPUz4Dt6AepE/MFcY9F4YwxHW/zyjmRGBKaE8OG8+Il5wJ5
         eCTxga0zMgzFJVNY76BO1mUZnv/Uft1ebGsV8m7tizOlrEnuigwEtCmx8/fe4oSQ0AVo
         /797w3k0N0nRkEu2xArq4+BCbQkWh+3nfm5dbOaGXLDcAefPgGQy+5L3xoKyR/7YCt5J
         uSWTBd3apTkb1bVzsnU5tubrNgs6DSCSFkHtMQzESBzRR9cIfncsJz+1St3dVuLv4m3M
         40Gg2m2IgKGDDYmsBeIpKiQvvbg1L99enEhRjlrWFpoItnXHy4aosIGyiZHhCqrftKRn
         nWRQ==
X-Gm-Message-State: ACrzQf34AnE3B+DgxEBQRPGkcVLi9LG9m9KMRIMY4/U3C/6spiJJvAYr
        rjuxmSWsm0xHsjqAs+rbWkBg8qF8ORAExJzD5GusssEYaaWrbmQAlDFQHJVZom9pLmDsZpDNDdE
        yo6GJhWpSdluLtnU2
X-Received: by 2002:adf:c583:0:b0:22c:df60:dfda with SMTP id m3-20020adfc583000000b0022cdf60dfdamr3695519wrg.499.1664556174835;
        Fri, 30 Sep 2022 09:42:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ViJCNAm6ede/BGwwKgwOiMQbLpDU0b7QKSl2NIYaWzj0vdaFJI4vBNqrmewebA8ok7f62gA==
X-Received: by 2002:adf:c583:0:b0:22c:df60:dfda with SMTP id m3-20020adfc583000000b0022cdf60dfdamr3695508wrg.499.1664556174664;
        Fri, 30 Sep 2022 09:42:54 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id x12-20020a05600c2d0c00b003b51369fbbbsm7659352wmf.4.2022.09.30.09.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:42:54 -0700 (PDT)
Date:   Fri, 30 Sep 2022 18:42:51 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 3/4] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_newlink_create
Message-ID: <20220930164251.GG10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-4-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930094506.712538-4-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 05:45:05PM +0800, Hangbin Liu wrote:
> This patch use the new helper rtnl_configure_link_notify() for
> rtnl_newlink_create(), so that the kernel could reply unicast
> when userspace set NLM_F_ECHO flag to request the new created
> interface info.
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/core/rtnetlink.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1558921bd4da..da9a6fd156d8 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3318,10 +3318,12 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
>  static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  			       const struct rtnl_link_ops *ops,
>  			       struct nlattr **tb, struct nlattr **data,
> -			       struct netlink_ext_ack *extack)
> +			       struct netlink_ext_ack *extack,
> +			       struct nlmsghdr *nlh)

'nlh' could be const here too. Also, since we've started being picky
about the order of parameters, let's put 'nlh' right before 'tb' to
follow what other functions generally do.

>  {
>  	unsigned char name_assign_type = NET_NAME_USER;
>  	struct net *net = sock_net(skb->sk);
> +	u32 pid = NETLINK_CB(skb).portid;

s/pid/portid/

