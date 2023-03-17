Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77FB6BECCE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCQPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjCQPXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:23:55 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEAD4ECA;
        Fri, 17 Mar 2023 08:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=alwacGIsYUkAEyXPWeQ4Vcq46Ox3tubR5cPVZUbOrno=; b=hY2cOctRb2VFQOGXVpUOq1ce46
        ZxoUS7JdciaXQXEFeoxFjDZXS/r6mLOdEZKLuW+2mMyXJ+32GMa93P3iukKSMory3UEX7m/LWgxav
        +7Lt05pE2vsSjm0LaNVx0pMdKTczMC0LJArS/45RVsyJkGy1a12L22gqwsT1GafsY5t1HNkotZASZ
        dgzrY87cNO/fvUQNIOAlSO8Ck+uQrjW6y87Kd/FRzWW57DkjanpvFo6c/IrWioAOS3v3IakfNSFQu
        kOPArRPUwUv68+c/h/BML3lJPxAWTUQhCFRS/vMGlGMFJ2sfowi+GaWpCtmRxBct0UV4OwhWY0vTR
        PZxeKpJA==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pdBvp-000IIF-IF; Fri, 17 Mar 2023 16:23:49 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pdBvp-000N4L-6y; Fri, 17 Mar 2023 16:23:49 +0100
Subject: Re: [PATCH bpf-next v7 2/8] net: Update an existing TCP congestion
 control algorithm.
To:     Kui-Feng Lee <kuifeng@meta.com>, bpf@vger.kernel.org,
        ast@kernel.org, martin.lau@linux.dev, song@kernel.org,
        kernel-team@meta.com, andrii@kernel.org, sdf@google.com
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
References: <20230316023641.2092778-1-kuifeng@meta.com>
 <20230316023641.2092778-3-kuifeng@meta.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
Date:   Fri, 17 Mar 2023 16:23:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230316023641.2092778-3-kuifeng@meta.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26846/Fri Mar 17 08:22:57 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/23 3:36 AM, Kui-Feng Lee wrote:
> This feature lets you immediately transition to another congestion
> control algorithm or implementation with the same name.  Once a name
> is updated, new connections will apply this new algorithm.
> 
> The purpose is to update a customized algorithm implemented in BPF
> struct_ops with a new version on the flight.  The following is an
> example of using the userspace API implemented in later BPF patches.
> 
>     link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
>     .......
>     err = bpf_link__update_map(link, skel->maps.ca_update_2);
> 
> We first load and register an algorithm implemented in BPF struct_ops,
> then swap it out with a new one using the same name. After that, newly
> created connections will apply the updated algorithm, while older ones
> retain the previous version already applied.
> 
> This patch also takes this chance to refactor the ca validation into
> the new tcp_validate_congestion_control() function.
> 
> Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
> ---
>   include/net/tcp.h   |  3 +++
>   net/ipv4/tcp_cong.c | 60 +++++++++++++++++++++++++++++++++++++++------
>   2 files changed, 56 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index db9f828e9d1e..2abb755e6a3a 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1117,6 +1117,9 @@ struct tcp_congestion_ops {
>   
>   int tcp_register_congestion_control(struct tcp_congestion_ops *type);
>   void tcp_unregister_congestion_control(struct tcp_congestion_ops *type);
> +int tcp_update_congestion_control(struct tcp_congestion_ops *type,
> +				  struct tcp_congestion_ops *old_type);
> +int tcp_validate_congestion_control(struct tcp_congestion_ops *ca);
>   
>   void tcp_assign_congestion_control(struct sock *sk);
>   void tcp_init_congestion_control(struct sock *sk);
> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> index db8b4b488c31..c90791ae8389 100644
> --- a/net/ipv4/tcp_cong.c
> +++ b/net/ipv4/tcp_cong.c
> @@ -75,14 +75,8 @@ struct tcp_congestion_ops *tcp_ca_find_key(u32 key)
>   	return NULL;
>   }
>   
> -/*
> - * Attach new congestion control algorithm to the list
> - * of available options.
> - */
> -int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
> +int tcp_validate_congestion_control(struct tcp_congestion_ops *ca)
>   {
> -	int ret = 0;
> -
>   	/* all algorithms must implement these */
>   	if (!ca->ssthresh || !ca->undo_cwnd ||
>   	    !(ca->cong_avoid || ca->cong_control)) {
> @@ -90,6 +84,20 @@ int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
>   		return -EINVAL;
>   	}
>   
> +	return 0;
> +}
> +
> +/* Attach new congestion control algorithm to the list
> + * of available options.
> + */
> +int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
> +{
> +	int ret;
> +
> +	ret = tcp_validate_congestion_control(ca);
> +	if (ret)
> +		return ret;
> +
>   	ca->key = jhash(ca->name, sizeof(ca->name), strlen(ca->name));
>   
>   	spin_lock(&tcp_cong_list_lock);
> @@ -130,6 +138,44 @@ void tcp_unregister_congestion_control(struct tcp_congestion_ops *ca)
>   }
>   EXPORT_SYMBOL_GPL(tcp_unregister_congestion_control);
>   
> +/* Replace a registered old ca with a new one.
> + *
> + * The new ca must have the same name as the old one, that has been
> + * registered.
> + */
> +int tcp_update_congestion_control(struct tcp_congestion_ops *ca, struct tcp_congestion_ops *old_ca)
> +{
> +	struct tcp_congestion_ops *existing;
> +	int ret;
> +
> +	ret = tcp_validate_congestion_control(ca);
> +	if (ret)
> +		return ret;
> +
> +	ca->key = jhash(ca->name, sizeof(ca->name), strlen(ca->name));
> +
> +	spin_lock(&tcp_cong_list_lock);
> +	existing = tcp_ca_find_key(old_ca->key);
> +	if (ca->key == TCP_CA_UNSPEC || !existing || strcmp(existing->name, ca->name)) {
> +		pr_notice("%s not registered or non-unique key\n",
> +			  ca->name);
> +		ret = -EINVAL;
> +	} else if (existing != old_ca) {
> +		pr_notice("invalid old congestion control algorithm to replace\n");
> +		ret = -EINVAL;
> +	} else {
> +		/* Add the new one before removing the old one to keep
> +		 * one implementation available all the time.
> +		 */
> +		list_add_tail_rcu(&ca->list, &tcp_cong_list);
> +		list_del_rcu(&existing->list);
> +		pr_debug("%s updated\n", ca->name);
> +	}
> +	spin_unlock(&tcp_cong_list_lock);
> +
> +	return ret;
> +}

