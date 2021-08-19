Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A303F2115
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhHSTxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbhHSTxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 15:53:39 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DCFC061575;
        Thu, 19 Aug 2021 12:53:02 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n12so10492101edx.8;
        Thu, 19 Aug 2021 12:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL02EH4U27OoNA/U0vdcgLaKOgzicMCVSFoibIBTSqY=;
        b=jegj1+iUV+OYa0nLxvTj8NqDQWtDg+bVCVX/DXeMAqEepPR42MGZkvVHLwn/bsF7o8
         0e/iFwkWNoFB7tiBlX4gsUPZ3e+LxJjTo/yuGB6rTdbqw7ng8Y9M6wiASMKpBp5D5OHx
         Q+Yyvae20b8s+yvBCiGI48BhNTZi+LScYkgy0To/a30BCJljhtLiWWjGYOkZqgQzmAmz
         niAPmGz+MG5ffgMp6bDJGMqraAeh8D94+A2PEeXKI9gaAv1eSTqAhmc1y1XPwxYnRnrd
         Cz1d6Yw1a9YeFSimnDEJJIQr6X+674A9QgQVt60mD4cdt9pUJWLD1ng4AThWGEgfjumn
         4r2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL02EH4U27OoNA/U0vdcgLaKOgzicMCVSFoibIBTSqY=;
        b=Su2YYsYttvPgWuKdnjvD+7uCBryXxlefrioVtIrex7eaowPtwsYK4jaBaoFhpk65Aj
         KZTdrbSrXoN3Z1MUfd5UARl+CiCIxQGzK/BERgP5jonnZUH0LMEesrZ2Ay+o37vlenn2
         jJX+FDWCGP8mfcrf0UaeBo1osweR+nbqqhbesAcGAQbIDMlX1z0QtCtCEr1VKpobrAD1
         X+FtFrMmvTDbVz3wT99iUdhRJe/UD6Q7Fl7dv0Ld+tz+5pTEe5MfH8A+bTnAAFnCyVts
         x1zQTj1wMbED3FtNm/eWPfZRCjNn6RznuXCjG5uYjaWJRevYIABmn6QoJUuJZ652nQUk
         DvAA==
X-Gm-Message-State: AOAM5304hjlgktDrnsGMO2vZ2T1ILQkov2OhTKbRbBnU9l7klrFqAzVC
        xxL4INaDbN2w3/nkgaCOtHM=
X-Google-Smtp-Source: ABdhPJx5c+3atR0akUSCvQH9yGfSDZgLsl3iVICHWV+CAbHlA79L62zT9M6X+mAZM5o/pFaAMkBIBw==
X-Received: by 2002:a50:fc96:: with SMTP id f22mr18626056edq.367.1629402780891;
        Thu, 19 Aug 2021 12:53:00 -0700 (PDT)
Received: from localhost.localdomain (185.239.71.98.16clouds.com. [185.239.71.98])
        by smtp.gmail.com with ESMTPSA id ck17sm2284984edb.88.2021.08.19.12.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 12:53:00 -0700 (PDT)
From:   Xiaolong Huang <butterflyhuangxx@gmail.com>
To:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>
Subject: [RESEND PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
Date:   Fri, 20 Aug 2021 03:50:34 +0800
Message-Id: <20210819195034.632132-1-butterflyhuangxx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This check was incomplete, did not consider size is 0:

	if (len != ALIGN(size, 4) + hdrlen)
                    goto err;

if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
will be 0, In case of len == hdrlen and size == 0
in header this check won't fail and

	if (cb->type == QRTR_TYPE_NEW_SERVER) {
                /* Remote node endpoint can bridge other distant nodes */
                const struct qrtr_ctrl_pkt *pkt = data + hdrlen;

                qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
        }

will also read out of bound from data, which is hdrlen allocated block.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>

---

Reason for resend:
1. Modify the spelling error of signed-off-by email address.
2. Use real name.
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 171b7f3be6ef..0c30908628ba 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (len != ALIGN(size, 4) + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
-- 
2.25.1

