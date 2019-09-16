Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E2CB4154
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbfIPTrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:47:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50622 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfIPTrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:47:11 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70FB6153F26F6;
        Mon, 16 Sep 2019 12:47:09 -0700 (PDT)
Date:   Mon, 16 Sep 2019 21:47:07 +0200 (CEST)
Message-Id: <20190916.214707.1312089672859838604.davem@davemloft.net>
To:     dongli.zhang@oracle.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xen-netfront: do not assume sk_buff_head list is
 empty in error handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568605619-22219-1-git-send-email-dongli.zhang@oracle.com>
References: <1568605619-22219-1-git-send-email-dongli.zhang@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 12:47:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>
Date: Mon, 16 Sep 2019 11:46:59 +0800

> When skb_shinfo(skb) is not able to cache extra fragment (that is,
> skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS), xennet_fill_frags() assumes
> the sk_buff_head list is already empty. As a result, cons is increased only
> by 1 and returns to error handling path in xennet_poll().
> 
> However, if the sk_buff_head list is not empty, queue->rx.rsp_cons may be
> set incorrectly. That is, queue->rx.rsp_cons would point to the rx ring
> buffer entries whose queue->rx_skbs[i] and queue->grant_rx_ref[i] are
> already cleared to NULL. This leads to NULL pointer access in the next
> iteration to process rx ring buffer entries.
> 
> Below is how xennet_poll() does error handling. All remaining entries in
> tmpq are accounted to queue->rx.rsp_cons without assuming how many
> outstanding skbs are remained in the list.
> 
>  985 static int xennet_poll(struct napi_struct *napi, int budget)
> ... ...
> 1032           if (unlikely(xennet_set_skb_gso(skb, gso))) {
> 1033                   __skb_queue_head(&tmpq, skb);
> 1034                   queue->rx.rsp_cons += skb_queue_len(&tmpq);
> 1035                   goto err;
> 1036           }
> 
> It is better to always have the error handling in the same way.
> 
> Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Applied and queued up for -stable.
