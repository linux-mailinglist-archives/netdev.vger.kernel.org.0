Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF527CF17
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgI2N1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgI2N1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:27:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC40C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 06:27:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z1so5422648wrt.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 06:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=u3WXrKA1CfjFzJBSJpuHsIULdRjXx+Aufe9hLA2Ll8I=;
        b=oZ1xZPAvn1ZSglZkn8SpcNR0b8We4Xu2XdF66Qnm84luiwwJJRsteCszET6bdXVNxa
         XleF8Qd8rnnTv49urrBtdgAhFI801eTGph5qDfEvrdUFfPdqeLCDDt974+Fd4j3QgHiW
         J6NopjLUWGjrX/hLhf1M6PO6CnvE2RL80k5XATFOPr+jKCzf/TCiM8QKlU5bJmqQdyGj
         195GcgLZPfEhxNMJ7P2d7OjkArQQph5xk1h5UEN46kpO4xLGBByFcsXzXUdVfL3SRcIU
         KJtkaWQtfmcCFy9nqrd/FKDuVj3bQcs40SPlaiX5UkbnnJWwf6knElN7aI+1zX/qjf03
         lVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u3WXrKA1CfjFzJBSJpuHsIULdRjXx+Aufe9hLA2Ll8I=;
        b=POg+9yuTQix3QNGT0rLAuK4cpyHazdHNR3ce/SPjR8ph8n4FZbNekN/0YdAZlT4j2w
         +W/y1xlT500r8uzbaqlm91krf7x/vA9sB7s8UIxHiupB+HmiU2rLXNPvtsCWVkFR07fp
         ivkUb9p9os3Y6nFdE1H9QdqnjtRyFN6bhB1Nfur2GU8FCfwbq8de0dKAFK6VVTOuTTCL
         WPV4lpW9ybz/RDbP0K7Gf1sCjlBlytAzsD0fjZXfVawwS/ZiW6eGbKruEk9BaVqGFUzP
         V+W3lmy0mjQGHhPMk+CjdUvkXizt1/wiNpBVvjOjtJOQrVUZ6E+BNMGuy6G4DVVOQD0q
         P6tw==
X-Gm-Message-State: AOAM530Yhqka1a/GP3MkD3Sb/ZG5Z1kmCmFVepvnXuN2UvnZmz8v2wUj
        7BwDvD71oDqjlURvTCuduvfeDQ==
X-Google-Smtp-Source: ABdhPJz9+shSWoQYtKYgfUfPz+HU+fmv3EAEqV9VpW5cHw2f9eHBtvcnlBv6RLfzmLVk4goIAJphRw==
X-Received: by 2002:adf:e449:: with SMTP id t9mr4475125wrm.154.1601386037648;
        Tue, 29 Sep 2020 06:27:17 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:490:8730:d9ed:65b4:1d51:1846])
        by smtp.gmail.com with ESMTPSA id q20sm5409907wmj.5.2020.09.29.06.27.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:27:17 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     bjorn.andersson@linaro.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, clew@codeaurora.org,
        manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 1/2] net: qrtr: Allow forwarded services
Date:   Tue, 29 Sep 2020 15:33:16 +0200
Message-Id: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A remote endpoint (immediate neighbor node) can forward services
from other non-immediate nodes, in that case ctrl packet node ID
(offering distant service) can differ from the qrtr source node
(forwarding the packet).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
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

