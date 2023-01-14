Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5AA66A96C
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjANFdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjANFdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:33:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CB835BC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 21:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6715BB82206
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF16C433EF;
        Sat, 14 Jan 2023 05:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673674389;
        bh=V2J0undbCH57Ac05L3X6NtjLOWMcZ8xHoUbIF3MosD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=low3nAgGVdo3pwhsEakdaDVGySOai4t1OdIRPoKUVmZqs676bmkTtzBu0FtusPnjs
         pNjM1pJCmQpDFLWXBy8nyToEfCd0ZbiOaf8Ev+g8Vsf2iqiDWUadIK7WuJDdBJ52Is
         DGE/+TezvBbsFVQkDgh+8+2aSuC/a3FlbZQhmof9dwPxWrarzduTR1+Lau3Ou2EYny
         YXZHlqQqLFgKZDZxRPZzkXdu0Jir2J+TGti8GlW12K6Ap7UJELP6VqGjppQPvYX1Qw
         34wC4l73oga3PI1owayDLNZuxyGgVvHgutX0X/GbMatdNrN0TnzgMrOYoHq9sQzcbo
         TyMrJLQAuz3Yg==
Date:   Fri, 13 Jan 2023 21:33:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv2 net 1/2] ipv6: prevent only DAD and RS sending for
 IFF_NO_ADDRCONF
Message-ID: <20230113213307.17c32270@kernel.org>
In-Reply-To: <f29babd921a1842b7f953c56175cf2cd2abe7bc8.1673483994.git.lucien.xin@gmail.com>
References: <cover.1673483994.git.lucien.xin@gmail.com>
        <f29babd921a1842b7f953c56175cf2cd2abe7bc8.1673483994.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 19:41:56 -0500 Xin Long wrote:
> So instead of preventing all the ipv6 addrconf, it makes more sense to
> only prevent DAD and RS sending for the slave ports: Firstly, check
> IFF_NO_ADDRCONF in addrconf_dad_completed() to prevent RS as it did in
> commit b52e1cce31ca ("ipv6: Don't send rs packets to the interface of
> ARPHRD_TUNNEL"), and then also check IFF_NO_ADDRCONF where IFA_F_NODAD
> is checked to prevent DAD.

Maybe it's because I'm not an ipv6 expert but it feels to me like we're
getting into intricate / hacky territory. IIUC all addresses on legs of
bond/team will silently get nodad behavior? Isn't that risky for a fix?

Could we instead revert 0aa64df30b38 and take this via net-next?

Alternatively - could the team user space just tell the kernel what
behavior it wants? Instead of always putting the flag up, like we did 
in 0aa64df30b3, do it only when the user space opts in?
