Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6927235E71F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbhDMTeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhDMTeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:34:02 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CBCC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 12:33:42 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso3082141otm.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 12:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l/O/VR4bB4Yf40ev7F99+fYica4D8zABTRv5mqubPFQ=;
        b=U7jq1y4naytpOGJYLAK4f0lO3OB1O+ovCXf9FBLNaBJU1kuSduuSQIO9vL3iI0NsdF
         mXAnfQ52fTEK4aevp9bSArrTdV0wLBFPYjgYJNnEO8DbsvTKzjxdGSWylR63P+Tr5+ev
         vb9NQggr0oUEUQJKiS9bhLa/bjVB8oMteRmbyQdBCRdUF8HgDMHtIc1+Ve1zID1tqczB
         y+YS/Z2jmpjT0LaKPtxv7J/6fIGo2hsCz8Sc91bD5ziQuasHGdzO10x0kNp2ZXdX9M3u
         Q/OFeRIHdqr+s5xftjWx50l9OzGQwJnnmmgzSdTFUxuL7J3/JLCC58DsW8Q4gK1whKZg
         i8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l/O/VR4bB4Yf40ev7F99+fYica4D8zABTRv5mqubPFQ=;
        b=DIe9MpWAlaldCGNmOJAAtru6sQppEdiXlV3aDjPboUjA1mnYeL+GfoJEltXoTnniPo
         hfe6YdfXRGHK5NtH26ufAH/yMJej63l8KY8PlC6/mau+GJnaG5MbS/KNgZkSE50jUvcW
         9Rn8VClOoVXuQ/YiEkHbC0CPIY96BpiKtYCH3C8eXHucE0z5eMJZWwM+BpZCz8pMxuvJ
         N3kUasrsOe6wndo8z5vHvbEasGidfqTk3oD0Ih3mNItgE6fGh5oezdBzknHQ/x8oHXXY
         xrgtsf7QTwET56diZPyaHCi+cE+/X+4JCLyPIVS2UEI9+QDFu6tF2TFDVuWxq/lhnSaR
         wucQ==
X-Gm-Message-State: AOAM530mYyBBSdBNIyUvNc/rFoECjy1AiN/Z0wpya4cl1eWGqnOxBKqo
        8b4juOwbNwUWwBbyyx+QiVrd6lidhU6PQw==
X-Google-Smtp-Source: ABdhPJxEK2C63z2FoiKq+vL2gVYOEAPyKxKbyWagZA7H7prAYfmZS/a+NR7GzNVkmotZdQ3cg3YrZw==
X-Received: by 2002:a9d:30c6:: with SMTP id r6mr14260617otg.270.1618342421898;
        Tue, 13 Apr 2021 12:33:41 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:f46a:46e6:5a15:5a2c])
        by smtp.gmail.com with ESMTPSA id x127sm3055299oix.36.2021.04.13.12.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 12:33:41 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Nathan Lynch <nathanl@linux.ibm.com>
Subject: [PATCH net-next v2] ibmvnic: queue reset work in system_long_wq
Date:   Tue, 13 Apr 2021 14:33:39 -0500
Message-Id: <20210413193339.11050-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset process for ibmvnic commonly takes multiple seconds, clearly
making it inappropriate for schedule_work/system_wq. The reason to make
this change is that ibmvnic's use of the default system-wide workqueue
for a relatively long-running work item can negatively affect other
workqueue users. So, queue the relatively slow reset job to the
system_long_wq.

Suggested-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
v2: reword the commit message to justify why we do this.

 drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0961d36833d5..b72159ccca3a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2292,8 +2292,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
 
 	if (test_and_set_bit_lock(0, &adapter->resetting)) {
-		schedule_delayed_work(&adapter->ibmvnic_delayed_reset,
-				      IBMVNIC_RESET_DELAY);
+		queue_delayed_work(system_long_wq,
+				   &adapter->ibmvnic_delayed_reset,
+				   IBMVNIC_RESET_DELAY);
 		return;
 	}
 
@@ -2437,7 +2438,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %s)\n",
 		   reset_reason_to_string(reason));
-	schedule_work(&adapter->ibmvnic_reset);
+	queue_work(system_long_wq, &adapter->ibmvnic_reset);
 
 	ret = 0;
 err:
-- 
2.23.0

