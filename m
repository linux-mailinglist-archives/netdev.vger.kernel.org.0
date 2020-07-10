Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936AE21BF76
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgGJV5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:18 -0400
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:49249
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726718AbgGJV5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0a8H+H/DZVUAsGdOEgIeyGmyHaW9dMcPdTI9Emwg8/BWVbq7Kgh99vqBms1PWkKTLI+H7z1emD7IMtqkpciC5mwr6Vk4/UWoGC9kr88Y2QzxfjAyj17VORRaX/fHn+Mo2n4xvXoE1G9zle4jbVN1Q5tbrzU6TUvBh3nZ24ZsAb9m3rQXPN1/rhv7wwBuT6EXM/OAqiYh/LvXeLp6WXEXGptwjoe0Wo+zXSugTLA81Ji0u+91B6axjUarrsVTFZv/Qs4hiBl+BimQWu8PEhY+4kr9LkIbzSWYN2lsluHZ3URWZeNJdxYFulscpe2Bd4N6XdSlPQeLEHtDhGaOFV/6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sDrEMF+P/VTQqDhUiMuzwpyFUE+VqcucGRh4JlbB2s=;
 b=aCmpkef12JaVoeSvawI4wnpkkxSqa2hj5gr8ThpiXgHiETZdx+MWIlW8sq9fBMPZKZKsIPOVWxUpINyVisq0hG2eIBTa/t+vMsPgEK3vzMHit4geNA+fWAkvUSeu7h8QpBuP14jV5F0ZXvJUVDb9RIwKCEiMQKB4psMELfhz9IK09LKMdxFragGe8erSBWFKEXaQMjYxR4U5VTOrkLEuMCegdbfmUYT/ij0NuzuV0q0NuEcMdTlN+sK/mvFc3EIAtJlKkWKjNwRrHQwSjT4p4OUZXPqzMud+kPtTlAnOlXG0EKyWaAsN+YTgNormUt2NGTAPmLELYgIViBv/TeNmhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sDrEMF+P/VTQqDhUiMuzwpyFUE+VqcucGRh4JlbB2s=;
 b=nT9ZVgMNx3uM63D6fOyQ3jaB/tHXihZIPkHLUyxomoyYEYbQ+BB1m+CpvRZLu1n6bSZ6FrRGtMvYG1yfXJfW74lGw2pNcoV2tol61S7K5Gc/LvBPS9fozTQWOihw3KIbYjx7yQo/wh93BmmvFgfGA2ektHRbYObUwl5XkABzTgc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:57:01 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:57:01 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 09/13] mlxsw: spectrum_flow: Drop an unused field
Date:   Sat, 11 Jul 2020 00:55:11 +0300
Message-Id: <c8f0498f1755cf5735666e4bf040d16dc975ac11.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:58 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e23e5e9a-d798-49a3-43bc-08d8251c2c7b
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335479EE933BA74E8020FA65DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWAWWQ+j93QN45EHb36QoEYsJepBatUyu4LZ4glGGrLMsVaX4LzUpEQJ3Q7WXcTHF0J5I4XkHadsSh5bkPwLsnVNWdJ7IavinM6PkD35XhpytF6at7bbBZCvSrPyO5F0qGzvhNsJ1AfA5pqtmCtRppy9BabzrOAcYqrspUdZVonx0o0gOjtZ/KsT05chBeW/H9V+jl4QrmjGXhuCnUUl6oi1qlTitwUyQiQzvIxRUNTei7w+y3XtQTWOr7rACgBEx55JZi6ygLVfTIRuH/pGxeWKnmnZ4XBPhnR10G4VuuUmQaNaYMYf5AXvqjUYTosk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(4744005)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ipYdvUXi2ith8CXNq9q3NPwI7r+d25y8dkDL3WrhAn37hmI59nghCJSxd0bH+4Yp6I0U+uUrLDEFDBesCzL6LfmQhFzDqkcv90mnyfq+i5WsMreUxv+FB4CpXTPSE3rG/A6jsdju8kSvZ7PZPpgtfn8AQKiLSBMGd/BgMiE3WWD8Kjm0WG8IVcDnoE8uVmu7M9ULEhVF1dtuK9M/1kmn7/NnVhVpb/WYNC8SWHf5u5Lug9rDySBL33GgJZeHgRDhXyMpnuRXAyvg62u3ndNqLRyS8PxNCWKDy20pyjKfSQ5uFrpPY+RlTUuXQ71QWPnMJMpbbjOMChXWfCoGvqgtWRkXnE4lmZaTuSjY7B4LiVL/doqGvdGNK7omnaLjzMRw6H10hy8YE2b/YdQopuPS6c8oTvTzMh3nshDHbh8EiYEVvqNgqXpH8ynHkN4KUfcb1I5X1JgzhA58ErIT1uaFiHlXCgB//yjxzbMj4NcERMc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e23e5e9a-d798-49a3-43bc-08d8251c2c7b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:57:01.1371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eb/Ot8ajRmNetM3GuiAidWg/CJzCCKzzGf25YdlkbpZcqk3v5VnuyoCUpHaR2MacV7got5/YdoMGiBFgdR4hMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The field "dev" in struct mlxsw_sp_flow_block_binding is not used. Drop it.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 18c64f7b265d..ab54790d2955 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -710,7 +710,6 @@ struct mlxsw_sp_flow_block {
 
 struct mlxsw_sp_flow_block_binding {
 	struct list_head list;
-	struct net_device *dev;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	bool ingress;
 };
-- 
2.20.1

