Return-Path: <netdev+bounces-4426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462B670CB22
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F37222810BA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DE314AA6;
	Mon, 22 May 2023 20:34:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE91A21
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83299C433D2;
	Mon, 22 May 2023 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684787651;
	bh=0N5ujlws6muMcuISdvNwKEBan06V8ul27Fqz3m4Odnk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JV6R8zU24ZJEqo4ZBm2nq4gkyJastGUa/aWU+mkcudCYp1Fa8N+X8REo36DFPU7Bi
	 OYfy+X7+TGQDvt0uVlZTVWHx77I9faM6ACVsGs58PYMxtP0SkXqYWTo6WbBL6715fO
	 3MTLyVaRODvWKJu0gpEwSsnfuhkuQQqt2YUQWVDGlyJf4LMQ55UlXb9IsI3xKeGtro
	 Ue11yNL5WtyUwsxlVNjZUybljAstpbRoxpz8CkW0NP1YuSgN1KJsyfAyNTfLc5Tk9G
	 bunR2kzIS4AgR20jnxX3E+sjBsTp3VO+zwjn+bPEb15jvYvMUX+AnpoZcmktKE0DM/
	 +8j+ZRrF4y7xw==
Date: Mon, 22 May 2023 13:34:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>, David Ahern
 <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook
 <keescook@chromium.org>, Christian Brauner <brauner@kernel.org>, Kuniyuki
 Iwashima <kuniyu@amazon.com>, Lennart Poettering <mzxreary@0pointer.de>,
 Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230522133409.5c6e839a@kernel.org>
In-Reply-To: <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
	<20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 15:24:37 +0200 Alexander Mikhalitsyn wrote:
> v6:
> 	- disable feature when CONFIG_UNIX=n/m (pidfd_prepare API is not exported to modules)

IMHO hiding the code under #if IS_BUILTIN(CONFIG_UNRELATED) is
surprising to the user and.. ugly?

Can we move scm_pidfd_recv() into a C source and export that?
That should be less controversial than exporting pidfd_prepare()
directly?

