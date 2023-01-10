Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD48866409F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbjAJMgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbjAJMgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:36:31 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C8167E6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:36:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X57Hl0Tmx6Mn0nOG5C1ftD6Mce9izHz33tg3U0qry/hr2t3X6yncXrHDqUXUIDcmVuBBP1VH7lumaBIY43WwR5t7xnxepOCqdhGodEGzrsAKMbv0sVA31LmtBK+0Tkhgmb4RMXr0rcJVNxDvHZJD2eJNIF5SkMoqatLhnZqCFVk81zC3Y0XNlscHPr+AVvgUt/ju0ZPA2bbJizm0Q3YVxbaFxJF97tnt+YxTe/sU15oH6nGa9epPIAJsuc4rjO9ixK2KTkW0krKsWdaq4eahWP/mOq/jN1YeTwu/gjNlWevwZdPigIZnQ3Yl78KVZ6/gV0PvTe7fbvxq8Ilbt3RNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XboUjGxehPv4lq2TKwK5Mbkhorn8Mc9YkRXfQ5AErhk=;
 b=NL5LXKgiCXB72sqdiw+SSEWazdQaT7zzFtAX62oZvCLe2qy+nFccAFDYgMs9m/ks/VOShYqAXh+TfLulL1BJ8KSV/liqga2IrRpKa2hPOTDPTyGtasKwOAv5vWWS1lgmysyRyQ7TEss6ZwTLT5c5s+mDxRt+1mOP/wjrWRd8c4HAL2CZnITiv1KDa+E9G1SFgILdSVKuDjVQcD7HSi4ZwUx1UKKMTx5ticFfBLQdqnAmMvNkELmBM2DBHhXLG67KDc77xsQmNbWIHatXgei0VZumNn00N7EYwjD6CJHQBT81RQG2M/peFYyqdQ4wo6B67g8ZDMzIS1aROIQXSodPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XboUjGxehPv4lq2TKwK5Mbkhorn8Mc9YkRXfQ5AErhk=;
 b=gnAN5AUgSgGUJ5O6wUpbqiTK9HC8jl6hLl01NB3GwhJ0yZrIW+/OEy/ma1pVqMfvmUzRqEOOEaXFaDZ+OxX02X5C2x9eiJqyi+S/VbDN9+hdjbSYyNWqifRXed/QVSv0N6i8HmA9Kr0VPu00GF7hQ6NwtTqfGHfeXN2oK2wQtt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5609.namprd13.prod.outlook.com (2603:10b6:806:230::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 12:35:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 12:35:59 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/2] nfp: add DCB IEEE support
