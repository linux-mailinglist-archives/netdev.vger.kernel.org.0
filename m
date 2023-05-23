Return-Path: <netdev+bounces-4624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE7F70D982
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEAC71C20D34
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD6B1E522;
	Tue, 23 May 2023 09:49:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21C71DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9FDC433EF;
	Tue, 23 May 2023 09:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684835357;
	bh=F/kNVB79mMMqUME2ygzIJRbu7qcW7y1FnAv1mRYfEH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AOY3svIebr1ZJz2DqCK1GD5W8HSGiLHYu7cLu4k20tmfrNp44PHB3dNw9SHjv4LPJ
	 xeeilKV/n25FpF6uSKFm14nsNYHvq1zbs//3T6Fq4+Xc6GMybkU+eIeMw1DIqeyMGg
	 T0oF3ExydPAIHEewvW9crtw9QS9VdHZocJugetsBMpAbfPbreCHUqcYCIZkIAM0YTi
	 fj0scCGwt87RkMtSthHiZj3B7NfEoJInXpFLl7H52CVwm3e740LSOwMsd5Rfy0y/kq
	 HQ6Q7EJaQYbiFU0Bzj6q9nGN+z5Od1pc7eBUT1jSmPuWnHxwMqIJxW68T3Uzkt225D
	 QDfgj5jJeluHg==
Date: Tue, 23 May 2023 11:49:10 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
 <20230522133409.5c6e839a@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230522133409.5c6e839a@kernel.org>

On Mon, May 22, 2023 at 01:34:09PM -0700, Jakub Kicinski wrote:
> On Mon, 22 May 2023 15:24:37 +0200 Alexander Mikhalitsyn wrote:
> > v6:
> > 	- disable feature when CONFIG_UNIX=n/m (pidfd_prepare API is not exported to modules)
> 
> IMHO hiding the code under #if IS_BUILTIN(CONFIG_UNRELATED) is
> surprising to the user and.. ugly?
> 
> Can we move scm_pidfd_recv() into a C source and export that?
> That should be less controversial than exporting pidfd_prepare()
> directly?

I really would like to avoid that because it will just mean that someone
else will abuse that function and then make an argument why we should
export the other function.

I think it would be ok if we required that unix support is built in
because it's not unprecedented either and we're not breaking anything.
Bpf has the same requirement:

  #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
  struct bpf_unix_iter_state {
          struct seq_net_private p;
          unsigned int cur_sk;
          unsigned int end_sk;
          unsigned int max_sk;
          struct sock **batch;
          bool st_bucket_done;
  };

and

  #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
  DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
                       struct unix_sock *unix_sk, uid_t uid)

