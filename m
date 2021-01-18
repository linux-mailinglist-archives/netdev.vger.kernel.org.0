Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746052FA09B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391788AbhARM7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 07:59:41 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:60732 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391719AbhARM7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 07:59:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 23CC3201E4;
        Mon, 18 Jan 2021 13:58:16 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YVpkQoYFr9KA; Mon, 18 Jan 2021 13:58:15 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9D0C4200BC;
        Mon, 18 Jan 2021 13:58:15 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 18 Jan 2021 13:58:15 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 18 Jan
 2021 13:58:14 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id EF5813182E9B;
 Mon, 18 Jan 2021 13:58:14 +0100 (CET)
Date:   Mon, 18 Jan 2021 13:58:14 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Alexander Lobakin <alobakin@pm.me>
CC:     Dongseok Yi <dseok.yi@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>, Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Willem de Bruijn" <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Message-ID: <20210118125814.GL3576117@gauss3.secunet.de>
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
 <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
 <20210115171203.175115-1-alobakin@pm.me>
 <20210118063759.GK3576117@gauss3.secunet.de>
 <20210118121707.2130-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210118121707.2130-1-alobakin@pm.me>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 12:17:34PM +0000, Alexander Lobakin wrote:
> > From: Steffen Klassert <steffen.klassert@secunet.com>
> > Date: Mon, 18 Jan 2021 07:37:59 +0100
> > On Fri, Jan 15, 2021 at 05:12:33PM +0000, Alexander Lobakin wrote:
> >>
> >> I used another approach, tried to make fraglist GRO closer to plain
> >> in terms of checksummming, as it is confusing to me why GSO packet
> >> should have CHECKSUM_UNNECESSARY.
> >
> > This is intentional. With fraglist GRO, we don't mangle packets
> > in the standard (non NAT) case. So the checksum is still correct
> > after segmentation. That is one reason why it has good forwarding
> > performance when software segmentation is needed. Checksuming
> > touches the whole packet and has a lot of overhead, so it is
> > heplfull to avoid it whenever possible.
> >
> > We should find a way to do the checksum only when we really
> > need it. I.e. only if the headers of the head skb changed.
> 
> I suggest to do memcmp() between skb_network_header(skb) and
> skb_network_header(skb->frag_list) with the len of
> skb->data - skb_network_header(skb). This way we will detect changes
> in IPv4/IPv6 and UDP headers.

I thought about that too. Bbut with fraglist GRO, the length of
the packets can vary. Unlike standard GRO, there is no requirement
that the packets in the fraglist must be equal in length here. So
we can't compare the full headers. I think we need to test for
addresses and ports.

> If so, copy the full headers and fall back to the standard checksum,
> recalculation, else use the current path.

I agree that we should fallback to standard checksum recalculation
if the addresses or ports changed.
