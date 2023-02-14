Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B84E696437
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjBNNG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjBNNG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:06:27 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA52B23C6C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:06:23 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 87B8A200AA;
        Tue, 14 Feb 2023 14:06:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XwzfExrlDK_o; Tue, 14 Feb 2023 14:06:20 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4F73C2049B;
        Tue, 14 Feb 2023 14:06:20 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 3FB6E80004A;
        Tue, 14 Feb 2023 14:06:20 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 14:06:20 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 14 Feb
 2023 14:06:19 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 358723182E51; Tue, 14 Feb 2023 14:06:19 +0100 (CET)
Date:   Tue, 14 Feb 2023 14:06:19 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Hyunwoo Kim <v4bel@theori.io>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <imv4bel@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [v2 PATCH] xfrm: Zero padding when dumping algos and encap
Message-ID: <Y+uHS/XnQEzqLh/o@gauss3.secunet.de>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
 <20230208085434.GA2933@ubuntu>
 <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
 <Y+RH4Fv8yj0g535y@gondor.apana.org.au>
 <Y+T84+VIBytBSLrJ@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+T84+VIBytBSLrJ@hog>
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

On Thu, Feb 09, 2023 at 03:02:11PM +0100, Sabrina Dubroca wrote:
> 2023-02-09, 09:09:52 +0800, Herbert Xu wrote:
> > v2 fixes the mistaken type of XFRMA_ALG_COMP for x->encap.
> > 
> > ---8<---
> > When copying data to user-space we should ensure that only valid
> > data is copied over.  Padding in structures may be filled with
> > random (possibly sensitve) data and should never be given directly
> > to user-space.
> > 
> > This patch fixes the copying of xfrm algorithms and the encap
> > template in xfrm_user so that padding is zeroed.
> > 
> > Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
> > Reported-by: Hyunwoo Kim <v4bel@theori.io>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Thanks Herbert.
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks a lot everyone!
