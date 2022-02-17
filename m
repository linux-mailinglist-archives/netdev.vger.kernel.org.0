Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5E4B956A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiBQBVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:21:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiBQBVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E1C79;
        Wed, 16 Feb 2022 17:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0785616D2;
        Thu, 17 Feb 2022 01:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8492C340F1;
        Thu, 17 Feb 2022 01:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060886;
        bh=PyfBm3JdbqZgg6lEYzHxWbG1mDXoWMsCqP0jN55ZWaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtNJojPtKoq8pmHhOOjdVgVbQD71b+SR4H/IwoHiLsDMgBemQQFbXhNIv+avIz1PV
         3vuVmwNruRiyXcB2MOO7GQEbIiRmVXMYS+RNTcF0NBeJgdXaMbbBpjJpiQKRpHwWxU
         HmKY6suo70GLVpl7sRSQVns/IJScgxFUPyGzF1j884Du694iLvxtMypen+blPUWDF7
         DMyAuvu7r3llbow7zrL+/LExnKkI4VPh1fv0CX8WFt0wH0EcQw3XiaeReN2j6RAU6k
         UVy9ZUhhEuZAR5noxhc1t/hxObVkjQr+usltu9cc/kpuzQ03b86RgPR74sQbzeDkTf
         HGwjLcglvVenQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/5] net: ping6: support setting basic SOL_IPV6 options via cmsg
Date:   Wed, 16 Feb 2022 17:21:16 -0800
Message-Id: <20220217012120.61250-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217012120.61250-1-kuba@kernel.org>
References: <20220217012120.61250-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support setting IPV6_HOPLIMIT, IPV6_TCLASS, IPV6_DONTFRAG
during sendmsg via SOL_IPV6 cmsgs.

tclass and dontfrag are init'ed from struct ipv6_pinfo in
ipcm6_init_sk(), while hlimit is inited to -1, so we need
to handle it being populated via cmsg explicitly.

Leave extension headers and flowlabel unimplemented.
Those are slightly more laborious to test and users
seem to primarily care about IPV6_TCLASS.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ip6_output.c |  1 +
 net/ipv6/ping.c       | 21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0c6c971ce0a5..3286b64ec03d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1487,6 +1487,7 @@ static int __ip6_append_data(struct sock *sk,
 
 	if (cork->length + length > mtu - headersize && ipc6->dontfrag &&
 	    (sk->sk_protocol == IPPROTO_UDP ||
+	     sk->sk_protocol == IPPROTO_ICMPV6 ||
 	     sk->sk_protocol == IPPROTO_RAW)) {
 		ipv6_local_rxpmtu(sk, fl6, mtu - headersize +
 				sizeof(struct ipv6hdr));
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index d5544cf67ffe..ff033d16549e 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -101,11 +101,21 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
-	err = sock_cmsg_send(sk, msg, &ipc6.sockc);
-	if (err)
-		return err;
+	if (msg->msg_controllen) {
+		struct ipv6_txoptions opt = {};
+
+		opt.tot_len = sizeof(opt);
+		ipc6.opt = &opt;
 
-	/* TODO: use ip6_datagram_send_ctl to get options from cmsg */
+		err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6, &ipc6);
+		if (err < 0)
+			return err;
+
+		/* Changes to txoptions and flow info are not implemented, yet.
+		 * Drop the options, fl6 is wiped below.
+		 */
+		ipc6.opt = NULL;
+	}
 
 	memset(&fl6, 0, sizeof(fl6));
 
@@ -140,7 +150,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	pfh.wcheck = 0;
 	pfh.family = AF_INET6;
 
-	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
+	if (ipc6.hlimit < 0)
+		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
 	lock_sock(sk);
 	err = ip6_append_data(sk, ping_getfrag, &pfh, len,
-- 
2.34.1

