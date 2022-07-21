Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C9957D69D
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiGUWMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiGUWMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BC8951D7;
        Thu, 21 Jul 2022 15:12:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNbypd+IRF0VaY9yOLvMd2LgqtEm0HIRKZuEGL2kiBjMduJa/1+92A6Nl2spoYWKy0Q02iS4O6Ejh/pVLSLHPuDzsu/+vdymABc/Z7JVy97XK601EEhDucuNQQO31MOvKVpyomx/3BU7tPQR0htux2+j13g6g9qZx/QihqeElEyb+iX8VdtzIpxpWVLFbnS7qiFZ75HTxxF2ADoptwpKKvnn8Q2bvf7PWYXG2cCpi8H9oBY6A5QiR4PtCrAUZ6X/s+AMya3QN+QsxZhtrn47EFARxPiZmJkObdA/pEqwwM90MMe9cj1/aXp8EZO8zedR6SAnqRnKwJX9Z27RtRk4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45y6Pg6TMsmi/tyvomHD/Y8AQogHGv76yBkBbX7Q/Zg=;
 b=VTAUcUlWyoq53AryRqYm2qWaakpUbisuskqp+EypX8ZQaq0O05waOGiQqSnyNonmgCE28bcKFmJlXvrmfr2q6uzW1e3F8Ca+0vjtJJdM4n1AOJVrHXOY1Yg2ST9XcvM4MCpDrOaVaCL9oe9t/3SFtv4o5sQ+tqyK2GymfP6seEAKgBX3HFhbo/rh0zB3yRlWuVReb2R8nqK6ZOsfPZyZW+iSt1owfyyPwj//qCLr20InK7lEVqUlDF+bQHeIzcwVLG4316voKAqXJ0H4b8x7EhFusiYtFmep5gZb2QTNQtvNFL8Jkie80wjmrCdLtgWtYVNfUtmG+S7mXx+4/nf84A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45y6Pg6TMsmi/tyvomHD/Y8AQogHGv76yBkBbX7Q/Zg=;
 b=itoE2PjyNwOU6MAQ0dR2S7d5wfuZhGX2pY3DUA8IQ6S1JxilM0q9MayZAKZJgJpRiBS8xjAA1l4U35ta/imD1uyExsH+nsz8+iDgZGeq0mp3javpN9PCBsqedEO8r2xBnfvqBwsgAHwazx/yS7FU7rgAw0W2bf2jnsmS2aKJWO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:12 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:12 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v2 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Fri, 22 Jul 2022 01:11:45 +0300
