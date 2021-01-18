Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4AD2F9A00
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 07:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbhARGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 01:38:45 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36706 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbhARGin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 01:38:43 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C5993201D5;
        Mon, 18 Jan 2021 07:38:01 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fTVnJEMH7k3n; Mon, 18 Jan 2021 07:38:00 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EF58C200BC;
        Mon, 18 Jan 2021 07:38:00 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 18 Jan 2021 07:38:00 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 18 Jan
 2021 07:38:00 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B737C3182E9B;
 Mon, 18 Jan 2021 07:37:59 +0100 (CET)
Date:   Mon, 18 Jan 2021 07:37:59 +0100
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
Message-ID: <20210118063759.GK3576117@gauss3.secunet.de>
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
 <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
 <20210115171203.175115-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210115171203.175115-1-alobakin@pm.me>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 05:12:33PM +0000, Alexander Lobakin wrote:
> From: Dongseok Yi <dseok.yi@samsung.com>
> Date: Fri, 15 Jan 2021 22:20:35 +0900
> 
> > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > skb_gso_segment is updated but following frag_skbs are not updated.
> > 
> > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > does not try to update UDP/IP header of the segment list but copy
> > only the MAC header.
> > 
> > Update dport, daddr and checksums of each skb of the segment list
> > in __udp_gso_segment_list. It covers both SNAT and DNAT.
> > 
> > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > ---
> > v1:
> > Steffen Klassert said, there could be 2 options.
> > https://lore.kernel.org/patchwork/patch/1362257/
> > I was trying to write a quick fix, but it was not easy to forward
> > segmented list. Currently, assuming DNAT only.
> > 
> > v2:
> > Per Steffen Klassert request, move the procedure from
> > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> > 
> > To Alexander Lobakin, I've checked your email late. Just use this
> > patch as a reference. It support SNAT too, but does not support IPv6
> > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > to the file is in IPv4 directory.
> 
> I used another approach, tried to make fraglist GRO closer to plain
> in terms of checksummming, as it is confusing to me why GSO packet
> should have CHECKSUM_UNNECESSARY.

This is intentional. With fraglist GRO, we don't mangle packets
in the standard (non NAT) case. So the checksum is still correct
after segmentation. That is one reason why it has good forwarding
performance when software segmentation is needed. Checksuming
touches the whole packet and has a lot of overhead, so it is
heplfull to avoid it whenever possible.

We should find a way to do the checksum only when we really
need it. I.e. only if the headers of the head skb changed.

