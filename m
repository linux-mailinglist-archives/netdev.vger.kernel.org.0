Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194F16CFD7E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjC3H4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjC3H43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:56:29 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4B518F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:56:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 791ED20896;
        Thu, 30 Mar 2023 09:56:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9KeJiS_IkQgr; Thu, 30 Mar 2023 09:56:23 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 05C7020895;
        Thu, 30 Mar 2023 09:56:23 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id F37DA80004A;
        Thu, 30 Mar 2023 09:56:22 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 30 Mar 2023 09:56:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 30 Mar
 2023 09:56:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2A7CB318033A; Thu, 30 Mar 2023 09:56:22 +0200 (CEST)
Date:   Thu, 30 Mar 2023 09:56:22 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Tudor Ambarus <tudordana@google.com>
CC:     Hyunwoo Kim <v4bel@theori.io>, Eric Dumazet <edumazet@google.com>,
        "Taehee Yoo" <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <imv4bel@gmail.com>, Lee Jones <joneslee@google.com>
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
Message-ID: <ZCVApoRV/myYz1Hx@gauss3.secunet.de>
References: <20230321024946.GA21870@ubuntu>
 <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
 <20230321050803.GA22060@ubuntu>
 <ZBmMUjSXPzFBWeTv@gauss3.secunet.de>
 <20230321111430.GA22737@ubuntu>
 <CANn89iJVU1yfCfyyUpmMeZA7BEYLfVXYsK80H26WM=hB-1B27Q@mail.gmail.com>
 <20230321113509.GA23276@ubuntu>
 <ZB10DlJoNmGhRINM@gauss3.secunet.de>
 <179721c2-f471-0e26-9023-4742a5e2489c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <179721c2-f471-0e26-9023-4742a5e2489c@google.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 08:42:56AM +0100, Tudor Ambarus wrote:
> Hi, Steffen!
> 
> On 3/24/23 09:57, Steffen Klassert wrote:
> > 
> > I plan to fix this with the patch below. With this, the above policy
> > should be rejected. It still needs a bit of testing to make sure that
> > I prohibited no valid usecase with it.
> > 
> > ---
> > Subject: [PATCH RFC ipsec] xfrm: Don't allow optional intermediate templates that
> >  changes the address family
> > 
> > When an optional intermediate template changes the address family,
> > it is unclear which family the next template should have. This can
> > lead to misinterpretations of IPv4/IPv6 addresses. So reject
> > optional intermediate templates on insertion time.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Hyunwoo Kim <v4bel@theori.io>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > ---
> >  net/xfrm/xfrm_user.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> 
> What's the status of this patch? I'm asking because LTS kernels are
> affected and we'll have to fix them too. I tried searching for a related
> patch on public ml archives and into the IPSEC repositories and I
> couldn't find one.

I'll likely submit that patch tomorrow. I will go to the ipsec tree
soon, if there are no objections on the list.
