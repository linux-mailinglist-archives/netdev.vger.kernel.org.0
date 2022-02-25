Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E3D4C3C4D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiBYDQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiBYDQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 22:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD851B65EB;
        Thu, 24 Feb 2022 19:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6641616BD;
        Fri, 25 Feb 2022 03:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0BCC340E9;
        Fri, 25 Feb 2022 03:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645758959;
        bh=YQBwiO0RElQQGuGz2YXzyyRpxa66lfHk5yUyBMIL3V8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bpRoz38oufg+FQjPVI6nkCQnG5bV6eydQQwz1g3st1ZwlPGFWvV7EbmopG/9tNKOs
         fazzsTZoP4QOE5SocxIRlhE74mDxIJBaM4h1FcgxqRuwTKu2aPehZixzZED09Ws17D
         0kPL0cvT7FX/Wd7Ex4+Pt/Zuxg3tyNKTW1wV8jafu8gC4FF8fg4vH9EKrOxVsrk/UA
         hSmKlEHzoTnBu7NQD921pA6tfSuJacwxFMq2RNZn74Ysx194N8lzEWpGBIq++7Tv4Y
         JZ088bC867VKq4lhY0hAzoZCehdhwyfu2M2YaojIrtefglMiiN5+cELWaKBssdDH94
         s+m2Auh6ktplQ==
Message-ID: <26c10903-53a1-cab4-b213-440f4a5a18f6@kernel.org>
Date:   Thu, 24 Feb 2022 20:15:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v3] net/tcp: Merge TCP-MD5 inbound callbacks
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20220223175740.452397-1-dima@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220223175740.452397-1-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/22 10:57 AM, Dmitry Safonov wrote:
> The functions do essentially the same work to verify TCP-MD5 sign.
> Code can be merged into one family-independent function in order to
> reduce copy'n'paste and generated code.
> Later with TCP-AO option added, this will allow to create one function
> that's responsible for segment verification, that will have all the
> different checks for MD5/AO/non-signed packets, which in turn will help
> to see checks for all corner-cases in one function, rather than spread
> around different families and functions.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
> v2: Rebased on net-next
> v3: Correct rebase on net-next for !CONFIG_TCP_MD5
> 
>  include/net/tcp.h   | 13 ++++++++
>  net/ipv4/tcp.c      | 70 ++++++++++++++++++++++++++++++++++++++++
>  net/ipv4/tcp_ipv4.c | 78 +++------------------------------------------
>  net/ipv6/tcp_ipv6.c | 62 +++--------------------------------
>  4 files changed, 92 insertions(+), 131 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
