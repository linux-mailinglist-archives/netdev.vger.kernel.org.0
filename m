Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30756CB42
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 21:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGITX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 15:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGITXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 15:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C7515A10
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 12:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0324DB806A0
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 19:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3051DC3411C;
        Sat,  9 Jul 2022 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657394601;
        bh=0D6oFHqU+zFv3pjPrUJqqWWAIeXMFm2WwgHxERu24yQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DFz0q9ylgzaCjgQTf6icDW9WBR7peMlE6kjaIl8AYDkSAMwzeO+ryhT2GK093j1RJ
         JqCHbYqHQHHwh3ZlMxWfdw5PJY1DOQpdjqIZVPFaNfcrT4+qgrOyKkFAGikcardzHw
         bBx/7X0V18Xhn6byaxbvY+1nUXQOeGtemaig7i4OeSAPIXgdqedbCT9dqqYRbHMVkR
         qAJ6zpfYkoTfAImoeld/Yt3yjcCN3ohY1H0WpVs/5m3bpiF9TZ3O3g3k5m0w+UGk/3
         0sQ5etP0WkMMLILGPL/TC6dN/d4FvqNCV4XVC75XzSz6No1tMwln47fBXkT3Qjg/en
         kNo2lG3SUheQQ==
Date:   Sat, 9 Jul 2022 12:23:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next v5] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <20220709122320.7ecc9621@kernel.org>
In-Reply-To: <Ysl4TPkTNW+6JPj4@eidolon.nox.tf>
References: <20220707093336.214658-1-equinox@diac24.net>
        <20220708202951.46d3454a@kernel.org>
        <Ysl4TPkTNW+6JPj4@eidolon.nox.tf>
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

On Sat, 9 Jul 2022 14:45:00 +0200 David Lamparter wrote:
> > > +	err = ip6mr_rtm_valid_getroute_req(in_skb, nlh, tb, extack);
> > > +	if (err < 0)
> > > +		goto errout;  
> > 
> > Can we:
> > 
> > 		return err;
> > 
> > ? I don't know where the preference for jumping to the return statement
> > came from, old compilers? someone's "gut feeling"?  
> 
> If I were forced to find a justification, I'd say having a central
> sequence of exit helps avoiding mistakes when some other resource
> acquisition is added later.  Easy to add a cleanup call to an existing
> cleanup block - easy to overlook a "return err;" that needs to be
> changed to "goto errout;".

That only works if the label's name is meaningless, if the label is
named after what it points to you have to rename the label and all the
jumps anyway. Can as well replace returns with a goto.

> But I have absolutely no stake in this at all, I'll happily edit it to
> whatever the consensus is.  This is just what the IPv4 code looks like
> after being adapted for IPv6.

Ah, I looked around other getroute implementations but not specifically
ipmr. I'd rather refactor ipmr.c as well than keep its strangeness.
The fact that we jump to the error path which tries to free the skb
without ever allocating the skb feels particularly off.
