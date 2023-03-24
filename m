Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16786C8419
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjCXR7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjCXR64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:58:56 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E189C1D91F;
        Fri, 24 Mar 2023 10:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RPp+jVq4zG5ARLVqdsVeJzjEB0rJ97uPgpM5r2QXxfg=; b=OAhwsUUJPmpSnm7KbFDZ7CypGo
        CldKXkDPF8KCtrhtoB08gdBqNpIzhabZNQbRJJz7BFNVBdHMjozwH7gdto6rH3WVtfMK+G9xopF2F
        U8F4d6sAeU9JJMn/EkYkk4WQEzVFSP4LpayYkcfeySpciDXRcSpzyIxZ1Oikvs213UJM=;
Received: from p200300daa7147b00f53b1e71cf2162bd.dip0.t-ipconnect.de ([2003:da:a714:7b00:f53b:1e71:cf21:62bd] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pflex-006S1f-HB; Fri, 24 Mar 2023 18:57:03 +0100
Message-ID: <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
Date:   Fri, 24 Mar 2023 18:57:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
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
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
In-Reply-To: <20230324104733.571466bc@kernel.org>
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

On 24.03.23 18:47, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 18:35:00 +0100 Felix Fietkau wrote:
>> I'm primarily testing this on routers with 2 or 4 CPUs and limited 
>> processing power, handling routing/NAT. RPS is typically needed to 
>> properly distribute the load across all available CPUs. When there is 
>> only a small number of flows that are pushing a lot of traffic, a static 
>> RPS assignment often leaves some CPUs idle, whereas others become a 
>> bottleneck by being fully loaded. Threaded NAPI reduces this a bit, but 
>> CPUs can become bottlenecked and fully loaded by a NAPI thread alone.
> 
> The NAPI thread becomes a bottleneck with RPS enabled?

The devices that I work with often only have a single rx queue. That can
easily become a bottleneck.

>> Making backlog processing threaded helps split up the processing work 
>> even more and distribute it onto remaining idle CPUs.
> 
> You'd want to have both threaded NAPI and threaded backlog enabled?

Yes

>> It can basically be used to make RPS a bit more dynamic and 
>> configurable, because you can assign multiple backlog threads to a set 
>> of CPUs and selectively steer packets from specific devices / rx queues 
> 
> Can you give an example?
> 
> With the 4 CPU example, in case 2 queues are very busy - you're trying
> to make sure that the RPS does not end up landing on the same CPU as
> the other busy queue?

In this part I'm thinking about bigger systems where you want to have a
group of CPUs dedicated to dealing with network traffic without
assigning a fixed function (e.g. NAPI processing or RPS target) to each
one, allowing for more dynamic processing.

>> to them and allow the scheduler to take care of the rest.
> 
> You trust the scheduler much more than I do, I think :)

In my tests it brings down latency (both avg and p99) considerably in
some cases. I posted some numbers here:
https://lore.kernel.org/netdev/e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name/

- Felix
