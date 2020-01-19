Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721A2141D9E
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgASLbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgASLb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:28 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C41414CDB4DB;
        Sun, 19 Jan 2020 03:31:26 -0800 (PST)
Date:   Sun, 19 Jan 2020 11:00:31 +0100 (CET)
Message-Id: <20200119.110031.253679721520131241.davem@davemloft.net>
To:     blackgod016574@gmail.com
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: tg3: fix potential UAF in
 tigon3_dma_hwbug_workaround()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116033044.GA2783@hunterzg-yangtiant6900c-00>
References: <20200116033044.GA2783@hunterzg-yangtiant6900c-00>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>
Date: Thu, 16 Jan 2020 11:30:44 +0800

> In tigon3_dma_hwbug_workaround(), pskb is first stored in skb. And this
> function is to store new_skb into pskb at the end. However, in the error
> paths when new_skb is freed by dev_kfree_skb_any(), stroing new_skb to pskb
> should be prevented.
> 
> And freeing skb with dev_consume_skb_any() should be executed after storing
> new_skb to pskb, because freeing skb will free pskb (alias).
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

There are no bugs here.

The caller never references "*pskb" when an error is returned.  So it is
safe to store any value whatsoever into that pointer.

'skb' never changes it's value even if we store something into *pskb
because we've loaded it into a local variable.  So it is always safe to
call dev_consume_skb_any() on 'skb' in any order with respect to that
assignment.

I'm not applying this until you can show a real bug resulting from
the current code, and if so you'll need to add that explanation to
your commit message.

Thanks.
