Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D84693436
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBKWmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 17:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBKWmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 17:42:00 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020022.outbound.protection.outlook.com [52.101.56.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B5218B11;
        Sat, 11 Feb 2023 14:41:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcsdB4F24vZ1op7dKz51/BBlAd5RtFt9RTD39RD1gPIzJsB94Ppj7+5BMzduuMiBXxg1pSrW0PGQsKjNyGp87SNqvFJRowJzPmZzLBpkoarXOO2hQKlWaKXzouED/VNXi/+R08p/rEsRWf7zpFUm7r/B/YCpJ36DZOeNG9jTc7L2kEEXZ0WPxHEaRlfzU561H+Vd49r32FqdtKpg3Y6a4H4rUt6Yhw9FpYP8FPQ6e4TDtiYdjNlU/7iEQ8iMOpg2wNiWecCNDGyIKhsDi4g0UK77WRjucHtPdOftDEDkt/L44MVyu68rkejYn1fGd5H43Osp3m+oEO4EcdL3PNHzVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDoh5nkXBsHBtlkzIoElmfwQMzyvXqJr3kEqvt3E8WA=;
 b=RP7BSqzIwNdzkqe/Rsj3/5nGBpjnm/hoxy4Qx7ihiPdZrZA69s5jNZ6XO5h3E3PivT5wRjSxVSy1ZHAv43OE7/PfRIb4ZNLD4qjYPjw+UVPrgsRTY2YGo9eBc0asrXoBb0FZn7nDSTTgKdULT2RrBtfnFrge+AU7ce0wI/UToukTuOcGivfM53jUPyuSIe0H1rNtaIpUiocueHn8jwTsnKEFIJJDusg8M/bW7Xsjo7shuC15qKnLZ3QKXVWcfj6IJ9IG3qPYuXVzsf/J1+QWOAsOfFY1x9knXfP+4B233Sga528h/T5pFOh0hA+s3sThMD+Lp3F7fM+6g+Mt3mzrKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDoh5nkXBsHBtlkzIoElmfwQMzyvXqJr3kEqvt3E8WA=;
 b=eoJEty2DIhj6hripfL98tdceH+hnigkwBGEz7npvMThQdV8UXfoyI5etaw1mfegzAx+rHGwKSjgGr4XcndyKnXSRvQwIICeecrN8Mj83WLd9JaYiQb4OnCcHHzfNb5H8shWMhBB8Cdx5sQO+9QvjaK0JciqvFLOaBgG6mq4dShI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by SA3PR21MB3960.namprd21.prod.outlook.com (2603:10b6:806:2fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.0; Sat, 11 Feb
 2023 22:41:56 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::73b8:4677:8c77:5da0]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::73b8:4677:8c77:5da0%6]) with mapi id 15.20.6111.003; Sat, 11 Feb 2023
 22:41:50 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH net-next v2 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT completion message
