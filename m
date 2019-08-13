Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C922C8B3F6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 11:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfHMJTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 05:19:02 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39429 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfHMJTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 05:19:02 -0400
Received: by mail-yb1-f193.google.com with SMTP id s142so9802871ybc.6;
        Tue, 13 Aug 2019 02:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kUBanlA+OewYHu2v1NZSgckcWYzqv9IZZgRNtPfde/g=;
        b=d+Zq0j1xk01kcL7JLQQuf0rcJykzM1Q2WReVxSSIHTiaLwmA69IiDa4OBVM5trnh2D
         hf0kPgOyIGaKv3sWT/Zp4Q+/A4Z+peAcFUd47w3k24QFrxmf/syBkDBlGueCzXXJYpgm
         dtFVneZatUc0O9hTLSQmYHiDdkrUdX3tSlJ6U0ef9J5qDJq68YEjTS2WTDUx/FciHtMm
         B57umdMpZJxLssyFzWP8cx9zxcTfkwZIrrAIMeDL+a8ZcrlcYMzeJU1WFPxC+dZKK4hL
         PnkjAKoSCeItbQ0VJZ4PsD7J8f3/aE5JZCYPfs0uPwvC/VK/3bR1mGbWPDbduWJgFYR6
         5cwA==
X-Gm-Message-State: APjAAAVpLKnBOgYmxjsAGLdAZUt9VIh/lFym6j8eu+a9P7bdi6yXEEz7
        cztX7St53spLXDzHfDPiX2Y=
X-Google-Smtp-Source: APXvYqyoHIMWWV/Nk16YmgaFnSRnrejnpcOOOW4NSBuQgxkJI14N5BkT7qkjQjzx+L8npD+m4oT1oQ==
X-Received: by 2002:a5b:d52:: with SMTP id f18mr9448758ybr.516.1565687941169;
        Tue, 13 Aug 2019 02:19:01 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id r19sm27423518ywa.109.2019.08.13.02.18.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 02:18:59 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] cxgb4: fix a memory leak bug
Date:   Tue, 13 Aug 2019 04:18:52 -0500
Message-Id: <1565687932-2870-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In blocked_fl_write(), 't' is not deallocated if bitmap_parse_user() fails,
leading to a memory leak bug. To fix this issue, free t before returning
the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 0295903..d692251 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3236,8 +3236,10 @@ static ssize_t blocked_fl_write(struct file *filp, const char __user *ubuf,
 		return -ENOMEM;
 
 	err = bitmap_parse_user(ubuf, count, t, adap->sge.egr_sz);
-	if (err)
+	if (err) {
+		kvfree(t);
 		return err;
+	}
 
 	bitmap_copy(adap->sge.blocked_fl, t, adap->sge.egr_sz);
 	kvfree(t);
-- 
2.7.4

