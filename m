Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A087E4C609C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiB1BVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiB1BVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D953E5C66B;
        Sun, 27 Feb 2022 17:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86D2CB80CD5;
        Mon, 28 Feb 2022 01:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE50C340EE;
        Mon, 28 Feb 2022 01:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646011226;
        bh=7Vx9N8987kps795HY7hHjHYJ6nh4+GLyowZu6iYELtM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NMDZm1pl8MjI2yjTQ1KLehTgaUU66bT7ORHHMaFpk+2wXw13r+2wOkDMR/3h0iaQc
         qhjmuWEcfszvRa/W9wF/k4yH8YkjBl2WzzMhnIH/noCHD9jyAuF0p0CMYYjiGnpjI8
         x8nC3c5rUkgnA1iPm3J8yMnR9nbFaGXVdaOaL8271Kjv/qTzv1iyGbZscXyhFQl6pw
         ufQiHQkbSjVsGjEIxpUbP6XUHmC0A95eO+NfUCpo1t+FLy9GVWViiPBeEXMKohfZJP
         BKUIKstWRsFGbd6Kv2F5gQZn/Ze4sETDUWjVX0FhbYW9BBOpMMhXt84aNOdzZZHud0
         zhYrJixoE+EEA==
Message-ID: <acdce090-dfa6-5449-ae7c-cfd0dde46aa2@kernel.org>
Date:   Sun, 27 Feb 2022 18:20:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220226084929.6417-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/22 1:49 AM, Dongli Zhang wrote:
> The TUN can be used as vhost-net backend. E.g, the tun_net_xmit() is the
> interface to forward the skb from TUN to vhost-net/virtio-net.
> 
> However, there are many "goto drop" in the TUN driver. Therefore, the
> kfree_skb_reason() is involved at each "goto drop" to help userspace
> ftrace/ebpf to track the reason for the loss of packets.
> 
> The below reasons are introduced:
> 
> - SKB_DROP_REASON_SKB_PULL
> - SKB_DROP_REASON_SKB_TRIM
> - SKB_DROP_REASON_DEV_READY
> - SKB_DROP_REASON_TAP_FILTER
> - SKB_DROP_REASON_TAP_TXFILTER
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - revise the reason name
> Changed since v2:
>   - declare drop_reason as type "enum skb_drop_reason"
> Changed since v3:
>   - rename to TAP_FILTER and TAP_TXFILTER
>   - honor reverse xmas tree style declaration for 'drop_reason' in
>     tun_net_xmit()
> 
>  drivers/net/tun.c          | 37 ++++++++++++++++++++++++++++---------
>  include/linux/skbuff.h     | 10 ++++++++++
>  include/trace/events/skb.h |  5 +++++
>  3 files changed, 43 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
