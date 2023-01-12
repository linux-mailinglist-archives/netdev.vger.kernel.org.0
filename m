Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B22C666806
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbjALAnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbjALAm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:42:58 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCDB32188
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:42:01 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id fd15so5371885qtb.9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pN/2+SU3KPT9EU3qMdA2HtIIkuYoz2P2Dee5WOS69ew=;
        b=MF9NNLL+M/NVyjnzdfHz3E993WPT8otyDm98L3nheROQ2X4vxZJsCuPjuOhIfLQIlB
         wqAiRuUnzgnMgPRCbmvHavAiPNZzeSWlbfGIgkT35nxMjxaaZ6/9YnfbBDoEXz47xlc1
         nmpwNyDH2/fBLxYETBgOunlVZ/sw8C8FFGk7IPLBkVCwt+10Ikmog0QZU5mQS353bjl2
         CoPDvwYHJwdDT15nWhS07WUlFeCmZTjLUbjtzyoiHJFBGB+ADlWZzuEYZlhcJ/aXy9Ip
         +k5KQoghXPG16IEkEfLyxlsm7FA09Ec1rEj3yf9Y6GSdI8SnQoIfGleN/hpOkm4j1fLS
         fC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pN/2+SU3KPT9EU3qMdA2HtIIkuYoz2P2Dee5WOS69ew=;
        b=e4QFVCqyHlXClnOdvRtwfMsp2zY9e2hrkAa/dv5TrILGt+p+Ylnf5xLEoXcyY7i60w
         DNT6o7LuEnz/EcpOhEabikf8gpetHx0NYKeGa5z2/TS8ofk28t9XXHdvOJ7hsFhGvnW1
         Ng+HFJFspl6C43Fe+7qAVDDO9b4M1MvkSK6oCU0G6YqPfInCJPxDHlkotZAqdDp5FlV7
         3yRqgN01NJtagBg+ZOzlhXZ4dQbvUDsMRbZpg0DauDPlKURPmRXhQmL/fravdMV60Tr6
         dsNkKwZ5vLeOPcNvXMXS9qE+sFVHryjxZ8NXT5tDc9ik2CwL6JZn3Ku5fj6aqQytXjHB
         +s3A==
X-Gm-Message-State: AFqh2kqDj3D8coVQjPP89CKXNTVt672a7T9rXUJR+vszzWKo/c90o6s1
        /vhE48wHk9quxy9RXZ1Ro9CiQK6PzEKzZw==
X-Google-Smtp-Source: AMrXdXu+nckgEmw7vYYXqI9D96qivdJxYNPbG2OwAbI3tKekE+kQHQymfqfhghWWVr2FpzMIpGmwOA==
X-Received: by 2002:ac8:7cb1:0:b0:3b1:8ad7:b9fb with SMTP id z17-20020ac87cb1000000b003b18ad7b9fbmr2485930qtv.49.1673484120264;
        Wed, 11 Jan 2023 16:42:00 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c11-20020ac853cb000000b00397b1c60780sm8268152qtq.61.2023.01.11.16.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:41:59 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCHv2 net 1/2] ipv6: prevent only DAD and RS sending for IFF_NO_ADDRCONF
Date:   Wed, 11 Jan 2023 19:41:56 -0500
Message-Id: <f29babd921a1842b7f953c56175cf2cd2abe7bc8.1673483994.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673483994.git.lucien.xin@gmail.com>
References: <cover.1673483994.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
slave ports of team, bonding and failover devices and it means no ipv6
packets can be sent out through these slave ports. However, for team
device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
link will be marked failure.

The orginal issue fixed by IFF_NO_ADDRCONF was caused by DAD and RS
packets sent by slave ports in commit c2edacf80e15 ("bonding / ipv6: no
addrconf for slaves separately from master") where it's using IFF_SLAVE
and later changed to IFF_NO_ADDRCONF in commit 8a321cf7becc ("net: add
IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf").

So instead of preventing all the ipv6 addrconf, it makes more sense to
only prevent DAD and RS sending for the slave ports: Firstly, check
IFF_NO_ADDRCONF in addrconf_dad_completed() to prevent RS as it did in
commit b52e1cce31ca ("ipv6: Don't send rs packets to the interface of
ARPHRD_TUNNEL"), and then also check IFF_NO_ADDRCONF where IFA_F_NODAD
is checked to prevent DAD.

Note that the check for flags & IFA_F_NODAD in addrconf_dad_begin() is
not necessary, as with IFA_F_NODAF, flags & IFA_F_TENTATIVE is always
false, so there's no need to add IFF_NO_ADDRCONF check there either.

Fixes: 0aa64df30b38 ("net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/addrconf.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f7a84a4acffc..de4186e5349c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1124,7 +1124,8 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ifa->flags = cfg->ifa_flags;
 	ifa->ifa_proto = cfg->ifa_proto;
 	/* No need to add the TENTATIVE flag for addresses with NODAD */
-	if (!(cfg->ifa_flags & IFA_F_NODAD))
+	if (!(cfg->ifa_flags & IFA_F_NODAD) &&
+	    !(idev->dev->priv_flags & IFF_NO_ADDRCONF))
 		ifa->flags |= IFA_F_TENTATIVE;
 	ifa->valid_lft = cfg->valid_lft;
 	ifa->prefered_lft = cfg->preferred_lft;
@@ -3319,10 +3320,6 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
 	if (netif_is_l3_master(idev->dev))
 		return;
 
-	/* no link local addresses on devices flagged as slaves */
-	if (idev->dev->priv_flags & IFF_NO_ADDRCONF)
-		return;
-
 	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
 
 	switch (idev->cnf.addr_gen_mode) {
@@ -3564,7 +3561,6 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev) &&
 			    dev->flags & IFF_UP && dev->flags & IFF_MULTICAST)
 				ipv6_mc_up(idev);
-			break;
 		}
 
 		if (event == NETDEV_UP) {
@@ -3855,7 +3851,8 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 			/* set state to skip the notifier below */
 			state = INET6_IFADDR_STATE_DEAD;
 			ifa->state = INET6_IFADDR_STATE_PREDAD;
-			if (!(ifa->flags & IFA_F_NODAD))
+			if (!(ifa->flags & IFA_F_NODAD) &&
+			    !(dev->priv_flags & IFF_NO_ADDRCONF))
 				ifa->flags |= IFA_F_TENTATIVE;
 
 			rt = ifa->rt;
@@ -4218,6 +4215,7 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
 		  (dev->flags & IFF_LOOPBACK) == 0 &&
+		  (dev->priv_flags & IFF_NO_ADDRCONF) == 0 &&
 		  (dev->type != ARPHRD_TUNNEL);
 	read_unlock_bh(&ifp->idev->lock);
 
-- 
2.31.1

