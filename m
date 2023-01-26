Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAD267C582
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjAZIIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjAZIH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:07:58 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3239729E14;
        Thu, 26 Jan 2023 00:07:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce57g4R5aTt0gxqEuFugM1Zc5lzRk4jk6lMqCvNcWygeER65lBCzPi8V3jSQSx7SXMx/1+eAhygPoFoFZsLZ9x4pcmYPrhNEOYrVNkiiGTYO6AvAlsvRQKynMFTS1y5LKzGfIbXs33fVeF24BFHeqBKjG+pYmswqD+Z+uGajoUyJ1OodaJc7ccOSD6DqHuCqCATSq4psb6+tPKsfK3S66fGhqMV9AdGZBNo68ODpz93kr1w5BnrkR+ErBukdbg8v1XP02UZZMxhEEUvJJ7qXYZtVgPndBzRafv1HUwFPtf8EZO8p0mCdVlP5fkBGWB040oajwJ1vrYGqLpyBM/OwVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/X1RHNBiylHrurdoGaUkuRyWrYD+HNVsejju+ZSIBho=;
 b=f26HdhO3k2BLip7keQlMsg/P6M0M/WP+kwzJxMK+i5yD2p4toD3dFpSRK97U4ZJTcNDRrHkAXnSc+iKIWrzPpMzDwHDUF0s/M2z237POIRCMr0rT6zH9mtcM3U7lUbmyIOM93izdISA13AS/dbYn0VGHvt4p3/+jcjzzL2F34OCRqdkdqkbSd/MujzLQY7x4UFOIF2dRd9p6Xt4tDWcwniSIBqnUlrM+bUTh8yi1WtsDkZ6usjIhs5H+Rkvqa2aVcZtXsxUJdk6jdF0A0m6Hw5JPTDEeBrVyri6b01EXL6I4HRa67lDe1arXDiMOWY4ia1K7woOFzmKoPT1vjTT7Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/X1RHNBiylHrurdoGaUkuRyWrYD+HNVsejju+ZSIBho=;
 b=QJ6/bJsDpbulqelf5fHDrmFbVDNpiQmH8kBM86fI4KDz4Ex1VVzqHr18PXePYlAkcs7/UMmGhvzjnD/Z4Pnssk3LvH7NGxJVHbFgkB2GYjGKX8DRPL28zFOJsW0jAgO4HPQ1o8xUcVOVEI9/CnjckkCkzzaoPRTiLdamg/UjOlk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5074.namprd13.prod.outlook.com (2603:10b6:208:33d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 08:07:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Thu, 26 Jan 2023
 08:07:54 +0000
Date:   Thu, 26 Jan 2023 09:07:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/18] can: m_can: Disable unused interrupts
Message-ID: <Y9I01AN65Uvdxp9E@corigine.com>
References: <20230125195059.630377-1-msp@baylibre.com>
 <20230125195059.630377-7-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125195059.630377-7-msp@baylibre.com>
