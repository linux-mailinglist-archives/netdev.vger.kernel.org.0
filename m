Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A769B1DA4A4
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgESWjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgESWjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:39:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A21C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:39:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7278128EDAA1;
        Tue, 19 May 2020 15:39:07 -0700 (PDT)
Date:   Tue, 19 May 2020 15:39:07 -0700 (PDT)
Message-Id: <20200519.153907.1979252396950846339.davem@davemloft.net>
To:     boris.sukholitko@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] __netif_receive_skb_core: pass skb by reference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519073229.GA20624@noodle>
References: <20200519073229.GA20624@noodle>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:39:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Sukholitko <boris.sukholitko@broadcom.com>
Date: Tue, 19 May 2020 10:32:37 +0300

> __netif_receive_skb_core may change the skb pointer passed into it (e.g.
> in rx_handler). The original skb may be freed as a result of this
> operation.
> 
> The callers of __netif_receive_skb_core may further process original skb
> by using pt_prev pointer returned by __netif_receive_skb_core thus
> leading to unpleasant effects.
> 
> The solution is to pass skb by reference into __netif_receive_skb_core.
> 
> v2: Added Fixes tag and comment regarding ppt_prev and skb invariant.
> 
> Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>

Applied and queued up for -stable.

> @@ -4997,6 +4997,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>  	bool deliver_exact = false;
>  	int ret = NET_RX_DROP;
>  	__be16 type;
> +	struct sk_buff *skb = *pskb;

I fixed up the reverse christmas tree variable ordering here, please take
care in this area next time.

Thank you.
