Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855E621AED0
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 07:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGJFi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 01:38:29 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37802 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgGJFi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 01:38:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1904C2055E;
        Fri, 10 Jul 2020 07:38:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AIQmszMbNI9z; Fri, 10 Jul 2020 07:38:27 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A14CF201A0;
        Fri, 10 Jul 2020 07:38:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 07:38:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 10 Jul
 2020 07:38:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 09E9631846AE; Fri, 10 Jul 2020 07:38:27 +0200 (CEST)
Date:   Fri, 10 Jul 2020 07:38:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "kbuild test robot" <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCHv3 ipsec-next 00/10] xfrm: support ipip and ipv6 tunnels
 in vti and xfrmi
Message-ID: <20200710053826.GB20687@gauss3.secunet.de>
References: <cover.1594036709.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 08:01:28PM +0800, Xin Long wrote:
> Now ipip and ipv6 tunnels processing is supported by xfrm4/6_tunnel,
> but not in vti and xfrmi. This feature is needed by processing those
> uncompressed small fragments and packets when using comp protocol.
> It means vti and xfrmi won't be able to accept small fragments or
> packets when using comp protocol, which is not expected.
> 
> xfrm4/6_tunnel eventually calls xfrm_input() to process ipip and ipv6
> tunnels with an ipip/ipv6-proto state (a child state of comp-proto
> state), and vti and xfrmi should do the same.
> 
> The extra things for vti to do is:
> 
>   - vti_input() should be called before xfrm_input() to set
>     XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4/6 = tunnel. [A]
> 
>   - vti_rcv_cb() should be called after xfrm_input() to update
>     the skb->dev. [B]
> 
> And the extra things for xfrmi to do is:
> 
>    - The ipip/ipv6-proto state should be assigned if_id from its
>      parent's state. [C]
> 
>    - xfrmi_rcv_cb() should be called after xfrm_input() to update
>      the skb->dev. [D]
> 
> 
> Patch 4-7 does the things in [A].
> 
> To implement [B] and [D], patch 1-3 is to build a callback function
> for xfrm4/6_tunnel, which can be called after xfrm_input(), similar
> to xfrm4/6_protocol's .cb_handler. vti and xfrmi only needs to give
> their own callback function in patch 4-7 and 9-10, which already
> exists: vti_rcv_cb() and xfrmi_rcv_cb().
> 
> Patch 8 is to do the thing in [C] by assigning child tunnel's if_id
> from its parent tunnel.
> 
> With the whole patch series, the segments or packets with any size
> can work with ipsec comp proto on vti and xfrmi.
> 
> v1->v2:
>   - See Patch 2-3.
> v2->v3:
>   - See Patch 2-3, 4, 6, 9-10.

Series applied, thanks a lot Xin!
