Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFAA6800B0
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbjA2SOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2SOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:14:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1238816AC2;
        Sun, 29 Jan 2023 10:14:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A030260DE8;
        Sun, 29 Jan 2023 18:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E90BC433EF;
        Sun, 29 Jan 2023 18:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675016076;
        bh=qleW8OsJKDz3DwkJzVoZs3IE+9MXCq49n9SqVXc3voI=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=Mq6CNP6ya7VXwvl7yqyrgYcxBe2Wmkg9wptQRojGBSJb5zmuwKOggweH4H4G5Yv57
         e/h3QxtfCEgaFkuBTKG7mVsqcXbsRt4TPs82GgGHu0YggRF0UPcvcIMJ6u9XMfICZQ
         ldAxVCqcsAjf8lO7CmTNZJ6Ow2KK8i28Cd1CBXqqwjKgfJB5GfyoeuaqvJVtp4Zw5l
         TAalrVMxnww0DxFAssdnx7SEVNzYczv+Owd414b/VtlZv3/L8QaI0Zr/9aLOmHETXV
         l5UutsIFWKqMZAQqhvgjJP7Steh6UWnGyp5ITLMJGmL2sR2aNL56kCuQ1jHGYGRzRF
         HvjUpnrKb3kVA==
Message-ID: <a4f4392f-cc15-86e0-9b63-12678b65d58f@kernel.org>
Date:   Sun, 29 Jan 2023 11:14:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Content-Language: en-US
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, pabeni@redhat.com,
        edumazet@google.com, kuba@kernel.org, a@unstable.cc,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230127025941.2813766-1-Thomas.Winter@alliedtelesis.co.nz>
 <20230127025941.2813766-2-Thomas.Winter@alliedtelesis.co.nz>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230127025941.2813766-2-Thomas.Winter@alliedtelesis.co.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of nits.

On 1/26/23 7:59 PM, Thomas Winter wrote:
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f7a84a4acffc..0065b38fc85b 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3355,7 +3355,7 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
>  	}
>  }
>  
> -static void addrconf_dev_config(struct net_device *dev)
> +static void addrconf_eth_config(struct net_device *dev)

why the rename of this function? It does more than ethernet config.


>  {
>  	struct inet6_dev *idev;
>  
> @@ -3447,6 +3447,30 @@ static void addrconf_gre_config(struct net_device *dev)
>  }
>  #endif
>  
> +static void addrconfig_init_auto_addrs(struct net_device *dev)

this one should be 'addrconf_' to be consistent with related function names.


