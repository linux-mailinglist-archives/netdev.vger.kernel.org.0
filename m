Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D9D10A35C
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfKZRdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:33:20 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:37567 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfKZRdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:33:20 -0500
Received: by mail-ua1-f73.google.com with SMTP id d8so3440293uan.4
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 09:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uZgRtie4stQ2omjZ9+aRh+vBByoF3iFyA+dR7y3Aqi4=;
        b=QoZg5pdZcL7nJ4kxTdFJo2PQmqKYNmUY5WwsA12jlEW+YvJ+CA0AaU407wQP5Xmndn
         //syVebMtU21PIQPjgA7EuT2hxq7uOJaegU1RLdT0dmHdDOj+xvjXltfbNC3JlCJTzdC
         vVrJ4XGeDuRUGo/6snLJmdMstmGCbIz4a4Jk2aKlKiNUxBLI3LUA0y0Rs4E5ZdMgkukR
         IY6auVckKOyb/GTglp9/K83kISanrvRkE3cEtE+nRoIbj2c2TmUGqsuqKiJtmqW4No4A
         0KXHzjKfZRM/A7cI+fz2dMuQiDwTAXq3pKmUZZ28Qq4SQVv/I/0TCvbINnE0BUxN2B01
         3upQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uZgRtie4stQ2omjZ9+aRh+vBByoF3iFyA+dR7y3Aqi4=;
        b=ptbmx7RtULhpqv+5rqRP30d83wNs9hwr7/rUBfvDE45dyUFdR4Tg5jccn+j0HjW/Kr
         Ek1FLrHv1T7qJ6X8tJeZtWqfVrICLERlz4U8XDfuDTScAr4ti+xh73IR4o/E3CyzdnHl
         8mG2EeZfhKKLnw8cv023aEpdhSYjYygceX297l7r0WYdWuA54JgTCj781ZgaIs/x108K
         U6eAeAH+hrQnMjjOsG9hV5h3sMMLCYVrhNkaXgVEwqd/LvTrDa/pkxnOebrT2Rmy4B8W
         fTQR8uewgeITYCMS+jfx48Em+O1gZUTd7Zz3zBS0Te7qf5QkFPj3gNy9q/9AAsOL3GdW
         N9+w==
X-Gm-Message-State: APjAAAWc3DH7aMnA905oLKABOAUea05LENGdS7i99AnIhkIusMF09k3U
        9IBA0r1YtrAT5I3AoHOtCq9+URAmqSxDCQ4wUy+UmN93WmPZ/1vKzLl1uh4JyHUoB7n4PPwl+Ux
        tlrSEwTrcOhDS1Rd+qkwEbxih+ZjgWTWP5idZ+c6q67ekcuTnVuiuG1txALGdI90xKZs=
X-Google-Smtp-Source: APXvYqytXMKG4G5u1sTXyxSKOevA3WO3b8/8OHOfIMwzGn4Jxr/LyPqO8TKXU4pFH6qe4zRwk5HRsUFPdWj7RA==
X-Received: by 2002:ac5:c922:: with SMTP id u2mr1871041vkl.12.1574789597270;
 Tue, 26 Nov 2019 09:33:17 -0800 (PST)
Date:   Tue, 26 Nov 2019 09:33:13 -0800
Message-Id: <20191126173313.137860-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net] gve: Fix the queue page list allocated pages count
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gve_alloc_queue_page_list(), when a page allocation fails,
qpl->num_entries will be wrong.  In this case priv->num_registered_pages
can underflow in gve_free_queue_page_list(), causing subsequent calls
to gve_alloc_queue_page_list() to fail.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index aca95f64bde8..9b7a8db9860f 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -544,7 +544,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 	}
 
 	qpl->id = id;
-	qpl->num_entries = pages;
+	qpl->num_entries = 0;
 	qpl->pages = kvzalloc(pages * sizeof(*qpl->pages), GFP_KERNEL);
 	/* caller handles clean up */
 	if (!qpl->pages)
@@ -562,6 +562,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
+		qpl->num_entries++;
 	}
 	priv->num_registered_pages += pages;
 
-- 
2.24.0.432.g9d3f5f5b63-goog

