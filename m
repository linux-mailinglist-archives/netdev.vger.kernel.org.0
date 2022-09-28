Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740175ED962
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiI1JqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiI1JqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:46:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D4597D42;
        Wed, 28 Sep 2022 02:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF5BB61DE6;
        Wed, 28 Sep 2022 09:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE924C433D6;
        Wed, 28 Sep 2022 09:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664358375;
        bh=X0Qhc9iLIP8xYLEQvpMkrhuGs70pVHyhsJYCdLtOALY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W8O7gjTWXq9XhF7ur5LksP3gzuLYWEeKWzx19KOd8bNm2US2qTEQsV3Tmyq72XjnC
         rX831/OIxEYwdccBOy9cWs/2u5N0yIIlSzb3JmIsG7kG6ZSEqdXO8XMHPOPqHQCqda
         T0RHLx5Mv4b69qoII7Ea9PJmuXx8HNu9qGTFEmgYTGlHeU29Ak+IF2ZEX6cogUOxkn
         knq+G2vSg5rWTNa5iNp5mNvaL4XPRA13ktsFTNFthwCCmkt4PWIhW61autviUdAw+n
         FSJdRK7CcDbf9ZNzUHU01IPQ7Mno0w0kxpThtdRWb/gda/0glCY0kOCSAx2kqmbhCQ
         lI0vyFV8U6bQQ==
Date:   Wed, 28 Sep 2022 12:46:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org
Subject: Re: [PATCH V2] mISDN: fix use-after-free bugs in l1oip timer handlers
Message-ID: <YzQX4mVT18TT/uoe@unreal>
References: <20220923142514.58838-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923142514.58838-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 10:25:14PM +0800, Duoming Zhou wrote:
> The l1oip_cleanup() traverses the l1oip_ilist and calls
> release_card() to cleanup module and stack. However,
> release_card() calls del_timer() to delete the timers
> such as keep_tl and timeout_tl. If the timer handler is
> running, the del_timer() will not stop it and result in
> UAF bugs. One of the processes is shown below:
> 
>     (cleanup routine)          |        (timer handler)
> release_card()                 | l1oip_timeout()
>  ...                           |
>  del_timer()                   | ...
>  ...                           |
>  kfree(hc) //FREE              |
>                                | hc->timeout_on = 0 //USE
> 
> Fix by calling del_timer_sync() in release_card(), which
> makes sure the timer handlers have finished before the
> resources, such as l1oip and so on, have been deallocated.
> 
> What's more, the hc->workq and hc->socket_thread can kick
> those timers right back in. We use del_timer_sync(&hc->keep_tl)
> and cancel_work_sync(&hc->keep_tl) twice to stop keep_tl timer
> and hc->workq. Then, we add del_timer_sync(&hc->timeout_tl)
> behind l1oip_socket_close() to stop timeout_tl timer.
> 
> Fixes: 3712b42d4b1b ("Add layer1 over IP support")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v2:
>   - Solve the problem that timers could be restarted by other threads.
> 
>  drivers/isdn/mISDN/l1oip_core.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
> index 2c40412466e..7b89d98a781 100644
> --- a/drivers/isdn/mISDN/l1oip_core.c
> +++ b/drivers/isdn/mISDN/l1oip_core.c
> @@ -1232,17 +1232,16 @@ release_card(struct l1oip *hc)
>  {
>  	int	ch;
>  
> -	if (timer_pending(&hc->keep_tl))
> -		del_timer(&hc->keep_tl);
> -
> -	if (timer_pending(&hc->timeout_tl))
> -		del_timer(&hc->timeout_tl);
> -
> +	del_timer_sync(&hc->keep_tl);
> +	cancel_work_sync(&hc->workq);
> +	del_timer_sync(&hc->keep_tl);
>  	cancel_work_sync(&hc->workq);

It is racy, the call twice to del_timer_sync and cancel_work_sync
doesn't solve "the problem that timers could be restarted by other
threads."

Thanks

>  
>  	if (hc->socket_thread)
>  		l1oip_socket_close(hc);
>  
> +	del_timer_sync(&hc->timeout_tl);
> +
>  	if (hc->registered && hc->chan[hc->d_idx].dch)
>  		mISDN_unregister_device(&hc->chan[hc->d_idx].dch->dev);
>  	for (ch = 0; ch < 128; ch++) {
> -- 
> 2.17.1
> 