Date:   Tue, 10 Jan 2023 13:35:40 +0100
Message-Id: <20230110123542.46924-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: d880648d-46d5-47ed-72a3-08daf30739e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJq2ST8INfrbddJFNtE3ixnllbowB9+diS727W2IMpTRdZaW57I6zQv2v+PX9PZbz1CotptoOClq8IthTwbnKinwCmKCGtNML86CZ3nwO4QT38yasBC/sKgYZSQZU9SJRKCPK/JTRuMQiyvbGoHFdjlZWpYEtayEwPSvZqXXOp5nPT/vcffv5XubfTKS2rV9jeUOem8HLVnv9ZnPNH81QOG/JrcdyHGyB9lQ6rKrsY9e8WXdfX60hVlppUg4Sor68P/9AqkjoFvvsmJoU/e1Si4TKFe1mtdYRsh+x3h+oHPyoPPhjIIeO6ap2b6OiTADnhAzBSaPTEqIK4YHEYiGkbGQ+RJ4szjSLVEJ6wqQMkb5NOJO396gCFjRHW0jpSikHFsZfMO4uAcXAKsjRAzphUSgREcg4HJYQoepzacw7UY5pEp8TsZhehGrQAwTyA52+4EBmtO3TIpVUGC6CsqY7EpyjtJVqkhpnsalYW8xWk6BrbAc/p+JzaTW6Pdd9Qt42ogZ1+tHG6NkB/fNELRhufJ3NPesm5enAP66s0URAh2I6BtEIuAllKTvkf/YcCQdF3eEqgCC4FMNR2DqvsV546iukTexSzUYoXc6Q6UWxRyFpccb1nwE9mry6Warwl8Ao3CzDNDikLoRhDYTHHlj8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(376002)(366004)(346002)(136003)(396003)(451199015)(8676002)(66476007)(66946007)(66556008)(316002)(52116002)(4326008)(110136005)(54906003)(44832011)(4744005)(2906002)(5660300002)(8936002)(41300700001)(36756003)(83380400001)(107886003)(6666004)(478600001)(6486002)(6506007)(1076003)(2616005)(38100700002)(6512007)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6UfE1AtkiB/O22XbO7YYjUlnFvfP1DTkSS742FXRLNffBJA1/vbiNBKRKIg?=
 =?us-ascii?Q?w4g3Fm0QCo+QFVqiEEcFLaD4LBB3JERV9qC4lHWFnlfjlAICxOjT/B7iRCtl?=
 =?us-ascii?Q?WUlhIC6IvWbOkXvgP5F2535AxIh3kasz64ecFnGBfJmx5t0XqfEoZrxYKTl4?=
 =?us-ascii?Q?NijK8Br2o77mK/xqbr9lodjOcc/uvxcbtSOY7KlHILqBdD9JtlftxlVadwXz?=
 =?us-ascii?Q?xNugWXH43GKE+osi66n5nHq/ipbCn76is7iXvC+YGsNek5for0XMxfF99C+m?=
 =?us-ascii?Q?HPYgKYp2fhXVHuMcSTgAn4kDqxhx+qnQGOHXrcKadQoMjO+RpeRd5uH+EMI7?=
 =?us-ascii?Q?IlIni0LPNFepmVUNHja75dawxy7V+V02HvgcPDlqaNfehlIBfLmw2pRqC/i3?=
 =?us-ascii?Q?PtFbSHpXEDlft6EeuLQXSlzvUPw2pm5WBZiiPcwG+Ps7ubUwcM/42PjjeZnC?=
 =?us-ascii?Q?pPWU1cCS2M8t88BARUyqIAo2m3QOV2m54ZaQ5mbIutwJKgG9kmATcDkqBdUm?=
 =?us-ascii?Q?n0/rIi+YIh10uPmE+6slXp0FBFEfGCqN+t6IA5XMF0Iob5jsfYNwVpi/hoWo?=
 =?us-ascii?Q?pCmHr+GSNOHlkzdfh+4ERKRAPk3I6OkJUpMkhVDEzy3v4QbafpD6LTrMmsNz?=
 =?us-ascii?Q?7TU6SyYbx2Ulj25WOSo0iljeWDrP6+P99i6l8zFX1ijR0bqgv7JKXhInvXGV?=
 =?us-ascii?Q?VlUuLqdFoGRHeq99YnwzJTspB/vXiZKtgsiUn/PNvsMXp2pjyedcfUoSkRGV?=
 =?us-ascii?Q?Bp/5oeo5ot+YiQlN7YH4/j3PDNJS7oC07omt/QgPnPN/2sJHrO4VNQZrnyxV?=
 =?us-ascii?Q?zlu+jGxC8D01XyuTRFZ8OLRNMJxhnGTlueWgkDMXY5/pUEEHSU6xmc9sFjwH?=
 =?us-ascii?Q?F+nHi+UNbKHF/vfS9oK8y/vlLbx0Rqyo5Ec9JWSIe6DKc5zEUjhXpDlTZPdm?=
 =?us-ascii?Q?aBOJOKjekaqW8mcIFn7c/6kHXN0ddxFuMaD0UKxGAE/kv1jommjreRX+oC5r?=
 =?us-ascii?Q?i1aZAbWUOmy5dmzi+KIm9OxB4HOae5gHLX5QDHfSz/F7OhrIoIGFClGnkvbP?=
 =?us-ascii?Q?X/QvBjB0kIaIOO5nt3ivqaA9HJe/WWi9PW61B0gf0auB7MSs34XtQStazAVX?=
 =?us-ascii?Q?UxjiXcMn1QQZ1npDJC4TeWcsmwdWZjCcMNgAPDsjv9ZwAeIsfjln+wB/CrfW?=
 =?us-ascii?Q?fY4Id0Mjh5xe/NOPCgkjbI6myEdAPcTvWuFZyBEdJVkgIKzt7IwOlvEaSxkY?=
 =?us-ascii?Q?RQlzrqcjgoCpf81SNBZPA31ZpSUn5zmW6lUwa1h250aPnVHXfN4KthSyOa4J?=
 =?us-ascii?Q?x8wHF2bbMbuT6kRRYIuOFRAE7iNAbCjs9waTKL+ddz7+o0zNsdzEK9PpLdFA?=
 =?us-ascii?Q?L6jDt88pG9mjqGogmsm4Vh5/Ujo6R+V6woJW5b1rHWO1myxU/Xk9bABWeB2A?=
 =?us-ascii?Q?808RTotB6vhosc1O0Qovo/Cz4wFIBoKdqxj8dRZZvAzv+JZIEJhTjVt+/GXV?=
 =?us-ascii?Q?cEv1rR8ogUgYU5WVg5+ntz7NkNZ95Xt/Z7OQvUcc2BifLiir2uSwuMJs7eyP?=
 =?us-ascii?Q?82voZ4DtpKHpsdlUmzFo6tfwuXTI2fYzZxywdZorl7XXxLvRNeNhD9x879pe?=
 =?us-ascii?Q?efSkoGWzSgtci7B6SXNkj7UsueRvuejBRPkpwPPZts5CfJT04IQRJIbyLVLw?=
 =?us-ascii?Q?K6p5RQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d880648d-46d5-47ed-72a3-08daf30739e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 12:35:59.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T12fcGNgEiZ2RTLi00Q1V+cEpbilOFBnCug5t3ro4lStoWK7fB2brkt4BXCv+AzIcibNkmZRZfU+VVUwxcb75wx98lC1dogeeF7MMD26t6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series adds basic DCB support, including ETS, to the NFP driver.

Patch 1/1: Add stub implementation of relevant callbacks.
Patch 2/2: Fill-out implementation of callbacks.

Bin Chen (1):
  nfp: add DCB IEEE configuration process

Xingfeng Hu (1):
  nfp: Add stub implementation of DCB IEEE callbacks

 drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
 drivers/net/ethernet/netronome/nfp/bpf/main.c |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 +
 drivers/net/ethernet/netronome/nfp/nic/dcb.c  | 572 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nic/main.c |  39 +-
 drivers/net/ethernet/netronome/nfp/nic/main.h |  46 ++
 6 files changed, 659 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/dcb.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/main.h

-- 
2.30.2

