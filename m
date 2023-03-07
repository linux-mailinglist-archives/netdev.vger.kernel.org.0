Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F26ADDE5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjCGLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjCGLru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:47:50 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E5B73AD1
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 03:46:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6B974201E4;
        Tue,  7 Mar 2023 12:31:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id if7BnsT5iahY; Tue,  7 Mar 2023 12:31:20 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AB77420501;
        Tue,  7 Mar 2023 12:31:20 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 99CD280004A;
        Tue,  7 Mar 2023 12:31:20 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 7 Mar 2023 12:31:20 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 7 Mar
 2023 12:31:20 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DC7D33182D73; Tue,  7 Mar 2023 12:31:19 +0100 (CET)
Date:   Tue, 7 Mar 2023 12:31:19 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] af_key: fix kernel-infoleak vs XFRMA_ALG_COMP
Message-ID: <ZAcghyIW77Zo0taS@gauss3.secunet.de>
References: <20230307100231.227738-1-edumazet@google.com>
 <ZAcVL3ZYGkaoFX1+@gondor.apana.org.au>
 <CANn89iKns8CmuM3AK45B5bYFEwcEiNmfMee_4H2SHBcZDVdX+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iKns8CmuM3AK45B5bYFEwcEiNmfMee_4H2SHBcZDVdX+g@mail.gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:28:47PM +0100, Eric Dumazet wrote:
> On Tue, Mar 7, 2023 at 11:43 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Tue, Mar 07, 2023 at 10:02:31AM +0000, Eric Dumazet wrote:
> > > When copy_to_user_state_extra() copies to netlink skb
> > > x->calg content, it expects calg was fully initialized.
> > >
> > > We must make sure all unused bytes are cleared at
> > > allocation side.
> >
> > This has already been fixed:
> >
> > https://lore.kernel.org/all/Y+RH4Fv8yj0g535y@gondor.apana.org.au/
> 
> Ah, I thought this was for a different issue.
> 
> I do not see this patch in net tree yet ?

It is still in the ipsec tree. It will go upstream
this week.

Thanks!
