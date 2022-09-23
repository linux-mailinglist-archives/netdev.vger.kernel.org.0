Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C7C5E7C3B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiIWNtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiIWNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9CB13FB4D
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47153B81986
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA9FC433D6;
        Fri, 23 Sep 2022 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663940927;
        bh=4rlK1X1vVFturrEnfEFcq/cP19Vf9jgpzPTPJm7cviQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UqXPupIzGxfNR7gmE/0F74zB8LYt3r3hfPQ/1+pXdjEGKiNLK/3rHggln0EA9n0zu
         7gTH2DNkJbpoAnFCAvNXQtvHaBUOYWbLWK5a4fV+KIyjO4X4Iz72F0lgLDz6dZyYII
         8nBs+w6vpAov4cKR/HT0daZ4ICVxnSXskw2utxSOQBpwfqXp7XLfJqhz9dWQeQFR+C
         ZaqRgiT0lFSNGIW1M8Few1s4apQF9LBGX/QSNX2JBVkfhWFOD0Bt9EM80BFyka4rBA
         90yebUEVNHmljM6vVln057f6egTmsSgfTWEOPgOs5apmvgv7Uo+90THKKL+7uqWRIH
         St/cB7HWbShLQ==
Date:   Fri, 23 Sep 2022 06:48:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set}link
Message-ID: <20220923064845.64c9a801@kernel.org>
In-Reply-To: <5a1f51a2-3a68-54ae-69ec-51881d60b43f@6wind.com>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
        <20220921060123.1236276d@kernel.org>
        <20220921161409.GA11793@debian.home>
        <20220921155640.1f3dce59@kernel.org>
        <20220922110951.GA21605@debian.home>
        <20220922060346.280b3af8@kernel.org>
        <20220922145142.GB21605@debian.home>
        <5a1f51a2-3a68-54ae-69ec-51881d60b43f@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let me clarify one more time in case Hangbin is waiting for=20
the discussion to resolve...

On Fri, 23 Sep 2022 10:43:53 +0200 Nicolas Dichtel wrote:
> Le 22/09/2022 =C3=A0 16:51, Guillaume Nault a =C3=A9crit=C2=A0:
> > I just don't see any way to pass a handle back to user space at the
> > moment. The echo mechanism did that and was generic to all netlink
> > families (as long as nlmsg_notify() was called with the right
> > parameters).

In NEWLINK, right? In NEWLINK there is no way to pass it back=20
at the moment. A newly added command can just respond with the handle
always. The problem with NEWLINK is that it _used to_ not respond so=20
we can't make it start responding because it will confuse existing user
space.

At the protocol level NEW is no different than GET, whether it sends=20
a response back is decided by whoever implements the command.

So yes, for NEWLINK we need a way to inform the kernel that user space
wants a reply. It can be via ECHO, it could be via a new attr.

What I'm trying to argue about is *not* whether NEWLINK should support
ECHO but whether requiring ECHO to get a response for newly added
CREATE / NEW commands is a good idea. I think it is not, and new
commands should just always respond with the handle.

My main concern with using ECHO is that it breaks the one-to-one
relationship between a request and a response. There may be multiple
notifications generated due to a command, and if we want to retain=20
the "ECHO will loop back to you all resulting notifications" semantics,
which I think we should, then there can be multiple "responses".

This also has implications for the command IDs used in notifications.
A lot of modern genl families use different IDs for notifications to
make it easily distinguishable from responses.


I guess tl;dr is Hangbin should go forward with the v2, and I should
document the expectations clearly..