Date:   Sat, 11 Feb 2023 14:41:16 -0800
Message-Id: <1676155276-36609-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::7) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|SA3PR21MB3960:EE_
X-MS-Office365-Filtering-Correlation-Id: f93b8324-8298-4467-b361-08db0c812a43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WGy8OULkTX4mvXXRGGbV1sbEkT3u3/DwHmjch5dk9bMCjcrEDAOFC+O3AtOUeHI5zzgJ6R9Vh+C9/Cl/9xQ/HPKV2c+VNFjWoa0btsIhJYrEfrj+uXyR8LFPK8t90v0ir8d7LW45eTJd7oo+/i39jlOAV2QXMyqomWqQCd0K4a+ogRGeHupFh5WCnxEmSy17Q8r7Q9OUKJw9CKLf4FStVM3HMLyH5TRFg1/jK6NwnKLJ4HpeboptK16H3lw6NcRLDtP8LjFdAlkG8a1m/1O8BFm7PmBElM6ZHAlMYAvgC95YgcKiLYbyHFLD6DY71OVbNcfXGmHyuiOURHyyKbgqOhkmRBoo2rUA8VU9hy3WHyImXz5WcP1uqcMUlh86UeADNwGQYya4KTUojsAhBJ9IRsFYVT6MVUb/W9Vh8e6W2TCNNaTtQLzf5eTAlNIdTyqVF27BXDHJ6XYxjfUwdbvZBRW3Qdc5FlAVfSEZrfwSB3xk8zAxsZRefDKGhmOs/PfUl0IzYfTb/K39RTvCc9in0j79DlD/ghCv+9C2ny59Qy+GbdfgcaWCI86zt1sqOSTrK935uD53Qm3EgLq3W0cEMUxeRGGZ+Nur/UY1H3ah4p4WvaG9VDorSv+UIClE5KvWHfgwE4Izgu9yKGe+0wBYpIb0BwZMXnglZ7Kc0I5J4QEOFJ//cst37f+ABvnz9/bltjw5oBsWf8rhMz8hk/iKsIliODsmfWvJ6+xlIBFg5gYpJtLdiNW6gbwHoTD0VHKI9PcnM9j0dMXtA3n//oY4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199018)(186003)(10290500003)(316002)(15650500001)(52116002)(6486002)(6512007)(5660300002)(26005)(36756003)(478600001)(8936002)(921005)(41300700001)(8676002)(66946007)(66476007)(66556008)(6506007)(107886003)(86362001)(4326008)(6666004)(82960400001)(82950400001)(38100700002)(38350700002)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hn55bFM35J5qTdKaPAxUKcOr0FYgst9yM2WQjlTZcxvDdFFww4rcIMwZ/LCw?=
 =?us-ascii?Q?IU0JUGYYIuyREKmtFg0gxB23xDzqv+LUIdDAtR9NUkaCtDSWKcUmQNajEnmh?=
 =?us-ascii?Q?/dAE1jp7uYSVA2reEyJnzRWcQNsO9+Tda/dsOyYKXUse5T2q9Wy5CV5rqePz?=
 =?us-ascii?Q?cg+lHZIuC4V7JY1N4ylEE8r+eD6hthqo8ynUqj8jqkXF01v5ydhk/RsHexqD?=
 =?us-ascii?Q?YaI/yjKtldEP1fSacVDP80fRk9MBsoGmRaWHRD+NsBH8iMsKN1RDifnuuKgC?=
 =?us-ascii?Q?4hHh9ibtqOhzGVC08eFJYfhI1HwVpssR2ANC60zKrxQsUL/isF99LkRQmxJt?=
 =?us-ascii?Q?fyVlS92DIyzQv5QHFwELOsCI/zFpVHjLuC7G7mXenSmATUOIvgcijHcmMAAS?=
 =?us-ascii?Q?qThGMlMqpxCp5S9LiNPFv0gp1DsySRKYGIYjZm8QtrbSQx7vXbbrBEbJOUbg?=
 =?us-ascii?Q?hlY7tVbkU0RPgx1A44IJA3tADw67D4358EkkdzHMrocNXilgO+bIwDRjlfdd?=
 =?us-ascii?Q?lrmnOdDY2Fks5La9IJIHOQ7s8uhhb4U9H4e5LKs3XUQeioAn15YlnLELHlVL?=
 =?us-ascii?Q?MVguLPkeFe/2kwRE2yEWZoSeDeU2gN9P7ZoMJ/G+6T36yvT5axzWYDAG8AcM?=
 =?us-ascii?Q?GDNtXde/bIPdQxybVS3zCOqOdaPmEL66a8mdOrIxag9n2AbkbMlzqetgT/dz?=
 =?us-ascii?Q?ZN/pOowe1o35PhxtxrGfZCvvYnZuqQwOaQh6TjmPUwoAfa79WabFDJWzaKpi?=
 =?us-ascii?Q?Wc21+/fjrmGWACuRJeSc2+mIXeK2f69cMspegCQNNG0B037ae2WVRyFSACJy?=
 =?us-ascii?Q?sUTumKVhBCMI+bCCHkoI7KRTPJe6dmsY6m1mZQJPH3UVOMCoz+L0Zc5Pioom?=
 =?us-ascii?Q?3yg+ljqh2lBtjTmU12P64UhR7KlBx3W87m2dMuvb1z1CMPJTJQqz6tqLaMe9?=
 =?us-ascii?Q?cJOpq8AIO4+1AmOe86B+pVZrp8x1SfCST+V4LFzYb8huciTuFXMpHTY+4IYX?=
 =?us-ascii?Q?ZhSOWAcDwEOHN673Ig39QviFUztpRFD2fc55EcRC/5anhVDvlgu2zz3jYTzx?=
 =?us-ascii?Q?3v7aEal5krylGhrBlVYUks9IYCdcGqmrc/SrZHXPJhYgJ/yKBHgKdgkvvvoD?=
 =?us-ascii?Q?yavExgGb67VHGQKBn8SQVf+KNLmuoc9LcrXSnI+/i5/BCZ2TeU8f1QDB0PmW?=
 =?us-ascii?Q?qmg9H33/DexPJwLlJcxX/GClZGxHe0aA49Yg4BIx/1KmhmpCjqIG6FjvBhZ+?=
 =?us-ascii?Q?XqN7Nr47I/4Owz727Wx456uygC4NA3mw06pxLI1zLSP0XGD9P9O5MY7QURDA?=
 =?us-ascii?Q?Q6cM6wRm46poL6nnv41FJoZynbZAxNDBR1JczcvDUeJBY8jU2kWueGRZhjhd?=
 =?us-ascii?Q?T98v9X5/qcwfi7uwdVTMOSuQAskcUod4uF0wv1pVA9x+vXWTGrxYrbsIgjUw?=
 =?us-ascii?Q?SE+Y9fcSA68fvZiOvSqFGTHb9t08xk8ift3kruakeRWlDcmHcr3KDBUxCa3q?=
 =?us-ascii?Q?/mWJAiLV+nnfCqlan7C7Tao31IAJbYsn5MlmQi5+rwhyUYe3rbbL263xbG9E?=
 =?us-ascii?Q?K33A322jZhpNZ1ybdMgt6scTRrWJioeptjAA8BPA6JLHqr7mfGbbktp6xqU3?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93b8324-8298-4467-b361-08db0c812a43
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 22:41:50.4339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EepHYyltGo3Ch5ZR6THJMOua3drb65OWbrJECWZxbpyWE46KwSH+0GvEhxeIPqbZH2CXLMg2RkN3tsoXKZbIhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB3960
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
undetected. Fix this by checking the status and outputting a rate-limited
message if there is an error.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---

Changes in v2:
* Add rate-limiting to error messages [Haiyang Zhang]

 drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 661bbe6..90f10ac 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -813,6 +813,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 	u32 msglen = hv_pkt_datalen(desc);
 	struct nvsp_message *pkt_rqst;
 	u64 cmd_rqst;
+	u32 status;
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
@@ -884,6 +885,23 @@ static void netvsc_send_completion(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+		    sizeof(struct nvsp_1_message_send_rndis_packet_complete) &&
+		    net_ratelimit()) {
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
+		if (status != NVSP_STAT_SUCCESS && net_ratelimit())
+			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
+				   status);
+
 		netvsc_send_tx_complete(ndev, net_device, incoming_channel,
 					desc, budget);
 		break;
-- 
1.8.3.1

