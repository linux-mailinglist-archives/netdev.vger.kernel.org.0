Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E96E48CF11
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiALXXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:23:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47766 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiALXXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:23:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E271C61B72
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 23:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73E2C36AE9;
        Wed, 12 Jan 2022 23:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642029822;
        bh=7DX/kGA5Y+x+fQPe3xPpp5Mrcwlh79IaMjWWUzHdWHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tikLky1/vmZUUHbDpNXHXU5fcq8v1/3ntWGl3da6inLacdvB7MzODI+q7OgLSdY2B
         lnz/Bg/wGpQRaQJ/WI8GHTWBaZvqha03kOK3d6soA2PzdNaSM2a7RZ3rtEbS9kBAwy
         uZR1vxKUGr5iLtLN3sPDwiFvg2gj+6R57Kaz2S0xI/ELTqY6FMMt73uqEpwQy/ODeu
         IHaJWlalLahMXZ3KqNCsDIhBgv14sRMDB/WaxKSqWxE7sIGTihjsC7BRDNDrzFew6W
         cWvoAS0/sIvZW+yfFtuEbgdFIUlSaG5kLRHYfJA4ST2aUhHsWnv0YZOytuT4b76RXC
         412FzNGnjTeXQ==
Date:   Wed, 12 Jan 2022 15:23:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@cloudflare.com,
        Amir Razmjou <arazmjou@cloudflare.com>
Subject: Re: [PATCH] sit: allow encapsulated IPv6 traffic to be delivered
 locally
Message-ID: <20220112152340.4906baf8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <446f3303-d520-7353-713e-baf213c2ed2e@gmail.com>
References: <20220107123842.211335-1-ignat@cloudflare.com>
        <446f3303-d520-7353-713e-baf213c2ed2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 12:59:37 -0700 David Ahern wrote:
> On 1/7/22 5:38 AM, Ignat Korchagin wrote:
> > While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
> > traffic fails to be delivered, if the peer IP address is configured locally.
> > 
> > It can be easily verified by creating a sit interface like below:
> > 
> > $ sudo ip link add name fou_test type sit remote 127.0.0.1 encap fou encap-sport auto encap-dport 1111
> > $ sudo ip link set fou_test up
> > 
> > and sending some IPv4 and IPv6 traffic to it
> > 
> > $ ping -I fou_test -c 1 1.1.1.1
> > $ ping6 -I fou_test -c 1 fe80::d0b0:dfff:fe4c:fcbc
> > 
> > "tcpdump -i any udp dst port 1111" will confirm that only the first IPv4 ping
> > was encapsulated and attempted to be delivered.
> > 
> > This seems like a limitation: for example, in a cloud environment the "peer"
> > service may be arbitrarily scheduled on any server within the cluster, where all
> > nodes are trying to send encapsulated traffic. And the unlucky node will not be
> > able to. Moreover, delivering encapsulated IPv4 traffic locally is allowed.
> > 
> > But I may not have all the context about this restriction and this code predates
> > the observable git history.
> > 
> > Reported-by: Amir Razmjou <arazmjou@cloudflare.com>
> > Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
