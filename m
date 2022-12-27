Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE2D6569B3
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 12:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiL0LEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 06:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiL0LEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 06:04:02 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46526AE45;
        Tue, 27 Dec 2022 03:03:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t2so12952402ply.2;
        Tue, 27 Dec 2022 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rgu6mM4Jqs66vBJ1eVaVAeL/gltzz7QwmhdjdBu7Ti8=;
        b=YGv2EoxKtGKsK4vzLZZ9ZDdUasxdFDHKXA1DkT8M8nbn/CkOUehjMVv3gb0XGgr/u+
         fapTR27fbCWbAn9Ap4MNFrAmssqFjEMqe7ZpnjUwRtKXhTZs8dHY8sAVWqPkVi004gKm
         QhaTKvgwbn9zZzZVKsAVyZg1tyhk8qtjieFxXuTz4qIUdlCm/XTTBsyAZmzrBlY6BwiY
         sluno+rvfAC3FKpa5uI7Zhxpmhg95Vk2cfJ6xKgBPmVTrlcoKyc1hE3TZmUzT86eFef4
         j+wOaIuJzuttpsNKXJ7MtPXOeTEWeqguOqNUsxrOMhPDYvkTiWrPQDZ6cnrtfN4PEKgU
         hQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rgu6mM4Jqs66vBJ1eVaVAeL/gltzz7QwmhdjdBu7Ti8=;
        b=ZRiJvnlG0Y5wKuirDLsy35Cby/OJZh/2dSOA+U89eUVJVDK0Mexb5YVde8UZFyAZjv
         uYIL5/aSO8yBLZw6AymzfRt5qAd4Lx8CPF8u1xM8mXV65KESLsqHrlRSJvklqjW0MkD5
         VYYzy4GclSMH0W4UaP6n3hgxsN2nxp8s+BbpjVGmoD8HW1kahDAjrZBmY2AmIKEarvhL
         gf+BflKS1JsIL/QGN/e9sd2pR4ivX9MBW+pTp4s1DWu1F7wuzVmAUwWfZPjDSI3vN0s/
         AmfjLaHWWGEmF013fea7tXhvUI7XEpJ4v4NZ/cd9CMW45Msn5Ez1eywXzxhXlEODAHZu
         hqYg==
X-Gm-Message-State: AFqh2kqq72CGzKlAPFZGaPkfwnbJLaTyc1oKPWI6dTvst3RQzg9JMz+m
        j9BCqUem/zLOP996Zn9wViS1ikH4gK0FDg==
X-Google-Smtp-Source: AMrXdXuz++twZ5maPvpwAmAyHMKpEoujELivOJCY8XWaNVyFLdaTCW5fvWeg9kn0Q+oB4RTTVlU5wg==
X-Received: by 2002:a17:902:d590:b0:192:90b1:9007 with SMTP id k16-20020a170902d59000b0019290b19007mr345578plh.27.1672139038467;
        Tue, 27 Dec 2022 03:03:58 -0800 (PST)
Received: from carlis-virtual-machine.localdomain ([156.236.96.164])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902ea0100b00178143a728esm8816103plg.275.2022.12.27.03.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 03:03:58 -0800 (PST)
From:   Xuezhi Zhang <zhangxuezhi3@gmail.com>
To:     zhangxuezhi1@coolpad.com, wintera@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390/qeth: convert sysfs snprintf to sysfs_emit
Date:   Tue, 27 Dec 2022 19:03:52 +0800
Message-Id: <20221227110352.1436120-1-zhangxuezhi3@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>

Follow the advice of the Documentation/filesystems/sysfs.rst
and show() should only use sysfs_emit() or sysfs_emit_at()
when formatting the value to be returned to user space.

Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
---
 drivers/s390/net/qeth_core_sys.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 406be169173c..d1adc4b83193 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -410,13 +410,13 @@ static ssize_t qeth_dev_isolation_show(struct device *dev,
 
 	switch (card->options.isolation) {
 	case ISOLATION_MODE_NONE:
-		return snprintf(buf, 6, "%s\n", ATTR_QETH_ISOLATION_NONE);
+		return sysfs_emit(buf, "%s\n", ATTR_QETH_ISOLATION_NONE);
 	case ISOLATION_MODE_FWD:
-		return snprintf(buf, 9, "%s\n", ATTR_QETH_ISOLATION_FWD);
+		return sysfs_emit(buf, "%s\n", ATTR_QETH_ISOLATION_FWD);
 	case ISOLATION_MODE_DROP:
-		return snprintf(buf, 6, "%s\n", ATTR_QETH_ISOLATION_DROP);
+		return sysfs_emit(buf, "%s\n", ATTR_QETH_ISOLATION_DROP);
 	default:
-		return snprintf(buf, 5, "%s\n", "N/A");
+		return sysfs_emit(buf, "%s\n", "N/A");
 	}
 }
 
@@ -500,9 +500,9 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 
 	if (card->info.hwtrap)
-		return snprintf(buf, 5, "arm\n");
+		return sysfs_emit(buf, "arm\n");
 	else
-		return snprintf(buf, 8, "disarm\n");
+		return sysfs_emit(buf, "disarm\n");
 }
 
 static ssize_t qeth_hw_trap_store(struct device *dev,
-- 
2.25.1

