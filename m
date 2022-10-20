Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF8605574
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJTCYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiJTCYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:24:05 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6191D5866
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:24:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VSd1XNd_1666232639;
Received: from 30.221.148.96(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VSd1XNd_1666232639)
          by smtp.aliyun-inc.com;
          Thu, 20 Oct 2022 10:24:00 +0800
Message-ID: <c128d468-0c87-8759-e7de-b482abf8aab6@linux.alibaba.com>
Date:   Thu, 20 Oct 2022 10:23:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:106.0)
 Gecko/20100101 Thunderbird/106.0
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
 <87v8p7r1f2.fsf@toke.dk>
 <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
 <567d3635f6e7969c4e1a0e4bc759556c472d1dff.camel@redhat.com>
 <c1831b89-c896-80c3-7258-01bcf2defcbc@linux.alibaba.com>
 <87o7uymlh5.fsf@toke.dk>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <87o7uymlh5.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/9/29 下午8:08, Toke Høiland-Jørgensen 写道:
> Heng Qi <hengqi@linux.alibaba.com> writes:
>
>>>> As I said above in the real case, the user's concern is not why the performance
>>>> of xdp becomes bad, but why the data packets are not received.
>>> Well, that arguably tells the end-user there is something wrong in
>>> their setup. On the flip side, having a functionally working setup with
>>> horrible performances would likely lead the users (perhaps not yours,
>>> surely others) in very wrong directions (from "XDP is slow" to "the
>>> problem is in the application")...
>>>
>>>> The default number of veth queues is not num_possible_cpus(). When GRO is enabled
>>>> by default, if there is only one veth queue, but multiple CPUs read and write at the
>>>> same time, the efficiency of napi is actually very low due to the existence of
>>>> production locks and races. On the contrary, the default veth_xmit() each cpu has
>>>> its own unique queue, and this way of sending and receiving packets is also efficient.
>>>>
>>> This patch adds a bit of complexity and it looks completely avoidable
>>> with some configuration - you could enable GRO and set the number of
>>> queues to num_possible_cpus().
>>>
>>> I agree with Toke, you should explain the end-users that their
>>> expecations are wrong, and guide them towards a better setup.
>>>
>>> Thanks!
>> Well, one thing I want to know is that in the following scenario,
>>
>> NIC   ->   veth0----veth1
>>    |           |        |
>> (XDP)      (XDP)    (no XDP)
>>
>> xdp_redirect is triggered,
>> and NIC and veth0 are both mounted with the xdp program, then why our default behavior
>> is to drop packets that should be sent to veth1 instead of when veth0 is mounted with xdp
>> program, the napi ring of veth1 is opened by default at the same time? Why not make it like
>> this, but we must configure a simple xdp program on veth1?
> As I said in my initial reply, you don't actually need to load an XDP
> program (anymore), it's enough to enable GRO through ethtool on both
> peers. You can easily do this on setup if you know XDP is going to be
> used in your environment.

This does serve our purpose, but in fact, users of veth pair do not necessarily understand
how it works. In this case, for users who are not familiar with veth pair, they may not
know that they need to enable GRO or load the xdp program for peer veth to ensure that
the redirected packets can be received smoothly. In order to solve this overwhelming problem,
they may go to take the time to look at the source code, or even find someone else to solve it,
but we can avoid these with simple modifications (modifications may not be the rollback,
using the backlog instead of the napi ring, made by this patch), for example, maybe we should
consider a simpler method: when loading xdp in veth, we can automatically enable the napi ring
of peer veth, which seems to have no performance impact and functional impact on the veth pair,
and no longer requires users to do more things for peer veth (after all, they may be unaware
of more requirements for peer veth). Do you think this is feasible?

Thanks.

> -Toke

