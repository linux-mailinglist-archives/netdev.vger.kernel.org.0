Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB1157217B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiGLQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiGLQ7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:59:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705D321252
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657645157; x=1689181157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8ltP4keG82wd13OO1CYmccpRihu1nWxXRVMEA6A8ecw=;
  b=kAbi7QSIDPd5Z7ZC3Uis0FCx1ofoPeTRow6LGp+3XpRyG7KpQNli+imT
   ib5vS94EQI9bANIlUbbNeLp/IdjZyd6lcsgFxpXCcAUdnWPW+E17oXNUg
   YGaUphNvhK9uUImBFB50JtHFShSEXskF+a7pq8Wyfc15Qe130+64zspoN
   2zywaPROy8tfdM+B1HhiNx2VTTwvzXn7DXaMrD25gFbfQxz/fNvY+InTt
   ReexdX4d0gZWisJalKWlJOObDCoSEeGUOgCE+OYM4lavgY11dm8Q5V8Kn
   xejLkkX3Inpu8eNl7VdXhpSEJDbo6d0YWCO+P42MuLWFJBSURO8i0aeac
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="264778563"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="264778563"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="698087533"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2022 09:59:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Alan Brady <alan.brady@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/1] ping: fix ipv6 ping socket flow labels
Date:   Tue, 12 Jul 2022 09:56:08 -0700
Message-Id: <20220712165608.32790-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Brady <alan.brady@intel.com>

Ping sockets don't appear to make any attempt to preserve flow labels
created and set by userspace. Instead they are always clobbered by
autolabels (if enabled) or zero.

This grabs the flowlabel out of the msghdr similar to how rawv6_sendmsg
does it and moves the memset up so we don't zero it.

Signed-off-by: Alan Brady <alan.brady@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 net/ipv6/ping.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ecf3a553a0dc..b1179f62bd23 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -64,6 +64,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (err)
 		return err;
 
+	memset(&fl6, 0, sizeof(fl6));
+
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_in6 *, u, msg->msg_name);
 		if (msg->msg_namelen < sizeof(*u))
@@ -72,12 +74,15 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			return -EAFNOSUPPORT;
 		}
 		daddr = &(u->sin6_addr);
+		if (np->sndflow)
+			fl6.flowlabel = u->sin6_flowinfo & IPV6_FLOWINFO_MASK;
 		if (__ipv6_addr_needs_scope_id(ipv6_addr_type(daddr)))
 			oif = u->sin6_scope_id;
 	} else {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -EDESTADDRREQ;
 		daddr = &sk->sk_v6_daddr;
+		fl6.flowlabel = np->flow_label;
 	}
 
 	if (!oif)
@@ -101,7 +106,6 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
-	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_oif = oif;
 
 	if (msg->msg_controllen) {
-- 
2.35.1

