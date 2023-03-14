Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555366B8B4C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCNGhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNGhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:06 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2122.outbound.protection.outlook.com [40.107.95.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC49F7C3F0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbmyEZhzs3YMseh7ZZw9M/Rb+6VMyBUvfknIMMl51xVUNQdCJDEUOJB0UNGlW1bdZjN+vYkBAwmNAnF1Ya6RcpOij0gyFbsIiDF5UY8LCv1tdwP+WCAY2EDm4dFEW6swVsuMgF51peOkAqQwKk35DytdOccDAMjldffutcA1xrroDmU3bOh7LKlMqXNa52EiAj6wdIJIA5QaZ1HQBI8F7IhMo6NRUG3ktWHUSCb+ZQUsFijPox0uVmooq6gFDIbZ86R0syz5Z2tGF3Bdb5eGxx5ZexKUuk5uDX1NjHKwivGLaF/sOS8KfX7PAqKN/5W9N7iHltooOskvSqe3p2ufYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ThK5VKosdzObkrCu7BV/WxZ2JiCcFM5ZqVokEi1fOs=;
 b=B7ZYyW77rs1lWcc14NFW4R21sjwl7+92lh6fw21JNW6yjUXjH8LzOiC11p4KHfQsFcx6IdWUuDkk+CTQOPUL2VtxMMUjLJGbSJtRQTvzVvI4eRLhxhK2CSQrJltEWJ2umNWBlvHHsWDVUQ9py7p2tjPdr0JbA38wgKX9pXHMZQfQCXvNNUi1CAln8CIOrkJxjBvpzBSI4ZAW3nbUvMBOuPJDKbewmZUClv1sEY7XzAGJ17WVn8vGxzXuykBpzzqP+tAQC+Ii70hMy+JPyCAGvHfvnuulsLNLOpNeoUpRqWiJ17Eu2c2Dtzi8v9YXP1mtLEHQb30gPQr0XtMiwdMcPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ThK5VKosdzObkrCu7BV/WxZ2JiCcFM5ZqVokEi1fOs=;
 b=mKS5pw3rrcA+JwqNOh5f/eADPG+oUW6leMUSxeDKs9rCjVKY9u9e5KbTn+fe0JWC9FtGKwGU2o2CjujD5mcvfLlG/d7S/fTdiynEiDhdmIi4FafEWPVBuhDS2JtzH5943aGN7CS66JXkgx+OAfJvS+5aaVfX01IpRn3djrOlJ9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:03 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:03 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 1/6] nfp: flower: add get_flow_act_ct() for ct action
