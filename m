Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B094BE4EA
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355914AbiBULUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:20:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355739AbiBULT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:19:28 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960973B8;
        Mon, 21 Feb 2022 03:04:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4B3C3204E5;
        Mon, 21 Feb 2022 12:04:07 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JgmJFGSUZo9J; Mon, 21 Feb 2022 12:04:06 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6FE99200A0;
        Mon, 21 Feb 2022 12:04:06 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 6A59680004A;
        Mon, 21 Feb 2022 12:04:06 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 21 Feb 2022 12:04:06 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 21 Feb
 2022 12:04:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B53743182F10; Mon, 21 Feb 2022 12:04:05 +0100 (CET)
Date:   Mon, 21 Feb 2022 12:04:05 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Lina Wang <lina.wang@mediatek.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] xfrm: fix tunnel model fragmentation behavior
Message-ID: <20220221110405.GJ1223722@gauss3.secunet.de>
References: <20220221051648.22660-1-lina.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220221051648.22660-1-lina.wang@mediatek.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 01:16:48PM +0800, Lina Wang wrote:
> in tunnel mode, if outer interface(ipv4) is less, it is easily to let 
> inner IPV6 mtu be less than 1280. If so, a Packet Too Big ICMPV6 message 
> is received. When send again, packets are fragmentized with 1280, they
> are still rejected with ICMPV6(Packet Too Big) by xfrmi_xmit2().
> 
> According to RFC4213 Section3.2.2:
>          if (IPv4 path MTU - 20) is less than 1280
>                  if packet is larger than 1280 bytes
>                          Send ICMPv6 "packet too big" with MTU = 1280.
>                          Drop packet.
>                  else
>                          Encapsulate but do not set the Don't Fragment
>                          flag in the IPv4 header.  The resulting IPv4
>                          packet might be fragmented by the IPv4 layer
>                          on the encapsulator or by some router along
>                          the IPv4 path.
>                  endif
>          else
>                  if packet is larger than (IPv4 path MTU - 20)
>                          Send ICMPv6 "packet too big" with
>                          MTU = (IPv4 path MTU - 20).
>                          Drop packet.
>                  else
>                          Encapsulate and set the Don't Fragment flag
>                          in the IPv4 header.
>                  endif
>          endif
> Packets should be fragmentized with ipv4 outer interface, so change it.
> 
> After it is fragemtized with ipv4, there will be double fragmenation.
> No.48 & No.51 are ipv6 fragment packets, No.48 is double fragmentized, 
> then tunneled with IPv4(No.49& No.50), which obey spec. And received peer
> cannot decrypt it rightly.
> 
> 48              2002::10	2002::11 1296(length) IPv6 fragment (off=0 more=y ident=0xa20da5bc nxt=50) 
> 49   0x0000 (0) 2002::10	2002::11 1304	      IPv6 fragment (off=0 more=y ident=0x7448042c nxt=44)
> 50   0x0000 (0)	2002::10	2002::11 200	      ESP (SPI=0x00035000) 
> 51		2002::10	2002::11 180	      Echo (ping) request 
> 52   0x56dc     2002::10	2002::11 248	      IPv6 fragment (off=1232 more=n ident=0xa20da5bc nxt=50)
> 
> esp_noneed_fragment has fixed above issues. Finally, it acted like below:
> 1   0x6206 192.168.1.138   192.168.1.1 1316 Fragmented IP protocol (proto=Encap Security Payload 50, off=0, ID=6206) [Reassembled in #2]
> 2   0x6206 2002::10	   2002::11    88   IPv6 fragment (off=0 more=y ident=0x1f440778 nxt=50)
> 3   0x0000 2002::10	   2002::11    248  ICMPv6    Echo (ping) request 
> 
> Signed-off-by: Lina Wang <lina.wang@mediatek.com>

We have two commits in the ipsec tree that address a very similar
issue. That is:

commit 6596a0229541270fb8d38d989f91b78838e5e9da
xfrm: fix MTU regression

and

commit a6d95c5a628a09be129f25d5663a7e9db8261f51
Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Can you please doublecheck that the issue you are fixing still
exist in the ipsec tree?

Thanks!
