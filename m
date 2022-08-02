Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C192587C11
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiHBMNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiHBMM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:12:57 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC252871E;
        Tue,  2 Aug 2022 05:12:56 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272AlwVo013562;
        Tue, 2 Aug 2022 14:09:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=SIiCmJXt9v+lY7Nu2rajGi53+FPokSY1UdV8paIPp1w=;
 b=QcIpp/EOeZ5NNaVIpOMti3p/BCFb4iG2FDeHECjVDodf7ehwboHV+Z24WO5wybVwdD6T
 c07bpJSi4fmELH+8oAqtU+8q+qs7EK1LCh0OHR4962N12Jbe5TOgoyhZWHDUUFaCOgpy
 lOdEYWPxHSsq4sd9e99IyS28V2d2H1Pc4asqdmQApSYz5zURtIxzmIydKTOHYseRuWxv
 x26tEw202BQ0Xb1/6NZDMxWRDdLm6m3ngLVkkNBBDcli+iEAHmPpWxnwzOfXf048RngV
 PrOwixH9r9/EYgkR7vIbilCx5/ZQMXJmjqMAxS/ZkaWp+DklaqaAfhemZBC3bGthEz3j yw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hms0c2wbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 14:09:55 +0200
Received: from Orpheus.westermo.com (172.29.101.13) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 2 Aug 2022 14:09:53 +0200
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
Subject: [PATCH v2 net 1/4] geneve: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 2 Aug 2022 14:09:32 +0200
Message-ID: <20220802120935.1363001-2-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220802120935.1363001-1-matthias.may@westermo.com>
References: <20220802120935.1363001-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.101.13]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: TXRr773tnxTrfU_syFXSbJceHVQAeTpn
X-Proofpoint-ORIG-GUID: TXRr773tnxTrfU_syFXSbJceHVQAeTpn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Guillaume Nault RT_TOS should never be used for IPv6.

Fixes: 3a56f86f1be6a ("geneve: handle ipv6 priority like ipv4 tos")
Signed-off-by: Matthias May <matthias.may@westermo.com>
---
v1 -> v2:
 - Fix spacing of "Fixes" tag.
 - Add missing CCs
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

