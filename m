Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2166569AC
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 12:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiL0LDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 06:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiL0LDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 06:03:50 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC50EA477;
        Tue, 27 Dec 2022 03:03:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so16956802pjj.2;
        Tue, 27 Dec 2022 03:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rgu6mM4Jqs66vBJ1eVaVAeL/gltzz7QwmhdjdBu7Ti8=;
        b=QpPu3NphcdtA7vXQLMbNoD05acMughBTynihyWef+NBpXlxok81SW4MrpqCjkLO/ll
         Y1Ri8WqDZYc34DNVw+iekBqZKPLaKFnJI2USEFOYR+bpq6uFTPTHgaYcfQfI9PViD0w6
         r1HZWRxqNE2aKgh7jyEJ0XhhVaruVRF9tAM/o21IZdoQISAv80BJmz/BVh8cbKCIY1Gz
         nQflNgKwfwPCABJiRwCeptducnWEu7hoDOOGLTUFlwG3bFhq0IJvuzlrSwudILWh7ozN
         pKbZ5yy51+Jr2qVTTFJWnpVj3PVLDhM5Ktw5sI6YLzACmWgJ36m/vMMf9tFYVYi/CfOM
         LJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rgu6mM4Jqs66vBJ1eVaVAeL/gltzz7QwmhdjdBu7Ti8=;
        b=jiSwo43LayBaBCIzvLj2iF1zRo0+PpVv8vYxDv08RidcSA8b5eFeD7LO9NuuHku4TD
         KQ4+pQB1Kequ2FzeKPVUAChOz/BQPYIeQp2MBqLm8k0JbebWxpsXZx8svxqYxhGRdSuZ
         HhKG4KiYZeoVRZWn2PEDe3QVbNE3Igh4YNQwxqdirgXPCPlYc74UClGqp93MkMtuCuvD
         vFwowMQVWa8RIJpP7DjAMJpNe9eYx7V99rmTXiaXUEV4IdUqag2W/bP6MCj2MuMbNFjk
         ZjwbfAV0NLZqObI4BXyX1nANIs1saeGpsYdjrlfrcF94laoL5lRlw7u8jnGeY4fbdb/H
         z+3A==
X-Gm-Message-State: AFqh2kq3gRu28ZH1SY3mhZYFm/6q4UFZtM3hN4mDLsqnKjvKTHDx3joe
        OhC26K3IR0tmrdNg3JK+Mru4yvi2hGMB/w==
X-Google-Smtp-Source: AMrXdXvt9yPn1cy8MN+ikp3ZONU+ZMLcpJUo5lIDJXXhd7CslhLFPhhX3tyRKqdD1b3S2FJYUICq1A==
X-Received: by 2002:a17:903:1c1:b0:191:271f:47be with SMTP id e1-20020a17090301c100b00191271f47bemr35769960plh.35.1672139027479;
        Tue, 27 Dec 2022 03:03:47 -0800 (PST)
Received: from carlis-virtual-machine.localdomain ([156.236.96.164])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902714200b001865c298588sm8683764plm.258.2022.12.27.03.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 03:03:47 -0800 (PST)
From:   Xuezhi Zhang <zhangxuezhi3@gmail.com>
To:     zhangxuezhi1@coolpad.com, wintera@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390/qeth: convert sysfs snprintf to sysfs_emit
Date:   Tue, 27 Dec 2022 19:03:42 +0800
Message-Id: <20221227110342.1436070-1-zhangxuezhi3@gmail.com>
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

