Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321716734F6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjASKA7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Jan 2023 05:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjASKAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:00:24 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4F067796
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:00:21 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-nW76kCZIPne7wc871JK6_w-1; Thu, 19 Jan 2023 05:00:04 -0500
X-MC-Unique: nW76kCZIPne7wc871JK6_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A533A1818E58;
        Thu, 19 Jan 2023 10:00:03 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A87422026D68;
        Thu, 19 Jan 2023 10:00:02 +0000 (UTC)
Date:   Thu, 19 Jan 2023 10:58:32 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net/ulp: use consistent error code when blocking ULP
Message-ID: <Y8kUSPZSEOE57reb@hog>
References: <7bb199e7a93317fb6f8bf8b9b2dc71c18f337cde.1674042685.git.pabeni@redhat.com>
MIME-Version: 1.0
In-Reply-To: <7bb199e7a93317fb6f8bf8b9b2dc71c18f337cde.1674042685.git.pabeni@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-18, 13:24:12 +0100, Paolo Abeni wrote:
> The referenced commit changed the error code returned by the kernel
> when preventing a non-established socket from attaching the ktls
> ULP. Before to such a commit, the user-space got ENOTCONN instead
> of EINVAL.
> 
> The existing self-tests depend on such error code, and the change
> caused a failure:
> 
>   RUN           global.non_established ...
>  tls.c:1673:non_established:Expected errno (22) == ENOTCONN (107)
>  non_established: Test failed at step #3
>           FAIL  global.non_established
> 
> In the unlikely event existing applications do the same, address
> the issue by restoring the prior error code in the above scenario.
> 
> Note that the only other ULP performing similar checks at init
> time - smc_ulp_ops - also fails with ENOTCONN when trying to attach
> the ULP to a non-established socket.
> 
> Reported-by: Sabrina Dubroca <sd@queasysnail.net>
> Fixes: 2c02d41d71f9 ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks Paolo.

-- 
Sabrina

