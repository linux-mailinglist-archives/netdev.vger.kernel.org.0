Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0D26C4FBB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCVPxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjCVPxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:53:07 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2100.outbound.protection.outlook.com [40.107.101.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438E31115A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:53:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azIu0uYMu9Kh5L2dAap/sPyE+EvysT1zVcpXKxVlQuovacVqrE+8r4rS19zH49t32hSZ5X05F9rp6ajiX/q8mFZ3JKBLy0THhmPvg+FyHFVw5jJakpsG4kTMEy39nx160XQrPJLy1HrBg2QpsF3JKESI4lg+fNIGVCQP6STz73ln0sJ0zURSqIpNksxEZ+cq4naN9C6/nuHPyhW1LZfSkPk12pnCYLlyfJbutkTAORBv4NQ3YwluaiVMlPddcPGL4iC5MuZcFwBvRddRW9d1MfHU/kiIsUlwyn/Hoh5QA60EanC6fkVMwZrPQ3+3H5utSRgL0ODgzjBb6g0h1VWOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGCsWQTsmIOVY2fI1mgkh7n0Cge9qvjhm+Oc6nhJ/EI=;
 b=lIxesSbyE+9mECM7h0o8/d16Xh+OEuajqnQetX76kwXJjJVhAkyHbf0Qi1pBqDM9DFFo/QtvhB2rn1Mjgh7Q90cGx83FhfVOQeFC9F9wVMMLfKiwYV1vnrFJLqrXnTnoVmr5LUSdC9hTrr1MsYCEMqsWw/jLZ5igMJxaf3pQRaqaGe0Jbgc4tKuB6YD6rI3/x2dcsYeYgYeFSai/qMGMEN38p8iIr+khR3qcgvRxpFQKbAiH64rQvbWoilB3mF6xY4YdruVOmqblhYmao5Ng0/HE2XrcCoV5Jb3NheFImShtvbbzkH/F9rq+5iYiF8dLGNvVDnO/+FAbjPYAGRZ0Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGCsWQTsmIOVY2fI1mgkh7n0Cge9qvjhm+Oc6nhJ/EI=;
 b=kDYXkKmym8qxP5CJ5IpcRYuYT3MxkSaa4I5kapfKjg7yPUpJ4al3cSroMEIiRyWq//7ZJAlrRiEiRclSSuhBtlYHgwkE9fmWqpoS0qZfsmywdDeuVsE+4sgOcNfj4UcXeh4801hRL26FoI4eQ0SWtU1hEMZF4rQxlOK/K97tGog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB5048.namprd13.prod.outlook.com (2603:10b6:303:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 15:53:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 15:53:04 +0000
Date:   Wed, 22 Mar 2023 16:52:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZBskWuzEMp1HvILu@corigine.com>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM9P250CA0019.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: bcbb3d66-d2ad-481a-349f-08db2aed85aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +VA4Vt4uaVByewov9NTPYQPhPeDk4J/1zL3HjCVIQn7rsbpOvuqGL+eNddu8ZfB2q8fh3/hd96ucok30fMJMNr0C8jM936oHYXW3GpH26gP4CMP1cPWBHDm85WRMaCr3dK+0zXBWZlccrECvwDdGylj/OkNYOCgTi3H56TYJpdNem+40tZLpSpsaIGDwKtW8Vur1l8aWYk4O5GGLIqASKeauLmAFO+c5iGES/K6XzSl0GlvBVTgx+BDA/dyTiiE4vYMgSZUGnKchBKOzZ9dixcjPIMDdthPtoiWrxivoUFoWhwQD1zVVjyZI4li8qLvtmAb2L6Cu3C05LRp8K75S4lQefHb8Z7TLkkjx1KPZMfua9IDBirm8ne5WbCQUpsl8SEfzAAOaH7OBWdcJzQ+qidKHNDgE7O7Dng2y66QmI6eZgm8JLmQJB8RNl2qLPGthK58zaSLkQpN2CfdWPBMyYVYeQYHujyBLhbqT6LXcHOde2R+PkNAKKWRMxWJZ7Qm8XN2kEE+hHMFvIKkKWY+qtm6MNFHbXo8XlCBnLWwhV33Mf6kKa1JREoW/V/PVbKP5Jvo19V7Hbpq53osN84rU6HXLq8uwH5kIHh3O1nigS5dhfPzK6Hc7innbpUz7zQICMHprZ5/EvplXK8KMbwD4qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(376002)(39840400004)(451199018)(2616005)(6512007)(41300700001)(186003)(6486002)(4326008)(83380400001)(478600001)(6666004)(316002)(8676002)(66946007)(66556008)(66476007)(6506007)(54906003)(44832011)(8936002)(4744005)(5660300002)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BCdzDM7BecyOT/EKnPPNdwBSC/ywimCZ8lhf/L9Ji00oF6nroKV32Xl4lroO?=
 =?us-ascii?Q?KBvCSS66CJ/uS6ZnLm47Hvj9gf6xnOrNhbYk75UlrJsIWfxsaSVi90IlGCVd?=
 =?us-ascii?Q?21KqWnKvJK/4qbuL0+R8haATSV3UZYNJ7KUaoU3uSfNBCb5nFBsCTVFZASOz?=
 =?us-ascii?Q?/l7MmUzkTfZ9NVVyQSr/zziJySTVY7gQi0Ec+TuDZ3fkZ14/BwhsixQRVKMG?=
 =?us-ascii?Q?y9QN4cbAJ9WFiO0PpctFeko1fRPG3Rc6MX8wz2qsNQMiqaRT/QwnkyqktlVA?=
 =?us-ascii?Q?3I0b4DPq2a0lrswM8g8D5+uxo5hidcsWT7SAXjoS/NnZBe5Ni4rpIeMQJqjv?=
 =?us-ascii?Q?fUpmdtyuarKuL+kCHcuigor1jGVVM3ToXSf/kDnSgFgRNx9YrRwJYeW8tceW?=
 =?us-ascii?Q?jjVpc40vPHX3Kr3tVSlBrcTL4ESon/vC9lHhdGdrKSQRzDCl2TBBVryyPwkr?=
 =?us-ascii?Q?hkaGTytept0bx9DlJg4mvggPLsR4fFGtzSgz/9L04uFIGn3MReQrmVKuBVCf?=
 =?us-ascii?Q?4/HN6dIQXL6QYx0RD53qT+PwbvKOV9QP5AIJB3V9O5id2pQEjblxioSrh/Np?=
 =?us-ascii?Q?7isI5lY7Mbs8Eug9XVYSRGNLzIHYUi+Vc0uKm7z8jTRJvOL8FTgEcJH74XBm?=
 =?us-ascii?Q?2nsmWJMABKR7V6sZh4nNnxEPlDulKI2e1xT8Qj8dfRkH211L12azeKuORflz?=
 =?us-ascii?Q?fjRaw7fH9gxrRZ8pAScww5+gEIDtKNaaAzoM+lcXwy+OZaCMAhxC7JLOTRQT?=
 =?us-ascii?Q?OEkxklVTqc9GCwQvN0ZEMeVDjg0gsBzJDCihMH2UGCr6yvbdbEXLpNbkf8Tf?=
 =?us-ascii?Q?uFrBMLehyZDu6cuKIHj6A37vahwuf1EiiEUwWeEUG9Kzpr0vh9AbSh0DVfLs?=
 =?us-ascii?Q?1fIMKUDba2c8YsBqBVyE3K9lRx1ITQSqg1mBfPNzKSMy8R++Pq4WOCYBau8g?=
 =?us-ascii?Q?58oD8X8CnAXbEprm6RX7MSnQ3Ej418Itd2yZddZFp6645FVa58mKSKaeP+Po?=
 =?us-ascii?Q?vGLaZq7ZMbkQ/VmA1GIi1UyRNLMABR2wbZHhpyuI3TjEiELWDy6GoBq0XghK?=
 =?us-ascii?Q?8jv1V70EAyEeUk0OkzM/gJLr7nU8C69TSA4SJJ3mCu5bm1D1RzXNkEDaIkx7?=
 =?us-ascii?Q?2CilM6INxi37VrVlQtDgTokON4SEbgmMEjIJcqB8rpzYRHvWQAPPH+TcmeIw?=
 =?us-ascii?Q?7bZolmvxIAl5XMDIGQxP1Z2zlqUbMnuhNJtO8O9m+ZX9tRpr51GHC6g7oRom?=
 =?us-ascii?Q?PCsGazoEajI8dkd8eVK3PIXYtIocpPcfoEIu4VfkNEGdVjpch5dkJIlLECD8?=
 =?us-ascii?Q?GiGlfO7RRJvGMcALg4TK/b4+SQzlanBR/sXpquZ+X1PCAzulikAgIQVtVJH5?=
 =?us-ascii?Q?z9owPyVgHFsRAI8uBsUMHzDcjzWBN/VehPKY0my61G2oDWceOJDRZgM/qVPY?=
 =?us-ascii?Q?rWaAnJxVIGuJ9sah+Q4mxPDJACu/YcshNl1gT1f8J8wOvKE+ajqhPuZBUg3p?=
 =?us-ascii?Q?ShTxsfLjiZxP6K5j6yxHEAsl/KClLtIrpnlwqlSvQaUus0ZkxAtBoROYUfqd?=
 =?us-ascii?Q?PdxY6kvbviZOvUzflJIkd09SUIvNz1biE5yZYDLeiLQ+naGEANxTSMXbH5IV?=
 =?us-ascii?Q?3TyjPFxpkSPlvpl0C+Jz0CZS0iU6pNHDJaPBXM+UyXoDRfFzPXyzkGiFWPRm?=
 =?us-ascii?Q?baDrMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcbb3d66-d2ad-481a-349f-08db2aed85aa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 15:53:04.3071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLhEXeZ694d0T4fNiUieHXHQwsg/MigjZULZkX4uEqswL8C7NftjKGpm5QSAbvYuehL681W1qOntihEdFsYf1ixl8SMCPNqwBRo5k+pHmuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5048
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wrote:
> Add a quirk for a copper SFP that identifies itself as "OEM"
> "SFP-2.5G-T". This module's PHY is inaccessible, and can only run
> at 2500base-X with the host without negotiation. Add a quirk to
> enable the 2500base-X interface mode with 2500base-T support, and
> disable autonegotiation.
> 
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

