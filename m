Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD486E9686
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjDTOCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjDTOCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:02:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E9A1728;
        Thu, 20 Apr 2023 07:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9oA/ncU308YDXfF9NaRZHILD9RiYWGUNGCmFvtPSNqv1MeDUFxFmxD+fggQJe1+YXzovEKB7raFdrgMiMRpnPNswOESCcIBz7UBnk3WGTTGXACezEtX72biaChe6ksQzcNV99MjKdzDiwrijMfvIzx15ONu387eGj+xrNDgTZnDi/HLrztQx6vz7JXTSDLJ1GgiDmxz96oQwtoQbXNFIQEXOtAqYthZoWkljBMjFNLRt5W01xkvGNWQPVNQKGpvmeH/9Zyci24q6uyyow15hYyQE+RQDWB4RWUpv+RDWGTpX72YVFbMqHq14mdWqVBs3BwlWZLwJvO6yO3wpufJBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yVsWfAukwqs/LPLQxLUm3eQ7W+xRG6x6cwl8+0aAbg=;
 b=NVmgOXbFljx7E+zTB/mWce7YYXsNEWDRkZT4Zam6f+rD34TRLeVqIVohfhJcSo0i8FWveXMmZHNdX5EEJMrPjblxHDeJFG0cqfByut8+LEzztCwGLeE5J+5FuGxZf3RJurJjJblb5tKoygHmlDZlmYLu/weoxd/jw4vrC4y8l0AmvR+hiGe7PcZb9m0qBUYtwdagRo/WYMgblVpmMolIwxCMxuwrQIdpSPQIddAXFW0mHSzt3AK6YnMh4z/fNgtZqKTFmGMJGdy1Tl0V/nSIywVgxP4gXQqK2LMrMVGk88NS+E19unINVRBw+2rL/55RNUfb8Ox3VbuINkCvUaOXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yVsWfAukwqs/LPLQxLUm3eQ7W+xRG6x6cwl8+0aAbg=;
 b=aCX4mkFF/TbKmk4ja0xdJBIB4GSqa3OgEqhqw1pn1VkeuC+iuEen16k2ZxqF/G+pDpdH6Su/pLZEfXAmN0UafdhsB3rx1ISBGtx5vPaxAaO3JK2g1kZcp2At6v/bTwWxkUvfIyPg0la39/BOwfz4N5obJYrMFGSsvuHFXPiU1hM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA1PR13MB5021.namprd13.prod.outlook.com (2603:10b6:806:188::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:02:15 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:02:15 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net] nfp: fix incorrect pointer deference when offloading IPsec with bonding
