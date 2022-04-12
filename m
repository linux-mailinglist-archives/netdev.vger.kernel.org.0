Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E7E4FDA01
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbiDLH7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 03:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353542AbiDLHZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 03:25:45 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2118.outbound.protection.outlook.com [40.107.215.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942334EA16;
        Tue, 12 Apr 2022 00:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bv0+1mBfm2OZkztbGrR/VmcCpV1qrHQNU+hynqgUSC9WY6O2hej9aDQ+aRyPF+rO9WJeoIbw02wfwFGfla755AFl+4tanyqup1VgFNDhgJ+fUlUEC5IJIJWWFGu3n1NZJpt4QxxXsJxgUDOwXSPeFZGcd1qVhRVBjaY9H9Ml6ftOO/R3onBu7qHj6q2VEXOyeQGeov/TYbi3TxfGAp9kqs2IXCy4jNdCY8Je5vQIsXmjITOl8hYFRvE1Nmu6GWDIhUdJ1F2NxHo7esnX6NUo9kwA5TrNLeJFyKP59Jn0DnqFZSLAxSl58D+4hZUCRwJwIpRgNSaFcs2aWtka/L0LRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+g52sBbc04l5E4ybAdIZXH1enNSTxVRcHBpTOuXgDs=;
 b=eVttQp6bKW2I6nZAm0UQYgDiWzXl6DnOKA4sV0dpqPZIkvnWWrfyMwNTfY1vifRwBMTIc4GuCQI3ng7VSTzPu/j4iEHVDW93UhuUagn0ZfSFpmkuRmjusg1glxqhNefyXqnahWDCdZkB0sHkUH+yYJxYVqJ9jZZ2wHP3Uitf3QXt2A/HVHC+bKL38z5YxaKKzWeVIj75o8QRfVyi636/DCh/5t4Wzd8+Ko96LdoahUshDoepnB4ENMKc456uJEJjyiWXljSlmI7NS2XBNTunZ+lZCTIkGaKi7D00RTRqDjy5kpwa51b83M9g+6NAc5gbTyf2c7zPQOsgkLslQ2K2aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+g52sBbc04l5E4ybAdIZXH1enNSTxVRcHBpTOuXgDs=;
 b=lbkp4V4FjlZoBA3nSFsJb1cRpt9of7lRcHsSmM/KFnUAgtO21JjEmezoV38DC6aFSAzuIJML+QijB0PBtHeIOl0Ss9GP+3j+IA3fjipP/GN2uZ1cqMnCRU17LpU5OJ3lK6dmR/AGm4G04PHQqtS5DhYRL4zSnChW9TjXjgqgU2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SI2PR06MB3899.apcprd06.prod.outlook.com (2603:1096:4:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:00:58 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::5aa:dfff:8ca7:ae33]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::5aa:dfff:8ca7:ae33%6]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 07:00:58 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        ceph-devel@vger.kernel.org (open list:CEPH COMMON CODE (LIBCEPH)),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com
