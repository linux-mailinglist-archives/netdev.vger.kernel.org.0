Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F864D08BD
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbiCGUqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245295AbiCGUqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:46:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544E485955
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685908; x=1678221908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/eP9FA3TlK1JhqXDW8j+WHnR3670oSgdS19K3yRsgGA=;
  b=aSxYkxgfoJYFBjkWntIJLXzh3DWmaj8lETShRyM/csDFN5j749xnMqYH
   nFdRtFs7qTrlPYKheATCvHp332v3uL9HaE9mLoMIY6snVE4I9CrrrzGAG
   Wud21SdRQGFSAnbmRFHQF/z7v7b82/YOfemMH3KCFsUSLIAjST2Bjx5hu
   dQp4IIAAKJ4ojEmWK2bRdIAKDYMt+Hy4YQ+XH/LZmTE2D591C0WmUi0Ox
   GeCHYTik1nSFQRpCV5rmlwLxe5JYHdt8UZza2rKNYbRBpfGY0m1FGxi0c
   0LICgrYANrrjxZ59U0UwIH+wJCSJvbJenHkVk/BeLOq0as6BzeZFqleLA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440174"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440174"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320496"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 9/9] mptcp: add fullmesh flag check for adding address
Date:   Mon,  7 Mar 2022 12:44:39 -0800
Message-Id: <20220307204439.65164-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
References: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

The fullmesh flag mustn't be used with the signal flag when adding an
address. This patch added the necessary flags check for this case.

Fixes: 73c762c1f07d ("mptcp: set fullmesh flag in pm_netlink")
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e090810bb35d..800515fe5e1d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1264,6 +1264,12 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	if (addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL &&
+	    addr.flags & MPTCP_PM_ADDR_FLAG_FULLMESH) {
+		GENL_SET_ERR_MSG(info, "flags mustn't have both signal and fullmesh");
+		return -EINVAL;
+	}
+
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_IMPLICIT) {
 		GENL_SET_ERR_MSG(info, "can't create IMPLICIT endpoint");
 		return -EINVAL;
-- 
2.35.1

