Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3DD3D3E93
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhGWQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhGWQpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:45:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA5AC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:25:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b7so3132910wri.8
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PjeERi7upz0bSI36pGMn3mjTdet+nsuS/09bNkS+VnE=;
        b=nBqZsBSC8BS+wPgs5VmujkQq/FCzPj/JIbH7YdSf5kKMX98ooJnNs1mljh5diiEuWx
         UdHrrNkK1FU4XhpylPAABSPY6/324y6ZnO2q7YaAWCzAfO+4NZpc4H+4642kEwv2x9fk
         tfLSqGdjxobO8UcGaemI8dkVqsj555Vc9abvamty3D6yRA2Y1AIUfguTN+iS+kPvbrhx
         fWyVTqG0gnOdEmfgeXlDMuT/iinSegnv0K6nIsfiZLgLa/RlDmehmPbJ8egUZqovRdQb
         sjwO0xqODVGW1ET9oXzEjXG9ewWqYW/QSJTWhKWFwNmJxPDe5puEvgXdPHR9jutODwNL
         YH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PjeERi7upz0bSI36pGMn3mjTdet+nsuS/09bNkS+VnE=;
        b=A0P9Ak1tEXin+iKWGsOQBMBG9+dc/Eg0vbtL39cn3pZe0vTyrArLSwOnyLJB/40mDG
         qTbt03Rdx3g6eINZMo8QsbM6iswFfCK3pELIhLb5KUdtX9twpIduD1rbDl6Xc6beAkdx
         2sRzMxR5ryVB4zIRNyUmHSGOdp8KTpMTu/ENE9X5d3aiXdtAIzIbvufcYrnhkpLDR/3e
         VsCbUlTOVSb8GZrntn+TWZzwdrUrsDCcn/nC9hkCLM2+Umf+KxhOOQaIpToAtyrrxtZD
         OCl0du7CE4TOTR729CoIxGwB+0sB7o0QreEq5SrmFKhUn1N9sWBNKFRo0PbaqnfUGxx1
         P6ig==
X-Gm-Message-State: AOAM531q0ufXMz0tzzLP5sMxl5OcpA2KINXdWRGX4SrMXO+ZtyO7IIrv
        r2wfQt5R7Smsg+qIhEtPTekLg3+bEcJP0g==
X-Google-Smtp-Source: ABdhPJyPkhxq0lrs5SdrqngPDFkK8mSu7awcghjWyziR3fdQN6BfwmySLLeOG7UC+8bEXBevpx0onw==
X-Received: by 2002:adf:df12:: with SMTP id y18mr6598619wrl.189.1627061138522;
        Fri, 23 Jul 2021 10:25:38 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f26sm27690440wmc.29.2021.07.23.10.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:25:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Jon Maloy <jmaloy@redhat.com>,
        tipc-discussion@lists.sourceforge.net
Cc:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Subject: [PATCH net-next] tipc: fix an use-after-free issue in tipc_recvmsg
Date:   Fri, 23 Jul 2021 13:25:36 -0400
Message-Id: <a60f2c4e9eb8cce9da01c5bd561684011f7fa7da.1627061136.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported an use-after-free crash:

  BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
  Call Trace:
   tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
   sock_recvmsg_nosec net/socket.c:943 [inline]
   sock_recvmsg net/socket.c:961 [inline]
   sock_recvmsg+0xca/0x110 net/socket.c:957
   tipc_conn_rcv_from_sock+0x162/0x2f0 net/tipc/topsrv.c:398
   tipc_conn_recv_work+0xeb/0x190 net/tipc/topsrv.c:421
   process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
   worker_thread+0x658/0x11f0 kernel/workqueue.c:2422

As Hoang pointed out, it was caused by skb_cb->bytes_read still accessed
after calling tsk_advance_rx_queue() to free the skb in tipc_recvmsg().

This patch is to fix it by accessing skb_cb->bytes_read earlier than
calling tsk_advance_rx_queue().

Fixes: f4919ff59c28 ("tipc: keep the skb in rcv queue until the whole data is read")
Reported-by: syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 9b0b311c7ec1..b0dd183a4dbc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1973,10 +1973,12 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		tipc_node_distr_xmit(sock_net(sk), &xmitq);
 	}
 
-	if (!skb_cb->bytes_read)
-		tsk_advance_rx_queue(sk);
+	if (skb_cb->bytes_read)
+		goto exit;
+
+	tsk_advance_rx_queue(sk);
 
-	if (likely(!connected) || skb_cb->bytes_read)
+	if (likely(!connected))
 		goto exit;
 
 	/* Send connection flow control advertisement when applicable */
-- 
2.27.0

