Return-Path: <netdev+bounces-4811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A3A70E727
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 23:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FA261C20A54
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 21:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55906BA42;
	Tue, 23 May 2023 21:08:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2789465
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 21:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B732C433EF;
	Tue, 23 May 2023 21:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684876126;
	bh=t4leSM84mfYsgogyyDTg6ovfFaEJHHtHZJXOO19zbLs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ucDXjYViKyH2WU35ZLkIAGU/3peB1OBW0tLipFJolAd84E5J+l51ss5bL0x9W7k5N
	 I9gLNb1xrKkiqEmPbtGz7tv2q9xj8E8f8VOL5ZpFtswDPFhbgaakPAD79m6Kcn3p7y
	 DfdrvwuXoRBhTut4Xs/c5Z/zi2GbzoSfck7KK9nFyoIEPoJlDhNnOhOsPjAW8qFw31
	 hCRLi7M/TV7haEgMMEQ23HkpvyPN66iT4y9e9djI57Jc6ejIiWKIEDzMYMRsCZFr9V
	 WLPs+i22UEw/hxO6qnuDIKkhAXyyV0ESeJLlLMzFU8K6X4cdJnWAKaE6ECIwXozxGs
	 b3dFyJoeeq9VA==
Date: Tue, 23 May 2023 14:08:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Luca Boccassi <bluca@debian.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Mikhalitsyn
 <aleksandr.mikhalitsyn@canonical.com>, davem@davemloft.net,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky
 <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann
 <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Lennart Poettering <mzxreary@0pointer.de>,
 linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230523140844.5895d645@kernel.org>
In-Reply-To: <CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
	<20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
	<20230522133409.5c6e839a@kernel.org>
	<20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
	<CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 11:44:01 +0100 Luca Boccassi wrote:
> > I really would like to avoid that because it will just mean that someone
> > else will abuse that function and then make an argument why we should
> > export the other function.
> >
> > I think it would be ok if we required that unix support is built in
> > because it's not unprecedented either and we're not breaking anything.
> > Bpf has the same requirement:
> >
> >   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
> >   struct bpf_unix_iter_state {
> >           struct seq_net_private p;
> >           unsigned int cur_sk;
> >           unsigned int end_sk;
> >           unsigned int max_sk;
> >           struct sock **batch;
> >           bool st_bucket_done;
> >   };
> >
> > and
> >
> >   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
> >   DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
> >                        struct unix_sock *unix_sk, uid_t uid)  

Don't think we should bring BPF into arguments about uAPI consistency :S

> Some data points: Debian, Ubuntu, Fedora, RHEL, CentOS, Archlinux all
> ship with CONFIG_UNIX=y, so a missing SCM_PIDFD in unlikely to have a
> widespread impact, and if it does, it might encourage someone to
> review their kconfig.

IDK how you can argue that everyone sets UNIX to =y so hiding SCM_PIDFD
is fine and at the same time not be okay with making UNIX a bool :S

> As mentioned on the v5 thread, we are waiting for this API to get the
> userspace side sorted (systemd/dbus/dbus-broker/polkit), so I'd be
> really grateful if we could start with the simplest and most
> conservative approach (which seems to be the current one in v6 to me),
> and then eventually later decide whether to export more functions, or
> to deprecate CONFIG_UNIX=m, or something else entirely, as that
> doesn't really affect the shape of the UAPI, just the details of its
> availability. Thank you.

Just throw in a patch to make UNIX a bool and stop arguing then.

