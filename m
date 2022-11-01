Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8C6151EF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKATKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKATK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:10:28 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8432F1DDC9
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 12:10:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6332920527;
        Tue,  1 Nov 2022 20:10:24 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9cREXNv5l-Mj; Tue,  1 Nov 2022 20:10:23 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DB6C0204E5;
        Tue,  1 Nov 2022 20:10:23 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D3E8A80004A;
        Tue,  1 Nov 2022 20:10:23 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 20:10:23 +0100
Received: from moon.secunet.de (172.18.149.2) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 1 Nov
 2022 20:10:22 +0100
Date:   Tue, 1 Nov 2022 20:10:21 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antony Antony <antony.antony@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Leon Romanovsky <leon@kernel.org>,
        "Roth Mark" <rothm@mail.com>, Zhihao Chen <chenzhihao@meizu.com>,
        Tobias Brunner <tobias@strongswan.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: Fix oops in __xfrm_state_delete()
Message-ID: <Y2FvHZiWejxRiIS8@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20221031152612.o3h44x3whath4iyp@intra2net.com>
 <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:39:48 +0800, Herbert Xu wrote:
> On Mon, Oct 31, 2022 at 04:26:12PM +0100, Thomas Jarosch wrote:
> >
> > diff --git a/net/key/af_key.c b/net/key/af_key.c
> > index c85df5b958d2..65a9ede62d65 100644
> > --- a/net/key/af_key.c
> > +++ b/net/key/af_key.c
> > @@ -3382,7 +3382,7 @@ static int pfkey_send_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
> >  	hdr->sadb_msg_len = size / sizeof(uint64_t);
> >  	hdr->sadb_msg_errno = 0;
> >  	hdr->sadb_msg_reserved = 0;
> > -	hdr->sadb_msg_seq = x->km.seq = get_acqseq();

This line looks very odd.

> > +	hdr->sadb_msg_seq = get_acqseq();
> 
> This looks broken.  x->km.seq is part of the state which you are
> changing.  Shouldn't you do whatever xfrm_user does in the same
> situation?

xfrm_user sets msg_seq to zero in mapping change message. seq is only useful for
acquire message. I think setting to zero would be a better fix.

-	hdr->sadb_msg_seq = x->km.seq = get_acqseq();
+	hdr->sadb_msg_seq = 0;

While increasing x->km.seq in every call to pfkey_send_new_mapping()
could be an issue, would it alone explan the crash?

Tobias would pfkey_send_new_mapping() called in a default setting?
