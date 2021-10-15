Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EEE42FE65
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbhJOWzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:55:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:46068 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243401AbhJOWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:55:40 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mbW4x-000Bek-7M; Sat, 16 Oct 2021 00:53:31 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 -next 1/4] Update kernel headers
Date:   Sat, 16 Oct 2021 00:53:16 +0200
Message-Id: <20211015225319.2284-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211015225319.2284-1-daniel@iogearbox.net>
References: <20211015225319.2284-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26323/Fri Oct 15 10:25:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to commits:

    2c611ad97a82 ("net, neigh: Extend neigh->flags to 32 bit to allow for extensions")
    7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/uapi/linux/neighbour.h | 35 +++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 00a60695..db05fb55 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -31,6 +31,7 @@ enum {
 	NDA_PROTOCOL,  /* Originator of entry */
 	NDA_NH_ID,
 	NDA_FDB_EXT_ATTRS,
+	NDA_FLAGS_EXT,
 	__NDA_MAX
 };
 
@@ -40,14 +41,16 @@ enum {
  *	Neighbor Cache Entry Flags
  */
 
-#define NTF_USE		0x01
-#define NTF_SELF	0x02
-#define NTF_MASTER	0x04
-#define NTF_PROXY	0x08	/* == ATF_PUBL */
-#define NTF_EXT_LEARNED	0x10
-#define NTF_OFFLOADED   0x20
-#define NTF_STICKY	0x40
-#define NTF_ROUTER	0x80
+#define NTF_USE		(1 << 0)
+#define NTF_SELF	(1 << 1)
+#define NTF_MASTER	(1 << 2)
+#define NTF_PROXY	(1 << 3)	/* == ATF_PUBL */
+#define NTF_EXT_LEARNED	(1 << 4)
+#define NTF_OFFLOADED   (1 << 5)
+#define NTF_STICKY	(1 << 6)
+#define NTF_ROUTER	(1 << 7)
+/* Extended flags under NDA_FLAGS_EXT: */
+#define NTF_EXT_MANAGED	(1 << 0)
 
 /*
  *	Neighbor Cache Entry States.
@@ -65,12 +68,22 @@ enum {
 #define NUD_PERMANENT	0x80
 #define NUD_NONE	0x00
 
-/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
- * and make no address resolution or NUD.
- * NUD_PERMANENT also cannot be deleted by garbage collectors.
+/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change and make no
+ * address resolution or NUD.
+ *
+ * NUD_PERMANENT also cannot be deleted by garbage collectors. This holds true
+ * for dynamic entries with NTF_EXT_LEARNED flag as well. However, upon carrier
+ * down event, NUD_PERMANENT entries are not flushed whereas NTF_EXT_LEARNED
+ * flagged entries explicitly are (which is also consistent with the routing
+ * subsystem).
+ *
  * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
  * states don't make sense and thus are ignored. Such entries don't age and
  * can roam.
+ *
+ * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
+ * of a user space control plane, and automatically refreshed so that (if
+ * possible) they remain in NUD_REACHABLE state.
  */
 
 struct nda_cacheinfo {
-- 
2.27.0

