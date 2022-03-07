Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A704D08B7
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiCGUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiCGUpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1038119A
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685885; x=1678221885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ucCVEbG2r6tv8BhrEAQxcmNxQ5DVG9ZS+1eowHh6Zk=;
  b=CmFKXpOgGxv1/EZ8bO50JlmFJFKEwi2M22bsntSI5x3TmTPns7K8Idsr
   uJDSmiRIBvlYYVVDU8iZcJWwFwDBJ8zhY82oIOE2fOIduxAjtNFqImH5+
   gVJwpmwAPnFL3d7PhUUC2FvKZt/MqRhQnR2ojH3hpOglUSvBRSbmxK9YK
   MhjIUVBzqVhh7JWkp2FDymHMOE0uYcs7fjCdgbw29A5/xvTEicwNIKHKu
   JTgR1p74iY3SFnhT83uY+us9kzYEJBorh1XSeq1u7bTBwdpM3CsYReSOT
   1ywsi8RKN8yOQmBsyGy6jxrSKnS1QaAjEk+aGJw9e+kttJb5SpeUidRUm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440155"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440155"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320480"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/9] mptcp: add tracepoint in mptcp_sendmsg_frag
Date:   Mon,  7 Mar 2022 12:44:31 -0800
Message-Id: <20220307204439.65164-2-mathew.j.martineau@linux.intel.com>
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

The tracepoint in get_mapping_status() only dumped the incoming mpext
fields. This patch added a new tracepoint in mptcp_sendmsg_frag() to dump
the outgoing mpext too.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/trace/events/mptcp.h | 4 ++++
 net/mptcp/protocol.c         | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/trace/events/mptcp.h b/include/trace/events/mptcp.h
index 6bf43176f14c..f8e28e686c65 100644
--- a/include/trace/events/mptcp.h
+++ b/include/trace/events/mptcp.h
@@ -115,6 +115,10 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		  __entry->csum_reqd)
 );
 
+DEFINE_EVENT(mptcp_dump_mpext, mptcp_sendmsg_frag,
+	TP_PROTO(struct mptcp_ext *mpext),
+	TP_ARGS(mpext));
+
 DEFINE_EVENT(mptcp_dump_mpext, get_mapping_status,
 	TP_PROTO(struct mptcp_ext *mpext),
 	TP_ARGS(mpext));
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1c72f25f083e..36a7d33f670a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1356,6 +1356,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 out:
 	if (READ_ONCE(msk->csum_enabled))
 		mptcp_update_data_checksum(skb, copy);
+	trace_mptcp_sendmsg_frag(mpext);
 	mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
 	return copy;
 }
-- 
2.35.1

