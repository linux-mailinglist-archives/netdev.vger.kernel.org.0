Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5B86B8B4D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCNGhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCNGhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F9A968F3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzyYVUG/deSvpZS3YNIcxOIauJ9rDxsRaIBXmYAkJd2FaqgRbIT2MNZWAaVvxox77L4+XB494/Rz2fdxgUDGIzJDv6KfNbpw6j7ql6XupAH+ccpKWhRnZzG9y8yTu7Fhx88KeQFJn/3IRbOBsCcv7H8nEnpRu3JMKqMyKuelpp6gw3EXkhgrY1UQZ+W+bnbjtnEkKHisVKChA0CoG8YovjeDtWsYl2NdeiOb3ROuV75wSrNPVPynsn709S8298wFxvpDpCU9iRrmeOAvyCyADD7iNVRDT57/St/4xjYqwiidJYZIn6JPrLUafvO8ZuPFLWPI7Uj8nZhZ1l1XkquoaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9D7uUliMZ5cQBgeOWiLR2WipqWnpiSpRh5nWTCTiRU=;
 b=Rux4aDDB/q0UJkhIYR798+kHKoLnYF44I+UMrlEAy8Qjlkc6nNZ+rL0MCWhyTyz3LI6GHngfIvav2LNB6xeAL2GAaHh1WewgNdZQn/bPOsBLtAzctD4fVc7MmyClrmTE3s2VgBm2O0npPjTyuX44Jqel7fLLRIjyjso9a4rAV4lSe0xpn02uJvAjtngM4Z5/qKe8/Hvw71820tyedCIFCTxqzBu0cuH/sbLUD/sfJnsrdcIhDTRTJ+PAtXIeaS/PXT4JPQQM7/PBHOWPZHe7uE+Wg5jacH6+0KeIG6bwsYmTbyBEPnZmvgQn1DPHp0MVxxgPPe6UHKTgmEYezRqAvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9D7uUliMZ5cQBgeOWiLR2WipqWnpiSpRh5nWTCTiRU=;
 b=P/d6OYlkXhIXMV/LqMfJrAur8JqZpSQkAdr6ggZzZ7EKBffhsloeqZl6HfDZhxWN+NDe7ndW+xDhlZTtK83uyJfXSLSfrIkdlETwARXvgm0sNPGzecUhOVavvPVym3zfQMLMTLqyfaJb7l6iav/tsVM+DhQELG3/4ZSG6A0PwHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:12 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:12 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 4/6] nfp: flower: add goto_chain_index for ct entry
