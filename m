Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DAD13A257
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgANH56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:57:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38448 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbgANH55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:57:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so6198888pfc.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cT6CIKbYE+ZaFFcNOOsxSrYLOhAgjqy8hJjakcWsraw=;
        b=HWJ1FrKZivAC77Q6ewttmSwMoUhC4h8f56+T4yQkYs25/XqVt1ThC3IC6EIkcHoLVG
         Y2dYcFEqMihzuuTAPZAm1+7UqRpMk5pYxniaU+29kPfB+8LfcZdqTBakVYTfdnANH3PP
         7+mK1m0XlZawRAeIqF2Owtzv8kZbkk0jPGX4STZEQUySpNfqfiEeeR+JoJaD/qi+ZSWB
         BraJSp7wL9eRt7pusrlG48nShyFwNDz4uqSEEtRRYZrexuBcShVJaAk25O66oIUw8APO
         FRBI0GvoQCE0Uxu/OeTAMbDVUOtpBRsi8LgxGZUFs1lRq0Ok2CvcFBYSLTufUgLaep5l
         Oi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cT6CIKbYE+ZaFFcNOOsxSrYLOhAgjqy8hJjakcWsraw=;
        b=fU1xNo9gPZRfgsV5y3abTEoyHomlUIaLDQrAB9ytnlxMI9Fg4I1bagsPJXRTpI4UYh
         oP7/gsp01SCzTs4MdXL3pEMkw6Ny4zUw2wGwn3x2hZqdTfwfEYkY+WGUeKekYv6x4sxO
         +IcLmCMmNXFU7mbZ4Bj2wz+yj0TL1Idbk4v7BYoJV/kljsZ4JorwG4WbZ4QsFSEeolMf
         smdALWpIZzFK9Ltzw/l2o+2gLpyJl+Egj/j7eviu2IbtOtiEx6mLvA9hWS0rB9GXygma
         FIbSJxoEaOmpmV8fVhXRmcSqPOJg7klukbQ4bhNV4SLsPD7RD0dztsfN9EQ10+so8qpc
         Donw==
X-Gm-Message-State: APjAAAXWqsMO0di7vWhGkleTMUFB+v9FF2KW1rB26oF9bL78R+Lkeq53
        MD2P2u+4QtkxlGj8vAx9BgVKxJRRbLw=
X-Google-Smtp-Source: APXvYqxa0sjqaAqTU3VpbArJAMp7cdEEAKNxoK+7V8ScX+GgBOrVf0psQGSLOw/kjBSkfLKnRweY0w==
X-Received: by 2002:aa7:979a:: with SMTP id o26mr24139687pfp.0.1578988677055;
        Mon, 13 Jan 2020 23:57:57 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id q63sm17349352pfb.149.2020.01.13.23.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 23:57:56 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 4/5] net: qrtr: Make qrtr_port_lookup() use RCU
Date:   Mon, 13 Jan 2020 23:57:02 -0800
Message-Id: <20200114075703.2145718-5-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
References: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The important part of qrtr_port_lookup() wrt synchronization is that the
function returns a reference counted struct qrtr_sock, or fail.

As such we need only to ensure that an decrement of the object's
refcount happens inbetween the finding of the object in the idr and
qrtr_port_lookup()'s own increment of the object.

By using RCU and putting a synchronization point after we remove the
mapping from the idr, but before it can be released we achieve this -
with the benefit of not having to hold the mutex in qrtr_port_lookup().

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v3:
- None

 net/qrtr/qrtr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 52816d44fb26..8ae301132a54 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -646,11 +646,11 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
 	if (port == QRTR_PORT_CTRL)
 		port = 0;
 
-	mutex_lock(&qrtr_port_lock);
+	rcu_read_lock();
 	ipc = idr_find(&qrtr_ports, port);
 	if (ipc)
 		sock_hold(&ipc->sk);
-	mutex_unlock(&qrtr_port_lock);
+	rcu_read_unlock();
 
 	return ipc;
 }
@@ -692,6 +692,10 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 	mutex_lock(&qrtr_port_lock);
 	idr_remove(&qrtr_ports, port);
 	mutex_unlock(&qrtr_port_lock);
+
+	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
+	 * wait for it to up increment the refcount */
+	synchronize_rcu();
 }
 
 /* Assign port number to socket.
-- 
2.24.0

