Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624275A0F13
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbiHYL33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241526AbiHYL32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:29:28 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3EAAF0FB
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:29:26 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u5so16403956wrt.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=pvYI8qCHeX2hzimY5iZ75icinfdJvwYKQum42Zqlb2U=;
        b=UnWEaMN+2C1WDnIL3Xl7DPuGcLPStIXZxmNBxtSyIPPSziPZ73FKJEyiig64Yy8j85
         KQSyyILccxe2XsV9YaVbhEOX4iyiI26EIceaOpQZ+g+HG/o7fS4Kgr1vL9szV1ZFGtEp
         d/1iWwUEe7tthjnCXZ/p/xvYa0IzvfAfomuOp0cS+6lqxxgvS08c8LmxAYSixfiVKMNy
         OzEflaqfnzZ1kg0NuI2DpIlskXUYic7Q9bSLn7iyqUEec9GCKPVFA+15pcnA8xk2ilL8
         6KS9Jz+Z+T0Z881Cqr0Pvmtjq4evyeQrCKUtEDUm9I/o5ZZ4EoIrff1RZLOsBxSTM4iK
         lDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=pvYI8qCHeX2hzimY5iZ75icinfdJvwYKQum42Zqlb2U=;
        b=kOp+e6CvG4xZq3L2KCYi8pvtwBSNNohx5X+I6pPCeXZsAWY2X/l/6SF2pkKPxJ4JoZ
         fjfT4Tn6jopwN86fpmMRM2eawPzx58EK2pZY80XglB1W/wuBzuqw43lanhg5R1LsKCRY
         UzyUo2Vsb8UaHPDscFQABoe2D4rFsGRP8e4uNelcan2xbI1Cp7K+abukorlFm+LJUaWi
         G3OHeKTlEU9koUxWO5H3Q+wJbLI1zRdLLELwdH4Z9e82TrfP0RFvabFj2Qs9EAZ3PXnx
         cN8ntMCE9Yd3Ss1MwqU7NJ4nr4xpJOYQq7ZMJsIL1DXmdTefE7uYVPMF+dglX/lOHTAR
         GF0Q==
X-Gm-Message-State: ACgBeo0VB9MxrOk3aqG5uTDW2Yk+aYWAM62wMfIyMcEQQ3M6GNK72mKf
        ViXSmZZA4+BWpqc2yBdHJ0l3HR1q5ont4kUk
X-Google-Smtp-Source: AA6agR4Bpo4M1PcfAF1NcP00r3EDz0oMbs9d+dNw57dxKN6Vwa6BzEy/a47GxUHx8HsQ61dJIjj1zg==
X-Received: by 2002:a5d:64a4:0:b0:225:6cc5:5ca5 with SMTP id m4-20020a5d64a4000000b002256cc55ca5mr2080130wrp.436.1661426965181;
        Thu, 25 Aug 2022 04:29:25 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e11-20020a056000120b00b002206236ab3dsm15751880wrx.3.2022.08.25.04.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 04:29:24 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] net: devlink: add RNLT lock assertion to devlink_compat_switch_id_get()
Date:   Thu, 25 Aug 2022 13:29:23 +0200
Message-Id: <20220825112923.1359194-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Similar to devlink_compat_phys_port_name_get(), make sure that
devlink_compat_switch_id_get() is called with RTNL lock held. Comment
already says so, so put this in code as well.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6854f574e3ae..3b4dc64eaaae 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -12339,6 +12339,8 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	 * devlink_port instance cannot disappear in the middle. No need to take
 	 * any devlink lock as only permanent values are accessed.
 	 */
+	ASSERT_RTNL();
+
 	devlink_port = netdev_to_devlink_port(dev);
 	if (!devlink_port || !devlink_port->switch_port)
 		return -EOPNOTSUPP;
-- 
2.37.1

