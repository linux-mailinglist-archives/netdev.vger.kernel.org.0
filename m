Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63584BEBE8
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiBUUgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:36:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBUUgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:36:08 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62AA237CC
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:35:44 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u1so29030686wrg.11
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XlzX9gDy4XjD1q8Bv6zI2a9b8+oDi1jGLfGPO3lK4QA=;
        b=ErgE3hl6pB2qeUes/BQtqtdPE+0OgQ2ciDaS+K+37IX27VhVWyVl5wQ+sNp2uFtdSI
         VEsmonrdZ4WskwvCNc5yHAQeBgJbZAiISxYS1Ol272lQpg7zGwhcsG0HuQfBEneMkJet
         JMpdP0lPmjSPszfRjtGf6011po1WcyvCyNu0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XlzX9gDy4XjD1q8Bv6zI2a9b8+oDi1jGLfGPO3lK4QA=;
        b=IvgZZHDruoYjqERocDz7T0+f0YprOZprEsJ7dDh9o3H2/OfQGrsH37VzUr5NWkVTUs
         YgXDn/fGDUR9ZAWLJYpH5q/oQ/7zeoxLImBAnLyljldwFQXrgChWP9nMjJonAgAtiSZZ
         4kLXfHhN2mRhANfNtRrjqWCv1/JxX7MKlrI5n1gW0D+w4Xc8IvFHHic+blW8ujryN6ZI
         YU0T0en82T9t7vRi5pgnJ4hjdQrnxC3iFl5phqRWSSCnvl1tWBx5hbxw/wyfbVacRhby
         afOprnA9U+DtbY3I8vo1dXeRdTSC2dfNEzunIW4+HFdhipFGzJ63sXThathu6JWxAwN1
         jOfQ==
X-Gm-Message-State: AOAM531OoB7mrur1DL8Z6R+ux7XZ4a0ddHVr7AmUdsVr2NK4gCZz8YJf
        yAN3U+kM6tNiljZzHVa1WDSwfw==
X-Google-Smtp-Source: ABdhPJzvvmtJ+9B1GaTk+STcgmWeNruO76Gbv8vjsh/To+Ojd0Y/wS1prszpFloSPh7yaI8DmfoQIA==
X-Received: by 2002:a05:6000:15cb:b0:1ea:7db2:f5bb with SMTP id y11-20020a05600015cb00b001ea7db2f5bbmr1382967wry.709.1645475743321;
        Mon, 21 Feb 2022 12:35:43 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id z24-20020a1c4c18000000b0037bd7f40771sm340380wmf.30.2022.02.21.12.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:35:42 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: dsa: fix panic when removing unoffloaded port from bridge
Date:   Mon, 21 Feb 2022 21:35:38 +0100
Message-Id: <20220221203539.310690-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

If a bridged port is not offloaded to the hardware - either because the
underlying driver does not implement the port_bridge_{join,leave} ops,
or because the operation failed - then its dp->bridge pointer will be
NULL when dsa_port_bridge_leave() is called. Avoid dereferncing NULL.

This fixes the following splat when removing a port from a bridge:

 Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
 Internal error: Oops: 96000004 [#1] PREEMPT_RT SMP
 CPU: 3 PID: 1119 Comm: brctl Tainted: G           O      5.17.0-rc4-rt4 #1
 Call trace:
  dsa_port_bridge_leave+0x8c/0x1e4
  dsa_slave_changeupper+0x40/0x170
  dsa_slave_netdevice_event+0x494/0x4d4
  notifier_call_chain+0x80/0xe0
  raw_notifier_call_chain+0x1c/0x24
  call_netdevice_notifiers_info+0x5c/0xac
  __netdev_upper_dev_unlink+0xa4/0x200
  netdev_upper_dev_unlink+0x38/0x60
  del_nbp+0x1b0/0x300
  br_del_if+0x38/0x114
  add_del_if+0x60/0xa0
  br_ioctl_stub+0x128/0x2dc
  br_ioctl_call+0x68/0xb0
  dev_ifsioc+0x390/0x554
  dev_ioctl+0x128/0x400
  sock_do_ioctl+0xb4/0xf4
  sock_ioctl+0x12c/0x4e0
  __arm64_sys_ioctl+0xa8/0xf0
  invoke_syscall+0x4c/0x110
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x28/0x84
  el0_svc+0x1c/0x50
  el0t_64_sync_handler+0xa8/0xb0
  el0t_64_sync+0x17c/0x180
 Code: f9402f00 f0002261 f9401302 913cc021 (a9401404)
 ---[ end trace 0000000000000000 ]---

Fixes: d3eed0e57d5d ("net: dsa: keep the bridge_dev and bridge_num as part of the same structure")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v1 -> v2:
- replace trailing comma with semicolon *facepalm*
---
 net/dsa/port.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index eef4a98f2628..1a40c52f5a42 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -395,10 +395,17 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.bridge = *dp->bridge,
 	};
 	int err;
 
+	/* If the port could not be offloaded to begin with, then
+	 * there is nothing to do.
+	 */
+	if (!dp->bridge)
+		return;
+
+	info.bridge = *dp->bridge;
+
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
-- 
2.35.1

