Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B0B219572
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGIA6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:58:11 -0400
Received: from out0-141.mail.aliyun.com ([140.205.0.141]:34731 "EHLO
        out0-141.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGIA6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 20:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594256289; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=Ddzysup6Lbxn4AghrKT764Y0x81HYoyhQVLgbVdXWzQ=;
        b=alwUh05QvZPDxbKGwhvmdmBCz8JZ7Jw6sUbANzj+Vf/Pkd2eQxlFsecXR4gkPgZgztE0sPVz95IyjGr778/O2cjkE9a7xHiBV2QtQne1MfkU3ws5ysMV8YOLqJ2uteSv15FLEgHLF+Mn/WHwL46pRRDwGLMqCeXeng88YxOk6cw=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03307;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-Z-bTO_1594256287;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-Z-bTO_1594256287)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 08:58:08 +0800
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
 <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
 <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <387fe086-9596-c71e-d1d9-998749ae093c@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 08:58:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 5:08 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 4:59 PM, YU, Xiangning wrote:
> 
>>
>> Yes, we are touching a cache line here to make sure aggregation tasklet is scheduled immediately. In most cases it is a call to test_and_set_bit(). 
> 
> 
> test_and_set_bit() is dirtying the cache line even if the bit is already set.
> 

Yes. I do hope we can avoid this.

>>
>> We might be able to do some inline processing without tasklet here, still we need to make sure the aggregation won't run simultaneously on multiple CPUs. 
> 
> I am actually surprised you can reach 8 Mpps with so many cache line bouncing around.
> 
> If you replace the ltb qdisc with standard mq+pfifo_fast, what kind of throughput do you get ?
> 

Just tried it using pktgen, we are far from baseline. I can get 13Mpps with 10 threads in my test setup.

Thanks,
- Xiangning
