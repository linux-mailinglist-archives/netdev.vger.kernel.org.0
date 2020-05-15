Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8B81D476A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgEOHx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 03:53:56 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44020 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgEOHx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 03:53:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7C32F2055E;
        Fri, 15 May 2020 09:53:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jZSae1sjwtQi; Fri, 15 May 2020 09:53:50 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B62AB2057A;
        Fri, 15 May 2020 09:53:50 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 15 May 2020 09:53:50 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 15 May
 2020 09:53:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C4C7731800AA;
 Fri, 15 May 2020 09:53:49 +0200 (CEST)
Date:   Fri, 15 May 2020 09:53:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] esp6: calculate transport_header correctly when
 sel.family != AF_INET6
Message-ID: <20200515075349.GV13121@gauss3.secunet.de>
References: <5224dd1a6287b41e9747385154a0dff4f115590a.1589366334.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5224dd1a6287b41e9747385154a0dff4f115590a.1589366334.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 06:38:54PM +0800, Xin Long wrote:
> In esp6_init_state() for beet mode when x->sel.family != AF_INET6:
> 
>   x->props.header_len = sizeof(struct ip_esp_hdr) +
>      crypto_aead_ivsize(aead) + IPV4_BEET_PHMAXLEN +
>      (sizeof(struct ipv6hdr) - sizeof(struct iphdr))
> 
> In xfrm6_beet_gso_segment() skb->transport_header is supposed to move
> to the end of the ph header for IPPROTO_BEETPH, so if x->sel.family !=
> AF_INET6 and it's IPPROTO_BEETPH, it should do:
> 
>    skb->transport_header -=
>       (sizeof(struct ipv6hdr) - sizeof(struct iphdr));
>    skb->transport_header += ph->hdrlen * 8;
> 
> And IPV4_BEET_PHMAXLEN is only reserved for PH header, so if
> x->sel.family != AF_INET6 and it's not IPPROTO_BEETPH, it should do:
> 
>    skb->transport_header -=
>       (sizeof(struct ipv6hdr) - sizeof(struct iphdr));
>    skb->transport_header -= IPV4_BEET_PHMAXLEN;
> 
> Thanks Sabrina for looking deep into this issue.
> 
> Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
> Reported-by: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin!
