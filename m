Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E7C4B999A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiBQHIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:08:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiBQHIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:08:00 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5EF28ADA2;
        Wed, 16 Feb 2022 23:07:41 -0800 (PST)
X-UUID: a549484970ab4c659dbf3a1fca61e35b-20220217
X-UUID: a549484970ab4c659dbf3a1fca61e35b-20220217
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1352216927; Thu, 17 Feb 2022 15:07:34 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 17 Feb 2022 15:07:33 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Feb 2022 15:07:32 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3] net: fix wrong network header length
Date:   Thu, 17 Feb 2022 15:01:39 +0800
Message-ID: <20220217070139.30028-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <CAADnVQK78PN8N6c6u_O2BAxdyXwH_HVYMV_x3oGgyfT50a6ymg@mail.gmail.com>
References: <CAADnVQK78PN8N6c6u_O2BAxdyXwH_HVYMV_x3oGgyfT50a6ymg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-16 at 19:05 -0800, Alexei Starovoitov wrote:
> On Tue, Feb 15, 2022 at 11:37 PM Lina Wang <lina.wang@mediatek.com>
> wrote:
> > 
> > When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is
> > enable,
> > several skbs are gathered in skb_shinfo(skb)->frag_list. The first
> > skb's
> > ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> > network_header\transport_header\mac_header have been updated as
> > ipv4 acts,
> > but other skbs in frag_list didnot update anything, just ipv6
> > packets.
> 
> Please add a test that demonstrates the issue and verifies the fix.

I used iperf udp test to verify the patch, server peer enabled -d to debug
received packets.

192.0.0.4 is clatd interface ip, corresponding ipv6 addr is 
2000:1:1:1:afca:1b1f:1a9:b367, server peer ip is 1.1.1.1,
whose ipv6 is 2004:1:1:1::101:101.

Without the patch, when udp length 2840 packets received, iperf shows:
pcount 1 packet_count 0
pcount 27898727 packet_count 1
pcount 3 packet_count 27898727

pcount should be 2, but is 27898727(0x1a9b367) , which is 20 bytes put 
forward. 

12:08:02.680299	Unicast to us 2004:1:1:1::101:101   2000:1:1:1:afca:1b1f:1a9:b367 UDP 51196 → 5201 Len=2840
0000   20 00 00 01 00 01 00 01 af ca 1b 1f 01 a9 b3 67   ipv6 dst address
0000   c7 fc 14 51 0b 20 c7 ab                           udp header
0000   00 00 00 ab 00 0e f3 49 00 00 00 01 08 06 69 d2   00000001 is pcount
12:08:02.682084	Unicast to us	1.1.1.1	                 192.0.0.4 	 	  UDP 51196 → 5201 Len=2840

After applied the patch, there is no OOO, pcount acted in order.

Thanks!
