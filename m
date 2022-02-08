Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04864AE0C8
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384937AbiBHS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346719AbiBHS1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:27:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37B07C06157B
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644344869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bHltsITjcGLh+BqksFUL+z3yHA0H6+hdvGkFSwF9lxM=;
        b=BCNJH+1aqqlKFrF2gSR2Bt3M100DRo5FooFImwD8Q2ZYFRnAFgG8w3mLxpACfdu4OQ/IF6
        uglz5NZRk6Ds6LsERyogfUfMtS79sU6ylMtOf6wTr9XgHOw677VjU4eUNvAuao51TwA6Uu
        B/6h7ch/0KRWUVO42IVwDMH0sq1OGsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-qByAX9KoPUuj10wW4gewlQ-1; Tue, 08 Feb 2022 13:27:46 -0500
X-MC-Unique: qByAX9KoPUuj10wW4gewlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AADA83DD21;
        Tue,  8 Feb 2022 18:27:44 +0000 (UTC)
Received: from fenrir.redhat.com (unknown [10.22.35.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E02174EA0;
        Tue,  8 Feb 2022 18:27:42 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next] tipc: rate limit warning for received illegal binding update
Date:   Tue,  8 Feb 2022 13:31:57 -0500
Message-Id: <20220208183157.922752-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

It would be easy to craft a message containing an illegal binding table
update operation. This is handled correctly by the code, but the
corresponding warning printout is not rate limited as is should be.
We fix this now.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/name_distr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index bda902caa814..8267b751a526 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -313,7 +313,7 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 		pr_warn_ratelimited("Failed to remove binding %u,%u from %u\n",
 				    ua.sr.type, ua.sr.lower, node);
 	} else {
-		pr_warn("Unrecognized name table message received\n");
+		pr_warn_ratelimited("Unknown name table message received\n");
 	}
 	return false;
 }
-- 
2.31.1

