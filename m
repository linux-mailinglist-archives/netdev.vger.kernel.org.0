Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439966BCBEA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCPKEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCPKEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:04:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2099.outbound.protection.outlook.com [40.107.243.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBC02D7E;
        Thu, 16 Mar 2023 03:04:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aovgb/acQqpFcWBrS8fBSqKyoSS/8kFchW19OHW60tWL7tNVjNQHggzqEKl4rFXmyyYcUbW3mh3qtk0s05Sc3afES4uW4KX7voo6DLqmMjrniQ5/bmfGmRnrXf98Hc8AUNiMIQUvPajQu2qOn+G83z0J//XkdA1ovDSjcZORM8F9mKmqa1Z+MWlbdiTp4VPyViJKR51k2B3zofjC8TbWZsWPPUeLa4kpXg63g8iygc0E4K1GwT/8ELTnK6E5H/6Jlg793zEQBOHBFL2WCzCVkh4nML005o0eM7JVZ2JWEC8UtvRhpiiGdEf+llp0PIouzdCZcrg0teFk+39UcG6fvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YR0p1/doQpGoFOm3WaxJgcyr5ke0f6JMXOI785b9ivY=;
 b=oIpwVM7vyfQO5cz1tn57esaQEq5BcT8KyBxAyRjtOpHtZCung52GyKlawrScjVo7U8QBMX339dKaNQZ0UC1UkoUw8cbSNnuue58sHeSg87o7tLbRhWn+//eumhM402VCMByOIHLynEFX5q6cFZ4JrRfUkZDWNRBlp/7BE8zEnmH9+xIWwWR1y5v5U87A9aVBKkMdnRRiY9wVndsCIYMXf+I2DE9dyqrJ0Do5zYshZ5oQpqylEO0nnz/fL3/AhFpQ6yPsI67WgwOe4QK93PgtVI1hWyW1MigIzA0+1z0KU5zi+OoVsu2T40rloFEUAQxV479jkYdcTQnJH+jpaFcqJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YR0p1/doQpGoFOm3WaxJgcyr5ke0f6JMXOI785b9ivY=;
 b=KA8mzzBauiHD8AXX+iWVbr8XwhBOQlwyz8fxpsjqdBFNOKpm9ZLxtf/ZK3MXv1vivlPfupEaq4T1Ma8y36icVL8laNO432tga3FGXYsUFZREDxDl4Bl9oin6yxpszuFlK3QaAp4r3XFR2h0Eb5MFuSzDt0VYYwT0t+NccHYnbt8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4066.namprd13.prod.outlook.com (2603:10b6:5:2ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 10:04:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:04:38 +0000
Date:   Thu, 16 Mar 2023 11:04:32 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/16] can: m_can: Implement receive coalescing
Message-ID: <ZBLpsG/NTq/0Bo+7@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-8-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-8-msp@baylibre.com>
X-ClientProxiedBy: AS4P195CA0027.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: deed7669-d2b2-421d-9d6c-08db2605da4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O18YS0K9Ms28Mf2i0rj/MtHVmllxpzcNOhhXXx6LFH2HerKqfQ5XPhsetiALw9VjOXdGJQW6t3lD0HB2dFLwy1Qj8DZttNpFScCeHWFqwuFPwX8JEW991lAivclaOwjdnWkn2xJ6g/I09i1f+nNl+T7urn/guuAItyekF0W1w+sQJPRtyrYOxVdvRnjmhEBM+6XRlH35JrCLeaHZAdtStpBiDdi3BTcShdJocbnnJ/OZoa4ex17tJ8NERR21ZO/9km/acSFDZbaJ8gcz1ooAbK0FGsXcblQ/KUfdmsqz6LsKvvMJ6BLUkxuEVEaeRc3wjfUiYDi9BLTQ9kvNQjG/ADGtxNJOtCNEXRColtLRFWBBMrkmwonzeoaciIVacFskOygh9err6pfJrq9Iu0vTvEv/2XlXb6TzGbZCAh45emUfpVAUh64w3WpANAxNesbnyMltlg1528KjblJF5oZiSLkFxygvADWA/22Gw3mRQU6wxlTMsBUm8GaOZnmGN9cYYbyauvhdvYsHvdBFR7ObTWyEut6VRrWLryjqWz/2PNyxmHeGcx+9x6B3lQZmAOPmlxWXShY78iM+rf6lkiXBPBIwij0Iy+JKYYHkh7RFLOsie+zpZSWNx7VZcNxvsGjE8at0OdQh+ewADi+SjqqGDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(376002)(39840400004)(451199018)(36756003)(44832011)(478600001)(2906002)(186003)(316002)(83380400001)(41300700001)(2616005)(54906003)(6512007)(6506007)(66899018)(6486002)(5660300002)(8936002)(66946007)(6666004)(66556008)(66476007)(6916009)(4326008)(8676002)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DHOuj0ap0+U2yCaBH1Uzn3K75zitmyRcHPpAXnSuxDg4livOY3i4Eexc/Ub/?=
 =?us-ascii?Q?6qM+/DQTkS6TcsiLFeKx0OtDHnIUTD35Mr1F7hxfnDiqb9SsY0CsTfvFc6Iw?=
 =?us-ascii?Q?z6QvII9Xm4UgwCDWBD+hCI5fpyIY/yU19IsJG1VPdo4zzZBqQHUfB9kPDO6M?=
 =?us-ascii?Q?oHAUMUdH+ZKd3xTNcKFn/DYETzfSsoVUaFIugrfSfJUMltM0pOkQq+K6/TqL?=
 =?us-ascii?Q?E+s26uZzZjTuCDyvDQWRONlewczKznrXN2g9dKszTLMkoyZoGmw8QKhN9unG?=
 =?us-ascii?Q?vvYsdRjDAk8K+X7V8NrejGDp5UJ55jAOdMRV5RAgszZOY3rqXUV7MBtnyv37?=
 =?us-ascii?Q?kCJSBGR0WB2dzJ9yxUryjN9ztvM9QDutZ+n94reVPlZzc/0uuSmOOpZo623G?=
 =?us-ascii?Q?JtlYln8nzKRY4NZIH0vf4TPpn8OBMfGOx3k+V6O7GzbkgiWaQFdLawRBZBRI?=
 =?us-ascii?Q?K5ITgL6btKmRRFvnC4R5Xe0ejQXJ4E1egL8GzJqClu32BjIybBrN6chl8O9W?=
 =?us-ascii?Q?F9jTghesRm78vM395fMz6JUfUM0VtKKsnysk8xXW5aOidMaJQrHjpes06KG3?=
 =?us-ascii?Q?2rmsQJGd68vtSzzfYdozyWJorqLyORX4/+vBLmRL8V2MCnp9q/4x9L+EhRzE?=
 =?us-ascii?Q?+3eDpU4e1Ubv8l7alkGekgEKDbRQ8fMrikhcL69YlKtfsDqSDhBiQGCqHmRY?=
 =?us-ascii?Q?vT3b7C8D98BmEgZDtlgDyUryTbF8PlmRB/n6ABKqP0M6cBBjZgBJ3UKu+G/E?=
 =?us-ascii?Q?mBjIliNWIPDMEE+kSH658prU7+d691yfRGgRO13Li6CwRfwWrsEziqxJrGMI?=
 =?us-ascii?Q?CfuEzWnmCL/tBZg9PVtJrOC5h1bDPptf8B7oFfsxgUNuKQeVQbCjnU1VxuX/?=
 =?us-ascii?Q?348UOAZKpVsBVuKw1pHcZr+O1/6SQKdnpv50n7VJnKOrisftQ7HCDq4BOi/d?=
 =?us-ascii?Q?Rifoiv+j8ZXST18zx9s/ADMYbA5kxNDKbpUlOfFMnTGulLHlUoPhjTDkKzYT?=
 =?us-ascii?Q?BcIGHlNewCFTzeFq9ytEU/QRyxHi5G5Fh2N0QiGNynVr4Jk79eEyRcG49QUw?=
 =?us-ascii?Q?bneQ+WYkq497B+6R284DHdoC9AfBf3VyXNwP0Mg7S2mzCxz7yAqlSEAzEGb/?=
 =?us-ascii?Q?Q5stzoXNzkOHqcL7rlJ9GMn8bRtxBaaMh2zjaClfemK/T36HNUVvoUBPe6vK?=
 =?us-ascii?Q?YISC6m0K45UUOUzGSlzQFaCqxhNiJKg4Y+ZRnz5pQiQRxnjfac7DNN6ST7Er?=
 =?us-ascii?Q?gCB85aFZTVs96QghYonjllMZlRWWOy3C2/f1G5jbpjCCqDb+WHoCp3MhSgly?=
 =?us-ascii?Q?yqWWxiwlDMfNScD1RkfPobOX3sclt7Zyd4LZ/4k9diOj6tICMfcL/xFzt5S6?=
 =?us-ascii?Q?aT5K254tlnamEn1wNXrKuBc0Na6d544dlTO+eCTXWaNTKrC3OdlGBtG+7crF?=
 =?us-ascii?Q?Jz3G8LyP5F19MXC25WgSmbozGwz84IBIJ4MjngPpwnuMRlmuwpeEtx4tL8T/?=
 =?us-ascii?Q?bf7Iktq4HwHXToFzSoju2ecPnepjWtNHI2hp/9WG0R1mRf3KLV0UHBlutWfE?=
 =?us-ascii?Q?fp52awYorhO3CpkeeiDk/pyFwQu5e/2pq689cPjo2jXfv0WWTo1kaZYkrqK/?=
 =?us-ascii?Q?ruLGjzZqb/SF5D0ttC++2Cn7bf5CSr3Mk2z4BA1qSVoNycDlmdVAq1ISuoRz?=
 =?us-ascii?Q?511SZQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deed7669-d2b2-421d-9d6c-08db2605da4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:04:38.3518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WR4wEgsy6+KxhDA9n7K5CJOHuu8j75IMbkDmCyDe8eZLbsowzgy1eSBTIj57QgclScr7T5DgEWqGaiELPFqY9ighvGWkByIhkCdKmezSGks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:37PM +0100, Markus Schneider-Pargmann wrote:
> m_can offers the possibility to set an interrupt on reaching a watermark
> level in the receive FIFO. This can be used to implement coalescing.
> Unfortunately there is no hardware timeout available to trigger an
> interrupt if only a few messages were received within a given time. To
> solve this I am using a hrtimer to wake up the irq thread after x
> microseconds.
> 
> The timer is always started if receive coalescing is enabled and new
> received frames were available during an interrupt. The timer is stopped
> if during a interrupt handling no new data was available.
> 
> If the timer is started the new item interrupt is disabled and the
> watermark interrupt takes over. If the timer is not started again, the
> new item interrupt is enabled again, notifying the handler about every
> new item received.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

