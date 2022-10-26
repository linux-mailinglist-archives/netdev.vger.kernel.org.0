Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E7D60E24F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiJZNjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiJZNjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:39:07 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02383BBF25
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:39:05 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-3mY7VsqLMXexof_X3L_guA-1; Wed, 26 Oct 2022 09:39:02 -0400
X-MC-Unique: 3mY7VsqLMXexof_X3L_guA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71E1738107B8;
        Wed, 26 Oct 2022 13:39:00 +0000 (UTC)
Received: from hog (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4630C4022C2;
        Wed, 26 Oct 2022 13:38:57 +0000 (UTC)
Date:   Wed, 26 Oct 2022 15:38:23 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [v3 PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <Y1k4T/rgRz4rkvcl@hog>
References: <000000000000fd9a4005ebbeac67@google.com>
 <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
 <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
 <Y1Y8oN5xcIoMu+SH@hog>
 <Y1d8+FdfgtVCaTDS@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1d8+FdfgtVCaTDS@gondor.apana.org.au>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-10-25, 14:06:48 +0800, Herbert Xu wrote:
> On Mon, Oct 24, 2022 at 09:20:00AM +0200, Sabrina Dubroca wrote:
> > 2022-10-24, 14:06:12 +0800, Herbert Xu wrote:
> > > @@ -1697,11 +1699,11 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
> > >  		pfk->registered |= (1<<hdr->sadb_msg_satype);
> > >  	}
> > >  
> > > -	mutex_lock(&pfkey_mutex);
> > > +	spin_lock_bh(&pfkey_alg_lock);
> > >  	xfrm_probe_algs();
> > 
> > I don't think we can do that:
> > 
> > void xfrm_probe_algs(void)
> > {
> > 	int i, status;
> > 
> > 	BUG_ON(in_softirq());
> 
> Indeed.  I was also wrong in stating that this bug was created by
> namespaces.  This race has always existed since this code was first
> added.
> 
> ---8<---
> The function pfkey_send_acquire may race with pfkey_register
> (which could even be in a different name space).  This may result
> in a buffer overrun.
> 
> Allocating the maximum amount of memory that could be used prevents
> this.
> 
> Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

LGTM, thanks.

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

