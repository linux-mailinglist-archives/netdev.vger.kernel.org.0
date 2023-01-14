Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646EB66AD44
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 19:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjANSYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 13:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjANSYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 13:24:10 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07547EE3;
        Sat, 14 Jan 2023 10:24:08 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id f34so37405032lfv.10;
        Sat, 14 Jan 2023 10:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WHI6tGRe0cD63H1ZI0cQg/EKz93hem5gCf2mi4XYKxU=;
        b=JeTS+Kks5lelgY47PuxV8p9YUYtL+qgIwzrJPdgD3gcJRUEjX3oVMu8t5gzT9yD5zM
         61RZkoxAzYY+oq/noeWJX7jwk7Jm5EXE+yQ8jXK4gIVUW3gpN/jxZ9o8kahBxazwVd7Q
         JLcCj3SbH+OK7yCrc7ipwTU/xwAxpyHoEmwKu1hZOX8TrmgryUnsYKRz6a6Do6YsVGRu
         sYmyLlGg8K3wer4r5JKBE3x9av9dAwoQgz3zFLGEPPXgVYHRMkYQEdu0UxgD1OT2dN+6
         eSIR8+Wy9Uw/zBPs9t56rzxgSedCnQYSnPrA8MRmSUZk/rywBywXRdDNaTXFruz7CiM6
         Bebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WHI6tGRe0cD63H1ZI0cQg/EKz93hem5gCf2mi4XYKxU=;
        b=yvGyQTYRURkvBKCdDag3PyqTr8xNm1yEaXzHL2JVkQNJHqVSQy79F2+/99tnriSLan
         8cftrmCgSzUCLRbVv4TFdKfXQFgPkPqVdoh2yGDzEJxukaS4vl6AbhDff/VCYj2HWE6c
         YiOTWoLytva5AFS+dXb0GH6S9LrNuEEICfJbrqdCIPBFF7HmZZ2ZKRLppmXdIOsrJIdj
         tMKSdzJvnhenT2El6mcpQCcmXJ8W+zwOuXiElsNdMI44HSbYviEO/Ii5sapnQRDJ7qOp
         lo6NWrljkA74IkzRu852QysOO6Mmj+1P7kLlctOCNAXoMllC2MpyIsquwVw0cutBEoqa
         iLng==
X-Gm-Message-State: AFqh2kqC2nB0oPCzKv3pFdh6WUpdySlQi0N4yjOPDZNMvBQK9cN9Wm6g
        HCW2YQrBMAgUHlD0rfjOP3g=
X-Google-Smtp-Source: AMrXdXv+LMxlwjN2wZ8qnuZBk2vQ7BkL5DbqOm8b7YkPOp3d2vJDk3jMXqCLOof+jvQs29r3+hKWfA==
X-Received: by 2002:ac2:4f13:0:b0:4b6:f3b3:fe14 with SMTP id k19-20020ac24f13000000b004b6f3b3fe14mr23441066lfr.1.1673720647204;
        Sat, 14 Jan 2023 10:24:07 -0800 (PST)
Received: from localhost.localdomain (077222238029.warszawa.vectranet.pl. [77.222.238.29])
        by smtp.googlemail.com with ESMTPSA id t5-20020a05651c204500b0027ff129de9fsm2983883ljo.24.2023.01.14.10.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 10:24:06 -0800 (PST)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: sr9700: Handle negative len
Date:   Sat, 14 Jan 2023 19:23:26 +0100
Message-Id: <20230114182326.30479-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packet len computed as difference of length word extracted from
skb data and four may result in a negative value. In such case
processing of the buffer should be interrupted rather than
setting sr_skb->len to an unexpectedly large value (due to cast
from signed to unsigned integer) and passing sr_skb to
usbnet_skb_return.

Fixes: e9da0b56fe27 ("sr9700: sanity check for packet length")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
 drivers/net/usb/sr9700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 5a53e63d3..3164451e1 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -413,7 +413,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.39.0

