Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E855805F8
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiGYUwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiGYUwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:52:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA80140B8
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782360; x=1690318360;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tx6gJ865FBlGF8GXhCZ8lBxX17nODAgYp59Qf1QLR34=;
  b=FYc+7CRhiYCvvEvPaKSmdLtzzz8h8oJPE4xgPDhYYEQLH5HepIOl2Ehi
   JHdR1Dc5fYanrE2wkvf8sa2hWwhAh8emvYb48NgB4k/uJTE7+4PblvNhv
   iJXw8p34qpe4L2CkBBYHkzn9zy+1pBDYEfiBpF3ZFyqfMs6HUZPSyO1JZ
   zyS2p3ZokjEINdNaFRvznmRZ/545hoIjIacH7Yto5zD+Tbytd2O6D9d6b
   rMuUDTxYzjWCvOyqfApCeMtb6vPDnsDjohAk1PRNZZjJut5Sb0O0WuHP2
   GKp7e2Ag17Eg9MWUBghGk2dL51Fs5kMixsjKb1m0uyp2t3ZQfVmHTm35/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="267563698"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="267563698"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:52:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="599741712"
Received: from dbpatel1-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.117.180])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:52:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net, fw@strlen.de,
        mptcp@lists.linux.dev
Subject: [PATCH net] mptcp: Do not return EINPROGRESS when subflow creation succeeds
Date:   Mon, 25 Jul 2022 13:52:31 -0700
Message-Id: <20220725205231.87529-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New subflows are created within the kernel using O_NONBLOCK, so
EINPROGRESS is the expected return value from kernel_connect().
__mptcp_subflow_connect() has the correct logic to consider EINPROGRESS
to be a successful case, but it has also used that error code as its
return value.

Before v5.19 this was benign: all the callers ignored the return
value. Starting in v5.19 there is a MPTCP_PM_CMD_SUBFLOW_CREATE generic
netlink command that does use the return value, so the EINPROGRESS gets
propagated to userspace.

Make __mptcp_subflow_connect() always return 0 on success instead.

Fixes: ec3edaa7ca6c ("mptcp: Add handling of outgoing MP_JOIN requests")
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---

Note: The original author of ec3edaa7ca6c is no longer reachable at that
email address.

---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 63e8892ec807..af28f3b60389 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1533,7 +1533,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	mptcp_sock_graft(ssk, sk->sk_socket);
 	iput(SOCK_INODE(sf));
 	WRITE_ONCE(msk->allow_infinite_fallback, false);
-	return err;
+	return 0;
 
 failed_unlink:
 	list_del(&subflow->node);

base-commit: 9af0620de1e118666881376f6497d1785758b04c
-- 
2.37.1