Date:   Tue, 14 Mar 2023 08:36:08 +0200
Message-Id: <20230314063610.10544-5-louis.peens@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 52b3a057-d964-4c39-361e-08db24568adb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGZv76HSn/f46MXyBSj4WSKlAhPXF9XNsO2LbaIJo2jKXjOxzq1el29vxjNS1xJtBjeiHp4dMlT2QPYCSfzWfGpty5b7ygn4oK/gjJ4lF8Byaq2Xyhy1w8N6viycS4bfrEK9kRD0WVRtjeLEeXS8LRs6eszk0s2BP7AqVrUEd+n/bEqAWk5kyLCIdcuK5d/JH0rJazCVJ1HtP0tTOrw0FS/4v1UltKBPYIbS47IiY5a2fTRt+Gc+Om30LuQ7+OlA1+yuFr+9TYCLCLhSKs6pF6TXoqCKdWUF0/koDiIYTMLUB9cJnshGGK6Yo/BZzIZcHRsf/EdAwAf9GeJ7YmLmH+CLF5mu6v8whsFG+3Ww1r63Zv/T8Btoat6BP2rxqU/x2CyagyIGAUUp0Ix+cmYVKF0OL7MxKG9WSENk29xH+DiJshmBDYNbCQnXvpyTBu04UBtXQaVIGfjkMZ+7lQA5Ol17EEUcenUO0Gxcpk7p1v5kDoZUp91uDwG23bPoY2NGInaJ85Pvt3SQLDo9GbBBodMV/AAEwglzJSZpQsiSwPApp390AytiroTqj4wq0asadKYtBcCM+SztTWDbMoyETQmky5exzV00Yx0HAaCSIfYrCf2ZET/fSFmEJcct2SxRVRxQDIbkO46O8vdlYZ69wL6PCw0MTAzP5l5ky2NC74TZ2Di5QKPJq5etsULWLntGtCh6oVPtC0aJHs9wP+jqpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(6666004)(4326008)(83380400001)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nIhZfo8bIK4ReJUzxCshuXmmCsdYAnbU6g3D306SYXrdBIB0FUext5Abl70X?=
 =?us-ascii?Q?hYSKNICqHmU2UJqk6mqTTx0blybdXsj/JoJmJd1seKXX+PmUnFmCfhO1KiTc?=
 =?us-ascii?Q?xVwhNvQdXLpMxNLLXtiVjyytRGJLCU8bkCSr65FY2NDfSODQlVJ/OvvJQ742?=
 =?us-ascii?Q?aRGJ4dSb8gmqjuUUSqSREro/u4v1+XNoPn7FEH3S0PmoAam9mM1oVTbuU9Mc?=
 =?us-ascii?Q?/0/RiSk+01nS2e1GHKlL8b5x6u6uSpEaF/w3BwbAsk3jeRqoEHLdpW85gBFb?=
 =?us-ascii?Q?Mis7LCq8xiz6QG+NvzJlM4Eg/Mc0IHR3XEc+Gl5o4g/t5z613w4zOrUyrYsl?=
 =?us-ascii?Q?226AS30MDdpBeefF3V4YTkBGnSmLCRgsbysr80SFx7HNd/SsNxu02ehf/AuO?=
 =?us-ascii?Q?jvXCql9jpBV/DX9t5Q6gubDsrLJQYftlAunAIueipfyLFKtRHC/sOjj41gW2?=
 =?us-ascii?Q?dzBPppADqzY5KV1kMGgJe9BvCXBDoC4lqkwEdvgehRCWUiLDv/J92qEvxiKx?=
 =?us-ascii?Q?tAFB0n1vVCx4icXVVJXQzcBgFyftTy4Bd57GVn0jzE89OTGU5nB2iuOyXKWw?=
 =?us-ascii?Q?3usl9MCuyPIGr33/r1P+NWAqwOLi8u9DEkAGROwTrd7zSLGmWIf7a2biXu0C?=
 =?us-ascii?Q?Hp3utvP3yg4bIB9eY4psFF/O/awFkd2CiWLRCGdB17YEv10ll1aCqjXJ+4zh?=
 =?us-ascii?Q?wO9UNGVjPgsJrBvnHNfE4YGKXTo49i+oxRru1eEZoeeki0XcZSrNm2clUS4b?=
 =?us-ascii?Q?5z5gb2RLi96j8lANBk8r+jTVzpHz7fmOnrYPKMAyCNqLmqMslbRMNjwgnX6U?=
 =?us-ascii?Q?RyMezt9OKbo+1E0az9sf9oak/7+3u+3DoDhS1ZSBZFCJM1ZlpbKolsnU3vUq?=
 =?us-ascii?Q?ICEbZh9rtICoiGQpXYfdWKs3OgY5xEBnR0tZc3OXNBtVY0GyTvat2huGM0G8?=
 =?us-ascii?Q?cyH/SLi9oXJsdN8eHypUPW/U6Rw0ce42ZSu9pZgx17G/HYT4oB67dkvxhtQ4?=
 =?us-ascii?Q?L4EgDYzQMfXsVRGcpPTMsPyyB/Tqhn3ruruRTO3+sG7kgsxN/iF3Tu1hzjyp?=
 =?us-ascii?Q?3U91VJX7EptBNIVnzaeVZcq3/YyGHSRncYsCedL8Xd8g9YXbWrF1OiNqc+n5?=
 =?us-ascii?Q?S8kwLZwuVmrt+QizhlfF8NFlB40BvM1CmFnitQNRPXDmyVW6QnMk8+OS1xzN?=
 =?us-ascii?Q?biHy60a3vCSkzeTu9tzT4X424rpiDbI8zAJWwnLRWNyvrwoduTjzqv818waI?=
 =?us-ascii?Q?OxgZSp7k6SMCGkwNJWv6X3EPAX4uCmf6xqwPS99HXJRn5/GNQSTrszZ7ABLP?=
 =?us-ascii?Q?GDwCreejGlzxSlY35WmZxANMDW5S5HBi5HDKP+a68RgxECnnIjPG/uQfu9NA?=
 =?us-ascii?Q?jHE6eMSYddOYzodbWv7Dt7C/fZ1NO0b9pqrfW/kGp4o2l+e4kS5SD8MSd3Ba?=
 =?us-ascii?Q?oGYZCLoeK0BBdThj2HAaa4iLiEj/INIxB5gWBBYOyG1isWUmh4XSTgLS+rak?=
 =?us-ascii?Q?idOWPk90x+EkB1F63cbQooaYdtRxM+tTaSkh8AIe/XHHrUdtnRa/j9bBBBqx?=
 =?us-ascii?Q?RQVXT+licHPMpmbj9M6mXM5df+BPVO/NxX/+ssK7j7/jsWMvy2vvGhOwma8T?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b3a057-d964-4c39-361e-08db24568adb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:11.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PwzzowPaX0ppzMJhlnVDTyiyYtv/46pySwz3WMaOsxGV7MCGPQ1bi65rKg2gW6E/seGGYi03u2BEHkt0LcG50mCIc9nuzx9gMZYqNrWZiA=
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