Message-Id: <20220721221148.18787-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dabdbd7b-2621-4325-d7b3-08da6b660fec
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jLkIaqzh4kjUzRx5cPtVIQS1q4LVsPsHIQ4hID73awzmmke63Suw/+U3mMdBwUjxGEOiP/PY6fdiCBDY0d20/AUe4Q99HLo3ieX/YHQJ0cIIfZbTh5N7E01FM6vXdGiIZYqvhV2JWEfqO6c2BtOfc62xJX1FBOGRvgTQ8p6cCvlcNe4lR1WkeIdT92CXADXFLjOfNPFROlVtHvYBtSpj6VMY9DSTTwzSu6wSgbIZth2pnEA7aB1FCbLroA+K845W35AQQc6PRDNMsLzM9Kuz7RUt22cWfjSwSMJC5DS3wG5fJ7NQfCv6TcmAxRYBtLVLHmsybgAwO8th9iJrWSXHt2QUfnGL7HRC9vhJOPsVgZxGi8CLBhjmZDeUcOev9NY+x2XLY4Bc43HN9fGvjmtTn6GyGNvkyvFPrNrq1U7n9RVGg0cb/KhFShyQR3XzdExQT7hStQfJfoYMY+MhHyqDkcxTSXAPCiMBWHp/LM7dC5wa141Yp0ogQAW2MtEphHA4KmH7qlVHsoX0tfs6RM/jXiDrlH35C/JrrlocwYP6IpYjxHjkYvXAXFfZiw83yfrf4h3/CmABGnme3mbBQ3ywwUT7atA11shOsx8HhECiXreDsFMW1/WTikcSLNSFqmt1Ya4gMMmYKUIv10X3Y6/+fZgixg/PXEVQWCYXZ4wX1kc6Sh2vvffOjhAORImi2zAfxSJoYi4aqYSO7aSUxFUZobJBfFQtF+BjgTa7gfCzYxEbUlxLkr2k+qDQgxF+r4YsUSNQOkTVNp54NuqIdrsBJ1p/FQaqS4ke7ubjPmQbFc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(30864003)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mDv2vAMBDSwVBJVTDe6W6+xG/BfknfVkqikspzaQrMlCp/Cfh5IDFCYGF5kL?=
 =?us-ascii?Q?gDIFjF3nSm6CkuzEiFY4EGHE36a1aVo83Q5SVh+wTTYdp8T7BlaF98eCa2GM?=
 =?us-ascii?Q?XUlZDbcR3bsYRL+4P18WeMjsYfaX32+sMGW/jOULMgJYM4l1WgRsSHfEsqRS?=
 =?us-ascii?Q?Ua8IvAdx1R3SLWFtLPJ/4fy4F06HbWGfkwGB/KD9qQht6OrLVBlnD2NvX6qd?=
 =?us-ascii?Q?7Uz+IogXD3s1MBEahG8IpMgutCLlvwcobmY4i6LBlaIuPR1LRmrnIn1DOb2t?=
 =?us-ascii?Q?OD6S3OHJwJptvtITsSyZbxzglXX1YujyT2DdDfNxBTx0d3i/buXAXle0bYo0?=
 =?us-ascii?Q?AjNJjeuF7ZMh07a23vQqvSnO5+43XWCWBvyFDP7lSwPbHw+p7no3FlzgNXiE?=
 =?us-ascii?Q?NEOieBE0WqE64mm2ruaBOMPcr6UdA2LIIPesgUcDTba3ehjisilXp1LnEd9b?=
 =?us-ascii?Q?TLU/GWQ4sX0PuqDFQLI982PQ014uxkERdLj5/udYKMf1nfaozL3ugEIPweTH?=
 =?us-ascii?Q?+GCwaSjuhsDMjoni8qmO5ounXBxXTKe3eENAJK5zch4M2X2xZwBdtkjmZlgO?=
 =?us-ascii?Q?iaM9qjTQ9+oFpiqqXrqETuO2fev81hD9ovp+NgqB2fDq0dkC0aposfTqP+tL?=
 =?us-ascii?Q?d9pemcQEUngH4SI0WBgO1QeGUJe3IAp+PbhZzqUEbN3X7AT4WKdpbGV9h9FZ?=
 =?us-ascii?Q?NLyEZZCe00YoOo/JM4ARzh7m8Q2t6nUiaTZG86LjAg3GkdmpzsPHN6MzzCe8?=
 =?us-ascii?Q?c2L36CsUb5jab2Kq9zQedUXjiFlB5ymd53vaC3u2OPbXa7a/JnNOPsX1cuqQ?=
 =?us-ascii?Q?8cVp7Bqbn3EdO220aYVdnapW7zhCEzKT2q+0+5GVlAV4iKILKlg1CHnkXAwM?=
 =?us-ascii?Q?AIrPcI3qU5JKSng3WmqdPSyC77S6t5103zK9Dpk06KUD3Q3sMIRwMnf+/THA?=
 =?us-ascii?Q?vjFr47srMKRMfKTqLgtD4z5vKrVeqctg8yTqyMhDMiUf9GAG2SUH/Of93m6N?=
 =?us-ascii?Q?r0SwilQZNTiuNJoM4CsutDNvydMk0xow4wULgzNW8qq4ZpyHJnE39jXfbakh?=
 =?us-ascii?Q?AfVy19UX+GKRbNHtirKt5j1HWILz0t58WEOvQKu3MCq7JDlwljXzG4kOgP9R?=
 =?us-ascii?Q?gUyksTSYBzFiRe2RsiwYd45EKgZjv4eRK9KYmN2bsU9a7JF1jyx+HKvsrtpJ?=
 =?us-ascii?Q?tmlNQGLdX3KrEdzN5dpUgWGDE4NTI8MCaa42crbWxtUVWZt7AuZ0NtYHwuM2?=
 =?us-ascii?Q?XxrnsI2FpSoiPbyXWikbNv/eHJWSsYN5HMDtO5lFJn/yAOXUHhrGsARRkLW2?=
 =?us-ascii?Q?n52kMJyKBEMYeJ1xGH1Qq5rMqj2TrwT1dXc2eGfUEOc9YQcMT+U5Ye5PW66e?=
 =?us-ascii?Q?bSeIJoCUDcKrzeHiqgKMvT7QeHXblowzloVnou9SXUNTUqXjYomHEZjz4liu?=
 =?us-ascii?Q?Z1DI7TsYLs+cVcIKloZV3RiT8WiU17av6x87pBpliS/gI4UVSDffk5QBs6TJ?=
 =?us-ascii?Q?4j07KnZUgL4YuiiBguf3fi0ZWhua/CLG4qYX1Zc3bPT7KtXBgboLGX+gv9zZ?=
 =?us-ascii?Q?73HXqkmEZeSkfBttYotgtHN1KaU8REWxxde2kCZp4eEWLQ7T/v0FwIUsUmNS?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: dabdbd7b-2621-4325-d7b3-08da6b660fec
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:12.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWMaYnTojDi3SS6RflBPzHQbDP6qPm5s5LMf4/E9/jjsuvgujZr87u4LqxpFaPpR2nyxKTkm5R/6g7ocjyMasw3D5tRA37/FFTECMvAWOU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to implement nexthops related logic in next patches.
Also try to keep ipv4/6 abstraction to be able to reuse helpers for ipv6
in the future.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 311 ++++++++++++++++--
 1 file changed, 277 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index db327ab4a072..7e3117399432 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -7,6 +7,7 @@
 #include <net/inet_dscp.h>
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
+#include <net/nexthop.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -26,9 +27,10 @@ struct prestera_kern_fib_cache {
 	} lpm_info; /* hold prepared lpm info */
 	/* Indicate if route is not overlapped by another table */
 	struct rhash_head ht_node; /* node of prestera_router */
