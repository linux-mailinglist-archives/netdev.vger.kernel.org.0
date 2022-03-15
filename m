Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432204D948F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiCOG1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240722AbiCOG1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:27:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759055F8B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:26:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p17so15422657plo.9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sNbGvu9gxl2xK5UIPNKtEgnSMHuKMnS5rTnq6umhXus=;
        b=LscTVbtyYMSx2YxakTTGtQ96bleP3FlFVFuMzxZlY/Y4Ibr3CA8goMBYBXGRv1Bhjv
         WwQDS31/JLKuQ4W5WsTiLySsNQMuFpWLeJzhL6gkPAcL2An8q74YfAh2FUTHiYb40S7I
         dYh3buJx7xOTlKrqfMLOrEQx/bSTlt4xb1V0iEFU6UmIQDRvayWFmkXXwUGkZz+x3YSK
         OaxjhGAok9VVlF2w6fxJNWMgrWyWAMP44yokJSamWuVzOWn9ss0Im4pnOZpNITYVV34V
         QS+Hrbqnl/LQQiL+Pz50gdmrrm0kBplBkMWhuj+Wvy2AKmpgs0+hWwFpo8YFZX9KI7pu
         m9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sNbGvu9gxl2xK5UIPNKtEgnSMHuKMnS5rTnq6umhXus=;
        b=jYe+KLBA/3qqVCZqg3lxV/nnP8IJzDiSyCXdaAhj36SYjji1DU5w00qo7Yy1lby6ah
         dNvNslZtdNSvexQA5GG2jneIsmy1ZQKxA/mbIgYAaZdVgn5GcU8ZXnU3ypdpx/7M5SBd
         npVphJoR+T/p4gfYZKw1tYy+96TDs3hnLABhH03MoizibypuJV7HHf1swLWZfLF5t40L
         qL2KAYkWpF5Nvdr1tA60ltpcwzVstfVB5k02dNmlCoyXCEUt8bKL0zel1SodRCvCkL6M
         A3HKi76vihqTylYNjBLa8IL48Z3Vj9T8gdXt7IudbTSX+sjjyfKGDXU2TUTEVyTi8OZl
         iNdA==
X-Gm-Message-State: AOAM5301mwBsbVNZunVL+Ad5yY1ok/RirBcsgmHFANDfYx+wUU5LZriv
        C9X3DVooMwjbet9BKzxQGKd8S9d+Msg=
X-Google-Smtp-Source: ABdhPJxHzH7gUloj6WKy6OBnthq21jFyIhsZduW1MQPNjRPe+a8Umk8XuiGKKjC0Vbhzmij4HAUPQQ==
X-Received: by 2002:a17:90b:4f8f:b0:1bf:84ad:1fe6 with SMTP id qe15-20020a17090b4f8f00b001bf84ad1fe6mr2857772pjb.189.1647325593665;
        Mon, 14 Mar 2022 23:26:33 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm21523574pfj.128.2022.03.14.23.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 23:26:32 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Martin Varghese <martin.varghese@nokia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jianlin Shi <jishi@redhat.com>
Subject: [PATCH net] bareudp: use ipv6_mod_enabled to check if IPv6 enabled
Date:   Tue, 15 Mar 2022 14:26:18 +0800
Message-Id: <20220315062618.156230-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bareudp_create_sock() use AF_INET6 by default if IPv6 CONFIG enabled.
But if user start kernel with ipv6.disable=1, the bareudp sock will
created failed, which cause the interface open failed even with ethertype
ip. e.g.

 # ip link add bareudp1 type bareudp dstport 2 ethertype ip
 # ip link set bareudp1 up
 RTNETLINK answers: Address family not supported by protocol

Fix it by using ipv6_mod_enabled() to check if IPv6 enabled. There is
no need to check IS_ENABLED(CONFIG_IPV6) as ipv6_mod_enabled() will
return false when CONFIG_IPV6 no enabled in include/linux/ipv6.h.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bareudp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index ba587e5fc24f..683203f87ae2 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -148,14 +148,14 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
-	if (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
+	if (!ipv6_mod_enabled() || family == AF_INET)
 		err = IP_ECN_decapsulate(oiph, skb);
 	else
 		err = IP6_ECN_decapsulate(oiph, skb);
 
 	if (unlikely(err)) {
 		if (log_ecn_error) {
-			if  (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
+			if  (!ipv6_mod_enabled() || family == AF_INET)
 				net_info_ratelimited("non-ECT from %pI4 "
 						     "with TOS=%#x\n",
 						     &((struct iphdr *)oiph)->saddr,
@@ -221,11 +221,12 @@ static struct socket *bareudp_create_sock(struct net *net, __be16 port)
 	int err;
 
 	memset(&udp_conf, 0, sizeof(udp_conf));
-#if IS_ENABLED(CONFIG_IPV6)
-	udp_conf.family = AF_INET6;
-#else
-	udp_conf.family = AF_INET;
-#endif
+
+	if (ipv6_mod_enabled())
+		udp_conf.family = AF_INET6;
+	else
+		udp_conf.family = AF_INET;
+
 	udp_conf.local_udp_port = port;
 	/* Open UDP socket */
 	err = udp_sock_create(net, &udp_conf, &sock);
@@ -448,7 +449,7 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	rcu_read_lock();
-	if (IS_ENABLED(CONFIG_IPV6) && info->mode & IP_TUNNEL_INFO_IPV6)
+	if (ipv6_mod_enabled() && info->mode & IP_TUNNEL_INFO_IPV6)
 		err = bareudp6_xmit_skb(skb, dev, bareudp, info);
 	else
 		err = bareudp_xmit_skb(skb, dev, bareudp, info);
@@ -478,7 +479,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-	if (!IS_ENABLED(CONFIG_IPV6) || ip_tunnel_info_af(info) == AF_INET) {
+	if (!ipv6_mod_enabled() || ip_tunnel_info_af(info) == AF_INET) {
 		struct rtable *rt;
 		__be32 saddr;
 
-- 
2.35.1

