Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EFF895DF
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 05:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfHLD5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 23:57:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLD5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 23:57:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C49FF143BF5BC;
        Sun, 11 Aug 2019 20:57:19 -0700 (PDT)
Date:   Sun, 11 Aug 2019 20:57:19 -0700 (PDT)
Message-Id: <20190811.205719.198343441735959015.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     tglx@linutronix.de, gregkh@linuxfoundation.org,
        colin.king@canonical.com, allison@lohutok.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] nfc: st-nci: Fix an incorrect skb_buff size in
 'st_nci_i2c_read()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806141640.13197-1-christophe.jaillet@wanadoo.fr>
References: <20190806141640.13197-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 20:57:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue,  6 Aug 2019 16:16:40 +0200

> In 'st_nci_i2c_read()', we allocate a sk_buff with a size of
> ST_NCI_I2C_MIN_SIZE + len.
> 
> However, later on, we first 'skb_reserve()' ST_NCI_I2C_MIN_SIZE bytes, then
> we 'skb_put()' ST_NCI_I2C_MIN_SIZE bytes.
> Finally, if 'len' is not 0, we 'skb_put()' 'len' bytes.
> 
> So we use ST_NCI_I2C_MIN_SIZE*2 + len bytes.
> 
> This is incorrect and should already panic. I guess that it does not occur
> because of extra memory allocated because of some rounding.
> 
> Fix it and allocate enough room for the 'skb_reserve()' and the 'skb_put()'
> calls.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is LIKELY INCORRECT. So think twice to what is the correct
> solution before applying it.
> Maybe the skb_reserve should be axed or some other sizes are incorrect.
> There seems to be an issue, that's all I can say.

The skb_reserve() should be removed, and the second memcpy() should remove
the " + ST_NCI_I2C_MIN_SIZE".

This SKB just get sent down to ndlc_recv() so the content returned from I2C
should places at skb->data to be processed.

Pretty clear this code was never tested.
