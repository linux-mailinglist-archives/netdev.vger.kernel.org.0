Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3446468CD3
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 19:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhLEShL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbhLEShK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 13:37:10 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7272DC061714;
        Sun,  5 Dec 2021 10:33:43 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u1so17617984wru.13;
        Sun, 05 Dec 2021 10:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cNCNOD/VY4UQ57myNANKBUePZRc6/9OL52ULDdnUR5M=;
        b=lCognWdQswhVq46kJiA93/WzrXSVw9hKnCnBezWQB6y3RaBb59inEdLusxbaL8uOvA
         NhWbS2mFVK1t/TCj8y8v0sFJd689akS6KaCU+OCABg027ZfCR6aoLTfig5Dt8xl/uBPz
         MCS/UpO/feuLlS3d+aTPQln8X4OZXJ+d2XluKXXVffr8YuCkcwS6QHtpgyANiH3EJ8xF
         7QKqBhnlYPJrDal16yFuyhPZ+ZVpnCHs2Aul0qxNyBo7Cmz3FIZbHbu6UKH4PVFhmSEs
         MoU2kR9rrmXQkShmqt0HIEc4JR+Lxk5QxmMsCvgbsj/MuwfTYRwTRL2iHPFLhIBT+8ta
         9VfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cNCNOD/VY4UQ57myNANKBUePZRc6/9OL52ULDdnUR5M=;
        b=IEQntVQJQOIjSZ35BYiQXdkJsny/NT10G8uN9/YhoTId59cZIEKPPJ6+YKxIpCjDBn
         4aGo0CexPq1aPR/4RHHHM93fL8n5KBV0UqcNjmvJt6IcwK9tO4cJH6pgDNkPyF63OLzu
         9m0rLaI1+W/OmiNlTnr+jhoD4YwhOAwKDqj1RZYUOvEb3Xfco8rJqz3vEpVq/CPUhOri
         eai9liU73gU/3b0UmmcrB4bRsh24Kjf72kdLPEIWwXVXLXdL3KlQcENzT0QkyEX5EKMQ
         bNAZfbGwZxhnOCmE8QLIWJSvcS4mZvivMTXEyY7jYGU6Na56h/0qCIUiLTA1kAcx2D2z
         zrqw==
X-Gm-Message-State: AOAM531Nufw9cCtfbz4CuhOqru4aIJ+HTnsvOFPANwSSthEFurH65F9M
        pzMSd6jiZZVUwM7NDnuZE4Go1LKNGWtGQRgp
X-Google-Smtp-Source: ABdhPJxmfS9BLrq1agFZnZMCzh1b1iuTBT2oPXEBDFPvgVDHpgPWKXPyshWhWgln2m8NeoiaYcZ8QQ==
X-Received: by 2002:a5d:51cb:: with SMTP id n11mr37095224wrv.278.1638729221997;
        Sun, 05 Dec 2021 10:33:41 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id az4sm11516769wmb.20.2021.12.05.10.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 10:33:41 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        davem@davemloft.net, kuba@kernel.org, bcf@google.com,
        willemb@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        amhamza.mgc@gmail.com
Subject: [PATCH] gve: fix for null pointer dereference.
Date:   Sun,  5 Dec 2021 23:33:16 +0500
Message-Id: <20211205183316.7800-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid passing NULL skb to __skb_put() function call if
napi_alloc_skb() returns NULL.

Addresses-Coverity: 1494144 (Dereference NULL return value)

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
 drivers/net/ethernet/google/gve/gve_utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index 88ca49cbc1e2..f4befdb54ad4 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -68,6 +68,9 @@ struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
 		set_protocol = ctx->curr_frag_cnt == ctx->expected_frag_cnt - 1;
 	} else {
 		skb = napi_alloc_skb(napi, len);
+
+		if (unlikely(!ctx->skb_head))
+			return NULL;
 		set_protocol = true;
 	}
 	__skb_put(skb, len);
-- 
2.25.1

