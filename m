Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED24B4FA234
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 06:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbiDIEHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 00:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiDIEHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 00:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEEEC7490;
        Fri,  8 Apr 2022 21:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1F2060A76;
        Sat,  9 Apr 2022 04:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28454C385A0;
        Sat,  9 Apr 2022 04:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649477112;
        bh=eVkPmkxi6qzXtHTxQBIvaskpCWSNt+R6+EwI7nJJyVI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=pm6I2XBAwkPieVX1dzlpzm8VBrqa+dEUDoITcCOz1kP0BYiCWFw58IfCL/kIv8W2+
         krk1WzTacP+DXEH1BrqJeclDoQYUw1ZVa8iJ2O/DqW/KgxUWq+zo17DIg0RDiD/4qd
         qoOudUUz0lBxRqqWueDOZIRnSsSeQywqhiVwXWgpcY/6WVUcx0yFrUQ9kd1uxW8qEA
         3dC2l7lwcIyeyY8HbEPJ70xh9hXCvYbtKhjTXB2Luotb2NgcW4EIB3wPTlpNBY/aZM
         jq9Os+utblgvcFM4ELt7Zg5X07ggDM+YCIupzbwX9KDUd8WIIDvyNf/u/+fjkwabIV
         aiiZVkLBt+IFQ==
Message-ID: <8f5cee25-07c2-3338-b6e7-c6ae10187e9c@kernel.org>
Date:   Fri, 8 Apr 2022 22:05:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND net-next v5 3/4] net: icmp: introduce
 __ping_queue_rcv_skb() to report drop reasons
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
 <20220407062052.15907-4-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220407062052.15907-4-imagedong@tencent.com>
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
> In order to avoid to change the return value of ping_queue_rcv_skb(),
> introduce the function __ping_queue_rcv_skb(), which is able to report
> the reasons of skb drop as its return value, as Paolo suggested.
> 
> Meanwhile, make ping_queue_rcv_skb() a simple call to
> __ping_queue_rcv_skb().
> 
> The kfree_skb() and sock_queue_rcv_skb() used in ping_queue_rcv_skb()
> are replaced with kfree_skb_reason() and sock_queue_rcv_skb_reason()
> now.
> 
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v4:
> - fix the return value problem of ping_queue_rcv_skb()
> 
> v3:
> - fix aligenment problem
> 
> v2:
> - introduce __ping_queue_rcv_skb() instead of change the return value
>   of ping_queue_rcv_skb()
> ---
>  net/ipv4/ping.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
