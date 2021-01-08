Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C312EF32E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbhAHNiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:38:01 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50492 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbhAHNiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 08:38:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 741AC2057B;
        Fri,  8 Jan 2021 14:36:50 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ixpUgj6Iguuf; Fri,  8 Jan 2021 14:36:45 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 995482049B;
        Fri,  8 Jan 2021 14:35:04 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 14:35:04 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 8 Jan 2021
 14:35:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F3D0C3182BA9; Fri,  8 Jan 2021 14:35:02 +0100 (CET)
Date:   Fri, 8 Jan 2021 14:35:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net] udp: check sk for UDP GRO fraglist
Message-ID: <20210108133502.GZ3576117@gauss3.secunet.de>
References: <CGME20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134@epcas2p3.samsung.com>
 <1610110348-119768-1-git-send-email-dseok.yi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1610110348-119768-1-git-send-email-dseok.yi@samsung.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 09:52:28PM +0900, Dongseok Yi wrote:
> It is a workaround patch.
> 
> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> skb_gso_segment is updated but following frag_skbs are not updated.
> 
> A call path skb_mac_gso_segment -> inet_gso_segment ->
> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> does not try to update any UDP/IP header of the segment list.
> 
> It might make sense because each skb of frag_skbs is converted to a
> list of regular packets. Header update with checksum calculation may
> be not needed for UDP GROed frag_skbs.
> 
> But UDP GRO frag_list is started from udp_gro_receive, we don't know
> whether the skb will be NAT forwarded at that time. For workaround,
> try to get sock always when call udp4_gro_receive -> udp_gro_receive
> to check if the skb is for local.
> 
> I'm still not sure if UDP GRO frag_list is really designed for local
> session only. Can kernel support NAT forward for UDP GRO frag_list?
> What am I missing?

The initial idea when I implemented this was to have a fast
forwarding path for UDP. So forwarding is a usecase, but NAT
is a problem, indeed. A quick fix could be to segment the
skb before it gets NAT forwarded. Alternatively we could
check for a header change in __udp_gso_segment_list and
update the header of the frag_skbs accordingly in that case.