Date:   Thu, 20 Apr 2023 16:01:25 +0200
Message-Id: <20230420140125.38521-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JN3P275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:70::11)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA1PR13MB5021:EE_
X-MS-Office365-Filtering-Correlation-Id: e3407c69-b13d-4837-8d93-08db41a7d85e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrHbcKSSTJsrdRlQj1+Jbms/BXX1FTJkX+k7xRdXdlobQnnu+8vIc7H87p8A2+HETW2IzTkvOhKAhFeHBgM8HBcvYipOtM3v4ZjDDl3sKpzCut/2V5ydujAYGfCDl732o92ZbpIQ4vxuc226PUCdrECzDq+1uAXrh/vF58sascML/Lq9nzA9koJwizOBafB4SRv4q3jDn3IeV7jCpv/zi09kASbtMWttnfcfKhj+29BOnx2ihX6JpRgngT3zXw2KC/1MrbvfTS76/ZkEfrltdSTokkP1j1miPgLdZWzG7GRul2W5LyIN83ZNGR7jxkzo49NQueQUKZ1t1PT4+C33G4ElYkE8co2MrqCEJfmqi2QcQxnP3o/4Vy1nIBvHGhtPrriJVu0k6qelBagLPZUTuovvnFeMHiEAa2iy+55M3LrJ7iRvgn+VOVSdrm5nwp981ZeKBG5TBAXbPtpsOScdkC3DtBVi5/zlfB8QU4MyZevlDzKxfFqO9VjT55zSg0LzvxT6gQ12PgbtRdlPLqMjY79ESMA2LBLPMn4Nh2rJ1Hhp/QWCqJZRcq+URaJbb/RfdJVH7XZtsupgv/MxA+sAOMPK+r0W+I13Hoe9rD3eZczynZXMmby9XnkC1FeOgt22
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(366004)(136003)(346002)(451199021)(107886003)(6512007)(6506007)(26005)(1076003)(4326008)(41300700001)(316002)(2616005)(83380400001)(86362001)(186003)(6666004)(52116002)(6486002)(478600001)(36756003)(110136005)(8676002)(5660300002)(8936002)(2906002)(66946007)(66476007)(66556008)(38100700002)(38350700002)(54906003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vK9jERyw53STwZ8FpTiROtWW5BD9Wrl7BRgjgWEfo8aBOIvyXf51bW++mJFN?=
 =?us-ascii?Q?kpSAWWsX4T2AMnOqw6V69FV1n4pi1TPPWj/VFwrzEJpOoxOAN/+t/BH4v1JQ?=
 =?us-ascii?Q?Ul2utJGLvGXId3qIOxGoLfheLseSbvcsYA3PLnw4GLPZ9a/bZWNlvrOl2Vxf?=
 =?us-ascii?Q?BF2qLVgLnQEtBWwuH8vux1WGoPWqNa9Fi8MgMLvQfFWd163XclNJejgY3Q4r?=
 =?us-ascii?Q?ARzTRer8odZWxvUuc94QE61bEQ72o40pquP6ebABX+JJ2rTifSSWyYHhzEwM?=
 =?us-ascii?Q?CmHNB+BpAmy02dqE7VnMSD5psbx+tk0EoMlqxiSw2p6PJCtmV2NLqrUT5+JP?=
 =?us-ascii?Q?0AhPM3HbWU3XepG7KPmDX9fKMtOA0OkY1kh8C6KqaEX7vlGI549PjZuuZVoT?=
 =?us-ascii?Q?v70fbKND3+g0HpqMcKCKpMoeoWXRRamX2+PYlGxrCJmmkis4/gYUYg5uAe6J?=
 =?us-ascii?Q?Oc1BtM1RPwWIGq8I2zQhBwZT0eD0f7WO0qpNNsQJ8E3qedrKB8EHs+Vpwsne?=
 =?us-ascii?Q?BP5zL97Br60TwgUNEFBq29pEkzDYlOfQLCySc7b3Bjkd79EfaoH4cEdZI38/?=
 =?us-ascii?Q?52ZbzWD09QtrS/ORBMGRHwzPUhKCIzn399huQPMCRVE5nktXUWtrs03U/9DI?=
 =?us-ascii?Q?Odnsxn8UWTIz4lEdMXwHlMUlQlhH43C1s2NOJ/gca+nN9SSUg3Hu4WWyqz1K?=
 =?us-ascii?Q?Y58HRp3D9HN8NdMJLzc2dIuhaYkOSea+yG3QeVo82XkOstx0ELll2LONxYjQ?=
 =?us-ascii?Q?EASWa49ekrNSlFPR0tXT1HRAmHzDwwzv/wUtKHNO4W8LWdZtydxZeJLqlTiZ?=
 =?us-ascii?Q?fTv0C0JOQsV2sh38ytFWVftFHkdHykBsAFB4C4h31d3frVQdbf+8iDvr51vz?=
 =?us-ascii?Q?aHwl3z2Fb6UcoOHAPbkA+rkViLMjD+Kw3t23SUnPQz0TrF24o2473pR3DpXZ?=
 =?us-ascii?Q?1c0fslQc+pC8ZZAngCV0puVfowtb2uap919IxYZ3Napyan72qbPolFACesww?=
 =?us-ascii?Q?VBC/gceKUxnyYiCWXSeCpQzOCBk8Q1oQYPioTYKfC8PpySVBvbtAC5o1iS3e?=
 =?us-ascii?Q?CmMpJz82+hjHHhzAF8fq7u/atjxwiE7+epll59T6m/skm73GuxEv+yr9OYJE?=
 =?us-ascii?Q?dzdcOpdecHeB91yD2D6BNfxG4iiFpaC4W4qw1+0GbtweVaAD61xjWKVEr7Gl?=
 =?us-ascii?Q?6rb5sm3gB5NpsIpzX0zOy6g/EeIqxkgH1povyzUaHvR0+IByaQFNqChOqhyM?=
 =?us-ascii?Q?mtOauQ5ierDu62PlxUs+Ea3x16Ya9vwi2ewgQJHPcGHve3BMaFs6GcmKID15?=
 =?us-ascii?Q?fEt9XhRDlTlZrqhHLc+GTGnAIM2Nxc1AnDVSystazm3rxyFZv9nQv6JcXoMs?=
 =?us-ascii?Q?D2X1YlrgYpU82zcv2BMLseV56yIYTfdYGC9JNkA3RnDPHmkX+ZcBjgOVWoHY?=
 =?us-ascii?Q?NoaAHw+ankE00rbTQrVknqfDFcXXMuGByQR2S4Qtoco8RiagzNqUJiwwz/Pq?=
 =?us-ascii?Q?zgnLl7NLekaKXt98oeIKoOGeucbwusr3TS462CBnAfo+C743gVGKCe7A1xzq?=
 =?us-ascii?Q?hF1jCtGQz0CKwM7tLikqSrZwugyhZBZc4IbmWtptsoljRP+vLOhNqrRxqypd?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3407c69-b13d-4837-8d93-08db41a7d85e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:02:14.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLCvDrskvDmsLfOjda3xB/eGSFv1VgnyXwfgIxK+SMX/a36FEtdPQicEM4YMbrWklmljS7kfUXD6J3ppj+/TQsrzeRS2PA5LHhc159YscVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5021
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

There are two pointers in struct xfrm_dev_offload, *dev, *real_dev.
The *dev points whether bonding interface or real interface, if
bonding IPsec offload is used, it points bonding interface; if not,
it points real interface. And *real_dev always points real interface.
So nfp should always use real_dev instead of dev.

Prior to this change the system becomes unresponsive when offloading
IPsec for a device which is a lower device to a bonding device.

Fixes: 859a497fe80c ("nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer")
CC: stable@vger.kernel.org
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index c0dcce8ae437..b1f026b81dea 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -269,7 +269,7 @@ static void set_sha2_512hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
 static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 				  struct netlink_ext_ack *extack)
 {
-	struct net_device *netdev = x->xso.dev;
+	struct net_device *netdev = x->xso.real_dev;
 	struct nfp_ipsec_cfg_mssg msg = {};
 	int i, key_len, trunc_len, err = 0;
 	struct nfp_ipsec_cfg_add_sa *cfg;
@@ -513,7 +513,7 @@ static void nfp_net_xfrm_del_state(struct xfrm_state *x)
 		.cmd = NFP_IPSEC_CFG_MSSG_INV_SA,
 		.sa_idx = x->xso.offload_handle - 1,
 	};
-	struct net_device *netdev = x->xso.dev;
+	struct net_device *netdev = x->xso.real_dev;
 	struct nfp_net *nn;
 	int err;
 
-- 
2.34.1

