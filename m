Return-Path: <netdev+bounces-4421-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4734570CA81
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 041D82810D2
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E460171DF;
	Mon, 22 May 2023 20:12:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C096171CC;
	Mon, 22 May 2023 20:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAA2C433EF;
	Mon, 22 May 2023 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684786374;
	bh=X+V0TTDz8Mqt3pN5GJ6h4caGEtPDpRHhQ5Zzn6UlqkA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XF7Ky8RmlfTLRxNETe3aUKuftCpz32Gu97nKEXJiCHaV6nJ1QMnFGNWcCfIyZg0U9
	 XmCHT1jFc3GoFeIPRoqwVU1gm9MhgRttrCsYJV7nJHGzVNXLkKTwRougMI1A4EygSp
	 RWfLvjJBnKnIzNZLq/Ct5ZqOeMjsN/Q8XFVktp6eyW5j8YOfJEkzHlA8C2IgDyraaj
	 IdsH7QPe2PqeOna8dpqhw2ZueiS1Ajun96fA0zEXVZEmin32hpTkv6+3MC56MiZkee
	 s+HGjRjexEtnTi5OUrclbykxTqRkHAghgsHueF11wWfQTlHoWaDBo4AjLJM4DwIvgm
	 IlIz1i0OJbSdQ==
Date: Mon, 22 May 2023 13:12:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Christian Brauner <brauner@kernel.org>, kernel test robot
 <lkp@intel.com>, Eric Dumazet <edumazet@google.com>, Alexander Mikhalitsyn
 <aleksandr.mikhalitsyn@canonical.com>, davem@davemloft.net,
 oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky
 <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann
 <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Lennart Poettering <mzxreary@0pointer.de>, Luca
 Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230522131252.4f9959d3@kernel.org>
In-Reply-To: <ZGtr1RwK42We5ACI@corigine.com>
References: <20230517113351.308771-2-aleksandr.mikhalitsyn@canonical.com>
	<202305202107.BQoPnLYP-lkp@intel.com>
	<20230522-sammeln-neumond-e9a8d196056b@brauner>
	<ZGtr1RwK42We5ACI@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 15:19:17 +0200 Simon Horman wrote:
> > TLI, that AF_UNIX can be a kernel module...
> > I'm really not excited in exposing pidfd_prepare() to non-core kernel
> > code. Would it be possible to please simply refuse SO_PEERPIDFD and
> > SCM_PIDFD if AF_UNIX is compiled as a module? I feel that this must be
> > super rare because it risks breaking even simplistic userspace.  
> 
> It occurs to me that it may be simpler to not allow AF_UNIX to be a module.
> But perhaps that breaks something for someone...

Both of the two options (disable the feature with unix=m, make unix
bool) could lead to breakage, I reckon at least the latter makes
the breakage more obvious? So not allowing AF_UNIX as a module
gets my vote as well.

A mechanism of exporting symbols for core/internal use only would 
find a lot of use in networking :(

