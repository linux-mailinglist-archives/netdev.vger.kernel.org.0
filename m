Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA15EBFB3
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiI0K1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiI0K1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:27:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2121.outbound.protection.outlook.com [40.107.92.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37092C8896
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8PuSk9ZoyKktVOAuwwLDgDl1hBAon/iyHyaCVCxROiv0fEB5rJsgdbAwGHYWWTxABc2aIENDpPbZVTU8W0U2yfEb8XQJczCAILPRW+CnceBSGXtn/4DYg7Ut2q5AvHhMABIr0EytIo2uXZMlP1VlXSgAXe5SLJRIeIsx9dUR5VaYZWpUJKrkyVno0BsK1P4o6dUJCeoYCpp3MUYjVPeNRHTW7X1ZOG1zEmTA9TAkgc+NqYwdclA6AT/6vw4vZYLCwEiKNQ4MhiicujEgMdd09xCaOvk66DTgocH+2YlTPQic0+abUD1nDuJ98VydayXdZcH5GLWtNNArLDLef3mSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oD1+od3eQseLCqxoFUYeElBvrvJS5qT8GsBJkK4HNI4=;
 b=HLKiOOuNTUw86GjVdGeSb8XfP7uiywB/XgDdF83MaoB5+mUVXntHMyZuzDensOrtOmbXiL+ZruQ83Xu0fyLk83Vrlk3gzVkjv6Nt8k/HK+u5l0hAEjG0MbetJshvsrTDedpiyexwBdXExnf0NCKIPdHyetrGAJ09sXftVEQJ5zLnBT5Hy5GdVyZen70ouijsAQEtveGgCnqDtbbinl2GY3ad65i/8BC74RJnazDC9NDq7XVp++/3j2yizlSwODnCkHVZz83/7PgsWwtYLaaq/RsMICU5h63euXf+QbpqI2PbN3Z3EY6mKODy03ud2GfG+/1Zq4fc3M5RqRf/4dH/AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oD1+od3eQseLCqxoFUYeElBvrvJS5qT8GsBJkK4HNI4=;
 b=JeLaXCgkDED+m8L9+maYlsd3fX8+vTtLB/xN8acURoHZBZVRo+OWrDisUCrBDjmWKMq6LPBK74zKrgbGlvxrrXRaa0Q0ecwp+cGjvhriAyG1dl/8YMGwD1KxsVubHC/ZsP069uKhH1AOf3k8Ma/8cb6Mz5mz75iNHCics7SL8tw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5489.namprd13.prod.outlook.com (2603:10b6:806:230::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Tue, 27 Sep
 2022 10:27:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Tue, 27 Sep 2022
 10:27:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Leon Romanovsky <leon@kernel.org>,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: [PATCH net-next v2 0/3] nfp: IPsec offload support
Date:   Tue, 27 Sep 2022 12:27:04 +0200
Message-Id: <20220927102707.479199-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0017.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5489:EE_
X-MS-Office365-Filtering-Correlation-Id: e31cbefa-afed-4735-8dc6-08daa072e072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v25F15C7enHhgCHegWo3T9o+qiiFwv0WYXwXEAIS2P89sl+APMveSrKMbq1kRwn/8v17P1Ydz2TLhkMYCPnnw00TNOxA+v9zgRB+UQht4KQZUCxnb8fxFJGk8exnVXFBqsQPN7ALmNA9KFtzMLV21tvX3Agb8591eA3g7LZD5U9GA4tbSPwt9wITUi6cq/y68qkMTNBw6fpv2jaTD93jWoUoGBAPo7rJStulwZuhHG47JDaFD6Mx9QmpiLDho73DZ5VO8JIcPmeTXAw099CXX2KeM5dF4o1+jlo8JTNkpZiilC48tAcM5U9ajSeB76yU32zuOrwyVf5QhEyKLdk648eKkuS7Oun3fqg96dePkLGSm1L6PwNsJYW8BW8b18Pd8Au/VI5WxLKt/KDFz3V50/1FBYf6gYkInRdDwdyX29tu2AKF3b8hiwK3ZwRYbBgmqcATyQtVDIKDsMqVEX0pBe1VN6JJ6zNZxZ0KJbEHcIVETH4thSas3CM2z8X1l8W47viFF+HKpRrHuVTt2JH9ss5AaPPFNHmkrim/xgJMhuQdj7Oq+Ny+dWqrBQ6dg7yzYaQkFsIGuddKmjjO/7OJD8TtBKLhFm+eJbuvbvx0aRiWnjOrli4T+3dMj5sZx69TudmIWwDBEswafB+Cys76hTIYej3n6/3Hw3eRDj+o2Fbaie5DxqFNCHlVFj7f92v1R3gPAOJiN6+jhtBohrNkPJfyPfUwu5z7LHMxUp8B1AvEL2WsIFul+UzmXPw9KUWC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(396003)(136003)(366004)(376002)(346002)(451199015)(110136005)(54906003)(6486002)(478600001)(316002)(6666004)(66946007)(66476007)(4326008)(107886003)(66556008)(52116002)(8936002)(5660300002)(41300700001)(8676002)(6506007)(44832011)(2906002)(6512007)(36756003)(186003)(1076003)(2616005)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Rmj7EeTRW9esqA+Ar+eIiNR/UKdXAmRjXm5NxnFivoByyND0Vkv7/S03A27?=
 =?us-ascii?Q?VPZ/GwBqUgfrkEe4MMxTe4euIVNZ8BCgaGPJbzbWLudyLDbbjaG3HjC4ECPs?=
 =?us-ascii?Q?4Zljd/e1VCSuXBlW6u4NKFSPANXZyo2VRbPnt3tlcWj8AL2SFeWgCCNmv5z8?=
 =?us-ascii?Q?4w0PlsjFCjrY0BKlGRzPuaRvjjgUDIwJwl6uxSTexCT7hGiLYjfWPw/53S4i?=
 =?us-ascii?Q?GI+DtIPhAQKLp5+is5Y0FGSERAT6osBUjkEbNm2UjRBRzO2V/lCPoANGTL39?=
 =?us-ascii?Q?U6OJ5/k1hmAn2mFT6VE9N19Tv5BPLVWILOJZ5LhzMr5HmCOYKWRlJtTLwYY7?=
 =?us-ascii?Q?YpflBqNtvpfWCP+SZClpqigptN7I8QXJi7hM98n15yBaT3FjSFdeT+1t6C+n?=
 =?us-ascii?Q?1VTqf/v6ut9HUXP0CsWDQwOYbLgd0g+CyaWh2AmF7GQRCe9419g3P3Qt19Yi?=
 =?us-ascii?Q?2HLjEGG/IomJzK3aKRRcA3DQ6UTF7po/gDnkawYiGLt3m158p80rXh9bANjn?=
 =?us-ascii?Q?KIvOtnNqv5C9cCmlvozTUVdsh6spF2c9BtZr1SEjp3IGGQNwRNdMLTFJCXDR?=
 =?us-ascii?Q?j+qx5yyvCIxRBmG8V+JaVDQmwOoNRpJzua2S4sDVFBT9L9Sd/OpTeRblFFGk?=
 =?us-ascii?Q?ZAilucbWPsHr0VWMZTzQuIdn5JrXc6wn6s5EBjbe9JXITS0aS61ykb/pW0Fv?=
 =?us-ascii?Q?1+eXv8jAREmS+9nxpUJ2ApZ2MnU2I181qLST166sbTEodTb5AAO6ZugzQvPo?=
 =?us-ascii?Q?UAkTm0KzBrJBYSOSYZY/AXl6BcgUyuAksCH1iqHMeDXnLa07jxF6NAPCXTYF?=
 =?us-ascii?Q?YwU3K3iGzekr20hON6PXj1SgJHHpRuRSj1iG1zVEy3DjAq73ZhT1e21+X0PR?=
 =?us-ascii?Q?DQoE3Vu3sU0mTXVedEbjHBKaJ3D7fn8HXqAO0KSxiRhjXb21yXdyzOJMrYrw?=
 =?us-ascii?Q?KF+0cyTNkJWEegK+sJqZqr7LTv6w2L2nHLMPgvRzTu0MBuH1Nhs3feL584ck?=
 =?us-ascii?Q?pA9fg0rghtn/DpzDbFBx5sfVk11Y4G8DNPk9iNo36x2C+86YNNLivS04pkfH?=
 =?us-ascii?Q?dBmmKtnCLyKpm4ilRaJUjQHM7rntqWvi5e4uTGrCu/OGh8J8mq29P/ush0kE?=
 =?us-ascii?Q?A9QzGCV9UNA0Ljj4YM2B7prPll3Of8nugnFMs4af7YxOcZEFmvkJSaBrrwDq?=
 =?us-ascii?Q?F9S2OxcZJFdQxEEj4MKT2a64CSM9X8GtBZkWXW5twb9l0W0wnDEjRXGvKE0O?=
 =?us-ascii?Q?dRoEndXbRFRdbhFrucQLVwYtemfR1CnHAZbf5tzDtvn4kXwP3RYBxBwi9W4W?=
 =?us-ascii?Q?9ww4QAZ3MIFy/KD4bBCL4pQOtIiD+W4SVV6FrPABJDenh5mZ+hkLc2YJiZVB?=
 =?us-ascii?Q?kfYWlSKcMLhm2ktRDofj9mNfWli81hTLdmISuXnVcx1jm+m505EguD/YhQIV?=
 =?us-ascii?Q?oRJJyFshf7+OsO1+OyOyyzPvRJYx80E/Lf57EXlU8ZZPylgwm14+6oMPu8dn?=
 =?us-ascii?Q?0KxWyQh1x1kLeJ8rut+qn72PrxHEzw5ko6XPghI9ZaMfI52o4YhzVYtJ+dyk?=
 =?us-ascii?Q?jOLcSx1dNcZXWuowocVaCC5vLvMIJJ83B5zIBNx9jG45qJ6mY0jzBvv0fhXF?=
 =?us-ascii?Q?ZzFauROh077pP0MGi/NXABBAo+0yWJ+KgPKKYhpCCAfu5ZDLGRyK6y4ypc5u?=
 =?us-ascii?Q?jzIpgw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31cbefa-afed-4735-8dc6-08daa072e072
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 10:27:27.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ze0yEGeFxNR9VxFYVQvz7zTyOK3okQ7M11jil1srqSzamqbtWcsoXVcNy2Wo2/1/XzWCw5F/nDzNEueD2sCy3sRA6vJgt2p8o2QIXlRCASg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5489
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
 drivers/net/ethernet/netronome/nfp/Makefile   |   6 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  35 +
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 774 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  43 +-
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  19 +
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  11 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  17 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  22 +-
 10 files changed, 934 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

-- 
2.30.2

