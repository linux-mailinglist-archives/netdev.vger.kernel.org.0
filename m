Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705091B06B3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDTKgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:36:47 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33396 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgDTKgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:36:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B4B28205A9;
        Mon, 20 Apr 2020 12:36:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aGBy6znb51da; Mon, 20 Apr 2020 12:36:43 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4D2C420536;
        Mon, 20 Apr 2020 12:36:43 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Apr 2020 12:36:43 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Apr
 2020 12:36:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B4A3231800B3; Mon, 20 Apr 2020 12:36:42 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:36:42 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] xfrm: do pskb_pull properly in
 __xfrm_transport_prep
Message-ID: <20200420103642.GF13121@gauss3.secunet.de>
References: <8ee05a6dd512e7925d80f9890af20f2a4436be5e.1586509591.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ee05a6dd512e7925d80f9890af20f2a4436be5e.1586509591.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:06:31PM +0800, Xin Long wrote:
> For transport mode, when ipv6 nexthdr is set, the packet format might
> be like:
> 
>     ----------------------------------------------------
>     |        | dest |     |     |      |  ESP    | ESP |
>     | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
> 
> and in __xfrm_transport_prep():
> 
>   pskb_pull(skb, skb->mac_len + sizeof(ip6hdr) + x->props.header_len);
> 
> it will pull the data pointer to the wrong position, as it missed the
> nexthdrs/dest opts.
> 
> This patch is to fix it by using:
> 
>   pskb_pull(skb, skb_transport_offset(skb) + x->props.header_len);
> 
> as we can be sure transport_header points to ESP header at that moment.
> 
> It also fixes a panic when packets with ipv6 nexthdr are sent over
> esp6 transport mode:
> 
>   [  100.473845] kernel BUG at net/core/skbuff.c:4325!
>   [  100.478517] RIP: 0010:__skb_to_sgvec+0x252/0x260
>   [  100.494355] Call Trace:
>   [  100.494829]  skb_to_sgvec+0x11/0x40
>   [  100.495492]  esp6_output_tail+0x12e/0x550 [esp6]
>   [  100.496358]  esp6_xmit+0x1d5/0x260 [esp6_offload]
>   [  100.498029]  validate_xmit_xfrm+0x22f/0x2e0
>   [  100.499604]  __dev_queue_xmit+0x589/0x910
>   [  100.502928]  ip6_finish_output2+0x2a5/0x5a0
>   [  100.503718]  ip6_output+0x6c/0x120
>   [  100.505198]  xfrm_output_resume+0x4bf/0x530
>   [  100.508683]  xfrm6_output+0x3a/0xc0
>   [  100.513446]  inet6_csk_xmit+0xa1/0xf0
>   [  100.517335]  tcp_sendmsg+0x27/0x40
>   [  100.517977]  sock_sendmsg+0x3e/0x60
>   [  100.518648]  __sys_sendto+0xee/0x160
> 
> Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
