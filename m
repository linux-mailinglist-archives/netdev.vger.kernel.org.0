Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64119471458
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 15:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhLKO6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 09:58:00 -0500
Received: from mail-gv0che01on2122.outbound.protection.outlook.com ([40.107.23.122]:5024
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230172AbhLKO57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 09:57:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9bDKO5dZw6lFJwS+6eWwHh6IjoHV+y4COBVZN+ebJoVgUxhMa0+iJ5qub1OVLuDOold/NPmr9n1mKU6Tp9SklwbH+DKa081lJIbUq0ifxKzwtELpzNMRrB73af0ivnTwfeVx5thImSj4bXWp5PT9YnNN6UakKydpCxkE9VuxY/LV+6AjENv76VhCTv4xwO8TjU3rAlDraugGhydLMWAAXSyz+U7rPygpzvfu5hJ02lMt9nYgFseAV9wvQaYMVl2Dw4xuZPB2JLFv+UzfiVGSWBFLHwnyRtaeNGWkyTjXLbQtCFjdbrm4Osn5xjrq0QdmsTRxcW37mGk6vtfNdfI3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I488eq8nToz930+ToYmgiuMAm05MBtGF1g8ueLHbeOA=;
 b=T1gWmp55iRNCIWfL+ON1mo/JTclh45f/t6PQZl0lolw+F7Ccv3MZy5QVu3bJ84E/UQ8sOIKg/oY3r5i9Cj2U56grmUASHfFXF1jRz+4eHAXv+gHnEjRQ4/OwB9Q8kYrgcjckTkW36azdaB7NxqP9xPHCzhbR/4jI1znA1Js8A7jTTn4o3zHvUKRzW51/YIQ9mGXnsmwySuN9hxKfk0epDwtKJ4VD5MynvZNaJ0yoCDIQZRc9C//DlPdQAii8DzQ4JDPWPdEleO2vxinizYMBnndpmyCpEs4eCt7gJN19d2NW5DrWb46pNsjR2jaeW0Evs+EbQQAJ7p6UMUGb7nlgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I488eq8nToz930+ToYmgiuMAm05MBtGF1g8ueLHbeOA=;
 b=Y5aFdbImFPi7+mjUNtyhQmGphLcpsKr3/h070T9vbZ+P0OIcv4TZxSEA0y+7IZ9VTzzkVVkbEmgodD2NjKWaLwD3xcokg9kiD/zARRqN3FvJFe6Nkizg5VZtfxRy2iLqM843YTuhCnHAdBFPqI+xwVtTw/YjfuXOVcJzmWBZNvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZR0P278MB0490.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:30::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sat, 11 Dec
 2021 14:57:55 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.017; Sat, 11 Dec 2021
 14:57:55 +0000
Date:   Sat, 11 Dec 2021 15:57:54 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        philippe.schenker@toradex.com, andrew@lunn.ch,
        qiangqing.zhang@nxp.com, davem@davemloft.net, festevam@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: perform a PHY reset on resume
Message-ID: <20211211145754.GA360685@francesco-nb.int.toradex.com>
References: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
 <20211211130146.357794-1-francesco.dolcini@toradex.com>
 <YbSymkxlslW2DqLW@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbSymkxlslW2DqLW@shell.armlinux.org.uk>
X-ClientProxiedBy: MR2P264CA0177.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::16)
 To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23d351fc-6d65-446f-f2e7-08d9bcb69d20
