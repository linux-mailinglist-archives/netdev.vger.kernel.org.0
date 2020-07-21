Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D04922748D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgGUBbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGUBbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:31:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B408C061794;
        Mon, 20 Jul 2020 18:31:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E513011FFCC36;
        Mon, 20 Jul 2020 18:14:28 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:31:13 -0700 (PDT)
Message-Id: <20200720.183113.2100585349998522874.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     vishal@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu
Subject: Re: [PATCH] cxgb4: add missing release on skb in uld_send()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200718051845.10218-1-navid.emamdoost@gmail.com>
References: <20200718051845.10218-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:14:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Sat, 18 Jul 2020 00:18:43 -0500

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
> index 32a45dc51ed7..d8c37fd4b808 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
> @@ -2938,6 +2938,7 @@ static inline int uld_send(struct adapter *adap, struct sk_buff *skb,
>  	txq_info = adap->sge.uld_txq_info[tx_uld_type];
>  	if (unlikely(!txq_info)) {
>  		WARN_ON(true);
> +		consume_skb(skb);
>  		return NET_XMIT_DROP;
>  	}
>  

This is a packet drop so kfree_skb() is more appropriate here.
