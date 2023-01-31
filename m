Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38316835B9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjAaSyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjAaSyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:54:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBD6518E2;
        Tue, 31 Jan 2023 10:54:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfyonGndwonUPWG59DmXsY4EZAUi6GCr94USXNyCP+FFkSp+VGhtGoeHj/ax6Lb+w1m5zdFdTXWEjOl6m0d2vKRuZIeknnQYLBqRBaK8PxGnMJbm9XdDZa3ek1M74H9tsw2pRjQrRkYacbvmlEh2e2Pih9GhV5hzz4zDeDk2jkDDr/SNJ7E71nTnX2OKETrMtBPtGVLQ/Mo8bak3Nzs6KlQCzguIfHgsnqQ3/TH77JXzgTxC3GEqfKzL9A0UCAC9hXk0gAEECpx1UBja0l9do6FLNugJl7cZ+1fmTiZ2R8I5qaPQWvwWcRBr3LiyflGOjoh1ixuG0+QalPmdLm6v3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j58njQuoQwqmh6mKcmxIbKhNgIQ6/3Cj24dZVcX2u9Y=;
 b=QTRb79rogxfTeMmSXyNLqz8Yxfs40rsNTT96IgWsT3zHidTindpSanUfeldmkM4rereQ7YuOer8odIWvwRmJI+r5ynka6f/SZgBWBftT79xcvB5epbDplRQtadH5L8H5r1eSTubRkuEcuzHzNOf4LJ2KrygGLQqgy4ocAkKyOydgGqY1go1OavFdu7+9rOppZf0Vie6C5e/R7qv6fLwwbHC6LI77ITeWbcyItgFCd8vdftUyQV239dZqB/Y2rJDqOLREhGxWgmYA1J+TZRmuiL9KooNrFkMXc/0d0LM2e0jGUdN4jbz3F2anKdIJx3MgnUSuEyg9AYLZlShE75uh7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j58njQuoQwqmh6mKcmxIbKhNgIQ6/3Cj24dZVcX2u9Y=;
 b=ksv702ckHVR/g+jfPAitT8rjjewWgtRiuY6GU9eqHwPGEL84Z13gSPQEhl5Zkbx1PJAthEWf1OnFiMyksvQFM+GKHw599XDFoy67v6If6fRmctMnZ65Wii+N4SKb18IJQIIvxRiq76AIn5FeENXSeYi+cz9jKNVi0h43+u6cPhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4882.namprd13.prod.outlook.com (2603:10b6:a03:36e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 18:54:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 18:54:47 +0000
Date:   Tue, 31 Jan 2023 19:54:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 3/5] drivers: net: dsa: add fdb entry flags
 incoming to switchcore drivers
