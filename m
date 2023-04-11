Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7B56DD995
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjDKLkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjDKLku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:40:50 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2086.outbound.protection.outlook.com [40.107.6.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A440F9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqgnfH6AUE8hibA2RlXjlZxUpSwQwP7KGMB/7I6CvsdMWiIGjsf7Ef4PCR1+RWd7qcb5bDR15/FZxNeMMzuHD5h4o8myjzdGUH5enCPsgF+bXHXZQNGaPqX13IBWLWyqanprtmSyI5YBsMMCRyFGwG5G0nWyflA97u3qYaimqQsiJRZbCRCeWz95hjlzx80Q8MZZnWKDjs4ut29ni+NH50CEPxZNT5W76zsCMnWR64oWxUWiC8cUiSUUUnzJOmG1Z1jzc67C0NjIoQkL8YJgA26vFvTX53dl3ufFmQKfnM/970TCnAUTSGuhpMyncr1nX79Fgl5uJgPuDStZtnk2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1zTFOH3NdHJDG8IijR5zXbVxvdT991F7NhwEl/n/t4=;
 b=fcnkVRsBC/08Q0rjjN5JWuhO8/gGmFZktm/Lb0TcqoVzPQmj3e+aneNtXp83rFlvoY3T+OT9AEjTgbTkuaGEDhuT7Drm6cY9mV+CSKiVpH/MXh/LiM5DnUvlBacZ3ChOzVu8LXlPeENnSLBXa4SHOTGZfCFvNl3QhmP88OHg2SdLLq5aJk2AnJFHdZVFc4iCslFLm1X6niK5whGNtWgHLDVYBRKJ4LMV8ihjtfaRcY/uh5vlFMdCyuOmaxSvg+q4WYhrBJEllJF1UMqD36eqvRW8ny/0KffK+zoD6ou9iIqvhhnN4tTS7J0m64i+HFJGETMWReeKet/ByTKK5PtebQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1zTFOH3NdHJDG8IijR5zXbVxvdT991F7NhwEl/n/t4=;
 b=ILXstj5lj3SiVqnUMIqgZ7WHjkQYSF9PwdoiqV9sYWN4UQhepjlImhLicokS6D4PbukxBgcZb0QtBDmHfYTGM78o5nS/yqdRhC6fTW7hehc75Y8p0lpCaTr4SRtRE6GRUUI/p278ReZn+ukS+CezLledeInDP8jeXJ+tl0TReH4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8182.eurprd04.prod.outlook.com (2603:10a6:20b:3b2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 11:40:46 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Tue, 11 Apr 2023
 11:40:46 +0000
Date:   Tue, 11 Apr 2023 14:40:43 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM64: dts: freescale: ZII: Add missing phy-mode
Message-ID: <20230411114043.5egxx4gflwgrqhha@skbuf>
References: <20230408152801.2336041-1-andrew@lunn.ch>
 <20230408152801.2336041-4-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408152801.2336041-4-andrew@lunn.ch>
X-ClientProxiedBy: FR3P281CA0073.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8182:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb080c8-662c-49f8-0069-08db3a819723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QnRw/J/TNo+43FZmpTsnq1bhHUd/vjAkPUtFokFLWcPpqD6MRm3No1NA+5X293DiardWR5P/8dfcKNR6wegwUAt7dQnt+5zAf5MsB0IGnTLyEt2OF7rQjj3RqaexVUau0tXHuFdmfuCDtL76mlv0MO8NdkbcAT8AvT7lIb/wRGpi4Q8tQxA+n77roQgcJ7W5sbw2JfiAoTJ5DVd5Vn6MvrdT9VUzytg2ijXaPbztCN12TULdlWI2P5GB7aRgRr341sDLy7bm45i1x8zW69i3AKx30VHelcxbT2FSgiVbojFtUp2fqTDkXlVFsXO9vxJc/JKZNiMQEVs9eUKlCkfr2POQp2h/nknTZZq/+efm0LJOuLVeq0CrGkCMsrYs9DahSxaoY5rsaB/7q0ACKzh2cLAPor3lq62OUm8pgiLL2eRkJ1lgX6e8mnkbA0YeRMA2fngd6YAGq6xKthAJUzIUFQ9us+PwqY+pEevceNByX6IS/BNYNPhKEfiESzpvpMIfrT6W87hzyJCLdbDHtHkbgayy7o2iTQriXjfQSOV7sxZwSmLFGyscZBWHqNddLLp0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199021)(41300700001)(33716001)(38100700002)(186003)(54906003)(478600001)(6916009)(66476007)(66556008)(66946007)(4326008)(8676002)(316002)(2906002)(86362001)(6506007)(9686003)(1076003)(6512007)(26005)(6666004)(6486002)(5660300002)(8936002)(4744005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sBtFr6ofOtFXrJR4HQ56J3kg2q54BRNyZ7GuMhIutm0EWkQu92t+cPv8ZDBg?=
 =?us-ascii?Q?LYr43oFcOeLbCOStY6kelM4wl7e+wRlbZoYxXvuvj/Iv3F0qGPCbc+mAbbLo?=
 =?us-ascii?Q?8D653oA8f2xJSgpVGUxT1VodNLMKyBUQ9myna7+8hhXF/oDjBVDYMnuxn/3t?=
 =?us-ascii?Q?V1/7M61v5i89HoKoq/oGsbF6xkWCsFooHy22SPlVgn2oyDhQLBbOi7565P/K?=
 =?us-ascii?Q?389uSzDMFloO+Wl5aQGHVMJfuF93t9UqUkEYuaBqkkg1wwEwLbhcEASuDz7z?=
 =?us-ascii?Q?Jh8Y/s2bU8pp3LdZTI9eLTZM4aBGfkxhxvpzAJA7ukD5tldaR76E3cITTA/G?=
 =?us-ascii?Q?ZRUcXVLCgarZWXPoHeD1NXifK6uWZA2Umahe2uIstYN1eWdWFJysVs7H8brw?=
 =?us-ascii?Q?T4dB0hixGjon25EWIsNHXC08o+a9MvkIHGpXcYVQhJNWiSsdb8OBeSEJj8u1?=
 =?us-ascii?Q?H2BzvZnQyeZ/9LO0+cvHj7iTRBGhN6nZJvevmnZRrkOeCr4C3OfuqxC85n18?=
 =?us-ascii?Q?wkUXxoWG0KyiDm7tMsGvKpcFwP56BfDcmpXlWahQlyDkdB5BgaAJzsK0rPdX?=
 =?us-ascii?Q?8Fs4GHyWXecTmZG0ftYX4+Rz1db7MftAxd0VG7a26e81b+EZuVAa5cVlZy+e?=
 =?us-ascii?Q?5alABZ4tA0hxpl/xbrrYDOO1E0AOSZg2Kf/7AvzrTBsL1y4t3o5yfJha/Uyx?=
 =?us-ascii?Q?78Lspf142f4rInnVl4FvnF2JjBVEUcWXx5fA8EdxYISJHNjIduD5Yxm+UpZR?=
 =?us-ascii?Q?PxnZGXSviqVR/8NEIQsVJ/R3e7dwEZGnUSU4TlqjVb+xMOYFTe7sdO/H00Vs?=
 =?us-ascii?Q?lm8PNTkN8lBt+gDAL2vjzAZR4x4ONnsgWfj1To+8E17jfoOaMBHujdi3sGwL?=
 =?us-ascii?Q?/lujX6pfgQoWgWj/5RCHR9Si9MFaepGA3YclD8Qxax5IGx6HYoWhNEW5UeMO?=
 =?us-ascii?Q?Pl5PhJuM0luEGqfzDVOwHte5roThrz9cbIGGeTgJU8uGy2YeQ66O2J8Nfvck?=
 =?us-ascii?Q?lvWMquSZZxSuG3QNyHY20iFSmH6l6mxCaXn+1HeReLxc62qS1GIrjQdRaWX1?=
 =?us-ascii?Q?Jccv4er5iVDHZBO/U8PtIL8DMXe1oDYb5lm/9aXXzZNTH9zdLvLAliEmjDwV?=
 =?us-ascii?Q?/s/KfodLeoo14vKAEbZiw0D+aYzn2iSMSZ+FA16Nb7vH5//j7OBXGPoMvrSP?=
 =?us-ascii?Q?04nlaiGyR5GcsTvVZkKouRZqzeoFGtrCMkVAr34AMT40Bdd3LDMi+Z1RGg/b?=
 =?us-ascii?Q?r7vd3hDTgrOPIBm9T0rvvQivI+M8fefyVdEDlNX8oiOlwIcAQyDnp8BUicIJ?=
 =?us-ascii?Q?lfnvYPIdYB/pQ2Qh+eLpMaeuM74iHRZtXlZoeL12mQGmgvc2rTbG8WgRWseM?=
 =?us-ascii?Q?drWc0s+k+NZUsrvqS9FC7LGbfgtS1GUEnrWxWOd3i8Y9DWq7G5E4KsBPSVGV?=
 =?us-ascii?Q?b6igzA3D5nPU7MKobW3NUgE5EIkLfH99Uwo06g/IUJYLJSsxR9RyebYuRfI7?=
 =?us-ascii?Q?NOSdY5+Svqqs3PMHDfhpUn6esRutr+dc6zaP0wJ3VeU6mLo2uq38fVwvpEEx?=
 =?us-ascii?Q?gHGSt5M6nGiBVcTBj7mVZQ7Q8vR50w1OLemhTAEPuzTSyMTm8jXraE7fd/fN?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb080c8-662c-49f8-0069-08db3a819723
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:40:46.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vz/+8FNceRYK2hhwtvjExh+GS6u/dya5Fe+BjKV0pDBcIYLSjcyncXxcQGV94tBfgV1EGfjzmbfZP+lJgKSSYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8182
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 05:28:01PM +0200, Andrew Lunn wrote:
> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. The imx8mq Ethernet is being configured to RMII. Set
> the switch phy-mode based on this.
> 
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2: Use rev-rmii for the side 'playing PHY'
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
