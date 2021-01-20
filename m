Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DEA2FC8AC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbhATDWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732161AbhATCfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:35:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DFD522509;
        Wed, 20 Jan 2021 02:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611110107;
        bh=d4WV6P1DevpxZzXFWXgTamTE83h5kx3hZ+Q2yTt1v2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KSCK+77yjd0LYvpTZWscJn90qFOI09uFMik1jvNMv/+9HBrm4raMDsjLkkka/c4sk
         2IHSLTWbzNN52Ypo4hDh8IcRqyKABICQ8TWu5C4y/48NEqBVQ7BE0NishWop8cEhCx
         ur1oKWKDQzDhmqUyYa81wgCtvQ/7Y7HZR4RUtUF6X3+5p2xcevpy/SZ4yo2njYJ4mQ
         QxmuXjD3xlJWqSKHa531QRKjKBpok2S+H4QQ2fcaW9HcDayf6RY6T+CC0YQwZIGvN6
         i277JrnDDdBRwHbxCcUSth+9qvXtDf5Q2ffqZySp4Fjjfb7bQx3Iw1dsnNe/UMu20F
         HDDzU0cL5pFKA==
Date:   Tue, 19 Jan 2021 18:35:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] nexthop: Use a dedicated policy for
 nh_valid_get_del_req()
Message-ID: <20210119183506.21a2da79@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <74bb53b9-1bda-ba42-ceeb-9e85c8c2ea27@gmail.com>
References: <cover.1610978306.git.petrm@nvidia.org>
        <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
        <20210119125504.0b306d97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <74bb53b9-1bda-ba42-ceeb-9e85c8c2ea27@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 19:28:40 -0700 David Ahern wrote:
> On 1/19/21 1:55 PM, Jakub Kicinski wrote:
> >> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> >> index e53e43aef785..d5d88f7c5c11 100644
> >> --- a/net/ipv4/nexthop.c
> >> +++ b/net/ipv4/nexthop.c
> >> @@ -36,6 +36,10 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
> >>  	[NHA_FDB]		= { .type = NLA_FLAG },
> >>  };
> >>  
> >> +static const struct nla_policy rtm_nh_policy_get[NHA_MAX + 1] = {  
> > 
> > This is an unnecessary waste of memory if you ask me.
> > 
> > NHA_ID is 1, so we're creating an array of 10 extra NULL elements.
> > 
> > Can you leave the size to the compiler and use ARRAY_SIZE() below?  
> 
> interesting suggestion in general for netlink attributes.

According to tags on commit ff419afa4310 ("ethtool: trim policy
tables") the credit goes to Johannes :)
