Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423DEB944B
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404086AbfITPmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:42:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393522AbfITPmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 11:42:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A06D10DCC82;
        Fri, 20 Sep 2019 15:42:23 +0000 (UTC)
Received: from asgard.redhat.com (ovpn-112-68.ams2.redhat.com [10.36.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 099DC19C5B;
        Fri, 20 Sep 2019 15:42:21 +0000 (UTC)
Date:   Fri, 20 Sep 2019 17:42:00 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net v2 3/3] uapi, net/smc: provide socket state constants in
 UAPI
Message-ID: <2be8f9cfd2e031a9217326ea89227e0517248f0f.1568993930.git.esyr@redhat.com>
References: <cover.1568993930.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1568993930.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Fri, 20 Sep 2019 15:42:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As socket state itself is already exposed via sock_diag interface.

Fixes: ac7138746e14 ("smc: establish new socket family")
Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 include/uapi/linux/smc_diag.h | 17 +++++++++++++++++
 net/smc/smc.h                 | 18 +-----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 8cb3a6f..6798ec0 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -31,6 +31,23 @@ struct smc_diag_msg {
 	__aligned_u64	diag_inode;
 };
 
+enum smc_state {		/* possible states of an SMC socket */
+	SMC_ACTIVE	= 1,
+	SMC_INIT	= 2,
+	SMC_CLOSED	= 7,
+	SMC_LISTEN	= 10,
+	/* normal close */
+	SMC_PEERCLOSEWAIT1	= 20,
+	SMC_PEERCLOSEWAIT2	= 21,
+	SMC_APPFINCLOSEWAIT	= 24,
+	SMC_APPCLOSEWAIT1	= 22,
+	SMC_APPCLOSEWAIT2	= 23,
+	SMC_PEERFINCLOSEWAIT	= 25,
+	/* abnormal close */
+	SMC_PEERABORTWAIT	= 26,
+	SMC_PROCESSABORT	= 27,
+};
+
 /* Mode of a connection */
 enum {
 	SMC_DIAG_MODE_SMCR,
diff --git a/net/smc/smc.h b/net/smc/smc.h
index e60effc..7eaef72 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h> /* __aligned */
 #include <net/sock.h>
 #include <linux/smc.h>
+#include <linux/smc_diag.h>
 
 #include "smc_ib.h"
 
@@ -26,23 +27,6 @@ extern struct proto smc_proto6;
 #define KERNEL_HAS_ATOMIC64
 #endif
 
-enum smc_state {		/* possible states of an SMC socket */
-	SMC_ACTIVE	= 1,
-	SMC_INIT	= 2,
-	SMC_CLOSED	= 7,
-	SMC_LISTEN	= 10,
-	/* normal close */
-	SMC_PEERCLOSEWAIT1	= 20,
-	SMC_PEERCLOSEWAIT2	= 21,
-	SMC_APPFINCLOSEWAIT	= 24,
-	SMC_APPCLOSEWAIT1	= 22,
-	SMC_APPCLOSEWAIT2	= 23,
-	SMC_PEERFINCLOSEWAIT	= 25,
-	/* abnormal close */
-	SMC_PEERABORTWAIT	= 26,
-	SMC_PROCESSABORT	= 27,
-};
-
 struct smc_link_group;
 
 struct smc_wr_rx_hdr {	/* common prefix part of LLC and CDC to demultiplex */
-- 
2.1.4

