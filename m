Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3692B0227
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKLJmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKLJmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 04:42:45 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D322C0613D1;
        Thu, 12 Nov 2020 01:42:45 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 10so4020385pfp.5;
        Thu, 12 Nov 2020 01:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5W+o639lHZ25tp12ttWBBd5JJlogsy7RLDvSupOMn2Q=;
        b=iDLrnXYUeWekNi9FUWPHaaNfIa2cYDEY0x0jwvrxBr+L0KbiQXFRrsj0LdmE2OwT3a
         lkQUH2ZqgQ/gk8S4/yqTcS/knSC3wRb//cCGnATqrYo3pE60ORarCBNURIZbJNcELNbb
         +/FEaiJX9KC2UsuD87GS61pJnDr5RwgXGt5heCJUzsEauWuIsbNYUGW5rmU3muzV/niw
         lphTB8n547XVoDJcC5wcHu5OgBIhPjYtpsiTlC0z0xlX275pPlTu5R11aiaRmXtZyDqN
         N7u8F0zZoMQxrnMNriy91MrCYwtKk8GLDcrm1PytWUsCERbzCzzjP1w49sQgiegocWpE
         ihWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5W+o639lHZ25tp12ttWBBd5JJlogsy7RLDvSupOMn2Q=;
        b=awP0beSjclBRuOoj3JTc6oFS5+EPseQBYAsTajiJYXMO5ceyJD/wqmNdYbWIOIMKQ6
         mYBzSe0yzbmjt5L4WpZjXZpAOhRzZR7hx9elJ0LYr/t+fyEd8MsvjCjrvDcjVoTRk9lw
         Hr5hixFrW13I7w+zspGjR4Xg5gzGLlX+fxdxnQTuuku2aKRrt9RUBrQmVZjcWPoQbnV8
         lt6UIErWLNkSca6mYKhDOK5wlOyECSKutJI+i+nA1XbqCZBHD7iAS/N1WVYoGN0+2MoV
         glGBwueJUun5UsFNPT7O81IzmAwMBxjcjX30I3sUgGQX0HovyYsMDJzbT8nl8R3sN6VE
         LYzQ==
X-Gm-Message-State: AOAM530h9g3Hn+/Y4a1rdubAjZZhDVQ3UMpUYpJ7AvGy3w85EDoP8HJO
        sUCzTdy8XpnPKJ42muDp3MU=
X-Google-Smtp-Source: ABdhPJzW8aF3dzV1nheTLVlEB/j+quAUoBuS7b61kG2QpZLIzYxpF+oVm3sBRas/l218EdfJzhUSVQ==
X-Received: by 2002:a17:90a:940f:: with SMTP id r15mr1712977pjo.219.1605174164947;
        Thu, 12 Nov 2020 01:42:44 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:50f6:9265:b24d:a776])
        by smtp.gmail.com with ESMTPSA id w6sm4917402pgr.71.2020.11.12.01.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:42:44 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request
Date:   Thu, 12 Nov 2020 01:42:37 -0800
Message-Id: <20201112094237.4288-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x25_disconnect function in x25_subr.c would decrease the refcount of
"x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.

However, in the x25_rx_call_request function in af_x25.c, which is called
when we receive a connection request, does not increase the refcount when
it assigns the pointer.

Fix this issue by increasing the refcount of "struct x25_neigh" in
x25_rx_call_request.

This patch fixes frequent kernel crashes when using AF_X25 sockets.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/x25/af_x25.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 046d3fee66a9..a10487e7574c 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1050,6 +1050,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	makex25->lci           = lci;
 	makex25->dest_addr     = dest_addr;
 	makex25->source_addr   = source_addr;
+	x25_neigh_hold(nb);
 	makex25->neighbour     = nb;
 	makex25->facilities    = facilities;
 	makex25->dte_facilities= dte_facilities;
-- 
2.27.0

