Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD263504AC0
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 03:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbiDRCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 22:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbiDRCBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 22:01:35 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEAD183B7;
        Sun, 17 Apr 2022 18:58:56 -0700 (PDT)
X-UUID: 0679de9cd634460f8d358ad0faa66faf-20220418
X-UUID: 0679de9cd634460f8d358ad0faa66faf-20220418
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1957503384; Mon, 18 Apr 2022 09:58:52 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 18 Apr 2022 09:58:51 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 Apr
 2022 09:58:51 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 18 Apr 2022 09:58:50 +0800
From:   <Lina.Wang@mediatek.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>,
        Maciej enczykowski <maze@google.com>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] selftests: bpf: add test for bpf_skb_change_proto
Date:   Mon, 18 Apr 2022 09:52:30 +0800
Message-ID: <20220418015230.4481-1-Lina.Wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <9dc51533-92d2-1c82-2a6e-96e1ac747bb7@iogearbox.net>
References: <9dc51533-92d2-1c82-2a6e-96e1ac747bb7@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-04-07 at 17:22 +0200, Daniel Borkmann wrote:
> Hi Lina,
> 
> On 4/7/22 10:47 AM, Lina Wang wrote:
> > The code is copied from the Android Open Source Project and the
> > author(
> > Maciej Żenczykowski) has gave permission to relicense it under
> > GPLv2.
> > 
> > The test is to change input IPv6 packets to IPv4 ones and output
> > IPv4 to
> > IPv6 with bpf_skb_change_proto.
> > ---
> 
> Your patch 2/3 is utilizing this program out of
> selftests/net/udpgro_frglist.sh,
> however, this is a bit problematic given BPF CI which runs on every
> BPF submitted
> patch. Meaning, udpgro_frglist.sh won't be covered by CI and only
> needs to be run
> manually. Could you properly include this into test_progs from BPF
> suite (that way,
> BPF CI will also pick it up)? See also [2] for more complex netns
> setups.

more complex netns setups? Do u mean I should c code netns setups to
make a complete bpf test?It is complicated for my case, i just want to
simulate udp gro+ bpf to verify my fix-issue patch.
maybe I can move nat6to4.c to net/, not bpf/prog_test, then
udpgro_frglist.sh is complete.

> > +
> > +// bionic kernel uapi linux/udp.h header is munged...
> 
> nit: Throughout the file, please use C style comments as per kernel
> coding convention.
> 
Np

> > +#define __kernel_udphdr udphdr
> > +#include <linux/udp.h>
> > +
> > +#include <bpf/bpf_helpers.h>
> > +
> > +#define htons(x) (__builtin_constant_p(x) ? ___constant_swab16(x)
> > : __builtin_bswap16(x))
> > +#define htonl(x) (__builtin_constant_p(x) ? ___constant_swab32(x)
> > : __builtin_bswap32(x))
> > +#define ntohs(x) htons(x)
> > +#define ntohl(x) htonl(x)
> 
> nit: Please use libbpf's bpf_htons() and friends helpers [3].
> 
OK

> OT: In Cilium we run similar NAT46/64 translation for XDP and tc/BPF
> for our LB services [4] (that is,
> v4 VIP with v6 backends, and v6 VIP with v4 backends).
> 
>    [4] 
> https://github.com/cilium/cilium/blob/master/bpf/lib/nat_46x64.h
>        
> https://github.com/cilium/cilium/blob/master/test/nat46x64/test.sh

It is complicated for me, my case doesnot use XDP driver.I use xdp_dummy 
just to enable veth NAPI GRO, not real XDP driver code. My test case is 
simple and enough for my patch, I think. I have covered tcp and udp, 
normal and SO_SEGMENT.

Thanks!

