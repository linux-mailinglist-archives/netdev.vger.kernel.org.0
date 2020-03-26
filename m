Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965A5193730
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgCZDwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:29077 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbgCZDwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:14 -0400
IronPort-SDR: U5/tNgomtM826x8MaL7eE7JSt3s2c4vzN/Kh1etb41/LUIKRa8hyhIvidA1vYrErpzxg90O1hB
 vKvGOwa/5Rdw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:14 -0700
IronPort-SDR: JJ7AemwPA/l6s+xAdw5tZiG643rvZFe6pyNwrnMue0rf29Fuha6WZzocZCGRR0/pFc6DIP5XGd
 fyYq4WpKteFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028107"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:12 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v2 05/11] devlink: use -ENOSPC to indicate no more room for snapshots
Date:   Wed, 25 Mar 2020 20:51:51 -0700
Message-Id: <20200326035157.2211090-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink_region_snapshot_create function returns -ENOMEM when the
maximum number of snapshots has been reached. This is confusing because
it is not an issue of being out of memory. Change this to use -ENOSPC instead.

Reported-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 620e9d07ac85..8c2c4bc009bb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3793,7 +3793,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
-		return -ENOMEM;
+		return -ENOSPC;
 
 	if (devlink_region_snapshot_get_by_id(region, snapshot_id))
 		return -EEXIST;
-- 
2.24.1

