Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BD646DF2D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbhLIAHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbhLIAHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:07:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7E9C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 16:04:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99CBBCE241F
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F82C00446;
        Thu,  9 Dec 2021 00:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639008246;
        bh=/apG6k+vW+j3XTZxBu7ZcuVmplejClenoMgF/w/a2yg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hFvVdJJOhAaYCHZJ8bbDhm7VXu5z51AtIzUOFWGZjmYgEDxcs6yZrXihYm2Q8vjQ8
         GwD/NeftTr4ZHKRSt5c0zrMbcx9BUCn053mAxkcpKUWgfesb0KdBM02HYXwwnsqKxj
         erZSb0GTz2YVNzMqo4N/WaxvnSjDx5hh0vB4IdfK37bfhamnWzl3F+bc+1nywg5X6Y
         ubERA6JqBFiye2orsi47nz25dvCOg7uKMVwIiE7+JFafcuzNJPTCkQygj+1FQPXjyX
         uKCOdd4irHtVeEOiCklrxLk1gf6JcuXpmeyQ7hwL7y/5F3E+BTT3jDLLiaC5Pii8m8
         fJGadlJOhs7mw==
Date:   Wed, 8 Dec 2021 16:04:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org, nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211208160405.18c7d30f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
        <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
        <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
        <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 16:43:28 -0700 David Ahern wrote:
> On 12/8/21 2:47 PM, Lahav Schlesinger wrote:
> > No visible changes from what I saw, this API is as fast as group
> > deletion. Maybe a few tens of milliseconds slower, but it's lost in the
> > noise.
> > I'll run more thorough benchmarks to get to a more conclusive conclusion.
> > 
> > Also just pointing out that the sort will be needed even if we pass an
> > array (IFLA_IFINDEX_LIST) instead.
> > Feels like CS 101, but do you have a better approach for detecting
> > duplicates in an array? I imagine a hash table will be slower as it will
> > need to allocate a node object for each device (assuming we don't want
> > to add a new hlist_node to 'struct net_device' just for this)  
> 
> I think marking the dev's and then using a delete loop is going to be
> the better approach - avoid the sort and duplicate problem. I use that
> approach for nexthop deletes:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/nexthop.c#n1849
> 
> Find a hole in net_device struct in an area used only for control path
> and add 'bool grp_delete' (or a 1-bit hole). Mark the devices on pass
> and delete them on another.

If we want to keep state in the netdev itself we can probably piggy
back on dev->unreg_list. It should be initialized to empty and not
touched unless device goes thru unregister.
