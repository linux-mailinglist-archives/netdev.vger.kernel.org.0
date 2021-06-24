Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B633B2760
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFXGaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:30:20 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:45797 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231132AbhFXGaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:30:19 -0400
X-UUID: e3c7c8f1ed7e4f5fb9d9096946be6d03-20210624
X-UUID: e3c7c8f1ed7e4f5fb9d9096946be6d03-20210624
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 744569985; Thu, 24 Jun 2021 14:27:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Jun 2021 14:27:55 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Jun 2021 14:27:53 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        David Ahern <dsahern@gmail.com>
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
Date:   Thu, 24 Jun 2021 14:13:10 +0800
Message-ID: <20210624061310.12315-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNQYHfE09Dx5kWyg@kroah.com>
References: <YNQYHfE09Dx5kWyg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 07:29 +0200, Greg KH wrote:
> 
> Thanks for the explaination, why is this hardware somehow "special" in
> this way that this has never been needed before?
> 
> thanks,
> 
> greg k-h
> 

Before kernel-4.18, RAWIP was the same as PUREIP, neither of them
automatically generates an IPv6 link-local address, and the way to
generate an IPv6 global address is the same.

After kernel-4.18 (include 4.18 version), the behavior of RAWIP had
changed due to the following patch:
@@  static int ipv6_generate_eui64(u8 *eui, struct net_device *dev)
+	case ARPHRD_RAWIP:
+		return addrconf_ifid_rawip(eui, dev);
 	}
 	return -1;
}

the reason why the kernel doesn't need to generate the link-local
address automatically is as follows:

In the 3GPP 29.061, here is some description as follows:
"in order to avoid any conflict between the link-local address of
MS and that of the GGSN, the Interface-Identifier used by the MS to
build its link-local address shall be assigned by the GGSN. The GGSN
ensures the uniqueness of this Interface-Identifier. Then MT shall
then enforce the use of this Interface-Identifier by the TE"

In other words, in the cellular network, GGSN determines whether to
reply to the Router Solicitation message of UE by identifying the
low 64bits of UE interface's ipv6 link-local address.

When using a new kernel and RAWIP, kernel will generate an EUI64
format ipv6 link-local address, and if the device uses this address
to send RS, GGSN will not reply RA message.

Therefore, in that background, we came up with PUREIP to make kernel
doesn't generate a ipv6 link-local address in any address generate
mode.

Thanks,
Rocco

