Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEB8561902
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiF3LWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3LWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:22:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2134.outbound.protection.outlook.com [40.107.220.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD1860C0
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:22:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzJfeUZvOwTp+SBqR0cSCbilzezwpJIKvOrOYbzrhVze6AKpqOl7XG2DYjKng1vbUfIdd3V/sPJjzqgaLIHkc3e+ypE/oO55edQSZTXDTJZ6mavWu2cPvA678LG/wJBR2xbh2r0xGRzz+IvWfQjBfFjhBfWXFLXp7WJ74f806jLGh9YIRB7JT/XkX1lddNbHRfGC5esIbTeJvkU4j0mXNa0suW/FF52kNqYB8c2FRNL3vP7KuPQg3C/xvs59hu3Nums5Y0okbK7qmQMhcH6MaxEi2x+sVlIuOstZh5ak7mmldXmfaX17mCcOHywAZoNuAynKzEuTmEyCD/bTWuI8Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puoN4/LttHlMlsHgE3plFzT3cSKxsyTtXILZWgk0oDg=;
 b=OLfhMb0JONrGAPz+KFKTjf0GUgFTJ3X9DdGVec0TZYChHByy7+4T4WQ8cplpNsDXfg8kcIy7QdJcuJ3KdR5QO4dt0HRwgf9/bRlLc8bKP2d+lHlvL7EPGI/1cYqbRj87zQS9LlkE0kQvkoTf4GaEBPrRSFNDWTptyF++xKnBDPXfWa+K4vJhcOmzxHnKjEz49XKLAs8ZjHWmgePygbVRVTeKxoP97aMw9hvE+joa9PwrIiDEKolbeBasqzYrTt1GkRaU32vnXWAzh0urIil8FfqKQ2Vf+7da69AsArRclA13S0UxnnCC2PR4Um74LCtAZN+SX1HVxmkRWXMsxP6gGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puoN4/LttHlMlsHgE3plFzT3cSKxsyTtXILZWgk0oDg=;
 b=vSFddO/f47N23H76jwFK85FCIdsHyGxVmqT7YzCHzw1Gf5iG2sYmbtj5Luu9E9XjAcUAlNk+Xw46hI8K+aTsGfVUBHCByAlPrLaAy8T1JO/VGyoEu7rluHTns5q0J4AgIkgCfg97qG/SNV9D1WuJ5tbu1XnaDhrqY6jeR6RzKgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3629.namprd13.prod.outlook.com (2603:10b6:208:1e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.11; Thu, 30 Jun
 2022 11:22:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 11:22:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>
Subject: [PATCH net-next] nfp: support VF rate limit with NFDK
Date:   Thu, 30 Jun 2022 13:21:55 +0200
Message-Id: <20220630112155.1735394-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0029.eurprd03.prod.outlook.com
 (2603:10a6:205:2::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06f3eaa6-4042-4df7-bf52-08da5a8ac621
X-MS-TrafficTypeDiagnostic: MN2PR13MB3629:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJg62Rv7bRlrI7tm1O2172d5yzHkmyCxyG3DdrZEO/fjGL0AMrSLWoLp9w1tsT0i67/kPBvZfy53Z/rV4+plQ7354NTJSacDcA1bWAR+MSbJgAG1Kwls8sh2Ut9UHksnJVjZviofqsGE5hMYmVXbOJIH5Gatb2/cf9bHh7bTMTqZe/7vncrE4FLJkL4WUEUwhu3NmFr5kiMkECWcbY/I5TDYsPK1C3yD6GFc3U7shsq7QNZACnPHgm124YYxHAzyuC+5kG3K04h4Z76YIW3wW+EVZTe3OyXjz6lAAA5Bt9GpJCqhD+H35B6p419CSV4xi3PwK7Rjlx8kQ/PUWQeIKmG0PtkQaWALtPbVqDut2NIXaMX98l71XZgvdcN2+XUuvjKze/1eOJsa78v346uRzbPE3Yb3qzNHQCHwVSN8yApkCFp9gm5MuWA+mmMPiEoAvVDJn8QlePc9Vnxnoa8YYvDKWBjwUYVEwfKLbQB0PbdxEziQgCmRi64NESKwWJ83uk9Z7hij3PLdNT0suExsMuAkPxxKGoHR8Zgo13jJ0IaH+TpSrRRREnZ5P3Ezln4TLAiusRh3wf1Gj08dj7ZD5TTELpE2ydTiESzlqHK1jkcYNmqACnmwBQXU14Gq6YhidnyX0Y7mTYEtT+uiwF635YOwvF3Ws0nYfUsxu1RZzQPd9P+A2vf8H+eHPHJuQI40tUxhiVw/clqYpK9w/YpIh1of+m7MvF4k9ntO2aLfTFnhfl00CUto5+JuKTRPfxUG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(346002)(136003)(39850400004)(316002)(110136005)(186003)(41300700001)(6512007)(6506007)(2616005)(107886003)(52116002)(6486002)(36756003)(478600001)(1076003)(38100700002)(44832011)(83380400001)(86362001)(66476007)(8936002)(8676002)(4326008)(66946007)(2906002)(66556008)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G6lUrDjnZaGk2G8TqgpgHmVL8PKTT7xbHwsTiDmuZO3m+R+Mnccy+OAbCgmh?=
 =?us-ascii?Q?tN8MRA+K7qNEahEUiaenkgeiucOV5m7DYBQCLFC1502WmST2Q09DbIVtyygc?=
 =?us-ascii?Q?q/Fmn044FtLxS7X///+fYFwEnGECLLCQB0sJJgraA6QpesmSP/y20Pz6YKxK?=
 =?us-ascii?Q?T8iBxqdjkICgZdgB7y76dbxAetxRaSOTA+7ri7bZooVNdjDDISAjoZbPT/6J?=
 =?us-ascii?Q?FDwKpZA4nQYN+f6n9H9TzVTJSV0RpH6raYfZzQP3lCPDUxnE8a58yrsG3H/5?=
 =?us-ascii?Q?UWBbfBpsnOntyn52TwbQO0A4kZZt8wvzdWt57AjCI3M6e6snTXI2J/ahHaFU?=
 =?us-ascii?Q?HJJ7fRmiady6YD9hs2uA6O8eBj/Ydy/3QOO1kiw7ib7Cg9V7+HfgVhKQJ3A9?=
 =?us-ascii?Q?f9iPdrkMsZzly7jqhUdI2FEeIU90iRS10P1jmJqewJs/xD9Wlu+6O9f1yTyj?=
 =?us-ascii?Q?+LCGqvRQCSJR4D9KNzU86jagjAojBEqqEDaac3pfleMRXsH/fl07xwHNmxiZ?=
 =?us-ascii?Q?h4YoW0kD8xuGOHyRu8grA+8Wn0TH1+/IbxRuKVI4aKliLCi1yBu/tpc7WNYF?=
 =?us-ascii?Q?/Fb6uvlsyNv0+cYiaaRTGN0kv1uFV4Xrbg8tABCu5Q5qXlxbJBeFVoICOUnh?=
 =?us-ascii?Q?yE1pFEge/NkeqJoIFruZ9NNhnItvuichYsNaXE4L4Whgvi5vn7b2N4GRmvV8?=
 =?us-ascii?Q?n0pOI8UEr0+Gm0aIxIurZw0ddUf3PHTjTmsYw+tvOEioYdI9povBlFKQLsEp?=
 =?us-ascii?Q?AhQiXfySCa2ImfClrQnykHTasozpB7e5YlAQFBCwYYi1GyWYvzYH+S8kxVLz?=
 =?us-ascii?Q?CXZ0yp/8XqpSPYVRpz/6aTakiKbx53f2SLL6eaudcKuwU2W3L82TWT4Vox9R?=
 =?us-ascii?Q?+MR0CUEo3uxukP3z94Bvi9E9BT4aZwhl7W7aeUCO9kmXVOHdjuOtc2qM4qr8?=
 =?us-ascii?Q?4EEsXjmeWI3tzxM1a52gIj85/sy/hbsCDoGoRU4QtUBpL7N5/mhkSxhdlY8x?=
 =?us-ascii?Q?/No4qmtEDvdF0QVbWmWsYCIbxtC6vbIt4/ZWfeOxxnrBwBUlUs9JZwsPEZa5?=
 =?us-ascii?Q?cU6SCOex6MlrRG8oVarwlhxkuwWImIJwDSqKL7j/8+3BaU8lUTM3ORy7q20y?=
 =?us-ascii?Q?TlJanDhAWt3TXZ5RPGXfkaZFpJtHBFQYVeqrr05SyVKjLj5m5EmNVPB+D6r3?=
 =?us-ascii?Q?i7JoL56uK8c/J7MrfLsadkxvsDD+EtiLUr/oha133/iv46n0ePP7enazZWKu?=
 =?us-ascii?Q?u4yUTfKfRQpfkbYgXOOsbKor89gXoJq0yXfBqOIbGoo5VT3dVT+4SNeCrSCJ?=
 =?us-ascii?Q?RoGhTr8XaNJ/aqoSrukXFZ/ROyAE5QG1jzIOxmwIOP8kxbt7LOakyliFWs2L?=
 =?us-ascii?Q?lHxmaYaEj80cEcXboLUdzxC5mXp8WNNEeMnRdg4xvG8R+xQ3wqci7GokZJag?=
 =?us-ascii?Q?ILnkKhuAEwFBlGZX04/cVmobryaQmyNGUeP3RLa6084uxfV8J7obvEUTkxUg?=
 =?us-ascii?Q?zkV9t4lWhg9nyQ/q6qx9cyREQCFgUOWF6wn11lIbzJCRywy6Pd9iG2z6A9Cs?=
 =?us-ascii?Q?oILltsGNFJXWvA+bGCL9AyGYSQANWuMhQDlZmok6iasy8Y/urYeIuYCpZ9hB?=
 =?us-ascii?Q?sdRqpCeoxikSeSVXn50Q32puYFvyPSJ80da+Nr87Q9ZPmf/IkVZJ2pAvlKnN?=
 =?us-ascii?Q?W0U/FA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f3eaa6-4042-4df7-bf52-08da5a8ac621
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 11:22:10.5870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0y141HBxRy1eNlF8mxb8AAt1r0JXwSTB2yXAudr9kzuwA8BSQzGt634qFNur1uTOWEAxdvlFbFelAJZMJb5HT+XQ3vkxRqAUUMJ//Li++6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

Support VF rate limiting with NFDK by adding ndo_set_vf_rate to the NFDK
ops structure.

NFDK is used to communicate via PCIE to NFP-3800 based NICs
while NFD3 is used for other NICs supported by the NFP driver.
The VF rate limit feature is already supported by the driver for NFD3.

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0991fc122998..bcdd5ab0da5a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1998,6 +1998,7 @@ const struct net_device_ops nfp_nfdk_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
 	.ndo_set_vf_mac         = nfp_app_set_vf_mac,
 	.ndo_set_vf_vlan        = nfp_app_set_vf_vlan,
+	.ndo_set_vf_rate	= nfp_app_set_vf_rate,
 	.ndo_set_vf_spoofchk    = nfp_app_set_vf_spoofchk,
 	.ndo_set_vf_trust	= nfp_app_set_vf_trust,
 	.ndo_get_vf_config	= nfp_app_get_vf_config,
-- 
2.30.2

