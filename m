Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17F25625F6
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiF3WSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 18:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiF3WSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 18:18:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF4F4D175
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656627485; x=1688163485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tF/Wq5emO17ur6n4i4kolET5/WZvdXynovD9SwfsTxM=;
  b=lZLpgzmbl+unZ5fk95G1XicRbPoQVU48gQIjH3agnSBs+VSrT2Lv0yBE
   dto5thLwuUEYdSCvDhhXWOVLBkyVHMVFojvgKZ4FGCcNhXX4oN2vgJxq5
   CKq7yHYT6LlMxI5wa3bKgnxN5bwtuJcbXgIXsmqmjJnJffF/yxk3wBcc0
   azwW3UDBAqU3/Qvnd3o+xN+/SiY4iSraN/s6w0yuhIP594ugPcAOBdueI
   qPj/x7RPtMvXH9aoBfhXldhVJ4fT9NxmDIw+yk0Os85mMfPoow6TX/WfX
   7NVeywHs5ifVxYmwDcnef9rX1Ap4+aebPwSOFox74iDzuoZHM1U0Y6iip
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283583508"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="283583508"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="733804541"
Received: from mhtran-desk5.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.176.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/4] mptcp: refine memory scheduling
Date:   Thu, 30 Jun 2022 15:17:56 -0700
Message-Id: <20220630221757.763751-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
References: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Similar to commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
sk_rmem_schedule() errors"), let the MPTCP receive path schedule
exactly the required amount of memory.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e89a0124023f..91628dbe5a2d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -323,9 +323,10 @@ static bool mptcp_rmem_schedule(struct sock *sk, struct sock *ssk, int size)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int amt, amount;
 
-	if (size < msk->rmem_fwd_alloc)
+	if (size <= msk->rmem_fwd_alloc)
 		return true;
 
+	size -= msk->rmem_fwd_alloc;
 	amt = sk_mem_pages(size);
 	amount = amt << PAGE_SHIFT;
 	if (!__sk_mem_raise_allocated(sk, size, amt, SK_MEM_RECV))
-- 
2.37.0

