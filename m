Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1D2ADAD
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 06:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfE0Ed5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 00:33:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfE0Ed5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 00:33:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E2A61476BA3F;
        Sun, 26 May 2019 21:33:56 -0700 (PDT)
Date:   Sun, 26 May 2019 21:29:14 -0700 (PDT)
Message-Id: <20190526.212914.2234426418598671959.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, sthemmin@microsoft.com
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked
 devices.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523175429.13302-3-sthemmin@microsoft.com>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
        <20190523175429.13302-3-sthemmin@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 21:33:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Thu, 23 May 2019 10:54:29 -0700

> @@ -4858,6 +4841,17 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>  
>  	__this_cpu_inc(softnet_data.processed);
>  
> +	if (static_branch_unlikely(&generic_xdp_needed_key)) {
> +		int ret2;
> +
> +		preempt_disable();
> +		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
> +		preempt_enable();
> +
> +		if (ret2 != XDP_PASS)
> +			return NET_RX_DROP;
> +	}

This function just did a skb_reset_mac_len().

do_xdp_generic() can modify skb->mac_header.

This means we have to redo the skb_reset_mac_len() to handle the
potentially changed value.
