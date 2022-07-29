Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04815849E9
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 04:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiG2CuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 22:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiG2CuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 22:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8093861723
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 19:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C56061DE5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB95C433C1;
        Fri, 29 Jul 2022 02:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659063004;
        bh=zJJwzl3P4WPkCGZnUowAyqdKcsqbm/N++zU6NFyXsIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=erJr7L4HZjd5+dM0lfKI5TTpg+b8F50AcOnC4eGrdKe9gRbuzM6yFhEjhgNWy5ILy
         8zOAiGG6D/yrJNg8lPobykDCaW+a6kqz9OWKX2gGfsdBQVFWyh/TMjkPBb94ASSZfZ
         1zlbHV3AMgqiQVEn6f+MDEIgbXbqZIF9+HZIx6LA17qFquDyb+QN+HGA2lD63xO9PV
         eBriPafJTTVPzppGF6RcY8ON2QYkNtVzvB7vgWeDFwpj9+QdKtta58lBfNmZGh7L4H
         D1MiSZHn4ejGpIvVe39ljpKhXDJ6ILnJTG/7AXVp66QpFhoszfGt2FCgBnU9jnnH98
         apDf+a5L7aZ1g==
Date:   Thu, 28 Jul 2022 19:50:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     gfree.wind@outlook.com
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Gao Feng <gfree.wind@gmail.com>
Subject: Re: [PATCH net-next 1/1] tcp: Remove useless acceptable check
 because the return vlaue always is 0
Message-ID: <20220728195003.5dd7cf34@kernel.org>
In-Reply-To: <OSZP286MB1404946FF81173281D3BF67695949@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
References: <OSZP286MB1404946FF81173281D3BF67695949@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 06:58:03 +0800 gfree.wind@outlook.com wrote:
> From: Gao Feng <gfree.wind@gmail.com>
> 
> The conn_request function of IPv4 and IPv6 always returns 0, so it's
> useless to check for acceptable.

I don't think this is an improvement. If the function returns 
a value we should not be ignoring it.

> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3ec4edc37313..82a875efd1e8 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6453,12 +6453,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
>  			 */
>  			rcu_read_lock();
>  			local_bh_disable();
> -			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
> +			/* TCP's conn_request always returns 0. */
> +			icsk->icsk_af_ops->conn_request(sk, skb);
>  			local_bh_enable();
>  			rcu_read_unlock();
>  
> -			if (!acceptable)
> -				return 1;
>  			consume_skb(skb);
>  			return 0;
>  		}

