Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3293B2F2B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFXMlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:41:46 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:58695 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229573AbhFXMlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:41:45 -0400
X-UUID: f67ee3b2ab0443539a473b3e01faec5e-20210624
X-UUID: f67ee3b2ab0443539a473b3e01faec5e-20210624
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1818821037; Thu, 24 Jun 2021 20:39:23 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Jun 2021 20:39:21 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Jun 2021 20:39:20 +0800
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
Date:   Thu, 24 Jun 2021 20:24:35 +0800
Message-ID: <20210624122435.11887-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNRKhJB9/K4SKPdR@kroah.com>
References: <YNRKhJB9/K4SKPdR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 11:04 +0200, Greg KH wrote:
On Thu, Jun 24, 2021 at 02:13:10PM +0800, Rocco Yue wrote:
>> On Thu, 2021-06-24 at 07:29 +0200, Greg KH wrote:
>>> 
>>> Thanks for the explaination, why is this hardware somehow "special" in
>>> this way that this has never been needed before?
>>> 
>>> thanks,
>>> 
>>> greg k-h
>>> 
>> 
>> Before kernel-4.18, RAWIP was the same as PUREIP, neither of them
>> automatically generates an IPv6 link-local address, and the way to
>> generate an IPv6 global address is the same.
>> 
>> After kernel-4.18 (include 4.18 version), the behavior of RAWIP had
>> changed due to the following patch:
>> @@  static int ipv6_generate_eui64(u8 *eui, struct net_device *dev)
>> +	case ARPHRD_RAWIP:
>> +		return addrconf_ifid_rawip(eui, dev);
>>  	}
>>  	return -1;
>> }
>> 
>> the reason why the kernel doesn't need to generate the link-local
>> address automatically is as follows:
>> 
>> In the 3GPP 29.061, here is some description as follows:
>> "in order to avoid any conflict between the link-local address of
>> MS and that of the GGSN, the Interface-Identifier used by the MS to
>> build its link-local address shall be assigned by the GGSN. The GGSN
>> ensures the uniqueness of this Interface-Identifier. Then MT shall
>> then enforce the use of this Interface-Identifier by the TE"
>> 
>> In other words, in the cellular network, GGSN determines whether to
>> reply to the Router Solicitation message of UE by identifying the
>> low 64bits of UE interface's ipv6 link-local address.
>> 
>> When using a new kernel and RAWIP, kernel will generate an EUI64
>> format ipv6 link-local address, and if the device uses this address
>> to send RS, GGSN will not reply RA message.
>> 
>> Therefore, in that background, we came up with PUREIP to make kernel
>> doesn't generate a ipv6 link-local address in any address generate
>> mode.
> 
> Thanks for the better description.  That should go into the changelog
> text somewhere so that others know what is going on here with this new
> option.
>

Does changelog mean adding these details to the commit message ?
I am willing do it.

> And are these user-visable flags documented in a man page or something
> else somewhere?  If not, how does userspace know about them?
> 

There are mappings of these device types value in the libc:
"/bionic/libc/kernel/uapi/linux/if_arp.h".
userspace can get it from here.

But I also failed to find a man page or a description of these
device types.

Thanks,
Rocco

