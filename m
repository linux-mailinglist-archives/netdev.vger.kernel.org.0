Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A58302E2
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfE3Tif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:38:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3Tif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:38:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3509214DA8954;
        Thu, 30 May 2019 12:38:34 -0700 (PDT)
Date:   Thu, 30 May 2019 12:38:33 -0700 (PDT)
Message-Id: <20190530.123833.494901093768074533.davem@davemloft.net>
To:     92siuyang@gmail.com
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: isac: fix a possible concurrency
 use-after-free bug in ISAC_l1hw()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559119739-27588-1-git-send-email-92siuyang@gmail.com>
References: <1559119739-27588-1-git-send-email-92siuyang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:38:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>
Date: Wed, 29 May 2019 16:48:59 +0800

> In drivers/isdn/hisax/isac.c, the function isac_interrupt() and
> ISAC_l1hw() may be concurrently executed.
> 
> ISAC_l1hw()
>     line 499: if (!cs->tx_skb)
> 
> isac_interrupt()
>     line 250: dev_kfree_skb_irq(cs->tx_skb);
> 
> Thus, a possible concurrency use-after-free bug may occur in ISAC_l1hw().
 ...
> +		spin_lock_irqsave(&cs->lock, flags);
>  		if (!cs->tx_skb) {
>  			test_and_clear_bit(FLG_L1_PULL_REQ, &st->l1.Flags);
>  			st->l1.l1l2(st, PH_PULL | CONFIRM, NULL);
>  		} else
>  			test_and_set_bit(FLG_L1_PULL_REQ, &st->l1.Flags);
> +		spin_unlock_irqrestore(&cs->lock, flags);

Nothing in this code accesses the cs->tx_skb object.  It is just a logic test
upon whether it is NULL or not.

I'm not applying stuff like this, sorry.

You have to show how something can actually go wrong when fixing a bug.
