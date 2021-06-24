Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B9D3B25B6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFXDvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:51:23 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:39818 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229850AbhFXDvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:51:22 -0400
X-UUID: 0e541a2a7cb5412db0d434357bec808b-20210624
X-UUID: 0e541a2a7cb5412db0d434357bec808b-20210624
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 358019924; Thu, 24 Jun 2021 11:48:58 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Jun 2021 11:48:56 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Jun 2021 11:48:54 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Date:   Thu, 24 Jun 2021 11:33:53 +0800
Message-ID: <20210624033353.25636-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNNtN3cdDL71SiNt@kroah.com>
References: <YNNtN3cdDL71SiNt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-23 at 19:19 +0200, Greg KH wrote:
On Wed, Jun 23, 2021 at 07:34:49PM +0800, Rocco Yue wrote:
>> This patch add the definition of ARPHRD_PUREIP which can for
>> example be used by mobile ccmni device as device type.
>> ARPHRD_PUREIP means that this device doesn't need kernel to
>> generate ipv6 link-local address in any addr_gen_mode.
>> 
>> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
>> ---
>>  include/uapi/linux/if_arp.h | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/include/uapi/linux/if_arp.h b/include/uapi/linux/if_arp.h
>> index c3cc5a9e5eaf..4463c9e9e8b4 100644
>> --- a/include/uapi/linux/if_arp.h
>> +++ b/include/uapi/linux/if_arp.h
>> @@ -61,6 +61,7 @@
>>  #define ARPHRD_DDCMP    517		/* Digital's DDCMP protocol     */
>>  #define ARPHRD_RAWHDLC	518		/* Raw HDLC			*/
>>  #define ARPHRD_RAWIP    519		/* Raw IP                       */
>> +#define ARPHRD_PUREIP	520		/* Pure IP			*/
> 
> In looking at the patches, what differs "PUREIP" from "RAWIP"?  It seems

Thanks for your review.

The difference between RAWIP and PUREIP is that they generate IPv6
link-local address and IPv6 global address in different ways.

RAWIP:
~~~~~~
In the ipv6_generate_eui64() function, using RAWIP will always return 0,
which will cause the kernel to automatically generate an IPv6 link-local
address in EUI64 format and an IPv6 global address in EUI64 format.

PUREIP:
~~~~~~~
After this patch set, when using PUREIP, kernel doesn't generate IPv6
link-local address regardless of which IN6_ADDR_GEN_MODE is used.

@@  static void addrconf_dev_config(struct net_device *dev)
+       if (dev->type == ARPHRD_PUREIP)
+               return;

And after recving RA message, kernel iterates over the link-local address
that exists for the interface and uses the low 64bits of the link-local
address to generate the IPv6 global address.
The general process is as follows:
ndisc_router_discovery() -> addrconf_prefix_rcv() -> ipv6_generate_eui64() -> ipv6_inherit_eui64()

> to be the same to me.  If they are different, where is that documented?
> 
> thanks,
> 
> greg k-h

I tried to find corresponding documents about other device types, but I
am sorry I didn't find it. If it is needed, I am willing to provide.

Thanks,
Rocco

