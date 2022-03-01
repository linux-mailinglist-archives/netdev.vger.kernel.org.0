Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D024C863B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiCAISn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiCAISk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:18:40 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC69E0DB;
        Tue,  1 Mar 2022 00:17:57 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id jr3so1776914qvb.11;
        Tue, 01 Mar 2022 00:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/9cWyhTY1JANz1X29vJp7nAVb49B2jaNSOIGWS3uGg=;
        b=BSY4T9+Lwm/mgKh/qJKEDXLM7olKe9GbgVkog27IJ1Gn1PwRQ32L/1zREs9959WUnW
         i8VfcrDGYFa/FfvHJvICfayzrhf+yIUzYEdpfnvW8FN2SCNpaqWYdroKFQccBPtcQfJa
         YSA2X8Lsoj42B6loBUaUPg32zo/ud3+U3+60CkwQjOvJi4LcgdlEhPSa4RzZXMSutCzg
         8aMbRX1AzZZaXKojfXJNo9aZLqF5ULjjnvjqXIOzRC8f27DOZ4QRCFxbgeL6zZ7FkRMR
         RHe0gPhtEEmCNXBhp73wBHwVm2zmsDBBdd9tFg0nXkAJNUl5KLJ3bH69Ig5khtpsnhTW
         3FTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/9cWyhTY1JANz1X29vJp7nAVb49B2jaNSOIGWS3uGg=;
        b=Y36gux5JBiErcfLkIetz7RG66l7klMf0zyXSGeGml9x4KsG9g2Qt3DPVN2kX4ZjVDR
         LzJqVknj1qs1Mz49Iea4RpEE+aSKk2tEou0Ki9w0hDJ4esaUbMjRPdNOvhdLt1ADvRU3
         nVMyye7AMCIvBkKW6/yA/vXy4/7CPMZ3tFq+S0SWrNshsJ3xQR6voq4QdPwenZFb7EU/
         3lgJodlZMg0ye48LMyiTXd5X5nJf/Co+7dEZUQPG6PdAXSRzroq8eQ2j8Oh6e2oXc8GK
         unct3WCcmif2GLz4Bj49jly/4Z65VGoEZdw6pD4yOatSNVcCJNV5z/xCQRZ/TLkF9FFr
         Lqiw==
X-Gm-Message-State: AOAM530Qd5nGcdpl7RbTedrqH5se03KebT1XyADJWAGox7KnGt8wMzoC
        Nj3/KLihuqh5rBymhEMDDEs=
X-Google-Smtp-Source: ABdhPJymlE8dqN2UNAK/SYjTXYrYRw9T67dkeL3D1Qmx79ZUJDl+/Yfu0KSRS5fbAagvKv9yIObG8w==
X-Received: by 2002:a0c:9029:0:b0:431:37ad:c8d2 with SMTP id o38-20020a0c9029000000b0043137adc8d2mr16269242qvo.71.1646122676895;
        Tue, 01 Mar 2022 00:17:56 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d15-20020a05622a15cf00b002de711a190bsm8815112qty.71.2022.03.01.00.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 00:17:56 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     krzysztof.kozlowski@canonical.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/nfc/nci: use memset avoid infoleaks
Date:   Tue,  1 Mar 2022 08:17:50 +0000
Message-Id: <20220301081750.2053246-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Use memset to initialize structs to preventing infoleaks
in nci_set_config

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/nfc/nci/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d2537383a3e8..32be42be1152 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -641,6 +641,7 @@ int nci_set_config(struct nci_dev *ndev, __u8 id, size_t len, const __u8 *val)
 	if (!val || !len)
 		return 0;
 
+	memset(&param, 0x0, sizeof(param));
 	param.id = id;
 	param.len = len;
 	param.val = val;
-- 
2.25.1

