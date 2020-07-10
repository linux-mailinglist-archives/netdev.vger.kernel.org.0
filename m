Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CB321BBBA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGJRDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:03:07 -0400
Received: from out0-130.mail.aliyun.com ([140.205.0.130]:57022 "EHLO
        out0-130.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgGJRDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594400585; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=eudv+Bo3hw4SAoshbOS4xq7pXDbhs4+nkOrtmU6Eu4E=;
        b=U/BZReYYpSzXeIv04F5AVBMd7pb8OB71VRc4aNv7yxR04bDwB11jVW3vbEkTUwwuRTYnM9ZAmuGiQYfxosxleUiOa6Vv/U0EgZiRfIiwqQWJJ3xwYGFETBnuKQI8BnfOKjJ237yZGesil7+dsLu2smnlxkLIKwWOpcoAhgyTThY=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03294;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I.arIMg_1594400583;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I.arIMg_1594400583)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 11 Jul 2020 01:03:04 +0800
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
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com>
 <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
 <a33f9de6-b066-6014-8be2-585203a97d89@alibaba-inc.com>
 <CAM_iQpUwACsXVe9GAkQ1XC1TTU8aT3pqnrkZYT+oVDrP_1pKzw@mail.gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <c81ef671-aefa-0ac8-18e6-bad26102d0c3@alibaba-inc.com>
Date:   Sat, 11 Jul 2020 01:03:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUwACsXVe9GAkQ1XC1TTU8aT3pqnrkZYT+oVDrP_1pKzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 11:09 PM, Cong Wang wrote:
> On Thu, Jul 9, 2020 at 10:49 PM YU, Xiangning
> <xiangning.yu@alibaba-inc.com> wrote:
>>
>> Well, we do ask packets from a flow to be classified to a single class, not multiple ones. It doesn't have to be socket priority, it could be five tuple hash, or even container classid.
> 
> I don't see how it is so in your code, without skb priority your code
> simply falls back to default class:
> 
> +       /* Allow to select a class by setting skb->priority */
> +       if (likely(skb->priority != 0)) {
> +               cl = ltb_find_class(sch, skb->priority);
> +               if (cl)
> +                       return cl;
> +       }
> +       return rcu_dereference_bh(ltb->default_cls);
> 
> Mind to be more specific here?
> 

The application will call setsockopt() to set priority. If no match if found, it will use the default class.

In real deployment we have another classifier. Please feel free to suggest what is best choice for it. 

> BTW, your qdisc does not even support TC filters, does it?
> At least I don't see that tcf_classify() is called.
>

You are correct we don't use generic tc filters. I leave it unsupported in this patch too.
 
> 
>>
>> I think it's ok to have this requirement, even if we use htb, I would suggest the same. Why do you think this is a problem?
> 
> Because HTB does not have a per-cpu queue for each class,
> yours does, cl->aggr_queues[cpu], if your point here is why we
> don't blame HTB.
>

My point is: it's OK to ask a flow to be classified to a single class.

Thanks,
- Xiangning

> Thanks.
> 
