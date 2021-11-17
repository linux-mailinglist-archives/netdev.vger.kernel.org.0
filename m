Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E1A4541B9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhKQHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 02:25:15 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48080 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230227AbhKQHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 02:25:15 -0500
X-UUID: 05cee36b6c4e40ee9a66387a00787b33-20211117
X-UUID: 05cee36b6c4e40ee9a66387a00787b33-20211117
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 717158995; Wed, 17 Nov 2021 15:22:12 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Nov 2021 15:22:11 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Nov 2021 15:22:10 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     <lorenzo@google.com>, <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <Rocco.Yue@gmail.com>,
        <chao.song@mediatek.com>, <yanjie.jiang@mediatek.com>,
        <kuohong.wang@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        <maze@google.com>, <markzzzsmith@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random or privacy mode
Date:   Wed, 17 Nov 2021 15:17:32 +0800
Message-ID: <20211117071732.7455-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <CAKD1Yr02W-WuLx8ouvP+wTtkxeyTBW_dp1deo9sim7wfLA2LXQ@mail.gmail.com>
References: <CAKD1Yr02W-WuLx8ouvP+wTtkxeyTBW_dp1deo9sim7wfLA2LXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-17 at 13:09 +0800, Lorenzo Colitti wrote:
> On Tue, Nov 16, 2021 at 3:15 PM Rocco Yue <rocco.yue@mediatek.com>
> wrote:
>> 
>> In the 3GPP TS 29.061, here is a description as follows:
>> "In order to avoid any conflict between the link-local address
>> of the MS and that of the GGSN, the Interface-Identifier used by
>> the MS to build its link-local address shall be assigned by the
>> GGSN.
>> [...]
>> 1) IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA, this mode is suitable
>> for cellular networks that support RFC7217. In this mode, the
>> kernel doesn't generate a link-local address for the cellular
>> NIC, and generates an ipv6 stable privacy global address after
>> receiving the RA message.
> 
> 
> It sounds like this would violate RFC 4291 section 2.1 which says
> "All
> interfaces are required to have at least one Link-Local unicast
> address. It is also not what 3GPP requires. 3GPP *does* require a
> link-local address. It just requires that that the bottom 64 bits of
> that link-local address be assigned by the network, not randomly.
>

Hi Lorenzo,

Thanks for your reply. :-)

Disabling the kernel's automatic link-local address generation
doesn't mean that it violates RFC 4291, because an appropriate
link-local addr can be added to the cellulal NIC through ioctl.

In fact, the current kernel has similar precedents. For example,
when device type is ARPHRD_NONE, and its addr_gen_mode is NONE,
the kernel will never generate a link-local addr for such interface.

> Given that the kernel already supports tokenized interface addresses,
> a better option here would be to add new addrgen modes where the
> link-local address is formed from the interface token (idev->token),
> and the other addresses are formed randomly or via RFC7217. These
> modes could be called IN6_ADDR_GEN_MODE_RANDOM_LL_TOKEN and
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_LL_TOKEN. When setting up the
> interface, userspace could set disable_ipv6 to 1, then set the
> interface token and the address generation mode via RTM_SETLINK, then
> set disable_ipv6 to 0 to start autoconf. The kernel would then form
> the link-local address via the token (which comes from the network),
> and then set the global addresses either randomly or via RFC 7217.

The method you mentioned can also solve the current problem, but it
seems to introduce more logic: 
  (1) set the cellular interface addr_gen_mode to RANDOM_LL_TOKEN or PRIVACY_LL_TOKEN;
  (2) set the cellular interface up;
  (3) disable ipv6 first;
  (4) set token addr through netlink;
  (5) autoconf through the kernel;
  (6) kernel trigger send RS message;

For the current patch, it is simpler, the configure process as follows:
  (1) set the cellular NIC addr_gen_mode to RANDOM_NO_LLA or PRIVACY_NO_LLA;
  (2) set the cellular interface up;
  (3) configure the link-local addr for the NIC by ioctl;
  (4) kernel trigger send RS message;

I wonder to hear what you and David think.

Thanks,

Rocco

