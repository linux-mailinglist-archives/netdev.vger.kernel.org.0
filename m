Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7796E009F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjDLVRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjDLVRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:17:30 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0690F7DB0;
        Wed, 12 Apr 2023 14:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GT7XlNA0h086uS1mGe3A17HvFoPE8RU9kVzf9nlyE8Wag24KJPzJj3FJ7YeaVkUETHXSU+UvWHItzy19exl2fKA7N2jmh9Zs4T8L+ibddJh60yquJX52uLg0shAC+nSt3neYmr47SpM0yabLGsFnHFPe7cpdVx+kedS+Vgj2E/LYL8ACp11LcECxRhzqfvRQeKKbOeN6yWDAZJLqvrU0acj8HWe5sZw5kGwbkTZfRIsfwN/wga/xiWgEA7BO+eNU1YRZDfvztHM/nPUvGH2kMZkd8mqBLwdsrJPWeqfOHtWU4ebExZK164qkIdRu0Dz/g8hYE6Ddvkk+uOiNrNwZhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkZb2endiUvSQiBBqICOnNXOTE5v7ywntoF1PbwKMQY=;
 b=cS0sXV+vuABeGXCQUQvne7Lj11/BixAtHyDBvOo/e/fVTJ6bPoRG52cO0AmADLOLc/xaTgl9rjbxs22G8/8QkQse7g7AZLDcD+Vr7yqPfDDSKER7FURtCcsBOqZT7rBks4PU8ZKnzIRPCtLqhfiRDlkTKv/gpVgfby2dYcxmKf1UmhBMJDZpIcBOcbSdXrEgqXQ48zQGXeyeiwBQQHEWm0PS26sDiLRzc8NBxgDITsxHWp2Tnpd2s6NIjIq+yDKt4C41GEJdFbXytt38NtAMWz7dUhxzy2IiQE3uuIXyC+tP4+D/2OvvfOqBbcmi7kpzp7foE7+BrQjd45XrXZxSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkZb2endiUvSQiBBqICOnNXOTE5v7ywntoF1PbwKMQY=;
 b=H+E47Cvnv0LcagTwQYb9oLvA/8t8FocKYpigjyeGv1PCiC7sRRBXFg2GdyC+1z3VfitXx5LXhe6HLb30golsCKTndNwVA6ZGHGFK+lwMeYh+PGasgWUexGu+NEl+741h4b8N+Wver02ZQa/bQw/m11/NytjUb1LsitOmDJo96wE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by SA0PR21MB1881.namprd21.prod.outlook.com (2603:10b6:806:e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 21:17:21 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 21:17:21 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 1/4] net: mana: Use napi_build_skb in RX path
Date:   Wed, 12 Apr 2023 14:16:00 -0700
Message-Id: <1681334163-31084-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15)
 To BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|SA0PR21MB1881:EE_
