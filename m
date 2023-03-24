Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254596C886E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjCXWeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbjCXWee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:34:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5124C1499B
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E22EB82624
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 22:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A6DC433D2;
        Fri, 24 Mar 2023 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679697248;
        bh=EcVwzn7QigOkt1WDI4WgDjqqvSs+MjFx6vXIpQLgQ0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gMRgVfTcolXJY3Q+KauQBK9usYHryzx2yB22ZxIQ958An7/suIB9pB2pBzEoSvHxG
         95CO7pascXK6HzYDmKIy2FN/6xAi7nyRmXyC8i4sxi6Q9AcaS87beb0mhF+sITEWn0
         f/dMgioGLBzfvBoSKTOn6NBcA+khxSAsQI+wSNEUzmnX411Fg6UugtcsyP4CrcY+78
         LaqHx80eUgKzc+ETuqIaRP/3iuDfzCOneqexshz9YfKApxyMNaux2GOs0oDmDx7zab
         sAuSAcekl32V+dRn9KJPqELCEEhRLdsqfT1OoE84acvHdkt7ChiNgL+Uh+hQY8KOfp
         6cn0fzZt7HJTQ==
Date:   Fri, 24 Mar 2023 15:34:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>,
        Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, a@unstable.cc
Subject: Re: [BUG] gre interface incorrectly generates link-local addresses
Message-ID: <20230324153407.096d6248@kernel.org>
In-Reply-To: <CAJGXZLhL-LLjiA-ge8O5A5NDoZ5JABqZHqix0y-8ThcJjBSe=A@mail.gmail.com>
References: <CAJGXZLhL-LLjiA-ge8O5A5NDoZ5JABqZHqix0y-8ThcJjBSe=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Thomas as well.

On Fri, 24 Mar 2023 19:35:06 +0300 Aleksey Shumnik wrote:
> Dear Maintainers,
> 
> I found that GRE arbitrarily hangs IP addresses from other interfaces
> described in /etc/network/interfaces above itself (from bottom to
> top). Moreover, this error occurs on both ip4gre and ip6gre.
> 
> Example of mgre interface:
> 
> 13: mgre1@NONE: <MULTICAST,NOARP,UP,LOWER_UP> mtu 1400 qdisc noqueue
> state UNKNOWN group default qlen 1000
>     link/gre 0.0.0.0 brd 0.0.0.0
>     inet 10.10.10.100/8 brd 10.255.255.255 scope global mgre1
>        valid_lft forever preferred_lft forever
>     inet6 fe80::a0a:a64/64 scope link
>        valid_lft forever preferred_lft forever
>     inet6 fe80::7f00:1/64 scope host
>        valid_lft forever preferred_lft forever
>     inet6 fe80::a0:6842/64 scope host
>        valid_lft forever preferred_lft forever
>     inet6 fe80::c0a8:1264/64 scope host
>        valid_lft forever preferred_lft forever
> 
> It seems that after the corrections in the following commits
> https://github.com/torvalds/linux/commit/e5dd729460ca8d2da02028dbf264b65be8cd4b5f
> https://github.com/torvalds/linux/commit/30e2291f61f93f7132c060190f8360df52644ec1
> https://github.com/torvalds/linux/commit/23ca0c2c93406bdb1150659e720bda1cec1fad04
> 
> in function add_v4_addrs() instead of stopping after this check:
> 
> if (addr.s6_addr32[3]) {
>                 add_addr(idev, &addr, plen, scope, IFAPROT_UNSPEC);
>                 addrconf_prefix_route(&addr, plen, 0, idev->dev, 0, pflags,
>                                                                 GFP_KERNEL);
>                  return;
> }
> 
> it goes further and in this cycle hangs addresses from all interfaces on the gre
> 
> for_each_netdev(net, dev) {
>       struct in_device *in_dev = __in_dev_get_rtnl(dev);
>       if (in_dev && (dev->flags & IFF_UP)) {
>       struct in_ifaddr *ifa;
>       int flag = scope;
>       in_dev_for_each_ifa_rtnl(ifa, in_dev) {
>             addr.s6_addr32[3] = ifa->ifa_local;
>             if (ifa->ifa_scope == RT_SCOPE_LINK)
>                      continue;
>             if (ifa->ifa_scope >= RT_SCOPE_HOST) {
>                      if (idev->dev->flags&IFF_POINTOPOINT)
>                               continue;
>                      flag |= IFA_HOST;
>             }
>             add_addr(idev, &addr, plen, flag,
>                                     IFAPROT_UNSPEC);
>             addrconf_prefix_route(&addr, plen, 0, idev->dev,
>                                      0, pflags, GFP_KERNEL);
>             }
> }
> 
> Moreover, before switching to Debian 12 kernel version 6.1.15, I used
> Debian 11 on 5.10.140, and there was no error described in the commit
> https://github.com/torvalds/linux/commit/e5dd729460ca8d2da02028dbf264b65be8cd4b5f.
> One link-local address was always generated on the gre interface,
> regardless of whether the destination or the local address of the
> tunnel was specified.
> 
> Which linux distribution did you use when you found an error with the
> lack of link-local address generation on the gre interface?
> After fixing the error, only one link-local address is generated?
> I think this is a bug and most likely the problem is in generating
> dev->dev_addr, since link-local is formed from it.
> 
> I suggest solving this problem or roll back the code changes made in
> the comments above.

