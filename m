Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC6631912
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 04:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKUDzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 22:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKUDze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 22:55:34 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352C820185;
        Sun, 20 Nov 2022 19:55:33 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VVDmM.g_1669002929;
Received: from 30.221.147.179(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVDmM.g_1669002929)
          by smtp.aliyun-inc.com;
          Mon, 21 Nov 2022 11:55:30 +0800
Message-ID: <ce5fe56b-bf1b-71c0-1e96-cff6fde40ff3@linux.alibaba.com>
Date:   Mon, 21 Nov 2022 11:55:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:106.0)
 Gecko/20100101 Thunderbird/106.0
Subject: Re: [PATCH net-next 0/2] veth: a couple of fixes
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <cover.1668727939.git.pabeni@redhat.com>
 <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
 <1669001595.7554848-1-xuanzhuo@linux.alibaba.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <1669001595.7554848-1-xuanzhuo@linux.alibaba.com>
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



在 2022/11/21 上午11:33, Xuan Zhuo 写道:
> On Fri, 18 Nov 2022 09:41:05 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
>> On Fri, 2022-11-18 at 00:33 +0100, Paolo Abeni wrote:
>>> Recent changes in the veth driver caused a few regressions
>>> this series addresses a couple of them, causing oops.
>>>
>>> Paolo Abeni (2):
>>>    veth: fix uninitialized napi disable
>>>    veth: fix double napi enable
>>>
>>>   drivers/net/veth.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>> @Xuan Zhuo: another option would be reverting 2e0de6366ac1 ("veth:
>> Avoid drop packets when xdp_redirect performs") and its follow-up
>> 5e5dc33d5dac ("bpf: veth driver panics when xdp prog attached before
>> veth_open").
>>
>> That option would be possibly safer, because I feel there are other
>> issues with 2e0de6366ac1, and would offer the opportunity to refactor
>> its logic a bit: the napi enable/disable condition is quite complex and
>> not used consistently mixing and alternating the gro/xdp/peer xdp check
>> with the napi ptr dereference.
>>
>> Ideally it would be better to have an helper alike
>> napi_should_be_enabled(), use it everywhere, and pair the new code with
>> some selftests, extending the existing ones.
>>
>> WDYT?
> I take your point.

I'll rewrite a patch as soon as possible and resubmit it.

Thanks.

>
> Thanks.
>
>
>> Side notes:
>> - Heng Qi address is bouncing
>> - the existing veth self-tests would have caught the bug addressed
>> here, if commit afef88e65554 ("selftests/bpf: Store BPF object files
>> with .bpf.o extension") would not have broken them meanwhile :(
>>
>> /P
>>

