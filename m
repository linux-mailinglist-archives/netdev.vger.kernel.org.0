Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9150BD41
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349414AbiDVQnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449746AbiDVQnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F325E6335
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94E1862104
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B738EC385A0;
        Fri, 22 Apr 2022 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650645616;
        bh=8+3mbxubWHDo+aOSTZTjV9v5jyTv6+7Bu8mQBsIYKMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDvQdqLGQp64loG8118+nIHFMnsp49ZLC1bs46MT1bKHa9Y0bVWqAz/ApSokXXGWO
         q8DT6+VKhT/Vw3bw2YjwADBi/QILiYRgtiWudhVmgc48EQQyKRNzaC2ALXleEfvX3V
         gXOrdOf1AsRSCoWFbc6wfxlgjKlcxSOY27ozSInibMnujuNLiu5FVq6sGy3Iot0/UR
         u79AoYWniGRnt94yaNc3BzssBvbzqvCCTAkzcCMMaIUoLkEUiHR4gr+QomGznl3wf3
         s6+0ZQvCQpbO1k5dFY/zYSEgxsZxYuVbcFDCwgzWng6T/14FoL7iN53ZGOIdB0NUdC
         Xl3xj5NA4Ddvg==
Date:   Fri, 22 Apr 2022 09:40:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to
 per-cpu lists
Message-ID: <20220422094014.1bcf78d5@kernel.org>
In-Reply-To: <20220421153920.3637792-1-eric.dumazet@gmail.com>
References: <20220421153920.3637792-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 08:39:20 -0700 Eric Dumazet wrote:
> 10 runs of one TCP_STREAM flow

Was the test within a NUMA node or cross-node?

For my learning - could this change cause more cache line bouncing 
than individual per-socket lists for non-RFS setups. Multiple CPUs 
may try to queue skbs for freeing on one remove node.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 7dccbfd1bf5635c27514c70b4a06d3e6f74395dd..0162a9bdc9291e7aae967a044788d09bd2ef2423 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3081,6 +3081,9 @@ struct softnet_data {
>  	struct sk_buff_head	input_pkt_queue;
>  	struct napi_struct	backlog;
>  
> +	/* Another possibly contended cache line */
> +	struct sk_buff_head	skb_defer_list ____cacheline_aligned_in_smp;

If so maybe we can avoid some dirtying and use a single-linked list? 
No point modifying the cache line of the skb already on the list.

> +	call_single_data_t  csd_defer;
>  };
