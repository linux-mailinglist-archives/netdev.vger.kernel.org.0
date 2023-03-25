Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F606C8B23
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 06:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbjCYFmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 01:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCYFmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 01:42:54 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC481A48C;
        Fri, 24 Mar 2023 22:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=elBC7x8BCDuYhJTGwQV3bWcb2ZYFxDKqqBJRBK7oPXA=; b=MfYdNUgeY+5US8ue8eoYcRVIyp
        vlkWGh2XrS2isG+R+p58i3KZxlnLWqJjzhedN9Jf7elWGTXCi6YBUYXreMyqPgI+DY5Z1mfZbupQM
        0R8dKbj7amqnvFhHKCV3RLxq7oqHwLKThyDEZnC0Xe9JiSsvVmtMq3xxx41IxE15K1ak=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pfwfr-006bjW-Us; Sat, 25 Mar 2023 06:42:44 +0100
Message-ID: <2ef8ab92-3670-61a1-384d-b827865447ca@nbd.name>
Date:   Sat, 25 Mar 2023 06:42:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230324171314.73537-1-nbd@nbd.name>
 <20230324102038.7d91355c@kernel.org>
 <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
 <20230324104733.571466bc@kernel.org>
 <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
 <20230324201951.75eabe1f@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230324201951.75eabe1f@kernel.org>
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

On 25.03.23 04:19, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 18:57:03 +0100 Felix Fietkau wrote:
>> >> It can basically be used to make RPS a bit more dynamic and 
>> >> configurable, because you can assign multiple backlog threads to a set 
>> >> of CPUs and selectively steer packets from specific devices / rx queues   
>> > 
>> > Can you give an example?
>> > 
>> > With the 4 CPU example, in case 2 queues are very busy - you're trying
>> > to make sure that the RPS does not end up landing on the same CPU as
>> > the other busy queue?  
>> 
>> In this part I'm thinking about bigger systems where you want to have a
>> group of CPUs dedicated to dealing with network traffic without
>> assigning a fixed function (e.g. NAPI processing or RPS target) to each
>> one, allowing for more dynamic processing.
> 
> I tried the threaded NAPI on larger systems and helped others try,
> and so far it's not been beneficial :( Even the load balancing
> improvements are not significant enough to use it, and there
> is a large risk of scheduler making the wrong decision.
> 
> Hence my questioning - I'm trying to understand what you're doing
> differently.
I didn't actually run any tests on bigger systems myself, so I don't 
know how to tune it for those.

>> >> to them and allow the scheduler to take care of the rest.  
>> > 
>> > You trust the scheduler much more than I do, I think :)  
>> 
>> In my tests it brings down latency (both avg and p99) considerably in
>> some cases. I posted some numbers here:
>> https://lore.kernel.org/netdev/e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name/
> 
> Could you provide the full configuration for this test?
> In non-threaded mode the RPS is enabled to spread over remaining
> 3 cores?
In this test I'm using threaded NAPI and backlog_threaded without any 
fixed core assignment.

- Felix
