Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0824D6DE5
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 11:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiCLKCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 05:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiCLKCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 05:02:40 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2110.outbound.protection.outlook.com [40.107.95.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749BFE0CA
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 02:01:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTE+xJqnkC8NThiZT/lSgi9UFPDhEPJruV0Km13+2HBCTKlTJtZz04alq2z2MelUCsHdYCUAf5P1zUSzLZgx4q4nZ50pl4OG70fJz17y7jnXNhCUTUwpEbo5kuhkf8avn0KZ5dz2rTpFt6gesDiJzPhkGbsXjLq3nzu2Pty+ByXj6fQIV80abVTwTR+Q4KHItieHXYCiz/QcfbefL4rKW7qRPqg5CaVFypNGCxGVM+aGv4HvBmpki+r1KRdzDx+zYSYSO2ak36Ib+tpfAVMooq4u7kId3V+lVF3EsoeMgIEY/Ir9pLydVM/NlBf6deSVFNcb/xCqR14VekYKOacDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FilKcfGqPzAHIqeN0KKShoSTxABtAxVb8vxS9HZxXUk=;
 b=MDThPr/tb5hsrZTHQxiwCGKjMh9/E+ElwNYO9Q470VT014yD6hJIxeV1gQdZz2hmwXH3p3oRgTMiZGywfkYPN+TpQOQSirUYmaKs5oX2OQo9RAEA1bDbMt6Kg401boiXyeXu4vrlsrY3xXWi4mtVL1Zt64w0hIEwK1cDmlu7KQNKzIfSdFHD6bDCL5e7TtgPdgsvtfAs6UEsXySVxzyxjN3e2Mnq+NdWqO3n4LTIHPvb4wIjtY3E6Cc/Tezw/8gJM5rYAA9zOATF5erkKCflH5xfcSTT27caWnXe6pZaXhhs725VR83fw3YTaDG7Qblp9aaxPfAkaBCpLTGC8a3tlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FilKcfGqPzAHIqeN0KKShoSTxABtAxVb8vxS9HZxXUk=;
 b=uv7vlAXOhTr4qXYWDDV2KCkIdQHgPjTVNaxlZ6GRGqdhpJYH/oDmD553g8+aNHlGvc9pyIKbpq71a2PMQihrbG/3MlfcOdN2WKKudsT6bwaCU3FSpaHMgHXaE2KTXLP+1c77/eveHLFudXRBC5SxpP5r6Euym2gY0jdadBRA1Hc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by BY5PR13MB3538.namprd13.prod.outlook.com (2603:10b6:a03:1a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.10; Sat, 12 Mar
 2022 10:01:32 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::e035:ce64:e29e:54f6]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::e035:ce64:e29e:54f6%5]) with mapi id 15.20.5081.011; Sat, 12 Mar 2022
 10:01:32 +0000
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>, oss-drivers@corigine.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Subject: [net-next] nfp: flower: avoid newline at the end of message in NL_SET_ERR_MSG_MOD
Date:   Sat, 12 Mar 2022 10:58:23 +0100
Message-Id: <20220312095823.2425775-1-niklas.soderlund@corigine.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:312::22) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbe385c3-716c-4394-ec4f-08da040f489f
X-MS-TrafficTypeDiagnostic: BY5PR13MB3538:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB353823E34C8EC1C536F090E9E70D9@BY5PR13MB3538.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtxeoaPtSiIR3YOYhc71ol5zZVrZtgXXHX4OAJVB/dLoUdt7LWQ2swpw6rO9P37u3Yx+yfvWIQtIEZzWiBPRlmCL1Ek+oNMBiZz6E+jMvnwC9IFbDlfddtB3XAdTy2FzsPT3BIAj/FAgkjKEcMiQ4FodSpWn9Qrlp6hioXsVLRzMks/wJe1k6Cubhc96e9/w6nb7s+qXiQ12S3hWZfqlLqkLLF7j8Q4ZWVCfspUV6NI8ZNf2N8cPUNwCvciYfJtpYIFJrQ+AX98tM/AJix4U7QAW/aKBixV0YcetSg5EO3r+jGCF4MAqpWoWJRiiUahtpW4BklDS90WRfJM53Zwg3ZDjM3LmvPXdBVVp1bP2xno7Hop+Me6Q9NznAxUt6fGr5b68aISMy+HTkruLhw946D/sXjkY6iYfY+W5PTKzTra2ILqQveTD6BlcPC7xgWrOguHy4CKuXogesqC/YbL4jTxr80ZfXZd6pGEdnrOp36ASBZQC+TCYJgJ8+A7FdvPGA6sD/r6cmgoKkao0qiF10xZ8qjgMXSvOEN8Rc51g9NCwBqJb5KS8GbJwV0RqwOHRIXC8V+pUbo0ofJ4Vw3QGEcBfSexRzqpzNwmgzJpNFhR3BJGGIczUWj1d1iFYdGuWhQWMM9UVuHulj385k62HwiGcwFj6DhMEP+VkFreMlYzWs9zFVBwll4PE6CzCtogSe3knRuc7chF5JwJlNSwEfmCKYGz7CPEtAD3ZQEjlN/eGItk+dcxTbHVzNPIuQJJ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(376002)(346002)(136003)(396003)(366004)(6486002)(15650500001)(2906002)(316002)(6666004)(54906003)(6916009)(86362001)(4326008)(508600001)(38100700002)(38350700002)(66946007)(66476007)(8936002)(5660300002)(8676002)(66556008)(6506007)(66574015)(6512007)(2616005)(186003)(26005)(1076003)(107886003)(36756003)(52116002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b015U0JiK29MSlNwVFVmMFBKQS84bHRWR3AvQmpMdmxjR3BYV2E2WVJzV3Az?=
 =?utf-8?B?Qjl0SlpLRHplUlU2bVVlQnlWRVdQK2JmemV0N3NCb2pqRzFLMjJhWWs3TVlY?=
 =?utf-8?B?S2NiM3hSc29majRWWnhQTnFVRkt4cTdPaGhBMXVqS25hU2Z3d3ZDUkhuSkJt?=
 =?utf-8?B?cWtoYkl1UjNremR1bGQzcXVQaE5MaGVScmQ2TTY5bjY4SDU4L3ZTVE1mcFFG?=
 =?utf-8?B?ZE4wUUVhZXVTNEpvKzBxUW9JNVUxWEZBRmFqWUF5SzdEZElsdFM4bFFSN2Q0?=
 =?utf-8?B?dEpGcFcvNGNCQWhsTXdaWDZLRG5oWkxhekhBeGVFOG9qSGtvNGxWdnVlU3ZJ?=
 =?utf-8?B?dW5XVDlBeDNUL1hkQW5TSDV3QnVRUVlYZFo0UzJWc3NFME1MeGJlZm5MNWsr?=
 =?utf-8?B?STlmZWYwaEJMQVk3NHZWYzdIU01hMjZjVGVoRTJuRG81dGdKMmxsVEVTaUVm?=
 =?utf-8?B?aVdrUWFEQTNhcUZzeEp3aWhlcWZJM3duK1BSRlkvdXZ5ay80eU1ORnZvSjFI?=
 =?utf-8?B?K1lLeUdid1cvOVFaWitjSWhISFVUQ3ViS3V4QXdVejFaQmVqeVVnQk9MZ3ds?=
 =?utf-8?B?SjlwREE0S0l4NDBHNGxBdnRIcGZWQUdVZG1OOEdKNVhWUm1JUDdCa3gxRFdx?=
 =?utf-8?B?bldDcmhXYnFZMktQbVN1eUpFREdlMTVSZDJGK09LWUZIUWJld0FLSXZWWTVL?=
 =?utf-8?B?Y1RQWDNCNTJyQVo1dkRpblM1YzBBZFdRTkFvMDA1bTRlTUt3Wi8zcVo0a0hJ?=
 =?utf-8?B?SDV1UHJXZzFNWHZDVTNxR1IwVTY4MXNjTU8xRmdmVHBodHhWMEZzbjJkKzFx?=
 =?utf-8?B?ZlNRNkVNRldUWEE0bmgwSWVkVSswZjBKM3pDRG10bmRIT21jaTNCV1hZSS93?=
 =?utf-8?B?NmdXb3o4eUQ1cmkzUE5RdS9DYW9aQ1JLa1lHNGVmZnM3SDh3QjVBR243VDQr?=
 =?utf-8?B?bklkNUw1Sk9USjN0RUZaZ0owaEN4RG9rMGVmd0tTa1JlN3hLS3NtQlB1N3I4?=
 =?utf-8?B?SU5FS0tZYTg4NGwzREtHZ3g4MmQvTml0Q0cxMTY0L2JBYWNmME9DUFo3WjU1?=
 =?utf-8?B?eDFyUEVVWExFYnQveVRnSnltT3orekFpdmJtdmJDZGFVT3M5YS96azJGMFdQ?=
 =?utf-8?B?L0E3b1dmRDdvdUdMbnlsakU5cE1JOGRPMHpZUC9hUjM2VzBRYndadDNuTmZr?=
 =?utf-8?B?OGxvRXU2b0lrVXFDQVcrYjZ4cE8yTUsrTEJ5TkFnZWpMb0hQTDZMMnhkZ0RO?=
 =?utf-8?B?MHBkWTgyTzJkdHBWdlEzMjcwbGh4YjljUWJkOHFpWjhWSUh5akZyN1A5aVRj?=
 =?utf-8?B?amlZeU9lMU5JbUt1YVJoOTZiVE9MeXI2cWI3SDc1dEVmN2V1YW4wZkwxb05U?=
 =?utf-8?B?RGVBZ08vOHdFMUlEVEFBakZ4R0FJckliUmdoSGsrWG1NS09wNDdaZzVXRDV4?=
 =?utf-8?B?cjMxMGVkL1dEbWZFb3Z1Zy9NMHUrTWYwa2hGNFlPZ2YwdDl4dWtoRkZnUCsy?=
 =?utf-8?B?dFF6My9JNWFjbmhQeHV2Vkx0MVF2MzZ5TEtVNWFKWHZVTkRuRWpRTVdaVEJE?=
 =?utf-8?B?dHd2Uk9UNTlNVDlWTVREU2NTdDhQN1R1c3BzTlRaM3o0YzFuL2F1bVk1L0hQ?=
 =?utf-8?B?b3RFdUlLczJFclViSmQzSjNJYXZJOWZaYWN0cE5wSjBkQ29BMW5jYjdORlc5?=
 =?utf-8?B?OGdTVTd5a0lCQmRURHpPTTlOenY1VnVrNkdPTUFnUHNPSExaSEVoNHFySDBa?=
 =?utf-8?B?K041UzBFVUhDM1J2ZXgrYWZCRUtna281MzArQjJvNzI2bU1iOGZnSXAzaXA3?=
 =?utf-8?B?ZnExcVkzYnRtQk9ud2JnNlJaZUZqcmUrN2U4ODFlcVZ4cmxXbWNob0dYay9a?=
 =?utf-8?B?Wk04RlVzSEJyVFRnczJJcCtib2VnZ2xiWlp6Y2M4UWM2RHhRRWM5VGM3eldp?=
 =?utf-8?B?TmlOZFZFaUZ2WTJPWE42Q3d1Q1VUc2pJeTdkOTlzVHRQWENkRWlYOXB5UjVq?=
 =?utf-8?B?Z3BsN3NBWGNRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe385c3-716c-4394-ec4f-08da040f489f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 10:01:32.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVELAJamKx80nP9iE5bTMKM4GoqvP/qG0IgiMdJQwzodjeMS3Ei/mSwaeWkrF5LWYwF01t3KvUQSNua+HqUCQ3P7oNAnatE+SXXOnMLM4mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3538
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

    drivers/net/ethernet/netronome/nfp/flower/action.c:959:7-69: WARNING avoid newline at end of message in NL_SET_ERR_MSG_MOD

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 2c40a3959f94da31..1b9421e844a95e2c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -956,7 +956,7 @@ nfp_flower_meter_action(struct nfp_app *app,
 	meter_id = action->hw_index;
 	if (!nfp_flower_search_meter_entry(app, meter_id)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "can not offload flow table with unsupported police action.\n");
+				   "can not offload flow table with unsupported police action.");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.35.1

