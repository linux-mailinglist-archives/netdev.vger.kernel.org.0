Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC6056932B
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiGFURj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiGFURi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:17:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6671CFF3
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 13:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D5E620CB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE60C3411C;
        Wed,  6 Jul 2022 20:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657138657;
        bh=jeKWvyF+EPnn3TUzP8ol+sOVtSEC54D/FsU0Imat2y4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AmigoYQmU3jHoVrkSH11jWfSFoNjXdsIW1paPLa/luSqsFwCk+WAi0rq6nEJwrqfK
         pAbV4i9qA0SWzuDxB/ur4SUrE5tpslQopiZoZLNZkF6k15s0yUqyc5Y7RzZB4caOjZ
         PnPNaNFOHMNg1iZ/Cz+ryoUJ66/GF+9pNX6tESZWqBcgXuKIMGW3nM5Tqu0q3QetQh
         qDedi6WeoEB+tqvJkPZZ/kykTsHdumHrZ42H3adKp2HPml4v8DGrYqcc6nIjAKyO31
         CoGK54us7hvWyma+aW7SfbEZx63e/f4SaRL+xFtuhEUmNd64OEyfHXCzFbaq9v0HhT
         MMqOz+uJSVhBw==
Date:   Wed, 6 Jul 2022 13:17:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias May <matthias.may@westermo.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated
 IP frames
Message-ID: <20220706131735.4d9f4562@kernel.org>
In-Reply-To: <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
        <20220705182512.309f205e@kernel.org>
        <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 09:07:36 +0200 Matthias May wrote:
> >> The current code allows to inherit the TOS, TTL, DF from the payload
> >> when skb->protocol is ETH_P_IP or ETH_P_IPV6.
> >> However when the payload is VLAN encapsulated (e.g because the tunnel
> >> is of type GRETAP), then this inheriting does not work, because the
> >> visible skb->protocol is of type ETH_P_8021Q.
> >>
> >> Add a check on ETH_P_8021Q and subsequently check the payload protocol.  
> > 
> > Do we need to check for 8021AD as well?
> 
> Yeah that would make sense.
> I can add the check for ETH_P_8021AD in v2.
> Will have to find some hardware that is AD capable to test.

Why HW, you should be able to test with two Linux endpoints, no?

> >> Signed-off-by: Matthias May <matthias.may@westermo.com>
> >> ---
> >>   net/ipv4/ip_tunnel.c | 21 +++++++++++++--------  
> > 
> > Does ipv6 need the same treatment?  
> 
> I don't think i changed anything regarding the behaviour for ipv6
> by allowing to skip from the outer protocol to the payload protocol.

Sorry, to be clear what I meant - we try to enforce feature parity for
IPv6 these days in Linux. So I was asking if ipv6 needs changes to be
able to deal with VLANs. I think you got that but just in case.

> The previous code already
> * got the TOS via ipv6_get_dsfield,
> * the TTL was derived from the hop_limit,
> * and DF does not exist for ipv6 so it doesn't check for ETH_P_IPV6.

Purely by looking at the code I thought that VLAN-enabled GRETAP frames
would fall into ip6gre_xmit_other() which passes dsfield=0 into
__gre6_xmit(). key->tos only overrides the field for "external" tunnels, 
not normal tunnels with a dedicated netdev per tunnel.

A selftest to check both ipv4 and ipv6 would be the ultimate win there.
