Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B686C1585
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 15:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjCTOvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 10:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjCTOvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 10:51:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2105.outbound.protection.outlook.com [40.107.102.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B112F23306;
        Mon, 20 Mar 2023 07:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFvd5/JQr5kxVAQsuJgTcuHDfk0y7fywmPAM6sOWQ8+MZRsYyCgUK6fEw1rHTsN+YHD8Hei/GvTBswZ+MoJYKf0RimYxdPQ9S25qiJN/3JWgxjpSKguKoaoItSA8dkyc1wV7d9HDV34eVve3M5BfXgOWXFrniFsGD+6rUqgphzUGiPnwxAWSn3YA2s2j3q26x8HY/GeEmI6kY/wr3U9B+ofIdjZ8E2pZFn0hYswPzu1zB5hrxvib74BBt9/+ayonNZ1sSm5c3xS5ZgrVCY6n6DLpf+kt5Am/VRHUKJFoo4cR9SIc8eZOx5aXMQu3nYyFec4C0HkYgvxFnaT3JRLFAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTI0lhZAJhT4ABAj1Ym6fXQDXMtCv4+t2puhsH6BmWI=;
 b=F7RIYgjoTEU3lc34gWFFTDFUBt45tvbNcR0Gqk8KGdq7rn97HNAid6E6qSiszlnuEGPy4YZo31ttmlvqGl71FGfyvjzywtv+27M24qVaHI7mf5SubhteQ1nA98ktgFufo8rXjnLTmJnMk8b5UWK5M2nzoFzKZjy7UlSjtOFPmFrsYNhksJ3sUw0bRFH2cd5W41/0z9R+uigRe2PXxC7Hzg98PSoqhJBFeIVi1HJx1C2sv1Af8i7oO9WUXs1kZpyGWHiKfMKQP2mqoWfqEeG3soBCJ3uH0Fgyc1xNK5+picEWbd4HKvqf9HHd37YUb4NQFsYSQoO+iFrVt+Du+O0CJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTI0lhZAJhT4ABAj1Ym6fXQDXMtCv4+t2puhsH6BmWI=;
 b=lk9jfpe1+uNlqEVUjK0tmflAc7hh3q5qepzjZzBuC/SCikuJnuJpSPUQvKrE7UCP7GhFB8jp7SZ2MBJhyrLsmOAi+I54iCBYbG5Ic2eYm+Myd7nTrOh0eUbCY0I0CsP55ZeDrGA582geBWPPJK5Ec3RRCZTZxMz2k2tTOGRQ7mg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3685.namprd13.prod.outlook.com (2603:10b6:610:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:48:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:48:56 +0000
Date:   Mon, 20 Mar 2023 15:48:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
Subject: Re: [PATCHv5 net 1/2] net: asix: fix modprobe "sysfs: cannot create
 duplicate filename"
Message-ID: <ZBhySakjpQdq8Oro@corigine.com>
References: <20230317181321.3867173-1-grundler@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317181321.3867173-1-grundler@chromium.org>
X-ClientProxiedBy: AM0PR10CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3685:EE_
X-MS-Office365-Filtering-Correlation-Id: b440e6de-ce8a-4c15-6268-08db29523b11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMJChzJdM1ITvR7dLdy7VVQAEaPjULrCmBH3JLnsEUukd+5mwNjqENbyL1sSlbjzqKpHh7E35xuFPfRd4Q8grzkhNXxgVf1TekBnJ3ow2d8sQ/H3Gf/R0eaGxvgZFc25WbIWm7mlqNR1vBYx0f9RI7zme7NhsfJMWg7lIsrwsy4vF69ld6tr1VFShSYfXgys2dvDI7CoNYXgjrSxfL1pNrV1SM+SL3/fR9FaTVqD6qWunQPIRPF2fewISzKqDAifhBtdA5JjZzKHgn2AGWI3TLjUAEPVK7tszXQ+h4pKtqhjLc3d1zaXhzN7t72bawtPVCfwMxfz3X51ugqEwzPMDpl2QVDRJt6ZVBxhLWkKTlEQ6H0ibwEwKZV+4XUIKlz2EBnbmRyMyfBkHiCDII0gpWL8iqJcw7XbIxmupYFrgsRmjH2OdU9zIqNYk5wUSlhYwiF/D/H9LrMA3WYNkE/Uw22w+uFdZbBkiPOvfZLb8q5Fo8y9AkvRJKzd7W73XhHk49jPFQS7W1CWtBljf+NkMwbE4gOKkH6sLWQ8MUC++2utNvjfLBMwCTV+Zbgesre8TNYGc5Dmrn9dLOqMHGg0TNU7WYbmRvY1Ix/edonmRrZMRTiURbtqNx9k+xk3dKH95ebdBisfGEiimeEApRJTs0LT9DjijM0lsIdSEQL1iLo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(366004)(376002)(136003)(346002)(451199018)(2616005)(186003)(966005)(6486002)(4326008)(6666004)(478600001)(83380400001)(54906003)(316002)(66946007)(66476007)(6916009)(66556008)(6506007)(6512007)(8676002)(41300700001)(7416002)(8936002)(5660300002)(44832011)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQjdCQXm+zeuEeC6TtYkngAXfJk9I468OLv0bsXwfbP4L9CDqGX4kNhxHOGM?=
 =?us-ascii?Q?LvBC6MCxr0adgwDOaJOAwUZGwbXG/1l8HQi8vpfsJCy9drD+XVCCkx3C0IDF?=
 =?us-ascii?Q?7wqJhI/nrCewtnnDJ7qZ7FetPG9OIgRaKyNwvvutoo4ZBGLeFf2qAHd8kXi+?=
 =?us-ascii?Q?x8yAFrNvZe0avn3rP2fHICoartCN1fcFXJFvQWsNOjhrd//DpBEaQu62msuP?=
 =?us-ascii?Q?39D4g0gKh43OV2m3bxRinz0yZDgy66ip6Ca0wCiUs3V7E1gmruDiNZZU1Ftw?=
 =?us-ascii?Q?PsfO936XKtka4+rn8+A7cwBC2VWZayi9aaF1VLSOKXXSA8jj/KsKekAHeDEY?=
 =?us-ascii?Q?9pctTP0RvNUo3/8SYq6iHEo/YqAxIx1yV9D398uzLuGeCckRUlguCsVYs5bt?=
 =?us-ascii?Q?EWRl4C+WceeG5nb1+XEUaJt5kvvbddgljOadAosHI7/1dbfdNS4x6azgL/oM?=
 =?us-ascii?Q?WdfLjKMiKE1Mf1BR8ELrrLaTqEl9Czf2nNGoYwDdBzF8vzwyoS9qVvZBA2Ta?=
 =?us-ascii?Q?Ncf/iGzcZvqM/FQnav6MA4G3eal7lfxrBDZLM1F/tfnCwn1JOpTl41hK/PoD?=
 =?us-ascii?Q?gWN83hnNG2mx2DYW2mrZ+4X61amaJTuH76TbEuOQGfczcPUtncGTJPNVrrKX?=
 =?us-ascii?Q?MLrOdEzkzKWjfybTAey2BMRmuRVbtC/uDQF/WFRlQxMS+N9dG/tOk1o4CqZS?=
 =?us-ascii?Q?R9SgoFrM6tDi/QTCbxRvjfWFFCcev1zcOvdqM8j3QmXo59W1AhuGSwdinLha?=
 =?us-ascii?Q?KlrGCmmop9C5R9PArJ8IQmUY/LS/DkZWgELUMCTsEWPLZIoJddz5Ko4qD5bW?=
 =?us-ascii?Q?NVknMcCgNDUy8Fe1MdMH5VfEtM/MsDUjQR7beaFWcRdf7X6UeGsO7Gl8BnH9?=
 =?us-ascii?Q?MWLgaQLtjiXpFdMBx6eb28EvX6glSc1v7DnJt++a+V7K82gNH+03a6BrO3qq?=
 =?us-ascii?Q?VTR9WAFcpY2J+BO3MVwb4w7J8J1kZNQDxaL9Wccr1G2aTct3F9QBXnomKD/4?=
 =?us-ascii?Q?ehSmLjariu0nBMoFNdhAdP6AD0tdwqlpPWOSVGcg1zzbb3rmykiA9M7nu5u5?=
 =?us-ascii?Q?vBmMvQ+ToeZXgKlKwS69gL1irRUpR2z6eLD89mSzBOlpumyv5wkz2ULR31RM?=
 =?us-ascii?Q?H3STUPnhSPlfgtlzRm94+NIwwFcMY5+EcYLBer9lJsQt8iscSBOpZQMlD3Qh?=
 =?us-ascii?Q?yf+BNR3Regnc8bFpksHcuc3gXvyUAy2JMsdd0Zx7d4WMDFuIApYCzNdZAO9r?=
 =?us-ascii?Q?uaO8adSSeb7Co4IsPD2SIbkpvBHmJ8AYl9OsuZLFZqOVAzIfCmAYh1SsMq95?=
 =?us-ascii?Q?Vn/iFMRKYUjBU8l0EmnBkucp56BRruQIK1qxK9ZgfnyvAPrgFg8I0vERF8Iw?=
 =?us-ascii?Q?CYBsOHdQbZsvGsFD0RTRS1Q7HRPzqDQtbezHySJ+lqvimevAD57Jj8K7YAha?=
 =?us-ascii?Q?CSrIw/FGnGgRFoa+nXrl9/53mGDg5X6iyNu+O82zw9WAE0yJsg9QKVsh3uPR?=
 =?us-ascii?Q?xOO0dERG3Bsox2SjnT+sKri8tp8kw51yGcZ3vjj1BH3yAXvLazpX8y4VTtr4?=
 =?us-ascii?Q?GTysgW8n5uJgwpYJMElaoyLPiQK6wjPnwBGWuVR4D6Xiqr8JAfNDp5dYYChz?=
 =?us-ascii?Q?jwv5E/Ky5/Ovn10eVbzvZjv7j+jyBrVgd/qSBZF1wsepDBlVjwDhf3Dw/Wgy?=
 =?us-ascii?Q?uUgDOw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b440e6de-ce8a-4c15-6268-08db29523b11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 14:48:56.1871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AVsiTyoNRyydNOpZvZ8vpsJweDd1ocra7FVl2eXpF1HqRhv/LyrSGxt5NUDjNPsKNIBY/vPaI/ZLoQ5LkK9MROBO+98BStjEAImjzcg4qQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3685
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 11:13:21AM -0700, Grant Grundler wrote:
> "modprobe asix ; rmmod asix ; modprobe asix" fails with:
>    sysfs: cannot create duplicate filename \
>    	'/devices/virtual/mdio_bus/usb-003:004'
> 
> Issue was originally reported by Anton Lundin on 2022-06-22 (link below).
> 
> Chrome OS team hit the same issue in Feb, 2023 when trying to find
> work arounds for other issues with AX88172 devices.
> 
> The use of devm_mdiobus_register() with usbnet devices results in the
> MDIO data being associated with the USB device. When the asix driver
> is unloaded, the USB device continues to exist and the corresponding
> "mdiobus_unregister()" is NOT called until the USB device is unplugged
> or unauthorized. So the next "modprobe asix" will fail because the MDIO
> phy sysfs attributes still exist.
> 
> The 'easy' (from a design PoV) fix is to use the non-devm variants of
> mdiobus_* functions and explicitly manage this use in the asix_bind
> and asix_unbind function calls. I've not explored trying to fix usbnet
> initialization so devm_* stuff will work.
> 
> Fixes: e532a096be0e5 ("net: usb: asix: ax88772: add phylib support")
> Reported-by: Anton Lundin <glance@acc.umu.se>
> Link: https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/
> Tested-by: Eizan Miyamoto <eizan@chromium.org>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

