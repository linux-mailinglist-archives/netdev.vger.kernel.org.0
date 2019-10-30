Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6853EE977F
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfJ3IAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:00:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37549 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3H77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 03:59:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so946876pgi.4
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 00:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wAR6DL7kvNJa9zycRx+anT2MCxHiDXG/E0WRkd4FHO0=;
        b=L8sbUWnl6Kx5vMvOjS6zYIJF5mVgBERadjbm50197rcmFIfMCthTMioQRMXCjjc5ix
         0lIrqRfCyCsAWbnTnCnmnFLf7AbRQNa9NDsgGE7DLKOfdroRg7RvV57qve683oBEfb0z
         iBfb5jzeb+2SMYcQeMgdZt2vJOrrxSEwUuVQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wAR6DL7kvNJa9zycRx+anT2MCxHiDXG/E0WRkd4FHO0=;
        b=a2bJ8Z6ZLkC45wi727JysddGZw+kO+038uFAwR0lC9fbBFIYbdMYDKjadTEXImv3nc
         /YIGJQDZ/fqkd5zMDEzVh6H36hsWhFfD/7ri4Nzg3UiDLmdeL/TCZ3HPQhV+djr3D38s
         HN/o9M63l9Rw76FSG8kwPGoU3Up9rD/w2vqA6KfT64cquERww2hB5ir1Zk75E/yshqxe
         VcdJXDv/4UL1cJFtdVzIVWmsfhzus+SlWdeMj4Q0JewCE0RgiFpII/p9gkIm+i28l8FV
         sgOdChjy+vv2JwQJWQ1Zya9nJhG5w8kz2OeTHQt4wdZlJmOU25fMzy5LQ26gQ0+jqk1Y
         wnXw==
X-Gm-Message-State: APjAAAXFgVFoyCWld0glGkWivg8qXX2efJeWkb1+Y6+zNdLcI121Rk6D
        KllsV36XWSs6Ox/gzXp8j8//HA==
X-Google-Smtp-Source: APXvYqwv3J4Uam3fiJNt99IIgwaZvMZhoiIskrXOwkpu/Tq7XFqA19E5yTjXFOONdZzk3OYKje0TAA==
X-Received: by 2002:a65:6456:: with SMTP id s22mr31602014pgv.287.1572422399026;
        Wed, 30 Oct 2019 00:59:59 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r21sm1960649pfc.27.2019.10.30.00.59.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 00:59:58 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH net-next 2/7] bnxt: Avoid logging an unnecessary message when a flow can't be offloaded
Date:   Wed, 30 Oct 2019 03:59:30 -0400
Message-Id: <1572422375-7269-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
References: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

For every single case where bnxt_tc_can_offload() can fail, we are
logging a user friendly descriptive message anyway, but because of the
path it would take in case of failure, another redundant error message
would get logged. Just freeing the node and returning from the point of
failure should suffice.

Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 6734825..2d86796 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1405,7 +1405,8 @@ static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
 
 	if (!bnxt_tc_can_offload(bp, flow)) {
 		rc = -EOPNOTSUPP;
-		goto free_node;
+		kfree_rcu(new_node, rcu);
+		return rc;
 	}
 
 	/* If a flow exists with the same cookie, delete it */
-- 
2.5.1

