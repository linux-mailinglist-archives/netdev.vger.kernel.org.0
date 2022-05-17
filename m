Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061BC52968E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiEQBKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbiEQBKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:10:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1058D41333
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 940A0B816A3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0719C385AA;
        Tue, 17 May 2022 01:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652749831;
        bh=T92aBYsbopYdrt46hOAUjf92En6XUgCGbdq+vFBcEZg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q29KYDSFCA6dL038Q/lc1h1KcXydtFHNjufL9eb581g8AQA7suaUZiAqa/38sosxG
         2yoKPCDqXJGax8bL9uQ55VqqCZreTZ/G9Y1XD9rtg71rjw49DDhXvtCOB1dU4mcQIk
         tfohjy0RQwUL3Jw0kO3PYnnUMZk+9lnjMEjit4AqRghnE1Q091ycgu1xFrxKEWub2T
         HCY8ETRpFRFbELGIlzsasI6fNwVfXFmb+ZFKxxm5xHTRBHNK2geW5bbzxum7vN7rp9
         /iFSAhvnASW0yQL9HHH0FMR5F5pQAmHsf7PuduLozbdYWJ6cxjnRYn9lmcybRjE4RU
         GmdIuxrUjQKKw==
Date:   Mon, 16 May 2022 18:10:28 -0700
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
Subject: Re: [PATCH RESEND net] bonding: fix missed rcu protection
Message-ID: <20220516181028.7dbbf918@kernel.org>
In-Reply-To: <20220513103350.384771-1-liuhangbin@gmail.com>
References: <20220513103350.384771-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 18:33:50 +0800 Hangbin Liu wrote:
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 38e152548126..3a6f879ad7a9 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5591,16 +5591,20 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  	const struct ethtool_ops *ops;
>  	struct net_device *real_dev;
>  	struct phy_device *phydev;
> +	int ret = 0;
>  
> +	rcu_read_lock();
>  	real_dev = bond_option_active_slave_get_rcu(bond);
>  	if (real_dev) {
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
>  	}

Can't ->get_ts_info sleep now? It'd be a little sad to force it 
to be atomic just because of one upper dev trying to be fancy.
Maybe all we need to do is to take a ref on the real_dev?

Also please add a Link: to the previous discussion, it'd have been
useful to get the context in which Vladimir suggested this.
