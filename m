Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67426DEA88
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDLEaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDLEaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2FA49F1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5925D62DE2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CE1C433A1;
        Wed, 12 Apr 2023 04:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681273819;
        bh=plc5+idFE6lHfomexSJiLA9twtO2GCgchIqd6wrhUqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nS+eHaAFPCKZ97xj9IgYbn5XrEEP2tMox4Y1qTAcTMVpkfEv6oevJVw1UoAlWW2Xz
         VnoH2yCK9aYVKGKgkn1gOz9B/GV9OFyMuu03QZs8Cfxo9638g2/m4jAnMnuN9TWayi
         UVu6o8lsgU93Iu8HFg2Uqa/EHr1gxaDL4lfN4iiCpfjQHGkkL3yXct+AG+xrbk6I4E
         a7LsXTZCOlsnXbI0DVNMAGXwDQSljfARM4K4CtX8eZq+NeUf8JSSfaWKFHeoeac2uh
         Gqis3skDiFZ43H7dPD9hDt/A9zuFLNHYsgMDdegO47GdgTw2DH3mjplGdeAo/5+6WH
         x7ICtSZyNtpcA==
Date:   Tue, 11 Apr 2023 21:30:18 -0700
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
Subject: Re: [PATCHv3 net-next] bonding: add software tx timestamping
 support
Message-ID: <20230411213018.0b5b37ec@kernel.org>
In-Reply-To: <20230410082351.1176466-1-liuhangbin@gmail.com>
References: <20230410082351.1176466-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Apr 2023 16:23:51 +0800 Hangbin Liu wrote:
> @@ -5707,10 +5711,38 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  			ret = ops->get_ts_info(real_dev, info);
>  			goto out;
>  		}
> +	} else {
> +		/* Check if all slaves support software rx/tx timestamping */
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

Do we _really_ need to hold RCU lock over this?
Imposing atomic context restrictions on driver callbacks should not be
taken lightly. I'm 75% sure .ethtool_get_ts_info can only be called
under rtnl lock off the top of my head, is that not the case?

> +			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) ==
> +				    SOF_TIMESTAMPING_SOFTRXTX) {

You could check in this loop if TX is supported...

> +				soft_support = true;
> +				continue;
> +			}
> +
> +			soft_support = false;
> +			break;
> +		}
> +		rcu_read_unlock();
>  	}
>  
> -	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
> -				SOF_TIMESTAMPING_SOFTWARE;
> +	ret = 0;
> +	if (soft_support) {
> +		info->so_timestamping = SOF_TIMESTAMPING_SOFTRXTX;
> +	} else {
> +		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
> +					SOF_TIMESTAMPING_SOFTWARE;

...make this unconditional and conditionally add TX...

> +	}
>  	info->phc_index = -1;
>  
>  out:
> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
> index a2c66b3d7f0f..2adaa0008434 100644
> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -48,6 +48,9 @@ enum {
>  					 SOF_TIMESTAMPING_TX_SCHED | \
>  					 SOF_TIMESTAMPING_TX_ACK)
>  
> +#define SOF_TIMESTAMPING_SOFTRXTX (SOF_TIMESTAMPING_TX_SOFTWARE | \
> +				   SOF_TIMESTAMPING_RX_SOFTWARE | \
> +				   SOF_TIMESTAMPING_SOFTWARE)

..then you won't need this define in uAPI.
