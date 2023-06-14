Return-Path: <netdev+bounces-10768-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF06730341
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C61501C2096A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336E1101C3;
	Wed, 14 Jun 2023 15:15:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D62C9C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37623C433C9;
	Wed, 14 Jun 2023 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686755735;
	bh=IYlo4kFJO2TVbRcxmRqgX52nQUD+JoUM4Xtdb77hYmo=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=L8/y2njeA9dvpmBLDS9b9VOFgU7bn/6Axd3gCwGdy5yLR9y2TYpTtK5sQOQ8kSSRS
	 3H+GT2aah72MhN7h0rby9iSLNoJa+QoW5WquxOJBh3bDbqieaEQFyVWttfVypNXAoD
	 E4yHAzZnziz/TpDvEUQdU22jT6S3EBYJ1Dhj5qhI1kq+I0pwIsf39kOnOrMygtN9Jv
	 pwSdfpNe43i8pavv/T5Ol0odDnE6xBW0s6vX/mMy6sbAOkrA9iocie8/zty1E5JlfF
	 XYEHdBWtm3z4qKiolcKU/fEMYGs9F/mi74EM079kBrQJtYIYfR+dTBMr2KQ559SGXu
	 rRGOJuArVX5yw==
From: Kalle Valo <kvalo@kernel.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: linux-hardening@vger.kernel.org,  linux-wireless@vger.kernel.org,  linux-kernel@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  netdev@vger.kernel.org,  Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] wifi: cfg80211: replace strlcpy() with strscpy()
References: <20230614134956.2109252-1-azeemshaikh38@gmail.com>
	<874jnaf7fv.fsf@kernel.org>
	<CADmuW3WEUgnpGXg=ajpRvwON6mFLQD9cPKnhsg35CcNqwcywxA@mail.gmail.com>
Date: Wed, 14 Jun 2023 18:15:31 +0300
In-Reply-To: <CADmuW3WEUgnpGXg=ajpRvwON6mFLQD9cPKnhsg35CcNqwcywxA@mail.gmail.com>
	(Azeem Shaikh's message of "Wed, 14 Jun 2023 10:55:13 -0400")
Message-ID: <875y7qcbxo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Azeem Shaikh <azeemshaikh38@gmail.com> writes:

> On Wed, Jun 14, 2023 at 10:24=E2=80=AFAM Kalle Valo <kvalo@kernel.org> wr=
ote:
>
>>
>> Azeem Shaikh <azeemshaikh38@gmail.com> writes:
>>
>> > strlcpy() reads the entire source buffer first.
>> > This read may exceed the destination size limit.
>> > This is both inefficient and can lead to linear read
>> > overflows if a source string is not NUL-terminated [1].
>> > In an effort to remove strlcpy() completely [2], replace
>> > strlcpy() here with strscpy().
>> >
>> > Direct replacement is safe here since WIPHY_ASSIGN is only used by
>> > TRACE macros and the return values are ignored.
>> >
>> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#str=
lcpy
>> > [2] https://github.com/KSPP/linux/issues/89
>> >
>> > Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
>> > ---
>> > v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh38=
@gmail.com/
>> > v2: https://lore.kernel.org/all/20230614134552.2108471-1-azeemshaikh38=
@gmail.com/
>>
>> In the change log (after the "---" line) you should also describe what
>> changes you made, more info in the wiki below. In this case it's clear
>> as the patch is simple but please keep this in mind for future patches.
>>
>> No need to resend because of this.
>>
>
> Thanks Kalle. I did have the below line in my changelog. For future
> patches, do you mean that changelog descriptions need to be more
> specific than this? For example - updated title from "x" -> "y"?
>
>> Changes from v1 and v2 - updated patch title.

Ah, I missed that because the format was not what we usually use. I
recommend something like this:

v3:

* add bar

v2:

* https://
* fix foo

v1:

* https://

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

