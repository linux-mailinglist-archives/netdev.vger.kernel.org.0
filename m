Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C47587B63
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiHBLO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbiHBLO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:14:26 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A12B193;
        Tue,  2 Aug 2022 04:14:18 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27275Q7L026303;
        Tue, 2 Aug 2022 13:13:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=s0sAH8Va4oVwM9bds8xjXKdGoYvKULeCnqytXxV4qlc=;
 b=2C9dKWqOfJyjZErAq5w2BIdsx6gbaRvgJ1S6g9qaYiN+C0qXm3O6ik1RtyQynJEF+2+T
 QTQMsqjAzGVSGp0dEaCoSQKtI4MNJdT93PsXMgqecDByUL4IXJge7MidjM8GPPehEqE2
 CBQYwOEBv33BXffQxIsOWy4HAT3U6WblyY+NxzSh/DCkNUvjoI9gXzrn1J4+v7eOKwh8
 YnIaJ8MBQ32nKgVU+ZJQJ3bXro9huFWxILyacJV2iYoctlxRmK2ukcLUPDRT2NnWAUSh
 r1qMowoYCbIA+zflmU5tmR3kvrgGj9Ylzg7j9uIwJ6uXlf/CLkn6+jCRzAhDNzGOEswN +A== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hms0c2v0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 13:13:44 +0200
Received: from Orpheus.westermo.com (172.29.101.13) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 2 Aug 2022 13:13:42 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <saeedm@nvidia.com>, <leon@kernel.org>, <roid@nvidia.com>,
        <maord@nvidia.com>, <lariel@nvidia.com>, <vladbu@nvidia.com>,
        <cmi@nvidia.com>, <gnault@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <nicolas.dichtel@6wind.com>, <eyal.birger@gmail.com>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH net 4/4] ipv6: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 2 Aug 2022 13:13:08 +0200
Message-ID: <20220802111308.1359887-5-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220802111308.1359887-1-matthias.may@westermo.com>
References: <20220802111308.1359887-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.101.13]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: FkHXf2mzz-Ak5yeVUdjlC1xlaQTArItR
X-Proofpoint-ORIG-GUID: FkHXf2mzz-Ak5yeVUdjlC1xlaQTArItR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Guillaume Nault RT_TOS should never be used for IPv6.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 net/ipv6/ip6_output.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 77e3f5970ce4..ec62f472aa1c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1311,8 +1311,7 @@ struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
 	fl6.daddr = info->key.u.ipv6.dst;
 	fl6.saddr = info->key.u.ipv6.src;
 	prio = info->key.tos;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					  info->key.label);
+	fl6.flowlabel = ip6_make_flowinfo(prio, info->key.label);
 
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
 					      NULL);
-- 
2.35.1

