Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AC42A9ABD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgKFR1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgKFR1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:27:10 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF124C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:27:09 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id y12so2129845wrp.6
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pEBu4MEn0zrdd6kmSnIxtSlsYwCAvk6sOANEKyTQKac=;
        b=Tp848QB4+ncG8vnPLsRqZ5TFpqijx3N7VRdr1ef8j53Zy/sRxGjPLH0VtZiTNxnzXV
         Kce/AvrdjaNJajerHWc4DvQN5uHLa79Y4mZzXL7Ac0PdnFSbUjTu3iOmHSam5yPrgmV7
         DerZQbNGykCT3Ws3HkxqmL4PbLfFyOs5ufOR6/foBS6wIXNn+JHHHEVFb8Ovcy0MfL26
         Z0h6IwTqr6eDIb1xckznkVd65oLRIOVTj0jOM0qrSeCUULw2yuE/efWFlSqiDnIXHEor
         j5u4sQVulB5ttoM8vLgyqO37sR1KwhBcC+QQGhpdGPVFjeXIgsrnweMtnCYp7Dh0yC0o
         LBjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pEBu4MEn0zrdd6kmSnIxtSlsYwCAvk6sOANEKyTQKac=;
        b=TJLsPV7su92f8XWXBY46qx3zxEtfnG7lsHM8xwMqr1312P2S3lJbmaEWoSZB0vfEj6
         hE8KxE4WSZhXfPJINahyYr3JqoLgNcnMSpbMudp+IEKegogXNShwWfeWr+sxcF/30teo
         UnKIjE5jcTs9oqoqFOGuumwDrS07tTn9c3LWSU46hNVaa4QQJbjkDOnKoot9vuMvSCoz
         9/Pem12IF222k/LX0jV9yS8j1QrWGu9hWaU5L4nIzkvkkM4uEn10uH7w8eCz1Bv62Fhx
         q81+F2uFYQyCe/JD6zO4bXqQcGxFw0jABa2OFV1uiCNgyGR76yEO8ooKv0yfz99Z4T+m
         t5GQ==
X-Gm-Message-State: AOAM533d03oxC/d5bj0/OFBUJNqUkDs42nr6l6IR3eqd113Btgu7AkwM
        Dy17KWfzd2Z9wTX7ZOycSFyXVg==
X-Google-Smtp-Source: ABdhPJwq2sXIdmMtWHlOAdTW98QRUJeaOrjOVv7UC50EyLKNd/0IkFSdtmrCyzL8cYe3xsQ7vi3hOw==
X-Received: by 2002:a5d:6046:: with SMTP id j6mr3886668wrt.317.1604683628508;
        Fri, 06 Nov 2020 09:27:08 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id z191sm3183266wme.30.2020.11.06.09.27.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:27:08 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 2/5] net: qrtr: Allow forwarded services
Date:   Fri,  6 Nov 2020 18:33:27 +0100
Message-Id: <1604684010-24090-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A remote endpoint (immediate neighbors node) can forward services
from other nodes (non-immadiate), in that case ctrl packet node ID
(offering distant service) can differ from the qrtr source node
(forwarding the packet).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/ns.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index d8252fd..d542d8f 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -469,10 +469,6 @@ static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
 		port = from->sq_port;
 	}
 
-	/* Don't accept spoofed messages */
-	if (from->sq_node != node_id)
-		return -EINVAL;
-
 	srv = server_add(service, instance, node_id, port);
 	if (!srv)
 		return -EINVAL;
@@ -511,10 +507,6 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 		port = from->sq_port;
 	}
 
-	/* Don't accept spoofed messages */
-	if (from->sq_node != node_id)
-		return -EINVAL;
-
 	/* Local servers may only unregister themselves */
 	if (from->sq_node == qrtr_ns.local_node && from->sq_port != port)
 		return -EINVAL;
-- 
2.7.4

