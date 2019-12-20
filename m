Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB01127BB4
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTNb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:31:56 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:49572 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfLTNby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:31:54 -0500
Received: from ramsan ([84.195.182.253])
        by andre.telenet-ops.be with bizsmtp
        id gDXr210055USYZQ01DXryR; Fri, 20 Dec 2019 14:31:51 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iiINj-0007le-3n; Fri, 20 Dec 2019 14:31:51 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iiINj-0001UY-29; Fri, 20 Dec 2019 14:31:51 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] net: dst: Force 4-byte alignment of dst_metrics
Date:   Fri, 20 Dec 2019 14:31:40 +0100
Message-Id: <20191220133140.5684-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When storing a pointer to a dst_metrics structure in dst_entry._metrics,
two flags are added in the least significant bits of the pointer value.
Hence this assumes all pointers to dst_metrics structures have at least
4-byte alignment.

However, on m68k, the minimum alignment of 32-bit values is 2 bytes, not
4 bytes.  Hence in some kernel builds, dst_default_metrics may be only
2-byte aligned, leading to obscure boot warnings like:

    WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x44/0x9a
    refcount_t: underflow; use-after-free.
    Modules linked in:
    CPU: 0 PID: 7 Comm: ksoftirqd/0 Tainted: G        W         5.5.0-rc2-atari-01448-g114a1a1038af891d-dirty #261
    Stack from 10835e6c:
	    10835e6c 0038134f 00023fa6 00394b0f 0000001c 00000009 00321560 00023fea
	    00394b0f 0000001c 001a70f8 00000009 00000000 10835eb4 00000001 00000000
	    04208040 0000000a 00394b4a 10835ed4 00043aa8 001a70f8 00394b0f 0000001c
	    00000009 00394b4a 0026aba8 003215a4 00000003 00000000 0026d5a8 00000001
	    003215a4 003a4361 003238d6 000001f0 00000000 003215a4 10aa3b00 00025e84
	    003ddb00 10834000 002416a8 10aa3b00 00000000 00000080 000aa038 0004854a
    Call Trace: [<00023fa6>] __warn+0xb2/0xb4
     [<00023fea>] warn_slowpath_fmt+0x42/0x64
     [<001a70f8>] refcount_warn_saturate+0x44/0x9a
     [<00043aa8>] printk+0x0/0x18
     [<001a70f8>] refcount_warn_saturate+0x44/0x9a
     [<0026aba8>] refcount_sub_and_test.constprop.73+0x38/0x3e
     [<0026d5a8>] ipv4_dst_destroy+0x5e/0x7e
     [<00025e84>] __local_bh_enable_ip+0x0/0x8e
     [<002416a8>] dst_destroy+0x40/0xae

Fix this by forcing 4-byte alignment of all dst_metrics structures.

Fixes: e5fd387ad5b30ca3 ("ipv6: do not overwrite inetpeer metrics prematurely")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/net/dst.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index fe62fe2eb781c122..8224dad2ae9460fb 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -82,7 +82,7 @@ struct dst_entry {
 struct dst_metrics {
 	u32		metrics[RTAX_MAX];
 	refcount_t	refcnt;
-};
+} __aligned(4);		/* Low pointer bits contain DST_METRICS_FLAGS */
 extern const struct dst_metrics dst_default_metrics;
 
 u32 *dst_cow_metrics_generic(struct dst_entry *dst, unsigned long old);
-- 
2.17.1

