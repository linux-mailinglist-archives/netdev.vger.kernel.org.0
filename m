Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FCF5F7612
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 11:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJGJVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 05:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJGJVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 05:21:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2107.outbound.protection.outlook.com [40.107.237.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C9BCA8BC
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 02:21:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfhoSYq+d+uLmfAhtvcSyLD3XbQeggu4l9mHsARWSaFQiIg18w/y2heFQM9Nc21BHLMqSCKWKjaNx2I6BZYnko2+fe28fTZrjdoikjs9pOjESLTVkQvV/ol8xlSO5XAoecojKu8qYlharZyd8CbdP2BshohqGWy2C/tmNT7tpNcXNKIbRWoAiJvAfKDZ2h2/P59m4upyF/o8UqXDVoF6ZHhG7WW3GZI0VS+OKc3HJG8jEAM9vB6HoKsPh5jWRrEWvrZ+iuO9+Xic3Qxz+Vvjju0Fi051THIc/zJimXZALlnUuvuL9yeIb/uLJ+k2jMf2xoyBEKKNI7NvbZJ7hUCsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srCJaIMZHd7AdzeXnHOB+gqgEaWRtXcj6RUR7PJzQ0c=;
 b=bv9TiQmNbmealLwwZqudz175Bfk3C+P61teT+2kZMY73D2HPWPuf629WNdSyFAyXvVMPXVJQxutMI+wlWwvqG1O4Tk3MDYkPMve2gjb+qI/0DgPlieBlu1UkUbpdiXaE+3uWzgnc1UE8GXmVRzNtafkjkSdIzJl0vLcb8feF3FopG9tJNeJOr0rBS9PnVks4/xfx7TMEiYrdGQxeyIO0LUlNCQZX1AJx5tVYHkP8SgfU70CWPUeJ7REQRQINssrVDl4nQagZSXOGgnJqH3qgHu8Hjxb/lUouKVppkCtyd7FJ9J+BP0TS7XAxQsrz1nAe6HKGfE339wXu0IfWUt7dSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srCJaIMZHd7AdzeXnHOB+gqgEaWRtXcj6RUR7PJzQ0c=;
 b=raJgLUteQ8Z8gQ/Kj3vmsZfmsnoMI5XwPI3F9KPOPmktqpQnC/IQIN8cBeY7zYyWlRoGOqVdnVellJLe0UeDgOC4jZLgoiUugTg1iU/r+JO4ZQGvEPQVPRftrgsavAUmo6aLTofabBwCSWriqlR5GB/SnGRJ/42s34RsdrZp6ao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5377.namprd13.prod.outlook.com (2603:10b6:510:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.8; Fri, 7 Oct
 2022 09:21:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b332:10af:929b:f19a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b332:10af:929b:f19a%5]) with mapi id 15.20.5709.010; Fri, 7 Oct 2022
 09:21:46 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Chaoyong He <chaoyong.he@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: flower: fix incorrect struct type in GRE key_size
