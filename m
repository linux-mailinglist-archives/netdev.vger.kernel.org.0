Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691B06D02AB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 13:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjC3LLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 07:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjC3LLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 07:11:43 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574BDB8;
        Thu, 30 Mar 2023 04:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pQa4FjwEIC+MA7FNmv9xFvah27iKAgSUzcE4V5/VRP0=; b=pOmIKHOuEA6ktJzJBgODzsgr/J
        tsEZyOoCOOjMYjLtsK4y+2MFEnr0BdljXWtMsbPjTQXcY2BH1qyFUGoJdn1uLm5VlChc887Iprmtz
        s0/Gs7irP/5cGzI1ViOWccPaXB8gbop0k0/sB1DHudPLFLgmWH/8Bjgqeypiv00ZXCAo=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phqBp-008VVi-12; Thu, 30 Mar 2023 13:11:33 +0200
Message-ID: <9281af68-d0d5-fbc0-6fa2-50f94bfcbed4@nbd.name>
Date:   Thu, 30 Mar 2023 13:11:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230328195925.94495-1-nbd@nbd.name>
 <20230328161642.3d2f101c@kernel.org>
 <e9e362e3a571bc32afb344cf35b54395e741de90.camel@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v2] net/core: add optional threading for backlog
 processing
In-Reply-To: <e9e362e3a571bc32afb344cf35b54395e741de90.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.23 13:01, Paolo Abeni wrote:
> On Tue, 2023-03-28 at 16:16 -0700, Jakub Kicinski wrote:
>> On Tue, 28 Mar 2023 21:59:25 +0200 Felix Fietkau wrote:
>> > When dealing with few flows or an imbalance on CPU utilization, static RPS
>> > CPU assignment can be too inflexible. Add support for enabling threaded NAPI
>> > for backlog processing in order to allow the scheduler to better balance
>> > processing. This helps better spread the load across idle CPUs.
>> 
>> Can you share some numbers vs a system where RPS only spreads to 
>> the cores which are not running NAPI?
>> 
>> IMHO you're putting a lot of faith in the scheduler and you need 
>> to show that it actually does what you say it will do.
I will run some more tests as soon as I have time for it.

> I have the same feeling. From your description I think some gain is
> possible if there are no other processes running except
> ksoftirq/rps/threaded napi.
> 
> I guess that the above is expect average state for a small s/w router,
> but if/when routing daemon/igmp proxy/local web server kicks-in you
> should notice a measurable higher latency (compared to plain RPS in the
> same scenario)???
Depends on the process priority, I guess.

The main thing I'm trying to fix is the fact that RPS as implemented 
right now is too static for devices routing traffic at CPU capacity limit.
Even if you manage to tune properly for simple ethernet NAT, then adding 
WLAN to the mix can easily throw a wrench into the picture as well, 
because its hard to cover different shifting usage patterns with a 
simple static assignment.

- Felix

