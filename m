Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C7A3E5A04
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240586AbhHJMf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:35:57 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:47416 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S236886AbhHJMfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:35:55 -0400
X-UUID: 6f4aa03e1f494d4284d2cd45b99e0a48-20210810
X-UUID: 6f4aa03e1f494d4284d2cd45b99e0a48-20210810
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1365449332; Tue, 10 Aug 2021 20:35:30 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 10 Aug 2021 20:35:28 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Aug 2021 20:35:27 +0800
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
Date:   Tue, 10 Aug 2021 20:33:27 +0800
Message-ID: <20210810123327.15998-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <c0a6f817-0225-c863-722c-19c798daaa4b@gmail.com>
References: <c0a6f817-0225-c863-722c-19c798daaa4b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-08-09 at 16:43 -0600, David Ahern wrote:
> On 8/9/21 8:01 AM, Rocco Yue wrote:

> +
>>  #ifdef CONFIG_SYSCTL
>>  
>>  static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
>> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
>> index c467c6419893..a04164cbd77f 100644
>> --- a/net/ipv6/ndisc.c
>> +++ b/net/ipv6/ndisc.c
>> @@ -1496,6 +1496,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>>  		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
>>  		mtu = ntohl(n);
>>  
>> +		if (in6_dev->ra_mtu != mtu) {
>> +			in6_dev->ra_mtu = mtu;
>> +			inet6_iframtu_notify(in6_dev);
>> +			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->ra_mtu);
>> +		}
>> +
>>  		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
>>  			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
>>  		} else if (in6_dev->cnf.mtu6 != mtu) {
> 
> Since this MTU is getting reported via af_info infrastructure,
> rtmsg_ifinfo should be sufficient.
> 
> From there use 'ip monitor' to make sure you are not generating multiple
> notifications; you may only need this on the error path.

Hi David,

To avoid generating multiple notifications, I added a separate ramtu notify
function in this patch, and I added RTNLGRP_IPV6_IFINFO nl_mgrp to the ipmonitor.c
to verify this patch was as expected.

I look at the rtmsg_ifinfo code, it should be appropriate and I will use it and
verify it.

But there's one thing, I'm sorry I didn't fully understand the meaning of this
sentence "you may only need this on the error path". Honestly, I'm not sure what
the error patch refers to, do you mean "if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu)" ?

Thanks
Rocco
