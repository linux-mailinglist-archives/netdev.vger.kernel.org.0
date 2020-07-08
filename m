Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3312191F1
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGHVHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:07:08 -0400
Received: from out0-147.mail.aliyun.com ([140.205.0.147]:37000 "EHLO
        out0-147.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgGHVHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594242424; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=QK77R55sKm/agml+oo3dfwt2PUPJG143UCbM9AGjfTw=;
        b=lb6iSvshW8px3NU2uDBLqWxHDL/is1tEnUZe6oFOIJMzs/km4f3n3JnyCfY0Ij38dkc85toZw8Zbi6o+Q4cIFgVRSgOI732RJoUAu1cboz8alo/HWl0A2DSw62eBAn7OQf4SWPSTy/NvCALOiDObzoik8o7xaPNxriaDn7KFoEU=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03300;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-NMrwH_1594242423;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-NMrwH_1594242423)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 05:07:04 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
 <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com>
 <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 05:07:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 1:24 PM, Cong Wang wrote:
> On Tue, Jul 7, 2020 at 2:24 PM YU, Xiangning
> <xiangning.yu@alibaba-inc.com> wrote:
>>
>> The key is to avoid classifying packets from a same flow into different classes. So we use socket priority to classify packets. It's always going to be correctly classified.
>>
>> Not sure what do you mean by default configuration. But we create a shadow class when the qdisc is created. Before any other classes are created, all packets from any flow will be classified to this same shadow class, there won't be any incorrect classified packets either.
> 
> By "default configuration" I mean no additional configuration on top
> of qdisc creation. If you have to rely on additional TC filters to
> do the classification, it could be problematic. Same for setting
> skb priority, right?
> 

In this patch we don't rely on other TC filters. In our use case, socket priority is set on a per-flow basis, not per-skb basis.

> Also, you use a default class, this means all unclassified packets
> share the same class, and a flow falls into this class could be still
> out-of-order, right?
> 

A flow will fall and only fall to this class. If we can keep the order within a flow, I'm not sure why we still have this issue?
 
Thanks,
- Xiangning

> Thanks.
> 
