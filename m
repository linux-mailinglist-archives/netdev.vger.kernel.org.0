Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6861E68FB95
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjBHXu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBHXuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:50:25 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18E99EFC;
        Wed,  8 Feb 2023 15:50:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OY9O0ePJW+VEzjcpklPBAFVLu2NuuY7LkupIt5CqTq7aw11asbgC1OFY2KzN2+fGpJCcw/M231iM9vP7OCPOO2eUl3WK2AqnbGukPMQ1mkkF5gym5kKWoLMgs/A3kiUnUrUoD0Nkl944AHcE9bS2x0vWqdTDhDK6UgqtS6H/fDKLdn3edwry2dZoV3tjiPfwdfBUdCdgV9tmE3HuI/x8tA1hkPj0oQoAyGkVbW6GrHJ/LjkHeGlWQ9EegNHE4/ZID/+JerBMGY+AUO5ARohf8WqE/5y9eulAYQNyp652Zgp1H59zyOtA8M4DQLobJpWpOUGHHb9jQ2zr5VDvfVQ1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTrlrNsgGBjmPWCO7OTllFbUZVUt298srufnD1ny7BA=;
 b=TOIzkKK455wQkk5tDTsCL11u1niCN3RHnr3ZGbX6mmETNu5xInIthUQ2bLjexb93C6qQB3yjNQpCxYz7c1ibqzFHh3bV9cENmib9weRjrEFJn3qu1E1EZXzT5uegb21Ccp8yHfIKvHE9N1H2AAQGMZvF2nN86hejKDAAUSIo1nnse5U2dWx2KhthYvWYOZX39XqvnNgO0W/6nj5pNfSLkrbNmJlRiC1hOyPjjFaSG9907nny4TofWWQ2GPbZbh+Jesv2/ZPyNMOIUsLiacqosJvSqJsnhPKsVIqI72x6ndGLNL7ik1NmsPy7VoytOavQVK7IbPwc429mKQZ7quRakA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTrlrNsgGBjmPWCO7OTllFbUZVUt298srufnD1ny7BA=;
 b=ar9Pg0URetBLOGKCmgPVfo8z4BmMJDba4NLp2wD0Bv6C0UldBT3aJT7UzCUs0cULxpY/lMoa/FuicBpc1xuel15I8cBWcZbohV8mIwkn7YOGdfVzw7I3j44KeoyxLmOxrlNs5RAKidGv/PZZacIBmGLVaUfBsyYACixofQXC3O4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by CH2PR21MB1384.namprd21.prod.outlook.com (2603:10b6:610:8c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.3; Wed, 8 Feb
 2023 23:50:15 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::73b8:4677:8c77:5da0]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::73b8:4677:8c77:5da0%6]) with mapi id 15.20.6111.003; Wed, 8 Feb 2023
 23:50:15 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT completion message
