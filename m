Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6499A5ACE5B
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbiIEJEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbiIEJED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:04:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D25240560;
        Mon,  5 Sep 2022 02:04:02 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t70so1772526pgc.5;
        Mon, 05 Sep 2022 02:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tIUedo3Gp+QoPuNX92HScl+5kGzWmBlWIt8drVj5myM=;
        b=n1iLbE1U7V0t6SHTmePm5vUWlyLKYEgbygLUkU6/Rp7uvtRlM2Vy/IXRhvVZ2faiey
         56bO1NU5zIxyqGGytiGzMJ5zGl09TR9m5UXpUboj3cYuJhb760sXtgC9Vsgql0xVozWY
         dS04t5u6iWeUGjKUZ9rKcLoFWNQStmXzLyA60KhnDfbWNooSRoVQvwLidlOnmmOMIV+T
         k5YUZPlW86f0K7q76J29jv94P0mXaeh/iAKU/sQHa5i3xMdpzEYcUllu9gVy7xoaXDtF
         HlkPpMvhn37EpyUd7GrsDShJwjgl02hrZlH3eMjO+JOxlwRFE46T3HxIOaUmhVgoDT/F
         M23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tIUedo3Gp+QoPuNX92HScl+5kGzWmBlWIt8drVj5myM=;
        b=p5uanva8uRXeIx/LK6vYzUW2dW4Nvr4gfDyMWWB/LR/EnScIKmfEy2sZAvUm8Lj+g6
         eKXaFqUXJLhKcxFD2qdO3NTOfcJEkHr6HscrxyL3pRSxJodFpbBkyMTVDVDOywDS3IKp
         QxbsTPpsIsy04/f2q3HXvvJ69Ganigc6Btl/wmGFx/HCY7USZ16yaQLXgyU5EClk6vNb
         TDj3L7YXE1RJ7uPH4bK1XrUOtSWIOU7O61FHtKU1+IDQW0G0Vs9Oz3uji1r2Wr6pfJvv
         wGenE28bf7t9gGgAsN5G0K2QDHYmoqF34ih1exyO3oS+Zrve45kDNx6TiKLs1rnI3CCD
         4kIA==
X-Gm-Message-State: ACgBeo3id+8LhUBiN5QZ1QAcPdUv7UZPIGtRNEd4lNSdLKfIUsj3HUHh
        CExDNLS3gpmVS6RwVBBF4NOUhnG4vlALqlApdPM=
X-Google-Smtp-Source: AA6agR4ZMPjZewSNXNkizsnySexkQUMcIlatGYRZ/e6MEJSDlQlwzhn4aGWDucTPosRtNpFhxt1ztF6cqFoOoKhT+JQ=
X-Received: by 2002:a05:6a00:1307:b0:53a:9663:1bd6 with SMTP id
 j7-20020a056a00130700b0053a96631bd6mr28026364pfu.55.1662368642066; Mon, 05
 Sep 2022 02:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220905050400.1136241-1-imagedong@tencent.com> <da8998cba112cbdea9d403052732c794f3882bd2.camel@redhat.com>
