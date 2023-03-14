Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E9F6B86E1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjCNA2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNA2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:28:46 -0400
Received: from out-21.mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE4C21A0A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 17:28:43 -0700 (PDT)
Message-ID: <d6af02bb-f1e6-79a9-33b6-292c486f5684@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678753721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8yVggL9I/M56Xj3RbtTVrlT/8KZEpkD/r4vcvlcDQM=;
        b=mLLD6STMZPKsRNRgUKKCa6WVi1r+vCeFEs2tletvwlNJHjN6adQH4lu3a2DmBOlKCwY+3K
        /ysqXy6qrHuzljBYfTRjiVCGRhv34Kgcro0VdT6ig+0ghfVSTLklXYtfupbl0vPed6ZIZy
        4hrV6jEqQf3iU1ybiffxPWF+tIueXYo=
Date:   Mon, 13 Mar 2023 17:28:36 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v6 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US
To:     Kui-Feng Lee <kuifeng@meta.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        song@kernel.org, kernel-team@meta.com, andrii@kernel.org,
        sdf@google.com
References: <20230310043812.3087672-1-kuifeng@meta.com>
 <20230310043812.3087672-3-kuifeng@meta.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230310043812.3087672-3-kuifeng@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/23 8:38 PM, Kui-Feng Lee wrote:
> This feature lets you immediately transition to another congestion
> control algorithm or implementation with the same name.  Once a name
> is updated, new connections will apply this new algorithm.

The commit message needs to explain why the change is needed and some major 
details on how the patch is doing it. In this case, why a later bpf patch needs 
it and what major changes are made to tcp_cong.c.

For example,

A later bpf patch will allow attaching a bpf_struct_ops (TCP Congestion Control 
implemented in bpf) to bpf_link. The later bpf patch will also use the existing 
bpf_link API to replace a bpf_struct_ops (ie. to replace an old tcp-cc with a 
new tcp-cc under the same name). This requires a helper function to replace a 
tcp-cc under a tcp_cong_list_lock. Thus, this patch adds a 
tcp_update_congestion_control() to replace the "old_ca" with a new "ca".

This patch also takes this chance to refactor the ca validation into the new 
tcp_validate_congestion_control() function.

> 
> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
> ---
>   include/linux/bpf.h            |  1 +
>   include/net/tcp.h              |  2 ++
>   net/bpf/bpf_dummy_struct_ops.c |  6 ++++
>   net/ipv4/bpf_tcp_ca.c          |  6 ++++
>   net/ipv4/tcp_cong.c            | 60 ++++++++++++++++++++++++++++++----
>   5 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 00ca92ea6f2e..0f84925d66db 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1511,6 +1511,7 @@ struct bpf_struct_ops {
>   			   void *kdata, const void *udata);
>   	int (*reg)(void *kdata);
>   	void (*unreg)(void *kdata);
> +	int (*update)(void *kdata, void *old_kdata);
>   	const struct btf_type *type;
>   	const struct btf_type *value_type;
>   	const char *name;
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index db9f828e9d1e..239cc0e2639c 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1117,6 +1117,8 @@ struct tcp_congestion_ops {
>   
>   int tcp_register_congestion_control(struct tcp_congestion_ops *type);
>   void tcp_unregister_congestion_control(struct tcp_congestion_ops *type);
> +int tcp_update_congestion_control(struct tcp_congestion_ops *type,
> +				  struct tcp_congestion_ops *old_type);
>   
>   void tcp_assign_congestion_control(struct sock *sk);
>   void tcp_init_congestion_control(struct sock *sk);
> diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
> index ff4f89a2b02a..158f14e240d0 100644
> --- a/net/bpf/bpf_dummy_struct_ops.c
> +++ b/net/bpf/bpf_dummy_struct_ops.c
> @@ -222,12 +222,18 @@ static void bpf_dummy_unreg(void *kdata)
>   {
>   }
>   
> +static int bpf_dummy_update(void *kdata, void *old_kdata)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>   struct bpf_struct_ops bpf_bpf_dummy_ops = {
>   	.verifier_ops = &bpf_dummy_verifier_ops,
>   	.init = bpf_dummy_init,
>   	.check_member = bpf_dummy_ops_check_member,
>   	.init_member = bpf_dummy_init_member,
>   	.reg = bpf_dummy_reg,
> +	.update = bpf_dummy_update,
>   	.unreg = bpf_dummy_unreg,
>   	.name = "bpf_dummy_ops",
>   };
> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> index 13fc0c185cd9..66ce5fadfe42 100644
> --- a/net/ipv4/bpf_tcp_ca.c
> +++ b/net/ipv4/bpf_tcp_ca.c
> @@ -266,10 +266,16 @@ static void bpf_tcp_ca_unreg(void *kdata)
>   	tcp_unregister_congestion_control(kdata);
>   }
>   
> +static int bpf_tcp_ca_update(void *kdata, void *old_kdata)
> +{
> +	return tcp_update_congestion_control(kdata, old_kdata);
> +}
> +
>   struct bpf_struct_ops bpf_tcp_congestion_ops = {
>   	.verifier_ops = &bpf_tcp_ca_verifier_ops,
>   	.reg = bpf_tcp_ca_reg,
>   	.unreg = bpf_tcp_ca_unreg,
> +	.update = bpf_tcp_ca_update,

In v5, a comment was given to move the ".update" related changes to patch 5 such 
that patch 2 will only have netdev change in tcp_cong.c for review purpose.

Please ensure the earlier review comment is addressed in the next revision or 
reply if the earlier review comment does not make sense. This will save time for 
the reviewer not to have to repeat the same comment again.

>   	.check_member = bpf_tcp_ca_check_member,
>   	.init_member = bpf_tcp_ca_init_member,
>   	.init = bpf_tcp_ca_init,


