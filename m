Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12973575E5
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356158AbhDGUZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356182AbhDGUYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D996100A;
        Wed,  7 Apr 2021 20:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827045;
        bh=2uHxjP0K/6fzzz/cW5MbaH6iXzs/AvsDUZFoJ93O1co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d3ddt0OPpk4Uy0RaR4VLXZqs1r3z1OjiptoT7CPogETSpCOdn8XOf/OyeG3yMVFH3
         Z/yf+G3JkHCzbMfVot9Dtu5BGSmVTF9k7GP98iREBmlOpn1vauxGgk1QL14JXdh2Yf
         VbO+v9/+vNKaGfos3SbWHBW/13/ocI3HROtfgJUGBz03GUBVqhrW2KgNnT9xnXoOP/
         d6sATvzwdRHavGi1x2TSCxoOjKnvDzmCXUcuysU2Dtg7TIVY2q1Mdp1FfyLg1axtqX
         9w0TLfV8tPP593C8rnr4ZkIoXdTFSaPnFuEqLGYCNOE2J6KjG27GBtmhasxe2wloFf
         cjW+6XyPwby7w==
Date:   Wed, 7 Apr 2021 13:24:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [RFC net-next 1/1] seg6: add counters support for SRv6
 Behaviors
Message-ID: <20210407132404.59c95127@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407180332.29775-2-andrea.mayer@uniroma2.it>
References: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
        <20210407180332.29775-2-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Apr 2021 20:03:32 +0200 Andrea Mayer wrote:
> This patch provides counters for SRv6 Behaviors as defined in [1], section
> 6. For each SRv6 Behavior instance, the counters defined in [1] are:
> 
>  - the total number of packets that have been correctly processed;
>  - the total amount of traffic in bytes of all packets that have been
>    correctly processed;
> 
> In addition, we introduces a new counter that counts the number of packets
> that have NOT been properly processed (i.e. errors) by an SRv6 Behavior
> instance.
> 
> Each SRv6 Behavior instance can be configured, at the time of its creation,
> to make use of counters.
> This is done through iproute2 which allows the user to create an SRv6
> Behavior instance specifying the optional "count" attribute as shown in the
> following example:
> 
>  $ ip -6 route add 2001:db8::1 encap seg6local action End count dev eth0
> 
> per-behavior counters can be shown by adding "-s" to the iproute2 command
> line, i.e.:
> 
>  $ ip -s -6 route show 2001:db8::1
>  2001:db8::1 encap seg6local action End packets 0 bytes 0 errors 0 dev eth0
> 
> [1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>

> +static int put_nla_counters(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> +{
> +	struct seg6_local_counters counters = { 0, 0, 0 };
> +	struct nlattr *nla;
> +	int i;
> +
> +	nla = nla_reserve(skb, SEG6_LOCAL_COUNTERS, sizeof(counters));
> +	if (!nla)
> +		return -EMSGSIZE;

nla_reserve_64bit(), IIUC netlink guarantees alignment of 64 bit values.
