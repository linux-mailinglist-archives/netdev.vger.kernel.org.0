Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4748F4BB9EE
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 14:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbiBRNQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 08:16:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiBRNQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 08:16:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2119.outbound.protection.outlook.com [40.107.243.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6430E229DD3
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:15:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7IDAtG149kCh818CQZk8v0QZ1g5CcYa9M7tVNnFnH3C/A2O2kkwMoXrEgUhRFIDKXLQp7WH8HlA7RLCdemNL/pHV0JGXvri/54CvrbM1486hiAasW4kFmYnfKSlJvnDJXpGxtgP5kvH4f3XlPaJ3t9Gkqu9j+RM19G2Pr+cQ0IAM6dLpDyM1mcm3/2NNqL3taE+WPaHgRhqQ2zykP8q4FDaynNfZtBxCfuiUgCPp4qtXCj3/xZ23OVDrX0sx6IohKkzgogzB05+2pj6/4To6ntJvhZ3NNNaW+WV3PqmsMZEA6WxwopoBNeSc6anWxkOf7JsgVNuw0/5f7yLPqpZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLtnCK2v2aAinTDD4NImQuuOK5aSds5XBjeK9xLHa6o=;
 b=Hkv6LqDrX1HzM3YDjPyKtS/5HB6AEIh8+9vN0BQ4rzkCOS5/k65k47UyiPB1Vxfsuh23hXhH43Fy5IikLfKY2tuxgqBHUx/yTMJDWMkkphjU3QPLbR/fJW+F0ROfe8B1Dnlre8jXQc50w0Q7oO11QDJFmfgFHWIBx7VV2MO3JEKuJp04EbWfKO+YGVQ4fFggzGKiupG0udhOk1DTCjen1R1TVCRHL9NA9+vAyLNlQ4CF3c3hCDa9MW8vTQA08oV5T0ACw4YY7z4rT/R+2ezIEx52LbBJnGjPXh+fxYCwza0KEyBqaxvCzI+xxr4a5V3GHKfs/uIdxpDEHHTto642oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLtnCK2v2aAinTDD4NImQuuOK5aSds5XBjeK9xLHa6o=;
 b=fpYzEuK0vu8nujtADMzwLrMC5lnBollhRG9Wk8f7mEvxthQLnwP6Yr4t8R8Z6qeHgdKVyH0kVyen7wU1w9PB7Tl9ZOTfibbqhqZ+q3POMfZWVYlX9WDK8Yt8TEuiXI9q46EZ0kkJrBxy+FTsIieMH/TF316VUbRYte+MUf3sfpg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5507.namprd13.prod.outlook.com (2603:10b6:303:181::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.13; Fri, 18 Feb
 2022 13:15:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 13:15:49 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()
Date:   Fri, 18 Feb 2022 14:15:35 +0100
Message-Id: <20220218131535.100258-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0098.eurprd02.prod.outlook.com
 (2603:10a6:208:154::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 899b1626-6dd7-4d5b-bb6e-08d9f2e0c815
X-MS-TrafficTypeDiagnostic: MW4PR13MB5507:EE_
X-Microsoft-Antispam-PRVS: <MW4PR13MB5507B8D501DE6DE29B78BD74E8379@MW4PR13MB5507.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xmn2ltmRvGx5ZERjh8xiSonlgSyBFjmXPTEsbcO+5pbcZnO7WUGuKifm/TuiS4Xt3lnT/oC9OhdnCJgnV4E9/NWk+RanvHrm5dA3hB+cGYLmA3w8s53QzRwiSFzkct4EkDPFjmWTMYb6LkC85ZCkj+35ItxC1UgQXxoYlv0LUDYp1QlCO7EvQg2E2h02xvYWQVZSMRywRH8rhdnG/8UBQQJxsyKer+ixGlHbR9cW74FlNgSF/LREV9Jr3jTFNZWpbTn+j7Pxik1Ghlsp97E1xL+6EDEf2UQgTeFkKeJ+j6IvpFV5k2K+8f2vaHYPV5ojoTWUVPWQ90g0pIWr/7RUJ79ztc7FXtuHQR/dsiUpqNXVosb1hj4QAUoGFD9wnm/CW49ZLyq0Q67zO7peNDwQ5Up11gRw0T9cmmjMfffa+Q37M6PQQQBOBZQL9xN+o7VFUl25e0i8y0kNhlWffWPxqfT+EyIkiWjBA0CRjZ6qch5YskEaO1MMWnkEFnQXKynwhKSsjDohLnsMllQmKeIT0SRA2f4RvvhIx/RdDA7aFTYhPVpuOXXpML7U9Fbq7D6BM3LKel7DVCikR2fXo8Y13rukvb4J8h1cIlZwzWKwnU0YgYXSSjQx646gx7Tge5JiX06UVhzHVF5sNdbrkyiRALqnvi9lhcHQe4vGmfMo1aIanXvRp5j9oHCqZdsOkyl8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(366004)(346002)(376002)(39840400004)(66476007)(316002)(110136005)(54906003)(1076003)(6666004)(6486002)(2616005)(508600001)(66556008)(66946007)(83380400001)(6512007)(6506007)(186003)(5660300002)(52116002)(107886003)(8936002)(2906002)(4326008)(8676002)(36756003)(38100700002)(86362001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k1brCFGvgJg1qlO3z9BqKY0vKGe8cu5NeYnWKbiM95ve4TnRbEWf/FE/Lg/Z?=
 =?us-ascii?Q?0YaE2wfncPZFn4FdnzIr/h6ae1xmUCoNHQ6NqusZEG5uQMoB/anXfHMUbDgU?=
 =?us-ascii?Q?MqR6x7IVkAPS8DIoONeIEP5obFBd6Gf36hnl5KzmHKHxrq3+cvtw2tqU4xyA?=
 =?us-ascii?Q?fH1w+TESQAidaai2vPa/9Wg2A9lQsDZJATdlclBXq4/uiBabIDEv+IbJgbtp?=
 =?us-ascii?Q?3G0pf7iZjLaBN1/1kE9Nw/NNAtBoKsz5NvfRL1ATl8vBzPf3Dn/wkQHoTDqW?=
 =?us-ascii?Q?7gUw7hy4D0W1OcDgHgf5XFtHXWy83TXc663ETtlOMbyZZLgHrDomefiQbZtE?=
 =?us-ascii?Q?IF/3hNff10JwOPjKd9Mf26ooZ3fG6+pYYPAS/T2vxf7GUuJck88vR0G3zwxd?=
 =?us-ascii?Q?E9UMu/6Zy234CjYvdox8GpLB5R0awifOJGIn1hDlg/epmMsUAkjcfLzumq36?=
 =?us-ascii?Q?17p4PXvqhfDZ700UjPOm2sWguGVIKEt+8isKH6VFJWUXFCocYQnFEls7AOjN?=
 =?us-ascii?Q?aZH10DiLD7XImMIEe0KN9xeB2c7uAl6fysS1qTOEswzAh57yz/QbSUPk6go4?=
 =?us-ascii?Q?4hKcvKGnYyB8tHD7K1SQPQbCiPj/0EilmBq0DEVwlj/jcH6JP1eqFH4XeZW8?=
 =?us-ascii?Q?LcW9LqB2MwNuBvBniuV37UGnpxug3bDrFCIrgPIlLW5bWS03FqKXUwd+SuYV?=
 =?us-ascii?Q?ybxAlykWgpEDHIZQA3MDph0+7ZlOL8ts5Zzpsar4gN39BZsqBtM6WXveCxNx?=
 =?us-ascii?Q?9Vg35nFvm8ouoARiWDQiJ92wcihQdtZ5RwtEF8ffKvmZ9KUVICb0OFDRvwhy?=
 =?us-ascii?Q?8TGdsSV0pHNjzC9X3cyD3R3ffVXDb0eOfYdhouM1n209IqJpdT6IWrW5kuWP?=
 =?us-ascii?Q?uDxPjAge9tYI9gIJYJR7RlsYT2xUeu0A3ZGy8/hG7d4IdCp68q2Yz05I96Q4?=
 =?us-ascii?Q?6bfnpCAOfU1fN9bPSyRfOLJsKBZsrDaocC78bMPUqCXck7DRdlOxi5Kg/EP0?=
 =?us-ascii?Q?IF+KYV1Me3v7Zcl5g2wKpHpeuK2l7oOu+2s3WYODE/SJS3qbJSKLPav+Ouz/?=
 =?us-ascii?Q?dmRUcKU4xZ9Jy74LrSG98IGJUkyZRagj5L1YJQCThgil9TLooedODAh8gYEM?=
 =?us-ascii?Q?8UUeXMchE43puOC5eCPOkxWw5Zis3mS6osMBb47d7VzIrqeSigNp3Q0BGGoA?=
 =?us-ascii?Q?mi/sKG/UXQGaxhp2AxLbedR+lO+lJR17yjbr58jeuKaJDq/bSZdqo7FkQn0D?=
 =?us-ascii?Q?rcr/xUVMwwTBxfriB1UuSVLiHyRMJIwx4w82nTcdF3ciahwNpjoO5/YQlrNg?=
 =?us-ascii?Q?w3tyXXDHd5i5jjXlQSnN/+YHewdJcLZvxeRhA4LHXVdFHkr3GPwlPsHdXP3I?=
 =?us-ascii?Q?ryRcl/LI8AknWaNjAlzrh8Ra36xVe0XqvgP2rqAQcv0iYPrw3JVhPNKUU/uh?=
 =?us-ascii?Q?9goDW01gaCw4SCI7OnKkkZomO+Rd+tbq9PfSwgYMm76tnfLlwuqzGbYINbNh?=
 =?us-ascii?Q?Lsei/1rcNJh8pn/6B95hMJnYZvfZ2cUUXRUpav7bpXewsg2Et+lFTy23yfp8?=
 =?us-ascii?Q?3TAMfzkVVo3jl25D7qFTg686YfLnM+DPdE21WyV/rrg6U81jHI+u2LmIu2+O?=
 =?us-ascii?Q?EPJr1iAsagoyZjebZEfv/Id+xdDFsOMIgEGA2Q+LTeVDAzWGE/ZUI68pZ2GL?=
 =?us-ascii?Q?UrXVl4eaKmEImnRn+gtAf67D/vIa0VcgIMD8Ftsq2WCPtv5v6S0WSpG0ijBh?=
 =?us-ascii?Q?XbIRt7J2x2uqhAEedoe6Y9wcSe9V3Js=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 899b1626-6dd7-4d5b-bb6e-08d9f2e0c815
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 13:15:49.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfz5495XnnU3KKbMAiVsIuUsvJVgzSdYAOrQwFMPsaArGK40spJ4BYBoy6ddq/I/GfwnqiOHhrIV932WN9iHynHwuATItGFsXYq2gSbOtJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5507
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
inclusive.
So NFP_MAX_MAC_INDEX (0xff) is a valid id.

In order for the error handling path to work correctly, the 'invalid'
value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
inclusive.

So set it to -1.

Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 0a326e04e692..cb43651ea9ba 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -922,8 +922,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 			  int port, bool mod)
 {
 	struct nfp_flower_priv *priv = app->priv;
-	int ida_idx = NFP_MAX_MAC_INDEX, err;
 	struct nfp_tun_offloaded_mac *entry;
+	int ida_idx = -1, err;
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
@@ -997,7 +997,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 err_free_entry:
 	kfree(entry);
 err_free_ida:
-	if (ida_idx != NFP_MAX_MAC_INDEX)
+	if (ida_idx != -1)
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;
-- 
2.30.2

