Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81105EF620
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiI2NMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiI2NMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:12:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6562598368
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664457147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n9aMVxOEiPjbeL7BALzZZPNFbptuxgGJ+1wVrFQ2hmQ=;
        b=NYgFjkuLKtGDVON95vQOsOspfPM1mbFLoOqsy52Z+FoPu27RIiDPbHS8Ft6QdrI1Zv4mYC
        uWDjS7Ov7HSD0vtDr+XzXUsuHUtJBoOhf5yQy+j5Dy+Si5GFemt7WO6Bog+47ClVV7Cu0X
        MLUd9J72JYz8A1/KNsX8CMhlwVHSGUM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-iYiKRj7eOH2ApDSZREVldw-1; Thu, 29 Sep 2022 09:12:26 -0400
X-MC-Unique: iYiKRj7eOH2ApDSZREVldw-1
Received: by mail-wr1-f71.google.com with SMTP id u20-20020adfc654000000b0022cc05e9119so514251wrg.16
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date;
        bh=n9aMVxOEiPjbeL7BALzZZPNFbptuxgGJ+1wVrFQ2hmQ=;
        b=Sj0ipgzxkYYdakw5S6bGhrcj8cdn81Tnb5JXf9OgYfGd4pU4Mti5GILXhoC2e6WnNU
         b2qYAihWXrUTFeZY5P3kFp8Z07H1r9LxwEaqhKDfF1g6icikOqtILYLWu6w3Tdmd5Pnx
         2p5wycDAnOcTQxAWdiGUI+MYyfSh+I9n+hgsq1QFT6tqfSloeAtHlbFbV0pzDmqcdxqR
         1215+ZjL5UQu1VVg1o+vgueWh7B7T906toL3uLPcLwvseTFdqrL1iSkMNgXihdvR0Giz
         EZ06YKtiZINtKFHltTSHQ4ch8XuB+8Ra1aHOHg4MNs8sc3JxShrfReMPmqOzagG1dEGT
         t08g==
X-Gm-Message-State: ACrzQf23MCR0m16LRPUnUtHfFkFuGJzijSUMo9dIx8sPK9aV1HDak6fZ
        GKhe1PX+2ZhhC+ztKpNePkIJwZlaE6kad32m9CGn0hoxI54A+CMwBGLrMhiWa/9cVUl3aKBpqdm
        0NU3wxmCaXP1eqX5W
X-Received: by 2002:a05:600c:6026:b0:3b5:b00:3a5a with SMTP id az38-20020a05600c602600b003b50b003a5amr2292113wmb.108.1664457145170;
        Thu, 29 Sep 2022 06:12:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5HIe+DaECjrfynQMGAmxeSjTFuYaD+A4oJcAG4toqep9hEDSb4KpvaqrVcIVeebzmPSwPqfA==
X-Received: by 2002:a05:600c:6026:b0:3b5:b00:3a5a with SMTP id az38-20020a05600c602600b003b50b003a5amr2292085wmb.108.1664457144839;
        Thu, 29 Sep 2022 06:12:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id b8-20020a5d45c8000000b0022ca921dc67sm6534964wrs.88.2022.09.29.06.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 06:12:24 -0700 (PDT)
Message-ID: <5a5b84a017bcdce540c7624a3c087c6971f82a34.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] net: Add helper function to parse
 netlink msg of ip_tunnel_encap
From:   Paolo Abeni <pabeni@redhat.com>
To:     Liu Jian <liujian56@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Date:   Thu, 29 Sep 2022 15:12:23 +0200
In-Reply-To: <20220928033917.281937-2-liujian56@huawei.com>
References: <20220928033917.281937-1-liujian56@huawei.com>
         <20220928033917.281937-2-liujian56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-28 at 11:39 +0800, Liu Jian wrote:
> Add ip_tunnel_netlink_encap_parms to parse netlink msg of ip_tunnel_encap.
> Reduces duplicate code, no actual functional changes.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: Move the implementation of the helper function to ip_tunnel_core.c
>  include/net/ip_tunnels.h  |  3 +++
>  net/ipv4/ip_tunnel_core.c | 35 +++++++++++++++++++++++++++++++++++
>  net/ipv4/ipip.c           | 38 ++------------------------------------
>  net/ipv6/ip6_tunnel.c     | 37 ++-----------------------------------
>  net/ipv6/sit.c            | 38 ++------------------------------------
>  5 files changed, 44 insertions(+), 107 deletions(-)
> 
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index ced80e2f8b58..51da2957cf48 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -302,6 +302,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
>  		      struct ip_tunnel_parm *p, __u32 fwmark);
>  void ip_tunnel_setup(struct net_device *dev, unsigned int net_id);
>  
> +bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
> +				   struct ip_tunnel_encap *encap);
> +
>  extern const struct header_ops ip_tunnel_header_ops;
>  __be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
>  
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index cc1caab4a654..526e6a52a973 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -1079,3 +1079,38 @@ EXPORT_SYMBOL(ip_tunnel_parse_protocol);
>  
>  const struct header_ops ip_tunnel_header_ops = { .parse_protocol = ip_tunnel_parse_protocol };
>  EXPORT_SYMBOL(ip_tunnel_header_ops);
> +
> +/* This function returns true when ENCAP attributes are present in the nl msg */
> +bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
> +				   struct ip_tunnel_encap *encap)
> +{
> +	bool ret = false;
> +
> +	memset(encap, 0, sizeof(*encap));
> +
> +	if (!data)
> +		return ret;
> +
> +	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
> +		ret = true;
> +		encap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
> +	}
> +
> +	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
> +		ret = true;
> +		encap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
> +	}
> +
> +	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
> +		ret = true;
> +		encap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
> +	}
> +
> +	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
> +		ret = true;
> +		encap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ip_tunnel_netlink_encap_parms);

I think EXPORT_SYMBOL_GPL() fits better here.

Cheers,

Paolo

