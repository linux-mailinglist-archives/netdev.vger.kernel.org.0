Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FBB6612F4
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 03:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjAHCEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 21:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAHCEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 21:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B544101CE
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 18:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB4460C35
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E66C433D2;
        Sun,  8 Jan 2023 02:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673143476;
        bh=cUnAthVCzEC/l4rhN+KQ9OpUo2DTFdUNJC5OqC6l+aU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cHW7Kfzf2IYYHvgWrMetK8WglpPhooZ8yvkvTgLIl0p2+GglXRg9PipWr5PusDx8P
         6CoCkDeKUTdgtKYnXsdPQ02jG2g+SvZVPJv8f3gnXuHkZzEOM7Drt5Ak7RzDo+AMVR
         st5OFf2qWJqsDA43uR++rGXuG9NRHcd94kMqvPQBI/pIqGgrWqiGC1KPd3m94uIoRi
         VJYunIuhQFFdYufAQfCo671ufFdpl5PDhbs2sr5smVQ3STbQ5qb2hIdGt7fmHM7/lT
         RmB1W6A2v7867gFHW3z9qJb7PnTwjC8uZQf0rS4OHUSAjvfR2YEETPigCZUff5SVyr
         HAivAoB8OZoYQ==
Message-ID: <7ab910df-c864-7f11-0c1a-acb863dd1539@kernel.org>
Date:   Sat, 7 Jan 2023 19:04:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net] ipv6: prevent only DAD and RS sending for
 IFF_NO_ADDRCONF
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        LiLiang <liali@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jianghaoran <jianghaoran@kylinos.cn>,
        Jay Vosburgh <fubar@us.ibm.com>
References: <ab8f8ce5b99b658483214f3a9887c0c32efcca80.1673023907.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <ab8f8ce5b99b658483214f3a9887c0c32efcca80.1673023907.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/23 9:51 AM, Xin Long wrote:
> Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
> slave ports of team, bonding and failover devices and it means no ipv6
> packets can be sent out through these slave ports. However, for team
> device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
> link will be marked failure.
> 
> The orginal issue fixed by IFF_NO_ADDRCONF was caused by DAD and RS
> packets sent by slave ports in commit c2edacf80e15 ("bonding / ipv6: no
> addrconf for slaves separately from master") where it's using IFF_SLAVE
> and later changed to IFF_NO_ADDRCONF in commit 8a321cf7becc ("net: add
> IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf").

That patch is less than a month old, and you are making changes again.

I think you should add some test cases that cover the permutations you
want along with any possible alternative / negative use cases.

