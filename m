Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AE3668A84
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 05:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjAMEER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 23:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjAMEEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 23:04:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC2160849;
        Thu, 12 Jan 2023 20:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D65DB8204D;
        Fri, 13 Jan 2023 04:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A68C433D2;
        Fri, 13 Jan 2023 04:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673582637;
        bh=KGBAhpzgkmQE7nz+ygylQKAsjnMy2pMUvzabm7ipyu0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tsVb9OQckuxxyeCcchhiJRyMaxgJTINOKjwKnPGDL17va1EV61zW2H8CCe0kGU2+m
         z1wlROIMf8Ea+CY7GebeBNdb+rxUnTxRj0OT7J8SvPsMv1jLThKF+GSYI4z8oInSLy
         OFYFCNfMXX+yGC9nQ7OEr1fUWVhCao1gZ31BYB3fxjBcrfvl1D34/QqF/tBWsg/VVg
         07KdvCOc5DN+JqhVmBXR2D51tIW1Zq759FHfE2r2TGu9YxPMt/3Ajsq8zQLJUACcM/
         4gzHYG6DWq0bf5DZeLX1xCrW1TFdtxxt0w578V2tOxFRw+6qj27emK9w2h73i2oCne
         AZi3Zc1onE/VA==
Message-ID: <e224073d-4c92-9a11-5385-4c38b06e6d15@kernel.org>
Date:   Thu, 12 Jan 2023 21:03:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next v2] ipv6: remove max_size check inline with ipv4
Content-Language: en-US
To:     Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20230112012532.311021-1-jmaxwell37@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230112012532.311021-1-jmaxwell37@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/23 6:25 PM, Jon Maxwell wrote:
> v2: Correct syntax error in net/ipv6/route.c
> 
> In ip6_dst_gc() replace: 
> 
> if (entries > gc_thresh)
> 
> With:
> 
> if (entries > ops->gc_thresh)
> 
> Sending Ipv6 packets in a loop via a raw socket triggers an issue where a 
> route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly 
> consumes the Ipv6 max_size threshold which defaults to 4096 resulting in 
> these warnings:
> 
> [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> .
> .
> [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> 
> When this happens the packet is dropped and sendto() gets a network is 
> unreachable error:
> 
> # ./a.out -s 
> 
> remaining pkt 200557 errno 101
> remaining pkt 196462 errno 101
> .
> .
> remaining pkt 126821 errno 101
> 
> Implement David Aherns suggestion to remove max_size check seeing that Ipv6 
> has a GC to manage memory usage. Ipv4 already does not check max_size.
> 
> Here are some memory comparisons for Ipv4 vs Ipv6 with the patch:
> 
> Test by running 5 instances of a program that sends UDP packets to a raw 
> socket 5000000 times. Compare Ipv4 and Ipv6 performance with a similar 
> program.
> 
> Ipv4: 
> 
> Before test:
> 
> # grep -e Slab -e Free /proc/meminfo
> MemFree:        29427108 kB
> Slab:             237612 kB
> 
> # grep dst_cache /proc/slabinfo
> ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
> xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
> ip_dst_cache        2881   3990    192   42    2 : tunables    0    0    0 
> 
> During test:
> 
> # grep -e Slab -e Free /proc/meminfo
> MemFree:        29417608 kB
> Slab:             247712 kB
> 
> # grep dst_cache /proc/slabinfo
> ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
> xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
> ip_dst_cache       44394  44394    192   42    2 : tunables    0    0    0 
> 
> After test:
> 
> # grep -e Slab -e Free /proc/meminfo
> MemFree:        29422308 kB
> Slab:             238104 kB
> 
> # grep dst_cache /proc/slabinfo
> ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
> xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
> ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0 
> 
> Ipv6 with patch:
> 
> Errno 101 errors are not observed anymore with the patch.
> 
> Before test:
> 
> # grep -e Slab -e Free /proc/meminfo
> MemFree:        29422308 kB
> Slab:             238104 kB
> 
> # grep dst_cache /proc/slabinfo
> ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
> xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
> ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0 
> 
> During Test:
> 
> # grep -e Slab -e Free /proc/meminfo
> MemFree:        29431516 kB
> Slab:             240940 kB
> 
> # grep dst_cache /proc/slabinfo
> ip6_dst_cache      11980  12064    256   32    2 : tunables    0    0    0
> xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0
> 
> After Test:
> 
> # grep -e Slab -e Free /proc/meminfo
> MemFree:        29441816 kB
> Slab:             238132 kB
> 
> # grep dst_cache /proc/slabinfo
> ip6_dst_cache       1902   2432    256   32    2 : tunables    0    0    0
> xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0
> 
> Tested-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  include/net/dst_ops.h |  2 +-
>  net/core/dst.c        |  8 ++------
>  net/ipv6/route.c      | 13 +++++--------
>  3 files changed, 8 insertions(+), 15 deletions(-)
> 

Thanks for the data in the commit message.

Reviewed-by: David Ahern <dsahern@kernel.org>



