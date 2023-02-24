Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12286A23F5
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBXVtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 16:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBXVtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:49:19 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23632570B6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 13:49:17 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-Fwx6xZaDNR-lR9FMMiqsvw-1; Fri, 24 Feb 2023 16:49:00 -0500
X-MC-Unique: Fwx6xZaDNR-lR9FMMiqsvw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 191F287B2A2;
        Fri, 24 Feb 2023 21:49:00 +0000 (UTC)
Received: from hog (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59310492B07;
        Fri, 24 Feb 2023 21:48:58 +0000 (UTC)
Date:   Fri, 24 Feb 2023 22:48:57 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangyu Hua <hbh25y@gmail.com>, Florian Westphal <fw@strlen.de>,
        borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, davejwatson@fb.com,
        aviadye@mellanox.com, ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <Y/kwyS2n4uLn8eD0@hog>
References: <20230224105811.27467-1-hbh25y@gmail.com>
 <20230224120606.GI26596@breakpoint.cc>
 <20230224105508.4892901f@kernel.org>
 <Y/kck0/+NB+Akpoy@hog>
 <20230224130625.6b5261b4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230224130625.6b5261b4@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-24, 13:06:25 -0800, Jakub Kicinski wrote:
> On Fri, 24 Feb 2023 21:22:43 +0100 Sabrina Dubroca wrote:
> > > Right, the bug and the fix seem completely bogus.
> > > Please make sure the bugs are real and the fixes you sent actually 
> > > fix them.  
> > 
> > I suggested a change of locking in do_tls_getsockopt_conf this
> > morning [1]. The issue reported last seemed valid, but this patch is not
> > at all what I had in mind.
> > [1] https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/
> 
> Ack, I read the messages out of order, sorry.
> 
> > do_tls_setsockopt_conf fills crypto_info immediately from what
> > userspace gives us (and clears it on exit in case of failure), which
> > getsockopt could see since it's not locking the socket when it checks
> > TLS_CRYPTO_INFO_READY. So getsockopt would progress up to the point it
> > finally locks the socket, but if setsockopt failed, we could have
> > cleared TLS_CRYPTO_INFO_READY and freed iv/rec_seq.
> 
> Makes sense. We should just take the socket lock around all of
> do_tls_getsockopt(), then? 

That would make things simple and consistent. My idea was just taking
the existing lock_sock in do_tls_getsockopt_conf out of the switch and
put it just above TLS_CRYPTO_INFO_READY.

While we're at it, should we move the

    ctx->prot_info.version != TLS_1_3_VERSION

check in do_tls_setsockopt_no_pad under lock_sock?  I don't think that
can do anything wrong (we'd have to get past this check just before a
failing setsockopt clears crypto_info, and even then we're just
reading a bit from the context), it just looks a bit strange. Or just
lock the socket around all of do_tls_setsockopt_no_pad, like the other
options we have.

-- 
Sabrina

