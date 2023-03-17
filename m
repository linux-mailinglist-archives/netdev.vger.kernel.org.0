Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A256BE67C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 11:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjCQKUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 06:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCQKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 06:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706313FB8F;
        Fri, 17 Mar 2023 03:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3A16222D;
        Fri, 17 Mar 2023 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957E3C433D2;
        Fri, 17 Mar 2023 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679048417;
        bh=3kO5aavn20pRd6T/BnfAZNIDQYJTPBi56iyxaCeDH38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vn7jq9AbkHQpEfF0NajnVkhbJBwbKwFv2NrW3hncAMbjBGV8uoywdZOpLgZEId4bv
         PyyiOmyL5fPi5AB1IK4FKxqvefzCPFrCEF/ue0z4YrLq1pda/jjXQAEInj0KU8wm3D
         lex0AJ3pwc7ow3/UVzDhFutbU5y+GQHGaLh2qmMgmhfboTLVQogEUStyZa75U1Tq3Q
         owlqqNXh7FUFQuKgAZuMUlwwbnSRl2D9oD2xcwrE87a3j+Qxp/vCgXWS67CgdxbmOe
         d1TodGbEoGjF8yDleyIHQOHUCU6KK1UCba/kz0T5K/u1HolJgeASeG5tWB0KAs8kSt
         3R5uD2mkoGF6g==
Date:   Fri, 17 Mar 2023 11:20:11 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230317102011.2cn7gv7r7lgyylg7@wittgenstein>
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
 <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
 <CANn89i+s7TG4jqC1qanboKff=-DRmDjB-vEkoLKbEDwv195ytg@mail.gmail.com>
 <CAEivzxeXx51+R=Pws_ZDyidrNOLcyi=xfS7KR8oRebRR9H6=3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEivzxeXx51+R=Pws_ZDyidrNOLcyi=xfS7KR8oRebRR9H6=3g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:32:03PM +0100, Aleksandr Mikhalitsyn wrote:
> On Thu, Mar 16, 2023 at 3:34 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Mar 16, 2023 at 6:16 AM Alexander Mikhalitsyn
> > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > >
> > > Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> > > but it contains pidfd instead of plain pid, which allows programmers not
> > > to care about PID reuse problem.
> >
> > Hi Alexander
> 
> Hi Eric
> 
> Thanks for the fast reply! ;-)
> 
> >
> > This would add yet another conditional in af_unix fast path.
> >
> > It seems that we already can use pidfd_open() (since linux-5.3), and
> > pass the resulting fd in af_unix SCM_RIGHTS message ?
> 
> Yes, it's possible, but it means that from the receiver side we need
> to trust the sent pidfd (in SCM_RIGHTS),
> or always use combination of SCM_RIGHTS+SCM_CREDENTIALS, then we can
> extract pidfd from SCM_RIGHTS,
> then acquire plain pid from pidfd and after compare it with the pid
> from SCM_CREDENTIALS.
> 
> >
> > If you think this is not suitable, it should at least be mentioned in
> > the changelog.

Let me try and provide some of the missing background.

There are a range of use-cases where we would like to authenticate a
client through sockets without being susceptible to PID recycling
attacks. Currently, we can't do this as the race isn't fully fixable.
We can only apply mitigations.

What this patchset will allows us to do is to get a pidfd without the
client having to send us an fd explicitly via SCM_RIGHTS. As that's
already possibly as you correctly point out.

But for protocols like polkit this is quite important. Every message is
standalone and we would need to force a complete protocol change where
we would need to require that every client allocate and send a pidfd via
SCM_RIGHTS. That would also mean patching through all polkit users.

For something like systemd-journald where we provide logging facilities
and want to add metadata to the log we would also immensely benefit from
being able to get a receiver-side controlled pidfd.

With the message type we envisioned we don't need to change the sender
at all and can be safe against pid recycling.

Link: https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/154
Link: https://uapi-group.org/kernel-features
