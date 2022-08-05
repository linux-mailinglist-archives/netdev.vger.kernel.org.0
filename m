Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3C058B05A
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiHETYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbiHETYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:24:03 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA986612E;
        Fri,  5 Aug 2022 12:24:01 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275JCsRd016655;
        Fri, 5 Aug 2022 21:20:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=OpFHzG1kl6wCe+/tAFHSweb+0GXtByAYdqY1N4yQX8g=;
 b=iVcpuJi3uZCdKrMqeLXNMxFHoWDGbBBCOhp2BuNBxmFmemCtBAK/y0Neq+hPorl6pEEm
 Ncq7t/W4l0BOlcV+KrRjnlFpvboLBpv7xFD3boS1BJGAtK72VRG6c+v1HRX/viME3OXT
 s5X44qdhLVSbvoMP+Jepqi7jmFGnoG40dpOzboPBFoVjxjN/xL+XpV4+8soYyp6JoQfc
 5k0xoI68iuzpZqIor/nd6e0hIhlaV5nMhLEP2lAio4qx4oX2vANzaNFOAO1ByIwpmvTV
 vDdPgcDt2+7t5Fbpb0ilEmOUvoy7uqEbU+Ta583+5by1wU0bgbZtUa3P6knx5Uuk3fhg nQ== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hr3tdsntk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 21:20:12 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Fri, 5 Aug 2022 21:20:09 +0200
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
        <jesse@nicira.com>, <linville@tuxdriver.com>,
        <daniel@iogearbox.net>, <hadarh@mellanox.com>,
        <ogerlitz@mellanox.com>, <willemb@google.com>,
        <martin.varghese@nokia.com>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH v3 net 1/4] geneve: do not use RT_TOS for IPv6 flowlabel
Date:   Fri, 5 Aug 2022 21:19:03 +0200
Message-ID: <20220805191906.9323-2-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805191906.9323-1-matthias.may@westermo.com>
References: <20220805191906.9323-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: goU3PmD8isX_P2PEqIj0xuXGqowA7BiQ
X-Proofpoint-ORIG-GUID: goU3PmD8isX_P2PEqIj0xuXGqowA7BiQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Guillaume Nault RT_TOS should never be used for IPv6.

Quote:
RT_TOS() is an old macro used to interprete IPv4 TOS as described in
the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
code, although, given the current state of the code, most of the
existing calls have no consequence.

But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
field to be interpreted the RFC 1349 way. There's no historical
compatibility to worry about.

Fixes: 3a56f86f1be6 ("geneve: handle ipv6 priority like ipv4 tos")
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matthias May <matthias.may@westermo.com>
---
v1 -> v2:
 - Fix spacing of "Fixes" tag.
 - Add missing CCs
v2 -> v3:
 - Add the info from the cover to the actual patch message (Guillaume Nault)
 - Correct length of fixes-tag from 13 to 12 characters (Guillaume Nault)
---
 drivers/net/geneve.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 4c380c06f178..e1a4480e6f17 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -877,8 +877,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 		use_cache = false;
 	}
 
-	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					   info->key.label);
+	fl6->flowlabel = ip6_make_flowinfo(prio, info->key.label);
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
 		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
-- 
2.35.1

