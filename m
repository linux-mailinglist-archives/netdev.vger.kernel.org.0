Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DA1B2293
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgDUJWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:22:40 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49622 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgDUJWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:22:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AD8F820411;
        Tue, 21 Apr 2020 11:22:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AYQp4HR7kOEi; Tue, 21 Apr 2020 11:22:38 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0F5A2201E2;
        Tue, 21 Apr 2020 11:22:38 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Apr 2020 11:22:37 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 21 Apr
 2020 11:22:37 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2541C3180126; Tue, 21 Apr 2020 11:22:37 +0200 (CEST)
Date:   Tue, 21 Apr 2020 11:22:37 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Yuehaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH ipsec] xfrm: fix a warning in xfrm_policy_insert_list
Message-ID: <20200421092237.GS13121@gauss3.secunet.de>
References: <b328381f956215debcaa2fb70c6a10159ba1f5db.1587459464.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b328381f956215debcaa2fb70c6a10159ba1f5db.1587459464.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc Yuehaibing.

On Tue, Apr 21, 2020 at 04:57:44PM +0800, Xin Long wrote:
> This waring can be triggered simply by:
> 
>   # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
>     priority 1 mark 0 mask 0x10  #[1]
>   # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
>     priority 2 mark 0 mask 0x1   #[2]
>   # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
>     priority 2 mark 0 mask 0x10  #[3]
> 
> Then dmesg shows:
> 
>   [ ] WARNING: CPU: 1 PID: 7265 at net/xfrm/xfrm_policy.c:1548
>   [ ] RIP: 0010:xfrm_policy_insert_list+0x2f2/0x1030
>   [ ] Call Trace:
>   [ ]  xfrm_policy_inexact_insert+0x85/0xe50
>   [ ]  xfrm_policy_insert+0x4ba/0x680
>   [ ]  xfrm_add_policy+0x246/0x4d0
>   [ ]  xfrm_user_rcv_msg+0x331/0x5c0
>   [ ]  netlink_rcv_skb+0x121/0x350
>   [ ]  xfrm_netlink_rcv+0x66/0x80
>   [ ]  netlink_unicast+0x439/0x630
>   [ ]  netlink_sendmsg+0x714/0xbf0
>   [ ]  sock_sendmsg+0xe2/0x110
> 
> The issue was introduced by Commit 7cb8a93968e3 ("xfrm: Allow inserting
> policies with matching mark and different priorities"). After that, the
> policies [1] and [2] would be able to be added with different priorities.
> 
> However, policy [3] will actually match both [1] and [2]. Policy [1]
> was matched due to the 1st 'return true' in xfrm_policy_mark_match(),
> and policy [2] was matched due to the 2nd 'return true' in there. It
> caused WARN_ON() in xfrm_policy_insert_list().

This issue is also discussed here:

https://lkml.org/lkml/2020/4/21/77