X-MS-TrafficTypeDiagnostic: ZR0P278MB0490:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB04904F60C9A57212025531CDE2729@ZR0P278MB0490.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRdpBfbQVxji/Fe22fRGPgPMArJ8jW2guzvoE3GmBN1wxIzFjDIc8KiSqUxQR1wEERTGQN1qHsnE5TrM+6UsG/z3TOrnq9w2wkCB702FYtZrjRa6QLHi3LXMyD7+M9shEm4TFY9w2bu5YViYBguXMJ5IpzqZfsrwkTExPrMu0iJs/Zfu9iwOx3kkOfFAH9rkLoiWMgf2pSIwE4a/VUgJs5Pc02cNNahlgxNCkIvwz721j8ceEp8/eUXMaFsUfrtp9jpUJBrAs6o4huBVa0Jfgg7+m669jbRBpdP6JYcqj+Mw3YYXcNe4na6V7R4CwJx3zYTL9ze3cKJGfNmczpstE/kFWarw7/JHkSbJIle2FO/9PhlExKE6b4QpC+eZutQ55TGIAhbDViqXE193P+X3GSnqQ/C6Hhuhp4ijnYBs3FfTWScEihrPJzJDjRLgpA03jRECdaQY5TVy7HxqNpzGb1boLhbXIKFs1ercAShaziwLdISYhvzQtFzAe0lID8FHywn3hTZ5utxI+gmbfqPLUU4FfSTUdze1dY9z6nhIux/mQTsERyRmuQCg+7L1zOHtiISz/lT618aw7KE2WPVNZe0WVbYyQNJhFwn0/Ryeld2iI6ReBTPgDE4LJIaLkQZ4tFKwX28i8B6mIs8paepjQMYkb3s0sEBjl8QRh/Ut+4HAsLNpHUEEXgWISVvLzCFjpojY7h7DJi1o9sC9e/ilC9zQyjLapf1jy+WxV4Zt900Y9gS3+s1KavQ+733mFbQLBBmM/CFl9GcZ1VZwNIJi5iwa5KSKKcNhFdaWQ/t1zLg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(2906002)(966005)(83380400001)(38350700002)(38100700002)(6512007)(5660300002)(8936002)(6506007)(8676002)(6916009)(1076003)(33656002)(6486002)(52116002)(86362001)(508600001)(66946007)(44832011)(66556008)(66476007)(316002)(26005)(186003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Nb7E7qGto76cRO/6A8tk+eE8gBpXe2w5JrGBFEqaZyppbXndq0Hn065MQ1M?=
 =?us-ascii?Q?gOCZrJXXdbR8FgSuTgKWesKfC4bMgronWQi8+hT74t7PlovYdUb9FDFAQQrh?=
 =?us-ascii?Q?JQ7gkPT7VSudwTHbCQsEgtZ/VL7iBN1ih3G2vVdtzIwW9eL3p3Uyr/3s+3fW?=
 =?us-ascii?Q?Xk4/m5EsP9qEhTj+Nv8nRhOOZ1vA004XU6L5jfpFPApjxAxw5XQN62gxqKfp?=
 =?us-ascii?Q?5YnjA8zgf9Wg8MyOBgcoA8fQx/TXTR9Lshrhqykq/FYefjqp9tR8Z/uShVFD?=
 =?us-ascii?Q?oLBzqGqvT5I7e+gWc6ZBGbp3/WhnLmmZ82zxLirkCrX+jjho/ja2awBLcYdo?=
 =?us-ascii?Q?Jr5Rnvr7bHNmH+h5V3iKXoAGrY2vcA2orv6eUdvMpTQsdSKKJEQNoSV0b95o?=
 =?us-ascii?Q?OLHNc/Pa6MlUGsHoC67uO1zKRxsJP1vntkmdAx9I5US9oN84b1f0VdXdOx4d?=
 =?us-ascii?Q?xHSubHzF1lKcvBmu7NSYkMkZisOqtSmQw3llfvAFHn8IJd8JSXHk2CBnRjON?=
 =?us-ascii?Q?6AJ6XsyMs8oTsOaBeFnEm9UdcLTHupxHqAGyK3mr/9J5G/Mw4koUDd7D6/ee?=
 =?us-ascii?Q?kUmTrsKUWBhfeb52ayPStgCmux+UGjVv7cY+G3ljX/YW6yRVovQAFUCtrBrk?=
 =?us-ascii?Q?dnYkgL39LGQGgf6NktRJASZAprdbb4uQqWQPY+fyo0j0nBZI/EgrJckplCcx?=
 =?us-ascii?Q?HR/9aWMmGYVqrt86/r8ffgc8TzlNETzK8hdT3Ia3e69/R09ursnFZi0JUpQn?=
 =?us-ascii?Q?kqGaunLUVuHyOdFm+Jc/XoqvghJ4JTzWzAoxmH7TJ0pmd/1MJkMCIODvGD7n?=
 =?us-ascii?Q?F1lGqFCXtWL0NgKTcXnCY+Tyl8Ujj31OAH8cKIGqnwEJhRR8rUXK5lttI3YV?=
 =?us-ascii?Q?gHTO4pFIw2HxZnN1qyWSqV2OYuNU84/Te2InoRL8VntbICVwAy/EQQ34hqhh?=
 =?us-ascii?Q?D8sixxS2I9T49tYnpLKN+BCn47r1+W56Ps0CxCdW2rdzp1/vNYljgqz+zDjg?=
 =?us-ascii?Q?ic5JjD20hlSoM3k5Ptuxc3ac6l0Zo7fwOVTlK0KCpv5pUxZDoJA0EkhO44TP?=
 =?us-ascii?Q?uXmqzteQbNsYSBDM++bPWsK45H+RO61Bb/xloG/yhcsziOZ0tEB9e11FxuXn?=
 =?us-ascii?Q?T/FORNTcgk1y+zvyujhxHRRhF+wPCYPuhk+lgpjzm+VSEXW77ycJCn/0ZDvK?=
 =?us-ascii?Q?j9IOZn/nSX56aC20vjFbJBeHxP2X3yMmGKRI9Sqjg5cqsM57VR2u5fDFhZgR?=
 =?us-ascii?Q?K9jNlwVrZCMXlkizJbVIw63NNVZGRd9GeWdUQFkoBKs+FeSWLyOrTrjd3Ql9?=
 =?us-ascii?Q?/F3EmWFKm6i8lHwwpxWTJ9KpdLCLh+0upmXVOj3qVSv1GtyFyNkPTmqIUFNg?=
 =?us-ascii?Q?N2jMK/IrDTSwuuWmcQoBw2g57U+Tiiyo10KgdLnubJUkK+eouYU5ukj8IRV8?=
 =?us-ascii?Q?yXhwYCW861TWfT/sKXNi+kvD3YS5Yqrr9i4cBX5LeDLWHmjivboy+t86c+rH?=
 =?us-ascii?Q?uVP/qAduAH1Tcg5xnmtrrfs6GXiRK74sTBSHN0n5pLEJS8s7lnsWzVmZc3rY?=
 =?us-ascii?Q?4Hfv6Ttd4nBUs9BO2vhJTW7PoRUJKfc3hOyRW1KoULeARjJPbfRi9A0+qJSR?=
 =?us-ascii?Q?U5FpC5QsPTKUNUKH5CRjJdwzMxuKoDEfnaTVEtqUXJaPGgWbYLjeCz4nWSGe?=
 =?us-ascii?Q?F/rk1g=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d351fc-6d65-446f-f2e7-08d9bcb69d20
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 14:57:55.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzV4za2PjVBlWGqnbPde381W7MjndRYI8i7pUndMkzKmRVchF/B/Ln5nVcqwsXg2UxbKgmsieznQorHE705EmDucjtY6iZsrAN4ICyKC7q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0490
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Dec 11, 2021 at 02:15:54PM +0000, Russell King (Oracle) wrote:
> I don't particularly like this - this impacts everyone who is using
> phylib at this point, whereas no reset was happening if the reset was
> already deasserted here.

I understand your concern, but I do not believe that this can create any
issue. The code should be able to handle the situation in which the PHY
is getting out of reset at that time.

> In the opening remarks to this series, it is stated:
> 
>   If a hardware-design is able to control power to the Ethernet PHY and
>   relying on software to do a reset, the PHY does no longer work after
>   resuming from suspend, given the PHY does need a hardware-reset.
> 
> This requirement is conditional on the hardware design, it isn't a
> universal requirement and won't apply everywhere. I think it needs to
> be described in firmware that this action is required. That said...
> 
> Please check the datasheet on the PHY regarding application of power and
> reset. You may find that the PHY datasheet requires the reset to be held
> active from power up until the clock input is stable - this could mean
> you need some other arrangement to assert the PHY reset signal after
> re-applying power sooner than would happen by the proposed point in the
> kernel.

I checked before sending this patch, the phy is a KSZ9131 [1] and
according to the power sequence timing  the reset should be toggled after
the power-up. No requirement on the clock or other signals.

The HW design is quite simple, we have a regulator controlling the PHY
power, and a GPIO controlling the reset. On suspend we remove the power
(FEC driver), on resume after enabling the power the PHY require a
reset, but nobody is doing it.

The issue here is that the phy regulator is handled by the FEC driver,
while the RESET_N GPIO can be controlled by both the FEC driver or the
phylib.
The initial proposal was to handle this into the FEC driver, but it was
not considered a good idea, therefore this new proposal.

One more comment about that, I do not believe that asserting the reset
in the suspend path is a good idea, in the general situation in which
the PHY is powered in suspend the power-consumption is likely to be
higher if the device is in reset compared to software power-down using
the BMCR register.

> universal requirement and won't apply everywhere. I think it needs to
> be described in firmware that this action is required. That said...
Are you thinking at a DTS property? Not sure to understand how do you
envision this. At the moment the regulator is not handled by the phylib,
and the property should be something like reset-on-resume, I guess ...

Francesco

[1] https://ww1.microchip.com/downloads/en/DeviceDoc/00002841C.pdf

