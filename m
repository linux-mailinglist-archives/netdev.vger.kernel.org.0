Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCDF529236
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348543AbiEPVEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348426AbiEPVEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:04:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5F75C665
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F303B8165E
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F3DC385AA;
        Mon, 16 May 2022 20:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652733582;
        bh=d9QzYvLdtwGCCUWrdETGnIhukVs8d/K4Hpgdx01lsBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U6th1iN1Z0vZKykuaMG1je9BES41BMn8g+r/+DbTIpeWwKh/lN31dAsSngoWh2RxR
         c1GBWY5YqVwXDQxf/3Qk5xUWQzrFtvEFvygeN7U8p/Z9B5ibFch4pjdqjoFk6tcp4n
         8MwaBTwJfmjLatQsvtkYOzkATNpdVKuLbWCgUro9Q/3AfxtaMT66Ism5pNzodZZQLL
         qpFV8G4rZr6pQAXPwzI0MC54t4vajxogwyDuBPJwsKy7snE/s64mul/pBQjmWLvWob
         p3KrG1U0rnlkywDnM5xw+Z8tZ1xNYQfNzlXzGRb3ZNYC/WkfvTX7LskVWM5GnfWNLF
         Zu6+xLj+6hEug==
Date:   Mon, 16 May 2022 13:39:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 3/4] net: add skb_defer_max sysctl
Message-ID: <20220516133941.7da6bac7@kernel.org>
In-Reply-To: <20220516042456.3014395-4-eric.dumazet@gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
        <20220516042456.3014395-4-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 May 2022 21:24:55 -0700 Eric Dumazet wrote:
> @@ -6494,16 +6495,21 @@ void skb_attempt_defer_free(struct sk_buff *skb)
>  	int cpu = skb->alloc_cpu;
>  	struct softnet_data *sd;
>  	unsigned long flags;
> +	unsigned int defer_max;
>  	bool kick;
>  
>  	if (WARN_ON_ONCE(cpu >= nr_cpu_ids) ||
>  	    !cpu_online(cpu) ||
>  	    cpu == raw_smp_processor_id()) {
> -		__kfree_skb(skb);
> +nodefer:	__kfree_skb(skb);
>  		return;
>  	}
>  
>  	sd = &per_cpu(softnet_data, cpu);
> +	defer_max = READ_ONCE(sysctl_skb_defer_max);
> +	if (READ_ONCE(sd->defer_count) >= defer_max)
> +		goto nodefer;
> +
>  	/* We do not send an IPI or any signal.
>  	 * Remote cpu will eventually call skb_defer_free_flush()
>  	 */
> @@ -6513,11 +6519,8 @@ void skb_attempt_defer_free(struct sk_buff *skb)
>  	WRITE_ONCE(sd->defer_list, skb);
>  	sd->defer_count++;
>  
> -	/* kick every time queue length reaches 128.
> -	 * This condition should hardly be hit under normal conditions,
> -	 * unless cpu suddenly stopped to receive NIC interrupts.
> -	 */
> -	kick = sd->defer_count == 128;
> +	/* Send an IPI every time queue reaches half capacity. */
> +	kick = sd->defer_count == (defer_max >> 1);

nit: it will behave a little strangely for defer_max == 1
we'll let one skb get onto the list and free the subsequent 
skbs directly but we'll never kick the IPI

Moving the sd->defer_count++; should fix it and have no significant
side effects. I think.
