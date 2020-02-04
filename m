Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFB01523A8
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 00:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgBDX7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 18:59:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:24442 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbgBDX7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 18:59:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 15:59:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,403,1574150400"; 
   d="scan'208";a="225671792"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 04 Feb 2020 15:59:52 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, parav@mellanox.com,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net] devlink: report 0 after hitting end in region read
Date:   Tue,  4 Feb 2020 15:59:50 -0800
Message-Id: <20200204235950.2209828-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit fdd41ec21e15 ("devlink: Return right error code in case of errors
for region read") modified the region read code to report errors
properly in unexpected cases.

In the case where the start_offset and ret_offset match, it unilaterally
converted this into an error. This causes an issue for the "dump"
version of the command. In this case, the devlink region dump will
always report an invalid argument:

000000000000ffd0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
000000000000ffe0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
devlink answers: Invalid argument
000000000000fff0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

This occurs because the expected flow for the dump is to return 0 after
there is no further data.

The simplest fix would be to stop converting the error code to -EINVAL
if start_offset == ret_offset. However, avoid unnecessary work by
checking for when start_offset is larger than the region size and
returning 0 upfront.

Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
I noticed this while working on adding the new region reading support at

https://lore.kernel.org/netdev/20200130225913.1671982-1-jacob.e.keller@intel.com/https://lore.kernel.org/netdev/20200130225913.1671982-1-jacob.e.keller@intel.com/

This is fairly cosmetic at least for the devlink userspace tools in iproute2
suite, but it is annoying. It appears to only happen with the dump-based
logic that does not specify a range or initial offset.

 net/core/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ca1df0ec3c97..549ee56b7a21 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3986,6 +3986,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	/* return 0 if there is no further data to read */
+	if (start_offset >= region->size) {
+		err = 0;
+		goto out_unlock;
+	}
+
 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
 			  DEVLINK_CMD_REGION_READ);
-- 
2.25.0.rc1