X-MS-Office365-Filtering-Correlation-Id: 11e944ab-c066-4e04-730f-08db3b9b4ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3Mg1U9nHBv+c2uYpWgIzvF9SCZcVLNSbMdO39xPVWfVpiNYis+QTlXYA5B4oyypAs2JglYTHwfrkliNKjmH0RUvj5PjbeqCb2vkA5LFwz81cMXH2PfoJVaGcFOpF5wrBBmMQ9E/PCZAsf6hIKvmXjZ4IOqzor9Z+kvgJuI/+K4DbYO99qC7EGSgyyP7A/4X87v7fdQ7z9TYwNPNenxfGCP7C0DI3kp+ToFEabOZSd2W8kuX9gA1p3R6S3omHW1/xK2dHhZ2RsyOiDAmlb79M5IXlkDHOx+UToaV3UHBmT8GdE5PEJcwCZz+HvHBNpPRRXQFYPWnZwIOzAS//Yny4Nq/wXqKiVkH5+/8UfhF70ONj9gt6HZ0LUvTFIu8f6w3JzFSPpTvXsFq9YxHfa9l1B+o3Go+p3bGhPO3dVDYXMe83Lht5pmn/siMlLiMBqiXu8Kig3LC+INw59fmEbnfAn8UvUH1FON4L7wAx/7/ay+4a1m8z9OlOBabngqpe/3g9DqVw4zD2gkGp7853slnEB1TAlpe17R2CLMCfqEMWHpMA0BTIZABidXzAm2q2FcuCxF10m4Pi8lE0rrezYxveNJUKoSUZUqZPJN1qrraoRrHvpKOfIijmA3gCJq398bCVpfAHUnFgt6kPgxIc6Ri206KVvUbDJpe7TiZtuOGmSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(8676002)(38350700002)(38100700002)(2616005)(83380400001)(7846003)(186003)(478600001)(52116002)(10290500003)(6486002)(6666004)(316002)(26005)(6506007)(6512007)(2906002)(4744005)(5660300002)(7416002)(36756003)(4326008)(82950400001)(66476007)(66946007)(82960400001)(41300700001)(66556008)(786003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Amnx66QsrZLAMDaKbpV3yfbDO68hoJUU0gLRrqjYH5bZPnrJc5nVIEidIObM?=
 =?us-ascii?Q?09GbSpUyoaAxgcxavV+sGHW0XGhJ1fiOUi5nh91QOJNb4976SSqfz5iICNci?=
 =?us-ascii?Q?djOlTlfdPRMUgkQOLJWhDgdnDpBLVVSvbhPKPRg6iVUdA2oAbGJuoQgt35Fn?=
 =?us-ascii?Q?mmddvTDdv0w8+hPQwIHJ6mXoaJ3N+LZqOt37OclJeQsTYTvgnKVqJKmWxtzJ?=
 =?us-ascii?Q?ad3zWsATdfWZVeRBIWBeLmLSxLScwtVvH8wO77Hrxd8eTTSNbYoy9fyyd95z?=
 =?us-ascii?Q?gQ576Ii1VhCBe2usdc9ejhLQiDzEqr8J9l/Q1b0NRHJsJNYfT9eYEOq7My6q?=
 =?us-ascii?Q?Ot5QOYDvr+w32GWG9XkaoknZPclHoV/5R27h1CvtcCLp1idTdwFPOjZsTab3?=
 =?us-ascii?Q?6Z76ffiwfDDDyfOeNoyTv8zttpQqBYUtWgHgKAj6nQ05U/E/7faQm0s7vlIE?=
 =?us-ascii?Q?uaW5gvixqKlKJRstzf8QaSfOv5VofB5ZS7iRJ+OgonVW/GOSNRYWqhTup/pg?=
 =?us-ascii?Q?Oqcc0p9Cu7ukIw+ziqsKP1VzLkMdPLMpKf/JbU9mCil/yqVtVbEM5K/xotN5?=
 =?us-ascii?Q?HzGFyaHuLGJPZTSIUtFwS+a5N9nIicEGHFFnGwHqichTfz0uZsPtixnsuXru?=
 =?us-ascii?Q?QlX2GmXDJk8A7MBBaTJQF0fegCKJbDIAt3SpLRSuRt/I3JEAlnI70GdApYpR?=
 =?us-ascii?Q?qIsPnvN+P8/8Iw7UX6xUApOUphl/+to7OyIazf5vfk6Pd6AG2rODHZHyPmyg?=
 =?us-ascii?Q?3UlySgJc3pesaNd25GGaD2KqqwImEm/24ej7GENIRv38cKgIoRwxMdgPlBre?=
 =?us-ascii?Q?WxYOVGY/16MYV//RJh6SYDK6mEAw9eUd6/REPviHXD30aFmOlPQJpsEAC0D2?=
 =?us-ascii?Q?Gt2j8fbimRduOJI8uOpRXBDU1zeVwt+lQ5TBMods4QSd/zPM+fGbmMmdzZQD?=
 =?us-ascii?Q?Qzv0zdJEQJwQJtVua8GjNdtacToSCd2oXyTav0RBEQlk8uSrImh7BBC/hw3e?=
 =?us-ascii?Q?QlrHb1pxI/ZXOExAGtGtC6aYpHBdrKuIqseUKNB48AbfTdz1GM8H/3EK4A1s?=
 =?us-ascii?Q?LxYUAiB717m5Y2qzKzk1UVtfML5RBMOjlKhrIH0yCNinZI/exZKPnNgJYrtc?=
 =?us-ascii?Q?wAxOUtD4haaYQ9mI1XpK3GfB76BHj6tDj2dAzyvvjKaoOpPr9L/DAbROuo9Y?=
 =?us-ascii?Q?Ef+cGcIXvSdFaJraeXFYX1LxxYS/hhcsC6bNlhsSaJiSc0glE62ZBsCNW5px?=
 =?us-ascii?Q?YQcnS7W0Sa+au8GIALon5Azl6B4Op/Q0sWaPTkt+yUJst/lZ3v6U0ne+VTYo?=
 =?us-ascii?Q?aOCOuuI9ayiuGhwOnZNdJzZjVb/mhSttzhax2j4sPoU9H9KXgBrAs6BY6MN8?=
 =?us-ascii?Q?3ixe4eqvmeYfqXPxkrj59PNnPACrEN4c4QG/jyYN+IGHEybxuo60fWNI0inw?=
 =?us-ascii?Q?JxL13iJbgbEQNILx8+2/1OzH8mMgqnJgk4uQCtRcSOUKf5dC6j5gHbNflncT?=
 =?us-ascii?Q?ilfjUTAv3JiI52CZfP9hb6j6pZbEUBCyBjy4luhqqcN3irU+81k6dRtJk7P/?=
 =?us-ascii?Q?B6dJAE6E33DIaCxfOhlNqltaBsNC5bOx8+XHLdU1?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e944ab-c066-4e04-730f-08db3b9b4ddf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:17:21.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lLNPYfQka3r4EXKrVQmnwnCCeblU2h+kLBGw3BmRuhJTkCCMUB4Ux4FhbmWahwgrcg7szDdFHbdlg8hqLnqVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_build_skb() instead of build_skb() to take advantage of the
NAPI percpu caches to obtain skbuff_head.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 492474b4d8aa..112c642dc89b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1188,7 +1188,7 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
 static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
 				      struct xdp_buff *xdp)
 {
-	struct sk_buff *skb = build_skb(buf_va, PAGE_SIZE);
+	struct sk_buff *skb = napi_build_skb(buf_va, PAGE_SIZE);
 
 	if (!skb)
 		return NULL;
-- 
2.25.1

