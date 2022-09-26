Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCCF5EB5C2
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiIZX2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIZX1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:27:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691526EF2A
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664234866; x=1695770866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9am/bieXiysWtUx7w/8/1msQI6g+HrLkELye1uXSmPM=;
  b=dnTHYwqhusnhP82sHhQ1A8Dn06oazH+0mhOTQPW/uGnEpTQGUSFYq2eE
   qoIfIjEjGXj1iW/VOjW6Zqa4G+rWzDdIpxIRbGJLYbvcy2pVLovqcihcR
   qC2h440CuMg1nQoYcAvVsQ41mPA00LVWbb0i9DgP3THs5hnHVRlB3leyh
   MK63pZML06F4i0WU4Y8jGKaBto+FVDvmYH1oW14/xUP+Nvio9XU84vDlF
   OF29t8TzHx+et+0CEsgAvOHK98Ora4DOLsGo1iiniChV7qjxKF6h4AkJC
   wgswTD+hrBjg293maAdthPzbcWGNVwAU8bxUzPBTOC6VOFMjc7nv/jnla
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280890873"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="280890873"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="572424287"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="572424287"
Received: from sankarka-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.3.132])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Dmytro Shytyi <dmytro@shytyi.net>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        benjamin.hesmans@tessares.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/4] mptcp: handle defer connect in mptcp_sendmsg
Date:   Mon, 26 Sep 2022 16:27:38 -0700
Message-Id: <20220926232739.76317-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
References: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>

When TCP_FASTOPEN_CONNECT has been set on the socket before a connect,
the defer flag is set and must be handled when sendmsg is called.

This is similar to what is done in tcp_sendmsg_locked().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 866dfad3cde6..fc753896caa0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1677,6 +1677,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct page_frag *pfrag;
+	struct socket *ssock;
 	size_t copied = 0;
 	int ret = 0;
 	long timeo;
@@ -1690,6 +1691,27 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(sk);
 
+	ssock = __mptcp_nmpc_socket(msk);
+	if (unlikely(ssock && inet_sk(ssock->sk)->defer_connect)) {
+		struct sock *ssk = ssock->sk;
+		int copied_syn = 0;
+
+		lock_sock(ssk);
+
+		ret = tcp_sendmsg_fastopen(ssk, msg, &copied_syn, len, NULL);
+		copied += copied_syn;
+		if (ret == -EINPROGRESS && copied_syn > 0) {
+			/* reflect the new state on the MPTCP socket */
+			inet_sk_state_store(sk, inet_sk_state_load(ssk));
+			release_sock(ssk);
+			goto out;
+		} else if (ret) {
+			release_sock(ssk);
+			goto out;
+		}
+		release_sock(ssk);
+	}
+
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
 	if ((1 << sk->sk_state) & ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
-- 
2.37.3

