Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE56A1463
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBXAmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBXAmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:42:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3097C54A29
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677199326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FPDNUMkwoEyP5rrkyeMnVwjHw7OiPQ0FVaZBik5vcH0=;
        b=aPnPHt2vd4kxlrVe5XXBYVEWv4A7NsUytW6WpBcj5kDnldsOEZCBlVGDdhuf6RXCNN+GH6
        YPzFjKVlVsnVJEIBGr4MustLIsyWuX8nYLtHdeO+ElBwVkPGsPVQ9boGc6Qhy6yHoBJsvQ
        tQeAg413suobqRDtNmBLnm9dGQIgz04=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-YwA3xkAqP7WRynmB_mQ3LQ-1; Thu, 23 Feb 2023 19:42:03 -0500
X-MC-Unique: YwA3xkAqP7WRynmB_mQ3LQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EE8A85A5A3;
        Fri, 24 Feb 2023 00:42:02 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-2.brq.redhat.com [10.40.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 941802166B2C;
        Fri, 24 Feb 2023 00:42:01 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: [PATCH net] qede: avoid uninitialized entries in coal_entry array
Date:   Fri, 24 Feb 2023 01:41:45 +0100
Message-Id: <20230224004145.91709-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even after commit 908d4bb7c54c ("qede: fix interrupt coalescing
configuration"), some entries of the coal_entry array may theoretically
be used uninitialized:

 1. qede_alloc_fp_array() allocates QEDE_MAX_RSS_CNT entries for
    coal_entry. The initial allocation uses kcalloc, so everything is
    initialized.
 2. The user sets a small number of queues (ethtool -L).
    coal_entry is reallocated for the actual small number of queues.
 3. The user sets a bigger number of queues.
    coal_entry is reallocated bigger. The added entries are not
    necessarily initialized.

In practice, the reallocations will actually keep using the originally
allocated region of memory, but we should not rely on it.

The reallocation is unnecessary. coal_entry can always have
QEDE_MAX_RSS_CNT entries.

Fixes: 908d4bb7c54c ("qede: fix interrupt coalescing configuration")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 21 +++++++-------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 4a3c3b5fb4a1..261f982ca40d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -963,7 +963,6 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 {
 	u8 fp_combined, fp_rx = edev->fp_num_rx;
 	struct qede_fastpath *fp;
-	void *mem;
 	int i;
 
 	edev->fp_array = kcalloc(QEDE_QUEUE_CNT(edev),
@@ -974,20 +973,14 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 	}
 
 	if (!edev->coal_entry) {
-		mem = kcalloc(QEDE_MAX_RSS_CNT(edev),
-			      sizeof(*edev->coal_entry), GFP_KERNEL);
-	} else {
-		mem = krealloc(edev->coal_entry,
-			       QEDE_QUEUE_CNT(edev) * sizeof(*edev->coal_entry),
-			       GFP_KERNEL);
-	}
-
-	if (!mem) {
-		DP_ERR(edev, "coalesce entry allocation failed\n");
-		kfree(edev->coal_entry);
-		goto err;
+		edev->coal_entry = kcalloc(QEDE_MAX_RSS_CNT(edev),
+					   sizeof(*edev->coal_entry),
+					   GFP_KERNEL);
+		if (!edev->coal_entry) {
+			DP_ERR(edev, "coalesce entry allocation failed\n");
+			goto err;
+		}
 	}
-	edev->coal_entry = mem;
 
 	fp_combined = QEDE_QUEUE_CNT(edev) - fp_rx - edev->fp_num_tx;
 
-- 
2.39.1

