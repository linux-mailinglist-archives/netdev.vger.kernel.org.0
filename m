Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B671614821
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKALDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiKALDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:03:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A3F193E5
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVzzs8EtfbXeFABLVUobv89qdugHG3PXQYTRTKq+HoZLIKUmpGXYZDErihAufFlF3tBQ4mWwWjBIPgPg+wUz20pRN+HVsMEJMeOhRqPcxpkdRsj48bF5w5sKyP84R/lZB2DqKWj4cr6I+FTVwegtKmXSDV697e+Mc2/YpnA9rvK8Z5etrvW85bRFHUFO456qRHztBZv4yNdDexzpo0OBCdXc+G2KjsgLHcCvQiA7KqccQZS+Ldbtmv6LwVzMNw/qgvtBsxMtO/JifzCwTeyHaK6lA3GqOLQydw7e8cmjsLgCjoi4yCEFBJbjmnhIANa0rH6ao3yWBCqVOyJnJYbSmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR8YpUtGfPAGDa95l/I9epdX/RfBdX+E/UYswJQ7hFI=;
 b=d4wvc2wWxMu2yb4ZGhBBo8dY5FE1GN6KUEq8bsrkgC//dDITUwbUBJgRWvETxEa5N+bSvMZviQuOwLaSmqDoG7dmNovxCnNgJfa93Vfec2J4A1VVKMRE355Fx0LKoy6umEvfNnewGVYKrQtPa/w8fLu6cE8ptVxYsxr/H5pYQ+3F/qrZgLe9DWRHVStd2klC87v69FgBjqvHYp8OQDJsbNHXVMaHNJuTxv/4G20RlUVlgTbPohRP4zTvDsEGSwNOLWHlOE4ctFlNQtYzPGGcS9HH9BbLYNSbcEKMzLJreghGbvkzMs07HZMLyrtTz+FgkqB/90n5/DzznR2jv8tJzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR8YpUtGfPAGDa95l/I9epdX/RfBdX+E/UYswJQ7hFI=;
 b=bQc8W2Zs0yXSPjzX2RCxXQWRxUVOeKKZxQz7nc3LmeYSVGOkMllLGOcxLtcrvbwVwM5bTp7YC5oLu6ULs77D+Tlwfyol37ZKfwYPYS+f7sOALnkMxU5KQq3CNN+nq7VHGnXLP5c0WItzxysbUu5ynV8mMuMYC/ilEdNo5f8vGS4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4578.namprd13.prod.outlook.com (2603:10b6:208:332::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.19; Tue, 1 Nov
 2022 11:03:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5791.017; Tue, 1 Nov 2022
 11:03:09 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v3 0/3] nfp: IPsec offload support
