Return-Path: <netdev+bounces-5197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A892171024E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ADC51C20D35
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 01:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5310C17C7;
	Thu, 25 May 2023 01:23:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4188415A9
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:23:03 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC2D122
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:23:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba83fed51adso3090586276.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684977781; x=1687569781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JiDrdjr9ZIvJRpTUykulKnPPib43IN+W9wnZrH/g/co=;
        b=Kc4m8fCt442UK9sds+JYnCWnnXQpQizzytfKVQhDZkNY9+1qRMLazQeW801p+gspii
         IQTicNAxo/MDfJclziG6AJImn0Et/GBw06sCD+fITH49YsrjHBeQk4+4fdp8xwm0e9T4
         ELuFE4v+8Rt6ZRoLX3GXXwxM3wnRxBB4yaBEtIxoWv6e+RYk3W0YSpf28DGIxXl8dI64
         wH/3Q6Mk9siXQ3Cp/P3F1YGISixoPdtRHj2YHx4Fhq3h8REvRrXlK6nJfuZ723TCxUq3
         8FZu17NSLb6po7FUTSqQld/fOrPsZbjs0YHqzrGISUdbvE9LydumDgS1nlaNeJ1Sxli5
         I/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684977781; x=1687569781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JiDrdjr9ZIvJRpTUykulKnPPib43IN+W9wnZrH/g/co=;
        b=PoSACdXSm7O8BlyES6aXdeRNT7No7/ojLjVmNwae4F7scf6ruQvh2ZEQJ0XkVwOpIB
         T0ykcGaWf9CojR9FWTI6ZFvNkIQv2yvm8y7qLaMyXBgJcL6CUR/ZK2DM/8mXVwn7anWB
         emDHrmaud1tWwCCkm1eSBv/kyamyrch35fd2kuxm7m7jTRtohpRCZbWjyw1sYo63OKW1
         X0q5FQd/5KCc+tK705cxjDJxdBkrdqb0iMZhJlXpokAZjcfPj5rORYXrE5AoAlKE0toR
         K+A3e8xi3HuhiYPeaD/ffNQ23sU9Ex8Lawwe9Vse5XIt/IO1ZMsPN6zGo8yQKYAoL5e4
         aQtQ==
X-Gm-Message-State: AC+VfDzxrRKFUvYOqcv3Krn7c04v4oGmFmxPfBFT0+d41RoIko8NpBXN
	KOE9xzOYm58jRSHfzguNILrUEHTSpUeKKA==
X-Google-Smtp-Source: ACHHUZ4YWaUzpt35EAhVNGF2S/+iZk+Ncd2VTjuqIw7hCp129AfK4hYExWoJGFS+acfRQcSTRFepi+stvqMUPg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a05:6902:4a8:b0:bab:a1e6:c87d with SMTP
 id r8-20020a05690204a800b00baba1e6c87dmr837508ybs.4.1684977781052; Wed, 24
 May 2023 18:23:01 -0700 (PDT)
Date: Thu, 25 May 2023 01:22:59 +0000
In-Reply-To: <20230522070122.6727-4-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230522070122.6727-1-wuyun.abel@bytedance.com> <20230522070122.6727-4-wuyun.abel@bytedance.com>
Message-ID: <20230525012259.qd6i6rtqvvae3or7@google.com>
Subject: Re: [PATCH v2 3/4] sock: Consider memcg pressure when raising sockmem
From: Shakeel Butt <shakeelb@google.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Glauber Costa <glommer@parallels.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:01:21PM +0800, Abel Wu wrote:
> For now __sk_mem_raise_allocated() mainly considers global socket
> memory pressure and allows to raise if no global pressure observed,
> including the sockets whose memcgs are in pressure, which might
> result in longer memcg memstall.
> 
> So take net-memcg's pressure into consideration when allocating
> socket memory to alleviate long tail latencies.
> 
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>

Hi Abel,

Have you seen any real world production issue which is fixed by this
patch or is it more of a fix after reading code?

This code is quite subtle and small changes can cause unintended
behavior changes. At the moment the tcp memory accounting and memcg
accounting is intermingled and I think we should decouple them.

> ---
>  net/core/sock.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 801df091e37a..7641d64293af 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2977,21 +2977,30 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>  {
>  	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
>  	struct proto *prot = sk->sk_prot;
> -	bool charged = true;
> +	bool charged = true, pressured = false;
>  	long allocated;
>  
>  	sk_memory_allocated_add(sk, amt);
>  	allocated = sk_memory_allocated(sk);
> -	if (memcg_charge &&
> -	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
> -						gfp_memcg_charge())))
> -		goto suppress_allocation;
> +
> +	if (memcg_charge) {
> +		charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
> +						  gfp_memcg_charge());
> +		if (!charged)
> +			goto suppress_allocation;
> +		if (mem_cgroup_under_socket_pressure(sk->sk_memcg))

The memcg under pressure callback does a upward memcg tree walk, do
please make sure you have tested the performance impact of this.

> +			pressured = true;
> +	}
>  
>  	/* Under limit. */
> -	if (allocated <= sk_prot_mem_limits(sk, 0)) {
> +	if (allocated <= sk_prot_mem_limits(sk, 0))
>  		sk_leave_memory_pressure(sk);
> +	else
> +		pressured = true;
> +
> +	/* No pressure observed in global/memcg. */
> +	if (!pressured)
>  		return 1;
> -	}
>  
>  	/* Under pressure. */
>  	if (allocated > sk_prot_mem_limits(sk, 1))
> -- 
> 2.37.3
> 

