Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25514B0298
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiBJB72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:59:28 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiBJB7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249822AC;
        Wed,  9 Feb 2022 17:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA0D6117E;
        Thu, 10 Feb 2022 00:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299BEC340F2;
        Thu, 10 Feb 2022 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453415;
        bh=vysQG6m7H3kYsRl6MCsWmusmF/i/5c7bYcQ6nlh4A/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa24r4Pvr+UQSz9se0+IO8trhy9w0OHbaZOhBXWx3oeMKDhXzgN1dAARb5bpj0m8s
         pen+thtr7iM6x/ic6/9RvCpC8e+gNETJC1n4dzKIkTvHBogg5YYJpHnezVApLxuuTv
         I6oLCKCaecKx7KEcZmQ79lrDQR7s/O9Qh0YmYJdanhcrSkkSMPwIdkfP0Pf1wlHoCC
         RZcRP8dBbZXRgNevLDujv6GIUsRW1tWppsmoJznBSPeORIz2GpExNeKH1bMfs0A6xQ
         sC/upS23JPJhc6bf0aICZ3WWjZhcF+ACQDa1YfBdOVKMJ1RSLJks5msIP4ytvQ5rkk
         VvnUr06ZI0+wQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/11] net: ping6: support setting socket options via cmsg
Date:   Wed,  9 Feb 2022 16:36:41 -0800
Message-Id: <20220210003649.3120861-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor reordering of the code and a call to sock_cmsg_send()
gives us support for setting the common socket options via
cmsg (the usual ones - SO_MARK, SO_TIMESTAMPING_OLD, SCM_TXTIME).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ping.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 3228ccd8abf1..d5544cf67ffe 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -97,6 +97,14 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
 		return -EINVAL;
 
+	ipcm6_init_sk(&ipc6, np);
+	ipc6.sockc.tsflags = sk->sk_tsflags;
+	ipc6.sockc.mark = sk->sk_mark;
+
+	err = sock_cmsg_send(sk, msg, &ipc6.sockc);
+	if (err)
+		return err;
+
 	/* TODO: use ip6_datagram_send_ctl to get options from cmsg */
 
 	memset(&fl6, 0, sizeof(fl6));
@@ -105,15 +113,12 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	fl6.saddr = np->saddr;
 	fl6.daddr = *daddr;
 	fl6.flowi6_oif = oif;
-	fl6.flowi6_mark = sk->sk_mark;
+	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk->sk_uid;
 	fl6.fl6_icmp_type = user_icmph.icmp6_type;
 	fl6.fl6_icmp_code = user_icmph.icmp6_code;
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
-	ipcm6_init_sk(&ipc6, np);
-	ipc6.sockc.mark = sk->sk_mark;
-	ipc6.sockc.tsflags = sk->sk_tsflags;
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_sk_dst_lookup_flow(sk, &fl6, daddr, false);
-- 
2.34.1

