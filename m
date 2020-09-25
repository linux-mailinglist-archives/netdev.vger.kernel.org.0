Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5003277E40
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 04:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgIYCyX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Sep 2020 22:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgIYCyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 22:54:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EBAC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 19:54:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBE43135F7AF2;
        Thu, 24 Sep 2020 19:37:32 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:54:19 -0700 (PDT)
Message-Id: <20200924.195419.900096450603641906.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com, lorenzo@google.com, sgill@quicinc.com,
        vparadka@qti.qualcomm.com, twear@quicinc.com, dsahern@kernel.org
Subject: Re: [PATCH v3] net/ipv4: always honour route mtu during forwarding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923201815.388347-1-zenczykowski@gmail.com>
References: <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
        <20200923201815.388347-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:37:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Wed, 23 Sep 2020 13:18:15 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> Documentation/networking/ip-sysctl.txt:46 says:
>   ip_forward_use_pmtu - BOOLEAN
>     By default we don't trust protocol path MTUs while forwarding
>     because they could be easily forged and can lead to unwanted
>     fragmentation by the router.
>     You only need to enable this if you have user-space software
>     which tries to discover path mtus by itself and depends on the
>     kernel honoring this information. This is normally not the case.
>     Default: 0 (disabled)
>     Possible values:
>     0 - disabled
>     1 - enabled
> 
> Which makes it pretty clear that setting it to 1 is a potential
> security/safety/DoS issue, and yet it is entirely reasonable to want
> forwarded traffic to honour explicitly administrator configured
> route mtus (instead of defaulting to device mtu).
> 
> Indeed, I can't think of a single reason why you wouldn't want to.
> Since you configured a route mtu you probably know better...
> 
> It is pretty common to have a higher device mtu to allow receiving
> large (jumbo) frames, while having some routes via that interface
> (potentially including the default route to the internet) specify
> a lower mtu.
> 
> Note that ipv6 forwarding uses device mtu unless the route is locked
> (in which case it will use the route mtu).
> 
> This approach is not usable for IPv4 where an 'mtu lock' on a route
> also has the side effect of disabling TCP path mtu discovery via
> disabling the IPv4 DF (don't frag) bit on all outgoing frames.
> 
> I'm not aware of a way to lock a route from an IPv6 RA, so that also
> potentially seems wrong.
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied and queued up for -stable, thank you.
