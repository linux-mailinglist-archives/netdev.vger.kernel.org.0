Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988CE6D6732
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbjDDPYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjDDPYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:24:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A68449C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 08:24:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnTvvXoV/rcaDX+zCU5aF1WA3M+51lcIPtX33hCR4Ny+9tSC5QQAnbjVDzifh/AOrLPtdZ1jzxJCqeBD86zkLoT+KWpRDdwupL90DIzWxZ+85VJKP3qCS0Kdl4fjsEl1UlC+UTMam4/31GyUL9VGj1nDm7b0xTsXV0BNGba9NQLHO8rOnDK/02SCYQDlrjBX57Z96NHHsdQ2wbGQNrbf8y7yG94/8th7rbkV6W3TQGGgXzlf6WPmOmbdsIrLu0h2lfMgw5fYyAkrt0hPiP6wt56Gj8YZBwBfVY3BS1eOSWgaDNKUmNnqloPWbtDq8mQsEiplOViY4giRpUMJ5RGsjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ei4CpC9BAUyOHcWqWZ05FdJTnRVYJ9TUB1moVDzeGfY=;
 b=Px3iVpdEbWorSUr47MgFQoMBDuF4x8C5deYUq8UkLMUmSQqsp7pOSx5M6qwVkwp0ihPSxYfKCorriNe6mMNk/wahUpQM5Vt4Db9bCp4r91UDx0Pr8YB1CfReEZN7xiVthTSQgtyofyueAevdqBOD+fAj+gGUXqEO5tJqNZgDCLaXq9Dt8h9F33KIIdIXDyDBFE8oKDMkNRUfgHMouyZXhPvTjpYrQcoDCP+A8v4uJ3g2DHD8SR4T2FkihrfL2HM2r5V9695eJMBdEyyQigRNjuaKJsxRqrOHJBaP/djP8gTEU8JmobWdktye98uO8+gUHU70gvTnT/ZNsFVD+Rm54g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ei4CpC9BAUyOHcWqWZ05FdJTnRVYJ9TUB1moVDzeGfY=;
 b=kALLySsBuznV4FUEHcfgea4s+tbM2l7IxaF/CsaBc3sxHky7kZTEjvA3dh08K4J0jo9EMp15Ga3z1JaHsDDclOqgtFLKRM4kyud+Z1xAxxKwkEHsXwGmJJKjV/jgsxoiav/FaTKelz0TiA4EDY/BfS5n0Eav/IGm270HV56NNNU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5886.namprd13.prod.outlook.com (2603:10b6:303:1b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Tue, 4 Apr
 2023 15:24:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:24:27 +0000
Date:   Tue, 4 Apr 2023 17:24:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        imx@lists.linux.dev
Subject: Re: [PATCH v6 1/2] net: stmmac: add support for platform specific
 reset
Message-ID: <ZCxBIW2dyLbndT9v@corigine.com>
References: <20230403222302.328262-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403222302.328262-1-shenwei.wang@nxp.com>
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5886:EE_
X-MS-Office365-Filtering-Correlation-Id: adf075d3-72ec-477d-9f71-08db3520adeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Su2P3NfCes1LCVLq9iY1aUI/f68Uqoq4bD42legOhh2HydjVbrMXBud8/STWhrcFobmxN3I5Ih+xBxTyaQgAAZY1/oGkKlSSIAxllC1jmCC+0nvYr+U5QDLa/rMt8k/Nrc+yHfvO4jRIryoosVN5piJPx6qR9h4HKMqZnDAIz+flSutkrUgeH4FaxDyAwxD5COmhiLoy0GbRY/R3PMoFUsVz4d1qIBu/7nFuQVS3695H7IpmrkXoLErFzAVbTsZaOkpv4cxgKTemSBYu5wUdKCBD4SGQT7AdwDXfaYWtGHAYMoHiDLvYeuBhpjTt4YGvaI2QIeP7Cvj62rObNgZrtR2Klejg8k2GKlm/HA2WI+yDO0sSC7vLBMNRux4nMB4F+sjGylKtuRud8sOL73lYp7P9Hqa3suLNnesTUs8i2NgVZeORIFiX10+Ss8rKkF3sF9PyhgbNJcOYxvPve7INgubCj7KgdgHriyXOq+I/hEsAflDUYIQkflfoAYu+gEDonwXUKA4MpUv1ygMGAMEorWRakaOxtGjjO2OtrC8pUh5iawsHJ5NRI9K1JEMJeOOp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(376002)(136003)(346002)(451199021)(7416002)(36756003)(38100700002)(66476007)(44832011)(8676002)(4326008)(66946007)(8936002)(66556008)(6916009)(5660300002)(41300700001)(2906002)(2616005)(86362001)(6486002)(6512007)(4744005)(316002)(6506007)(186003)(478600001)(6666004)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5D6Wp4oOROTI9eFquT4A4lanzA/kB3NYwLP70lrU8u/8wR9j4ltQ75mPfKje?=
 =?us-ascii?Q?3vJOF2FQkKn4AlIZPVJna80Fv5vxC1gXTZx/dyHYaJ7bdc8Xg68EHXaO1pT5?=
 =?us-ascii?Q?V8/rhT/2sksqHShUrrQegG3aCm6NHIXptZjyoO35tnKPR3fKIasAbgW22UeC?=
 =?us-ascii?Q?Az6wN6IQalLKRg/Qmjquk7YgdtAPTQlr5CC2cvmvMKCKVdTkiA9EiwYQ3f3n?=
 =?us-ascii?Q?gXSEJ+nXa4AfPtR0U9tbKP6gzj0GDCXgDqfeDUMKwfPm2FIs608cz7k1c+Xl?=
 =?us-ascii?Q?5aSY81TDATwZDQpaBsMww1shwTIXn6OQX2zDCr09eqydsjxTIXpaOg0nOL4l?=
 =?us-ascii?Q?WHPnuHn/cS2SvlRjQ9RimaCmZAVms7/IxANsv16fPZ9oGY3DvNT2+dDsvZwL?=
 =?us-ascii?Q?AgyAu+HAUpGKBHpNnyyIx8tlJqoE9XMITQLyVT2Ncju4H3b2lXnTr4tl3osS?=
 =?us-ascii?Q?zINoUZsa+HvG4MLOIxBc8uJG3GWPA9jUNMsF4VlnttZ7AxRspLI4Ag2dtqpK?=
 =?us-ascii?Q?FjsZX6zwhJPPw1OWt+MKfVrxVXzS2IyuW2wgADIGnELoCS7/Qr/7pOTB8s/Q?=
 =?us-ascii?Q?DtWZLAHkQxxPHYEdiD76Rfv9n7HxHNRVerw5JkVX8x0xg67Y/iMhhNSUdXmS?=
 =?us-ascii?Q?FfhRjasz2nrDrieHIhdJFv+jvGWlJhTOo7JwH6/r2UNbr8WU4unc3Y+yEF4O?=
 =?us-ascii?Q?abBk/rgcCYgKPPREyhNndFT37y6f9FeKENF3cJdbYrz/Ihrj4KGPr7Gzk5zp?=
 =?us-ascii?Q?E4qFclmV9Max30I1Su5H+io7NuM8DGDC/Ceix1DqS8S1LzRx6hBGH4QNGUyj?=
 =?us-ascii?Q?7l/j2vsnwGJjH4f/NGVhFJAP17kgd0A1GnKPSeIssLwLtZnzJjzI6wZ1JOYT?=
 =?us-ascii?Q?syrCnUTsXBj5vGyzdUbmAfpNeEhyD2QOqTgF7PjQw6K3e9YURnC7OTfE+hAv?=
 =?us-ascii?Q?dtA/8PogNL32tUFDewnX/8qAK750yQwYl1ejdc1hi8dbomGvJDs4RSLHJE3f?=
 =?us-ascii?Q?jD/kOwR5Kp2gBif3O27xAds891uA28FwykRWm4SyRV6khjJSgg0bbMnYsD8U?=
 =?us-ascii?Q?qTQz5DbxRooQf8albzAc83k8M9kVJsEQYnmBO4PkmLbqLYnztHQ4N0yWqEEs?=
 =?us-ascii?Q?aHkPfq5yyqoSgLWfwSt9L+iUCxcU8K75cWhqUfUnLOPPAG1qOoJc0Tkyxn++?=
 =?us-ascii?Q?s+OgEfd6tXtVP0IIS2PGsE6hcBK7yawcMqo/2jLg5oVD7QbVX3jpNkqvb28k?=
 =?us-ascii?Q?VVB/n9vtlmBQ+3ZFC64yQVV8DGG4L69GxF6bOF9fvfxJY2w5THj5zYQHa0pY?=
 =?us-ascii?Q?SZNw1JNRZPj5TeVekwLPpLam7eOhIiEFo326stzDvl0D+Q1jUrsd1CJx5Smf?=
 =?us-ascii?Q?diZGTJTdc3joLm0V/klFAYXM3vpmB9BXJnGm6BbbVpbfcEqEWS9N0O07tlhx?=
 =?us-ascii?Q?BANGPDbDZUVZSvNW8CUANGQRAJ9qyGeAmeRNFrd5+4fl6KaDtsU2N4fQ3r/F?=
 =?us-ascii?Q?uwdQWgmYOCd2q8ouDm+h5AfHtncITeScWGstfhXW366gJhSx45xQ0uLWINv9?=
 =?us-ascii?Q?efv31LOIY9J4kMdd7GA/V7QOaWcshQqswxklD3niIc7mud5IA/ZH7ErRux7u?=
 =?us-ascii?Q?YjtKeVSj3N8e/3BnQmbP9L1hPp1rPAuE3iPRlt9s0eGNsS/DGaheFXHUpWM2?=
 =?us-ascii?Q?SjG9eQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf075d3-72ec-477d-9f71-08db3520adeb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 15:24:27.8073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pq9lB2HhdhVQZ6Bai5uq/91ublLAcfFTmwCLgFzurg8LPU7pEjg1mVSLoj1voNPHfCrNPjmr8K1306JY6at5VVzBIuOm8nnp8NkEkw9JEbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5886
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 05:23:01PM -0500, Shenwei Wang wrote:
> This patch adds support for platform-specific reset logic in the
> stmmac driver. Some SoCs require a different reset mechanism than
> the standard dwmac IP reset. To support these platforms, a new function
> pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
> The stmmac_reset in hwif.h is modified to call the 'fix_soc_reset'
> function if it exists. This enables the driver to use the platform-specific
> reset logic when necessary.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

