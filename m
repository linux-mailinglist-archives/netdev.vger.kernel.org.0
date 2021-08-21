Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8BF3F38ED
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 08:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhHUGLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 02:11:34 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:59622 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230319AbhHUGLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 02:11:33 -0400
X-UUID: e185f2d302644c4b845823bcdfa5263a-20210821
X-UUID: e185f2d302644c4b845823bcdfa5263a-20210821
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 720271186; Sat, 21 Aug 2021 14:10:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 21 Aug 2021 14:10:48 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 21 Aug
 2021 14:10:48 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 21 Aug 2021 14:10:47 +0800
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
Subject: Re: [PATCH net-next v4] ipv6: add IFLA_INET6_RA_MTU to expose mtu value in the RA message
Date:   Sat, 21 Aug 2021 14:10:30 +0800
Message-ID: <20210821061030.26632-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <ad32c931-3056-cdef-4b9b-aab654c61cb9@gmail.com>
References: <ad32c931-3056-cdef-4b9b-aab654c61cb9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-17 at 09:05 -0600, David Ahern wrote:
On 8/17/21 1:26 AM, Rocco Yue wrote:
>> @@ -1496,6 +1490,11 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>>  		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
>>  		mtu = ntohl(n);
>>  
>> +		if (in6_dev->ra_mtu != mtu) {
>> +			in6_dev->ra_mtu = mtu;
>> +			send_ifinfo_notify = true;
>> +		}
>> +
>>  		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
>>  			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
>>  		} else if (in6_dev->cnf.mtu6 != mtu) {
> 
> 
> If an RA no longer carries an MTU or if accept_ra_mtu is reset, then
> in6_dev->ra_mtu should be reset to 0 right?
> 
> rest of the change looks good to me.

Hi David,

Thanks for your review.

In this patch, if an RA no longer carries an MTU or if accept_ra_mtu is reset,
in6_dev->ra_mtu will not be reset to 0, its value will remain the previous
accept_ra_mtu=1 and the value of the mtu carried in the RA msg. This behavior
is same with mtu6. This should be reasonable, it would show that the device
had indeed received the ra_mtu before set accept_ra_mtu to 0 or an RA no longer
carries an mtu value. I am willing to listen to your suggestions and make
changes if needed, maybe it needs to add a new separate proc handler for
accept_ra_mtu.

In addition, at your prompt, I find that this patch maybe have a defect for
some types of virtual devices, that is, when the state of the virtual device
updates the value of ra_mtu during the UP period, when its state is set to
DOWN, ra_mtu is not reset to 0, so that its ra_mtu value remains the previous
value after the interface is re-UP. I think I need to fix it.

Thanks
Rocco
