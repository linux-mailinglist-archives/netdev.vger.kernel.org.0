Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467B649C3BE
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 07:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiAZGlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 01:41:04 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:33530 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbiAZGlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 01:41:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EF0412053D;
        Wed, 26 Jan 2022 07:41:01 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h-yg8JBze1Xe; Wed, 26 Jan 2022 07:41:01 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7465C20504;
        Wed, 26 Jan 2022 07:41:01 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 6398080004A;
        Wed, 26 Jan 2022 07:41:01 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 26 Jan 2022 07:41:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 26 Jan
 2022 07:41:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7E3AC318303F; Wed, 26 Jan 2022 07:41:00 +0100 (CET)
Date:   Wed, 26 Jan 2022 07:41:00 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiri Bohac <jbohac@suse.cz>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Mike Maloney" <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: fix MTU regression
Message-ID: <20220126064100.GN1223722@gauss3.secunet.de>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220119092253.osio2qsm3dfi6otz@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220119092253.osio2qsm3dfi6otz@dwarf.suse.cz>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 10:22:53AM +0100, Jiri Bohac wrote:
> Commit 749439bfac6e1a2932c582e2699f91d329658196 ("ipv6: fix udpv6
> sendmsg crash caused by too small MTU") breaks PMTU for xfrm.
> 
> A Packet Too Big ICMPv6 message received in response to an ESP
> packet will prevent all further communication through the tunnel
> if the reported MTU minus the ESP overhead is smaller than 1280.
> 
> E.g. in a case of a tunnel-mode ESP with sha256/aes the overhead
> is 92 bytes. Receiving a PTB with MTU of 1371 or less will result
> in all further packets in the tunnel dropped. A ping through the
> tunnel fails with "ping: sendmsg: Invalid argument".
> 
> Apparently the MTU on the xfrm route is smaller than 1280 and
> fails the check inside ip6_setup_cork() added by 749439bf.
> 
> We found this by debugging USGv6/ipv6ready failures. Failing
> tests are: "Phase-2 Interoperability Test Scenario IPsec" /
> 5.3.11 and 5.4.11 (Tunnel Mode: Fragmentation).
> 
> Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm:
> xfrm_state_mtu should return at least 1280 for ipv6") attempted
> to fix this but caused another regression in TCP MSS calculations
> and had to be reverted.
> 
> The patch below fixes the situation by dropping the MTU
> check and instead checking for the underflows described in the
> 749439bf commit message.
> 
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> Fixes: 749439bfac6e ("ipv6: fix udpv6 sendmsg crash caused by too small MTU") 

Applied to the ipsec tree, thanks Jiri!
