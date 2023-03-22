Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B496C4D35
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjCVONe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCVONa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D0F20050;
        Wed, 22 Mar 2023 07:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07AC9620F9;
        Wed, 22 Mar 2023 14:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A8DC433D2;
        Wed, 22 Mar 2023 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679494403;
        bh=7GYtRL6YyPYjncnf9JpknqIQlqvrlk4HFEZjeod2l9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uk+C7lKt/qBWFBI9Grg8oad+0wbtd0WpsvOpNuFJsdL2uh9GcmaXOKuZJumrsUFU0
         P/gUERmM8WsesYP1CGhol+YKrv6HgUUfl6Xj7HsFmpJO12hAQlw6JTWr5yzskimY9s
         vvjcFj13Vn9VfwjkJ5jgCjmDYSCxnCaEtXrtvyzCEEU5BOc/VbZhSwbFMmQT4NOcjH
         kI8Oo1PvnMtxd9z3Y3X+f1Y2dfUp7EEQVkNWxjmHN2Xpa5CjYG0He4SLXPdTsvYEIj
         KjYNn16pINRJ+GrwJUY6wJEnzRhfPBEJO7gUsLlBi2k6Y5L9ujouCxfyzUITpLBDoR
         3dY1SsMvP5wVg==
Date:   Wed, 22 Mar 2023 15:13:17 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH net-next v2 0/3] Add SCM_PIDFD and SO_PEERPIDFD
Message-ID: <20230322141317.am2j6ml4rvwc5hrx@wittgenstein>
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 07:33:39PM +0100, Alexander Mikhalitsyn wrote:
> 1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.
> 
> 2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> 
> 3. Add SCM_PIDFD / SO_PEERPIDFD kselftest
> 
> Idea comes from UAPI kernel group:
> https://uapi-group.org/kernel-features/
> 
> Big thanks to Christian Brauner and Lennart Poettering for productive
> discussions about this.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> 
> Alexander Mikhalitsyn (3):
>   scm: add SO_PASSPIDFD and SCM_PIDFD
>   net: core: add getsockopt SO_PEERPIDFD
>   selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
> 
>  arch/alpha/include/uapi/asm/socket.h          |   3 +
>  arch/mips/include/uapi/asm/socket.h           |   3 +
>  arch/parisc/include/uapi/asm/socket.h         |   3 +
>  arch/sparc/include/uapi/asm/socket.h          |   3 +
>  include/linux/net.h                           |   1 +
>  include/linux/socket.h                        |   1 +
>  include/net/scm.h                             |  14 +-
>  include/uapi/asm-generic/socket.h             |   3 +
>  net/core/sock.c                               |  32 ++
>  net/mptcp/sockopt.c                           |   1 +
>  net/unix/af_unix.c                            |  18 +-
>  tools/include/uapi/asm-generic/socket.h       |   3 +
>  tools/testing/selftests/net/.gitignore        |   1 +
>  tools/testing/selftests/net/af_unix/Makefile  |   3 +-
>  .../testing/selftests/net/af_unix/scm_pidfd.c | 336 ++++++++++++++++++
>  15 files changed, 417 insertions(+), 8 deletions(-)
>  create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

What's the commit for this work? Because this seems to fail to apply
cleanly on anything from v6.3-rc1 until v6.3-rc3.

