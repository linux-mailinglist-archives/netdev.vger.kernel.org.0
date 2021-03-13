Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D24339E66
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 15:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhCMOCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 09:02:50 -0500
Received: from foss.arm.com ([217.140.110.172]:37990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233478AbhCMOCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 09:02:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F83F1FB;
        Sat, 13 Mar 2021 06:02:24 -0800 (PST)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 67FBB3F7D7;
        Sat, 13 Mar 2021 06:02:21 -0800 (PST)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     Jianlin.Lv@arm.com, iecedge@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] bonding: Added -ENODEV interpret for slaves option
Date:   Sat, 13 Mar 2021 22:02:10 +0800
Message-Id: <20210313140210.3940183-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After upgrading the kernel, the slave interface name is changed,
Systemd cannot use the original configuration to create bond interface,
thereby losing the connection with the host.

Adding log for ENODEV will make it easier to find out such problem lies.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 drivers/net/bonding/bond_options.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 77d7c38bd435..c9d3604ae129 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -640,6 +640,15 @@ static void bond_opt_error_interpret(struct bonding *bond,
 		netdev_err(bond->dev, "option %s: unable to set because the bond device is up\n",
 			   opt->name);
 		break;
+	case -ENODEV:
+		if (val && val->string) {
+			p = strchr(val->string, '\n');
+			if (p)
+				*p = '\0';
+			netdev_err(bond->dev, "option %s: interface %s does not exist!\n",
+				   opt->name, val->string);
+		}
+		break;
 	default:
 		break;
 	}
-- 
2.25.1