The chain_index has different means in pre ct entry and post ct entry.
In pre ct entry, it means chain index, but in post ct entry, it means
goto chain index, it is confused.

chain_index and goto_chain_index may be present in one flow rule, It
cannot be distinguished by one field chain_index, both chain_index
and goto_chain_index are required in the follow-up patch to support
multiple ct zones

Another field goto_chain_index is added to record the goto chain index.
If no goto action in post ct entry, goto_chain_index is 0.

Signed-off-by: Wentao Jia <wentao.jia@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/conntrack.c | 8 ++++++--
 drivers/net/ethernet/netronome/nfp/flower/conntrack.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 6b90b922bac0..86ea8cbc67a2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1254,7 +1254,7 @@ static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
 	/* Checks that the chain_index of the filter matches the
 	 * chain_index of the GOTO action.
 	 */
-	if (post_ct_entry->chain_index != pre_ct_entry->chain_index)
+	if (post_ct_entry->chain_index != pre_ct_entry->goto_chain_index)
 		return -EINVAL;
 
 	err = nfp_ct_merge_check(pre_ct_entry, post_ct_entry);
@@ -1783,7 +1783,8 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 	ct_entry->type = CT_TYPE_PRE_CT;
-	ct_entry->chain_index = ct_goto->chain_index;
+	ct_entry->chain_index = flow->common.chain_index;
+	ct_entry->goto_chain_index = ct_goto->chain_index;
 	list_add(&ct_entry->list_node, &zt->pre_ct_list);
 	zt->pre_ct_count++;
 
@@ -1806,6 +1807,7 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	struct nfp_fl_ct_zone_entry *zt;
 	bool wildcarded = false;
 	struct flow_match_ct ct;
+	struct flow_action_entry *ct_goto;
 
 	flow_rule_match_ct(rule, &ct);
 	if (!ct.mask->ct_zone) {
@@ -1830,6 +1832,8 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 
 	ct_entry->type = CT_TYPE_POST_CT;
 	ct_entry->chain_index = flow->common.chain_index;
+	ct_goto = get_flow_act(flow->rule, FLOW_ACTION_GOTO);
+	ct_entry->goto_chain_index = ct_goto ? ct_goto->chain_index : 0;
 	list_add(&ct_entry->list_node, &zt->post_ct_list);
 	zt->post_ct_count++;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 762c0b36e269..9440ab776ece 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -112,6 +112,7 @@ enum nfp_nfp_layer_name {
  * @cookie:	Flow cookie, same as original TC flow, used as key
  * @list_node:	Used by the list
  * @chain_index:	Chain index of the original flow
+ * @goto_chain_index:	goto chain index of the flow
  * @netdev:	netdev structure.
  * @type:	Type of pre-entry from enum ct_entry_type
  * @zt:		Reference to the zone table this belongs to
@@ -125,6 +126,7 @@ struct nfp_fl_ct_flow_entry {
 	unsigned long cookie;
 	struct list_head list_node;
 	u32 chain_index;
+	u32 goto_chain_index;
 	enum ct_entry_type type;
 	struct net_device *netdev;
 	struct nfp_fl_ct_zone_entry *zt;
-- 
2.34.1

