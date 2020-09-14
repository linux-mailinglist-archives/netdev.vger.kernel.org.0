Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77202699F7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgINX6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINX6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:58:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2586C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:58:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C51E128E5E98;
        Mon, 14 Sep 2020 16:41:54 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:58:40 -0700 (PDT)
Message-Id: <20200914.165840.1091897815096752872.davem@davemloft.net>
To:     soheil.kdev@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, soheil@google.com
Subject: Re: [PATCH net-next 2/2] tcp: schedule EPOLLOUT after a partial
 sendmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914215210.2288109-2-soheil.kdev@gmail.com>
References: <20200914215210.2288109-1-soheil.kdev@gmail.com>
        <20200914215210.2288109-2-soheil.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:41:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
Date: Mon, 14 Sep 2020 17:52:10 -0400

> From: Soheil Hassas Yeganeh <soheil@google.com>
> 
> For EPOLLET, applications must call sendmsg until they get EAGAIN.
> Otherwise, there is no guarantee that EPOLLOUT is sent if there was
> a failure upon memory allocation.
> 
> As a result on high-speed NICs, userspace observes multiple small
> sendmsgs after a partial sendmsg until EAGAIN, since TCP can send
> 1-2 TSOs in between two sendmsg syscalls:
> 
> // One large partial send due to memory allocation failure.
> sendmsg(20MB)   = 2MB
> // Many small sends until EAGAIN.
> sendmsg(18MB)   = 64KB
> sendmsg(17.9MB) = 128KB
> sendmsg(17.8MB) = 64KB
> ...
> sendmsg(...)    = EAGAIN
> // At this point, userspace can assume an EPOLLOUT.
> 
> To fix this, set the SOCK_NOSPACE on all partial sendmsg scenarios
> to guarantee that we send EPOLLOUT after partial sendmsg.
> 
> After this commit userspace can assume that it will receive an EPOLLOUT
> after the first partial sendmsg. This EPOLLOUT will benefit from
> sk_stream_write_space() logic delaying the EPOLLOUT until significant
> space is available in write queue.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

Applied.
