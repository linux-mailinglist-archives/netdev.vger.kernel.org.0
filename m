Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE7339B01D
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFDCBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 22:01:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3052 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFDCA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 22:00:59 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fx5RR0yqSzWrCt;
        Fri,  4 Jun 2021 09:54:27 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:59:12 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 09:59:12 +0800
Subject: Re: [PATCH RESEND net-next v3 00/18] devlink: rate objects API
To:     Jakub Kicinski <kuba@kernel.org>, <dlinkin@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Simon Horman <simon.horman@netronome.com>,
        <louis.peens@netronome.com>, <baowen.zheng@corigine.com>,
        <idosch@idosch.org>, <mleitner@redhat.com>, <vlad@buslov.dev>,
        Jamal Hadi Salim <jhs@mojatatu.com>, <jianbol@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
 <20210602095824.1d3ce0c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e1101c47-fa4e-0143-9c9f-77a2351fb027@huawei.com>
Date:   Fri, 4 Jun 2021 09:59:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210602095824.1d3ce0c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/3 0:58, Jakub Kicinski wrote:
> On Wed, 2 Jun 2021 15:17:13 +0300 dlinkin@nvidia.com wrote:
>> From: Dmytro Linkin <dlinkin@nvidia.com>
>>
>> Resending without RFC.
>>
>> Currently kernel provides a way to change tx rate of single VF in
>> switchdev mode via tc-police action. When lots of VFs are configured
>> management of theirs rates becomes non-trivial task and some grouping
>> mechanism is required. Implementing such grouping in tc-police will bring
>> flow related limitations and unwanted complications, like:
>> - tc-police is a policer and there is a user request for a traffic
>>   shaper, so shared tc-police action is not suitable;
>> - flows requires net device to be placed on, means "groups" wouldn't
>>   have net device instance itself. Taking into the account previous
>>   point was reviewed a sollution, when representor have a policer and
>>   the driver use a shaper if qdisc contains group of VFs - such approach
>>   ugly, compilated and misleading;
>> - TC is ingress only, while configuring "other" side of the wire looks
>>   more like a "real" picture where shaping is outside of the steering
>>   world, similar to "ip link" command;
>>
>> According to that devlink is the most appropriate place.
> 
> I don't think you researched TC well enough. But whatever, I'm tired 
> of being the only one who pushes back given I neither work on or use
> any of these features.

tc action offload feature used in [1] seems to solve the
police action lifecycle problem?

And it seem to allow different flow to use the same action,
I am not sure if different function can use the same action,
it seems jianbo has mentioned about the same usecase?

1. https://lore.kernel.org/netdev/CALnP8ZaZQAbvm1girLUSLcFZTKV5MvBMEtN67OiA55OAvsO_1Q@mail.gmail.com/T/

