Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825D5647CB4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLID5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLID5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:57:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A834B3D86;
        Thu,  8 Dec 2022 19:57:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D235EB82642;
        Fri,  9 Dec 2022 03:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590E8C433D2;
        Fri,  9 Dec 2022 03:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670558242;
        bh=1q0uQy4fJmjH4+VbZp0T37Da4HzNtp6N52LDPApNq5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nNQdOESoSN8YTu+EIaKJjDIzOHtlhotkq2wNALRu/P89wIB66kvc2BcCunIT1dZuC
         I5DKAbzWbpHae80B4tBkbNw+kRoSnlLCCK+HQtWu6jvkziUXqP5S3bNYSPycHK5ue2
         xeV5Z4Dio/P/5KQz0U8HZM20IEGsWnGMzoG3GPd1BV7ysVbuBAnX4V24qxl8C2D3BN
         nlP2yf7feV/KMSKlOSdi8vT4eCkvgd6TWarLBkNevtd5EbWvV7QQ7laus5tlF3CxFK
         lR1ZHwcTn5f8753xOCSaSujdziYZIOWXpCPTZsX2bNYBTX826I0jJYqdhmcVE2slCu
         oW15HYYd8uP3A==
Date:   Thu, 8 Dec 2022 19:57:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [PATCH net-next] net: tso: inline tso_count_descs()
Message-ID: <20221208195721.698f68b6@kernel.org>
In-Reply-To: <20221208024303.11191-1-linyunsheng@huawei.com>
References: <20221208024303.11191-1-linyunsheng@huawei.com>
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

On Thu, 8 Dec 2022 10:43:03 +0800 Yunsheng Lin wrote:
> tso_count_descs() is a small function doing simple calculation,
> and tso_count_descs() is used in fast path, so inline it to
> reduce the overhead of calls.

TSO frames are large, the overhead is fine.
I'm open to other opinions but I'd rather keep the code as is than
deal with the influx with similar sloppily automated changes.

> diff --git a/include/net/tso.h b/include/net/tso.h
> index 62c98a9c60f1..ab6bbf56d984 100644
> --- a/include/net/tso.h
> +++ b/include/net/tso.h
> @@ -16,7 +16,13 @@ struct tso_t {
>  	u32	tcp_seq;
>  };

no include for skbuff.h here

> -int tso_count_descs(const struct sk_buff *skb);
> +/* Calculate expected number of TX descriptors */
> +static inline int tso_count_descs(const struct sk_buff *skb)
> +{
> +	/* The Marvell Way */

these comments should be rewritten as we move
the function clearly calculates the worst case buffer count

> +	return skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags;
> +}
