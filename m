Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3493C3942D0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhE1MoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42514 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbhE1Mnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:52 -0400
Received: from mail-vs1-f71.google.com ([209.85.217.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmbof-0007zE-4o
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:17 +0000
Received: by mail-vs1-f71.google.com with SMTP id d19-20020a0561020413b029023877d74e72so954227vsq.15
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1E8+lV2yYHpfQvRilUCcibqrpA4/S/5sauZ+Rzzh9M=;
        b=H5YArREQ8ZPRTU/XJf3J7t7ORo2zqKVTp9LusBdyJ15Ll2Ogv6tg6VnOAJCRvYTWNX
         fPMBbL6r/7kJHZzSUm0itcjzqURLKS3Dbv5udJ+/bI+z4VOIgFQiyFiE+7Y8WdETNUej
         KrIooiJiq+WemE4jtYXRSIJiGAS3ynfheWuzlYvRMRfPYaEidj/g7CSqMk80NJf36TyK
         pXExvbqcQKLHNaGEsPHnULMdT/Dp3yO0MpORMi9gp6M9WnuvRheW0hB5T4rOnEAlocvM
         JgwmzqwkL7I0izvG6DBpsqf1qgZDqVa0yFRZjm5viDllx5MP6m8LU1Bc1h0fWHnzrJ0M
         X5xw==
X-Gm-Message-State: AOAM5336Iz6SIsJ+iFY1B0sjF6tP7sttiurH0zNaNQ5tLyDkfqZdnChT
        CGF1pyYYzh4HffA1eTYUMRE0I8JiPMS1kflfFe67bysmwn5a5Dxrc/7S/iqd0OIyvA8Xj1JfkJg
        ZunwKksphyM3x372bV3HMLIixwmUrfrLaeg==
X-Received: by 2002:a67:ef94:: with SMTP id r20mr6640878vsp.36.1622205736336;
        Fri, 28 May 2021 05:42:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc3my6SxlXZaZfhHX7W+xfeFllcqLbI3WOn1B07accNkRCVFE7nIIADJby3arfB1ew53uXBw==
X-Received: by 2002:a67:ef94:: with SMTP id r20mr6640861vsp.36.1622205736180;
        Fri, 28 May 2021 05:42:16 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:15 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] nfc: mrvl: skip impossible NCI_MAX_PAYLOAD_SIZE check
Date:   Fri, 28 May 2021 08:41:54 -0400
Message-Id: <20210528124200.79655-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nci_ctrl_hdr.plen field us u8, so checkign if it is bigger than
NCI_MAX_PAYLOAD_SIZE does not make any sense.  Fix warning reported by
Smatch:

    drivers/nfc/nfcmrvl/i2c.c:52 nfcmrvl_i2c_read() warn:
        impossible condition '(nci_hdr.plen > 255) => (0-255 > 255)'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/i2c.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index bafd9b500b2c..3c9bbee98237 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -49,11 +49,6 @@ static int nfcmrvl_i2c_read(struct nfcmrvl_i2c_drv_data *drv_data,
 		return -EBADMSG;
 	}
 
-	if (nci_hdr.plen > NCI_MAX_PAYLOAD_SIZE) {
-		nfc_err(&drv_data->i2c->dev, "invalid packet payload size\n");
-		return -EBADMSG;
-	}
-
 	*skb = nci_skb_alloc(drv_data->priv->ndev,
 			     nci_hdr.plen + NCI_CTRL_HDR_SIZE, GFP_KERNEL);
 	if (!*skb)
-- 
2.27.0

