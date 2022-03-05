Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA84CE683
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 20:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiCETHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 14:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiCETHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 14:07:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B14C40
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 11:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CE3E60B33
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 19:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5249CC004E1;
        Sat,  5 Mar 2022 19:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646507212;
        bh=VVzvP0/L/7PHuH1XIc9/tH7nnRKBoNEGJaQdCN5TbNQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NGz+10JAy5Q8LmK6ArebRqGIpmiBXRiTgXsWEzLCcA5gyYx5LB24zxIJ8YXrVOua6
         tKqlHtx5REcEH0ydwpZhff8vTi7k4XGBo1QhllkhuZEZ8dJMfUbJxg6S7VK0DhKF82
         cLpSTHMROeIAJ33Yo19uoZ0D1bIGhiPdNgzIbTM4KWAseI1ZZD4K2DkzO0G51jRrha
         gfp2MgU5kvOZQ+yXOn6eI5ynkhfSUiBEmZA+KK44+m6bIpNT3tB3sNO6thAaqdSa6x
         I/H47N+RHO0QLBm7cr5Al9zC/BVDLskb8bFG1Azx65c2fNfzwTteUB+r9UukAxNtxF
         cmfDt/k8tEHAw==
Message-ID: <0926b40f-f66b-5cca-cd9b-ba9800d21388@kernel.org>
Date:   Sat, 5 Mar 2022 12:06:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com>
 <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
 <CANn89iL2gXRsnC20a+=YJ+Ug=3x_jacmtL+S269_0g+E0wDYSQ@mail.gmail.com>
 <b66106e0-4bd6-e2ae-044d-e48c22546c87@kernel.org>
 <CANn89i+iGb7p2SqLXvzmkR3W3T_BgUWW78-4z0TxrBW8dYTnwA@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89i+iGb7p2SqLXvzmkR3W3T_BgUWW78-4z0TxrBW8dYTnwA@mail.gmail.com>
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

On 3/5/22 11:08 AM, Eric Dumazet wrote:
>>
>> Why? skb->len is not limited to a u16. The only affect is when skb->len
>> is used to fill in the ipv4/ipv6 header.
> 
> Seriously ?
> 
> Have you looked recently at core networking stack, and have you read
> my netdev presentation ?

yes I have.

> 
> Core networking stack will trim your packets skb->len based on what is
> found in the network header,

Core networking stack is s/w under our control; much more complicated
and intricate changes have been made.
