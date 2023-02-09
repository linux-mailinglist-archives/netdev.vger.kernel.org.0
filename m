Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7BC690D28
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjBIPj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbjBIPj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:39:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F19CC14
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17E2AB821A3
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 15:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B3CC433D2;
        Thu,  9 Feb 2023 15:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675957162;
        bh=RD6Pi7TzYnwNj8ZxFZD5oBpZ7pmcH+74YYN7viThwRQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BjSmtye24xmT/yF70yCEaWFOQhjknlT7LENDSuBjLHNtpXL/jLbPP/E3ZBN2myyz4
         wRWYpVsPSZCVQmhejmtSjsrL6r2nByq41e1wUdllvKpLE0O7w6NeQCv88En7PbVK9F
         kzqPfxaUcO9fPbDT5bg2qWQOsJynIUvhgJNeHOc0wQei7yAuAXFwdb+RImeF2v7k2M
         nIoEp0DDzrmk0vPlF/EeP4sq11ThphnYArNRY1A+YMocWbbJLPH+p9X8pfvhZT906X
         WQ1vdBFNAGu+wr2v8Cw8/iJfw2WiuIjhJ5PSCp/7kHq+Uczz/NpT3sAUsqIqky3LRo
         c84GpURSBgmnQ==
Message-ID: <5dae2d71-d960-616a-65da-0743c3987073@kernel.org>
Date:   Thu, 9 Feb 2023 08:39:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/3] ipv6: Fix tcp socket connection with DSCP.
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
References: <cover.1675875519.git.gnault@redhat.com>
 <f8b69f5aaa0049c2d9d162b1155beab535cdbf04.1675875519.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <f8b69f5aaa0049c2d9d162b1155beab535cdbf04.1675875519.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 10:14 AM, Guillaume Nault wrote:
> Take into account the IPV6_TCLASS socket option (DSCP) in
> tcp_v6_connect(). Otherwise fib6_rule_match() can't properly
> match the DSCP value, resulting in invalid route lookup.
> 
> For example:
> 
>   ip route add unreachable table main 2001:db8::10/124
> 
>   ip route add table 100 2001:db8::10/124 dev eth0
>   ip -6 rule add dsfield 0x04 table 100
> 
>   echo test | socat - TCP6:[2001:db8::11]:54321,ipv6-tclass=0x04
> 
> Without this patch, socat fails at connect() time ("No route to host")
> because the fib-rule doesn't jump to table 100 and the lookup ends up
> being done in the main table.
> 
> Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv6/tcp_ipv6.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


