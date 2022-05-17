Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4A252A9AD
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351665AbiEQRyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351664AbiEQRyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648663FBC9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ECE260EF3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AF8C385B8;
        Tue, 17 May 2022 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652810087;
        bh=4RFRTLelmZQNRUetemAcK1Nz2gDyHDcgHytUb3wXyu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GrgkOxg4GYP9vlNffmj7D59RfYayXjopd+r5UiYgH80m3ICfz5Pm5xHDsXBgH/M2B
         tOMkUyXO+mmM0yt0DEGY/8+S4ZFq1Il+MK+m8IHuzA4AAxj/cXVUcTfMw3shnKP/gQ
         JDNXK2MpAbh5BSmjjJyX+1xfeLIklafOVv578z8WFWv2IaugLe1stHuYqSJ+whhM0i
         +zbCyuM0Sx5pWOM/OXlEcs/1Y5UM/Pz3JGQV+Cc1mLCmtrqWeYhkNOJqG5wGmoSoXD
         pfgIVbtX9Oz1DYdAecORUzmEmPkNWMd70jilH+9veyfT+ViTfJRovpRGRWAoycb+Um
         7drbf58QbPczw==
Date:   Tue, 17 May 2022 10:54:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCHv2 net] bonding: fix missed rcu protection
Message-ID: <20220517105445.355b1d22@kernel.org>
In-Reply-To: <20220517082312.805824-1-liuhangbin@gmail.com>
References: <20220517082312.805824-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 16:23:12 +0800 Hangbin Liu wrote:
> +	rcu_read_lock();
>  	real_dev = bond_option_active_slave_get_rcu(bond);
>  	if (real_dev) {
> +		dev_hold(real_dev);
> +		rcu_read_unlock();
>  		ops = real_dev->ethtool_ops;
>  		phydev = real_dev->phydev;
>  
>  		if (phy_has_tsinfo(phydev)) {
> -			return phy_ts_info(phydev, info);
> +			ret = phy_ts_info(phydev, info);
> +			goto out;
>  		} else if (ops->get_ts_info) {
> -			return ops->get_ts_info(real_dev, info);
> +			ret = ops->get_ts_info(real_dev, info);
> +			goto out;
>  		}
> +	} else {
> +		rcu_read_unlock();
>  	}
>  
>  	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
>  				SOF_TIMESTAMPING_SOFTWARE;
>  	info->phc_index = -1;
>  
> -	return 0;
> +out:
> +	if (real_dev)
> +		dev_put(real_dev);

dev_hold() and dev_put() can take NULL these days, for better or worse.
I think the code simplification is worth making use of that, even tho
it will make the backport slightly more tricky (perhaps make a not of
this in the commit message).
