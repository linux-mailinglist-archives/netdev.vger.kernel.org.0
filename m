Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276E42C1EE7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgKXHbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:31:21 -0500
Received: from mx316.baidu.com ([180.101.52.236]:31885 "EHLO
        njjs-sys-mailin04.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729981AbgKXHbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:31:21 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 02:31:20 EST
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (unknown [10.168.61.89])
        by njjs-sys-mailin04.njjs.baidu.com (Postfix) with ESMTP id 4DC031180005C;
        Tue, 24 Nov 2020 15:21:14 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com
Subject: [PATCH][V2] libbpf: add support for canceling cached_cons advance
Date:   Tue, 24 Nov 2020 15:21:14 +0800
Message-Id: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new function for returning descriptors the user received
after an xsk_ring_cons__peek call. After the application has
gotten a number of descriptors from a ring, it might not be able
to or want to process them all for various reasons. Therefore,
it would be useful to have an interface for returning or
cancelling a number of them so that they are returned to the ring.

This patch adds a new function called xsk_ring_cons__cancel that
performs this operation on nb descriptors counted from the end of
the batch of descriptors that was received through the peek call.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
[ Magnus Karlsson: rewrote changelog ]
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
---
diff with v1: fix the building, and rewrote changelog

 tools/lib/bpf/xsk.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 1069c46364ff..1719a327e5f9 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
 	return entries;
 }
 
+static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
+					 size_t nb)
+{
+	cons->cached_cons -= nb;
+}
+
 static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
 {
 	/* Make sure data has been read before indicating we are done
-- 
2.17.3

