Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369285EDE97
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiI1OQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiI1OQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:16:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF65642FE
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:16:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6098E61E8B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A54C433D7;
        Wed, 28 Sep 2022 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664374570;
        bh=8m53XULflZ94piZwa4qAbvBCkDL2SDvWTKQatuyS2ao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+NqUfiyJJ9uTrLiGsubVkcaM+VhZ/daCMTZBFHRiaHsbRBy3Q0g9Gec4A1h04TSW
         kBYdMVyBRwnUPjO0qKErTCbWd7ARbOq8/higdDj1vC9w+Dck+4mEVNzbLPjwLCcc1V
         6/au5Pxdoh2qBZxoeB4gcwwvvO0HJzo09sSVbUXc5+0fsmi/zhDdlvtSIvzyjPiKnC
         b42vckkHNwplCUjNwI+wb7zPts2bVD/QQakMs6XYjHJ2tiDWeVaVcLi9cy1W4PVK34
         Xx6uLB30YnxrnDsA5SpZuOLebWf5l+FYSE2FhUmIXCOrfNnZEeO1SMCtpV7sZKznV+
         RQYUm9tlXkotw==
Date:   Wed, 28 Sep 2022 07:16:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <20220928071609.5af4bb4f@kernel.org>
In-Reply-To: <YzO943B4Id2jLZkI@Laptop-X1>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
        <YzO943B4Id2jLZkI@Laptop-X1>
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

On Wed, 28 Sep 2022 11:22:11 +0800 Hangbin Liu wrote:
> Hi Jakub,
> On Tue, Sep 27, 2022 at 12:13:03PM +0800, Hangbin Liu wrote:
> > @@ -3009,6 +3012,11 @@ static int do_setlink(const struct sk_buff *skb,
> >  		}
> >  	}
> >  
> > +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> > +				      0, pid, nlh->nlmsg_seq);
> > +	if (nskb)
> > +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);  
> 
> BTW, in do_setlink() I planed to use RTM_SETLINK. But I found iproute2 use
> RTM_NEWLINK to set links. And I saw an old doc[1] said
> 
> """
> - RTM_SETLINK does not follow the usual rtnetlink conventions and ignores
>   all netlink flags
> 
> The RTM_NEWLINK message type is a superset of RTM_SETLINK, it allows
> to change both driver specific and generic attributes of the device.
> """

Interesting, so we actually do use this "NEW as SET" thing.

> So I just use RTM_NEWLINK for the notification. Do you think if we should
> use RTM_SETLINK?

FWIW I think it's typical for rtnl / classic netlink to generate 
"new object" notification whenever object is changed, rather than
a notification about just the change.
