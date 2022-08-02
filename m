Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E97E587B61
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiHBLOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbiHBLOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:14:11 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EAE1835B;
        Tue,  2 Aug 2022 04:14:09 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272AqotW029528;
        Tue, 2 Aug 2022 13:13:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=qzoiygoNP3aKHBU59YwFwlDaf3F38U+FwxB7grTnLfg=;
 b=RI6w56erWjaWVrwEz/AujQ1SNFoXRSblYjthE9nzGQ/D1wkSTacmTDR4jil83+xVtQCy
 29Cu//n2F0THt/01/+axhTNGYIEyv4MbZCN3MJQSQQwHJEb6M5OXDewyjZrauTk0JWVY
 nfCJJr72FH4OzYBbON0kcfCGml7V5SsK6AwXLS3Xgd9xk7cPkB+IDQ31DSHnIR65oeh5
 /04yqkamwwsxa5dKpa2TwyRv63BE2ix3lP0lB/H/TIq2pR+We622hv6I2/CMrOS9CIcX
 7DKpIBj+Dae9VBouF2EWkUP6F3N8olYWgRWm6gLOdSoAMNnTcaYd3NeJR6giYJCkgSqx /w== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hmrn42u0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 13:13:41 +0200
Received: from Orpheus.westermo.com (172.29.101.13) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 2 Aug 2022 13:13:39 +0200
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
Subject: [PATCH net 3/4] mlx5: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 2 Aug 2022 13:13:07 +0200
Message-ID: <20220802111308.1359887-4-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220802111308.1359887-1-matthias.may@westermo.com>
References: <20220802111308.1359887-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.101.13]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: 4kZqUP7mwkKp_nVO2BtZHMDBUjOJGro6
X-Proofpoint-ORIG-GUID: 4kZqUP7mwkKp_nVO2BtZHMDBUjOJGro6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Guillaume Nault RT_TOS should never be used for IPv6.

Fixes: ce99f6b97fcd ("net/mlx5e: Support SRIOV TC encapsulation offloads for IPv6 tunnels")

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index d87bbb0be7c8..e6f64d890fb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -506,7 +506,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	int err;
 
 	attr.ttl = tun_key->ttl;
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
@@ -620,7 +620,7 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 
 	attr.ttl = tun_key->ttl;
 
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
-- 
2.35.1

