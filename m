Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E982447BB
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 12:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHNKKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 06:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgHNKKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 06:10:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FC6C061383;
        Fri, 14 Aug 2020 03:10:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 88so7861683wrh.3;
        Fri, 14 Aug 2020 03:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R46SsqR1eyTATyhcAOvh3H+PeSzPXKSuMJhoGSukpwE=;
        b=ZkoqvZoN/zk5fWo/v9mYsby8Ww5Gy2pTb6vtMRcIkHDJzQPegLt8O8rrj++0RPqi2z
         pDsXrWYVVZdvt7BIUQP/FNkgEAXN1uG6NrKaT69dlvDs+o/wjUrt8fHAJCP3yzR9xNfy
         tT0HqGDpiyKHwHUyki3eYhBtEgjldOfzxMd45C2rTsxfqLPFG0s9UCQMxZAT04KrRHzU
         RJ2HvpD9C3PU0EIM49HALg/SaxSu3S50l5OmrAOyJhIOSjJsh1PG+Bpg3i1GlNExA5uY
         mql7U3Be570mZDAzuC071dxztsojSJn3f0jxO8dK/eyHUSBxghR+rtRGQxwIxcz47dgs
         vw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R46SsqR1eyTATyhcAOvh3H+PeSzPXKSuMJhoGSukpwE=;
        b=ZMRHPybPt+iGeuHK0wM9HddN+UT6cr4m+BK1+UyvK6YkVqbL39jbKdTFljSqlBt8O1
         pXyv/bVuK3QqK/hgQLM7IaCo0VKEdty1bqpeGezzCzZ8TQOWmxu3WSU8HBrFjLrgV26o
         ZA+3tKuv1VI8TH1F/3z/Nnf1rb9WU6woF3jv/l9sYhtzhkh8/+0xeYFhw6QFLUYyQS0m
         5B0XKDfmgCQqEvMbJ/wqCHyiP5+/LrlhBf1Ry5ogJGOkerGm96m7D7k15cvBDjQb1mvG
         jMC8nCEb05sVnGVgKXSu3CJamlwVi+hQhyP4SeRo1KMZRH8+nOxrhnOK3qvGCYkhC+Wy
         6abw==
X-Gm-Message-State: AOAM532zdrnrxXNu7Xlo0RstS6EUqsx3rvVPF+ezNEQDnMEuq11eYKDn
        w/PplXq4Q7MoovqGvayKVVI3Afj+tYuVz6KuIzA=
X-Google-Smtp-Source: ABdhPJy5Ary+CLZu0csWXpWFWur1DgCIbdgUHlLLl0lwU1vFMcz37O56KcA1H3bwbBBqunLPJqe9CA==
X-Received: by 2002:a5d:4144:: with SMTP id c4mr2032285wrq.200.1597399838075;
        Fri, 14 Aug 2020 03:10:38 -0700 (PDT)
Received: from syz-necip.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id s206sm13909891wmf.40.2020.08.14.03.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 03:10:37 -0700 (PDT)
From:   Necip Fazil Yildiran <fazilyildiran@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     courtney.cavin@sonymobile.com, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dvyukov@google.com, elver@google.com, andreyknvl@google.com,
        glider@google.com, necip@google.com,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Subject: [PATCH] net: qrtr: fix usage of idr in port assignment to socket
Date:   Fri, 14 Aug 2020 10:10:00 +0000
Message-Id: <20200814101000.2463612-1-fazilyildiran@gmail.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Necip Fazil Yildiran <necip@google.com>

Passing large uint32 sockaddr_qrtr.port numbers for port allocation
triggers a warning within idr_alloc() since the port number is cast
to int, and thus interpreted as a negative number. This leads to
the rejection of such valid port numbers in qrtr_port_assign() as
idr_alloc() fails.

To avoid the problem, switch to idr_alloc_u32() instead.

Fixes: bdabad3e36 ("net: Add Qualcomm IPC router")
Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Signed-off-by: Necip Fazil Yildiran <necip@google.com>
---
 net/qrtr/qrtr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b4c0db0b7d31..52d0707df776 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -693,22 +693,24 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
 	int rc;
+	u32 min_port;
 
 	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
-		rc = idr_alloc(&qrtr_ports, ipc,
-			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
-			       GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		min_port = QRTR_MIN_EPH_SOCKET;
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
+		if (!rc)
+			*port = min_port;
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
-		rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
+		min_port = 0;
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
 	} else {
-		rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		min_port = *port;
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
+		if (!rc)
+			*port = min_port;
 	}
 	mutex_unlock(&qrtr_port_lock);
 
-- 
2.28.0.220.ged08abb693-goog

