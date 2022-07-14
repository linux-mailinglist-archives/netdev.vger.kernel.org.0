Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0F857414C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiGNCHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiGNCHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:07:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E93237F5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 19:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB05AB82287
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5012BC3411E;
        Thu, 14 Jul 2022 02:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657764469;
        bh=lkqXasHpMAeOwxuxt+4MAVWJVx+JnKRwQ2WlcfON/3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aW/ZiENTQvzG1VKzWOujhKrFGBBveA++lmPhX7WgdnMLIyTGdqofoNCoLdfLrE5Ag
         2k/ti7MQ9sTdYZcXPjiqEDaQdAckSL+B7vjpeR4lWkjqPvcyrkUZnIplb1h/s43Gag
         S9TLaymKj5ptm3SGHyLjcimbIhryNszIZ3jYSl5oa+XEWMdb4ZdRuUPfvKXryjlar9
         gpcRcYDjs9GZcrVEe7mXI0wAKEdr/a+ZNKwXad7IyVd5Vzy0duwyEFq+OqKf3b2q6P
         +jsfKxpR1zUl8MVvzL8YuOlwLNbx2+YrY2lnX3x8i6wfIP80d/vLNFdJfdCCq6VrKV
         CYGVvUKF+hhMw==
Date:   Wed, 13 Jul 2022 19:07:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com
Subject: Re: [PATCH] net: sort queues in xps maps
Message-ID: <20220713190748.323cf866@kernel.org>
In-Reply-To: <1657679096-38572-1-git-send-email-liyonglong@chinatelecom.cn>
References: <1657679096-38572-1-git-send-email-liyonglong@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 10:24:56 +0800 Yonglong Li wrote:
> in the following case that set xps of each tx-queue with same cpu mask,
> packets in the same tcp stream may be hash to different tx queue. Because
> the order of queues in each xps map is not the same.
> 
> first set each tx-queue with different cpu mask
> echo 0 > /sys/class/net/eth0/queues/tx-0
> echo 1 > /sys/class/net/eth0/queues/tx-1
> echo 2 > /sys/class/net/eth0/queues/tx-2
> echo 4 > /sys/class/net/eth0/queues/tx-3
> and then set each tx-queue with same cpu mask
> echo f > /sys/class/net/eth0/queues/tx-0
> echo f > /sys/class/net/eth0/queues/tx-1
> echo f > /sys/class/net/eth0/queues/tx-2
> echo f > /sys/class/net/eth0/queues/tx-3

These commands look truncated.

> at this point the order of each map queues is differnet, It will cause
> packets in the same stream be hashed to diffetent tx queue:
> attr_map[0].queues = [0,1,2,3]
> attr_map[1].queues = [1,0,2,3]
> attr_map[2].queues = [2,0,1,3]
> attr_map[3].queues = [3,0,1,2]
> 
> It is more reasonable that pacekts in the same stream be hashed to the same
> tx queue when all tx queue bind with the same CPUs.
> 
> Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")

I'd suggest treating this as a general improvement rather than fix,
the kernel always behaved this way - it seems logical that sorted is
better but whether it's a bug not to sort is not as clear cut.

> @@ -2654,6 +2660,13 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  					  skip_tc);
>  	}
>  
> +	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> +	     j < nr_ids;) {
> +		tci = j * num_tc + tc;
> +		map = xmap_dereference(new_dev_maps->attr_map[tci]);
> +		sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
> +	}
> +

Can we instead make sure that expand_xps_map() maintains order?
