Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953C42BC5C8
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgKVNUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 08:20:34 -0500
Received: from mx57.baidu.com ([61.135.168.57]:41196 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727567AbgKVNUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 08:20:34 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2020 08:20:33 EST
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id CD117236C003;
        Sun, 22 Nov 2020 21:10:19 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] libbpf: add support for canceling cached_cons advance
Date:   Sun, 22 Nov 2020 21:10:23 +0800
Message-Id: <1606050623-22963-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to fail receiving packets after calling
xsk_ring_cons__peek, at this condition, cached_cons has
been advanced, should be cancelled.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 tools/lib/bpf/xsk.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 1069c46364ff..4128215c246b 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
 	return entries;
 }
 
+static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
+					 size_t nb)
+{
+	rx->cached_cons -= nb;
+}
+
 static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
 {
 	/* Make sure data has been read before indicating we are done
-- 
2.17.3

