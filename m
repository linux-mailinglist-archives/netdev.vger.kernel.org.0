Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCC54C19F3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiBWRiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiBWRiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:38:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744AC6242;
        Wed, 23 Feb 2022 09:37:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6D1B61381;
        Wed, 23 Feb 2022 17:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD0CC340E7;
        Wed, 23 Feb 2022 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645637871;
        bh=Okm5ikpIqu6C888lmXJ1Nz52yJBp2pGvTixiTk0zlZ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZjheHihqnT5OjGKK7REeyBqKOZF5Us3zcTAo092EDrHdggsO0QouNyeiFMCZEC8ch
         HiZht0O5gZcAuU7TyhJXiKxNmNkxHMVR1IWXeriTSskojPuqEp44DXO3EJ+XAsaU3j
         M1WNfXv1+wrLPajG1TCMlq9djxeRiAg+KBnxYkjQPPyLQ5XBPlZzx+cfh7TpBMXGN/
         mlf/uE8XAIMxRDkxEX7w92WXv4cYmCLDEcx+9z9KoQaonq8BRcKq5WWCzC7R2V8hDj
         1afYMzSACpKd7WD0eqmHvyaa5Xtvpq2m3ZbRWGZ5xO6lxx5r6DF7NUrCj72IoVDG0Q
         vlxBL48wjPwaA==
Date:   Wed, 23 Feb 2022 09:37:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
Message-ID: <20220223093749.6b33345a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223165836.GC19531@debian.home>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
        <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
        <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
        <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
        <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
        <20220222103733.GA3203@debian.home>
        <20220222152815.1056ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220223112618.GA19531@debian.home>
        <20220223080342.5cdd597c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220223165836.GC19531@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 17:58:36 +0100 Guillaume Nault wrote:
> On Wed, Feb 23, 2022 at 08:03:42AM -0800, Jakub Kicinski wrote:
> > I meant
> > 
> >   ip link set dev vlan0 mtu-policy blah
> > 
> > but also
> > 
> >   ip link set dev bond0 mtu-policy blah
> > 
> > and
> > 
> >   ip link set dev macsec0 mtu-policy blah2
> >   ip link set dev vxlan0 mtu-policy blah2
> > 
> > etc.  
> 
> Unless I'm missing something, that looks very much like what I proposed
> (these are all ARPHRD_ETHER devices). It's just a bit unclear whether
> "ip link set dev vlan0 mtu-policy blah" applies to vlan0 or to the vlans
> that might be stacked on top of it (given your other examples, I assume
> it's the later).

No, sorry I thought it would be clear, we need that neuralink ;)
It applies to the device on which it's configured. What I mean
is that bond, macsec, mpls etc have the same "should it follow 
the MTU of the lower device" problem, it's not vlan specific.
Or am I wrong about that?

> > To be honest I'm still not clear if this is a real problem.
> > The patch does not specify what the use case is.  
> 
> It's probably not a problem as long as we keep sane behaviour by
> default. Then we can let admins opt in for something more complex or
> loosely defined.

What I meant was - does anyone actually flip the MTU of their
interfaces back and forth while the system is running. Maybe
people do.
