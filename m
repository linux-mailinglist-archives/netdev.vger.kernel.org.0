Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D052AC54E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKITrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgKITrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 14:47:35 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 808C5206A4;
        Mon,  9 Nov 2020 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604951254;
        bh=BImTZioLqvv+T9X86cbNFib5gpkUiqtpYhga/QFjyh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qwUxejk2bLdenWoi/neYqmIDwoviu0d3kF7Z4wrf2/Gp/hPiaIuhaCoI5EYg1Pe1W
         N3X4+SL5NH1mPs9SyDE2SXqHXZ7aO1Ceh658JeO4tqekflH2sfk1HpKZdJefr0mwRq
         r1WHQBaapizk1Oz0rWY8gLbh3vb6JDne7c9aJa4Y=
Date:   Mon, 9 Nov 2020 11:47:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Dike <jdike@akamai.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net V2] Exempt multicast addresses from five-second
 neighbor lifetime
Message-ID: <20201109114733.0ee71b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109025052.23280-1-jdike@akamai.com>
References: <20201109025052.23280-1-jdike@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Nov 2020 21:50:52 -0500 Jeff Dike wrote:
> Commit 58956317c8de ("neighbor: Improve garbage collection")
> guarantees neighbour table entries a five-second lifetime.  Processes
> which make heavy use of multicast can fill the neighour table with
> multicast addresses in five seconds.  At that point, neighbour entries
> can't be GC-ed because they aren't five seconds old yet, the kernel
> log starts to fill up with "neighbor table overflow!" messages, and
> sends start to fail.
> 
> This patch allows multicast addresses to be thrown out before they've
> lived out their five seconds.  This makes room for non-multicast
> addresses and makes messages to all addresses more reliable in these
> circumstances.
> 
> Signed-off-by: Jeff Dike <jdike@akamai.com>

This makes sense because mcast L2 addr is calculated, not discovered,
and therefore can be recreated at a very low cost, correct?

Perhaps it would make sense to widen the API to any "computed" address
rather than implicitly depending on this behavior for mcast?

I'm not an expert tho, maybe others disagree.

> +static int arp_is_multicast(const void *pkey)
> +{
> +	return IN_MULTICAST(htonl(*((u32 *)pkey)));
> +}

net/ipv4/arp.c:935:16: warning: cast from restricted __be32

s/u32/__be32/
s/htonl/ntohl/
