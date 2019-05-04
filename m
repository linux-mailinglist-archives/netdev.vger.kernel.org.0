Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1288B13719
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEDDIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:08:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45948 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDDIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:08:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id o5so3586334pls.12;
        Fri, 03 May 2019 20:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HV0vFa1AQBzqqBWnhIe30OQkz8e00N5qYuPLeAvDLl8=;
        b=NHaEZsp9dkqALsfpr2wxPTSVYfQkyhvXfor+kgiCuW5I66x6jne+apYtEDRbeUNZnP
         DS0ewBuhEdgryPsd9Hq5ql6E8zEgOwaaeqA1sleexQWXTGQfgU3OxyJ85CFrF24qSjWG
         4YbR2FDLVP65vMd4ACXwWlvf8a6L79h/C3+p5XAGyxIncQiAGOXRt3IrJqRZ6mNgh0pj
         RywZv1VX47mRU0az7CTGyhmWvND3XBL3DrxYWe/ujjRUoOb01ZQjki10on2yOuVDSrjG
         ATOc7R/WYjEOvOaLNw0uNcbwmggYNAIE0XxQ3iRI4wVHdZ6heI+36/+1aeaUi3u0DK5X
         rkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HV0vFa1AQBzqqBWnhIe30OQkz8e00N5qYuPLeAvDLl8=;
        b=A2sAv605K0arl/RBCYz/1oKD5CSN459JrviV3O7il1dUneW1q/KWKqPs5zazKcglVW
         rx5EVwokgUzpLDCSoeRsKDLFsC2As0rYox6ZGt0t6NpmWJ2G04v8iveUgi7Huo5QNPzZ
         Gqpd4Ilyl0KkIdNmE3CQIzRupqntwHe690Dswk4W7Plpd7ZuFA+znFUDtaXp6HgkXmbr
         q3p40DMtm1anqo/hYGAwdqAW6wlBxcoxiQ76nkB7i4uUKrWfbmzafE+SvTMQ5h3rLgSw
         1JrUrBxuUe0RjrQvo7hS9lyyqE982R/xhMZVcPzMyOWqarPZyACGF+cusmfXVtw6p6ep
         /I7w==
X-Gm-Message-State: APjAAAVp0kdHfxsPCt8/VqgtTI47EsO+S9CmEhEwtxOl38bOJ8M9hSPC
        N+kf8RwlPs8UHbPuq+Uif9xcX3mT
X-Google-Smtp-Source: APXvYqyWTUUC5GhIaTfqz9ZEtHsf86I7ucmspTp/R7g1Ot87/LFL3+a3zUzT9AMg4Sj8gM9wDzf6Tw==
X-Received: by 2002:a17:902:900a:: with SMTP id a10mr15397562plp.336.1556939300552;
        Fri, 03 May 2019 20:08:20 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id b144sm5755529pfb.68.2019.05.03.20.08.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 20:08:19 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: via-rhine: net: Fix a resource leak in rhine_init()
Date:   Sat,  4 May 2019 11:08:13 +0800
Message-Id: <20190504030813.17684-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When platform_driver_register() fails, pci_unregister_driver() is not
called to release the resource allocated by pci_register_driver().

To fix this bug, error handling code for platform_driver_register() and
pci_register_driver() is separately implemented.

This bug is found by a runtime fuzzing tool named FIZZER written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/via/via-rhine.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 33949248c829..eb74e5a03aac 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2633,10 +2633,15 @@ static int __init rhine_init(void)
 		pr_info("avoid_D3 set\n");
 
 	ret_pci = pci_register_driver(&rhine_driver_pci);
-	ret_platform = platform_driver_register(&rhine_driver_platform);
-	if ((ret_pci < 0) && (ret_platform < 0))
+	if (ret_pci)
 		return ret_pci;
 
+	ret_platform = platform_driver_register(&rhine_driver_platform);
+	if (ret_platform) {
+		pci_unregister_driver(&rhine_driver_pci);
+		return ret_platform;
+	}
+
 	return 0;
 }
 
-- 
2.17.0

