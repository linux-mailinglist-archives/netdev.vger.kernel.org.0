Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B790145D541
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243105AbhKYHSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353064AbhKYHRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:17:32 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A11DC06175B;
        Wed, 24 Nov 2021 23:14:22 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id p19so5247354qtw.12;
        Wed, 24 Nov 2021 23:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U/cuKmRO20+eqlG5CDZBR9jfU5oioiAoXluC6pwequU=;
        b=dOktFrbJDD8oQEc1+5jijc9HqTOh4F20rD2vd9tBd5C4Ga3jE6Bc5Ox+PT+R+PYfX/
         NkfrDpQiT5YPbCTkmSuuPMEKvhuOxUrA7EVq3RrsiKKXk34ennlVrAE3TMRvDS0UW6wo
         JGch1NgjlcRBY+FWtefsZ7jI0NHcO7sx35j3Sq3Kym089SfcN6l51LMCvViCKBRUCr87
         l+qfUkcUKVJD353v/+8bAh+IySDm+yiE+vllR4g9uWZRca2lmfemkoWIxxZ5YHUUVL1H
         g+WPdFVFHIwYTlS3H8eIHWi1yWDNOYLXczVCAHUrKHLTUtHmxJIFqKrXpUIbJmGMN9ZM
         XQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U/cuKmRO20+eqlG5CDZBR9jfU5oioiAoXluC6pwequU=;
        b=MWeCrcwrwrXeGytxuBbBsMnZAu8H++H6GeQYBtK12KyUIxJm23YrAVT3m1JipJh3t6
         qXCw90flpzDtmKee7vFyAu8FL1sj3Mour8OLO4gN6XbJvN0LJUyHHzximGfLlMnZeKGa
         uijOvk+YPNQ7OdF+iqb7T21VFf0Sb7yBYOpYZoS2UGMiJDgjjd2F8sl+Vq/5Y/AejE7W
         6cAZJDlhH5N0XQ9JHOu9TrVKkZEybf8sxYhtkNCJv2YUgT+lxzPU6natpZEo+KoneN2k
         EwxTjvWyz8H2iVI7/sjFTtO20hHDn/qxWDZm8OGv2Zg/+8568jEfAVjS7Ng8WvWgouKM
         ZNeg==
X-Gm-Message-State: AOAM530/6ZeC7VhYuWjpb2ShsSa9u1GxRwQAy3tqw9M9NZA+8Ol4FGFR
        nP+DgOHA3DqcW4rA1ctZVIc=
X-Google-Smtp-Source: ABdhPJxArg/eurNFSt82HIaFwNiZ0PpEK1CU292WdYSvvUYG8jLGroK8tSKDP7qx5cI8m2cmwXlSsg==
X-Received: by 2002:a05:622a:130e:: with SMTP id v14mr5603515qtk.458.1637824461352;
        Wed, 24 Nov 2021 23:14:21 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l25sm994981qkk.48.2021.11.24.23.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 23:14:20 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     jiri@nvidia.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] devlink: use min() to make code cleaner
Date:   Thu, 25 Nov 2021 07:14:14 +0000
Message-Id: <20211125071414.53147-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

Use the macro 'min()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 net/core/devlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d144a62cbf73..6ffbbb02fb91 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/minmax.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/gfp.h>
@@ -5763,10 +5764,7 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 		u32 data_size;
 		u8 *data;
 
-		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
-			data_size = end_offset - curr_offset;
-		else
-			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
+		data_size = min(end_offset - curr_offset, DEVLINK_REGION_READ_CHUNK_SIZE);
 
 		data = &snapshot->data[curr_offset];
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
-- 
2.25.1

