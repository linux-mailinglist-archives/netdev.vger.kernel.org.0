Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C584A5759
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 07:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbiBAGqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 01:46:48 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37070 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233800AbiBAGqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 01:46:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4FAD7201E2;
        Tue,  1 Feb 2022 07:46:41 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 48dDJZFeEzpc; Tue,  1 Feb 2022 07:46:40 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 90B69200BB;
        Tue,  1 Feb 2022 07:46:40 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 88A6680004A;
        Tue,  1 Feb 2022 07:46:40 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 07:46:40 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 1 Feb
 2022 07:46:40 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D15C6318303F; Tue,  1 Feb 2022 07:46:39 +0100 (CET)
Date:   Tue, 1 Feb 2022 07:46:39 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiri Bohac <jbohac@suse.cz>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Mike Maloney" <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] Revert "xfrm: xfrm_state_mtu should return at least 1280
 for ipv6"
Message-ID: <20220201064639.GS1223722@gauss3.secunet.de>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220124154531.GM1223722@gauss3.secunet.de>
 <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
 <20220126064214.GO1223722@gauss3.secunet.de>
 <20220126150018.7cdfxtkq2nfkqj4j@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220126150018.7cdfxtkq2nfkqj4j@dwarf.suse.cz>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 04:00:18PM +0100, Jiri Bohac wrote:
> This reverts commit b515d2637276a3810d6595e10ab02c13bfd0b63a.
> 
> Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
> should return at least 1280 for ipv6") in v5.14 breaks the TCP MSS
> calculation in ipsec transport mode, resulting complete stalls of TCP
> connections. This happens when the (P)MTU is 1280 or slighly larger.
> 
> The desired formula for the MSS is:
> MSS = (MTU - ESP_overhead) - IP header - TCP header
> 
> However, the above commit clamps the (MTU - ESP_overhead) to a
> minimum of 1280, turning the formula into
> MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header
> 
> With the (P)MTU near 1280, the calculated MSS is too large and the
> resulting TCP packets never make it to the destination because they
> are over the actual PMTU.
> 
> The above commit also causes suboptimal double fragmentation in
> xfrm tunnel mode, as described in
> https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/
> 
> The original problem the above commit was trying to fix is now fixed
> by commit 6596a0229541270fb8d38d989f91b78838e5e9da ("xfrm: fix MTU
> regression").
> 
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Applied, thanks Jiri!