Was wondering if we could have tcp_register_congestion_control and tcp_update_congestion_control
could be refactored for reuse. Maybe like below. From the function itself what is not clear whether
callers that replace an existing one should do the synchronize_rcu() themselves or if this should
be part of tcp_update_congestion_control?

int tcp_check_congestion_control(struct tcp_congestion_ops *ca)
{
	/* All algorithms must implement these. */
	if (!ca->ssthresh || !ca->undo_cwnd ||
	    !(ca->cong_avoid || ca->cong_control)) {
		pr_err("%s does not implement required ops\n", ca->name);
		return -EINVAL;
	}
	if (ca->key == TCP_CA_UNSPEC)
		ca->key = jhash(ca->name, sizeof(ca->name), strlen(ca->name));
	if (ca->key == TCP_CA_UNSPEC) {
		pr_notice("%s results in zero key\n", ca->name);
		return -EEXIST;
	}
	return 0;
}

/* Attach new congestion control algorithm to the list of available
  * options or replace an existing one if old is non-NULL.
  */
int tcp_update_congestion_control(struct tcp_congestion_ops *new,
				  struct tcp_congestion_ops *old)
{
	struct tcp_congestion_ops *found;
	int ret;

	ret = tcp_check_congestion_control(new);
	if (ret)
		return ret;
	if (old &&
	    (old->key != new->key ||
	     strcmp(old->name, new->name))) {
		pr_notice("%s & %s have non-matching congestion control names\n",
			  old->name, new->name);
		return -EINVAL;
	}
	spin_lock(&tcp_cong_list_lock);
	found = tcp_ca_find_key(new->key);
	if (old) {
		if (found == old) {
			list_add_tail_rcu(&new->list, &tcp_cong_list);
			list_del_rcu(&old->list);
		} else {
			pr_notice("%s not registered\n", old->name);
			ret = -EINVAL;
		}
	} else {
		if (found) {
			pr_notice("%s already registered\n", new->name);
			ret = -EEXIST;
		} else {
			list_add_tail_rcu(&new->list, &tcp_cong_list);
		}
	}
	spin_unlock(&tcp_cong_list_lock);
	return ret;
}

int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
{
	return tcp_update_congestion_control(ca, NULL);
}
EXPORT_SYMBOL_GPL(tcp_register_congestion_control);
