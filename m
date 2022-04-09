Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2144FA21F
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 05:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239491AbiDIDwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 23:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiDIDwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 23:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04D71DA5E;
        Fri,  8 Apr 2022 20:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE77622C4;
        Sat,  9 Apr 2022 03:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63957C385A8;
        Sat,  9 Apr 2022 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649476196;
        bh=Qwq9S4OmRjUWa0BGRlb24xrLBmmP4CFvVpb7WkE+qyE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Wm6J5gAZJijPEttNW0lkFvt+hNB3qIZOWodrnYEIRTMJKiejqb11P4x+gztK9cERk
         kglOSP0OeXVhPep8B0XZxa2Q+7I8+3jurIOwPoBZUflCwYeA4MEFSn3oCda/i9GWfe
         ZtBXZ/cIWnPXt8j4Z8Rp8gvkREAsIpq3N4wsj6CvCw+faWBjcACI5Sa0SWPXozPTWX
         lh2f++bfnNz6BOE6l6aOdKKVmQNIJ2UsgC/dECJZYIPA7CPJn4fOJdydVLbud+SAD6
         hLiPyWZmUZOoDulmLS2ErCnoYYEMF9SPj0+cWFiMJJfwL016aIbUe33CZC6alDBtn5
         SPQ6pWsmb+H4Q==
Message-ID: <94414a48-f8d3-aa20-0d82-930043a3d4cd@kernel.org>
Date:   Fri, 8 Apr 2022 21:49:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND net-next v5 1/4] net: sock: introduce
 sock_queue_rcv_skb_reason()
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
 <20220407062052.15907-2-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220407062052.15907-2-imagedong@tencent.com>
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
> In order to report the reasons of skb drops in 'sock_queue_rcv_skb()',
> introduce the function 'sock_queue_rcv_skb_reason()'.
> 
> As the return value of 'sock_queue_rcv_skb()' is used as the error code,
> we can't make it as drop reason and have to pass extra output argument.
> 'sock_queue_rcv_skb()' is used in many places, so we can't change it
> directly.
> 
> Introduce the new function 'sock_queue_rcv_skb_reason()' and make
> 'sock_queue_rcv_skb()' an inline call to it.
> 
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/net/sock.h |  9 ++++++++-
>  net/core/sock.c    | 30 ++++++++++++++++++++++++------
>  2 files changed, 32 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


