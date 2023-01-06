Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61D3660415
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjAFQQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjAFQQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:16:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4BCDE0;
        Fri,  6 Jan 2023 08:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBA15CE1D41;
        Fri,  6 Jan 2023 16:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6DBC433EF;
        Fri,  6 Jan 2023 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673021767;
        bh=LUfq977S0xwl0fZvy6DFLm2MwNishlM8ceQPsMY0p4w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SNVZkEb30GUfOVmMtkO77BXIP9IhjnFiBsOPZrGxT7ySMiBYjFIzG7GFlsDrtdmwH
         Py8yztjt4tmmy8kOxswSKy5nYwUkSrGFd/X67l7c6n1Il4stXWEb5UATOn1B5WyJL7
         F1bEuDstg5Mx5QELT4++Ziphy/v9CkHtEfMZn8bn7tiGnMaQlnwT5yLr+V+8mdYDAC
         WlI+W8Drc/jjFAQ2jRF4hoOhMw850RM7elFYS86C0QgGdkF2P1F6Y2lpBUp4EbDVbd
         B3LrYhAi/lW+9CPezfnpeKAXO6u4wizN+ozJyCWZkPY6l2SVsXmTWT9HKVN5AJR+mZ
         mfQfq5w/Zec6Q==
Message-ID: <0ea195c3-89cc-1cb5-cdc5-a8bc3927dc99@kernel.org>
Date:   Fri, 6 Jan 2023 09:16:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] net: ipv6: rpl_iptunnel: Replace 0-length arrays with
 flexible arrays
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20230105221533.never.711-kees@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230105221533.never.711-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 3:15 PM, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct ipv6_rpl_sr_hdr's
> "segments" union of 0-length arrays with flexible arrays. Detected with
> GCC 13, using -fstrict-flex-arrays=3:
> 
> In function 'rpl_validate_srh',
>     inlined from 'rpl_build_state' at ../net/ipv6/rpl_iptunnel.c:96:7:
> ../net/ipv6/rpl_iptunnel.c:60:28: warning: array subscript <unknown> is outside array bounds of 'struct in6_addr[0]' [-Warray-bounds=]
>    60 |         if (ipv6_addr_type(&srh->rpl_segaddr[srh->segments_left - 1]) &
>       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from ../include/net/rpl.h:12,
>                  from ../net/ipv6/rpl_iptunnel.c:13:
> ../include/uapi/linux/rpl.h: In function 'rpl_build_state':
> ../include/uapi/linux/rpl.h:40:33: note: while referencing 'addr'
>    40 |                 struct in6_addr addr[0];
>       |                                 ^~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/uapi/linux/rpl.h | 4 ++--
>  net/ipv6/rpl_iptunnel.c  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
