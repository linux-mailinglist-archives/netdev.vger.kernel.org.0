Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEA4CE0DC
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiCDXVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCDXU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:20:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B678CE922
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 15:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF037B82C1D
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 23:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11902C340E9;
        Fri,  4 Mar 2022 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646436008;
        bh=82pqd7mytgSamRZGCxOVHGeukhFL7oaG/WE0yYNjDMw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UjhvKhNYDqlJFafqYlKU1gZO54mZVpnvK0qLsXPOlTnNr6UrHKzZ/30sN0edNlL25
         2b4dqd16IX4eGVlSmVzj0a4k2Pyj9FvVmcEjrKQc0bS4UwRnEWVFpwAI2ozAeYd2tj
         o9Q/dWZKRE2ZpKCOvDCzZjEPNyBCErYZF6NlGGteuL4M96VFDEkVZRVAuC7/1zH67u
         4+zpEiZcEweoUmciWUQwsMXvNqBI5zGatnRxdyVDcD5C6eHpZ5JNljOkThsqypy2IP
         jyrwr5iCl1qFU++ri+u2RJfQ5FL1ePbAeS8LA7zNrwOzHgg/srou/fiJAT/IsLsd0z
         Pm+1lK2K9zS+Q==
Message-ID: <5b6a8e65-7a21-c333-cdb5-253034effc30@kernel.org>
Date:   Fri, 4 Mar 2022 16:20:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: sendmsg bug
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        1031265646 <1031265646@qq.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>
References: <tencent_B01AAA5AC1C24CDEE81286F1006CE27B440A@qq.com>
 <CAHk-=wic8ind8nY5fea+otfkmjBuMwgiXY6idbtrXZcig3yDaA@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAHk-=wic8ind8nY5fea+otfkmjBuMwgiXY6idbtrXZcig3yDaA@mail.gmail.com>
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

On 3/4/22 2:13 PM, Linus Torvalds wrote:
> The bug seems real, although mostly harmless. If ip_make_skb() returns
> NULL, it's true that udp_sendmsg() will return a misleading success
> value since 'err' will be 0 and it will return the length of the
> packet that wasn't actually ever created or sent.
> 
> UDP being a lossy protocol, probably nobody has cared, since
> "successful send" doesn't mean "successful receive" anyway.
> 
> I'm not sure what the right error should be for this case, and whether
> it should be fixed inside ip_make_skb() ("always return a proper
> ERR_PTR") or what.. Or whether it should just be left alone as a
> "packet dropped early" thing.

I think the right answer is to have ip_make_skb (and by extension
__ip_make_skb) always return an skb or an ERR_PTR. That means fixing up
the callers and making sure err is set properly for the various paths.

Way too late in 5.17 for such a patch, but I can take look for 5.18. The
bug has been around since 2011 (903ab86d195c).
