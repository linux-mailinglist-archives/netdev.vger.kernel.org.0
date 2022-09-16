Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08F55BB12E
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIPQnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPQnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E59915FD0;
        Fri, 16 Sep 2022 09:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B06AE62C22;
        Fri, 16 Sep 2022 16:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0A9C433D7;
        Fri, 16 Sep 2022 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663346583;
        bh=UmsHj7RKIsPQ6Gwcuw/nAlwsZUANyOdOwRkhC5DlIlA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Q+MvSDJNvYsAGXBuFUlrG09/stqFoapplIlPRQgFQVvJgfC6rMy5NLwQB77CQxul4
         qYB640QLfxErr8XyvX5D5Qp3xIUAbqEAYOnsS13/oqpie38U9F/4SLT1HD8AkHH+o9
         It5PVx1zS9qRi6Gr3t0UzhtbAypW1Z4T6uS/aBcrp9ji1iNmnfd120OhHYaI04+pGj
         KeipG5t8Eus87efmYVmlp2qvLEh1GHKF3dnrKSDg0w+7aoEykM3zTVB/CeWwUMkLN3
         HkWLSeOmV25HJtnfqZNSX0d7CVG1syTqh7QfXcNq9BdyajzQGGD47bjRMYeniUNPMV
         s60eUtxyA/ZcA==
Message-ID: <75585c26-b4bc-8004-dc45-cedba6b8b392@kernel.org>
Date:   Fri, 16 Sep 2022 10:43:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [net-next v2 1/3] seg6: add netlink_ext_ack support in parsing
 SRv6 behavior attributes
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
 <20220912171619.16943-2-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220912171619.16943-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 11:16 AM, Andrea Mayer wrote:
> An SRv6 behavior instance can be set up using mandatory and/or optional
> attributes.
> In the setup phase, each supplied attribute is parsed and processed. If
> the parsing operation fails, the creation of the behavior instance stops
> and an error number/code is reported to the user.  In many cases, it is
> challenging for the user to figure out exactly what happened by relying
> only on the error code.
> 
> For this reason, we add the support for netlink_ext_ack in parsing SRv6
> behavior attributes. In this way, when an SRv6 behavior attribute is
> parsed and an error occurs, the kernel can send a message to the
> userspace describing the error through a meaningful text message in
> addition to the classic error code.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 44 +++++++++++++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 16 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


