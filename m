Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB706E4BB8
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjDQOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDQOmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:42:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A5B10CF;
        Mon, 17 Apr 2023 07:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C8C661D57;
        Mon, 17 Apr 2023 14:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0820C433EF;
        Mon, 17 Apr 2023 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681742557;
        bh=vK2Mdh81hU0JcVT4r2p86moQFzFGUnlZDHXh1AzFMFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZladgrftPwmlvOxj9rleuJBtqTLN4AMElXXoPxwqYfn7tuJEKuRJH7dRYCkW+w0oA
         QVDdG7eL5O383ATdRuJn2WGuU4052SCGbkZTctH88NRChqbDXWKHUHyl3LI9UGvg4+
         U5wlN5L8QgSa9qRz6IMq/i7R5M3RPOe9JlhFjLngFNqkOSG6ZRm6y0lOhR5vPd2V4n
         sQbgGwaSSCfBS5YIsQivPArb+m9r4kLN2RbEjCVL1rAAzV8dW0Wzwn8+Vl/zq0nnr5
         Bh2sbwhk1bBx2Hmh3qN1U4TgHyV65DamYSQ9/ms0bHZ+D4C8stNY4RhW0ni4Oo9JsE
         Fs2k+f5y3kaOw==
Date:   Mon, 17 Apr 2023 16:42:30 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/4] net: socket: add sockopts blacklist for
 BPF cgroup hook
Message-ID: <20230417-wellblech-zoodirektor-76a80f7763ab@brauner>
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDoEG0VF6fb9y0EC@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 06:55:39PM -0700, Stanislav Fomichev wrote:
> On 04/13, Stanislav Fomichev wrote:
> > On Thu, Apr 13, 2023 at 7:38 AM Aleksandr Mikhalitsyn
> > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > >
> > > On Thu, Apr 13, 2023 at 4:22 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Thu, Apr 13, 2023 at 3:35 PM Alexander Mikhalitsyn
> > > > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > > > >
> > > > > During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
> > > > > that bpf cgroup hook can cause FD leaks when used with sockopts which
> > > > > install FDs into the process fdtable.
> > > > >
> > > > > After some offlist discussion it was proposed to add a blacklist of
> > > >
> > > > We try to replace this word by either denylist or blocklist, even in changelogs.
> > >
> > > Hi Eric,
> > >
> > > Oh, I'm sorry about that. :( Sure.
> > >
> > > >
> > > > > socket options those can cause troubles when BPF cgroup hook is enabled.
> > > > >
> > > >
> > > > Can we find the appropriate Fixes: tag to help stable teams ?
> > >
> > > Sure, I will add next time.
> > >
> > > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > >
> > > I think it's better to add Stanislav Fomichev to CC.
> > 
> > Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
> > use it for tcp zerocopy, I'm assuming it should work in this case as
> > well?
> 
> Jakub reminded me of the other things I wanted to ask here bug forgot:
> 
> - setsockopt is probably not needed, right? setsockopt hook triggers
>   before the kernel and shouldn't leak anything
> - for getsockopt, instead of bypassing bpf completely, should we instead
>   ignore the error from the bpf program? that would still preserve

That's fine by me as well.

It'd be great if the net folks could tell Alex how they would want this
handled.

>   the observability aspect

Please see for more details
https://lore.kernel.org/lkml/20230411-nudelsalat-spreu-3038458f25c4@brauner


> - or maybe we can even have a per-proto bpf_getsockopt_cleanup call that
>   gets called whenever bpf returns an error to make sure protocols have
>   a chance to handle that condition (and free the fd)

Installing an fd into an fdtable makes it visible to userspace at which
point calling close_fd() is doable but an absolute last resort and
generally a good indicator of misdesign. If the bpf hook wants to make
decisions based on the file then it should receive a struct
file, not an fd.
