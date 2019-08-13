Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67968B4F5
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfHMKFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:05:17 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:32983 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbfHMKFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:05:17 -0400
Received: by mail-yw1-f66.google.com with SMTP id e65so2285362ywh.0;
        Tue, 13 Aug 2019 03:05:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QOJLmQUkpsoGCMPbck1Kq5bC18tcOyqr58P4itm/OgA=;
        b=ocWi80EaZD05lrd9gO5lQuxHjbRbh227mPFFH0rzjW/zmCwX9CaOo85ffTMO24cH5V
         SZmLHcgrgOthsyNbzC7ODH4046TeCov+qZlfpnLLrKRH5E5fH0lM8TSZpc+APubjev6q
         HJNfDBgKvU92O2Otdm6x9O8NwOP2HntM86Q3Qc7U33/dj/MnKWxNoDK98Eo7xnHMErCg
         L+qgL7+K0MOHNTZKlyOg11+ZTtobz3CKUasdTCjEmAciKM89DRQcRHMJfGDi42WXJOB2
         Mnd1vrl3eWk1017o9rJ4pljIhfDYWQ0HtdtpvOhfY9YCcqS6yR/zz9datloHF/T5HmzQ
         YwUg==
X-Gm-Message-State: APjAAAU1nBSJ/euIvCxHgCno0RslDje3K66EOBbfBv9j3Q5IddOx7hhW
        v8j5aD8EgB0mkriLd3BIEu0=
X-Google-Smtp-Source: APXvYqwwuwtTOn9hZoDhBXnvqPqw+Qi6eA4c2mCw0sHcWfGmgnNmMD6+s+pZGJspZoJCEr12sJ53CA==
X-Received: by 2002:a81:5c45:: with SMTP id q66mr13607307ywb.101.1565690715738;
        Tue, 13 Aug 2019 03:05:15 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id w206sm1485314ywc.51.2019.08.13.03.05.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 03:05:14 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com (supporter:QLOGIC QL4xxx ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:QLOGIC QL4xxx ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] qed: Add cleanup in qed_slowpath_start()
Date:   Tue, 13 Aug 2019 05:05:09 -0500
Message-Id: <1565690709-3186-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
memory leaks. To fix this issue, redirect the execution to the label 'err3'
before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 829dd60..d16a251 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1325,7 +1325,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 					      &drv_version);
 		if (rc) {
 			DP_NOTICE(cdev, "Failed sending drv version command\n");
-			return rc;
+			goto err3;
 		}
 	}
 
-- 
2.7.4

