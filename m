Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CE3EB250
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 10:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbhHMIKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 04:10:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:44220 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S239668AbhHMIKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 04:10:36 -0400
X-UUID: b8752efb16e1441f8b6b43d798f983b8-20210813
X-UUID: b8752efb16e1441f8b6b43d798f983b8-20210813
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1910488043; Fri, 13 Aug 2021 16:10:07 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Aug
 2021 16:10:06 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 13 Aug 2021 16:10:05 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next v3] ipv6: add IFLA_INET6_RA_MTU to expose mtu value in the RA message
Date:   Fri, 13 Aug 2021 16:07:40 +0800
Message-ID: <20210813080740.31571-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <4624cc10-1fc8-12cd-e9e1-9585f5b496a0@gmail.com>
References: <4624cc10-1fc8-12cd-e9e1-9585f5b496a0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-08-11 at 12:05 -0600, David Ahern wrote:
> On 8/11/21 7:56 AM, David Ahern wrote:
>> On 8/10/21 6:33 AM, Rocco Yue wrote:
>>> On Mon, 2021-08-09 at 16:43 -0600, David Ahern wrote:
>>>>
>>>> Since this MTU is getting reported via af_info infrastructure,
>>>> rtmsg_ifinfo should be sufficient.
>>>>
>>>> From there use 'ip monitor' to make sure you are not generating multiple
>>>> notifications; you may only need this on the error path.
>>>
>>> Hi David,
>>>
>>> To avoid generating multiple notifications, I added a separate ramtu notify
>>> function in this patch, and I added RTNLGRP_IPV6_IFINFO nl_mgrp to the ipmonitor.c
>>> to verify this patch was as expected.
>>>
>>> I look at the rtmsg_ifinfo code, it should be appropriate and I will use it and
>>> verify it.
>>>
>>> But there's one thing, I'm sorry I didn't fully understand the meaning of this
>>> sentence "you may only need this on the error path". Honestly, I'm not sure what
>>> the error patch refers to, do you mean "if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu)" ?
>>>
>> 
>> looks like nothing under:
>>     if (ndopts.nd_opts_mtu && in6_dev->cnf.accept_ra_mtu) {
>> 
>>     }
>> 
>> is going to send a link notification so you can just replace
>> inet6_iframtu_notify with rtmsg_ifinfo in your proposed change.
>> 
> 
> Taking a deeper dive on the code, you do not need to call rtmsg_ifinfo.
> Instead, the existing:
> 
>         /*
>          *      Send a notify if RA changed managed/otherconf flags or
> timer settings
>          */
>         if (send_ifinfo_notify)
>                 inet6_ifinfo_notify(RTM_NEWLINK, in6_dev);
> 
> is called too early. For one the RA can change the MTU and that is done
> after this notify.
> 
> I think if you moved this down to the out:
> 
> out:
>         /*
>          *      Send a notify if RA changed managed/otherconf flags or
> timer settings
>          */
>         if (send_ifinfo_notify)
>                 inet6_ifinfo_notify(RTM_NEWLINK, in6_dev);
> 
> and then set send_ifinfo_notify when the mtu is *changed* by the RA you
> should be good.

Hi David,

Thanks for your suggestion,
this looks like a better choice without adding a separate notification function,
I will modify it and push the next iteration .

Best Regards,
Rocco
