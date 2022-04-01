Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF4C4EF91F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbiDARpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 13:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiDARph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 13:45:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEE35FA0
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 10:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4D52B8256F
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 17:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109C0C2BBE4;
        Fri,  1 Apr 2022 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648835024;
        bh=8vHIJXtXwlCs49dmEIpdeaxsxvA4jnpUkLE4y47ww6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k4Y4VFR2+LIeFCSouMgOsYd2dHAcg1GaP32oBkSpllS752G+aRGW+ML600QI5BGFC
         FCif9+ZFHVYR/3hhQANEKMx8SoPQ0nLf/B3IgorZIPBatl9zLT6x7T9g0sS3WSqz+3
         sIl1s6rQA+axsmutSTKroOJ5p2lDBQRaOHonKD51+WWljimB2tk1WjbJgxHVrzuGpu
         wbGPZ+pa1wyLiU6v93PrqZjbgNdMzF91IipyyqyxiVg37UgLPbVrpz/DZzuCuSAy9G
         xjI/BMk5ZKiXlwyTurEF/W2uIOX4r1QTMRpEhNmYOtg3WL6yGvqfY2sJ80DAw6pHQY
         VptoOs1wED3Sg==
Date:   Fri, 1 Apr 2022 10:43:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH net v2] rtnetlink: enable alt_ifname for setlink/newlink
Message-ID: <20220401104342.5df7349a@kernel.org>
In-Reply-To: <20220401153939.19620-1-florent.fourcot@wifirst.fr>
References: <20220401153939.19620-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Apr 2022 17:39:39 +0200 Florent Fourcot wrote:
> buffer called "ifname" given in function rtnl_dev_get
> is always valid when called by setlink/newlink,
> but contains only empty string when IFLA_IFNAME is not given. So
> IFLA_ALT_IFNAME is always ignored
> 
> This patch fixes rtnl_dev_get function with a remove of ifname argument,
> and move ifname copy in do_setlink when required
> 
> Changes in v2:
>  * Remove ifname argument in rtnl_dev_get/do_setlink
>    functions (simplify code)
> 
> Fixes: 76c9ac0ee878 ("net: rtnetlink: add possibility to use alternative names as message handle")
> CC: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>

> @@ -3262,7 +3257,7 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
>  
>  	for_each_netdev_safe(net, dev, aux) {
>  		if (dev->group == group) {
> -			err = do_setlink(skb, dev, ifm, extack, tb, NULL, 0);
> +			err = do_setlink(skb, dev, ifm, extack, tb, 0);

This part depends on your other change, right? Do you care about this
getting into stable? Otherwise we can downgrade it from a fix to -next
and merge after your other patch. It never worked so we can go either
way on it being a fix. Actually leaning slightly towards it _not_ being
a fix.

>  			if (err < 0)
>  				return err;
>  		}

> @@ -3450,7 +3440,10 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (!ops->alloc && !ops->setup)
>  		return -EOPNOTSUPP;
>  
> -	if (!ifname[0]) {
> +	if (tb[IFLA_IFNAME]) {
> +		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> +	}
> +	else {

Formatting slightly off here, should be

	} else {

>  		snprintf(ifname, IFNAMSIZ, "%s%%d", ops->kind);
>  		name_assign_type = NET_NAME_ENUM;
>  	}
> @@ -3622,8 +3615,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (ifm->ifi_index > 0)
>  		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
>  	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
> -		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME],
> -				   tb[IFLA_ALT_IFNAME], NULL);
> +		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME], tb[IFLA_ALT_IFNAME]);

How about we pass tb and extract IFLA_IFNAME and IFLA_ALT_IFNAME inside
rtnl_dev_get()? All callers seem to pass the same args now.

>  	else
>  		goto out;
>  


