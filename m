Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB952A9D0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348018AbiEQSCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiEQSCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:02:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A379A3F88C
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652810540; x=1684346540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9i15zZu1wsyIycRzynIEjtH80AivT4HanS2rE/bQPcI=;
  b=V93octjC6sbwzmva5bwJgg7j2F5qPbMcrw72/LuD7GwSBfeNN+CpM4Yg
   AJ1vI2xcFtm+/NI3gnLKBEbyOlv4n5tW7qW/Xy/ed61a6nuuyPuGvk9jh
   K6j0lnDM36xulMVzxeFQCY6dPTZ1mbQxy41c2i24zzU/Dw/Abx/rIo65p
   19Hn1vSMFkwXfarvwQGX2idvNer4ju+YXVnvW7ZXMmUPe5zZUvfOSRYul
   UwAv+CObVZZxP4vOAccoht7omqi8Z3QJjO7bKElb96ijXLO5Ib3u/uArH
   OuYgHE6LqfZZ2WuvHJDUOHl0Pl356UFJI0xePHFg4b9rsZloEi3D593AJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="268854854"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="268854854"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 11:02:19 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="523080354"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.6.57])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 11:02:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 2/2] mptcp: Do TCP fallback on early DSS checksum failure
Date:   Tue, 17 May 2022 11:02:12 -0700
Message-Id: <20220517180212.92597-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517180212.92597-1-mathew.j.martineau@linux.intel.com>
References: <20220517180212.92597-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684 section 3.7 describes several opportunities for a MPTCP
connection to "fall back" to regular TCP early in the connection
process, before it has been confirmed that MPTCP options can be
successfully propagated on all SYN, SYN/ACK, and data packets. If a peer
acknowledges the first received data packet with a regular TCP header
(no MPTCP options), fallback is allowed.

If the recipient of that first data packet finds a MPTCP DSS checksum
error, this provides an opportunity to fail gracefully with a TCP
fallback rather than resetting the connection (as might happen if a
checksum failure were detected later).

This commit modifies the checksum failure code to attempt fallback on
the initial subflow of a MPTCP connection, only if it's a failure in the
first data mapping. In cases where the peer initiates the connection,
requests checksums, is the first to send data, and the peer is sending
incorrect checksums (see
https://github.com/multipath-tcp/mptcp_net-next/issues/275), this allows
the connection to proceed as TCP rather than reset.

Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h |  3 ++-
 net/mptcp/subflow.c  | 21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index fb40dd676a26..5655a63aa6a8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -443,7 +443,8 @@ struct mptcp_subflow_context {
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
-		local_id_valid : 1; /* local_id is correctly initialized */
+		local_id_valid : 1, /* local_id is correctly initialized */
+		valid_csum_seen : 1;        /* at least one csum validated */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e90fe7eec43a..be76ada89d96 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -955,11 +955,14 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		subflow->send_mp_fail = 1;
-		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
+		if (subflow->mp_join || subflow->valid_csum_seen) {
+			subflow->send_mp_fail = 1;
+			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
+		}
 		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
 	}
 
+	subflow->valid_csum_seen = 1;
 	return MAPPING_OK;
 }
 
@@ -1141,6 +1144,18 @@ static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ss
 	}
 }
 
+static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)
+{
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	if (subflow->mp_join)
+		return false;
+	else if (READ_ONCE(msk->csum_enabled))
+		return !subflow->valid_csum_seen;
+	else
+		return !subflow->fully_established;
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -1218,7 +1233,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		return true;
 	}
 
-	if (subflow->mp_join || subflow->fully_established) {
+	if (!subflow_can_fallback(subflow)) {
 		/* fatal protocol error, close the socket.
 		 * subflow_error_report() will introduce the appropriate barriers
 		 */
-- 
2.36.1

