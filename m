Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38436B9D49
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCNRpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCNRps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAB2B1B3C;
        Tue, 14 Mar 2023 10:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E901D61873;
        Tue, 14 Mar 2023 17:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A61C4339B;
        Tue, 14 Mar 2023 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678815942;
        bh=+3ZE6yZAH/YDpiyHhK95njQNBuzozufhyHjVe8cQxCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JISf94gWFh9rfezWXFFnWHOHd3ahRMgjuwROV/TzIb4LJ2wQZwYxhg6ODEXBCHqeI
         vBcJm8NiuGpsFtI+QDWwO7eDPJp5chF8hcR49q7+eqDiN36+m/NUOqiu9ZKzOFuKK/
         98kqYnD1lL63PaRTRlcGCUsa076EzjLakBq9BAfUxF005s9f00zKDEVRfJhKNATj4B
         P9we9BGjD27hSizkKa8e0pSt3PJxjAfS36Ympk/tx1Gm38R4nQt5mHUicVkwI6h9DD
         RNgmdwT5drcIYfy2MvEpVCJsvaETXymhiMXPvRJi7KfOVF6fNRFanQceHUFUnP5gjz
         S2mJXZXtrWhmA==
Date:   Tue, 14 Mar 2023 17:45:37 +0000
From:   Lee Jones <lee@kernel.org>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>, stable@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [STABLE REQUEST] tipc: improve function tipc_wait_for_cond()
Message-ID: <20230314174537.GA1642994@google.com>
References: <20190219042048.23243-1-tung.q.nguyen@dektech.com.au>
 <20190219042048.23243-2-tung.q.nguyen@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190219042048.23243-2-tung.q.nguyen@dektech.com.au>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Stable,

> Commit 844cf763fba6 ("tipc: make macro tipc_wait_for_cond() smp safe")
> replaced finish_wait() with remove_wait_queue() but still used
> prepare_to_wait(). This causes unnecessary conditional
> checking  before adding to wait queue in prepare_to_wait().
>
> This commit replaces prepare_to_wait() with add_wait_queue()
> as the pair function with remove_wait_queue().
>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
> ---
>  net/tipc/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 1217c90a363b..81b87916a0eb 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -388,7 +388,7 @@ static int tipc_sk_sock_err(struct socket *sock, long *timeout)
>  		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
>  		if (rc_)						       \
>  			break;						       \
> -		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
> +		add_wait_queue(sk_sleep(sk_), &wait_);                         \
>  		release_sock(sk_);					       \
>  		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
>  		sched_annotate_sleep();				               \

Could we have this ol' classic backported to v4.19 and v4.14 please?

--
Lee Jones [李琼斯]
