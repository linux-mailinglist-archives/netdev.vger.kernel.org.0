Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC764749A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiLHQsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLHQr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:47:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70C338A0
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 390FEB82511
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E56BC433D2;
        Thu,  8 Dec 2022 16:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670518074;
        bh=6r4jJjUrky13iXNiDH8xNc4743RLEstwLqZMAaakrpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oRk5+m5Xbq+JeNOW31QoWsQVeHerhzhTVQQc08r/T3QMoGde360ut9oLCDbJG+baB
         ChyhHMbP2cj8nQB5xEX3TlAr0KqWXqiGdPi5PECv1DPpoAfyKewrHP3S9tGHFNeH/f
         Rc8HnxRk7Hx+55j27BBkvM4rXP9WMpAZRkClF6bD3fOEn2XOFR1a72KaIvHEuKcvf4
         AUw7O9BA8WrYBSLCkjVLVFxev1bXkl8pozRVjzLgkEvvZD6nVuaPbVlOKjNxpNRrlU
         h2BUVGdi9h0rQI7B5qlpLSx46Xj0hOvClWwcdkm7Pvb7zp2KkzM0W021W9S0b8x5Hw
         2XGnO+Cjh2VsA==
Date:   Thu, 8 Dec 2022 08:47:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <leon@kernel.org>
Subject: Re: [PATCH net v4] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <20221208084753.6523ff23@kernel.org>
In-Reply-To: <20221208120121.2076486-1-yangyingliang@huawei.com>
References: <20221208120121.2076486-1-yangyingliang@huawei.com>
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

On Thu, 8 Dec 2022 20:01:21 +0800 Yang Yingliang wrote:
> It is not allowed to call kfree_skb() or consume_skb() from hardware
> interrupt context or with hardware interrupts being disabled.
> 
> It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
> The difference between them is free reason, dev_kfree_skb_irq() means
> the SKB is dropped in error and dev_consume_skb_irq() means the SKB
> is consumed in normal.
> 
> In this case, dev_kfree_skb() is called in free_tx_buffers() to drop
> the SKBs in tx buffers, when the card is down, so replace it with
> dev_kfree_skb_irq() here.

Make sure you read this:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
