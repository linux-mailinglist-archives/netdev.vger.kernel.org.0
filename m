Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4288269FCA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 09:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIOHaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 03:30:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:59792 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgIOHaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 03:30:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7483920482;
        Tue, 15 Sep 2020 09:30:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zv7Y5ak262BW; Tue, 15 Sep 2020 09:30:07 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 388E9200AC;
        Tue, 15 Sep 2020 09:30:07 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 09:30:07 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 15 Sep
 2020 09:30:06 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6E4F33184337; Tue, 15 Sep 2020 09:30:06 +0200 (CEST)
Date:   Tue, 15 Sep 2020 09:30:06 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     mtk81216 <lina.wang@mediatek.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH] xfrm:fragmented ipv4 tunnel packets in inner interface
Message-ID: <20200915073006.GR20687@gauss3.secunet.de>
References: <20200909062613.18604-1-lina.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200909062613.18604-1-lina.wang@mediatek.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 02:26:13PM +0800, mtk81216 wrote:
> In esp's tunnel mode,if inner interface is ipv4,outer is ipv4,one big 
> packet which travels through tunnel will be fragmented with outer 
> interface's mtu,peer server will remove tunnelled esp header and assemble
> them in big packet.After forwarding such packet to next endpoint,it will 
> be dropped because of exceeding mtu or be returned ICMP(packet-too-big).

What is the exact case where packets are dropped? Given that the packet
was fragmented (and reassembled), I'd assume the DF bit was not set. So
every router along the path is allowed to fragment again if needed.

> When inner interface is ipv4,outer is ipv6,the flag of xfrm state in tunnel
> mode is af-unspec, thing is different.One big packet through tunnel will be
> fragmented with outer interface's mtu minus tunneled header, then two or 
> more less fragmented packets will be tunneled and transmitted in outer 
> interface,that is what xfrm6_output has done. If peer server receives such
> packets, it will forward successfully to next because length is valid.
> 
> This patch has followed up xfrm6_output's logic,which includes two changes,
> one is choosing suitable mtu value which considering innner/outer 
> interface's mtu and dst path, the other is if packet is too big, calling 
> ip_fragment first,then tunnelling fragmented packets in outer interface and
> transmitting finally.
> 
> Signed-off-by: mtk81216 <lina.wang@mediatek.com>

Please use your real name to sign off.