X-ClientProxiedBy: AS4P192CA0007.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf6c054-161b-4266-dcf3-08daff746d33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iS6f1jyqf0aaUXMgGdFoFp98V5+RlauRaIuc65CNH8ycXXowAt3MlI6a/2LqE9v2eJyvqRhWdPsjoP7m8CZH1oz7yPNQBhsVkidRETl30+2R6K1MHGuwXAu200KN62ZJyadzPoM0US8ws1OMTP3y6giiE1xuR5IswXM/FA+YNZCpUytK8yOUEhHZ2AjHf9XWE8fHlYTTWzxnBbFEPyEWzOMxF6Ogs9ytaDdEoZuSJciDnkTSaiO79/uKm7QmA1cvyMdn3IH0YKN9q+4ZH/NdxuNOrNCaUBDnBwTIkniKPEf34Qvc5CkeSQzQoAnOeTTrJS5jhtIVxIK+oZvTvcZ+r4o8sr+dl1/aDMrSuqXhTh1Jbu2xKlJvs9hhyyCrdoHbVBwX+/waQ1AonsjNRp7uraOdoki/Op859XZu2Rdn5iO2EZ8VorUaWRHCqShsL4PaRw5GJtxWAOxrM7xcWCsIsLanKEWkOcAybAUsUvdSfvNSRVNzYZcD3GAMeplkDnAt40PJknwXBfA/Bg6HAa6wq7PHlbwSXeRQ/1h/o2VPRgiaOYazj6Fq8p5PO6MliyRSrRZAYcslMZSrJslPkL/96OYz/fR64nZaIr3AfiUoeVN14sxNBOtwrJtr8hBK9laql4g2/wTnQ6e5UD8ioZzvnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(136003)(39830400003)(451199018)(36756003)(8676002)(54906003)(316002)(478600001)(6666004)(6506007)(6486002)(44832011)(5660300002)(4744005)(2906002)(4326008)(66476007)(66946007)(6916009)(66556008)(8936002)(41300700001)(86362001)(38100700002)(83380400001)(2616005)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erWg9owEJ9d7gAB66sV16KVyCE4ciUnGHhBxyqAxxmfDSPSc18+aBt5P1xND?=
 =?us-ascii?Q?25SdgiESP6a8A3yU81QqRnXdHnLPTuLWm75jTFva8RVC533yk0p7A9e7mGRH?=
 =?us-ascii?Q?G42wnHs378HLAiL8vCsd+BeyqAyjtfO1Sc06nBL9ELU7vHSr3uL5KqVZkA5T?=
 =?us-ascii?Q?iEZluQE99vWwstHlKUHsoTkFaZKJJ10Gzuc3EwhAktV8cLMkMqBAKIdgWx2W?=
 =?us-ascii?Q?IdEJVr1bO8ycphEfHm0vLFbJLVHR196MS/IbGZtFbDiaWryX8jFjWkDsCogy?=
 =?us-ascii?Q?CM6FuPJfgaIUQnzK9qQ1a6AxRZ29EuvAcwSCKrSWiCyFx8o40lWSjB79kL8S?=
 =?us-ascii?Q?aJEad0nic7hqURC6kRtHeYq6cD/YXARQkSmMDky75/FXMs8EX3pBTPXZCJe9?=
 =?us-ascii?Q?j9CTA4mMhvUBFsfFHD4SZW1teVWg1xM+g0jeWIWk/+89MGUspJV09QMGA3LY?=
 =?us-ascii?Q?vWHGI3cCsPRFvIJhVWkt0NoQDk+JPo9YrUOqYcvxbApod+pqLYzRd/OiYVDK?=
 =?us-ascii?Q?vN+cku0MAUrWXYu8hxQba5r78acipd4qfZV6k+LNLoPb9rXHaWbjHcjqyhn2?=
 =?us-ascii?Q?E2K2z+zQhnY7Pj4hXk67smPF4uIf7Eg5zLw6jKpmToN9RsuXK3rpThKbtDpW?=
 =?us-ascii?Q?Qmih2rrinjHpslXY0BeRyBK+HLpnllPXGbkyCLjo7Q6EPXt+n7wmJer82qGf?=
 =?us-ascii?Q?pnT8/SFCIdTEfjwy542qxqeOoRXjZ7f0dP6nFQCMdvFF73mqJw8pBsr5yRKL?=
 =?us-ascii?Q?6BqJKrkadLW63pFpLyNCvb8/pQwiGn1KwFbHh2VfC4RWlbZewwD+S2hvpiQS?=
 =?us-ascii?Q?xdM9reYMPgyZCPcMZvQre0uiG0RnzioV9ak07GHmhb7St9aEy5SAfmp55oy0?=
 =?us-ascii?Q?4oVOmWIGjg/V4XzDKX1+GlWwRZRlluFh8XL8Eb6sdxWb5YhSPeGjOjPQIa6k?=
 =?us-ascii?Q?trKP4ef58CBWecqBXfAqXInGTlT/jfBSuHwSlIzqNmM2WpVjDz9KGuy/o7jZ?=
 =?us-ascii?Q?G6uQzUwQyR1lY1xO7T2EJ+UmGVzU1Gmr4gGdWcMee3d6O26tb5DJPvzuzjjT?=
 =?us-ascii?Q?DMpd1IAnxZVa/AahOv8l3KMNgHjEtyuA14/1E/gDNjRwwbQqfSnCxFstoJij?=
 =?us-ascii?Q?dpD/lvm6soLYeqL6I+KiedQrcZiJSLglX/ZfStrGCK9LjXFWNozUaqAoBAYN?=
 =?us-ascii?Q?oJ1sZrThhPHgHZRqvZzD4vG6t/lu7hHqdJYhd5VeH0LdPrtlurKVAPyHePbf?=
 =?us-ascii?Q?J/av6Y9uKJvCX86XUpE4+ejGp5IMbOt1OvH3i+dPlHolg9Vk2B//aXdCUmgy?=
 =?us-ascii?Q?3Lv4s/F3SMPkDZMNOdKIKMtngsKQwRTafyMRUYdLuGqtApoiiFETg+xI7O7r?=
 =?us-ascii?Q?pLSlhhVvm5RZFmMYJDU1YhmFTUt/k8PwZV5+m9ILN94LsYLGBH8rzWW9L+c6?=
 =?us-ascii?Q?6wH5EA4CMBMCRrMZA/tY1a6FKK2xuEZ1J0c6b0hPqRUKiI5xvrHDQ9ARj0Wx?=
 =?us-ascii?Q?QUXHTsH/sU8hvhEyO9dj2FlshCROh+i2YUD+dxUoqJm8RHPNXAHd0JUiEij/?=
 =?us-ascii?Q?RWlYy2CPgR8McZXkjr5FTzYXgabw00xjqtgN67551ahUF4+a+8kspFZZ/gKG?=
 =?us-ascii?Q?hc923i4AqgHiI4aesQF5gUKU5c5CMZ3hcafbQI3kg13hF1Iv7jlqSgZTJU8+?=
 =?us-ascii?Q?o6dfqQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf6c054-161b-4266-dcf3-08daff746d33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 08:07:54.1604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ier+wh7P8yP30gwfBjOoXis1dXGqteTq6FfFADj9TTVxNoiapVC4qUfxCE0mJIUsWGZmvj8R41zihDaR4E4YzKO2wMJC8lhIOZI2TZzsA9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5074
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 08:50:47PM +0100, Markus Schneider-Pargmann wrote:
> There are a number of interrupts that are not used by the driver at the
> moment. Disable all of these.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a668a5836cf8..ef5ca5d37b0d 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1262,6 +1262,7 @@ static int m_can_chip_config(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev = netdev_priv(dev);
>  	u32 cccr, test;
> +	u32 interrupts = IR_ALL_INT;
>  	int err;

nit: reverse xmas tree (longest line to shortest line) for local variable
declarations.

...
