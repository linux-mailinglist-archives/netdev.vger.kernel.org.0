Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE34425791
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbhJGQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242639AbhJGQSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:18:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 276986113E;
        Thu,  7 Oct 2021 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623419;
        bh=kbowb8lxcB967BBq1xJzUoWMBbuImOONRup+OQUabfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIaNtu7p7HGAFhZW4zsk5lDk8m4Fu7WNJmF9/VOd31AZcCjOi69m/7VeaHd305lsb
         8Cs4U3OgpZTMk5udZXn2bATiKw1GaTTWCl9B9qJzPcNb0/wDrRrfY7Cf0ltfrVTBMS
         dY35n6NAg/sH/H6emeCPdYVPKXzE1+ulO8Yda3serwaj074uhsHen+LCV8/TKw5d2u
         9njyJ246o8oEE5PFoStzYL40xphqAwLVOnXryNDtcsZDRcR/9qU9d+vuoaJatvPsZ5
         II7ykHH10xUH6wcKxqJGMGK0QMVS8JSYqFt9ckOGijnQOVuGgjJtYitkJ72XkKN58R
         n/xbeTeZzhsoA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] bonding: use the correct function to check for netdev name collision
Date:   Thu,  7 Oct 2021 18:16:51 +0200
Message-Id: <20211007161652.374597-3-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161652.374597-1-atenart@kernel.org>
References: <20211007161652.374597-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new helper to detect if a net device name is in use was added. Use it
here as the return reference from __dev_get_by_name was discarded.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/bonding/bond_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index b9e9842fed94..c48b77167fab 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -811,8 +811,8 @@ int bond_create_sysfs(struct bond_net *bn)
 	 */
 	if (ret == -EEXIST) {
 		/* Is someone being kinky and naming a device bonding_master? */
-		if (__dev_get_by_name(bn->net,
-				      class_attr_bonding_masters.attr.name))
+		if (netdev_name_in_use(bn->net,
+				       class_attr_bonding_masters.attr.name))
 			pr_err("network device named %s already exists in sysfs\n",
 			       class_attr_bonding_masters.attr.name);
 		ret = 0;
-- 
2.31.1