Date:   Tue,  1 Nov 2022 12:02:45 +0100
Message-Id: <20221101110248.423966-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0007.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: 3362b084-0124-4bc5-5bfc-08dabbf8a98f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1c3TL5n6chXyGHGf0UdT0gbLc93+qUcyvOamkedq2xMIibZD5K6GvTJiAqrtDD96jKU9fLxLy3/gOlpZxb8D1mSZvwEiSJ90OOvJ2j3JGVLPiuQoHXf8nNP2Eykj2gWuXvDejdHOm5OilDE66DlKXPWdEyCBrGOOss9e2UIYstt2j6ePzpBY1912Fic10xo6W1F98wtMEvoTMOfp9cbjQefRX6ECbZWrK2q2IbNAbE/kVjwQc1tUEeeDLY/LV8xHFLpMs4SK/hhyJ8HuwZr56FFUlMVrNVEQvHPd4kwnKntVuYYj5pv0y1iUyhayCoWtomwy2ehu5t2K+a9WL5a33atcgoaTiUfh4t87ZweR31UxR375G4V2wL++ncdFIz4Wilay2Ml0JKCBcOsm+ZD8BfpdJcujxZY1VpxZLreq0LM7baZLXL8eNr0qXJ3vErIzUf/fGrdVrrysN3PHH2435xwGh5Ay2ytS+YsnU7xZEaeW1kfxiiXVKGCu3sdVG/dWZuRJr+/51MMAZBIrG7/dvjThjLof4hdKVtn7dZ+wRt+iIj92+DRfb6kHfAOFRfKKnL7ASjaSVc7t6vjYgY9c4Sdnf1Gi91v1a4WeoVpKhOq+cBEWqmBGwJUorsDO8VGPjArDeJpmqD5NFeCCzIBurR68J5rzJSilUOp4Vd+i98RJWn3zA2wdIipGgH4q5efKHEqSPD0fPp6X+A0t+HdeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39830400003)(366004)(396003)(451199015)(41300700001)(2616005)(86362001)(83380400001)(38100700002)(6512007)(316002)(36756003)(5660300002)(6506007)(4326008)(8676002)(66946007)(52116002)(66556008)(66476007)(54906003)(2906002)(186003)(110136005)(6666004)(107886003)(6486002)(44832011)(478600001)(1076003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95AuIn80AIgNm72VYI4Ckj1yUEs33JdFaOlWOvRi/BGNiQLAoGxOiBNFPZ2K?=
 =?us-ascii?Q?njEXWkycJ4Jcxv4zIgyyfpV0FmAQ6ZEO/pcQSgWwwGm84d6Uj0m+KZkTqidO?=
 =?us-ascii?Q?my8EsbmTGsGDG/2kqexQBUZwYfCm21O68bPdRVWj4NGa/+Ofv00cuxyNr98L?=
 =?us-ascii?Q?yoZIrIJ6jy3/6XzFMc04PuBj8wiVnwX0FdNSB63rvno1cq80zgpadhFClG1q?=
 =?us-ascii?Q?J7ZHBZsNeCc4Q7y3xPM1AU0cgPYMkZU5ACI+urTLGu63GE05AKxFOSPP6YuR?=
 =?us-ascii?Q?kcVmbqKH4SvbyYCiheVf++lKgtQfFYZIT/1EBZcN1Vxc5IjIXsfZXDnbsVl7?=
 =?us-ascii?Q?h6/2X5RkiZns6h688joZYF4r9EhVuR5u5cYXsipL2c2e8f1DB1YAO+ag/XsC?=
 =?us-ascii?Q?8zghKBxklYgQn3rZoaRZS6GGFw0VXAN5Jx9QvbBQ9yKy+JgxSFRt9mWpspOp?=
 =?us-ascii?Q?cbT0+aXtDTlEoORCn5+b2v22gOPEdMgd7wUhhXDuHW2HaXxVyt+EJWpjhYzG?=
 =?us-ascii?Q?8Is4K+Nrg4tc9ugEXMkUYpP3zl00S82uX+UlnfdR51Ix+VNEYhUVvR7j4trF?=
 =?us-ascii?Q?0b6ZcoJSEXo51HSnxiDqPpJknfN8KuL1GYi7R58BNeDaqA5aKk37SeV00rWS?=
 =?us-ascii?Q?GsbE+gPRG6LsgKZUGbdGIje22MV9g8lkW4zhSuJShbksbr9aSZJZU9XPfvxp?=
 =?us-ascii?Q?PJ2QL52nukjZwmLaRws0MQpUU7FINkswTjQMXqSb1hkapVO9fqA3f+mmwwMS?=
 =?us-ascii?Q?TfAAKMNMxIP+ip66uP0am5GDfaI3jSFqLNBpG/Z24hXRjPaS3qK3sxk6aRPK?=
 =?us-ascii?Q?2mpQFsK7/9HDFqMhhEqwl1ofu0eLJNfFqHiMk+po3cUBd1vhCBnbx1qyZyQ7?=
 =?us-ascii?Q?giF3JzjZIsP6G/VKz6ZpXe+8eDWCUQq+tZzxz+oGn+GSRwuUN9mhjLzKgjmv?=
 =?us-ascii?Q?BhhunRB7sR9ri/dO7jLNyCWzUA65x/qL4xdRjGcuzsnDz1sKMQe1x1ssDvlL?=
 =?us-ascii?Q?eEChEfpnDScW8lDeJCZzzJl+GpuJItokZLimbqs7x5aRLZ5D6aSfFqJ+QnKb?=
 =?us-ascii?Q?z4n06SMO4jWIkcOTId/0MIUwLXYt7b/ridLTBGt5U5qU8eZ5EgaBr1gZCilS?=
 =?us-ascii?Q?zPRJHuDl3kk9lP1tR0nd5fSWJ+T/vwhpH5AS8cx/4qFy/61QRdIgYhUZobEL?=
 =?us-ascii?Q?5Kz7bz3akVKH5DWFzSlUHA7Xr7p+nYr1n3zJLDJZuZW0dzz4rPod7yXTAyoX?=
 =?us-ascii?Q?F8jFnQ26qFE9bYn6u8a8JehD+Pd3sTYHd1hD//IjI0wI6ciM95nO0T9qoJh9?=
 =?us-ascii?Q?yDcPEjYyHK0VmunirP2edeWxwwHyMV73h1WuaB3+IUe4SVREb5BPSNYh8s9g?=
 =?us-ascii?Q?3aSyFjfkuQ90cNx9ZIG91JqT7j3N61ogzs+ac2n1Uh6iCEJmfiXAKjK1dMSR?=
 =?us-ascii?Q?FotHOsicqqKmYMTktVtE8TUeRyvrr2Oi/m6TiRej4AB+zCSeYD29SXemaK/f?=
 =?us-ascii?Q?FMjylAHGGSVOAwx6E+W1t5u/WpdIbW/DSECqucQPigkM4ORPB+LAhwOnEdYd?=
 =?us-ascii?Q?BDGpN0h28cZABaiF80UEwi+pjyDyAJC4yT2KfEXgeWsJvsiAbRfz+AO+Mf3x?=
 =?us-ascii?Q?twL878gK05ZoLoKICSQIzdP1hnQgP7REOqhhOtxuyet4N1pvV86aND1rIU7z?=
 =?us-ascii?Q?V8SHgw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3362b084-0124-4bc5-5bfc-08dabbf8a98f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:03:09.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8gdefO5a6glF/m/BMiC+jo7SQsJcNuZnUNAXjj+7IzGrMtSPFs0hpI0uVqDtzU4ab8ocmrtCYuQBTx9ugS/vm0sCs1Bsac6lIBoMBKt3Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4578
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huanhuan Wang says:

this short series is support IPsec offload for the NFP driver.

It covers three enhancements:

1. Patches 1/3:
   - Extend the capability word and control word to to support
     new features.

2. Patch 2/3:
   - Add framework to support IPsec offloading for NFP driver,
     but IPsec offload control plane interface xfrm callbacks which
     interact with upper layer are not implemented in this patch.

3. Patch 3/3:
   - IPsec control plane interface xfrm callbacks are implemented
     in this patch.

Changes since v2
* OFFLOAD_HANDLE_ERROR macro and the associated code removed
* Unnecessary logging removed
* Hook function xdo_dev_state_free in struct xfrmdev_ops removed
* Use Xarray to maintain SA entries

Changes since v1
* Explicitly return failure when XFRM_STATE_ESN is set
* Fix the issue that AEAD algorithm is not correctly offloaded

Huanhuan Wang (2):
  nfp: add framework to support ipsec offloading
  nfp: implement xfrm callbacks and expose ipsec offload feature to
    upper layer

Yinjun Zhang (1):
  nfp: extend capability and control words

 drivers/net/ethernet/netronome/Kconfig        |  11 +
 drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  23 +
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 633 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  58 +-
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  18 +
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  11 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  10 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  22 +-
 10 files changed, 781 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

-- 
2.30.2

