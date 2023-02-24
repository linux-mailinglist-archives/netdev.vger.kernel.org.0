Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E695F6A2320
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 21:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBXUWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 15:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBXUWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 15:22:51 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99411FC0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 12:22:49 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-cx9-smQOP060xbLy2TSeMQ-1; Fri, 24 Feb 2023 15:22:46 -0500
X-MC-Unique: cx9-smQOP060xbLy2TSeMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6F933C0D853;
        Fri, 24 Feb 2023 20:22:45 +0000 (UTC)
Received: from hog (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 321FDC15BA0;
        Fri, 24 Feb 2023 20:22:44 +0000 (UTC)
Date:   Fri, 24 Feb 2023 21:22:43 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangyu Hua <hbh25y@gmail.com>, Florian Westphal <fw@strlen.de>,
        borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, davejwatson@fb.com,
        aviadye@mellanox.com, ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <Y/kck0/+NB+Akpoy@hog>
References: <20230224105811.27467-1-hbh25y@gmail.com>
 <20230224120606.GI26596@breakpoint.cc>
 <20230224105508.4892901f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230224105508.4892901f@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-24, 10:55:08 -0800, Jakub Kicinski wrote:
> On Fri, 24 Feb 2023 13:06:06 +0100 Florian Westphal wrote:
> > Hangyu Hua <hbh25y@gmail.com> wrote:
> > > ctx->crypto_send.info is not protected by lock_sock in
> > > do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
> > > and do_tls_setsockopt_conf() can cause a NULL point dereference or
> > > use-after-free read when memcpy.  
> > 
> > Its good practice to quote the relevant parts of the splat here.
> 
> Right, the bug and the fix seem completely bogus.
> Please make sure the bugs are real and the fixes you sent actually 
> fix them.

I suggested a change of locking in do_tls_getsockopt_conf this
morning [1]. The issue reported last seemed valid, but this patch is not
at all what I had in mind.
[1] https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/

do_tls_setsockopt_conf fills crypto_info immediately from what
userspace gives us (and clears it on exit in case of failure), which
getsockopt could see since it's not locking the socket when it checks
TLS_CRYPTO_INFO_READY. So getsockopt would progress up to the point it
finally locks the socket, but if setsockopt failed, we could have
cleared TLS_CRYPTO_INFO_READY and freed iv/rec_seq.

-- 
Sabrina

