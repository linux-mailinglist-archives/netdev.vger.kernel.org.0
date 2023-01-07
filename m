Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD42366127F
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 00:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjAGXHM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 7 Jan 2023 18:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGXHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 18:07:10 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65961271A2
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 15:07:08 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-kWdCFTcGNaOP4aCAd1ze4Q-1; Sat, 07 Jan 2023 18:06:00 -0500
X-MC-Unique: kWdCFTcGNaOP4aCAd1ze4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B238685C1A0;
        Sat,  7 Jan 2023 23:05:59 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54BE82166B30;
        Sat,  7 Jan 2023 23:05:58 +0000 (UTC)
Date:   Sun, 8 Jan 2023 00:04:36 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        atenart@kernel.org
Subject: Re: [PATCH net-next v6 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y7n6hF3voEe8Hv+5@hog>
References: <20230106133551.31940-1-ehakim@nvidia.com>
 <20230106133551.31940-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230106133551.31940-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-06, 15:35:50 +0200, ehakim@nvidia.com wrote:
[...]
> +static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
> +	struct nlattr **attrs = info->attrs;
> +	enum macsec_offload offload;
> +	struct net_device *dev;
> +	int ret;
> +
> +	if (!attrs[MACSEC_ATTR_IFINDEX])
> +		return -EINVAL;
> +
> +	if (!attrs[MACSEC_ATTR_OFFLOAD])
> +		return -EINVAL;
> +
> +	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
> +					attrs[MACSEC_ATTR_OFFLOAD],
> +					macsec_genl_offload_policy, NULL))
> +		return -EINVAL;
> +
> +	dev = get_dev_from_nl(genl_info_net(info), attrs);
> +	if (IS_ERR(dev))
> +		return PTR_ERR(dev);
> +
> +	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
> +		return -EINVAL;
> +
> +	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
> +
> +	rtnl_lock();

Why are you putting rtnl_lock() back down here? You just moved it
above get_dev_from_nl with commit f3b4a00f0f62 ("net: macsec: fix net
device access prior to holding a lock"), now you're pretty much
reverting that fix.

> +
> +	ret = macsec_update_offload(dev, offload);
>  
> -rollback:
> -	macsec->offload = prev_offload;
> -out:
>  	rtnl_unlock();
> +
>  	return ret;
>  }
>  

-- 
Sabrina

