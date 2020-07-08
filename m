Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEEE21929D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgGHViJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:38:09 -0400
Received: from out0-144.mail.aliyun.com ([140.205.0.144]:46284 "EHLO
        out0-144.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHViI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594244287; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=WktR4aJWK9TXa+A4lpH0AnOAyHHxrF0md63NW2LkCIc=;
        b=jqssNE2EVRQ0Qy/Kt3RabpCxxUof5Ri/vGN/HjK6Oa8XIGqSGK3sj3FRsH7LRTaj2aDpu3HTnfgZRh+YCEmlyg+19PTP0dmQJFytjS2vjnCaqrmBjDaD6ODNoQmnQyZlA6aVVt/6lgrthpYoLmp++oumO4TGBXfkByCxj9Hc8zs=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03308;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-OBwhM_1594244285;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-OBwhM_1594244285)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 05:38:06 +0800
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <049a23c1-a404-60c8-9b20-1825b5319239@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <769acdef-72c1-b4ed-4699-9423ce59db67@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 05:38:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <049a23c1-a404-60c8-9b20-1825b5319239@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/8/20 2:14 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 9:38 AM, YU, Xiangning wrote:
>> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
>> use of outbound bandwidth on a shared link. With the help of lockless
>> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
>> designed to scale in the cloud data centers.
>>
> 
> Before reviewing this patch (with many outcomes at first glance),
> we need experimental data, eg how this is expected to work on a
> typical host with 100Gbit NIC (multi queue), 64 cores at least,
> and what is the performance we can get from it (Number of skbs per second,
> on a class limited to 99Gbit)
> 
> Four lines of changelog seems terse to me.
> 

This is what I sent out in my first email. So far I don't see any problem with 2*25G bonding on 64 cores. Let me see if I can find a 100G, please stay tuned.

"""
Here’s some quick results we get with pktgen over a 10Gbps link.

./samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh –i eth0 -t $NUM

We ran it four times and calculated the sum of the results. We did this for
5, 10, 20, and 30 threads with both HTB and LTB. We have seen significant
performance gain. And we believe there are still rooms for further
improvement.

HTB:
5:  1365793 1367419 1367896 1365359
10: 1130063 1131307 1130035 1130385
20: 629792  629517  629219  629234
30: 582358  582537  582707  582716

LTB:
5:  3738416 3745033 3743431 3744847
10: 8327665 8327129 8320331 8322122
20: 6972309 6976670 6975789 6967784
30: 7742397 7742951 7738911 7742812
"""

Thanks,
- Xiangning
