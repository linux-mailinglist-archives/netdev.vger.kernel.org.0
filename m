Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFC3BC483
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504095AbfIXJJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:09:44 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:49451 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504086AbfIXJJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:09:44 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id dc158a12;
        Tue, 24 Sep 2019 08:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=u6Qv1urxbVN4KEZOHZSn+suLjNY=; b=D1W13TV9yrrZcXg5+xUO
        TLD65mmdS+8GAmgtxbY2A3svs4a1lbwwbqqbTb+SluV7MLQF+PQTT9hyY2BI7ua3
        3SZ9r9FNPo86bpuI9/hbAvOdjAVVrYRfQMTFc2gQfodNHMyJGNRERb7ylDkY69A3
        ghtvyBZyzaEyGBlkiuOL3QNqQIlbyaTAXKd0LA/bYuwG9UrBXkRQnw4riMTcfPOt
        wQtdTDKKyuWprgOLfrFQSlD/Lk43LoBPpYK8mPkfWDLXDt7nfPSj3lGOXR939n48
        bf2xpTAU5F6BYTH+nrcNCRf9nHv0qUfAbrFLUaKp4///x9OvHmRwyREP+8LbBlPK
        +w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3b8a643f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Sep 2019 08:24:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] net: print proper warning on dst underflow
Date:   Tue, 24 Sep 2019 11:09:37 +0200
Message-Id: <20190924090937.13001-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proper warnings with stack traces make it much easier to figure out
what's doing the double free and create more meaningful bug reports from
users.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/core/dst.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 1325316d9eab..193af526e908 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -172,7 +172,7 @@ void dst_release(struct dst_entry *dst)
 		int newrefcnt;
 
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
-		if (unlikely(newrefcnt < 0))
+		if (WARN_ONCE(newrefcnt < 0, "dst_release underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt)
@@ -187,7 +187,7 @@ void dst_release_immediate(struct dst_entry *dst)
 		int newrefcnt;
 
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
-		if (unlikely(newrefcnt < 0))
+		if (WARN_ONCE(newrefcnt < 0, "dst_release_immediate underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt)
-- 
2.21.0

