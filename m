Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C0268AFFA
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBENh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBENh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:37:29 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2134.outbound.protection.outlook.com [40.107.237.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2591C5A9;
        Sun,  5 Feb 2023 05:37:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+n+X0bQknqKZBek0EI0SQaCJXqAhmhu9biP0hhKeDzZ4o+fV2wVt5zjDk8S0L3xwJaivA7xFBkzDgxgduO+PBEjcFrhA/Zn4r9AZ/I/hzKXHFrHP7khmfIcEcQ0rg7FVwGx73fqcjLySfTSb6ISBDKB67Ha5kV6RqjByTo9Hm4OTpnuUCRIsZOOllPOzvqfURpFkVHgCCj8ZS9G15fs/gLm/ir45SIBBNHT1FXsMRux5nYxS0knjhKtMttve7qQEJDkqnW0ohxhclh42yhLhUSg2Z2S0pXnqyLscuj1PkR9aiMNxtPUKEc2bPT2Ua3OVw6YtDd70e9Vv1T/OkHgyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqahlbgXNtUJcFnODn+K23Ga2vatKUBkBToxzCcqYEc=;
 b=LLg+LllydSwVj+T96Kjv0jbpDXnE/Z+uTGkZbzAhRyPykHJYXzoVV/rXgoqSEWc0hEO/sZ29rGiYVVq0XDDVzhDThTWCuzYntsVoZGMjkPbReO3/tOPY5lOn2BSlp+5jxXAyTw/uckpJYzDGJg4k9wbnZuFnr+NBLpyjex+SxJXSq6AHtiV4DSwjouEkUrTA+eP8O8c/J44dJZyeUJTf7YW234eBx2aJbZ0xUjCCrxJvFUkYNh5xClyD6YhDl492xAG/9bvi3HpAPjqf3ZtQy+gyChfad675t992KxZQx81dKUpU1tz9PFjXcnrunjWtv1xsufO7dP2Y7zCo6nRrfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqahlbgXNtUJcFnODn+K23Ga2vatKUBkBToxzCcqYEc=;
 b=wP7TInoagsMiAJpEr4aypqy550c57GqqJLvnXo6PHcKmFmWliTWGwPuMXHgu4vLVAk36AHEeslNO6tjJ80XQrNm65gpOZguTd/3FUWcX+tzDoqVrFl1k1DREbDjIYHJmMl9JSWzgoLBm6T+h2fByZqXj6yj7E9jvH+nvMcuFSnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6114.namprd13.prod.outlook.com (2603:10b6:510:2bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sun, 5 Feb
 2023 13:37:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 13:37:23 +0000
Date:   Sun, 5 Feb 2023 14:37:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com
Subject: Re: [PATCH v2 1/4] wifi: rtw88: pci: Use enum type for
 rtw_hw_queue_mapping() and ac_to_hwq
Message-ID: <Y9+xDKZvQdNnbdxA@corigine.com>
References: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
 <20230204233001.1511643-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204233001.1511643-2-martin.blumenstingl@googlemail.com>
X-ClientProxiedBy: AM0PR10CA0031.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c346bd-e64f-41e3-b92e-08db077e1c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUhczW1P5D0rsX6ZdQiSAVIzI6KLHNKMeXVT3VTRSCwxsG9H+zvS4mL7GZpkWpIAPhE+lj13uIRHBoB0pWN5TyXEKKtfPYoR0PPro4K1kj6dVebNRICwD1SSiNvAZaE9gX83oHipCMBQ1EpJg8GKUeljfsyb+qXEOxtpVS9yM4gvYbS0JtgCuaO5yVLydMNGa7jMuMhHrALcXKUeW/5W78pFkqmfOfbtrJL+9b6fN6C666HfWdDwYlGvLUtl5y6zQKb84f2BFFq65jO6n8qXNeRj5nFsW92nKC6P8LH5eqz7jjnIE++9EGZ1HGGyQEQmE512svITBrZ2yoaYQx+TSUJiMSQSqxazjSdHwCeoU1F4MainXsLr2UYOEaX7t4DmtVSS0mdC8o8tfEPvV6VFZGg4yYefPUSEexO2juq6KEX7fCJlM4md8xVY9zAzBmq8mu6sR1/vfai2FAJ/DZYEFb0MtcHgrP0HvmrHD4+jcFjPJMYj2Fx32xYJ06KXXXq/Si9AkQ149KbVjab5jKwlP4H3Xdu2v2pbRJvUtHBECVY9rIzSiAFyNYRy93sh+kLMciwnlZyQK20wVrUQUd1YpRYDXFRR0l4xhAandV9lU+CRsnRZEJ9IT79mqiGjoXqFDWdzkZj2koFW0mEi0dfGheSpMPyNZe8/MNprEEbtYPN/wCQwwStiq9FzJGEDPgDslq1g21fg9iLxDlZVvKz6BTL0Voalsx8netnkIZEW3PwCoR1i7aRxntvWBRgDSS+B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199018)(4744005)(2616005)(38100700002)(8676002)(66946007)(6916009)(44832011)(41300700001)(8936002)(66476007)(66556008)(2906002)(86362001)(4326008)(5660300002)(6506007)(6486002)(478600001)(54906003)(186003)(6666004)(316002)(36756003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aazx/aiGcJUEQahiUJGLKs9WBqeizIapR6aECpPHTQcykZyAGw0r6zpZwaIw?=
 =?us-ascii?Q?A6wPh6w3EHoGD6Su4LOIsT6+f9tUgj0fib0lKOLfRWMAdZRWaJw9S5Zg2yN1?=
 =?us-ascii?Q?a7zsH7N84QJ3EBqeS9+VwC4VDUfFC5HHQvo2EnCk6oOZkZyBfFuqhPDSmMFE?=
 =?us-ascii?Q?nIzOhO3ZxPD42zWRSZnPm9+Bbpmh4wM63JYHOP/2D/L4JHxNrPK2N58CNXEM?=
 =?us-ascii?Q?7mqiSgqqws8aDe4rUbMU4kabdtgxgE/1dgK+jUulkMXifUTBNOzi3JoIEn/r?=
 =?us-ascii?Q?lo5KYu7ziZakmPgJhzic6DNYQyyR58FC5JpLq6/3VrMB0BIY/RDTChUkzYJ+?=
 =?us-ascii?Q?mFVyZ8ntNagKYCOWrW2jvPQ0RHR8Ai98RuKjs+k3Gc8LlKNUdV7mBnl1m9hp?=
 =?us-ascii?Q?QSCKUFUxxx6NP9PqVpIQP8GYplpVi+jEWj/YGMV5GAzU78TCMU+rXRJD6Zxc?=
 =?us-ascii?Q?LeuRPVKEiVZxiuFvjuGehnINzucKHF0KQWsN8ALV/7ONlPoNDVqJq7bybEZr?=
 =?us-ascii?Q?os+It/gWjNoszWFpllgNSW6rMJzGhbyxihGM2BL2q8UKfCc/rGJGQTVtDH4d?=
 =?us-ascii?Q?j5DVydxfXjhz3bJj8UqCFS5m0t/jbKs3rgyJjnldHfL1u+EvbDPswQ9xEyfK?=
 =?us-ascii?Q?W66+JsSR9vYc2Zb/R9acheSIpVnHyUcC+zYypz0c4rgbT2WpJ6ugnhk7uZc7?=
 =?us-ascii?Q?9UMojbVQqnco/zqw89vLw4HxVdXyHUM67dwE/kvGvGtDA7JR08gN6OSA70dL?=
 =?us-ascii?Q?yxRTlbfoTAuakdDUsg/JUPgqtWao4s5APhm9/xuAm8AgWASaMbB6czE5p2H7?=
 =?us-ascii?Q?wyap+H/OqKC9xftybZhvX/SpQs8ZZHGoK4euQWVin9E1zfA5a5MPz+RY1rXt?=
 =?us-ascii?Q?pHEIFXIFYonAkjQwIcyntvZMNLpxPP6XsTG4dvMOFWG19Tb87MUUbqe6IgLu?=
 =?us-ascii?Q?FJcyKlfgSML62SH+2Lk21Tqu1Ws7mh01duiWmtvpos5CnaILxEVmgoDptxW4?=
 =?us-ascii?Q?aztMgffl5Dx1juZJvWbMBF3Fvmo+O8/ZKDepxc8Gdq5uq+JUH+YuHHJ9AQB7?=
 =?us-ascii?Q?XgorVgWC8YN7CuVqBTva9mDim9fDNNEOgNQ8uhi/T4OxUuOZWlHEFfGJKtex?=
 =?us-ascii?Q?9Y8DCeoQO0NEI05kxBBiHgJT8DGNhIJIzuQbqj1DmtEG6aiPy05DjoutfYW3?=
 =?us-ascii?Q?2sB9SYnjYNHPcXv8iTXSWB3tpckR4eY3Akw7BQn/BDZ31HvfcUSqwZFT0r1F?=
 =?us-ascii?Q?yQYY1D9ejuS14MAA0vMGqDw2Lg4znQ06fpU52vL8yBgZpdGxvhZEcXB/9f5O?=
 =?us-ascii?Q?EXCaNYIJLchyHyMr89ewkYj0XCzORlnHaTo/ZSCH+oRb9UX5ga9Fgn2Myf58?=
 =?us-ascii?Q?GNnNfA/l1G3NDOHD3NXxgaUs/0uSlewZqy3/3P7OySmDey7aCSeA2hfHrkdS?=
 =?us-ascii?Q?xv0up+yi4223P48mDHsWAnjcIdM6sQLr1T15UTW6v7TlQJUIJ2uc93+aiunV?=
 =?us-ascii?Q?Z8epAArdqNI0Z57xpo6hxDQLXqIUiSK/CV8y7gCTglXzVwYbl0IqKux/PLKS?=
 =?us-ascii?Q?xvibQKHeFr/G6z10/z/y3kovkeYZ6lQ5mppN+ZpayusSlQD13FqULGAcvbQ7?=
 =?us-ascii?Q?Vsb2E5BqvraK8mbRTrcH6CfSOR+o0wulBa5dfvMpXXIQihK+FiPMMOvRY0u/?=
 =?us-ascii?Q?ZCSFyQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c346bd-e64f-41e3-b92e-08db077e1c8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:37:23.1946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8tDNJn3CM+PsqjJ1Tvv6KdSskq2FO9VqBld+dqdn+D2G11v3miaXieO5GL7g2B3YcjeEcee7G69VKuCwCKFa1h7gR3EzVa+iqEg6ZMAvhsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 12:29:58AM +0100, Martin Blumenstingl wrote:
> rtw_hw_queue_mapping() and ac_to_hwq[] hold values of type enum
> rtw_tx_queue_type. Change their types to reflect this to make it easier
> to understand this part of the code.
> 
> While here, also change the array to be static const as it is not
> supposed to be modified at runtime.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

