Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0133A53D
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 15:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhCNO5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 10:57:20 -0400
Received: from foss.arm.com ([217.140.110.172]:32990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhCNO4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 10:56:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E4621FB;
        Sun, 14 Mar 2021 07:56:39 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 244BB3F792;
        Sun, 14 Mar 2021 07:56:35 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     Jianlin.Lv@arm.com, iecedge@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] bonding: Added -ENODEV interpret for slaves option
Date:   Sun, 14 Mar 2021 22:56:29 +0800
Message-Id: <20210314145629.376155-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the incorrect interface name is stored in the slaves/active_slave
option of the bonding sysfs, the kernel does not record the log that
interface does not exist.

This patch adds a log for -ENODEV error, which will facilitate users to
figure out such issue.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
v2: Update changlog.
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

