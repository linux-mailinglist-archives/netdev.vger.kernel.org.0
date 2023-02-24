Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748496A1796
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 08:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBXH5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 02:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXH5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 02:57:41 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE715543
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 23:57:37 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-eVmjo_9qMACmN271Yc8nEQ-1; Fri, 24 Feb 2023 02:57:33 -0500
X-MC-Unique: eVmjo_9qMACmN271Yc8nEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84CB11C05AF9;
        Fri, 24 Feb 2023 07:57:32 +0000 (UTC)
Received: from hog (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E5F140EBF4;
        Fri, 24 Feb 2023 07:57:31 +0000 (UTC)
Date:   Fri, 24 Feb 2023 08:57:30 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible info leak in
 tls_set_device_offload()
Message-ID: <Y/ht6gQL+u6fj3dG@hog>
References: <20230223090508.443157-1-hbh25y@gmail.com>
 <Y/dK6OoNpYswIqrD@hog>
 <310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com>
 <04c4d6ee-f893-5248-26cf-2c6d1c9b3aa5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <04c4d6ee-f893-5248-26cf-2c6d1c9b3aa5@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-24, 11:33:29 +0800, Hangyu Hua wrote:
> On 24/2/2023 11:07, Hangyu Hua wrote:
> > On 23/2/2023 19:15, Sabrina Dubroca wrote:
> > > 2023-02-23, 17:05:08 +0800, Hangyu Hua wrote:
> > > > After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
> > > > tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL
> > > > if it fails
> > > > before kmalloc cctx->iv. This may cause info leak when we call
> > > > do_tls_getsockopt_conf().
> > > 
> > > Is there really an issue here?
> > > 
> > > If both tls_set_device_offload and tls_set_sw_offload fail,
> > > do_tls_setsockopt_conf will clear crypto_{send,recv} from the context.
> > > Then the TLS_CRYPTO_INFO_READY in do_tls_getsockopt_conf will fail, so
> > > we won't try to access iv or rec_seq.
> > > 
> > 
> > My bad. I forget memzero_explicit. Then this is harmless. But I still
> > think it is better to set them to NULL like tls_set_sw_offload's error
> > path because we don't know there are another way to do this(I will
> > change the commit log). What do you think?

Yes, I guess for consistency between functions it would be ok.

> Like a rare case, there is a race condition between
> do_tls_getsockopt_conf and do_tls_setsockopt_conf while the previous
> condition is met. TLS_CRYPTO_INFO_READY(crypto_info) is not
> protected by lock_sock in do_tls_getsockopt_conf. It's just too
> difficult to satisfy both conditions at the same time.

Ugh, thanks for noticing this. We should move the lock_sock in
getsockopt before TLS_CRYPTO_INFO_READY. Do you want to write that
patch?

Thanks.

-- 
Sabrina

