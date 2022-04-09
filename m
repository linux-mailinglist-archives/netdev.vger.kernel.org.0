Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAB64FA261
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 06:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbiDIETp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 00:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiDIETl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 00:19:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A55DA082;
        Fri,  8 Apr 2022 21:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 462E4B82DEE;
        Sat,  9 Apr 2022 04:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F86DC385A0;
        Sat,  9 Apr 2022 04:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649477852;
        bh=yuNFJXnjSDiht9flU5RGAGntqQXicnTEtSqbIeTHufo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Q3X7AEx3Z6UZz0TPIqRI0sd5VJYzwhgAbQ19TBKJNxuMREqhvmcr0H8ksFfvQhWUZ
         jN2Bgt4ESqhYiWiMbR97KYQETcygX8nSM42RDYxisILFrvHrC0AkYlG36YGM/iBzbd
         I1m9ydIHt5ynOAcE85a5Xzm+E38B5fGpyQAc3GNqkxNutFh4uqBo3E+bSO6iyaOCYJ
         V8Q6fHYI+XvKLLj3zpdVrLkzYNwDLmqXf4ipDzOz7JnZWAbtvALqfnsZdtmjsmmgx4
         rabWFwpNXhPUCKPLgKEQVF/rNc8NQ+5jM7MLTbGrR3qY7rYm4Nqhx4tMF0JzS0rlnn
         nJHVIXziSUbdw==
Message-ID: <16cb992b-f695-0388-25cc-8e41f33b0ee9@kernel.org>
Date:   Fri, 8 Apr 2022 22:17:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND net-next v5 4/4] net: icmp: add skb drop reasons to
 icmp protocol
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
References: <20220407062052.15907-1-imagedong@tencent.com>
 <20220407062052.15907-5-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220407062052.15907-5-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 12:20 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() used in icmp_rcv() and icmpv6_rcv() with
> kfree_skb_reason().
> 
> In order to get the reasons of the skb drops after icmp message handle,
> we change the return type of 'handler()' in 'struct icmp_control' from
> 'bool' to 'enum skb_drop_reason'. This may change its original
> intention, as 'false' means failure, but 'SKB_NOT_DROPPED_YET' means
> success now. Therefore, all 'handler' and the call of them need to be
> handled. Following 'handler' functions are involved:
> 
> icmp_unreach()
> icmp_redirect()
> icmp_echo()
> icmp_timestamp()
> icmp_discard()
> 
> And following new drop reasons are added:
> 
> SKB_DROP_REASON_ICMP_CSUM
> SKB_DROP_REASON_INVALID_PROTO
> 
> The reason 'INVALID_PROTO' is introduced for the case that the packet
> doesn't follow rfc 1122 and is dropped. This is not a common case, and
> I believe we can locate the problem from the data in the packet. For now,
> this 'INVALID_PROTO' is used for the icmp broadcasts with wrong types.
> 
> Maybe there should be a document file for these reasons. For example,
> list all the case that causes the 'UNHANDLED_PROTO' and 'INVALID_PROTO'
> drop reason. Therefore, users can locate their problems according to the
> document.
> 
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v5:
> - rename SKB_DROP_REASON_RFC_1122 to SKB_DROP_REASON_INVALID_PROTO
> 
> v4:
> - remove SKB_DROP_REASON_ICMP_TYPE and SKB_DROP_REASON_ICMP_BROADCAST
>   and introduce the SKB_DROP_REASON_RFC_1122
> ---
>  include/linux/skbuff.h     |  5 +++
>  include/net/ping.h         |  2 +-
>  include/trace/events/skb.h |  2 +
>  net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
>  net/ipv4/ping.c            | 14 ++++---
>  net/ipv6/icmp.c            | 24 +++++++-----
>  6 files changed, 75 insertions(+), 47 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

