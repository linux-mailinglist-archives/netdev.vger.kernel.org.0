Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792A74D3FC3
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiCJDiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiCJDiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:38:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D601195A04
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 19:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 891D3B82459
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8E4C340E8;
        Thu, 10 Mar 2022 03:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646883430;
        bh=owObSO7c+qeB/4BK8L2EAxjdhlKk9BgZPJucVCZQCco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cnIs+QGTDr/2WgQuETqSeY+J/BELzV28qHcTemUFGAttJV1S66zetmJttX6J8y8WA
         5p7SkgezWjbh6LZl1PgPUsm5fd1sFty3WQ89nhjh60uzOVZorJtWL5OH8r/Bbjxqcd
         xPDhghZKVw98bk/OP95Epknm8swqtoQDa0aAwkbv2jRvgJ3Hai0gkt0sYUh/7n8/MC
         LvoFo2vODJ2g6gK2wjK+nx4JXQ/IoDu/uzPDhnJFguAm1uJ+uVT0pzvMAMeESx3/ZI
         ZT4k5Glbg+sx/VfdVBCt1JWk/uzY4kFfBzXF2kIYf4pruFdQyJMeYj+P3JLEl5qqIS
         YZ2rcbYE9WNmQ==
Date:   Wed, 9 Mar 2022 19:37:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        George Shuklin <george.shuklin@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: limit altnames to 64k total
Message-ID: <20220309193708.340a6af5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3731ad8f-55b4-154e-28b7-0ee6cea827b8@gmail.com>
References: <20220309182914.423834-1-kuba@kernel.org>
        <20220309182914.423834-3-kuba@kernel.org>
        <3731ad8f-55b4-154e-28b7-0ee6cea827b8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 19:51:07 -0700 David Ahern wrote:
> On 3/9/22 11:29 AM, Jakub Kicinski wrote:
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index aa05e89cc47c..159c9c61e6af 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -3652,12 +3652,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
> >  			   bool *changed, struct netlink_ext_ack *extack)
> >  {
> >  	char *alt_ifname;
> > +	size_t size;
> >  	int err;
> >  
> >  	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
> >  	if (err)
> >  		return err;
> >  
> > +	if (cmd == RTM_NEWLINKPROP) {
> > +		size = rtnl_prop_list_size(dev);
> > +		size += nla_total_size(ALTIFNAMSIZ);
> > +		if (size >= U16_MAX) {
> > +			NL_SET_ERR_MSG(extack,
> > +				       "effective property list too long");
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> >  	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
> >  	if (!alt_ifname)
> >  		return -ENOMEM;  
> 
> this tests the existing property size. Don't you want to test the size
> with the alt_ifname - does it make the list go over 64kB?

Do you mean counting the exact length of the string?

Or that I'm counting pre-add? That's why I added:

	size += nla_total_size(ALTIFNAMSIZ);

I like coding things up as prepare (validate) + commit,
granted it doesn't exactly look pretty here so I can recode
if you prefer. But there's no bug, right? (other than maybe 
>= could have been > but whatever).
