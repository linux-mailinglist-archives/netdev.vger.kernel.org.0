Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483CF6BA70A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjCOF0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjCOF01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:26:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4377B1B2FD;
        Tue, 14 Mar 2023 22:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7FB1B81BFA;
        Wed, 15 Mar 2023 05:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19369C4339C;
        Wed, 15 Mar 2023 05:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678857394;
        bh=Bhf7zj25Ro7zhgY0ji25HnJhOcSay0ch2FcQZvqYmmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KtEnVijbBHGKL9D6jjLyq/rn2fDGj//tM1kuf97hh6yAIgvsjb2Ey6O0q+CA8pwrA
         /feO4+WkpJkdQCdYb94b6lxQaEJcSgBIop0dxFguAVePkpaes7fcD9WEKltEkMS86y
         BHDp9BVdb3UJZbrw860qMJwc99zC2yICry68b7SlGRdp6dgSfQrqHgHijJJAa/hJ+6
         FH/uQgEoHPrz6HFPI6EphsIm+IWD8h+FMVe9ZCBm+mI10ltYpuutPIsucDJ17lNY3p
         cv5p+BEGmdHkvMyIxpxjsT7J99HqFkmqeGOGEmVYBXZppWCwAgRXWSvhxcCHyzhUi2
         h1VjA+a3rtTlw==
Date:   Tue, 14 Mar 2023 22:16:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/5] connector/cn_proc: Add filtering to fix some
 bugs
Message-ID: <20230314221633.1e6c9bef@kernel.org>
In-Reply-To: <20230315021850.2788946-3-anjali.k.kulkarni@oracle.com>
References: <20230315021850.2788946-1-anjali.k.kulkarni@oracle.com>
        <20230315021850.2788946-3-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 19:18:47 -0700 Anjali Kulkarni wrote:
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 003c7e6ec9be..ad8ec18152cd 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -63,6 +63,7 @@
>  #include <linux/net_namespace.h>
>  #include <linux/nospec.h>
>  #include <linux/btf_ids.h>
> +#include <linux/connector.h>

Not needed any more.

>  	/* must not acquire netlink_table_lock in any way again before unbind
>  	 * and notifying genetlink is done as otherwise it might deadlock
>  	 */
> -	if (nlk->netlink_unbind) {
> +	if (nlk->netlink_unbind && nlk->groups) {

Why?

>  		int i;
> -
>  		for (i = 0; i < nlk->ngroups; i++)
>  			if (test_bit(i, nlk->groups))
>  				nlk->netlink_unbind(sock_net(sk), i + 1);

Please separate the netlink core changes from the connector
changes.

Please slow down with new versions, we have 300 patches in the queue,
replying to one version just to notice you posted a new one is
frustrating. Give reviewers 24h to reply.
