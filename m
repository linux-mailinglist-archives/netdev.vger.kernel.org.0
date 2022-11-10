Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BC162396E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiKJCCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiKJCA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:00:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D592ED7A;
        Wed,  9 Nov 2022 17:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9EA8B80959;
        Thu, 10 Nov 2022 01:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140B7C433D7;
        Thu, 10 Nov 2022 01:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668045561;
        bh=0+KljlocHurYx/De7VpZSIfHRyAIx3H1IOL6zcagU74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XCxaFgXMpIKMJhI+lJAG8fmgidHpsl5/vkwVcFZ3pW6RmwGMOBxpGvktgHZLTyRdt
         shNhUaj9oqStxaY4kW6YnmQYghJT6YZRiM4IXJtSCCD4NIOA+JpiBZEHfbrT7OnqP3
         QMHjhQFYZ9iQVLgpJp4tPTxqT3yPDPcqtx7d6Mkq3HxHSQRAnHOuxOdfqkDaMgpuiT
         fxbuGnB6SATgRju/u0mibiXK4OtP1udMQwTBgMZPzhBn/En+sU+QRL65PJQ6kKoONj
         5ycgDWazfshy5M3QNo+D1WM6uwu/O9IF6mkQIx0WBKFq/d9nxpaPn7WCbUi2zO4/A6
         m0ppQ6K0JBudg==
Date:   Wed, 9 Nov 2022 17:59:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: tun: rebuild error handling in tun_get_user
Message-ID: <20221109175908.593df5da@kernel.org>
In-Reply-To: <20221107090940.686229-1-nashuiliang@gmail.com>
References: <20221107090940.686229-1-nashuiliang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Nov 2022 17:09:40 +0800 Chuang Wang wrote:
> The error handling in tun_get_user is very scattered.
> This patch unifies error handling, reduces duplication of code, and
> makes the logic clearer.

You're also making some functional changes tho, they at the very least
need to be enumerated or preferably separate patches.

> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 4bf2b268df4a..5ceec73baf98 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1742,11 +1742,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>  	int good_linear;
>  	int copylen;
>  	bool zerocopy = false;
> -	int err;
> +	int err = 0;

Don't zero-init the variables like this, instead...

>  	u32 rxhash = 0;
>  	int skb_xdp = 1;
>  	bool frags = tun_napi_frags_enabled(tfile);
> -	enum skb_drop_reason drop_reason;
> +	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>  
>  	if (!(tun->flags & IFF_NO_PI)) {
>  		if (len < sizeof(pi))
> @@ -1808,11 +1808,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>  		 */
>  		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);

... use

	err = PTR_ERR_OR_ZERO(skb);

close to the jumps. It's safer to always init err before jumping.

>  		if (IS_ERR(skb)) {
> -			dev_core_stats_rx_dropped_inc(tun->dev);
> -			return PTR_ERR(skb);
> +			err = PTR_ERR(skb);
> +			goto drop;
>  		}
>  		if (!skb)
> -			return total_len;
> +			goto out;

>  	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
>  		atomic_long_inc(&tun->rx_frame_errors);
> -		kfree_skb(skb);

now we'll increment error and drop counters, that's not right.

> -		if (frags) {
> -			tfile->napi.skb = NULL;
> -			mutex_unlock(&tfile->napi_mutex);
> -		}
> -
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto drop;
>  	}

> @@ -1952,8 +1932,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>  
>  	rcu_read_lock();
>  	if (unlikely(!(tun->dev->flags & IFF_UP))) {
> -		err = -EIO;
>  		rcu_read_unlock();
> +		err = -EIO;

this change is unnecessary, please refrain from making it

>  		drop_reason = SKB_DROP_REASON_DEV_READY;
>  		goto drop;
>  	}
> @@ -2007,7 +1987,23 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>  	if (rxhash)
>  		tun_flow_update(tun, rxhash, tfile);
>  
> -	return total_len;
> +	goto out;

keep

	return total_len;

that's much easier to read, and there's no concern of err being
uninitialized.

> +
> +drop:
> +	if (err != -EAGAIN)
> +		dev_core_stats_rx_dropped_inc(tun->dev);
> +
> +	if (!IS_ERR_OR_NULL(skb))
> +		kfree_skb_reason(skb, drop_reason);
> +
> +unlock_frags:
> +	if (frags) {
> +		tfile->napi.skb = NULL;
> +		mutex_unlock(&tfile->napi_mutex);
> +	}
> +
> +out:
> +	return err ?: total_len;
>  }
>  
>  static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)

