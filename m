Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843CB4C8AA2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiCALZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiCALZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:25:13 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300111.outbound.protection.outlook.com [40.107.130.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A5291371;
        Tue,  1 Mar 2022 03:24:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuD6udBSMGyv07EpLMn/6RyrR5JeJTUhXJhhNt2OmJ+lErK9DVQs0MVHS8rvxAD9L66r2coeIOwqu/XBeddK7y2+o6T1hB9IYVKlzrboTgddkc7gneSfpaz672sSe1tN91PBXeedWlVqQrcjBWkhIn8A8KAR4qXjocNEhDZyON/8MY6/w0CDFKpLmp2yFS5y8M7ltV1yupUbaxxwCXaPbpeFX68PqNZJgpH/5Aib3jblp7nPbiE7zqRNtmNZQHRIwuQSNonOjDy04jGtmlJ61GyCxVCHbrj8ORFdSIb7Z3iLQfpRX4/nsVdXZgTZqNt8cJHd/wutVlTeJrjanXsFXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFpq1M0HqDUQT/8prLjKkFrjTF35ewpOobWEVPlKP+Y=;
 b=bP21JG0KT8RQQSbJ1wj7L5qp14HAejD9iSyo9hkpcJnLyfpfuCu75DXp+Dun1VSNj9WTy8auMSIqeKioFJNpqD2KV3Yp+1Qow4WOAsi5Q4SGGf/Kgz/Mqb2/8wrYYcLpGRUNjfng9reRxrmw+O3NlKO3XObZTo+V0UMDfaAYIf8bzhb987L+akz6xjyEnWwzYyDMxDUu+jAjespLuAQw/5KgO0lR8iRC5TZz+fA1qb+SAlLzj837lQwRb5BC90VySiMx8sjVNZaN4Nq1pk57IodzaGRmvdSI5AJY/mnd4JCat8OaW1vT7vr9i50Rdd5m3axL3PvqeCVq+uiJQWPb6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFpq1M0HqDUQT/8prLjKkFrjTF35ewpOobWEVPlKP+Y=;
 b=o0ebFX1bjLdxWmsivx/X5XL9Tinew7RdM8FqIISlcIjdtIF4I3tHStPXXnnJ3PmzouvcDyzaS7Pxq7U50+fHc7knI4X4Ddv55njpN2q+YnvnYXJvCByg9ulK3PVS1uUpDcSuFmgnQ9iBi03+Gpimto+o7ZTzPtcaYgJixwA5AVY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TY0PR06MB5079.apcprd06.prod.outlook.com (2603:1096:400:1b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Tue, 1 Mar
 2022 11:24:29 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.5017.026; Tue, 1 Mar 2022
 11:24:29 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Peng Zhang <peng.zhang@corigine.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@qq.com
Subject: [PATCH] nfp: avoid newline at end of message in NL_SET_ERR_MSG_MOD
Date:   Tue,  1 Mar 2022 19:23:54 +0800
Message-Id: <20220301112356.1820985-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0053.apcprd03.prod.outlook.com
 (2603:1096:202:17::23) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb37f46f-3b47-40bd-22a0-08d9fb760cdb
X-MS-TrafficTypeDiagnostic: TY0PR06MB5079:EE_
X-Microsoft-Antispam-PRVS: <TY0PR06MB507940A837991956F2EDE389AB029@TY0PR06MB5079.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eInhEY7xKL6fn7abnxk2XajlsjDbuQOA+Nl1Q7JCQi+Jl+0ngvCBOS56FEkwUk9mi18WBvaXUz7gQOvizwJaup7BMK7BOTgNqErr/VGsKLIPlvOgzlpGzb1nXC0FDyElwDr4gwZqMH7miJr/lwEzxn0n89zbNFx7th/xD+/ZLH3gb3yGSUzoIjNhgSvpfyO8vAvwmg5LV1dSIaG62TZEqfvcE+pdizZFJ4aylGIC9bEoR/4Dgq4QOYv69c5TsqymsSvMXEn7m+Gs38UuDlqVqozABp5Dh19Bj4toHMIGPNEdBNkIKGTNl+jBN72S80vo0s9+HzVe6W9ixrmKieX+00EYDR9/nUfqtL82ruyfBfV8fi33Plj6738C7YTQ6HMAggqzR8wrfHhERUfUL3dKyFmjbbltKswUCNGNc8YSKLRJiHE4Y2P8u0jc8GX/+koCAngg6SoiWCSKC39+YuKSYmbD6fnuxoUXPxxw4oU4035UTMb+0zj+4IuhDq1zIOaRSkL8aWqyQinUFbfZFizqzdugG6hoEqyuG4HoJ/7/xtr3HWZyYBAD106u/c9SxYzRJoJ5xjknJFsIabp4JpFB6bQbfFU9GBtK2ZRzUxMPl+yfocFfZapkGnark6i1laeysFa6vqZ9DYkI+6lUK9qmzXuIDmefPc8P/CyLtanmIzmqiB2qv8676ZoxDpmhnUdtRyec/qBuTIhs+hWlMQOd7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6512007)(38350700002)(38100700002)(186003)(7416002)(5660300002)(36756003)(8936002)(1076003)(83380400001)(52116002)(2616005)(4326008)(6486002)(86362001)(316002)(110136005)(6666004)(508600001)(6506007)(8676002)(2906002)(66556008)(66476007)(921005)(66946007)(4744005)(15650500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+PbJ+MFtKSatVK++/TW4UzIwgU7NbUkFDmbD05M49vRKckn0FgjSW9GdMYX?=
 =?us-ascii?Q?QIXZTd1WNgEHLwwU7L64y2Ch2AUOvtiT0As86hgcHrs6LCInh/ruVncnzRik?=
 =?us-ascii?Q?lJjJgii9fBeGqWbueyZHgbVs2wUcrffS7uW4se/toNZT6LK6TOK8vA6lj9bF?=
 =?us-ascii?Q?n9L4SYNix7OHb4I2DiFEct539uDDT5VJ91+ErIIo3n/0tAu/bq8SQmZfgNRv?=
 =?us-ascii?Q?Q/qQLPJgj/oInW3NKUlzu8o+QseMC0o8GFXlvw4QQUtwfsztS6gdi9QB6mPZ?=
 =?us-ascii?Q?xchK3PxKARXqWan7Y89jC4EI9Hc78l9VOWhh7qf/PyF/fq5VnjzPyuDTEYDJ?=
 =?us-ascii?Q?K96KNXAItjgkoQTeHSihGujKAFh4TJ8YR6s5HrHXUsA1idmMzQx6TYcqacy1?=
 =?us-ascii?Q?UpLgufg00IV3uZbwjrckKfaEddnTosVvcVQKQWFdTb8Bal6UiNkfJwBVe7fD?=
 =?us-ascii?Q?rE5kxmrXpJ/VK9XyA8A9A9372aelRKLtz9fynrCjXsEhKpBLBErhS00USiuG?=
 =?us-ascii?Q?P6dLvUjq9gofL4TNmrJyVSLY4/o/2tz0bL1BwYMeUepFm26Cot5n9OBeUBfZ?=
 =?us-ascii?Q?zLV11Z8orVivHaUCGwrpfPo8PtlnRMpyMZsixqa22PlCRYyRvzimJeMOZa13?=
 =?us-ascii?Q?VfLZY8YSpV22Q/Y55Qy1l1S8x1H9TDH3pZBI5dBVufuQG12+CTqA205cg9Qn?=
 =?us-ascii?Q?EZEAxY4JLFS/Qsa/ZRQKeGd5wDziybBU9ThY4yk4mbUhwD3kacO4mafnftdu?=
 =?us-ascii?Q?Z/eY4IWK1w5vaaE7TDzEkPCG20eH8IkEv9J7+9c9Z0mog4Sp81sSxLO+XdBD?=
 =?us-ascii?Q?v/3yC8+E3rUfMVQD+ICmvpEnBB9WlvJ/tc4+Ky1zTrdJrkLcP8CU3jqQuMEK?=
 =?us-ascii?Q?3ISAxRJyjz+mjMOwerPZk7IptTuUmvQbcjUodBUjUueM9jN9AZcPdaTDfa8e?=
 =?us-ascii?Q?Fbuv05CtzVI2pi3idTcLItzP8rMlcNJL5k8nDLkU1tHRt9jewOrYen70Smad?=
 =?us-ascii?Q?/CB1j6yH8VSoQ4QriCikIbAQBbVzGZZxNhbUcyOjA9zWXeTo+dPG4Xzx9akY?=
 =?us-ascii?Q?edEB7c4NYrwHTKZnO6RJdL5QqOSMK1R6JhJ/fZwgqGi/o43DqTcbIerVRPgJ?=
 =?us-ascii?Q?xW9V+ec0i69ehVuye3CceRjZXT3qI2uahfhtv/mlByJSGl3R3mp1QhV8tTxB?=
 =?us-ascii?Q?GybEiyIhdCywtUj62Zo7Wqs00kLdW4QsVlLzilM5GuVnu50/VkqLfoZnmUVD?=
 =?us-ascii?Q?4oqd3YMKv+MdQYFgWt5aCXtU0HlqS3wORvF6LD+xM36wmz9LoK0bGHgo2779?=
 =?us-ascii?Q?/UNkM5wU9LVXC/ZbTAja/H/TRbuLfKmhkMp+13VCPzqWlNltSYgMZIpsSVS7?=
 =?us-ascii?Q?K1FlWyrZiHooN5cWw3V48JlfpFj3L885EeMt7hKvduUDJJWZ471fsg8P9f3T?=
 =?us-ascii?Q?bLp+6ZS4XxEkMDSMYUF8B80XnxSEV2F7U+c2iwAmZssyBS0SlY5JZHvbul3c?=
 =?us-ascii?Q?/b+iGS3Fu9AYvLF9Wm7zL17KcmVNHyMHCEF+S8O3TtZ/W1alA+nzjVuGrA2Q?=
 =?us-ascii?Q?GG7NCmm3+vCv924J31atyrAFEYXcRWdRvrV+j8i9ziDVCn6pT9EZriT3rjC0?=
 =?us-ascii?Q?TTqWynbuKvuGS82iQey5v20=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb37f46f-3b47-40bd-22a0-08d9fb760cdb
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 11:24:29.4723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0uTmYbrPax9ebem2WsmXO10RuY5l4a/Dep5PGlJVoaJYkvbpyATFOB94K8SG4bJ+rzbjD6XPQEfnR5zbDrVXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5079
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/ethernet/netronome/nfp/flower/qos_conf.c:750:7-55: WARNING
avoid newline at end of message in NL_SET_ERR_MSG_MOD

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index cd3fdb9f953b..3206ba83b1aa 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -747,7 +747,7 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	meter_entry = nfp_flower_search_meter_entry(app, meter_id);
 	if (!meter_entry) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "no meter entry when delete the action index.\n");
+				   "no meter entry when delete the action index.");
 		return -ENOENT;
 	}
 	pps = !meter_entry->bps;
-- 
2.35.1