Date:   Tue, 14 Mar 2023 08:36:05 +0200
Message-Id: <20230314063610.10544-2-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314063610.10544-1-louis.peens@corigine.com>
References: <20230314063610.10544-1-louis.peens@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA0PR13MB4110:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc90445-8704-425b-ed27-08db245685a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KXXQfTdMT4/9lOfXhIzKD+/R1Qf1phpTIss/ZJ1yTSJvqfqeZ6KbaZB3isshCMr56z0mso50Z9iR4N7S7p6k/TunwPZ/Ji3pgEl5nwC+9N9h4NYg7jhFe3taOuyNZ/gYyX51JOCTnKIntEPudvZdMSzXGQAmOWO+ZHriKFPIrDT1NkME3J03d1xs/t+MMsEwoeDGgVhExtwzvHkvuNJIU7U/kwxvZMsA47f7iF8XqXpmVuvfLAnMR5TPeOnhCjj0MihswEbJie1eIpP2umLbOpvT4JNncP0v7lRRN41QP6cqZDi6WOeSmdPxkN5qAul44lVzxpMvw49ZC1XxYatVrl5o7+6Ut8LOfVBZIcIS0masq3b07ZZ8RnEUaDQXPM1TvOkatUHp2wmF7peJkt928n33tMVUfzWpbOmlOxB8Dm4UO6Vm26sqH7whW1UNRhQnCp3tPuw7JgKw0aRUc34SiT54tpOW2x7r2MUFCJG403RdQIDQQ79od804l7V3yKmVvIBXYRNJcoS0+ItXOe/FdF4f4IFYKSL++ORX/9u5Kb3gKwz0v22Qkd6yraVlFNh2gbArdNKPhe7XCd+zmNMj0sIyp3NsGtXASgaQyhRKTAlxfRztyWEPQj4WEgmpHoweQhM0Lfk1DNTxVXUvWTyyZN78j9L0CozNTmzwLJ+pO6tRKfpRP4lXk3m/7BulBOrwbuSNUlk0GA3X2ZHf6jZ2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(4326008)(83380400001)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h0K4GkTsMZFcHwR+PJ0hKgI6DWqNPMVgGACrMyxe+3j0BoTorE8SXdfnIk0L?=
 =?us-ascii?Q?FTdrDsHUcREsacPxGJ6wBC7vfG33VicUuZfXlY/veamekmIeBD1+2ctnL4qi?=
 =?us-ascii?Q?qme2wbAbCl1NHtSqmKW0mLxB2d0DG2GzkH4TIiI0f5diMSEoDK1c+8VNLZqn?=
 =?us-ascii?Q?SOSCUHGzDNm6CVkaJD1ze1EtIeh7XHYslj04hsEqiSCnAXxWgDuFrR0+V04q?=
 =?us-ascii?Q?PH1MnIXxARTMYeuzLB7dXqUxnzthh6PA0OlhQe8PP5ZVrJvpTjFbRw3x5jXw?=
 =?us-ascii?Q?N3176Dvai7UkCaJVRCdrAbW3gB7UKGZOip0P9g8iyaGxh4pxHeDa7OhvYffo?=
 =?us-ascii?Q?+TQAadH7tAYS2HVR9DNH90N1yTyGwrOVyYFjNkOHRZvEHJO4XoJVxgGVcN71?=
 =?us-ascii?Q?GCLPeA/rTDyaMf67zUizC3kB9sowUpceqeECBdADUJqlwQ0C/+jHcrF5rlh2?=
 =?us-ascii?Q?b36k3ZY0t5yQlouulUN8egKJcrEiwXypHEZLEgtClon6hs3BYySvooLRg6nj?=
 =?us-ascii?Q?6+a6fzW/QBxLRBucVqWSC3xKPJWHgKB9in1pWL74eSAhvAJy02XWz/mPRo4Z?=
 =?us-ascii?Q?CfUHjZwQRyyjumGAz9JBBReYZXExflKmJdOkHSsQODOB4z9Z1bNiu+cN/xub?=
 =?us-ascii?Q?aTC0lysOG9ASc+lFsGx1Y77Y27eP1iVZgynJNKZqDRnhOsnIHmugooEy16ri?=
 =?us-ascii?Q?kI87QYMa1aIngIfSSo3rjQJr4FN2SQiTib2IwdX696jz+OiRVS7WQBC9FHzR?=
 =?us-ascii?Q?NL/rfjgXHWxeoQQsXvXeIximZRDADqLtZFPziwjumuNgDCw0Gh9hRwWWBjy5?=
 =?us-ascii?Q?VF/9gPhIXuJYjdLrT5rEgWA8Owwk2sM7lP9v1bxrh7OpaLSXwFFi+rQ+bPHN?=
 =?us-ascii?Q?hb9jBsKKYcNt3OAtf1JeurRjFCbRxr+hwP1PsTCubQE4o+Z4LAa4JXiSfRUv?=
 =?us-ascii?Q?shktR3tR009Od/exr2qFpYIclkkO/svzvqxXJ0/RxYlhIGgmlHOLoJD99/3/?=
 =?us-ascii?Q?VNP/y9A5OjY5aUb9L5AfGK53XyEcX4bYn8/zcAuyH9DZxwFTyriiaquoKaMr?=
 =?us-ascii?Q?pIE8k2V5X81Z2BSV/78vnI8E2e1y727hIIsr8qfWco5ZJW6oMcRLcm6EJ0UW?=
 =?us-ascii?Q?0wH+nzzOQ/BorH991A6HrYLWvZambxQSeTIQIV45envjZfN1TVhfugSqsuIK?=
 =?us-ascii?Q?hjKp/tUOKusgxQNMurm3we6NRso1/pFEBYQPyZUbJzgu13V8h3Ud9iFCLpyS?=
 =?us-ascii?Q?cjmagBwk8lJUiZOjawSbRF/hXleGZCaYVoZyFVysf2DbzJ+itXlDwG3El4KA?=
 =?us-ascii?Q?L03i+7bVlePQLjVS7P8RByVM7/AB90hny/1RiDmv9RPhdFP2tKsfTA7cAvgR?=
 =?us-ascii?Q?OxvkbbKxmfUHXvE90OD/l42DTIbxn4jtybsWed1pDVqb5Vd5YyYFS+4FC1zk?=
 =?us-ascii?Q?s8PK5VoQ7UeItLk7+jdQwHA22TsBDtK2UdBuMecufJcf9ihdxVHelEkq+Kgt?=
 =?us-ascii?Q?hJW3AFDqEyuB2c0j57daJb7h2bNGyX43q/gKrAVrfjBrR6WrIyA6BP3ScRP0?=
 =?us-ascii?Q?jiOSQZa+cj1LSgSsDsvqQD12W7G7HMj/Iqp8kmOzcP07kk0l0pDcYYQwuNVM?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc90445-8704-425b-ed27-08db245685a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:03.2378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgbqeJdVjgwZKH9+MYIgumgBFzvg6vODAkcxRfxB1gY9RpCivl8OQlOr9HUwbPwnIVIM/rDkw4mJgbU8v0VE700pvXX0Z5+MBDmo+8D+zyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4110
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao Jia <wentao.jia@corigine.com>

CT action is a special case different from other actions, CT clear action
is not required when get ct action, but this case is not considered.
If CT clear action in the flow rule, skip the CT clear action when get ct
action, return the first ct action that is not a CT clear action

Signed-off-by: Wentao Jia <wentao.jia@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c  | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index d23830b5bcb8..a54d374788e1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1656,6 +1656,22 @@ void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry)
 	kfree(entry);
 }
 
+static struct flow_action_entry *get_flow_act_ct(struct flow_rule *rule)
+{
+	struct flow_action_entry *act;
+	int i;
+
+	/* More than one ct action may be present in a flow rule,
+	 * Return the first one that is not a CT clear action
+	 */
+	flow_action_for_each(i, act, &rule->action) {
+		if (act->id == FLOW_ACTION_CT && act->ct.action != TCA_CT_ACT_CLEAR)
+			return act;
+	}
+
+	return NULL;
+}
+
 static struct flow_action_entry *get_flow_act(struct flow_rule *rule,
 					      enum flow_action_id act_id)
 {
@@ -1720,7 +1736,7 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	struct nfp_fl_ct_zone_entry *zt;
 	int err;
 
-	ct_act = get_flow_act(flow->rule, FLOW_ACTION_CT);
+	ct_act = get_flow_act_ct(flow->rule);
 	if (!ct_act) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "unsupported offload: Conntrack action empty in conntrack offload");
-- 
2.34.1

