Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2946E0DFA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDMNF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjDMNF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F441704
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B98EC60F02
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8EBC433D2;
        Thu, 13 Apr 2023 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681391153;
        bh=nqe2Gk1lN7H/aLipYkQz+uliQ5S2rHHwHJdss9O8p1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AOsxN24/CSRzIimNJWBZlpbXwCtZ1QPNbLL0em1TkrC22zGLEVxqaOvhnBWLd5nIt
         zrnN7qSQhcxLkLkHa/5pdjlzCEJDpFBxXA8yrG4RADXoLRIKkA6G+TSXM/JTaCUNSQ
         5XMCpIzbIeizT13C0350gIjAFHZwIQli1QiW9rkfBfITitSdNebxL9IFy1hqWI71xn
         bCKQNBBcGEqQxzVW80LL/zfN/jH+tF1elDCBe0W5d84y96/Yktf98YNqyb+eQZAURe
         K0eUIuX3n4LKF98wXI7tYFIMh+DMYMKFNHEoz5jg7mDCCgC8YrHaRzgz+iXpP0XSB4
         ZQkpjp+lzTvXg==
Date:   Thu, 13 Apr 2023 16:05:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: add macro netif_subqueue_completed_wake
Message-ID: <20230413130548.GP17993@unreal>
References: <61877868-4fb7-4b9a-fd0d-41da1d9149b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61877868-4fb7-4b9a-fd0d-41da1d9149b4@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 11:25:10PM +0200, Heiner Kallweit wrote:
> Add netif_subqueue_completed_wake, complementing the subqueue versions
> netif_subqueue_try_stop and netif_subqueue_maybe_stop.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  include/net/netdev_queues.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Please send together with in-tree user of this macro.

Thanks


> 
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index b26fdb441..d68b0a483 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -160,4 +160,14 @@ netdev_txq_completed_mb(struct netdev_queue *dev_queue,
>  		netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs); \
>  	})
>  
> +#define netif_subqueue_completed_wake(dev, idx, pkts, bytes,		\
> +				      get_desc, start_thrs)		\
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq = netdev_get_tx_queue(dev, idx);			\
> +		netif_txq_completed_wake(txq, pkts, bytes,		\
> +					 get_desc, start_thrs);		\
> +	})
> +
>  #endif
> -- 
> 2.40.0
> 
