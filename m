Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129E96BE88B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCQLth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCQLtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:49:35 -0400
X-Greylist: delayed 1198 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Mar 2023 04:49:31 PDT
Received: from gardel.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E8A22038;
        Fri, 17 Mar 2023 04:49:31 -0700 (PDT)
Received: from gardel-login.0pointer.net (gardel-mail [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
        by gardel.0pointer.net (Postfix) with ESMTP id 2F1F1E8022C;
        Fri, 17 Mar 2023 12:12:14 +0100 (CET)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
        id 2A98A16006B; Fri, 17 Mar 2023 12:12:12 +0100 (CET)
Date:   Fri, 17 Mar 2023 12:12:12 +0100
From:   Lennart Poettering <mzxreary@0pointer.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <ZBRLDD4EWzKt0yDI@gardel-login>
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
 <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
 <CANn89i+s7TG4jqC1qanboKff=-DRmDjB-vEkoLKbEDwv195ytg@mail.gmail.com>
 <CAEivzxeXx51+R=Pws_ZDyidrNOLcyi=xfS7KR8oRebRR9H6=3g@mail.gmail.com>
 <20230317102011.2cn7gv7r7lgyylg7@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317102011.2cn7gv7r7lgyylg7@wittgenstein>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fr, 17.03.23 11:20, Christian Brauner (brauner@kernel.org) wrote:

> > > It seems that we already can use pidfd_open() (since linux-5.3), and
> > > pass the resulting fd in af_unix SCM_RIGHTS message ?

So yes, this is of course possible, but it would mean the pidfd would
have to be transported as part of the user protocol, explicitly sent
by the sender. (Moreover, the receiver after receiving the pidfd would
then still have to somehow be able to prove that the pidfd it just
received actually refers to the peer's process and not some random
process. – this part is actually solvable in userspace, but ugly)

The big thing is simply that we want that the pidfd is associated
*implicity* with each AF_UNIX connection, not explicitly. A lot of
userspace already relies on this, both in the authentication area
(polkit) as well as in the logging area (systemd-journald). Right now
using the PID field from SO_PEERCREDS/SCM_CREDENTIALS is racy though
and very hard to get right. Making this available as pidfd too, would
solve this raciness, without otherwise changing semantics of it all:
receivers can still enable the creds stuff as they wish, and the data
is then implicitly appended to the connections/datagrams the sender
initiates.

Or to turn this around: things like polkit are typically used to
authenticate arbitrary dbus methods calls: some service implements a
dbus method call, and when an unprivileged client then issues that
call, it will take the client's info, go to polkit and ask it if this
is ok. If we wanted to send the pidfd as part of the protocol we
basically would have to extend every single method call to contain the
client's pidfd along with it as an additional argument, which would be
a massive undertaking: it would change the prototypes of basically
*all* methods a service defines… And that's just ugly.

Note that Alex' patch set doesn't expose anything that wasn't exposed
before, or attach, propagate what wasn't before. All it does, is make
the field already available anyway (the struct ucred .pid field)
available also in a better way (as a pidfd), to solve a variety of
races, with no effect on the protocol actually spoken within the
AF_UNIX transport. It's a seamless improvement of the status quo.

Lennart

--
Lennart Poettering, Berlin
