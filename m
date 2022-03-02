Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7404D4C9C2F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbiCBDd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCBDd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:33:58 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FD38BF1E;
        Tue,  1 Mar 2022 19:33:15 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id j5so546992qvs.13;
        Tue, 01 Mar 2022 19:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9cnZV/yqSL4Et35xPbvGprEKId4yvGvmxh2X/V5hg4Q=;
        b=d1PIC7Asf0dJRR7WzEu0YcygafYbaA129uZH8XQ/Sq/zQcSTvH6mxp3TS6wvFIDtMA
         J73lwh7mf84VAZjNQ/yvb1pqin/ULoUBIyjMaSR1bTuOVgS0uqVAV8QedidVwgnhUOmz
         +AOD9uicSAnZitQ6vF1FPEfZOWB5kLeElwzBOTgKXWVLNdNgxANM71ksKmcrPKzVzXrK
         QYFU6xCKPr7NujA5fQT9qAUK1l32T0CP27H60kx6XlWjvV5hHu34HQ6PMxIqTO3cqabc
         YlzAKxFfS1MiKuH96YSqLMyKufM8Y7TABQtuv47BSOPdX5oC3aStL5s/lUIdJ+0boIcA
         Ijjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9cnZV/yqSL4Et35xPbvGprEKId4yvGvmxh2X/V5hg4Q=;
        b=qkWnDEDUiyfsXlmO99GiGmyoHibZD9Z8MmSgAkxHaa0LGf1X9UU+ug86N1KeCwo81a
         tMNGMnJ66b06Y3jyHNLJekgVQ/f3JG6NDFUQki45J6aovS5raTaWzcfaB8HcCn92GUCA
         j2vVjnCayzxPwzouSveQB0cIPg9vWeUmgBfdhAVW3Ix8xKakKZgMUZF1I6o3UckcStGw
         J+nGuG8zeDtECpiWnzAMyld4R2WhGkbGMRV2q4ljaHa9hgoBKlT4DueGFRkXx3ubaX+Z
         +5NQPSOeQxHRso1aToc+zH+Gk9ydvwP2FVsSpQnz3N681pVcj1YrswiugwmUZPfNr18w
         /HTw==
X-Gm-Message-State: AOAM533mGE2LGn7eavZFqDLnGMauN52+C95ywcanTt9j6G3HZ3LrK7GS
        cgO+mDzZNLrVd0+GTdEQP04=
X-Google-Smtp-Source: ABdhPJxNxn1wQ/ZO1kE7oJWiuVmBywJBkwZdtLFcJdiL182h9QiclE84rdX5aaMOwSx5BUrOOvalww==
X-Received: by 2002:a05:6214:1c84:b0:432:6dd5:ba71 with SMTP id ib4-20020a0562141c8400b004326dd5ba71mr19804822qvb.109.1646191994516;
        Tue, 01 Mar 2022 19:33:14 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g7-20020a376b07000000b006492f19ae76sm7596971qkc.27.2022.03.01.19.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 19:33:13 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     krzysztof.kozlowski@canonical.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] net/nfc/nci: fix infoleak in struct nci_set_config_param
Date:   Wed,  2 Mar 2022 03:33:07 +0000
Message-Id: <20220302033307.2054766-1-chi.minghao@zte.com.cn>
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

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

On 64-bit systems, struct nci_set_config_param has
an added padding of 7 bytes between struct members
id and len. Even though all struct members are initialized,
the 7-byte hole will contain data from the kernel stack.
This patch zeroes out struct nci_set_config_param before
usage, preventing infoleaks to userspace.

v1->v2:
  -Modify the title.
  -Add explanatory information.

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

