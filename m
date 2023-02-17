Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD15669ACA2
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBQNkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjBQNkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:40:49 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A6966052;
        Fri, 17 Feb 2023 05:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YglKEztuX5P6i7hn5a3YsSJiYSxruITl06+cJFndveM=; b=VTlE+B3dPrr2Vmvi3i3v7pYR/6
        H2dyDXUyXarNyTSfe9cjJQKS97/lKxZ6WINdw5R8at8nfph/wDDqSuOgzwIuda7a5QpiJvqyaiTXQ
        5qBNZsVV/k+zq3alobAepQPV36ULsH9h6Uz7bAa5x2GYQjMQGFHHEcfSr8R7d0eNpfyc=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pT0yc-009CX6-Rd; Fri, 17 Feb 2023 14:40:38 +0100
Message-ID: <e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name>
Date:   Fri, 17 Feb 2023 14:40:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230217100606.1234-1-nbd@nbd.name>
 <CANn89iJXjEWJcFbSMwKOXuupCVr4b-y4Gh+LwOQg+TQwJPQ=eg@mail.gmail.com>
 <acaf1607-412d-3142-1465-8d8439520228@nbd.name>
 <CANn89iLQa-FruxSUQycawQAHY=wCFP_Q3LHEQfusL1pUbNVxyg@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC v2] net/core: add optional threading for rps backlog
 processing
In-Reply-To: <CANn89iLQa-FruxSUQycawQAHY=wCFP_Q3LHEQfusL1pUbNVxyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.23 13:57, Eric Dumazet wrote:
> On Fri, Feb 17, 2023 at 1:35 PM Felix Fietkau <nbd@nbd.name> wrote:
>>
>> On 17.02.23 13:23, Eric Dumazet wrote:
>> > On Fri, Feb 17, 2023 at 11:06 AM Felix Fietkau <nbd@nbd.name> wrote:
>> >>
>> >> When dealing with few flows or an imbalance on CPU utilization, static RPS
>> >> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
>> >> for RPS backlog processing in order to allow the scheduler to better balance
>> >> processing. This helps better spread the load across idle CPUs.
>> >>
>> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> >> ---
>> >>
>> >> RFC v2:
>> >>  - fix rebase error in rps locking
>> >
>> > Why only deal with RPS ?
>> >
>> > It seems you propose the sofnet_data backlog be processed by a thread,
>> > instead than from softirq ?
>> Right. I originally wanted to mainly improve RPS, but my patch does
>> cover backlog in general. I will update the description in the next
>> version. Does the approach in general make sense to you?
>>
> 
> I do not know, this seems to lack some (perf) numbers, and
> descriptions of added max latencies and stuff like that :)
I just ran some test where I used a MT7621 device (dual-core 800 MHz
MIPS, 4 threads) as a router doing NAT without flow offloading.

Using the flent RRUL test between 2 PCs connected through the router,
I get these results:

rps_threaded=0: (combined CPU idle time around 27%)
                              avg       median       99th %          # data pts
  Ping (ms) ICMP   :        26.08        28.70        54.74 ms              199
  Ping (ms) UDP BE :         1.96        24.12        37.28 ms              200
  Ping (ms) UDP BK :         1.88        15.86        27.30 ms              200
  Ping (ms) UDP EF :         1.98        31.77        54.10 ms              200
  Ping (ms) avg    :         1.94          N/A          N/A ms              200
  TCP download BE  :        69.25        70.20       139.55 Mbits/s         200
  TCP download BK  :        95.15        92.51       163.93 Mbits/s         200
  TCP download CS5 :       133.64       129.10       292.46 Mbits/s         200
  TCP download EF  :       129.86       127.70       254.47 Mbits/s         200
  TCP download avg :       106.97          N/A          N/A Mbits/s         200
  TCP download sum :       427.90          N/A          N/A Mbits/s         200
  TCP totals       :       864.43          N/A          N/A Mbits/s         200
  TCP upload BE    :        97.54        96.67       163.99 Mbits/s         200
  TCP upload BK    :       139.76       143.88       190.37 Mbits/s         200
  TCP upload CS5   :        97.52        94.70       206.60 Mbits/s         200
  TCP upload EF    :       101.71       106.72       147.88 Mbits/s         200
  TCP upload avg   :       109.13          N/A          N/A Mbits/s         200
  TCP upload sum   :       436.53          N/A          N/A Mbits/s         200

rps_threaded=1: (combined CPU idle time around 16%)
                              avg       median       99th %          # data pts
  Ping (ms) ICMP   :        13.70        16.10        27.60 ms              199
  Ping (ms) UDP BE :         2.03        18.35        24.16 ms              200
  Ping (ms) UDP BK :         2.03        18.36        29.13 ms              200
  Ping (ms) UDP EF :         2.36        25.20        41.50 ms              200
  Ping (ms) avg    :         2.14          N/A          N/A ms              200
  TCP download BE  :       118.69       120.94       160.12 Mbits/s         200
  TCP download BK  :       134.67       137.81       177.14 Mbits/s         200
  TCP download CS5 :       126.15       127.81       174.84 Mbits/s         200
  TCP download EF  :        78.36        79.41       143.31 Mbits/s         200
  TCP download avg :       114.47          N/A          N/A Mbits/s         200
  TCP download sum :       457.87          N/A          N/A Mbits/s         200
  TCP totals       :       918.19          N/A          N/A Mbits/s         200
  TCP upload BE    :       112.20       111.55       164.38 Mbits/s         200
  TCP upload BK    :       144.99       139.24       205.12 Mbits/s         200
  TCP upload CS5   :        93.09        95.50       132.39 Mbits/s         200
  TCP upload EF    :       110.04       108.21       207.00 Mbits/s         200
  TCP upload avg   :       115.08          N/A          N/A Mbits/s         200
  TCP upload sum   :       460.32          N/A          N/A Mbits/s         200

As you can see, both throughput and latency improve because load can be
better distributed across CPU cores.

- Felix
