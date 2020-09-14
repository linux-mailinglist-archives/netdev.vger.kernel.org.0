Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6839B2696CB
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgINUgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgINUgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:36:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D5FC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:36:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D59F1278A16A;
        Mon, 14 Sep 2020 13:19:27 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:36:13 -0700 (PDT)
Message-Id: <20200914.133613.2303200671140457460.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com
Subject: Re: [PATCH net-next] tcp: remove SOCK_QUEUE_SHRUNK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914102027.3746717-1-edumazet@google.com>
References: <20200914102027.3746717-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:19:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 14 Sep 2020 03:20:27 -0700

> SOCK_QUEUE_SHRUNK is currently used by TCP as a temporary state
> that remembers if some room has been made in the rtx queue
> by an incoming ACK packet.
> 
> This is later used from tcp_check_space() before
> considering to send EPOLLOUT.
> 
> Problem is: If we receive SACK packets, and no packet
> is removed from RTX queue, we can send fresh packets, thus
> moving them from write queue to rtx queue and eventually
> empty the write queue.
> 
> This stall can happen if TCP_NOTSENT_LOWAT is used.
> 
> With this fix, we no longer risk stalling sends while holes
> are repaired, and we can fully use socket sndbuf.
> 
> This also removes a cache line dirtying for typical RPC
> workloads.
> 
> Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
