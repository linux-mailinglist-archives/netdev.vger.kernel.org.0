Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C2B6E76C5
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjDSJve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjDSJvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18070118C2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7F7D63D51
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D4C433A7;
        Wed, 19 Apr 2023 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681897889;
        bh=fUyVpG8pezXm0v1MCtm3/3Q56kst+kLoCLx2uTU3W08=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=UcXq/6RoutYQX1Zqt3qIsDrV93xaS7EerZnO7u2A+wOxnM0Tws7WHu5ihKsfC1+yW
         Ia2+eI/pXTu/9kUknQkgyepc82a631H/VUU2Ohyynl0koWj4ZLDNR8d6vdn31nzaw+
         Am5P+hviQJ+aUyGuJOCX2dd1RhEFU0gnp9vsj/cNXlya3jlEHVWb0F8MfCjtfW2Ng4
         1Eg9HgC/gUGs6zHbpvBsm7Tg0G4IvEpzc/pE7/Ka4qpGNjjisI2FOf597VV7DiFvc8
         1tlEgfadD/dco9fbdMrnEP2txUarwX7a4Wcfb/6UmDvycGDU4N/qOCjdBO5SDS0mkP
         7vl2tyWEITR+A==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E647BAA8817; Wed, 19 Apr 2023 11:51:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Robert Landers <landers.robert@gmail.com>, netdev@vger.kernel.org
Subject: Re: Maybe a bug with adding default routes?
In-Reply-To: <CAPzBOBNKPYFwm5Fq9hvEPPVk7RHjzPOO5gpnVXeT-2dgk_f69Q@mail.gmail.com>
References: <CAPzBOBNKPYFwm5Fq9hvEPPVk7RHjzPOO5gpnVXeT-2dgk_f69Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 19 Apr 2023 11:51:25 +0200
Message-ID: <878reourmq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Landers <landers.robert@gmail.com> writes:

> Hello netdev,
>
> I believe I either found a bug, or I'm doing something wrong (probably
> the latter, or both!). I was experimenting with getting a "floating
> IP" for my home lab, and eventually, I got it to work, but it requires
> some voodoo, which intrigued me and I think I found some strange
> behavior that smells like a bug. I'm on Ubuntu 22.04 (and Pop OS! on
> my desktop), so it is also possible that this is fixed upstream (in
> which case, I'll email that list next).
>
> To reproduce is quite simple:
>
> echo "1234 test" >> /etc/iproute2/rt_tables
> ip route add default via 167.235.212.73 dev enp9s0 table test
>
> This will fail with the error:
>
> Error: Nexthop has invalid gateway.
>
> Now, I think this makes sense, however, the routing table shouldn't
> need to know about hops, Right? Maybe I'm wrong, but this voodoo
> results in a correct routing table:
>
> ip addr add 167.235.212.72/29 dev enp9s0
> ip route add default via 167.235.212.73 dev enp9s0 table test
> ip addr del 167.235.212.72/29 dev enp9s0
>
> I'm not sure if this is a bug or working as designed. It smells like a
> bug, but I could just as easily be doing something wrong. I grew up in
> "simpler" times and am not nearly as familiar with iproute2 as I was
> with the old stuff.

Try the 'onlink' flag:

ip route add default via 167.235.212.73 dev enp9s0 onlink table test

-Toke
