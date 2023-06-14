Return-Path: <netdev+bounces-10565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 910B372F14A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55FFA2812A5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D6A37C;
	Wed, 14 Jun 2023 01:04:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0827F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4403DC433C8;
	Wed, 14 Jun 2023 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686704662;
	bh=lsO1eVWZBM6MvyPnhWRML3twvD4cN5i1hHFtDXs+nXk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Hbko6dySTiq2eWSTr8BZvN7WscQfkrDv5setRSvi3YYEiu7/BfkJhp9wG/uU7FGuP
	 gB/hmiwi0obdbTIcJIkVwKLxmDKLOiCnIxsnNQQlqWJ2sswwIac5eEUI0q4u/1Rx7x
	 U15NrKi6VlrGUp012c5Ws+LWbqdXsSkeg6p9AU48AFe2NXy0qyusDn1MzoHvJzvKs6
	 NPX90LpZpBLIAuo6TDfcSs9xpk3dqy3lN01MCMa00YP2RYDJ/xk7v35oPoPQuVR4Hp
	 K4QI2Qr76jQAu9zbkostHoGtmeqsXRjG5fz/IIflOne34zYzroMMifoQSo/5LEX5zS
	 f+Lz3r4YU1Jtw==
Date: Tue, 13 Jun 2023 18:04:19 -0700
From: Kees Cook <kees@kernel.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Kees Cook <keescook@chromium.org>
CC: linux-hardening@vger.kernel.org, Neil Brown <neilb@suse.de>,
 Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anna Schumaker <anna@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] SUNRPC: Remove strlcpy
User-Agent: K-9 Mail for Android
In-Reply-To: <20230614001246.538643-1-azeemshaikh38@gmail.com>
References: <20230614001246.538643-1-azeemshaikh38@gmail.com>
Message-ID: <7E4A66A6-0B58-43AF-B9E0-62087F2EA11C@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 13, 2023 5:12:46 PM PDT, Azeem Shaikh <azeemshaikh38@gmail=2Ecom> w=
rote:
>strlcpy() reads the entire source buffer first=2E
>This read may exceed the destination size limit=2E
>This is both inefficient and can lead to linear read
>overflows if a source string is not NUL-terminated [1]=2E
>In an effort to remove strlcpy() completely [2], replace
>strlcpy() here with sysfs_emit()=2E
>
>Direct replacement is safe here since the getter in kernel_params_ops
>handles -errno return [3]=2E
>
>[1] https://www=2Ekernel=2Eorg/doc/html/latest/process/deprecated=2Ehtml#=
strlcpy
>[2] https://github=2Ecom/KSPP/linux/issues/89
>[3] https://elixir=2Ebootlin=2Ecom/linux/v6=2E4-rc6/source/include/linux/=
moduleparam=2Eh#L52
>
>Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail=2Ecom>
>---
> net/sunrpc/svc=2Ec |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/net/sunrpc/svc=2Ec b/net/sunrpc/svc=2Ec
>index e6d4cec61e47=2E=2E77326f163801 100644
>--- a/net/sunrpc/svc=2Ec
>+++ b/net/sunrpc/svc=2Ec
>@@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kernel_=
param *kp)
> 	switch (*ip)
> 	{
> 	case SVC_POOL_AUTO:
>-		return strlcpy(buf, "auto\n", 20);
>+		return sysfs_emit(buf, "auto\n");
> 	case SVC_POOL_GLOBAL:
>-		return strlcpy(buf, "global\n", 20);
>+		return sysfs_emit(buf, "global\n");
> 	case SVC_POOL_PERCPU:
>-		return strlcpy(buf, "percpu\n", 20);
>+		return sysfs_emit(buf, "percpu\n");
> 	case SVC_POOL_PERNODE:
>-		return strlcpy(buf, "pernode\n", 20);
>+		return sysfs_emit(buf, "pernode\n");
> 	default:
> 		return sprintf(buf, "%d\n", *ip);

Please replace the sprintf too (and then the Subject could be "use sysfs_e=
mit" or so)=2E

-Kees



--=20
Kees Cook

