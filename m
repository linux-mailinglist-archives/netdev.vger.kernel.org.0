Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB80AC6DA
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405992AbfIGNsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:48:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733096AbfIGNsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:48:13 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 927A51525C2D4;
        Sat,  7 Sep 2019 06:48:11 -0700 (PDT)
Date:   Sat, 07 Sep 2019 15:48:09 +0200 (CEST)
Message-Id: <20190907.154809.649105225947712090.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     ajk@comnets.uni-bremen.de, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/hamradio/6pack: Fix the size of a sk_buff used in
 'sp_bump()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826190209.16795-1-christophe.jaillet@wanadoo.fr>
References: <20190826190209.16795-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 06:48:12 -0700 (PDT)
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

I applied your patch as-is, as it is correct and doesn't change the contents
of the data put into the SKB at all.

->rcount is the cooked count minus two, but then we copy effectively
cooked count minus one bytes from one byte past the beginning of the
cooked buffer and so all the accesses are in range on the input buffer
side.
