Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA836E2E17
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDOBCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDOBCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:02:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1976412B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF01614E1
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF15C433D2;
        Sat, 15 Apr 2023 01:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681520527;
        bh=3ZqmmZD+fpi3z4npBVCyb7opmMsUf3TJfIoLVIw4dC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q7n8Y7W/IHNKtOUo0qHXxbdEH9jxkvvj9GfV67FeFYzyKA86GiJzVAYmoEBSX+9EU
         6rHrD9O/TjcLJx5phLqYcQkK61ufOGZLPZBqPmrjY44mY6w4nCkTpq2wyYB/dhZlLB
         OnkbNkcm5xAnV/ifn0ToZ2/9OtizAPzB6DDUw0bgoyfteGnjB6i+v3nipd5SLA2WxV
         FjCnGh9wChWcR/i/asnUGZFM7LnSr1PZXtU/Xc/Pl1Ag8bQmTzypDongkm6dtAwydN
         TYXum20G6ssE/Fqdoc9pEUYLsx52Ro+FYtlNotTcpUG8DRsFPbJ6BSlV4EyEl5cWEp
         HM4zu5JVUdQSQ==
Date:   Fri, 14 Apr 2023 18:02:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv4 net-next] bonding: add software tx timestamping
 support
Message-ID: <20230414180205.1220135d@kernel.org>
In-Reply-To: <20230414083526.1984362-1-liuhangbin@gmail.com>
References: <20230414083526.1984362-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 16:35:26 +0800 Hangbin Liu wrote:
> v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
>     RTNL. Only check _TX_SOFTWARE for the slaves.

> +	ASSERT_RTNL();
> +
>  	rcu_read_lock();
>  	real_dev = bond_option_active_slave_get_rcu(bond);
>  	dev_hold(real_dev);
> @@ -5707,10 +5713,36 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  			ret = ops->get_ts_info(real_dev, info);
>  			goto out;
>  		}
> +	} else {
> +		/* Check if all slaves support software tx timestamping */
> +		rcu_read_lock();
> +		bond_for_each_slave_rcu(bond, slave, iter) {

> +			ret = -1;
> +			ops = slave->dev->ethtool_ops;
> +			phydev = slave->dev->phydev;
> +
> +			if (phy_has_tsinfo(phydev))
> +				ret = phy_ts_info(phydev, &ts_info);
> +			else if (ops->get_ts_info)
> +				ret = ops->get_ts_info(slave->dev, &ts_info);

My comment about this path being under rtnl was to point out that we
don't need the RCU protection to iterate over the slaves. This is 
a bit of a guess, I don't know bonding, but can we not use
bond_for_each_slave() ?

As a general rule we should let all driver callbacks sleep. Drivers 
may need to consult the FW or read something over a slow asynchronous
bus which requires process / non-atomic context. RCU lock puts us in 
an atomic context. And ->get_ts_info() is a driver callback.

It's not a deal breaker if we can't avoid RCU, but if we can - we should
let the drivers sleep. Sorry if I wasn't very clear previously.