Date:   Fri,  7 Oct 2022 11:21:32 +0200
Message-Id: <20221007092132.218386-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0111.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c700a2-0227-4f14-5317-08daa8455aec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOu89nNZjcBMNWPThnMc3Y4PfavrsH2V18Rdvc+GWqhkwiGMovzG2pXH+yxR6+k9Ty2/9hvODSb0seFOHLjPsonkJfM6M0CmvbrtPbuy/iY9uECkeAWAu8dRm0GvSfNvN9usRnaUvb77nulbafBGbvK/29e0w1SvcgX+JGhmRBxAb+Fwwvpx+404Uly+GZ3xJNcEmxjkaU4wGrwyi+tn9E1CFVNnLubh77US8+HjR6akvHKuMKDGU/itd6NDGcYdHK674bDpZsS8fBCSmiUWJ0MnoysahEKcXPZ53OvMKEk/9bk0zYim4aWeCSuJk/93FTFbrw+1+oIvOpy8pyU4vmdpZqzKD4NPYWxVz+8cTxfwjemRhMU24OxSwYIXkKMccPFT4QQPNFOEqnudXy0k0V620ucTMnviOog11mXHKbJQuoE1lQXweP6ag6j7daI6P8a12SNBflXbuQpt4H+Y0/UgwTeJ53TeKObpNMN0pbdRDM3mPu4/dGvY4T84DSay5ymqdwrGhRNPy8wKjL+eF5qotc79/aMjuBsLwHeWS3Kiy1WrF4Yt9DwYt5nI8UQYrg7izES6fwSaCJZWfBIi+zasmPgw5laJvTdmlAZHouz8eei13da99Oys6ECDoko+FFX/mjMWtUztTvxW8sE54ds98EaVI992djmeagdyft4TWoO4vNPHyA/69fLmpM+Vgztm5bYR4USwO6pXOOMhIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39830400003)(136003)(451199015)(41300700001)(44832011)(54906003)(110136005)(478600001)(86362001)(6486002)(107886003)(6666004)(36756003)(5660300002)(316002)(4326008)(66476007)(8936002)(8676002)(66946007)(66556008)(38100700002)(6512007)(2616005)(6506007)(52116002)(83380400001)(186003)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NONsGLEY4EZkov1+vNQiED6mi4QUQQs7sCanptxdayddVVOnjsM4wMqy4ptL?=
 =?us-ascii?Q?GceFInGVGFE2y2J66+5IsZ1mA1fn8aXE13Oov0maBA2RxK8TJOSSPXwye1tT?=
 =?us-ascii?Q?ew4uI5fE/L7WTicQ0TeujHBOS/nPu+eWe8PtaTZ9ZK/jbUWTo+PKLQo/SfAh?=
 =?us-ascii?Q?79yI3HjGSeKArNH/bCN+VlD0bbBVTq6MkYDfDtnXdePIfbg+27N/S+IMFyw0?=
 =?us-ascii?Q?WrfyYIMoojW3KDP1Hcy14g/D4B2HfTDVV6kbNoyvcy+dc8U5S65Sqy9Ey7rO?=
 =?us-ascii?Q?MejXxVrnGDipfWXv47uLdMhFwQX0GdxHsADlLd2NoPp1l19IdexHnLXBVpwB?=
 =?us-ascii?Q?fBxuOxqlNrK/S6sJjPnCsHauelrnx73Tb/8tlTC0eEsfPNXp3gtQDFd4MYWO?=
 =?us-ascii?Q?3xdDm4kxG5URb4HW2pb+Al4OB41FKwXVJaFIozB9wNGcNxSzntDm8ZHfAK3I?=
 =?us-ascii?Q?F2vVVbQr/+mKH9Znvno3GX8bGoBo8ty2F5KgC11r1rpgUx5ufw4eW8aQSudv?=
 =?us-ascii?Q?Dkz5bJGx4ZcTp2147b3oSdUJjqb42FrKpohv6BQVGkvecOaV4uGM810KmRMf?=
 =?us-ascii?Q?RNcLaDPcvuQO1eD3r7YQUTKwhulx9JtLCEeKd4fqxoVy4ObWmQHpUaKECYjm?=
 =?us-ascii?Q?pIpCmODmoF5dH3lBGtbBoBoPPdbfPbZRhh+DeQE2xq3iwc8sIYZwBczzVbNl?=
 =?us-ascii?Q?LCtI9ZU3Y8+JWjUoCTZbstJWyAtEffloOV4go58JozGTIr0yx+s5JG86vrZz?=
 =?us-ascii?Q?MlfbDUlNjY6sAjuvsuzWwgdRymviZzvKAX+5sMCzM1ls3igRdi7vwdoKMb4o?=
 =?us-ascii?Q?5DxMzgW2whV4kj3jXsbFDNoKxt78C6eCQA+pcfZxUE2moc83rQmjx/Ge5E+z?=
 =?us-ascii?Q?M8qyTKDgQLBlwu81m+bR/CL68PsvDBhvvD+9zLpagwiemz0nslAp9y4sq/9c?=
 =?us-ascii?Q?v0RQTZaj8yTdr2h8iBPaJ/jDscLaAuuqjbtjjs9e63TMWH0YsiYaqYj+b+ze?=
 =?us-ascii?Q?fXQN6uOFEqxcYxkZRfG6WwZqxUo+QyNAUDB3HzOhf/YvFdkAYBWlYyxF8/lX?=
 =?us-ascii?Q?Y8TOLblQEM1QwYzHZXZbghskjqh9qw9APp4CbwoBRJ+tvNFrmMlMyOlmTx9C?=
 =?us-ascii?Q?GA7dtA3ddUwLduzb+lxJ/aO/kpb1eFaL+e06FTKCVo3sPCu9B9wXQ4gGJu0H?=
 =?us-ascii?Q?yDDwhqESy1xVyi0AcYHiNEPqdCWDiqtPOArOBGyN+d0vtw6T/3LptWuiXMdu?=
 =?us-ascii?Q?edFH3ThWlafBB1219W+v4XOHlrC9ZrwkhlvdmqXLw2PpcGuYUcDYGTZcTVtN?=
 =?us-ascii?Q?EoEoMkpIMNLApTz01PGwUMeaHcmU4+QKz7CCCCpVoiZ1dRB8duX3IWJXNP0g?=
 =?us-ascii?Q?CYX180D9KOhy4o7iSxlNNOKKZjWMEUYkaGV3xFyy9i6JtB8dbL8+8XKd67GU?=
 =?us-ascii?Q?Rabgrb8Pp0AlpI86dPO5x/Qa6LFTFt0eO673k+56YKXQsQVqzrZ2m/xdKjCe?=
 =?us-ascii?Q?n0t8r0cOF5LXyr8GLT4dWFLtN6I537XS0t9ofOvkL+D071C9Dshgg5wh9eqx?=
 =?us-ascii?Q?U+7VH9ENQu/6UoACGiNvTefqIXWnwJznu2ows07gibs4Ps6Jg1goPM//ICnP?=
 =?us-ascii?Q?Ia00f6CRnYLxjcPoGmDBCan4bZdVDkBbuoz5t009jz67Afc6FJPU4fafv4t7?=
 =?us-ascii?Q?Gh6PUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c700a2-0227-4f14-5317-08daa8455aec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 09:21:46.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HI7wAUgPM5LcuO6Z+VW4eiE1fNaNuZX79PwkHPBDHm1bzZ0MThUhR/9D/N3CjbjBRXwCKI1aOZZ91Dvcz1/wDRkgZcqe6wJdXwiH4vujNTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5377
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Looks like a copy-paste error sneaked in here at some point,
causing the key_size for these tunnels to be calculated
incorrectly. This size ends up being send to the firmware,
causing unexpected behaviour in some cases.

Fixes: 78a722af4ad9 ("nfp: flower: compile match for IPv6 tunnels")
Reported-by: Chaoyong He <chaoyong.he@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 3ab3e4536b99..8593cafa6368 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -373,10 +373,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			if (ipv6_tun) {
 				key_layer_two |= NFP_FLOWER_LAYER2_TUN_IPV6;
 				key_size +=
-					sizeof(struct nfp_flower_ipv6_udp_tun);
+					sizeof(struct nfp_flower_ipv6_gre_tun);
 			} else {
 				key_size +=
-					sizeof(struct nfp_flower_ipv4_udp_tun);
+					sizeof(struct nfp_flower_ipv4_gre_tun);
 			}
 
 			if (enc_op.key) {
-- 
2.30.2