In-Reply-To: <da8998cba112cbdea9d403052732c794f3882bd2.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 5 Sep 2022 17:03:50 +0800
Message-ID: <CADxym3agY5PmVOgCKpxO8mwrCTGnJ6BNvYZUcgu0jwRJEiawHw@mail.gmail.com>
Subject: Re: [PATCH net] net: mptcp: fix unreleased socket in accept queue
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 4:26 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Mon, 2022-09-05 at 13:04 +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > The mptcp socket and its subflow sockets in accept queue can't be
> > released after the process exit.
> >
> > While the release of a mptcp socket in listening state, the
> > corresponding tcp socket will be released too. Meanwhile, the tcp
> > socket in the unaccept queue will be released too. However, only init
> > subflow is in the unaccept queue, and the joined subflow is not in the
> > unaccept queue, which makes the joined subflow won't be released, and
> > therefore the corresponding unaccepted mptcp socket will not be released
> > to.
> >
> > This can be reproduced easily with following steps:
> >
> > 1. create 2 namespace and veth:
> >    $ ip netns add mptcp-client
> >    $ ip netns add mptcp-server
> >    $ sysctl -w net.ipv4.conf.all.rp_filter=0
> >    $ ip netns exec mptcp-client sysctl -w net.mptcp.enabled=1
> >    $ ip netns exec mptcp-server sysctl -w net.mptcp.enabled=1
> >    $ ip link add red-client netns mptcp-client type veth peer red-server \
> >      netns mptcp-server
> >    $ ip -n mptcp-server address add 10.0.0.1/24 dev red-server
> >    $ ip -n mptcp-server address add 192.168.0.1/24 dev red-server
> >    $ ip -n mptcp-client address add 10.0.0.2/24 dev red-client
> >    $ ip -n mptcp-client address add 192.168.0.2/24 dev red-client
> >    $ ip -n mptcp-server link set red-server up
> >    $ ip -n mptcp-client link set red-client up
> >
> > 2. configure the endpoint and limit for client and server:
> >    $ ip -n mptcp-server mptcp endpoint flush
> >    $ ip -n mptcp-server mptcp limits set subflow 2 add_addr_accepted 2
> >    $ ip -n mptcp-client mptcp endpoint flush
> >    $ ip -n mptcp-client mptcp limits set subflow 2 add_addr_accepted 2
> >    $ ip -n mptcp-client mptcp endpoint add 192.168.0.2 dev red-client id \
> >      1 subflow
> >
> > 3. listen and accept on a port, such as 9999. The nc command we used
> >    here is modified, which makes it uses mptcp protocol by default.
> >    And the default backlog is 1:
> >    ip netns exec mptcp-server nc -l -k -p 9999
> >
> > 4. open another *two* terminal and connect to the server with the
> >    following command:
> >    $ ip netns exec mptcp-client nc 10.0.0.1 9999
> >    input something after connect, to triger the connection of the second
> >    subflow
> >
> > 5. exit all the nc command, and check the tcp socket in server namespace.
> >    And you will find that there is one tcp socket in CLOSE_WAIT state
> >    and can't release forever.
>
> Thank you for the report!
>
> I have a doubt WRT the above scenario: AFAICS 'nc' will accept the
> incoming sockets ASAP, so the unaccepted queue should be empty at
> shutdown, but that does not fit with your description?!?
>

By default, as far as in my case, nc won't accept the new connection
until the first connection closes with the '-k' set. Therefor, the second
connection will stay in the unaccepted queue.

> > There are some solutions that I thought:
> >
> > 1. release all unaccepted mptcp socket with mptcp_close() while the
> >    listening tcp socket release in mptcp_subflow_queue_clean(). This is
> >    what we do in this commit.
> > 2. release the mptcp socket with mptcp_close() in subflow_ulp_release().
> > 3. etc
> >
>
> Can you please point to a commit introducing the issue?
>

In fact, I'm not sure. In my case, I found this issue in kernel 5.10.
And I wanted to find the solution in the upstream, but find that
upstream has this issue too.

Hmm...I am curious if this issue exists in the beginning? I
can't find the opportunity that the joined subflow which are
unaccepted can be released.

> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  net/mptcp/subflow.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > index c7d49fb6e7bd..e39dff5d5d84 100644
> > --- a/net/mptcp/subflow.c
> > +++ b/net/mptcp/subflow.c
> > @@ -1770,6 +1770,10 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
> >               msk->first = NULL;
> >               msk->dl_next = NULL;
> >               unlock_sock_fast(sk, slow);
> > +
> > +             /*  */
> > +             sock_hold(sk);
> > +             sk->sk_prot->close(sk);
>
> You can call mptcp_close() directly here.
>
> Perhaps we could as well drop the mptcp_sock_destruct() hack?

Do you mean to call mptcp_sock_destruct() directly here?

>
> Perhpas even providing a __mptcp_close() variant not acquiring the
> socket lock and move such close call inside the existing sk socket lock
> above?
>

Yeah, sounds nice.

Thanks!
Menglong Dong

> Thanks,
>
> Paolo
>
