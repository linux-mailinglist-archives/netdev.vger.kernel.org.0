Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8B25EC5E0
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiI0OV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiI0OVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:21:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3E8186992
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 07:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE2D2619E4
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 14:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A86C433D6;
        Tue, 27 Sep 2022 14:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664288492;
        bh=4bQnZI8Jw2dtanthhEef1onMSAgdsb+Kei9j5MWAHtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p+PosGe7ro1xd4HBGlyZYxT44VDuo3bpfUi4HsQDfgVUQ1OmCyEKcrL8Q0rn4dwbk
         wh6u3hdo0QLUJDarpy13j3VUTERCXaXU84IEMk3GcnMW7WGph0nIWI+P1+BFisKrp/
         HYQ7XTYCrEesUwDcY/B8fAcjYmiCE5DTnX4YVd9SVAYZdF6RbcjZ16h8Kq3ydXh4bC
         4besFm7zjO49ZlQZTmi4fOqrUh84q61Xv3F8UmHY+OVG9cETu+pw5a0pAkQQaTuZJu
         5UjJRPctrFFsL19YMmpjq2eJxhXZoMcdJ8Xyvz95elVZhvm/b62WFoROAIPFxT/Viq
         6O49bDofgCcsA==
Date:   Tue, 27 Sep 2022 07:21:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <20220927072130.6d5204a3@kernel.org>
In-Reply-To: <20220927041303.152877-1-liuhangbin@gmail.com>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 12:13:03 +0800 Hangbin Liu wrote:
> @@ -3382,6 +3401,12 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  		if (err)
>  			goto out_unregister;
>  	}
> +
> +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> +				      0, pid, nlh->nlmsg_seq);
> +	if (nskb)
> +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
> +
>  out:
>  	if (link_net)
>  		put_net(link_net);

I'm surprised you're adding new notifications. Does the kernel not
already notify about new links? I thought rtnl_newlink_create() ->
rtnl_configure_link() -> __dev_notify_flags() sends a notification,
already.

