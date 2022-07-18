Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB58B577E06
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiGRIzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGRIzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:55:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A871DEFA
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 01:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658134543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OQDVyOC0X7PxpuAIr9ce/C6D+7/MPMftlFD0AEJPONQ=;
        b=YWBZn9ljbCgmqnFjd0Ozo8+P0NRMPmoXQ1hnfGJBQG8h6IPyw4zAU2V6QbgcPNdOSRvBKR
        mjHl2WhJJPLwYsxdE1wwPX6BvptHh8edqNOCm21he9yvb9rh92G7tmK0xB8eSuZztP68zS
        lfPjmYz2YOFBpwSVTRE9cFR1wUjCeEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-2iu1fRLTP2qj6wBz3UR9gA-1; Mon, 18 Jul 2022 04:55:27 -0400
X-MC-Unique: 2iu1fRLTP2qj6wBz3UR9gA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0519285A584;
        Mon, 18 Jul 2022 08:55:27 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.192.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01FE740CF8E7;
        Mon, 18 Jul 2022 08:55:25 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net/sched: remove qdisc_root_lock() helper
Date:   Mon, 18 Jul 2022 10:55:12 +0200
Message-Id: <703d549e3088367651d92a059743f1be848d74b7.1658133689.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the last caller has been removed with commit 96f5e66e8a79 ("mac80211: fix
aggregation for hardware with ampdu queues"), so it's safe to remove this
function.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/sch_generic.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d6cf5116b5f9..ec693fe7c553 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -551,25 +551,6 @@ static inline struct Qdisc *qdisc_root_sleeping(const struct Qdisc *qdisc)
 	return qdisc->dev_queue->qdisc_sleeping;
 }
 
-/* The qdisc root lock is a mechanism by which to top level
- * of a qdisc tree can be locked from any qdisc node in the
- * forest.  This allows changing the configuration of some
- * aspect of the qdisc tree while blocking out asynchronous
- * qdisc access in the packet processing paths.
- *
- * It is only legal to do this when the root will not change
- * on us.  Otherwise we'll potentially lock the wrong qdisc
- * root.  This is enforced by holding the RTNL semaphore, which
- * all users of this lock accessor must do.
- */
-static inline spinlock_t *qdisc_root_lock(const struct Qdisc *qdisc)
-{
-	struct Qdisc *root = qdisc_root(qdisc);
-
-	ASSERT_RTNL();
-	return qdisc_lock(root);
-}
-
 static inline spinlock_t *qdisc_root_sleeping_lock(const struct Qdisc *qdisc)
 {
 	struct Qdisc *root = qdisc_root_sleeping(qdisc);
-- 
2.35.3

