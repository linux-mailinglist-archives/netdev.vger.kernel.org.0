Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840D99F97B
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfH1Ejy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:39:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfH1Ejy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:39:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF680153C23C6;
        Tue, 27 Aug 2019 21:39:53 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:39:53 -0700 (PDT)
Message-Id: <20190827.213953.102911550129423796.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     ajk@comnets.uni-bremen.de, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/hamradio/6pack: Fix the size of a sk_buff used in
 'sp_bump()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826190209.16795-1-christophe.jaillet@wanadoo.fr>
References: <20190826190209.16795-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 21:39:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Mon, 26 Aug 2019 21:02:09 +0200

> We 'allocate' 'count' bytes here. In fact, 'dev_alloc_skb' already add some
> extra space for padding, so a bit more is allocated.
> 
> However, we use 1 byte for the KISS command, then copy 'count' bytes, so
> count+1 bytes.
> 
> Explicitly allocate and use 1 more byte to be safe.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch should be safe, be however may no be the correct way to fix the
> "buffer overflow". Maybe, the allocated size is correct and we should have:
>    memcpy(ptr, sp->cooked_buf + 1, count - 1);
> or
>    memcpy(ptr, sp->cooked_buf + 1, count - 1sp->rcount);
> 
> I've not dig deep enough to understand the link betwwen 'rcount' and
> how 'cooked_buf' is used.

I'm trying to figure out how this code works too.

Why are they skipping over the first byte?  Is that to avoid the
command byte?  Yes, then using sp->rcount as the memcpy length makes
sense.

Why is the caller subtracting 2 from the RX buffer count when
calculating sp->rcount?  This makes the situation even more confusing.