-	struct fib_info *fi;
-	dscp_t kern_dscp;
-	u8 kern_type;
+	union {
+		struct fib_notifier_info info; /* point to any of 4/6 */
+		struct fib_entry_notifier_info fen4_info;
+	};
 	bool reachable;
 };
 
@@ -51,15 +53,253 @@ static u32 prestera_fix_tb_id(u32 tb_id)
 }
 
 static void
-prestera_util_fen_info2fib_cache_key(struct fib_entry_notifier_info *fen_info,
+prestera_util_fen_info2fib_cache_key(struct fib_notifier_info *info,
 				     struct prestera_kern_fib_cache_key *key)
 {
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
 	memset(key, 0, sizeof(*key));
+	key->addr.v = PRESTERA_IPV4;
 	key->addr.u.ipv4 = cpu_to_be32(fen_info->dst);
 	key->prefix_len = fen_info->dst_len;
 	key->kern_tb_id = fen_info->tb_id;
 }
 
+static bool __prestera_fi_is_direct(struct fib_info *fi)
+{
+	struct fib_nh *fib_nh;
+
+	if (fib_info_num_path(fi) == 1) {
+		fib_nh = fib_info_nh(fi, 0);
+		if (fib_nh->fib_nh_gw_family == AF_UNSPEC)
+			return true;
+	}
+
+	return false;
+}
+
+static bool prestera_fi_is_direct(struct fib_info *fi)
+{
+	if (fi->fib_type != RTN_UNICAST)
+		return false;
+
+	return __prestera_fi_is_direct(fi);
+}
+
+static bool prestera_fi_is_nh(struct fib_info *fi)
+{
+	if (fi->fib_type != RTN_UNICAST)
+		return false;
+
+	return !__prestera_fi_is_direct(fi);
+}
+
+static bool __prestera_fi6_is_direct(struct fib6_info *fi)
+{
+	if (!fi->fib6_nh->nh_common.nhc_gw_family)
+		return true;
+
+	return false;
+}
+
+static bool prestera_fi6_is_direct(struct fib6_info *fi)
+{
+	if (fi->fib6_type != RTN_UNICAST)
+		return false;
+
+	return __prestera_fi6_is_direct(fi);
+}
+
+static bool prestera_fi6_is_nh(struct fib6_info *fi)
+{
+	if (fi->fib6_type != RTN_UNICAST)
+		return false;
+
+	return !__prestera_fi6_is_direct(fi);
+}
+
+static bool prestera_fib_info_is_direct(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		return prestera_fi_is_direct(fen_info->fi);
+	else
+		return prestera_fi6_is_direct(fen6_info->rt);
+}
+
+static bool prestera_fib_info_is_nh(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		return prestera_fi_is_nh(fen_info->fi);
+	else
+		return prestera_fi6_is_nh(fen6_info->rt);
+}
+
+/* must be called with rcu_read_lock() */
+static int prestera_util_kern_get_route(struct fib_result *res, u32 tb_id,
+					__be32 *addr)
+{
+	struct fib_table *tb;
+	struct flowi4 fl4;
+	int ret;
+
+	/* TODO: walkthrough appropriate tables in kernel
+	 * to know if the same prefix exists in several tables
+	 */
+	tb = fib_new_table(&init_net, tb_id);
+	if (!tb)
+		return -ENOENT;
+
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.daddr = *addr;
+	ret = fib_table_lookup(tb, &fl4, res, FIB_LOOKUP_NOREF);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static bool
+__prestera_util_kern_n_is_reachable_v4(u32 tb_id, __be32 *addr,
+				       struct net_device *dev)
+{
+	struct fib_nh *fib_nh;
+	struct fib_result res;
+	bool reachable;
+
+	reachable = false;
+
+	if (!prestera_util_kern_get_route(&res, tb_id, addr))
+		if (prestera_fi_is_direct(res.fi)) {
+			fib_nh = fib_info_nh(res.fi, 0);
+			if (dev == fib_nh->fib_nh_dev)
+				reachable = true;
+		}
+
+	return reachable;
+}
+
+/* Check if neigh route is reachable */
+static bool
+prestera_util_kern_n_is_reachable(u32 tb_id,
+				  struct prestera_ip_addr *addr,
+				  struct net_device *dev)
+{
+	if (addr->v == PRESTERA_IPV4)
+		return __prestera_util_kern_n_is_reachable_v4(tb_id,
+							      &addr->u.ipv4,
+							      dev);
+	else
+		return false;
+}
+
+static void prestera_util_kern_set_neigh_offload(struct neighbour *n,
+						 bool offloaded)
+{
+	if (offloaded)
+		n->flags |= NTF_OFFLOADED;
+	else
+		n->flags &= ~NTF_OFFLOADED;
+}
+
+static void
+prestera_util_kern_set_nh_offload(struct fib_nh_common *nhc, bool offloaded, bool trap)
+{
+		if (offloaded)
+			nhc->nhc_flags |= RTNH_F_OFFLOAD;
+		else
+			nhc->nhc_flags &= ~RTNH_F_OFFLOAD;
+
+		if (trap)
+			nhc->nhc_flags |= RTNH_F_TRAP;
+		else
+			nhc->nhc_flags &= ~RTNH_F_TRAP;
+}
+
+static struct fib_nh_common *
+prestera_kern_fib_info_nhc(struct fib_notifier_info *info, int n)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+	struct fib6_info *iter;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return &fib_info_nh(fen4_info->fi, n)->nh_common;
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		if (!n)
+			return &fen6_info->rt->fib6_nh->nh_common;
+
+		list_for_each_entry(iter, &fen6_info->rt->fib6_siblings,
+				    fib6_siblings) {
+			if (!--n)
+				return &iter->fib6_nh->nh_common;
+		}
+	}
+
+	/* if family is incorrect - than upper functions has BUG */
+	/* if doesn't find requested index - there is alsi bug, because
+	 * valid index must be produced by nhs, which checks list length
+	 */
+	WARN(1, "Invalid parameters passed to %s n=%d i=%p",
+	     __func__, n, info);
+	return NULL;
+}
+
+static int prestera_kern_fib_info_nhs(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return fib_info_num_path(fen4_info->fi);
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		return fen6_info->rt->fib6_nh ?
+			(fen6_info->rt->fib6_nsiblings + 1) : 0;
+	}
+
+	return 0;
+}
+
+static unsigned char
+prestera_kern_fib_info_type(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return fen4_info->fi->fib_type;
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		/* TODO: ECMP in ipv6 is several routes.
+		 * Every route has single nh.
+		 */
+		return fen6_info->rt->fib6_type;
+	}
+
+	return RTN_UNSPEC;
+}
+
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_find(struct prestera_switch *sw,
 			     struct prestera_kern_fib_cache_key *key)
