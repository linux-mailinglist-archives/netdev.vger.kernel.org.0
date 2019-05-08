Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC7170BF
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 08:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfEHGGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 02:06:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46984 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfEHGGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 02:06:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id t187so5427411pgb.13
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 23:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p5HInBiuJL6RtWK4IaOfUZdmH8ZXG7yh2eAVGA9vg3M=;
        b=u7QI4igQ8i/7N4oUg2BhkdqF4FwTcLtpbk8aJ06RfsBXr1Nqqo6zNwzuUELwAs0ThG
         pIKDNsZyj8tVY97Oj35iK/nVDAk8qWoYKzEW42lkqcG1QdA+yNBYcMnvHfH3EW8NKSQP
         QAegi/Ac9yj34wHZqOByYLTGfz5LS3p286gLTrG8DCKb8OVVSKCl/pk7qSS+uSiUMB3z
         7+wSTLY1v1nbeNGBzo9uO1V0YL94eDE66GfOvqYb2ZJ0HPGL8Jqq1AUa1WwyBE9KyAL6
         iC1RBZPBNf11/N4BlrlX+xaR1NXs+B2oTFhWUPLS6Oc51NEVRoz4Q8XCTo9Jo76G1fuk
         nn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p5HInBiuJL6RtWK4IaOfUZdmH8ZXG7yh2eAVGA9vg3M=;
        b=Hjw/xR/J0sS3T707OeNqXXDZICLzZm4h9Ps1yjPIhOqvCZBrnPUkQ0btDbs19yyAtV
         xjzRkbDviLTel6BY4g8gSxf8XRa85gCRGGlTEbZ8wtLpQNm8Y26M3Ss+0Q3y9ETljaef
         4XzD18dWKhYqD0O/kZbcbhFqK2v95ZgS3iffu8ov4F4qpoyFcNdttbOZYQKDx0i6+dso
         QUuLjoZn9aDgEEWsF+RFebQ3+9ycqjS0CeOmwWbKz5Bcg5YRttSDzng3sOEdQpz++dbo
         9jAjDkUnWSLVGfanqVtrVkNb9E2TaUv8HggU/Ty4xQDWZr6X+SPAn1q0QOt1XCi2xwDA
         GO5A==
X-Gm-Message-State: APjAAAWWhGbfVwYxCQ2C75Ph2tj2ayF606sS8VmS29ivTp7ijZI2+dcf
        k0PT5eE4egxOXoX669JGYjmgHg==
X-Google-Smtp-Source: APXvYqwtcRKDjJE+VZb+kZbkmB5gMLxA4ENM8x8rhsW0Qfxcl0RwFIAMO/6DjM3VQb67P2BEbr2t3g==
X-Received: by 2002:a62:6c43:: with SMTP id h64mr13973560pfc.5.1557295611749;
        Tue, 07 May 2019 23:06:51 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id t5sm2756130pgn.80.2019.05.07.23.06.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 23:06:51 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/5] net: qrtr: Make qrtr_port_lookup() use RCU
Date:   Tue,  7 May 2019 23:06:42 -0700
Message-Id: <20190508060643.30936-5-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190508060643.30936-1-bjorn.andersson@linaro.org>
References: <20190508060643.30936-1-bjorn.andersson@linaro.org>
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
 net/qrtr/qrtr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 9075751028a2..d2eef43a3124 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -602,11 +602,11 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
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
@@ -648,6 +648,10 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
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
2.18.0

