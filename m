Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3563B3C94
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 08:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhFYGVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 02:21:25 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:35066 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231406AbhFYGVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 02:21:24 -0400
X-UUID: 7bbb680ed00b4f3abb56ac188873f7bb-20210625
X-UUID: 7bbb680ed00b4f3abb56ac188873f7bb-20210625
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1601443592; Fri, 25 Jun 2021 14:19:01 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 25 Jun 2021 14:18:59 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 25 Jun 2021 14:18:58 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Dan Williams <dcbw@redhat.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
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
Date:   Fri, 25 Jun 2021 14:04:11 +0800
Message-ID: <20210625060411.23853-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <0548d1daa7e1eee9d8202481668bbe4975c9b33d.camel@redhat.com>
References: <0548d1daa7e1eee9d8202481668bbe4975c9b33d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 11:14 -0500, Dan Williams wrote:
On Thu, 2021-06-24 at 14:13 +0800, Rocco Yue wrote:
>> On Thu, 2021-06-24 at 07:29 +0200, Greg KH wrote:
>> 
>> Before kernel-4.18, RAWIP was the same as PUREIP, neither of them
>> automatically generates an IPv6 link-local address, and the way to
>> generate an IPv6 global address is the same.
> 
> This distinction seems confusing from a kernel standpoint if it only
> changes how v6 IIDs are determined. Do we really need something that's

Hi Dan,

Thanks for your comment,

In the cellular network, v6 IID is important, If the device use the
link-local address formed by the incorrect IID to send RS message to
the network, based on 3GPP, GGSN will not reply solicited RA message.
It will lead to the device can get ipv6 address prefix and ipv6 route.

Maybe the table below is a little bit clearer

three device type: ARPHRD_RAWIP , ARPHRD_PUREIP, ARPHRD_NONE
three mode: IN6_ADDR_GEN_MODE_EUI64 , IN6_ADDR_GEN_MODE_NONE, IN6_ADDR_GEN_MODE_STABLE_PRIVACY

ipv6 link-local address generate behavior in the kernel:
+---------+-------------------+---------------------+----------------+
|         | MODE_EUI64        | MODE_STABLE_PRIVACY | MODE_NONE      |
+---------+-------------------+---------------------+----------------+
| RAWIP   | fe80::(eui64-id)  | fe80::(privacy-id)  | no address gen |
+---------+-------------------+---------------------+----------------+
| PUREIP  | no address gen    | no address gen      | no address gen |
+---------+-------------------+---------------------+----------------+
| NONE    | fe80::(random-id) | fe80::(privacy-id)  | no address gen |
+---------+-------------------+---------------------+----------------+

ipv6 global address generate behavior in the kernel:
+---------+-------------------+---------------------+-------------------+
|         | MODE_EUI64        | MODE_STABLE_PRIVACY | MODE_NONE         |   
+---------+-------------------+---------------------+-------------------+
| RAWIP   | prefix+(eui64-id) | prefix+(privacy-id) | prefix+(eui64-id) |
+---------+-------------------+---------------------+-------------------+
| PUREIP  | prefix+(GGSN-id)  | prefix+(privacy-id) | prefix+(GGSN-id)  |
+---------+-------------------+---------------------+-------------------+
| NONE    | prefix+(random-id)| prefix+(privacy-id) | prefix+(random-id)|
+---------+-------------------+---------------------+-------------------+

> also reflected to userspace (in struct ifinfomsg -> ifi_type) if the
> kernel is handling the behavior that's different? Why should userspace
> care?
> 

In my opinion, userspace program cares about it because the kernel behaves
differently for different device types.
userspace can get the device type of the interface through ioctl, such as
the following code weblink:
https://cs.android.com/android/platform/superproject/+/master:system/netd/server/OffloadUtils.cpp;drc=master;l=41?q=ARPHRD_RAWIP&ss=android%2Fplatform%2Fsuperproject&start=11

> I'm also curious why this isn't an issue for the ipa/rmnet (Qualcomm)
> modem drivers. There's probably a good reason, but would be good to
> know what that is from Alex Elder or Loic or Bjorn...
> 
> Dan

MediaTek and Qualcomm has different hardware or modem design.
For the MediaTek platform, device send the RS message that generated by
the kernel to the GGSN.

Thanks,
Rocco
