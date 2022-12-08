Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437A3647903
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiLHWpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLHWph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:45:37 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCCF7868B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:45:36 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-oCnv6kCmOLye84aoeVkzxQ-1; Thu, 08 Dec 2022 17:45:31 -0500
X-MC-Unique: oCnv6kCmOLye84aoeVkzxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C9FF29AA3AF;
        Thu,  8 Dec 2022 22:45:31 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98C67C15BA8;
        Thu,  8 Dec 2022 22:45:29 +0000 (UTC)
Date:   Thu, 8 Dec 2022 23:44:25 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, atenart@kernel.org,
        jiri@resnulli.us
Subject: Re: [PATCH net-next v4 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y5Joya0YpTiMAdMt@hog>
References: <20221208115517.14951-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221208115517.14951-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-12-08, 13:55:16 +0200, ehakim@nvidia.com wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Add support for changing Macsec offload selection through the
> netlink layer by implementing the relevant changes in
> macsec_changelink.
> 
> Since the handling in macsec_changelink is similar to macsec_upd_offload,
> update macsec_upd_offload to use a common helper function to avoid
> duplication.
> 
> Example for setting offload for a macsec device:
>     ip link set macsec0 type macsec offload mac
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> ---
> V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
> 		  - Fix code style.
> 		  - Remove macsec_changelink_upd_offload
> V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
>                        to be sent to "net" branch as a fix.
>                  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
>                    to changelink
> V1 -> V2: Add common helper to avoid duplicating code
> 
>  drivers/net/macsec.c | 100 +++++++++++++++++++++++--------------------
>  1 file changed, 53 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index d73b9d535b7a..abfe4a612a2d 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -2583,38 +2583,16 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
>  	return false;
>  }
>  
> -static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
> +static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
>  {
> -	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
> -	enum macsec_offload offload, prev_offload;
> -	int (*func)(struct macsec_context *ctx);
> -	struct nlattr **attrs = info->attrs;
> -	struct net_device *dev;
> +	enum macsec_offload prev_offload;
>  	const struct macsec_ops *ops;
>  	struct macsec_context ctx;
>  	struct macsec_dev *macsec;
> -	int ret;
> -
> -	if (!attrs[MACSEC_ATTR_IFINDEX])
> -		return -EINVAL;
> -
> -	if (!attrs[MACSEC_ATTR_OFFLOAD])
> -		return -EINVAL;
> -
> -	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
> -					attrs[MACSEC_ATTR_OFFLOAD],
> -					macsec_genl_offload_policy, NULL))
> -		return -EINVAL;
> +	int ret = 0;
>  
> -	dev = get_dev_from_nl(genl_info_net(info), attrs);
> -	if (IS_ERR(dev))
> -		return PTR_ERR(dev);
>  	macsec = macsec_priv(dev);
>  
> -	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
> -		return -EINVAL;
> -
> -	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
>  	if (macsec->offload == offload)
>  		return 0;
>  
> @@ -2627,43 +2605,65 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
>  	if (netif_running(dev))
>  		return -EBUSY;
>  
> -	rtnl_lock();
> -
> -	prev_offload = macsec->offload;
> -	macsec->offload = offload;
> -
>  	/* Check if the device already has rules configured: we do not support
>  	 * rules migration.
>  	 */
> -	if (macsec_is_configured(macsec)) {
> -		ret = -EBUSY;
> -		goto rollback;
> -	}
> +	if (macsec_is_configured(macsec))
> +		return -EBUSY;
> +
> +	prev_offload = macsec->offload;
>  
>  	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
>  			       macsec, &ctx);
> -	if (!ops) {
> +	if (!ops)
>  		ret = -EOPNOTSUPP;

		return -EOPNOTSUPP;

It's probably not a problem because macsec_check_offload should catch
that, but it looks wrong.

> -		goto rollback;
> -	}
>  
> -	if (prev_offload == MACSEC_OFFLOAD_OFF)
> -		func = ops->mdo_add_secy;
> -	else
> -		func = ops->mdo_del_secy;
> +	macsec->offload = offload;
>  
>  	ctx.secy = &macsec->secy;
> -	ret = macsec_offload(func, &ctx);
> +	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
> +					    : macsec_offload(ops->mdo_add_secy, &ctx);
> +

nit: unnecessary blank line (sorry, I should have spotted that earlier)

>  	if (ret)
> -		goto rollback;
> +		macsec->offload = prev_offload;
>  
> -	rtnl_unlock();
> -	return 0;
> +	return ret;
> +}
> +
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
>  
> -rollback:
> -	macsec->offload = prev_offload;
> +	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
> +		return -EINVAL;
> +
> +	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
> +
> +	rtnl_lock();
> +
> +	ret = macsec_update_offload(dev, offload);
>  
>  	rtnl_unlock();
> +
>  	return ret;
>  }
>  
> @@ -3831,6 +3831,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
>  	if (ret)
>  		goto cleanup;
>  
> +	if (data[IFLA_MACSEC_OFFLOAD]) {
> +		ret = macsec_update_offload(dev, nla_get_u8(data[IFLA_MACSEC_OFFLOAD]));
> +		if (ret)
> +			goto cleanup;
> +	}
> +
>  	/* If h/w offloading is available, propagate to the device */
>  	if (macsec_is_offloaded(macsec)) {
>  		const struct macsec_ops *ops;

-- 
Sabrina

