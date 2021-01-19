Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD79C2FAFCA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbhASEtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731373AbhASEkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:40:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B45AF20848;
        Tue, 19 Jan 2021 04:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611031196;
        bh=Tongjwl+FwLZedxmbC6m+/81gorkgsi3qjXCL0mucog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKCjtjU8PKy1SgH2kMiBA6gEjdS2RrBLtch69Is5MMVwXkity1+Y66zGZv3uDSyIT
         PKGOijhWUVExEpoiXz8aymDf8tSsJKsaxJ4YrPQL8dq98ddRRAKJ/H3i+exmSPJC9S
         1ul1ab+UFceM+gjWJ1/hNC2XmkABumq7OBqX0pXPqFLLLaWujXsgpPB/K/PqHKtu5z
         Rc02Xt+najHajx8atE/5iY8vxoqFvC+OplzQcbhInjb05/29mZZ6mP4YA8gZls5Rg7
         WTLY3P+7uGB20ib3iMeocfTgmj8fsbS8b/uBEv3V3VAxIg9C1aRDBDu6EjGR54WuA+
         1ctAqVH/UTl9g==
Date:   Mon, 18 Jan 2021 20:39:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyingjie55@126.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH v1] ipv4: add iPv4_is_multicast() check in
 ip_mc_leave_group().
Message-ID: <20210118203954.15553706@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610890456-42846-1-git-send-email-wangyingjie55@126.com>
References: <1610890456-42846-1-git-send-email-wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 05:34:16 -0800 wangyingjie55@126.com wrote:
> From: Yingjie Wang <wangyingjie55@126.com>
> 
> There is no iPv4_is_multicast() check added to ip_mc_leave_group()
> to check if imr->imr_multiaddr.s_addr is a multicast address.
> If not a multicast address, it may result in an error.

Could you please say more? From looking at the code it seems like
no address should match if group is non-mcast, and -EADDRNOTAVAIL 
will be returned.

Adding Nik to CC.

> In some cases, the callers of ip_mc_leave_group() don't check
> whether it is multicast address or not before calling
> such as do_ip_setsockopt(). So I suggest adding the ipv4_is_multicast()
> check to the ip_mc_leave_group() to prevent this from happening.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
> ---
>  net/ipv4/igmp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 7b272bbed2b4..1b6f91271cfd 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2248,6 +2248,9 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
>  	u32 ifindex;
>  	int ret = -EADDRNOTAVAIL;
>  
> +	if (!ipv4_is_multicast(group))
> +		return -EINVAL;
> +
>  	ASSERT_RTNL();
>  
>  	in_dev = ip_mc_find_dev(net, imr);

