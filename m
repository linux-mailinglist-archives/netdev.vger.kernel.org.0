Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE02F35DA1F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhDMIdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhDMIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:33:04 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2DCC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 01:32:35 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id h19-20020a9d64130000b02902875a567768so4412266otl.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 01:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AvECZa53nCTmZ8P8KCQXvNcjhUA24gG/hDPbreBFD6k=;
        b=ACzNYRZKPk3sp+bHns6+afIAw9r33ciF9WrH6UO7nX/LGcIgZGeMOc1YtRPyHHYXOc
         J7dx56snUjO7d4nsHb1xap92RRRNn2iNqPn66x2BiHWlRV0pYonB1lomdc271qHEiFLO
         l05bBeq+xFZIH1JgwuZ6mHIoo8KmDq4t2bPPYs1vmRQ4apDZVjXNC3eLBCZaaYyRk6FB
         /F2VsrJ3pO1LqlZyZs6iBgU8zyqzyap/58G61m1f+dRvdyDZBlrPQf+bspgoGrJ5jNW1
         PABYwYSkG23DKr768sPJOgI7ZShX78Mho6GvrZKq8/462wlDfBsKlwYFgzY32T8k8rl8
         4YSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AvECZa53nCTmZ8P8KCQXvNcjhUA24gG/hDPbreBFD6k=;
        b=RH+O17gmy11SzoFDkzVfwddzyvv1L7+HCrtxaUElmJKunbxZdtH0611y8s+OFz08Sd
         iupYGf35qcMxA1LL+tRQwwNmyZeTTtOGSe43OGvXYVbeAByrvE9imvOo3GrqMeCcSoY5
         IJFu6tMsLfrYjEAAx2dBJeIPMZi8OGUMABjQrUdOKE0eWd+LeygNfxTFDS0UmDbQBssW
         qYx/BOTEiJuXskHlHqZ4GpbNZLWM28yl8OFvzsjIadIVaEVxYvtjwaCaD7T9AYKIBM/L
         goisiLruN/gQBIpiklCYoYsJ5YPZJaL2tCuU+wQWSMaFkWMKV4ZG6X6iMFhb+wb6RimR
         I+9w==
X-Gm-Message-State: AOAM5304PtRmCwsIEgPub8mQzqtNfq2qSRrR9+xiu9xl2q3sppd3JNZo
        5pkcow7D0PsFZ/3p4QrtCrSptL5VEG06vg==
X-Google-Smtp-Source: ABdhPJytWrop9zMyk+CSgiCyVHyOQZc/ZiB8VxfY9T33bfZwM9A/CjACg5ckXOAZD2c6uMMG7rALeA==
X-Received: by 2002:a9d:7ad1:: with SMTP id m17mr1296841otn.254.1618302754847;
        Tue, 13 Apr 2021 01:32:34 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:f46a:46e6:5a15:5a2c])
        by smtp.gmail.com with ESMTPSA id l15sm2774136otp.4.2021.04.13.01.32.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 01:32:34 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Nathan Lynch <nathanl@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: queue reset work in system_long_wq
Date:   Tue, 13 Apr 2021 03:32:33 -0500
Message-Id: <20210413083233.10479-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the linux system is under stress or the VIOS server is
responding slowly, the vnic driver may hit multiple timeouts during the
reset process. Instead of queueing the reset requests to system_wq,
queueing the relatively slow reset job to the system_long_wq.

Suggested-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3773dc97e63d..bbe45063b443 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2243,8 +2243,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
 
 	if (test_and_set_bit_lock(0, &adapter->resetting)) {
-		schedule_delayed_work(&adapter->ibmvnic_delayed_reset,
-				      IBMVNIC_RESET_DELAY);
+		queue_delayed_work(system_long_wq,
+				   &adapter->ibmvnic_delayed_reset,
+				   IBMVNIC_RESET_DELAY);
 		return;
 	}
 
@@ -2386,7 +2387,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
-	schedule_work(&adapter->ibmvnic_reset);
+	queue_work(system_long_wq, &adapter->ibmvnic_reset);
 
 	ret = 0;
 err:
-- 
2.23.0

