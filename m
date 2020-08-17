Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A858224714E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgHQSYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730916AbgHQQCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 12:02:55 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6395DC061389;
        Mon, 17 Aug 2020 09:02:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z18so15511803wrm.12;
        Mon, 17 Aug 2020 09:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5R//1gwPJaBVDKsBVQVRahfvA2gtmZIIH1L6eLKkANU=;
        b=o41v9UEH+JDITigfYWJeIZL2eVuQVurgNOlECENTyDbbewhZB8lLdvjxwSeK7ASXPJ
         CHFxToOJ9jMMfJVBGB6TYXApk7MXSISCrk160b4PdKpflDHxR0v6dQNbCloh6BBIpxqf
         8tj2PRg88vJXiPm0PyhxIIYVmKZhacn4ceeLP7byqGB2KJXTR6QQlLCTEbVF+ZeMAPgg
         kC8fzEc9D2PNMJ5R/XgTA5mLov7B7XNP0WHtvHC872ydWbNsBzHNWTjA6yRMXN/99xyu
         iPuPpEpHN4sMJBjgZxjHl+h6sXYLpvLT5yEDx+MQwLzfmHfiAV30hau4MXe9k92n3W1P
         5MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5R//1gwPJaBVDKsBVQVRahfvA2gtmZIIH1L6eLKkANU=;
        b=jGkitg2x4TzgKaO/C3eStmtQlI0RTaRvwvoSWE6NwkHPcOrG3/J/dckyHo8mG89ePg
         UnfVQlBqc61/3fRJk27vDj9TmP3fq8k7pwWcCJ1bCKWwfwuIZAG+jFhRl/QLux38MQEx
         Gk6h7DDGUtYogQzO6qSaSeaZQDAXI513FzbKnRlFiJAKGcPAqUIjdGtJp2lrINd/IHk5
         gRgRUiwg9XqWcJfTeEO+DWVlUM2HTksQm/RWINBAddVkWSkl4KY75koQWddFRqBdo10+
         +VYF8o6L7pmJrTy5jV9gHwNKFUZ9twXM41aBzU6OF3N9Jm5Bhkjc9E1Jra8rbO8Yv3Th
         MgjQ==
X-Gm-Message-State: AOAM532j14Ivm40uHsfmw5TuU/Ut9KthRS/2alulQ1zx9WkEDj/CZJ95
        ZszYboGHaQYAHCljdtZqEeZpyqvgIPqkxOEe
X-Google-Smtp-Source: ABdhPJxraiu4iLzWphUoT4hkaCNbj4d+jonExhITTrdP2QjcZwER1s4bzDz3fqMZPEaSnApfua4Kcw==
X-Received: by 2002:adf:e290:: with SMTP id v16mr15876943wri.259.1597680171465;
        Mon, 17 Aug 2020 09:02:51 -0700 (PDT)
Received: from syz-necip.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id b2sm28270724wmj.47.2020.08.17.09.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 09:02:50 -0700 (PDT)
From:   Necip Fazil Yildiran <fazilyildiran@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dvyukov@google.com, elver@google.com,
        andreyknvl@google.com, glider@google.com, necip@google.com,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Subject: [PATCH v3] net: qrtr: fix usage of idr in port assignment to socket
Date:   Mon, 17 Aug 2020 15:54:48 +0000
Message-Id: <20200817155447.3158787-1-fazilyildiran@gmail.com>
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

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Signed-off-by: Necip Fazil Yildiran <necip@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
---
v2->v3:
* Use 12-digits long fixes tag instead of 10
v1->v2:
* Use reverse christmas tree ordering for local variables
* Add reviewed-by tag
---
 net/qrtr/qrtr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b4c0db0b7d31..90c558f89d46 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -692,23 +692,25 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
  */
 static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
+	u32 min_port;
 	int rc;
 
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

