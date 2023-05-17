Return-Path: <netdev+bounces-3467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C50470745E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F4CB1C2091F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4579C107B6;
	Wed, 17 May 2023 21:34:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358C933F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:34:47 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B304496;
	Wed, 17 May 2023 14:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=H2c6uRb95qpElPmZyz5hJS7ZREoAr6SQ6O2hH5vnwIA=;
	t=1684359286; x=1685568886; b=hewDQxWcuLXS0utycf/O9EqKnTv+Yy8TVw6Sp1RE8+uctXa
	PvXBlJjz1MVyk3HRK7Wx2IBGKoersVyo83tqv5SbfxsbYRPnZ593epQLUocW/PEPYKF1fXUflJyPN
	PkZ6fLUXFyHx+6aXcEi/50ZirHQyiysyJCtbMUu4iXga4zhFou53+ExOndnKD9rz2jE0PnaBLCV1s
	LlB+Og9h4+Ocf43ijW2EAIjpUwDWm+7yEr/jmdlsHFC4bSvS+Xws2G6ebCD9cO7OKJtbaE5NZz7S4
	JNIMsS2ne6Z10DnyO5JKaPTw9VZAVgbyrfazvcj3Sc4qO7v8HggKwhprHGoHocpg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1pzOnC-00D3gi-16;
	Wed, 17 May 2023 23:34:42 +0200
Message-ID: <056e71bd6a06779bfcb1ef4518a2f67f67730fe7.camel@sipsolutions.net>
Subject: Re: [PATCH v5 1/1] wifi: mac80211: fortify the spinlock against
 deadlock by interrupt
From: Johannes Berg <johannes@sipsolutions.net>
To: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Leon Romanovsky <leonro@nvidia.com>
Date: Wed, 17 May 2023 14:34:38 -0700
In-Reply-To: <20230517213101.25617-1-mirsad.todorovac@alu.unizg.hr>
References: <20230517213101.25617-1-mirsad.todorovac@alu.unizg.hr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>=20
> Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
> Link: https://lore.kernel.org/all/1f58a0d1-d2b9-d851-73c3-93fcc607501c@al=
u.unizg.hr/
> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Link: https://lore.kernel.org/all/cdc80531-f25f-6f9d-b15f-25e16130b53a@al=
u.unizg.hr/
> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>=20

You really should say what you changed, but anyway, it's too late - I
applied a previous version yesterday.

Also, I suspect you just collected the reviewed-by tag here, which
really you shouldn't be doing a resend for.

johannes

