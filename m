Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E493F9776
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244819AbhH0Jop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:44:45 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:57434 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S244649AbhH0Jop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:44:45 -0400
X-UUID: 5eea3328230147b086203df54e390770-20210827
X-UUID: 5eea3328230147b086203df54e390770-20210827
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2106127847; Fri, 27 Aug 2021 17:43:51 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkexhb01.mediatek.inc (172.21.101.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 27 Aug 2021 17:43:50 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 27 Aug 2021 17:43:50 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 27 Aug 2021 17:43:49 +0800
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
Subject: Re: [PATCH net-next v5] ipv6: add IFLA_INET6_RA_MTU to expose mtu value
Date:   Fri, 27 Aug 2021 17:43:33 +0800
Message-ID: <20210827094333.4669-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <6a870141-089d-5e2b-48a7-448695e26238@gmail.com>
References: <6a870141-089d-5e2b-48a7-448695e26238@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-27 at 13:28 +0800, David Ahern wrote:
> On 8/25/21 11:46 PM, Rocco Yue wrote:
>> @@ -5651,6 +5654,9 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
>>  	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
>>  		goto nla_put_failure;
>>  
>> +	if (nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
> 
> I should have seen this earlier. The intent here is to only notify
> userspace if the RA contains an MTU in which case this should be
> 
> 	if (idev->ra_mtu &&
> 	    nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
> 

Hi David,

Thanks for your pretty suggestion.

When ra_mtu = 0, notify userspace is really unnecessary. At first
I did this because when userspace get ra_mtu = 0 through getlink,
then the corresponding operation can be performed.

After adding the restriction of "idev->ra_mtu", I think userspace can
judge whether the mtu option is carried in the RA by judging whether it
can be parsed to IFLA_INET6_RA_MTU after getlink, and perform the
corresponding operation.

I will push the next version.

> and in which case idev->ra_mtu should be initialized to 0 explicitly,
> not U32_MIN.

will do.

Thanks
