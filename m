Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C10C245E2D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHQHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgHQHkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 03:40:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAF6C061388;
        Mon, 17 Aug 2020 00:40:24 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t14so13054077wmi.3;
        Mon, 17 Aug 2020 00:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmUBZsbAmD3EVJjGvG9SbrYwlsHxu96UPQjT/uWpoKI=;
        b=qQNQrKM2PnFKtba/dyPTxZ9CFtTeRRw64795FOTV95E2SWNMEP5aT0mcNCTqE0IxGo
         7jxn9ffl0IgsRhXjVlzS2yh20XEsM4i52qqqzgfwJoPc7oW4bcR8tEt4nknAFwkeU2cq
         KEozNSd6bLuw9y7G+lQSNMet2YmW35acyJvTJ6rJ1JCyJr59bnVcA3Q9C+Ju9QyB8vkL
         gpS3EF686vwnUA0tt02Tdl6Iumk/tUzLCXhmYIJtgorThaszfPrIEIK3KHOauBQeErzG
         hICMlAFjskWDfPDbiUrG7GH/y4F/MnOVy7cJqlHgN4R/HnQEQbmf7kLxmLPgAZrUcQn0
         oCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmUBZsbAmD3EVJjGvG9SbrYwlsHxu96UPQjT/uWpoKI=;
        b=qrvRqLitsf6YnJdm5p22+RRK8Spu58P//XjrUWwYbAnwQAs7DJLV2JMJzycHHhYMjE
         6X7u4yECtNk4AqVP6uVwt0BnmNdwkQWRfasmmfBb8SXKIVipBpXrJHPQW/Ro+X9fTe7Z
         0g3x34Ny8oeKGfcpFlMlgSBemtbqYXBw3TodlL7ZYJsF+0LfY01TDFFQ/5XwEuJ+omz6
         k5naKamNBSUSYAusy0avIMLQUbguuieme9WuZWj56/YGx4RFXnfHVIG2NKYKjN24bWV6
         uZmPqSeBGkZFNJOUYqdcRl/zQ6q5ZzItc3R3rC0UBcGxmlBFPlALC3543D1Mq2P2hPfk
         0pTg==
X-Gm-Message-State: AOAM533PkEyQgqwhQspK9kOIAfPBCQiFWU1OewP7q/wg/eSZFu8hYcBx
        RWhiJaT8oKUq/DVO1zEx/r0=
X-Google-Smtp-Source: ABdhPJzymzR85rC/pY7wLdRC+kHRj7ITBwigBbtW9I4EL1/cPnvXMtzyEOVuXaDp2hMGoWNqXTZogw==
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr13279347wmh.39.1597650023517;
        Mon, 17 Aug 2020 00:40:23 -0700 (PDT)
Received: from syz-necip.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id y145sm30447447wmd.48.2020.08.17.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 00:40:22 -0700 (PDT)
From:   Necip Fazil Yildiran <fazilyildiran@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dvyukov@google.com, elver@google.com,
        andreyknvl@google.com, glider@google.com, necip@google.com,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Subject: [PATCH v2] net: qrtr: fix usage of idr in port assignment to socket
Date:   Mon, 17 Aug 2020 07:39:01 +0000
Message-Id: <20200817073900.3085391-1-fazilyildiran@gmail.com>
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
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
---
v2:
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

