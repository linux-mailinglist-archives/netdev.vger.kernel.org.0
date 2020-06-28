Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F83E20C75D
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgF1KPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 06:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgF1KPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 06:15:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A36C061794;
        Sun, 28 Jun 2020 03:15:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci15so627523pjb.5;
        Sun, 28 Jun 2020 03:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nVNoGcrbtjaZ4GttzC1leLHGKpRHUoIf6gW/P9mP5vA=;
        b=NkVBj5s7iQjaU/Yi/VIF1GCpAlRoS9YzQUup5V0keAn4HP6JSzvKtWMoeuw7/NjxCR
         kVa0P5nRWRBWFdhMKhnzLRPZ2guhokoclT7hwPFCbxdXoGvgJDvfLAl6qw6eFlOfgWV2
         pw0iap4dSOew2fguilkjXjOdHRzNzTD46coY7v8QsgcLOe/OJUvcIclUoAj1fxuShHY6
         m9Wd5Qs+v81CpOyZDlaLVz6I/4G4qWZSUaIBJwA9NNjIoGUwplKr/h/MhukL1pufwoof
         BD7KZnLDH3qJMC8xw3FGHf7Jt0cZvT1S2a/St8XOZgabS3oPlXytB+E3hQNu1NWzgxOr
         XpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nVNoGcrbtjaZ4GttzC1leLHGKpRHUoIf6gW/P9mP5vA=;
        b=lZSQvDOpS65aO3YeOkZURVdJb2/p5CqQtuceDOKRk86ys7X4MW3KJX4jHh5lgg0glT
         d1qKoRQVWA16pVu7C4SpHEpeG3RFU6ITfrTDvpbj07MDgYV/UoRDGSaR+dX5MlfwuVpL
         qvs+99myVmvcKiVP5UVf/HBtdsBK+XCkC+MXx62dJF5GTmV9V+FaR5bSJwBchH/P7ivV
         wSGy5/CcjEni/LkVMwcwdss4pAixoH2eIE3Qwd7ltF6GAXEiLVGkFftSaMeKC87BySw1
         IWDoJqGwgPZDSfGOatTTeWcEeRFm7hIrc9DU4xvG+unGkkyUt0O1syqUHQgtFA6APKXw
         oLrw==
X-Gm-Message-State: AOAM532/0H8Jts57OAhDyTS+Iw6i02BZNx8sEjuAhbnRukqvgK/txctu
        tr9ekxk5s0mhDCObw5Eg/8I=
X-Google-Smtp-Source: ABdhPJwmCm+KA8TPGTItXEQGsWRFcivwHuxETSBomvcRw+LRBnNDFtU6wK4toHme/k1LWlzA0pDGAg==
X-Received: by 2002:a17:90b:4306:: with SMTP id ih6mr11239323pjb.62.1593339343667;
        Sun, 28 Jun 2020 03:15:43 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id s36sm26824208pgl.35.2020.06.28.03.15.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 03:15:43 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] liquidio: use list_empty_careful in lio_list_delete_head
Date:   Sun, 28 Jun 2020 18:14:13 +0800
Message-Id: <cec4b86f5c19d84addb42a56f6dddbf045995431.1593339093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use list_empty_careful() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_network.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_network.h b/drivers/net/ethernet/cavium/liquidio/octeon_network.h
index 50201fc86dcf..ebe56bd8849b 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_network.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_network.h
@@ -612,7 +612,7 @@ static inline struct list_head *lio_list_delete_head(struct list_head *root)
 {
 	struct list_head *node;
 
-	if (root->prev == root && root->next == root)
+	if (list_empty_careful(root))
 		node = NULL;
 	else
 		node = root->next;
-- 
2.17.1

