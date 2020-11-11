Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E782AEE64
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgKKKEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgKKKEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 05:04:40 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CD0C0613D1;
        Wed, 11 Nov 2020 02:04:40 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i26so1147798pgl.5;
        Wed, 11 Nov 2020 02:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9rZwIqZztwOL1U6m2Ih25e7+ck0jlI4vUSseVss+TsI=;
        b=DfHz+bYF6uF4L6ciowIpNlMAzhpE83IECESzcYrTD4zb0Ox8K7aPr0xjiUNxl2vKsw
         pqkg+dnSWBqkRBmm0g8CBJ67jutIS1a/wekg68W5eIPJIFa94ZA+tvQkuNInZQNJngxz
         Z48I5hL4PKMZR3XkkDpbRaF7ixv9aikZy5tYtHFHQ4hbFaUtJw1aUcSl+IajSqE3RGks
         bK2ejNsHu5e4+DV0WdwblF5+iNIu8XPzTJDUTlok7kPNEchEhirx2zmhwqfy23x9l7Sq
         ml5DMvx/3KLgeX9rLvhqwOqqbHyPthoKrIPRwAsy2hq8yR45zJ3GUHCpQLpXHd6I1s4M
         1F7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9rZwIqZztwOL1U6m2Ih25e7+ck0jlI4vUSseVss+TsI=;
        b=HOkfZoToG0zv8qeOeWBRevEZtDqrYIsqydG7/I9fp8EDedn5cQVX9JVHOWLG4WrSuK
         wrXCLPj8miXBZjy6uyLFL4a9ags9Ad/+hWb4go9RlVaOqafxJl2f1OnUYNUR9r7GlB3W
         c9kFvhbmPoj/Wna3/l4tfd+8EXOwhBQKAoSR0hvEVQgR+m5RDEmnDeeYw+K8cTcAdL7s
         +wCZ4otzePCKs68aj7wOsaXi4scOtBXtdwcXJxs/Lx3w/ytnj7VhwV8wMyuY1TbLHSOF
         6G5jzb0Xuby56+1YC8iZx4AZv5WqLySPD+w4kgfpqgftwOZogJheWPS0gI4FTsiHOFZt
         BSJg==
X-Gm-Message-State: AOAM5333bfD2xgPXDt4jO1e4bjQ+ybtkdH+YQGBtd6HspstDkLwqhRUQ
        CFkm6gFQUfZf2l0k4IB+Dcs=
X-Google-Smtp-Source: ABdhPJymu48e+pSiMbIGXL45xkr0pRaRVr7nTPeW0lGyJQuUbCh66yBbDbBBB7AZCnpz+X1W7O+Vgw==
X-Received: by 2002:a62:2c16:0:b029:15d:8d2:2e6d with SMTP id s22-20020a622c160000b029015d08d22e6dmr22600604pfs.52.1605089079849;
        Wed, 11 Nov 2020 02:04:39 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:5320:802e:3749:ff39])
        by smtp.gmail.com with ESMTPSA id y3sm1870769pfl.77.2020.11.11.02.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 02:04:39 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: x25: Fix kernel crashes due to x25_disconnect releasing x25_neigh
Date:   Wed, 11 Nov 2020 02:04:24 -0800
Message-Id: <20201111100424.3989-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x25_disconnect function in x25_subr.c would decrease the refcount of
"x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.

However:

1) When we receive a connection, the x25_rx_call_request function in
af_x25.c does not increase the refcount when it assigns the pointer.
When we disconnect, x25_disconnect is called and the struct's refcount
is decreased without being increased in the first place.

This causes frequent kernel crashes when using AF_X25 sockets.

2) When we initiate a connection but the connection is refused by the
remote side, x25_disconnect is called which decreases the refcount and
resets the pointer to NULL. But the x25_connect function in af_x25.c,
which is waiting for the connection to be established, notices the
failure and then tries to decrease the refcount again, resulting in a
NULL-pointer-dereference error.

This crashes the kernel every time a connection is refused by the remote
side.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/x25/af_x25.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 0bbb283f23c9..8e59f9ecbeab 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -826,10 +826,12 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
 	rc = 0;
 out_put_neigh:
 	if (rc) {
-		read_lock_bh(&x25_list_lock);
-		x25_neigh_put(x25->neighbour);
-		x25->neighbour = NULL;
-		read_unlock_bh(&x25_list_lock);
+		if (x25->neighbour) {
+			read_lock_bh(&x25_list_lock);
+			x25_neigh_put(x25->neighbour);
+			x25->neighbour = NULL;
+			read_unlock_bh(&x25_list_lock);
+		}
 		x25->state = X25_STATE_0;
 	}
 out_put_route:
@@ -1050,6 +1052,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	makex25->lci           = lci;
 	makex25->dest_addr     = dest_addr;
 	makex25->source_addr   = source_addr;
+	x25_neigh_hold(nb);
 	makex25->neighbour     = nb;
 	makex25->facilities    = facilities;
 	makex25->dte_facilities= dte_facilities;
-- 
2.27.0

