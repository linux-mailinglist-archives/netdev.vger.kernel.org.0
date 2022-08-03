Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CF1588F2D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiHCPOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237930AbiHCPOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:14:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4215B2A948;
        Wed,  3 Aug 2022 08:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71773CE23A4;
        Wed,  3 Aug 2022 15:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21E2C433D7;
        Wed,  3 Aug 2022 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659539655;
        bh=pK3P6YKF/O7YvZ9WTM4gxZVhDGtihziln7chla4iH5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHLmK99NPoh2XDLKBc8f63WccKUVyqXftm9dlFIwJgKXDyOUW1xGLVr9REBVvDIcW
         9IJMTMHr2rBRYhKlVGx0CW5FpSF2CmdFut3hllMCWnRjoUhIw2kQZzEjQAjg8l7P3j
         ij54+7b2Uys4a2OeIIVOVXCvsO3bJ8vkm7A+mgPv09SiQPeQ603p9ZtYoeFMEI6m+q
         +jjkJrqu6d9L4ql4apSGZfm8RQ3lRp9ITsfSt4uM3//ruNlYo4YrQFScbzVegcimyg
         1pAchX4QHKemLcAlanRzbUaIwmAdqVjp69dhaNOB7ymHUs7LCW5dXIadiaUXzcR7IJ
         WHCl3NPza6BXQ==
Date:   Wed, 3 Aug 2022 08:14:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>, kafai@fb.com
Cc:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kgraul@linux.ibm.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [PATCH v4] net: fix refcount bug in sk_psock_get (2)
Message-ID: <20220803081413.3cc27002@kernel.org>
In-Reply-To: <20220803124121.173303-1-yin31149@gmail.com>
References: <00000000000026328205e08cdbeb@google.com>
        <20220803124121.173303-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Aug 2022 20:41:22 +0800 Hawkins Jiawei wrote:
> -/* Pointer stored in sk_user_data might not be suitable for copying
> - * when cloning the socket. For instance, it can point to a reference
> - * counted object. sk_user_data bottom bit is set if pointer must not
> - * be copied.
> +/* flag bits in sk_user_data
> + *
> + * SK_USER_DATA_NOCOPY - Pointer stored in sk_user_data might
> + * not be suitable for copying when cloning the socket.
> + * For instance, it can point to a reference counted object.
> + * sk_user_data bottom bit is set if pointer must not be copied.
> + *
> + * SK_USER_DATA_BPF    - Managed by BPF

I'd use this opportunity to add more info here, BPF is too general.
Maybe "Pointer is used by a BPF reuseport array"? Martin, WDYT?

> + * SK_USER_DATA_PSOCK  - Mark whether pointer stored in sk_user_data points
> + * to psock type. This bit should be set when sk_user_data is
> + * assigned to a psock object.

> +/**
> + * rcu_dereference_sk_user_data_psock - return psock if sk_user_data
> + * points to the psock type(SK_USER_DATA_PSOCK flag is set), otherwise
> + * return NULL
> + *
> + * @sk: socket
> + */
> +static inline
> +struct sk_psock *rcu_dereference_sk_user_data_psock(const struct sock *sk)

nit: the return type more commonly goes on the same line as "static
inline"

> +{
> +	uintptr_t __tmp = (uintptr_t)rcu_dereference(__sk_user_data((sk)));
> +
> +	if (__tmp & SK_USER_DATA_PSOCK)
> +		return (struct sk_psock *)(__tmp & SK_USER_DATA_PTRMASK);
> +
> +	return NULL;
> +}

As a follow up we can probably generalize this into
 __rcu_dereference_sk_user_data_cond(sk, bit)

and make the psock just call that:

static inline struct sk_psock *
rcu_dereference_sk_user_data_psock(const struct sock *sk)
{
	return __rcu_dereference_sk_user_data_cond(sk, SK_USER_DATA_PSOCK);
}

then reuseport can also benefit, maybe:

diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index e2618fb5870e..ad5c447a690c 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -21,14 +21,11 @@ static struct reuseport_array *reuseport_array(struct bpf_map *map)
 /* The caller must hold the reuseport_lock */
 void bpf_sk_reuseport_detach(struct sock *sk)
 {
-	uintptr_t sk_user_data;
+	struct sock __rcu **socks;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	sk_user_data = (uintptr_t)sk->sk_user_data;
-	if (sk_user_data & SK_USER_DATA_BPF) {
-		struct sock __rcu **socks;
-
-		socks = (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
+	socks = __rcu_dereference_sk_user_data_cond(sk, SK_USER_DATA_BPF);
+	if (socks) {
 		WRITE_ONCE(sk->sk_user_data, NULL);
 		/*
 		 * Do not move this NULL assignment outside of


But that must be a separate patch, not part of this fix.
