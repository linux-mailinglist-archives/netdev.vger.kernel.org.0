Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682F56F0D9A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 23:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344079AbjD0VJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 17:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjD0VJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 17:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9992D7C
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 14:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09FE960D56
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6125C433D2;
        Thu, 27 Apr 2023 21:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682629741;
        bh=1QvjlFfVtL2z4WPFwTrUuUvaBYlzYhUXrBKD8dfg96o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ge9dnI77Nf4angeeHSCsMLBTnQQA2Njtlm7gkS7+DiRqisNH3381S/B1+lsgXu7kp
         N6GiDN/Os2xh03GObrnyLpc+V4NlxR60EkVKktnHtFoAtPWxxRrMXcmpV4TO4e7YUQ
         plNuxugsi9Hkqwxhn3Q61kYx/VZnaPjDfEXy3hiGWOV5ijETEks67uZQ3Ol6kNEe1w
         WTl8XnnxCMghpyNU1im7SXrzqqppuTP1DYbzQzFi18y5IGRcZKuXZGtlobSKVfSQqi
         hgMDvQrEYvM2LjpAewjBx51T6iqTkHyDuVWBt8IouxVZC+BZRbIGYFc8Di/PZJlxlm
         HqqoPY/t2B2eA==
Message-ID: <0fa1d0a7-172e-12ca-99c5-d4cf25f2bfef@kernel.org>
Date:   Thu, 27 Apr 2023 15:08:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net] tcp: fix skb_copy_ubufs() vs BIG TCP
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Coco Li <lixiaoyan@google.com>
References: <20230427192404.315287-1-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230427192404.315287-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/23 1:24 PM, Eric Dumazet wrote:
> David Ahern reported crashes in skb_copy_ubufs() caused by TCP tx zerocopy
> using hugepages, and skb length bigger than ~68 KB.
> 
> skb_copy_ubufs() assumed it could copy all payload using up to
> MAX_SKB_FRAGS order-0 pages.
> 
> This assumption broke when BIG TCP was able to put up to 512 KB per skb.

Just an FYI - the problem was triggered at 128kB.

> 
> We did not hit this bug at Google because we use CONFIG_MAX_SKB_FRAGS=45
> and limit gso_max_size to 180000.
> 
> A solution is to use higher order pages if needed.
> 
> Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
> Reported-by: David Ahern <dsahern@kernel.org>
> Link: https://lore.kernel.org/netdev/c70000f6-baa4-4a05-46d0-4b3e0dc1ccc8@gmail.com/T/
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Coco Li <lixiaoyan@google.com>
> ---
>  net/core/skbuff.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
Tested-by: David Ahern <dsahern@kernel.org>

Thanks, Eric. With ConnectX-6's connected back-to-back and S/W only
settings (max GRO, GSO size and 9000 MTU) able to hit ~160G with both
IPv4 and IPv6. I added nr_frags to the net_dev_xmit to verify various
permutations; no issues with the patch.
