Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156C53C685C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 04:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhGMCHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:07:55 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60346 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229581AbhGMCHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:07:54 -0400
X-UUID: 69e3afa93de54c77b21be6682f21871a-20210713
X-UUID: 69e3afa93de54c77b21be6682f21871a-20210713
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1515791918; Tue, 13 Jul 2021 10:05:00 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 13 Jul 2021 10:04:58 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Jul 2021 10:04:57 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <maze@google.com>,
        <lorenzo@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
Date:   Tue, 13 Jul 2021 09:49:24 +0800
Message-ID: <20210713014924.1831-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <40951584-8f53-4e95-4a6b-14ae1cf7f011@gmail.com>
References: <40951584-8f53-4e95-4a6b-14ae1cf7f011@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> According to your suggestion, I checked the ipv6 code again. In my
>> opinion, adding another addr_gen_mode may not be suitable.
>> 
>> (1)
>> In the user space, the process enable the ipv6 stable privacy mode by
>> setting the "/proc/sys/net/ipv6/conf/<iface>/stable_secret".
>> 
>> In the kernel, the addr_gen_mode of a networking device is switched to
>> IN6_ADDR_GEN_MODE_STABLE_PRIVACY by judging the bool value of
>> "cnf.stable_secret.initialized".
> 
> and that can be updated. If the default (inherited) setting is
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA, then do not change to
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY.
> 
>> 
>> So, although adding an additional IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
>> user space process has some trouble to let kernel switch the iface's
>> addr_gen_mode to the IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA.
>> 
>> This is not as flexible as adding a separate sysctl.
>> 
>> (2)
>> After adding "proc/sys/net/ipv6/<iface>/disable_gen_linklocal_addr",
>> so that kernel can keep the original code logic of the stable_secret
>> proc file, and expand when the subsequent kernel adds a new add_gen_mode
>> more flexibility and applicability.
>> 
>> And we only need to care about the networking device that do not
>> generate an ipv6 link-local address, and not the addr_gen_mode that
>> this device is using.
>> 
>> Maybe adding a separate sysctl is a better choice.
>> Looking forward to your professional reply again.
> 
> per device sysctl's are not free. I do not see a valid reason for a
> separate disable knob.

Hi David,

Thanks for your reply,

honstly, this separate sysctl is really useful and convenient.

It allows users to simply configure the disable_gen_linklocal_addr
proc file to achieve customized configuration of ipv6 link-local
address without worrying about when the kernel will automatically
generate a link-local address.

At the same time, maybe a new addr_gen_mode will be added in the
future. If the method of adding a sysctl is adopted, we don't need
to consider the existing addr_gen_mode and the impact of adding
another new addr_gen_mode in the future.

Just simply echoing different values to the disable_gen_linklocal_addr
proc file can achieve this needs.

Thanks,
Rocco