Message-ID: <Y9lj7RJgyMJfjtGp@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-4-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173429.3577450-4-netdev@kapio-technology.com>
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: 254d11ee-252a-4413-fec3-08db03bc9f93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+xZseOXLepgiFEmVx8xj5JDRJTe9vlzI0c8AFCPfUVhy4pwqZce045/AwbWMo7KrG1R1YmMWV7z97MAPTzi4wXVAKfotpd6f9Ip9hydCljEEZ8G2tv8Ap8j0Z09/p9osCrR4fxBOzlBb3S4novUvgPGmmNV+09bYvuPLfl2kvYbGn5ja7EA+mYNEAFhWbRpdYb21kJGtGMwqJLJbvC+Z7J/YPy52h9k1o/QaFQsTVz3BFa2M9XLBKUw6GlWMkyII8w9onYjFCoIYYp4Ml8hvlkGCafl+uu2Fu8mGHCGVMQA1xaLNYGSiSja1t+V9iHXx/cY2zYNsHS/dQA0NLmyTseBGmChOMfmie4fj3cDYNxtFc6wGX4ji27yFLupVdEM9HkSmUS2QbWAQOI0+wn+SeVBkurQS8ebgDFe62PrhYG1uhO0STbb1KGXcawcz/N3ss3u9292HEQq5UPmokVjDb9jHwJe9ZpNqk2uD/92VDusrWoECw1QjGLoBX8d8BzeSwlJhOILtEhKbKx3udiHEJsR88TIu9jgh/5ti3jMslVuZMmiWKw6YA3qB4xz0HAtOmz+wiTEgmXVWflzttY/3kfbNTdvaWIgpkwYLlD7aTbIbdJHvZrLPvck2vd6GEVTRKBJxNlHwdh3akWcjQUyjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(346002)(39840400004)(451199018)(83380400001)(6666004)(478600001)(6486002)(2616005)(6506007)(6512007)(186003)(38100700002)(86362001)(36756003)(41300700001)(66556008)(8936002)(66946007)(66476007)(6916009)(7416002)(7406005)(44832011)(2906002)(5660300002)(54906003)(316002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ibBdCzLQGrc2pkJUxhWG0GZvGf8WRo3wD8d2/NsllovJ8HA+TBE9FIDTgDt3?=
 =?us-ascii?Q?F2AlvRDWkULzTx8frnzCkd9BgwAlA52y2GmnHm58o19V0oW6WqfGAiPbuFJP?=
 =?us-ascii?Q?GC2+unZVMrQTwQ+SQYaDlcQyK/hdo5ukoXqnm+u73KFnVU1GXVMAhr11wKDW?=
 =?us-ascii?Q?QxvWA2AvsV+zGylEJ8LKYhvnUiHM2gY2i+fMkgUQxBCHvuuxwYuhEuP8uZRx?=
 =?us-ascii?Q?nh7vEOqZd6UhopiUMzrgBe6zjQhyzPQ6BobiVtE0S77pGqURUnBTdMCrjJAE?=
 =?us-ascii?Q?CIQQjpScaPiFNm15keAa9kKI39S3K1MHEyLtxK83QoSqVXSnKUaP/P8KJ8QJ?=
 =?us-ascii?Q?HaLpcx2+Kqy3WSDMiCLg2kjAxgVK6JTJ8wZn1Ule0mgS68ArEjW3aS3mcxTG?=
 =?us-ascii?Q?pdfwyc8iI6w0Z8ATZELn/E8laZLuvsSqLJSli1bXE4wm6VJsbIsL0fu2QaNg?=
 =?us-ascii?Q?gM8wnEz1IytpN6Ie7ShCdTk96DXwtOeSNuFhlxBlRCWUvsFEiJz3KbX/juJU?=
 =?us-ascii?Q?Av4NxR88lVaDhGh+v+bb8e/spBZeR6PFGE4oFwGkD+zwMFSd51dLD+UQbVxp?=
 =?us-ascii?Q?zjgQiZ9RW1UrhT7fCYHaf363Wbw2WhA3Rcr+8WG9JwuHW4d/Ao8953KnZFTJ?=
 =?us-ascii?Q?3tLMiTkbZdBM6cPeZIyYajXoqT+6WccEYWykia2XJgOccv3iEopybaZdh9zo?=
 =?us-ascii?Q?cbErFRzwG15Fv7Y/py95VsAwiI5HVfqwIu9Meu9Sv/5tsQioZW+wMMffO1VJ?=
 =?us-ascii?Q?AioEFjIrotMMFERv44DBcH3IOjQJ6aJ5ovAFQvjCKW2bt/Z9WUsh/swQtIKe?=
 =?us-ascii?Q?hZ+JFKUalXpPwvip7Wa5KIK3HuoiHaYhshBBj6mmhoBYAYBOr8TdQLnId+B1?=
 =?us-ascii?Q?v5C42YYX1gOdFytHT+ROTNncQDLXGkpUHhs6pLLjB+kifqY67BDD/VCF4GKo?=
 =?us-ascii?Q?ykGUJ66KgVi5MyhZyrmIdPJEWvdq9ECRY9P18HynYR4gb0j+uOJPjzSevANd?=
 =?us-ascii?Q?TOsbDJjO81Z138iwiJV0v20nwq5/wiOmG3nA5fYXnnAq6pTqJz+aj8YHuu8p?=
 =?us-ascii?Q?+3YUsmCmBkCWYsdRimANRdJAYZBtzlakmuL6DE4bnk4YcAekFrr+DjVXrV5Y?=
 =?us-ascii?Q?4kucrygCMm52wY+1GvRoS05gxES4nrtszo1bTgFkiikziuX6nWfCHV4GepY+?=
 =?us-ascii?Q?5+F6RWx63QMcibF9mklfOaLtDSuav8SV52rMQLs2walg1FbnJrb6egBuVmVq?=
 =?us-ascii?Q?o/1jqt97/TFyJAQ6VQ7YL0AXNXT7+XrbY57rMyxBA1XxqWuSIl9cwq7qda5c?=
 =?us-ascii?Q?EGwOjcHoRX6HDBDDSAI73a+mHEizsdd8NFD1KltzpgYFyMZ2EOU3P19zRQA3?=
 =?us-ascii?Q?1S4pKZBH3Y6qTdYSRwjglrTOvP6dLcjy7gE7qYktdk6018rpZqOWV663oURP?=
 =?us-ascii?Q?pnDvopsFISGz9Hdubk/cNyUej4Unwfv/EB1sRDql1M+OuqF4ssjiYIPhbnzu?=
 =?us-ascii?Q?D/niVgRZpxxOd8yrdHQUVQnbQY3ScSvNJ2IIsoubsZ7YaCK4bp8i7le+oclM?=
 =?us-ascii?Q?d0Dd1lkEdI0GcG4a6nar4HG0hxL6qREFhPe84TRJnD9jjaiwa7b5VxLGpQ42?=
 =?us-ascii?Q?juiwx1P4amLqJAWk6ZXmVIih9/mrXRifghmk+7X6muDvoVHaxZYGyfWmLzlO?=
 =?us-ascii?Q?kiSBfw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254d11ee-252a-4413-fec3-08db03bc9f93
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 18:54:47.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayAiUJ3J182UlcLD6eninUK5ELol6ZIXjqUsI/hvjAon5r65SZNhxCR9ra7t0JpQDPiNBLOqTv0IZluoX/spqggi4c5njmhKR1TFgRGCiME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4882
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 06:34:27PM +0100, Hans J. Schultz wrote:
> Ignore FDB entries with set flags coming in on all switchcore drivers.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  drivers/net/dsa/b53/b53_common.c       | 12 ++++++++++--
>  drivers/net/dsa/b53/b53_priv.h         |  4 ++--
>  drivers/net/dsa/hirschmann/hellcreek.c | 12 ++++++++++--
>  drivers/net/dsa/lan9303-core.c         | 12 ++++++++++--
>  drivers/net/dsa/lantiq_gswip.c         | 12 ++++++++++--
>  drivers/net/dsa/microchip/ksz9477.c    |  8 ++++----
>  drivers/net/dsa/microchip/ksz9477.h    |  8 ++++----
>  drivers/net/dsa/microchip/ksz_common.c | 14 +++++++++++---
>  drivers/net/dsa/mt7530.c               | 12 ++++++++++--
>  drivers/net/dsa/mv88e6xxx/chip.c       | 12 ++++++++++--
>  drivers/net/dsa/ocelot/felix.c         | 12 ++++++++++--
>  drivers/net/dsa/qca/qca8k-common.c     | 12 ++++++++++--
>  drivers/net/dsa/qca/qca8k.h            |  4 ++--
>  drivers/net/dsa/rzn1_a5psw.c           | 12 ++++++++++--
>  drivers/net/dsa/sja1105/sja1105_main.c | 19 ++++++++++++++-----
>  include/net/dsa.h                      |  4 ++--
>  net/dsa/switch.c                       | 12 ++++++++----
>  17 files changed, 137 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 59cdfc51ce06..cec60af6dfdc 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1684,11 +1684,15 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
>  
>  int b53_fdb_add(struct dsa_switch *ds, int port,
>  		const unsigned char *addr, u16 vid,
> -		struct dsa_db db)
> +		u16 fdb_flags, struct dsa_db db)
>  {
>  	struct b53_device *priv = ds->priv;
>  	int ret;
>  
> +	/* Ignore entries with set flags */
> +	if (fdb_flags)
> +		return 0;


	Would returning -EOPNOTSUPP be more appropriate?

...
