Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133B35B3A2C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiIIN6H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Sep 2022 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiIIN5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:57:53 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FBBCCE0D
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 06:57:35 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2042.outbound.protection.outlook.com [104.47.22.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-nfxdsdZdP8iAO0C8Bipzww-2; Fri, 09 Sep 2022 15:56:36 +0200
X-MC-Unique: nfxdsdZdP8iAO0C8Bipzww-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0018.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:1d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.14; Fri, 9 Sep 2022 13:56:35 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%3]) with mapi id 15.20.5612.020; Fri, 9 Sep 2022
 13:56:35 +0000
Date:   Fri, 9 Sep 2022 15:56:33 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
CC:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <20220909135633.GA219857@francesco-nb.int.toradex.com>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <9f03470a-99a3-0f98-8057-bc07b0c869a5@pengutronix.de>
 <20220907143915.5w65kainpykfobte@pengutronix.de>
In-Reply-To: <20220907143915.5w65kainpykfobte@pengutronix.de>
X-ClientProxiedBy: MR2P264CA0128.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::20) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZRAP278MB0495:EE_|GV0P278MB0018:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a351c2-6874-4ac9-88fd-08da926b1bb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 0W4zPU9mbSZGYzEU42QKPcD7e3ZlcnAH5ZgNQ6uyBfAnqTk4GF8G85IUazf+O5cugh8C4o+OhhL1pxjG/T4su+eA0ZduFzcld35NcXpla7Q2Bn+/oQcApRVEiqOevONqtLr2E+wx3D1auMqKX2utlIVL+5tu9iW1rLjE9btyOfrltPZMxLx0qzXoZMpKEI1+MXYOQmZ4i5ohg3tG0pD7qyn7QG8YSwJeAbhLdweLL3JFpP9ZiJDardQ/220WGRIxENAkIc26c2uaVaKugqTqR+ALu3oAkO7kupv5FA8E6gnkf4IDAMHv2dNcoObVVyjRqocy1RdyQ6DgpZrjdXF/eIEL4K29VtSUKhHwH8A4DpOeRsmM2UOYsPGatEO5dtI38JolPN65wmB9ys8cKguFg2ICZ5ooxbcPO9AdAswyBSGZHuKWBEIGcNSr7C3FiVn20CDJEM3aPaO3x3sK6OETVOV9HcVnTNic6wGFIMfkyOleqAhZhI0YVLQqHGXBe4oyVeUaJBAQXmNhOMG3qUcirCz4HFm/u8Am/PiDgqJ6plYb22TNfHIxthA0X8/aMwhVo1BVlObR3DvPfb0Y1lqo1Goyv29gloLzRV3TpdTsPh5tR66d2xo3ROzhl2F7sZ4FEp0mnTRgDRzUWL4C31C1eBOEcpZeiAkIRTniTbeCxVqlQbLY60PnNbZJ9jkkRMjYqFH2VztonHpdXuaJzgejxftuGcAuh+Id34jA/zATb6+KLGvDRD1oNbM0wOL20ZYwRYdqZGimB61tRc+h7lTC04JtlcW5vyhmK7WYB/9NvvFLa3mvv4iAmtWJUxO2Aq1CYLXOpwFXKsp7s6iRY7Mt7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(396003)(366004)(346002)(376002)(136003)(38350700002)(83380400001)(38100700002)(66574015)(1076003)(186003)(2906002)(66556008)(33656002)(316002)(54906003)(110136005)(44832011)(8936002)(4326008)(66946007)(8676002)(66476007)(5660300002)(41300700001)(478600001)(6506007)(6512007)(53546011)(26005)(6486002)(86362001)(52116002)(81973001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PZ4iDaB2Q5oX7GzBuF209+Ej01j/J2MdcKC2wZlvvPy8U8jNx76Ndyg74qwM?=
 =?us-ascii?Q?hqyM5S+mapJfTK6VTcG4lHacoqL5ZwdQ0ThxjzMYn9SpwRJZOIWaE9iDEkQq?=
 =?us-ascii?Q?unb1+isADCSfGfZu0+bjEYjDTeifsqKkKA2PJLDQkwSXrqy74ofVEd9FfFx+?=
 =?us-ascii?Q?YcOZ393iQHqpW05r8LK41SGsi4vx9UILGh56gYYk5mkaAKAkf1i4riwpV9ZS?=
 =?us-ascii?Q?nfSHWMHnOSyQQbpubwD+YT6yNI8pKqIH6biKDEB9K6jRi1N177T4ZVjFwS6W?=
 =?us-ascii?Q?gzoGg3gPyIO2eLEHNArdYBFn/G44OeRWAriq5OUKqbFFJ6J0fJm2XjcuV+36?=
 =?us-ascii?Q?Jx19qhHNvnhsmjiuJSsjjR0BLp6xKs/Swn8HtcRV5othpLyRJoImjtdyA/xA?=
 =?us-ascii?Q?IFTF8LSI1iaBScNcTmSsOBwFUS7TcuOzWBgdn7P73fW/8F6vWACnrFsZRBn9?=
 =?us-ascii?Q?QqMKIkTdXGnyS7HqKg2gy9gP3094Mi77Fx6K5ZfLP9feLa46vbLZx6j9qwM2?=
 =?us-ascii?Q?3vtMFhfBOmJdeK4MSR4qTL/afpwZ1VmkHRHbPy7Wlfn9+rrn3z/UqSCwcWT8?=
 =?us-ascii?Q?PyxnEcRHXSSQOfZrTGC+f9YMvFTPEX/Wz7HONDwrtwQ5Em6lXGlUT4r9fh9t?=
 =?us-ascii?Q?5H3yCKSjdUIXMIliLx75xGkGVHpfnXCPY3rfr+OgxO4MG9SoHpbAvZMLoA74?=
 =?us-ascii?Q?MuTxybnxd2kPypPtU/1PZilhQJPJQRocu3gvLDqWUx0LQU0vaWLQbaKTRHCE?=
 =?us-ascii?Q?LxrCv0s49ZazrT1lkj6c+AVh1j5pE7l1t8IKJWWgSqxxgqZVe+HaSETDHGoj?=
 =?us-ascii?Q?Cw0wv+O07uEJ5veTnONw9zH3x995wpYqfRYAP0Fi/S9vmrOQd7DkBVjYePAa?=
 =?us-ascii?Q?vnkSzWkuwvmoXxA3kTecu3K+Q0OWg5Eahgifd46YepROE67FtLFDhl0xAin1?=
 =?us-ascii?Q?9YAIPFRZLDZYxtZyODGktPVESfcm2QrWMXKMQd5N8gpfM7JRS6J5CGchL+ub?=
 =?us-ascii?Q?UcJoGw8+H8dHqtE09wjNV6FqPxpEaGPvlBpOMb4kTIF1y92vQnDxXAWPq04n?=
 =?us-ascii?Q?6S2UjhnGibjrI187Uua+6szWKblM7TiXQZOxFxLYq1bpuV3kxi/dnHb3f8Yl?=
 =?us-ascii?Q?hlmr6kRndScdvBrXySJZsZpD0YkjxIO42PhdbtBCgl0QLlinPWxRHmM9Rs/Z?=
 =?us-ascii?Q?4RVArrr/zv7dp69HxyxFtes3/Uwb3UEgA5mwxer6wDCWwODneSSMztlXifPL?=
 =?us-ascii?Q?H+LEAiEchpZG8LnrPJqAkxoYCjdnf/ojMnZ8dhWQ45+FdOwnR9zZ+yp9TILw?=
 =?us-ascii?Q?UDCoQHATIuSEAkGo5WwjLn2V8pBPQMvo9gKpwlbajRL5tJoIdipeQ6qbnDWR?=
 =?us-ascii?Q?/rNdtcnXnTcPpEaahQ3UE5OZFnMeLIyHuTnuDPSJbRXEGG14doMnYOrXQF+1?=
 =?us-ascii?Q?Y0hGso03hDzhCaIIZlKoqfU1OXPTXuTO4oz67G9+sdONwQmRbNgByssqoX+u?=
 =?us-ascii?Q?7oHyd+55xBRbsEvex3KREU/AuiE6V8Zq5Xa++Ga+1MLLy4h98frJAbR+JBbg?=
 =?us-ascii?Q?2tIhODUyOhKQbLYxGE1HLYii+yVBOEv6SB0H0beLN2JQrAIh9nWY3sEgO1Xv?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a351c2-6874-4ac9-88fd-08da926b1bb1
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 13:56:35.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TWMGqkXrHcDXZ63NKn4ofhHAxt1xYi7Sjqx+BQYq4sp37n3dLGq7Duo67Yk2qMnpnMubMVzZBJQF0XciY7mwal6djI1rVSGanj6GlHIY6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0018
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

On Wed, Sep 07, 2022 at 04:39:15PM +0200, Marc Kleine-Budde wrote:
> On 05.09.2022 09:38:04, Marc Kleine-Budde wrote:
> > On 9/1/22 4:04 PM, Csókás Bence wrote:
> > > Mutexes cannot be taken in a non-preemptible context,
> > > causing a panic in `fec_ptp_save_state()`. Replacing
> > > `ptp_clk_mutex` by `tmreg_lock` fixes this.
> > 
> > I was on holidays, but this doesn't look good.
> 
> Does anyone care to fix this? Csókás?
I do care, however I do not really have resources for anything better than
reverting both of the problematic commits.

If we do not have a fix, I guess this is the only way. Csókás?

For some reason when I tested on imx6 :-( I had no warning, now the
change was merged and while doing a quick test on a imx7
I got new issues.

[   37.061582] ========================================================
[   37.070203] WARNING: possible irq lock inversion dependency detected
[   37.078847] 6.0.0-rc4-00137-g506357871c18 #3 Tainted: G        W
[   37.087944] --------------------------------------------------------
[   37.096615] systemd/580 just changed the state of lock:
[   37.104160] c218f2a4 (&dev->tx_global_lock){+.-.}-{2:2}, at: dev_watchdog+0x18/0x2c4
[   37.116691] but this lock took another, SOFTIRQ-unsafe lock in the past:
[   37.125896]  (&fep->tmreg_lock){+.+.}-{2:2}
[   37.125921]
[   37.125921]
[   37.125921] and interrupts could create inverse lock ordering between them.
[   37.125921]
[   37.153018]
[   37.153018] other info that might help us debug this:
[   37.163824]  Possible interrupt unsafe locking scenario:
[   37.163824]
[   37.174714]        CPU0                    CPU1
[   37.181215]        ----                    ----
[   37.187631]   lock(&fep->tmreg_lock);
[   37.193110]                                local_irq_disable();
[   37.200841]                                lock(&dev->tx_global_lock);
[   37.209153]                                lock(&fep->tmreg_lock);
[   37.217061]   <Interrupt>
[   37.221328]     lock(&dev->tx_global_lock);
[   37.227167]
[   37.227167]  *** DEADLOCK ***

that just goes away reverting this patch.

Francesco

