Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0446C250C2F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgHXXQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXXQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:16:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347E6C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 16:16:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 326BF129242DF;
        Mon, 24 Aug 2020 15:59:56 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:16:41 -0700 (PDT)
Message-Id: <20200824.161641.333865613724287036.davem@davemloft.net>
To:     luke.w.hsiao@gmail.com
Cc:     netdev@vger.kernel.org, axboe@kernel.dk, kuba@kernel.org,
        lukehsiao@google.com, soheil@google.com, arjunroy@google.com,
        edumazet@google.com, jannh@google.com
Subject: Re: [PATCH net-next v3 1/2] io_uring: allow tcp ancillary data for
 __sys_recvmsg_sock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
References: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
        <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:59:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <luke.w.hsiao@gmail.com>
Date: Fri, 21 Aug 2020 21:41:04 -0700

> From: Luke Hsiao <lukehsiao@google.com>
> 
> For TCP tx zero-copy, the kernel notifies the process of completions by
> queuing completion notifications on the socket error queue. This patch
> allows reading these notifications via recvmsg to support TCP tx
> zero-copy.
> 
> Ancillary data was originally disallowed due to privilege escalation
> via io_uring's offloading of sendmsg() onto a kernel thread with kernel
> credentials (https://crbug.com/project-zero/1975). So, we must ensure
> that the socket type is one where the ancillary data types that are
> delivered on recvmsg are plain data (no file descriptors or values that
> are translated based on the identity of the calling process).
> 
> This was tested by using io_uring to call recvmsg on the MSG_ERRQUEUE
> with tx zero-copy enabled. Before this patch, we received -EINVALID from
> this specific code path. After this patch, we could read tcp tx
> zero-copy completion notifications from the MSG_ERRQUEUE.

Would be great to see such test programs added to selftests instead of
vaguely being described.

> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Luke Hsiao <lukehsiao@google.com>

Applied.
