Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238F91E1887
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbgEZAmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEZAmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:42:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA06DC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:42:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BB301279064B;
        Mon, 25 May 2020 17:42:41 -0700 (PDT)
Date:   Mon, 25 May 2020 17:42:41 -0700 (PDT)
Message-Id: <20200525.174241.85970384865891191.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next,v2] net/tls: fix race condition causing kernel
 panic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522201031.32516-1-vinay.yadav@chelsio.com>
References: <20200522201031.32516-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:42:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Sat, 23 May 2020 01:40:31 +0530

> tls_sw_recvmsg() and tls_decrypt_done() can be run concurrently.
> // tls_sw_recvmsg()
> 	if (atomic_read(&ctx->decrypt_pending))
> 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
> 	else
> 		reinit_completion(&ctx->async_wait.completion);
> 
> //tls_decrypt_done()
>   	pending = atomic_dec_return(&ctx->decrypt_pending);
> 
>   	if (!pending && READ_ONCE(ctx->async_notify))
>   		complete(&ctx->async_wait.completion);
> 
> Consider the scenario tls_decrypt_done() is about to run complete()
> 
> 	if (!pending && READ_ONCE(ctx->async_notify))
> 
> and tls_sw_recvmsg() reads decrypt_pending == 0, does reinit_completion(),
> then tls_decrypt_done() runs complete(). This sequence of execution
> results in wrong completion. Consequently, for next decrypt request,
> it will not wait for completion, eventually on connection close, crypto
> resources freed, there is no way to handle pending decrypt response.
> 
> This race condition can be avoided by having atomic_read() mutually
> exclusive with atomic_dec_return(),complete().Intoduced spin lock to
> ensure the mutual exclution.
> 
> Addressed similar problem in tx direction.
> 
> v1->v2:
> - More readable commit message.
> - Corrected the lock to fix new race scenario.
> - Removed barrier which is not needed now.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied to 'net' as this is a bug fix, with Fixes tag from Jakub added,
and queued up for -stable.

Thanks.