@@ -76,7 +316,7 @@ static void
 prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 				struct prestera_kern_fib_cache *fib_cache)
 {
-	fib_info_put(fib_cache->fi);
+	fib_info_put(fib_cache->fen4_info.fi);
 	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
 			       &fib_cache->ht_node,
 			       __prestera_kern_fib_cache_ht_params);
@@ -89,8 +329,10 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_create(struct prestera_switch *sw,
 			       struct prestera_kern_fib_cache_key *key,
-			       struct fib_info *fi, dscp_t dscp, u8 type)
+			       struct fib_notifier_info *info)
 {
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
 	struct prestera_kern_fib_cache *fib_cache;
 	int err;
 
@@ -99,10 +341,8 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 		goto err_kzalloc;
 
 	memcpy(&fib_cache->key, key, sizeof(*key));
-	fib_info_hold(fi);
-	fib_cache->fi = fi;
-	fib_cache->kern_dscp = dscp;
-	fib_cache->kern_type = type;
+	fib_info_hold(fen_info->fi);
+	memcpy(&fib_cache->fen4_info, fen_info, sizeof(*fen_info));
 
 	err = rhashtable_insert_fast(&sw->router->kern_fib_cache_ht,
 				     &fib_cache->ht_node,
@@ -113,7 +353,7 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	return fib_cache;
 
 err_ht_insert:
-	fib_info_put(fi);
+	fib_info_put(fen_info->fi);
 	kfree(fib_cache);
 err_kzalloc:
 	return NULL;
@@ -126,21 +366,25 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 {
 	struct fib_rt_info fri;
 
-	if (fc->key.addr.v != PRESTERA_IPV4)
+	switch (fc->key.addr.v) {
+	case PRESTERA_IPV4:
+		fri.fi = fc->fen4_info.fi;
+		fri.tb_id = fc->key.kern_tb_id;
+		fri.dst = fc->key.addr.u.ipv4;
+		fri.dst_len = fc->key.prefix_len;
+		fri.dscp = fc->fen4_info.dscp;
+		fri.type = fc->fen4_info.type;
+		/* flags begin */
+		fri.offload = offload;
+		fri.trap = trap;
+		fri.offload_failed = fail;
+		/* flags end */
+		fib_alias_hw_flags_set(&init_net, &fri);
 		return;
-
-	fri.fi = fc->fi;
-	fri.tb_id = fc->key.kern_tb_id;
-	fri.dst = fc->key.addr.u.ipv4;
-	fri.dst_len = fc->key.prefix_len;
-	fri.dscp = fc->kern_dscp;
-	fri.type = fc->kern_type;
-	/* flags begin */
-	fri.offload = offload;
-	fri.trap = trap;
-	fri.offload_failed = fail;
-	/* flags end */
-	fib_alias_hw_flags_set(&init_net, &fri);
+	case PRESTERA_IPV6:
+		/* TODO */
+		return;
+	}
 }
 
 static int
@@ -149,7 +393,7 @@ __prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
 {
 	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
 
-	switch (fc->fi->fib_type) {
+	switch (prestera_kern_fib_info_type(&fc->info)) {
 	case RTN_UNICAST:
 		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
 		break;
@@ -274,14 +518,14 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 static int
 prestera_k_arb_fib_evt(struct prestera_switch *sw,
 		       bool replace, /* replace or del */
-		       struct fib_entry_notifier_info *fen_info)
+		       struct fib_notifier_info *info)
 {
 	struct prestera_kern_fib_cache *tfib_cache, *bfib_cache; /* top/btm */
 	struct prestera_kern_fib_cache_key fc_key;
 	struct prestera_kern_fib_cache *fib_cache;
 	int err;
 
-	prestera_util_fen_info2fib_cache_key(fen_info, &fc_key);
+	prestera_util_fen_info2fib_cache_key(info, &fc_key);
 	fib_cache = prestera_kern_fib_cache_find(sw, &fc_key);
 	if (fib_cache) {
 		fib_cache->reachable = false;
@@ -304,10 +548,7 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	}
 
 	if (replace) {
-		fib_cache = prestera_kern_fib_cache_create(sw, &fc_key,
-							   fen_info->fi,
-							   fen_info->dscp,
-							   fen_info->type);
+		fib_cache = prestera_kern_fib_cache_create(sw, &fc_key, info);
 		if (!fib_cache) {
 			dev_err(sw->dev->dev, "fib_cache == NULL");
 			return -ENOENT;
@@ -512,13 +753,15 @@ static void __prestera_router_fib_event_work(struct work_struct *work)
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = prestera_k_arb_fib_evt(sw, true, &fib_work->fen_info);
+		err = prestera_k_arb_fib_evt(sw, true,
+					     &fib_work->fen_info.info);
 		if (err)
 			goto err_out;
 
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		err = prestera_k_arb_fib_evt(sw, false, &fib_work->fen_info);
+		err = prestera_k_arb_fib_evt(sw, false,
+					     &fib_work->fen_info.info);
 		if (err)
 			goto err_out;
 
-- 
2.17.1

