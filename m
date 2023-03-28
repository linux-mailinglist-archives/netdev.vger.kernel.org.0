Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21B66CC723
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjC1PxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbjC1PxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:53:09 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F73EF93;
        Tue, 28 Mar 2023 08:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5yw49PqP0hAxp96MX56AWP776z6YCEYv9dmgDK54FaU=; b=EZGQ4AvOiXz1K4qmbOiBCRJRjg
        a5+U403wi7uwIUd43NJmUDO3CbpbSHHuwRPYO5mfcyYhXn+xJur6OKDsaMJEnS/1Gkt0qF1jO3JjG
        lQGu2kyuzMJTGnajDGuyPyjaIxJEN5erL66MDjOJCszmBb3OrzPZQgi1rYNhJPT0Wsts=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phB8G-007lrD-Gm; Tue, 28 Mar 2023 17:21:08 +0200
Message-ID: <d594019c-95a5-3412-4696-2533afdbda74@nbd.name>
Date:   Tue, 28 Mar 2023 17:21:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230324171314.73537-1-nbd@nbd.name>
 <20230324102038.7d91355c@kernel.org>
 <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
 <20230324104733.571466bc@kernel.org>
 <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
 <751fd5bb13a49583b1593fa209bfabc4917290ae.camel@redhat.com>
 <b001c8ed-214f-94e6-2d4f-0ee13e3d8760@nbd.name>
 <9331f1358cf7c24442d705d840812e9cd490e018.camel@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
In-Reply-To: <9331f1358cf7c24442d705d840812e9cd490e018.camel@redhat.com>
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

On 28.03.23 17:13, Paolo Abeni wrote:
> On Tue, 2023-03-28 at 11:45 +0200, Felix Fietkau wrote:
>> On 28.03.23 11:29, Paolo Abeni wrote:
>> > On Fri, 2023-03-24 at 18:57 +0100, Felix Fietkau wrote:
>> > > On 24.03.23 18:47, Jakub Kicinski wrote:
>> > > > On Fri, 24 Mar 2023 18:35:00 +0100 Felix Fietkau wrote:
>> > > > > I'm primarily testing this on routers with 2 or 4 CPUs and limited 
>> > > > > processing power, handling routing/NAT. RPS is typically needed to 
>> > > > > properly distribute the load across all available CPUs. When there is 
>> > > > > only a small number of flows that are pushing a lot of traffic, a static 
>> > > > > RPS assignment often leaves some CPUs idle, whereas others become a 
>> > > > > bottleneck by being fully loaded. Threaded NAPI reduces this a bit, but 
>> > > > > CPUs can become bottlenecked and fully loaded by a NAPI thread alone.
>> > > > 
>> > > > The NAPI thread becomes a bottleneck with RPS enabled?
>> > > 
>> > > The devices that I work with often only have a single rx queue. That can
>> > > easily become a bottleneck.
>> > > 
>> > > > > Making backlog processing threaded helps split up the processing work 
>> > > > > even more and distribute it onto remaining idle CPUs.
>> > > > 
>> > > > You'd want to have both threaded NAPI and threaded backlog enabled?
>> > > 
>> > > Yes
>> > > 
>> > > > > It can basically be used to make RPS a bit more dynamic and 
>> > > > > configurable, because you can assign multiple backlog threads to a set 
>> > > > > of CPUs and selectively steer packets from specific devices / rx queues 
>> > > > 
>> > > > Can you give an example?
>> > > > 
>> > > > With the 4 CPU example, in case 2 queues are very busy - you're trying
>> > > > to make sure that the RPS does not end up landing on the same CPU as
>> > > > the other busy queue?
>> > > 
>> > > In this part I'm thinking about bigger systems where you want to have a
>> > > group of CPUs dedicated to dealing with network traffic without
>> > > assigning a fixed function (e.g. NAPI processing or RPS target) to each
>> > > one, allowing for more dynamic processing.
>> > > 
>> > > > > to them and allow the scheduler to take care of the rest.
>> > > > 
>> > > > You trust the scheduler much more than I do, I think :)
>> > > 
>> > > In my tests it brings down latency (both avg and p99) considerably in
>> > > some cases. I posted some numbers here:
>> > > https://lore.kernel.org/netdev/e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name/
>> > 
>> > It's still not 110% clear to me why/how this additional thread could
>> > reduce latency. What/which threads are competing for the busy CPU[s]? I
>> > suspect it could be easier/cleaner move away the others (non RPS)
>> > threads.
>> In the tests that I'm doing, network processing load from routing/NAT is 
>> enough to occupy all available CPUs.
>> If I dedicate the NAPI thread to one core and use RPS to steer packet 
>> processing to the other cores, the core taking care of NAPI has some 
>> idle cycles that go to waste, while the other cores are busy.
>> If I include the core in the RPS mask, it can take too much away from 
>> the NAPI thread.
> 
> I feel like I'm missing some relevant points.
> 
> If RPS keeps the target CPU fully busy, moving RPS processing in a
> separate thread still will not allow using more CPU time.
RPS doesn't always keep the target CPU fully busy. The combination of 
NAPI thread + RPS threads is enough to keep the system busy. The number 
of flows is often small enough, that some (but not all) RPS instances 
could be keeping their target CPU busy.

With my patch, one CPU could be busy with a NAPI thread + remaining 
cycles allocated to a bit of extra RPS work, while the other CPUs handle 
the rest of the RPS load. In reality it bounces around CPUs a bit more 
instead of sticking to this assigned setup, but it allows cores to be 
more fully utilized by the network processing load, and the resulting 
throughput/latency improves because of that.

> Which NIC driver are you using?
I've been testing on multiple platforms. Mainly mtk_eth_soc, but also bgmac.

- Felix
