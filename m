Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D126606CA
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235987AbjAFS6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbjAFS5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:57:39 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D0C7D9D3
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031458; x=1704567458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ziWjDuaKo9pl4SeAqpiqjAJ31X2Msz1T7TKNnSpk2e8=;
  b=HDpWEX5lIJqK+ofG6iUD9dQ7Unz4uDSCc/LXg6XwJyAfeUGG9M03FzMr
   KDgUVt6Hchzz4CHasxigL2ghasTRTucwamXY1tKFw+qQjjEKBxqydd8E+
   jjoMmDJvSB72In9lbEY6BAU26DVABOZ+OGaS3WHSxerYEdrH3a5l4cB01
   hAiGu0q/BcnwYicF01/e0Rs8Oom8L+emL1owYlZa54KOVyCRF/sk/XkgL
   OZ7dttdNOSSPV6LH5Xdtf178QwHSpurdQ7XGo+CtygB9hfGNj51QNZ+VG
   /agWxnXKUrdnds4vgJh9jhadugXCo+UAM8Ax6XVt4CDKMyrn/9ad/5Irs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322611232"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="322611232"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688383431"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688383431"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/9] mptcp: init sk->sk_prot in build_msk()
Date:   Fri,  6 Jan 2023 10:57:21 -0800
Message-Id: <20230106185725.299977-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
References: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The 'sk_prot' field in token KUNIT self-tests will be dereferenced in
mptcp_token_new_connect(). Therefore, init it with tcp_prot.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/token_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/token_test.c b/net/mptcp/token_test.c
index 5d984bec1cd8..0758865ab658 100644
--- a/net/mptcp/token_test.c
+++ b/net/mptcp/token_test.c
@@ -57,6 +57,9 @@ static struct mptcp_sock *build_msk(struct kunit *test)
 	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, msk);
 	refcount_set(&((struct sock *)msk)->sk_refcnt, 1);
 	sock_net_set((struct sock *)msk, &init_net);
+
+	/* be sure the token helpers can dereference sk->sk_prot */
+	((struct sock *)msk)->sk_prot = &tcp_prot;
 	return msk;
 }
 
-- 
2.39.0

