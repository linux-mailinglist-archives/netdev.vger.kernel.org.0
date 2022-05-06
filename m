Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07D51D11A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389377AbiEFGRf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 May 2022 02:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiEFGRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:17:34 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.109.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB8D965D1C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 23:13:51 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2109.outbound.protection.outlook.com [104.47.22.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-35-yH2fLuCYMFKi9dFf5kszLw-1; Fri, 06 May 2022 08:13:48 +0200
X-MC-Unique: yH2fLuCYMFKi9dFf5kszLw-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0007.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:22::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Fri, 6 May 2022 06:13:47 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 06:13:47 +0000
Date:   Fri, 6 May 2022 08:13:45 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: Fix race condition on link status change
Message-ID: <20220506061345.GA325851@francesco-nb.int.toradex.com>
References: <20220506060815.327382-1-francesco.dolcini@toradex.com>
In-Reply-To: <20220506060815.327382-1-francesco.dolcini@toradex.com>
X-ClientProxiedBy: MRXP264CA0012.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::24) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e43436cd-bf8a-442d-b763-08da2f2794ad
X-MS-TrafficTypeDiagnostic: GVAP278MB0007:EE_
X-Microsoft-Antispam-PRVS: <GVAP278MB000728533AD1692E952B94F5E2C59@GVAP278MB0007.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: i5K3jU2m6w+Z7OEQ8NXbJqKL8a7Ui2b2XncgizTzTHJZms5WlJoICgwz/bDZ+OnvEDsj+lyTZUmDcFCG+9bQ2X9Yf4KrVS1EpcCDLQh54MPO1sYTnZnGYkjurdtK/BcsXDm8PGh2HzpUGoT4i3Y0gu/we17QqW7N3SAOygLcgesrW16F4RtTVxqsaOr6TZkZPaoAzfL5yth8X7zHOMcHWjRFzDB23Ahec9hWQpvrfRwIRaxp5KXzz7g5oUux7o2gyJRajQKYNl0axfpWycCVExSB+WPdeqqxE0GVrlBCfr1mfsujf0MaO72XGjxwSYvHRSwchnIvoGbQAA/Blf8eqXXuIPcaAdYW5oRCqM+CRxR4tvZewVXxogSFK0DxMheOZRzdgeaxsehvGBetFao/ZeirFEjeQ8V4AkfH/pvDP8bxIQK801dpLAtOiWdwNRPArbvLBGPa8yzQ+wpN2Oq56SF8zqwb5vWDXpjLepPRbzWj4Y8AjYquUPuuZ59hXeZMnRHGz8Fym5kV5jvon1MQXNlswRhGmj84dcGUmaS9Eb86cAV3iGhxhV0gPJsdDGxGp1Pc8IWDn1i9Er44rjXYMJONVFYhsdnAlCrwXYdyKz2GEpLBlccxgJdodjMExJZjNw9ER/EKdTun/WcwX9ObhyNPiWIm1jVvdpz6IywhIMNPSZmreyglC5PGKRNIi+FXn3we2EqHlg5nZ7kuiqQ9I/1SbbBtQZf44fm8kP0yOOyKcZMxwaVSptdBvwZRI89bQMNzHL2qmWrcgAz4aECDr3DKEwBi2C9Mqq9YfeDz8vE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(376002)(136003)(366004)(396003)(39850400004)(66946007)(38350700002)(38100700002)(54906003)(8936002)(4326008)(66556008)(110136005)(66476007)(8676002)(186003)(4744005)(2906002)(86362001)(316002)(33656002)(6486002)(7416002)(26005)(1076003)(44832011)(52116002)(6512007)(6506007)(508600001)(83380400001)(5660300002)(966005);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cFT9CswsYeTL2wdcAM4DE+u0N2Ia1F6qg6cxI35HFbupIR7TQs41a8uZ+iHU?=
 =?us-ascii?Q?N34vxIzVfMwEzY8efpwwSh7JgVzsdRGTwaNl5+gKN7clusDQ1rIfdLXmLWU/?=
 =?us-ascii?Q?FLU2OGvLEnElECNfr1VEZylQQazerGn3t/RLXqpq8NwFcMy2x7YTmbw4jFvd?=
 =?us-ascii?Q?KisQHMT9YFZlg0z1IDp4Qw/n1t8pfjEXow4M0rMiRm9a0D4Yz1qDPJfKHyzh?=
 =?us-ascii?Q?MFJTa/YE5pHEnHnDVzSrIcU8lVkxSpsa2vgg7znM5AO3qk//pOZIoQGJouCs?=
 =?us-ascii?Q?CC4r74hmBvar3uQboe42GAquuYWBXvYN1FyvzimRfaGglIpVHyPWHwwETVrl?=
 =?us-ascii?Q?U231gOzoXxQVWqN8pEZVVuRNWkrLPn9cZ8gTsv3W6EOFwy69AUd7bu/hk39A?=
 =?us-ascii?Q?AtlYCOwAsv7j1plkNdPbhJKh9IF9aOmAkmWvYOWkEHs512fH2kM3TjOGIfmP?=
 =?us-ascii?Q?n3jDMPHp3dlLBCnJHJ3JItsDuZ3WpLok6aV4u3vDXfUsQkHKbDy/vPlVhpHB?=
 =?us-ascii?Q?HAFg3UVTyUzuCwXaJmVkhcqwIltNdw7tq/9VGSwgS7oteJCDqqiBXlVVCtkC?=
 =?us-ascii?Q?OHBidKDbEeEfi2gEYUINcBk7uJXJZqD7JMAmpXXLN4BfSIjrj1X2GnfxSrcr?=
 =?us-ascii?Q?TqP3fAzl0DuZOWHRAqpmAfQkICoeRJbxmF6e8ewpGZyP3amO3KM3fB2CzN8v?=
 =?us-ascii?Q?xhJk7scMOKFNzOIla9YQLc8XXxrvya0NROn1Ei3v51V8xvgsf2hdV6oBSxKg?=
 =?us-ascii?Q?q1BkiN2w7RolkJWmSQMX8eXNFLzxq35xZUd4e1Zp30+iEKJeGG8Qe1VTc9II?=
 =?us-ascii?Q?/Wv/ObKqBuIzLFMKybimgqXUvv695PBqoiR3IzrMW6C+Bv7M1WZtkdxrzin7?=
 =?us-ascii?Q?+4nTu9IQa+h4aWWubwpFII1Zmdxffk9nPqzc0QDaf1lC0a858DJLO2oEilVw?=
 =?us-ascii?Q?mRDkLd2MrwbZgkSIcbRx2N7C69cahfPyaTuC0md3xwYpmS7nZHlSH1KTr98t?=
 =?us-ascii?Q?7XsaL1f3lKQQMy6Bi+QYRY5ktEXw2w/YPKSIn3FhSQ3x7ran0Qrj+R17vfx1?=
 =?us-ascii?Q?WMPmL4g2Gvb+8fRt7FfT0Gkb6OwFelqNE5ResqVmAgQfeyrYSXdSRkHNUK+e?=
 =?us-ascii?Q?bxMdUmU0uVWct2YYoMNTZaH01Xu1+bbtbdX91vaWDeWWVOvui2HnsUiwykwe?=
 =?us-ascii?Q?TBZ6h5gT++jk6wYAt1S2weykCgNDthYH5xwE5430lkuFUEhH5mnG0h/B7gsl?=
 =?us-ascii?Q?2SDRZ4EZ805M/t3YD0Lq5cZRIZdqUFle+WC9ssIIsqeNl0dPU4c2AIHrvJg5?=
 =?us-ascii?Q?J4zrWo7LR90m8nNljqg1krn3QNwyCbcfB4OFdCxYRNRfADHVqjVHRzIgRb58?=
 =?us-ascii?Q?aMkIap61rKxxYV2xcuPeMVDQSNFMxptn39r4lH26tVqwk+X1K0lz4lfceqyZ?=
 =?us-ascii?Q?wYeZR/6cqvZigS0KJqeus8RJjxPdPCGBZz2vK9P56GpKNGfZ8tJPZU/phaBC?=
 =?us-ascii?Q?7j+2fn9fvk6J6DYKVNajFSz6AXraPwcEKA+zdCX3I7FhPRg67nJsiUv868c8?=
 =?us-ascii?Q?GSz31eKry8R08t8nPuMwoxes+t1OaMqOEAxU008JMBcCc48isJkbz4YUTR15?=
 =?us-ascii?Q?KymaERtMUiAR3suiQCMOWvYc89QQXwsUPQlur4H+YCLRCvOXJmwVHOSwzT8s?=
 =?us-ascii?Q?PAfwnfwQJ47f6MzSiaMc07S7M0/XcdICG6j6il+bAym8IUdMVokIrYGGh1DE?=
 =?us-ascii?Q?tYUZrhLz571TVBH+mYUgXiUtUK+XQAs=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e43436cd-bf8a-442d-b763-08da2f2794ad
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 06:13:47.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0DuBRg+Nlf42PvOvwQyTj9H8UeFKxq/9B0o+/v8lY4efXgJQ+hl5zpPywDpNDm3Q5eqKeTcjnKuJs0Lho6npNghFHhZpPF2KPiMLopkeQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0007
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 08:08:15AM +0200, Francesco Dolcini wrote:
> This fixes the following error caused by a race condition between
> phydev->adjust_link() and a MDIO transaction in the phy interrupt
> handler. The issue was reproduced with the ethernet FEC driver and a
> micrel KSZ9031 phy.
> 
...
> Fix this by acquiring the phydev lock in phy_interrupt().
> 
> Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
> Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

whoops, I forgot the changelog, sorry.

v2: Added fixes tag, corrected commit message formatting (tab vs space)

