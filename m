Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911F037914A
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEJOuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:50:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:24987 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237421AbhEJOuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 10:50:09 -0400
IronPort-SDR: 5YwaJhHbFv73psr9IN1hx8xBebqJWd4DCsyCEoomqZ/z45WxfxtAXLpc32t7vJpxdKTVmR+QIo
 qlSPehLoBMLw==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="220158945"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="220158945"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 07:49:02 -0700
IronPort-SDR: 8QJvrU7G1vrVyVT3yrK6qDyeFtyciiSENAwJ0i/5OVYk1od0G0NuITOXCl35PAcgDfVd1tBoYD
 ovlne4mQ1kjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="541242183"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2021 07:49:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5A94E12A; Mon, 10 May 2021 17:49:20 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Chas Williams <3chas3@gmail.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v1 1/1] atm: Replace custom isprint() with generic analogue
Date:   Mon, 10 May 2021 17:49:09 +0300
Message-Id: <20210510144909.58123-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Custom isprint() definition may collide with one form ctype.h.
In order to avoid this, replace it with a functional analogue
which is isascii() && isprint() in this case.

First appearance of the code is in the commit 636b38438001
("Import 2.3.43").

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/atm/iphase.c | 11 +++++++----
 drivers/atm/iphase.h |  1 -
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 933e3ff2ee8d..e3f5d073caa6 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -47,6 +47,7 @@
 #include <linux/errno.h>  
 #include <linux/atm.h>  
 #include <linux/atmdev.h>  
+#include <linux/ctype.h>
 #include <linux/sonet.h>  
 #include <linux/skbuff.h>  
 #include <linux/time.h>  
@@ -996,10 +997,12 @@ static void xdump( u_char*  cp, int  length, char*  prefix )
         }
         pBuf += sprintf( pBuf, "  " );
         for(col = 0;count + col < length && col < 16; col++){
-            if (isprint((int)cp[count + col]))
-                pBuf += sprintf( pBuf, "%c", cp[count + col] );
-            else
-                pBuf += sprintf( pBuf, "." );
+		u_char c = cp[count + col];
+
+		if (isascii(c) && isprint(c))
+			pBuf += sprintf(pBuf, "%c", c);
+		else
+			pBuf += sprintf(pBuf, ".");
                 }
         printk("%s\n", prntBuf);
         count += col;
diff --git a/drivers/atm/iphase.h b/drivers/atm/iphase.h
index 2beacf2fc1ec..2f5f8875cbd1 100644
--- a/drivers/atm/iphase.h
+++ b/drivers/atm/iphase.h
@@ -124,7 +124,6 @@
 #define IF_RXPKT(A)
 #endif /* CONFIG_ATM_IA_DEBUG */ 
 
-#define isprint(a) ((a >=' ')&&(a <= '~'))  
 #define ATM_DESC(skb) (skb->protocol)
 #define IA_SKB_STATE(skb) (skb->protocol)
 #define IA_DLED   1
-- 
2.30.2

