Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5E95EED1B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbiI2FOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiI2FOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:14:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3D811BCE0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:14:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E3E722049B;
        Thu, 29 Sep 2022 07:14:02 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z6G2lrl2sQBy; Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 54A5E20082;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 42E4080004A;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 07:14:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 07:14:00 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B2E693182ADB; Thu, 29 Sep 2022 07:14:00 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/3] xfrm: Update ipcomp_scratches with NULL when freed
Date:   Thu, 29 Sep 2022 07:13:56 +0200
Message-ID: <20220929051357.3497325-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929051357.3497325-1-steffen.klassert@secunet.com>
References: <20220929051357.3497325-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
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

From: Khalid Masum <khalid.masum.92@gmail.com>

Currently if ipcomp_alloc_scratches() fails to allocate memory
ipcomp_scratches holds obsolete address. So when we try to free the
percpu scratches using ipcomp_free_scratches() it tries to vfree non
existent vm area. Described below:

static void * __percpu *ipcomp_alloc_scratches(void)
{
        ...
        scratches = alloc_percpu(void *);
        if (!scratches)
                return NULL;
ipcomp_scratches does not know about this allocation failure.
Therefore holding the old obsolete address.
        ...
}

So when we free,

static void ipcomp_free_scratches(void)
{
        ...
        scratches = ipcomp_scratches;
Assigning obsolete address from ipcomp_scratches

        if (!scratches)
                return;

        for_each_possible_cpu(i)
               vfree(*per_cpu_ptr(scratches, i));
Trying to free non existent page, causing warning: trying to vfree
existent vm area.
        ...
}

Fix this breakage by updating ipcomp_scrtches with NULL when scratches
is freed

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_ipcomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..92ad336a83ab 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -203,6 +203,7 @@ static void ipcomp_free_scratches(void)
 		vfree(*per_cpu_ptr(scratches, i));
 
 	free_percpu(scratches);
+	ipcomp_scratches = NULL;
 }
 
 static void * __percpu *ipcomp_alloc_scratches(void)
-- 
2.25.1

