Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C864BEBB8
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiBUUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:20:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiBUUUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:20:13 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A06717A87
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:19:48 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id i19so10138934wmq.5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRYfBT7+YvPhgwvqbULWJpR1FaB2CXS8XAOJTniZzJ0=;
        b=Nz7JRt9+gUUEoCpSMIxeNgs57Qs4+F9d9kczEkKJqch+3gAyvgcOne8iEw4BzPftoK
         XjcO4rRzmjamT0awd61BrUHgXMUpj4CIz6YClD+E1MywZrQBZFam32NHBsyfsrnj/n/k
         bgPDTlHazLD5IYI1ujRemiD+wJRxRsGXZyHHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRYfBT7+YvPhgwvqbULWJpR1FaB2CXS8XAOJTniZzJ0=;
        b=SZPS8bVUwTUsbx+xj9oU6wISmA00huVNLKprN5E0j0t7Bs4wXe97YPtoHa/PsZ3Up4
         eBepxKdixMmCtIOlYJZMwQr3N9sowOPYkmyqiYUz2quoCYw+DqVYaFDpEjhOLuXPpFj4
         YzF9Nhk26am0PHmAkCHf9Yz91W2iHKicZJrWx1fHeUnfBW6hpavG2+A60RP031cZuylO
         koHfE0NiB0L8or+9qfuumtkt6d+LWCJKAEGEZhSNoxvrlWmRXgyEnoZk8/IN6X13Z1/5
         PCoILOII2LcffOg0DQh223QIiK9GUXgWxT/DZGajil4c7MPg14nInT+Q9ICHRPhfcAwE
         v8SQ==
X-Gm-Message-State: AOAM533BmrO8oyYaSF+5gkiNR2gioFqUEu0be7oT6VYnuz5nOAPY10p/
        mzrffaCeC04cubl6YCW226dryA==
X-Google-Smtp-Source: ABdhPJzbyysYv4K2J8uCVgKrzj1ioT5n2LsRIQCL4yD0W/+uxQaHbGZWfESxpg+9QAk45WEAH23a3Q==
X-Received: by 2002:a7b:c143:0:b0:37b:dacd:bf2f with SMTP id z3-20020a7bc143000000b0037bdacdbf2fmr565884wmi.16.1645474786592;
        Mon, 21 Feb 2022 12:19:46 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id o6-20020a05600c338600b0037c322d1425sm322567wmp.8.2022.02.21.12.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:19:46 -0800 (PST)
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
Subject: [PATCH net] net: dsa: fix panic when removing unoffloaded port from bridge
Date:   Mon, 21 Feb 2022 21:19:31 +0100
Message-Id: <20220221201931.296500-1-alvin@pqrs.dk>
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
 net/dsa/port.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index eef4a98f2628..fc7a233653a0 100644
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
+	info.bridge = *dp->bridge,
+
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
-- 
2.35.1