Subject: [PATCH linux-next] net: ceph: use swap() macro instead of taking tmp variable
Date:   Tue, 12 Apr 2022 14:46:20 +0800
Message-Id: <20220412064940.14798-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0023.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::35) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 152d154b-0bce-46f5-56f5-08da1c523209
X-MS-TrafficTypeDiagnostic: SI2PR06MB3899:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB3899525BE3FBB905158A9D3BC7ED9@SI2PR06MB3899.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qq9TXb0d0y7UMr/AhjrMYdl0Tp8VGULiI402/2DCn8KFda8FG3+GlT0zW1o5Jn8q25fjcvLaFjLOIuGDP6o/LWnF2F/qoFUBX4xU1M0xDqyiNqXrnio07mQ72YNUfobkXEIFXW09qZ0kxTSufa6a3q9/dtKMreYFUBUiM4ZLp1pHrp+s2bY4SCOQGLwoJH8s+TyttNM6K49nUIr0Icp5edBDXTsKMaCOE5dD6eRi/Ck+TKvg8E10Jy8f3ftppxhcqnLTHspVqIP7CnlVbctb2Ctxd4FftSNpTFTCmj1mFDNus+i+figqPwa7FgsAxEFZeWv9INXDVbXRXwNL9ZdazD2ZiCNOs2aJjDxfKMm6NRZvwoKjqLzEshRoWxxmBtFfD28IDD+3YnOfiZ+CJ8CHj7NHNnLSoSDuzyl1TYS1JFm+CNMnfuBMFKV5BdyD/yqPOT8t9CbNYbednErY8f4s38yqX8gqvZnQykwInjI+1udgGCbxCI0CkoJHLWEozyIdo0qpEShHsXqiPG4/j3HhPP/HUxdntUxuylGnT78SEtheQdLA/XCDcKqiWEIhUoBUQ4FrbAD6BdcyeIOtufx22TCJDNDGcZi67Yg/L3rGHOWhq3O4oTtS2imqUnF5eyk3JJoh7Id3EU0XCnoxvA1Vw+rzecuPXWINTwnJNyLUEV7x1JEb1UwnrFbaJL6Kun/R1Y97oGv3lT5zExeeTM22/ZuIy3jBuBO11/tNHKBSzu4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(110136005)(316002)(4326008)(2616005)(186003)(66476007)(66556008)(38100700002)(26005)(36756003)(508600001)(2906002)(5660300002)(6486002)(8936002)(8676002)(66946007)(4744005)(7416002)(921005)(83380400001)(6506007)(52116002)(6512007)(6666004)(38350700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jL3AUBDTRJshR+uYGlrau9J7A4ufRcN82owIgDLJgYfmFdjTgk/gRzprs/pP?=
 =?us-ascii?Q?7PvhGpvHz6mAD1csS99tcusgW0c7cG9Qk+vfWhTRxnu7/BLOHrxRkUqs6LgI?=
 =?us-ascii?Q?ZrUmFjOVDAORZ5IXVE5XSoWraLCPUEqra9+harv60AcmjtbxewBNUiDrQtPi?=
 =?us-ascii?Q?JF4zsAN0CYVCGBVOerwkHbDiAtaZIrExYmU2ph2zyW79+OoiT6NU1CXnYr/G?=
 =?us-ascii?Q?wkkwfJMZAkH04HGXR8Xvxb8Qvj3TMaR/ZC8IfW+AFpJBfaDDFGL6bFA3xrq+?=
 =?us-ascii?Q?+QR+6JtLCOESvvCz/kwSMIwrunpoh1Ahgf5xJQZPcaFM5GE6icR6u73AXWPR?=
 =?us-ascii?Q?0HlqyFi6NPHqz9ZXk0tAEEACrLWkagTSqQJxzYzWtH1ZkjQztaqyEvTFOX8d?=
 =?us-ascii?Q?uBPilc5ZEig+2ha6ip3nCWj/HJ85T3Z+LR4sw+AuHFcPe161UvesAJ4ayg7d?=
 =?us-ascii?Q?vkFCZrsW8ZV3K2dJoSueiqm4HghTNpv0V6dmzh+DVWVFT3KOu1Ud5GLwZZTl?=
 =?us-ascii?Q?whicF5Oid0YObw0jIetH/0MhO8E8mOPy/3aBIxZ/SryIGOlyS0KhGGVOe8Xn?=
 =?us-ascii?Q?cuD7jj0FZU4ybCZKmtyU6gRXGHB1EVPWqzsOHKw0xqhvCofSi6we9VqxL/9E?=
 =?us-ascii?Q?i+m7uO045zRA3rtN7zR+xWW180GJYJ71kr2SamrJ3Fd/YH602TQ4mpBArWMP?=
 =?us-ascii?Q?NZTtx+2NXtudFzOAK/SnAYkwB+u4+n8usLLciwPN5lu5b8q0VxetNg/U3ZfC?=
 =?us-ascii?Q?upwsIEQe0bPcOwsKiz58JZ1Md+HlrukheaceUQzowUW3jYb2vDmSDza3G7za?=
 =?us-ascii?Q?Q9Hb9iAbm6hKFcHqgK1bvHxoLWnEWGdboGlcKm11SWNhztkAjix923qzLDkw?=
 =?us-ascii?Q?tODGMyjW+D4Sj8tFrsiY0NaZaIcDgTz1mRz0V2VOD1a3rutsqZx3u3I1UvGJ?=
 =?us-ascii?Q?WrNWIv7MZTfWdshnpqEEPz7+FtJZdVM3dABNkWDRWUnxQft1bM/KwUTbpGQ0?=
 =?us-ascii?Q?TitFnAI5ZxUkt9nsZjXYqqhBcujXYt1I0pnY+CnqvQzCKFEebf1AIevQCrxA?=
 =?us-ascii?Q?WyluZ8X6EU1JQ8p904GhN2oUxL9Y1+bSTEBRKlCUQ1aBZ18Pqe5FXW2cTbgd?=
 =?us-ascii?Q?TdG0Y0mkpP1XnIgTpbX4ExIiMxncTyyicItTmJT7fOxPwfvOObLTVoXuTaMd?=
 =?us-ascii?Q?/hiSUolVuIwfnehr2tSk8VZ0rIA3+x/ZqAScGUG3SmxCoNMfGHTdGXbJDNE8?=
 =?us-ascii?Q?47XQLBQcS1C8dcPhqMQa/TpnoVaKepnR5LJDyUIj0Xpn/s4hvS9nS5k/pqW+?=
 =?us-ascii?Q?JaMFL/1aqaojE3rHl2UsLS59QVC0mHClaJAQRTqAWj/sjHATWmE/Ma3MUVMn?=
 =?us-ascii?Q?8mnJR52o3Uo3wbwtPn8D/otaTTY6eFHvqU8ER0ZFoqMfki7OyGg9fAmsxvHS?=
 =?us-ascii?Q?Yij7IcpKsiE0CYYEmES5K/Wf51VeTi1I1TSNG2UsKCOb1WFq3o0oDXODRxNr?=
 =?us-ascii?Q?FRb0TYQLjDqY/SR51oTP5bllhMyU/4OoKON0gfv8SU+EUMoNcK7zHxAIG4De?=
 =?us-ascii?Q?mMmDfg1BGx6rXXAMBZjd4+fnBf3V57EhgIaF23iFTXDvfMc5RkmZcgF6XJMc?=
 =?us-ascii?Q?kjvIyP2MT4xOV9miVchyh5mXPARDjsYyAMWKeErrYWE+u8eoRNzQCe/MCDQU?=
 =?us-ascii?Q?ITLs6X4Ex//JD6wQBajbuv0DYnWQp5ldkn9F3W0SbwCrS9CC7HQo7I6ietPl?=
 =?us-ascii?Q?UiIEg/mydQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152d154b-0bce-46f5-56f5-08da1c523209
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:00:58.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cl7zVuVW+4+LJd04H82Vk4AcQatMUDVp9uU3n3zRytq7sHH5pZZMnkcyprxfiC8C0wlNOluijltpTzq1wliayQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB3899
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
net/ceph/crush/mapper.c:1077:8-9: WARNING opportunity for swap()

by using swap() for the swapping of variable values and drop
the tmp variable that is not needed any more.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 net/ceph/crush/mapper.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 7057f8db4f99..1daf95e17d67 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -906,7 +906,6 @@ int crush_do_rule(const struct crush_map *map,
 	int recurse_to_leaf;
 	int wsize = 0;
 	int osize;
-	int *tmp;
 	const struct crush_rule *rule;
 	__u32 step;
 	int i, j;
@@ -1073,9 +1072,7 @@ int crush_do_rule(const struct crush_map *map,
 				memcpy(o, c, osize*sizeof(*o));
 
 			/* swap o and w arrays */
-			tmp = o;
-			o = w;
-			w = tmp;
+			swap(o, w);
 			wsize = osize;
 			break;
 
-- 
2.20.1

