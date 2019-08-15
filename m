Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833738F2C1
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbfHOSFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:05:09 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:41783 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729736AbfHOSFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:05:09 -0400
Received: by mail-yb1-f196.google.com with SMTP id n7so1104876ybd.8;
        Thu, 15 Aug 2019 11:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+7ik1RvxnhAES3NBX5CO26tA3ZEBBHVVi3bXNL+10EQ=;
        b=WyAGvjil3rCmLR0WeJIzoS5cwWA7hEydGBlQUJlUZ47usGLvAUKbqxmmgufy07cl7e
         X9n+SbRn/opzmbXSmfIRooVd5YFEtWQQj3ctXpOIU2OIxJ26AJLYxonqkmmTYL76AHdN
         4XKT4mIs8ZA2ifn+wdnR2tK3exU5pzbdLKipgM6u5KQANa4GwnHEWYZX0AnZpOpyYjJi
         d31tYmGsHIFV3ol/wbV+q6tNJ5WWtRUoZbHpJemmWiuGbVopdP5ANorWy1MPdjjCdV9U
         JWfXGNscZmSHsPbtB3wwKFfbWqgr0rVyhu8fsii++PcUziW64MbGB6W7EzxfYCTC3Em+
         KVQA==
X-Gm-Message-State: APjAAAWwCmuHrVi9t+G5spTXXQ+8uWdnyEOTvC/ZNGclfZG0WeNjUPE+
        wCtBf7C3c6kwcmBCJn4pWtk=
X-Google-Smtp-Source: APXvYqzjeg/tMSF/9JfD1evzrNm/IdG2loRQLts4Qfq74BWA3UBsM3cxG5PNeC3VMJZAoFoly/wVDg==
X-Received: by 2002:a5b:307:: with SMTP id j7mr4426281ybp.316.1565892308230;
        Thu, 15 Aug 2019 11:05:08 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id v68sm745113ywe.23.2019.08.15.11.05.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Aug 2019 11:05:07 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com (supporter:INTEL WIRELESS WIMAX CONNECTION 2400),
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] wimax/i2400m: fix a memory leak bug
Date:   Thu, 15 Aug 2019 13:05:01 -0500
Message-Id: <1565892301-2812-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
to hold the original command line options. Then, the options are parsed.
However, if an error occurs during the parsing process, 'options_orig' is
not deallocated, leading to a memory leak bug. To fix this issue, free
'options_orig' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/wimax/i2400m/fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index e9fc168..6b36f6d 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -342,6 +342,7 @@ int i2400m_barker_db_init(const char *_options)
 				       "a 32-bit number\n",
 				       __func__, token);
 				result = -EINVAL;
+				kfree(options_orig);
 				goto error_parse;
 			}
 			if (barker == 0) {
@@ -350,8 +351,10 @@ int i2400m_barker_db_init(const char *_options)
 				continue;
 			}
 			result = i2400m_barker_db_add(barker);
-			if (result < 0)
+			if (result < 0) {
+				kfree(options_orig);
 				goto error_add;
+			}
 		}
 		kfree(options_orig);
 	}
-- 
2.7.4

