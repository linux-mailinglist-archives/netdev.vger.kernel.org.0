Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C42B38E3D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfFGPAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbfFGPAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E4653E2B7;
        Fri,  7 Jun 2019 15:00:08 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51372831B7;
        Fri,  7 Jun 2019 15:00:07 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/7] bonding: fix error messages in bond_do_fail_over_mac
Date:   Fri,  7 Jun 2019 10:59:27 -0400
Message-Id: <20190607145933.37058-3-jarod@redhat.com>
In-Reply-To: <20190607145933.37058-1-jarod@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 07 Jun 2019 15:00:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing the bond name again to debug output when referencing slave is wrong.
We're trying to set the bond's MAC to that of the new_active slave, so adjust
the error message slightly and pass in the slave's name, not the bond's.
Then we're trying to set the MAC on the old active slave, but putting the
new active slave's name in the output. While we're at it, clarify the
error messages so you know which one actually triggered.

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 32b6c1f9b82e..5823070f07a6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -661,8 +661,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		if (new_active) {
 			rv = bond_set_dev_addr(bond->dev, new_active->dev);
 			if (rv)
-				netdev_err(bond->dev, "Error %d setting MAC of slave %s\n",
-					   -rv, bond->dev->name);
+				netdev_err(bond->dev, "Error %d setting bond MAC from slave %s\n",
+					   -rv, new_active->dev->name);
 		}
 		break;
 	case BOND_FOM_FOLLOW:
@@ -692,7 +692,7 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		rv = dev_set_mac_address(new_active->dev,
 					 (struct sockaddr *)&ss, NULL);
 		if (rv) {
-			netdev_err(bond->dev, "Error %d setting MAC of slave %s\n",
+			netdev_err(bond->dev, "Error %d setting MAC of new active slave %s\n",
 				   -rv, new_active->dev->name);
 			goto out;
 		}
@@ -707,8 +707,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		rv = dev_set_mac_address(old_active->dev,
 					 (struct sockaddr *)&ss, NULL);
 		if (rv)
-			netdev_err(bond->dev, "Error %d setting MAC of slave %s\n",
-				   -rv, new_active->dev->name);
+			netdev_err(bond->dev, "Error %d setting MAC of old active slave %s\n",
+				   -rv, old_active->dev->name);
 out:
 		break;
 	default:
-- 
2.20.1

