Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706286A072A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 12:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbjBWLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 06:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjBWLQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 06:16:14 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD9353292
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 03:16:12 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-SdHWv8HcNEia4nmSBJEwSQ-1; Thu, 23 Feb 2023 06:15:55 -0500
X-MC-Unique: SdHWv8HcNEia4nmSBJEwSQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F24B8800B23;
        Thu, 23 Feb 2023 11:15:54 +0000 (UTC)
Received: from hog (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95448492B00;
        Thu, 23 Feb 2023 11:15:53 +0000 (UTC)
Date:   Thu, 23 Feb 2023 12:15:52 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible info leak in
 tls_set_device_offload()
Message-ID: <Y/dK6OoNpYswIqrD@hog>
References: <20230223090508.443157-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230223090508.443157-1-hbh25y@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-23, 17:05:08 +0800, Hangyu Hua wrote:
> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
> before kmalloc cctx->iv. This may cause info leak when we call
> do_tls_getsockopt_conf().

Is there really an issue here?

If both tls_set_device_offload and tls_set_sw_offload fail,
do_tls_setsockopt_conf will clear crypto_{send,recv} from the context.
Then the TLS_CRYPTO_INFO_READY in do_tls_getsockopt_conf will fail, so
we won't try to access iv or rec_seq.

-- 
Sabrina

