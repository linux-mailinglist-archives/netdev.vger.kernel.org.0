Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891415EB5C1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiIZX17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiIZX1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:27:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3CC6EF30
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664234866; x=1695770866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3eEN83FGptLBGWVNuc+N6UdQMdtD/faMYXdyfUdW2Ss=;
  b=m34chFg/DTH3bxYBJm1UUnNlRjfBMFeuZCSh+nRvxB5NdZxBJDpK3Mqo
   IeHlMtBLMDmadV3NTleVTqI2Hq4wyeZTggREYtGUXvVHN9AjFbdHtVmRT
   FJ+0Dv7+XIWPZLItqTYia4QotZX1N0d6Sp82IBKo4Hkflf7W83pQ4rcbp
   QwfQb3qfrMUbBeyRNX+RwjTfli2zkUezy8IU8pb0f/ec74eWhT9cwbXHh
   CpXEjeIqihPsl24Bho7lwVbbil2PnoOUN+f+njrk08RgxL5vYM/SUaFrM
   3AT47ao6A53+wk+p+hPM/H3WAuMLfe3ITOic76wOAYvjMRPIVVY+AWI/e
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280890877"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="280890877"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="572424288"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="572424288"
Received: from sankarka-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.3.132])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmytro@shytyi.net,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] mptcp: poll allow write call before actual connect
Date:   Mon, 26 Sep 2022 16:27:39 -0700
Message-Id: <20220926232739.76317-5-mathew.j.martineau@linux.intel.com>
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

From: Benjamin Hesmans <benjamin.hesmans@tessares.net>

If fastopen is used, poll must allow a first write that will trigger
the SYN+data

Similar to what is done in tcp_poll().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fc753896caa0..16c3a6fc347f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3548,6 +3548,7 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
+	inet_sk(sock->sk)->defer_connect = inet_sk(ssock->sk)->defer_connect;
 	sock->state = ssock->state;
 
 	/* on successful connect, the msk state will be moved to established by
@@ -3698,6 +3699,9 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
 		mask |= mptcp_check_writeable(msk);
+	} else if (state == TCP_SYN_SENT && inet_sk(sk)->defer_connect) {
+		/* cf tcp_poll() note about TFO */
+		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
 	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
 		mask |= EPOLLHUP;
-- 
2.37.3

