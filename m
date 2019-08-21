Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 722CF9713F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfHUErR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:47:17 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34961 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfHUErR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 00:47:17 -0400
Received: by mail-yw1-f67.google.com with SMTP id g19so435565ywe.2;
        Tue, 20 Aug 2019 21:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kxL2K/UgIPrq03eGU3MZLRfsEiG5CCTnJCgH/oJDhFQ=;
        b=hhSGYpEJi+fiIGwrIaKkNzWWSizjKMr2UeKUOcLutfM75oV6pwzT4eDTtvPho4lzmZ
         +UeK/UldFAYQyJtzyK/RtffGUtaKn9nOT51ZSOcl2Co7UH5p2ILMg0xVZAzB4is+g+Gk
         ckfqYr0BvXGYh5rW7aVL14ePfxj+jvL2PGgllbBEtfS0+AFvhyyIL97YQo/LT2jqEymK
         7CzinFv5R0ISb3YJI1WTxfINq2xSDUGoL07lN9KlZlzzR5kdqwDJ/d2/AXj180mcBXDm
         czCSMdTirCNE5TY9keTcO72qDRa3+qICY2ijAPpK+c95bIAd7/aOOpnO2lJx0Zb29zWC
         81bA==
X-Gm-Message-State: APjAAAVXko7GeOT0Hcmoxtfn+gcRe725sDESX6qjkISgEAJO1vtkciqy
        SYcVtNwYdreCsM+7Q4howU0=
X-Google-Smtp-Source: APXvYqxmg12NdhtkerPB0YQdRJSxn1rHVls2t3HnfjSQ+zntUJ9k0lZ1UUqMM/Aae2kTW6Ia1+SNdw==
X-Received: by 2002:a0d:dd51:: with SMTP id g78mr21950930ywe.102.1566362835944;
        Tue, 20 Aug 2019 21:47:15 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id r193sm2670175ywe.8.2019.08.20.21.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 20 Aug 2019 21:47:14 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com (supporter:QLOGIC QL4xxx ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:QLOGIC QL4xxx ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] qed: Add cleanup in qed_slowpath_start()
Date:   Tue, 20 Aug 2019 23:46:36 -0500
Message-Id: <1566362796-5399-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
memory leaks. To fix this issue, introduce the label 'err4' to perform the
cleanup work before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 829dd60..1efff7f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1325,7 +1325,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 					      &drv_version);
 		if (rc) {
 			DP_NOTICE(cdev, "Failed sending drv version command\n");
-			return rc;
+			goto err4;
 		}
 	}
 
@@ -1333,6 +1333,8 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 
 	return 0;
 
+err4:
+	qed_ll2_dealloc_if(cdev);
 err3:
 	qed_hw_stop(cdev);
 err2:
-- 
2.7.4

