Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED4822D438
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 05:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgGYDSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 23:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYDSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 23:18:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F9EC0619D3;
        Fri, 24 Jul 2020 20:18:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBE241277D60E;
        Fri, 24 Jul 2020 20:01:14 -0700 (PDT)
Date:   Fri, 24 Jul 2020 20:17:59 -0700 (PDT)
Message-Id: <20200724.201759.487082545769759347.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, edumazet@google.com, ms@dev.tdt.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-x25@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wan: lapb: Corrected the usage of skb_cow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724163347.57213-1-xie.he.0141@gmail.com>
References: <20200724163347.57213-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 20:01:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Fri, 24 Jul 2020 09:33:47 -0700

> This patch fixed 2 issues with the usage of skb_cow in LAPB drivers
> "lapbether" and "hdlc_x25":
> 
> 1) After skb_cow fails, kfree_skb should be called to drop a reference
> to the skb. But in both drivers, kfree_skb is not called.
> 
> 2) skb_cow should be called before skb_push so that is can ensure the
> safety of skb_push. But in "lapbether", it is incorrectly called after
> skb_push.
> 
> More details about these 2 issues:
> 
> 1) The behavior of calling kfree_skb on failure is also the behavior of
> netif_rx, which is called by this function with "return netif_rx(skb);".
> So this function should follow this behavior, too.
> 
> 2) In "lapbether", skb_cow is called after skb_push. This results in 2
> logical issues:
>    a) skb_push is not protected by skb_cow;
>    b) An extra headroom of 1 byte is ensured after skb_push. This extra
>       headroom has no use in this function. It also has no use in the
>       upper-layer function that this function passes the skb to
>       (x25_lapb_receive_frame in net/x25/x25_dev.c).
> So logically skb_cow should instead be called before skb_push.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
