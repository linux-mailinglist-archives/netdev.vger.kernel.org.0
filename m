Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFD252B468
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiERIMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiERIMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:12:07 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460282FFDF
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:12:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 67241206B0;
        Wed, 18 May 2022 10:12:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8ZSKLrOdf2Ah; Wed, 18 May 2022 10:12:00 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8290420787;
        Wed, 18 May 2022 10:12:00 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7C9A380004A;
        Wed, 18 May 2022 10:12:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 10:12:00 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 10:11:59 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 88A923182D02; Wed, 18 May 2022 10:11:59 +0200 (CEST)
Date:   Wed, 18 May 2022 10:11:59 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <herbert@gondor.apana.org.au>,
        <nicolas.dichtel@6wind.com>, <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" flag use when
 arriving from different devices
Message-ID: <20220518081159.GS680067@gauss3.secunet.de>
References: <20220513203402.1290131-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220513203402.1290131-1-eyal.birger@gmail.com>
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

On Fri, May 13, 2022 at 11:34:02PM +0300, Eyal Birger wrote:
> In IPv4 setting the "disable_policy" flag on a device means no policy
> should be enforced for traffic originating from the device. This was
> implemented by seting the DST_NOPOLICY flag in the dst based on the
> originating device.
> 
> However, dsts are cached in nexthops regardless of the originating
> devices, in which case, the DST_NOPOLICY flag value may be incorrect.
> 
> Consider the following setup:
> 
>                      +------------------------------+
>                      | ROUTER                       |
>   +-------------+    | +-----------------+          |
>   | ipsec src   |----|-|ipsec0           |          |
>   +-------------+    | |disable_policy=0 |   +----+ |
>                      | +-----------------+   |eth1|-|-----
>   +-------------+    | +-----------------+   +----+ |
>   | noipsec src |----|-|eth0             |          |
>   +-------------+    | |disable_policy=1 |          |
>                      | +-----------------+          |
>                      +------------------------------+
> 
> Where ROUTER has a default route towards eth1.
> 
> dst entries for traffic arriving from eth0 would have DST_NOPOLICY
> and would be cached and therefore can be reused by traffic originating
> from ipsec0, skipping policy check.
> 
> Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
> of the DST in IN/FWD IPv4 policy checks.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ---
> 
> v2: set IPSKB_NOPOLICY in ip_route_input_mc() as needed

Applied, thanks a lot Eyal!
