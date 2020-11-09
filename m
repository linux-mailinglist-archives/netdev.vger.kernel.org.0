Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65102AC990
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgKJAAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJAAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 19:00:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E9E6206ED;
        Mon,  9 Nov 2020 23:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604966400;
        bh=J4pDKkXNp2Y5H5jh93pio6tF7sDidvKSpRVwQ9Qn6Kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ymA7p9KhYx/9VvBMG9uGRsWTb/0LuFnNn85Gg1mubbrUEotG9Ka5viBdJ5ZAVbLRa
         rDe345kxoGT9j2admzKd6hysRxZivK4vXiJUOXcQBFc+8YQLuOMV91RNPOc9OpwAm8
         gWO5qFEHWONKtYZC+EViBRIJHeVtdjfnQHsOO02Y=
Date:   Mon, 9 Nov 2020 15:59:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Jianlin Shi <jishi@redhat.com>, David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Aaron Conole <aconole@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] tunnels: Fix off-by-one in lower MTU bounds for
 ICMP/ICMPv6 replies
Message-ID: <20201109155958.0ea7df75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4f5fc2f33bfdf8409549fafd4f952b008bf04d63.1604681709.git.sbrivio@redhat.com>
References: <4f5fc2f33bfdf8409549fafd4f952b008bf04d63.1604681709.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 17:59:52 +0100 Stefano Brivio wrote:
> Jianlin reports that a bridged IPv6 VXLAN endpoint, carrying IPv6
> packets over a link with a PMTU estimation of exactly 1350 bytes,
> won't trigger ICMPv6 Packet Too Big replies when the encapsulated
> datagrams exceed said PMTU value. VXLAN over IPv6 adds 70 bytes of
> overhead, so an ICMPv6 reply indicating 1280 bytes as inner MTU
> would be legitimate and expected.
> 
> This comes from an off-by-one error I introduced in checks added
> as part of commit 4cb47a8644cc ("tunnels: PMTU discovery support
> for directly bridged IP packets"), whose purpose was to prevent
> sending ICMPv6 Packet Too Big messages with an MTU lower than the
> smallest permissible IPv6 link MTU, i.e. 1280 bytes.
> 
> In iptunnel_pmtud_check_icmpv6(), avoid triggering a reply only if
> the advertised MTU would be less than, and not equal to, 1280 bytes.
> 
> Also fix the analogous comparison for IPv4, that is, skip the ICMP
> reply only if the resulting MTU is strictly less than 576 bytes.
> 
> This becomes apparent while running the net/pmtu.sh bridged VXLAN
> or GENEVE selftests with adjusted lower-link MTU values. Using
> e.g. GENEVE, setting ll_mtu to the values reported below, in the
> test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() test
> function, we can see failures on the following tests:
> 
>              test                | ll_mtu
>   -------------------------------|--------
>   pmtu_ipv4_br_geneve4_exception |   626
>   pmtu_ipv6_br_geneve4_exception |  1330
>   pmtu_ipv6_br_geneve6_exception |  1350
> 
> owing to the different tunneling overheads implied by the
> corresponding configurations.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied, thanks.