Date:   Wed,  8 Feb 2023 15:50:04 -0800
Message-Id: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:303:8e::14) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|CH2PR21MB1384:EE_
X-MS-Office365-Filtering-Correlation-Id: ed4056c9-6a57-4873-8409-08db0a2f3984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XxS3ynZ4Mpet2EGmbAoT4QLwKh64OP9R+HawTC0E/52DSVPvP93XB0wMYo82KXUdfYHmZOXT2s7pJIA7t37Qd/RSrpF9MrWH7H6pvdpuTxj0gLPC/JG9dPGrlN+B6xjrSP87C9eh6w+m4fpR2Q7aZs6n72C0uS1ojerVoTPA+cxNqY+IzgjoCjJ3JvzbMk6WuDQ0pj+IvhZ0xBB+25l1yJFP3p8JZxgE3auveGEXxdLi2BFfk/X5rq5NqH91t6kEHE2ZjdBPH2tsgl/j4ZDEGFL5R9mnYG5aYJ6T/a6z9QMZXZRjya09gGneU8uC+Et/n5ROYGgRAPFtGtbOeOpEY14fEb7mCxXDGwihEnu3MnR5Z3YCTwjq48oHi/FzdisbQJeRIs8/LMGW8z8wSV+BWbdV+AzhwHkS9kyPYEAAZl1w0hlAx2y68wi9DOFXf26KUK9DVWIFQnhzpYAeFmNgk0mSeHeHbPoetkh6SAR/teplrpJj73wMOARXVwnCC4/ytaBMkHXr7sfhGNCIeC742iqN11+VAOTyxSZSlQ6jwaFQ75zgSRh2u2Sue/Zj+Bndp0mkEVgM8z0WPgeJlmr91kI8/U04Ro4c06GKKkoWKE6h239nqouKiiX336PSOQ4upBce+Is0SdGsNdjp5hoM9lAecJ1UmLAdE+RqNW61ue20FhKbRThHpTbySzX7FIHZWWdiqD1xkmwluaKKh0w6w1ecE+WyizuIWVvkvFPea+NOH2baFAx4HDzc4RjglrawwUwcJz2jzUU9ouYedhMwJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199018)(36756003)(2616005)(66476007)(107886003)(6506007)(6666004)(82960400001)(83380400001)(6486002)(82950400001)(38100700002)(38350700002)(8936002)(52116002)(478600001)(186003)(86362001)(26005)(41300700001)(2906002)(15650500001)(6512007)(5660300002)(316002)(921005)(10290500003)(66556008)(66946007)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z6IbIqyDH357AMGhXQy4S+lJZdqjMmiVuk+8IkgzpTQT+c01syjwVZXtaztf?=
 =?us-ascii?Q?KMpyz+Ht9U/X7cD0RMkqZIKL2aeYrNrmAjR+m0ps8GmOnuPDLL/sp8WU/Mk/?=
 =?us-ascii?Q?lIAD/sypviT2B0Ur2UUEVKMnEgqulPaWxSFciznuDm2IQWjFVVcCFM5IcrJ6?=
 =?us-ascii?Q?whmyWUUGlxvUFUjT5UGSb3PF4UKlYalgafAKyOCcfGAYPkT0eWP8jbg3bsg5?=
 =?us-ascii?Q?Apv1iklDQ+mdyGLpsiG7YcUMgVN6DC6l6SlHiK7grLvUIV5DiAcKVxQ/oGrp?=
 =?us-ascii?Q?R2LttpsQij2D8qlNoGDZijUNxJT8YTa3MLmKuiWXjuOGY7PTBojNUBMnvwZH?=
 =?us-ascii?Q?sTQOQiwAsJG55sPVhUjDloRjgRnbTSDGLE6icmNB7R4WaKjYA1bc9neuQu0Z?=
 =?us-ascii?Q?VRbhh+RJpwtOGC0qY8ZSV3RPbOfPtGabfrRfQp9/BEYSXakJQS/xlI1oDCUb?=
 =?us-ascii?Q?V7EV85Pzuk28BBv0wdjtfsVUKjL+VjQp8O4ZqGlxF3X1+pHT73LtfWNHok/P?=
 =?us-ascii?Q?2sfolGbV2hSOKIpQ9VoSUw1UvUCnm2z0d7RB68aQgbe7+OLeD8H/HQbzrije?=
 =?us-ascii?Q?8aKDo5zh6MEMfEnc2c98QLi596f4iLdrg90Ram73Inhd1XTkw9ve1StOTZ8x?=
 =?us-ascii?Q?oxHnHCaClyO4Qfof/VrjPqgpkAuUbdkEVEFX68nTH9lMxebjFv8pnvf6ge0X?=
 =?us-ascii?Q?d8qkFGIUuTn7YGaNX4abgVG4JNmv5OXUKiEvxhhRedv3UzfPq+CDgruPZY8n?=
 =?us-ascii?Q?VlFCrpW9/Q8zkjBAJP8mYwFXg/4Zhpk9izp7mEXknD35Da68cPrTtasodq9a?=
 =?us-ascii?Q?nUc3WbwJGWiIfwMcikWal72Ir86S7Dnoo5lgZktwx8FXAJwSgk03em12r/nx?=
 =?us-ascii?Q?9THOQMMxpVfDPyLVwcIZOpL221O7LuupTVZ8J61K5nsyPNdTv1FI6EByZsum?=
 =?us-ascii?Q?NyirCDacDVXMli2+9Xh+lRipNXJTU1ptoYst4TkEgfrBy+Mr55eLK9+SxSDM?=
 =?us-ascii?Q?7o4DaRchxF6aMLNMGHO1966b1rDISWPSxMEz6H1zFTZTKRN2veQpVUONvsz+?=
 =?us-ascii?Q?mS8Z1oTydDPfIIY6eS6kgIPQQPqXZzA9t+7ld/fCKG6hwk81EVgB0lbajY7L?=
 =?us-ascii?Q?ARIM6amVhUUJ+gA6YTcA8NrEa+Kua+E8CWfaAk05+rWWnM68eh8IfUDoTkzk?=
 =?us-ascii?Q?On5c1ORrgRjieTBEqD6zSK1f0xqgKeYR+WwFXJzXWpXeCzlaDje/am0VY49G?=
 =?us-ascii?Q?5Z8THtvs62GquD/opICRk3wHjFMO6epp2Edzh+Ied1raQQxk6rFh6EqU0N0e?=
 =?us-ascii?Q?nvl7Wzt6IPtowG7bQy8xy1jaDisH3egen/Y18RSGSEG4YfMqCksyG8N8B/wG?=
 =?us-ascii?Q?Ubixh0RovUHfvRL4pWIvnDdkOiFi7rMCoEaVPKmxIt+ijY8D6endQgZ3QB6Z?=
 =?us-ascii?Q?7hqhOr9D6+i9m7ydYeF+wxqqBEU43LH43mcum2fEp0MpDK68XWEGeoYvAMYo?=
 =?us-ascii?Q?304IJTZvbtumg0fssfho/mFYCSVSxqPniCyzkOR0lSFxpbD6sR7eLx8LehXw?=
 =?us-ascii?Q?WxDWdsSNQNrwijvoCQ3P6vWbJE6Yd++Z5MXWumh93T8Xyi5aFcMYrnF188k0?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed4056c9-6a57-4873-8409-08db0a2f3984
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:50:14.9502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJB5I8YYx0Qz4k9JibSYN0kEjdSZZaR+/egNDU6z9wGyznhg2K5jTgr5OLk+SepUpAsAPWBrKkre/MpeLhZR4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1384
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completion responses to SEND_RNDIS_PKT messages are currently processed
regardless of the status in the response, so that resources associated
with the request are freed.  While this is appropriate, code bugs that
cause sending a malformed message, or errors on the Hyper-V host, go
undetected. Fix this by checking the status and outputting a message
if there is an error.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 661bbe6..caf22e9 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -813,6 +813,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 	u32 msglen = hv_pkt_datalen(desc);
 	struct nvsp_message *pkt_rqst;
 	u64 cmd_rqst;
+	u32 status;
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
@@ -884,6 +885,22 @@ static void netvsc_send_completion(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+		    sizeof(struct nvsp_1_message_send_rndis_packet_complete)) {
+			netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
+				   msglen);
+			return;
+		}
+
+		/* If status indicates an error, output a message so we know
+		 * there's a problem. But process the completion anyway so the
+		 * resources are released.
+		 */
+		status = nvsp_packet->msg.v1_msg.send_rndis_pkt_complete.status;
+		if (status != NVSP_STAT_SUCCESS)
+			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
+				   status);
+
 		netvsc_send_tx_complete(ndev, net_device, incoming_channel,
 					desc, budget);
 		break;
-- 
1.8.3.1

