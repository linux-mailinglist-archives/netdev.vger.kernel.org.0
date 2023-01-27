Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1848067E931
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbjA0PPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjA0PPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:15:03 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20721.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::721])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055D340E1;
        Fri, 27 Jan 2023 07:15:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVg1XEspNMojxFe/Ccjzlt+74YtEP5QE5kJmIVQjiZYwFfGmnVjHiYvuJ0QqPoPmzQWDA0paSiDtXZITNWUhiwxqNjp/bRsZ8lW3av0u4vV7aYD/52WbEASoOQQLvu8Km9tqgHoVynmemOXahFGOsv762DM+KYh+nTxJj4gLe2XUFCfoNOKIVT9795EZxwOp43Ums+IcV555CNnVLUOK8WvL444GprBbtyyKLKeS2W7m+dASrYcDBZuFBmgEllHUpTWEsyRFMOUB0nwz1TVYH93AhWrtoPHYS4reb7/uc847U1HnZmaV5jA8W3nmPgLCGwBe5r8X/ybQhMudiPZGOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6s+Q/S0oIGNxvMZEdApfs0E8S5bO5zaSvcnBzFGqJI=;
 b=IOZ64Oi65sEw8XTNCugxQDf+iE4z/DNqxRcir1tH4zduuo+lHlEdXsoksDYec8kqQrRGfLsexrStS15vo/snHFfAnGqPaI/IGd9eZLTkA4pwxNedNtmTN6z2DVwP3ymFXLpWa4Q1A9VqfncdMW8TcHhNr/jx5RjWFkuse7JUMTpk0Fz7QFmDd4+VSW0TbE7b5LLBhhTF/FGVs45AXsQQ/OnNU62BEKsitGrytKLI7zy5T6WzZUqBPDK4JIRDeYZfl6t+TUtuJFH1Z+KwCWPwDRLF5+Un0eRYb+TkROTVJyWlYnTfxfZbv80+FGIsUPrBTZtfHoVpjYafhijvcwat1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6s+Q/S0oIGNxvMZEdApfs0E8S5bO5zaSvcnBzFGqJI=;
 b=YiL08lD2G6MKWRti2dyTpMvVDbzQctMqaTl19VdZ1V0lj/IEhXVaX4fQbe2T2NnBJAsK4xmHgwt8rt1x8iVH0oCUUKN9BMzgbHHqxDmo71PA1VgndIrnJo5emjM4U2puEwJ5RsOYnKvarW2jHIJg8RXRFYVXpKOFgHAXrP/EKqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3751.namprd13.prod.outlook.com (2603:10b6:610:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 15:14:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 15:14:55 +0000
Date:   Fri, 27 Jan 2023 16:14:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        yangyingliang@huawei.com, weiyongjun1@huawei.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, lennart@lfdomain.com
Subject: Re: [net-next v2 1/3] net: ethernet: adi: adin1110: add PTP clock
 support
Message-ID: <Y9PqaJGwAUAZo2Rx@corigine.com>
References: <20230126133346.61097-1-alexandru.tachici@analog.com>
 <20230126133346.61097-2-alexandru.tachici@analog.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126133346.61097-2-alexandru.tachici@analog.com>
X-ClientProxiedBy: AM0PR02CA0164.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3751:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b243729-0325-42f5-c3b8-08db00793f46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HnYAUVOqzTdqPZ1zih5xzskD9VwbvM0l2MHJpNl4pPO9n8PGq8KC8gC+2MBLLHiZ+gwQUTYZUJz1P+jB+xI2FHAexmGdd0cRBmyD8mqsQ+bVkNCM4OpTpoiuHjA5H58yrvHuRJh0XKhAz2cpuBskfzhdUWQUnsH9c0oLE17kJvhysDsaByq5GON0GX4xO6YP6sxQsWq/W6sLouOLdsCT1GXSh9gIaXPoPTOlBENkSIVFIstbO863GZBvE1CrBPXiYsS7z5C28wzmg8H3I851Jkxwy0ivqEDqCZ7Dotfz3MNgXL1H5CNZmzXanMFsdy7wldW7X9lBWu56farOS93j91FdwJNArjGTbRoeFDMyxC9nXT4wL+h75HWzXqo1gMLVjm2YcMjFyEhJF/rsHXUMGEWJpRJtI/26T0RCenAuCdiVC6BwsVPz1tNAbI+6KigRlN/VfZAVWjCpAgMJD0mst+9ua9MK/ypMNI4g+6bnJV1zBGsYqHPabw+ebfdeKdi+xfx5Yy4pAehh0fSz0NJKHwLMAiXEnVuWcTlATyR55cq+5F77KfvlqP0zr5UWQkDc/AKvIDzpkT94gbjEpwwnuh9XvuJbZ7aDLCuKNe315Kp4wBrx5/lOYo2Cah4Qbo9GqqwSo6ZvinntW8PUJ5O/4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39830400003)(396003)(346002)(136003)(451199018)(7416002)(2906002)(36756003)(44832011)(5660300002)(2616005)(83380400001)(38100700002)(4326008)(8676002)(316002)(8936002)(41300700001)(66556008)(6916009)(6506007)(66476007)(6666004)(6512007)(86362001)(186003)(66946007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gpwz8iEQnLuPIjdL2Sj3UTFB/FrempFj55WmDF7Yxr9gSBweSJgELnBTwwn?=
 =?us-ascii?Q?LbQVxruQOTH5P+p2OPq+EZHUYrz2mSOVgnG5OnLV8THKe2jLiNVREuMNcmTq?=
 =?us-ascii?Q?UNYUfJ7FcNcb98N2OjKSB//o2PIauEaz+vHHNCPofzidSHvPpTPiIOQ6SAM/?=
 =?us-ascii?Q?EHCN7U1LHvKMPS81vxlatB0dfUaTSWvLUSakxO5Egl7ZeQXH+5STTb24npEL?=
 =?us-ascii?Q?UYN8DWvRcfgtS3it8w6CZKvZ8t6Sq1wzv6JbNaBiBFpKt69mtSZ3z/OOGPos?=
 =?us-ascii?Q?iKFcHMNhHjc1I6S0vqBNGgRhlIhE8iCW+a1Mp5OS6xC6nt9ThZZwfVED0CTt?=
 =?us-ascii?Q?dxuHvVDO3erL567jJ6MBCo+lmFij+Il8z4QI4V7rQ6X78rtY7phkUBxLf/+v?=
 =?us-ascii?Q?cGwHnCBaUTIG18asvQUol48bCUTUq/grsKYqjm/GRNEdrBwQHBLkEDMpk086?=
 =?us-ascii?Q?Stb3USnagKapOBhD4RWyiMm9c+HJaqWl6nXUmWvCjx/wgC00jfPyib/D3ZuU?=
 =?us-ascii?Q?0RT44RIUX5da80lIP72wPLwdzjaY3xXaCW3XO1t0cXQlIcLHCeR+4diPv7ry?=
 =?us-ascii?Q?MvIXphHzXW3NnuLegyibirmTJ2M5otp7VV5ZYDmEPjElE8jBAMSf93UJysoP?=
 =?us-ascii?Q?CUBtmTsi1hcgA1jrxviIig20cjueLgrVt+RwkZVdZ3GdKMqA9Q3wKu85i99Z?=
 =?us-ascii?Q?5atQdAMzjD4lBZc3UmNy9gG9+Vy9awLMztIWX8njrVpUW4t//nQQyyodo56Q?=
 =?us-ascii?Q?emLpneTAuwZ6fbeiLwnlAwBbqa/Vd6ntOcY62MR46NiXzc7K0lD7Q3EVmp4n?=
 =?us-ascii?Q?eVDSED50cdd6dKPGt3OKQnL5101cLk+H8omKOA+cx7PTMDOhANPP5XDwU78z?=
 =?us-ascii?Q?ith7KvnGZ+GYaVs2rxmjoGeE0RM1iylEiU5XZ+112c5v/mtEWPLCKVPz0o7n?=
 =?us-ascii?Q?gxqoK8WojVVzHeKa8DWq9QVy00pfItcyzk9IRTAAL7KHsUiBqeVM3P/lmydw?=
 =?us-ascii?Q?Q9w8g5rm73BZu+hviL74W1+aOTs7Eh35ou86lEIs3KgJKnOMpjPkhQCYrd4w?=
 =?us-ascii?Q?F3GUBeJW0qGaqb48ch+QTW6n6+do+9Yo1dMLVi4gq2pFHDT3tyHm+zyBI/4m?=
 =?us-ascii?Q?dN1P7mz/WNysp4X4cJ8tQR5DuCpevsfT4WLfI8VfQU+BEMV0YPGhamwv6k1m?=
 =?us-ascii?Q?3GAFYAzlSV/IxAxlMF6T/j8e0gz8PNiQ6s+gFuH2X7Z6Pe4wNwHqlbx+m9dK?=
 =?us-ascii?Q?zYgZt8gXpml444WsltQ6Bo4EgeSG3prLcdeRx9nJYUTc1HTFR+bwo216BFfY?=
 =?us-ascii?Q?4J5ZuJ0gQOHHhP/EQyYcBnIYHtR6pIya5OhkB/ZJROPrwjD9Nbjcm7i3yIJt?=
 =?us-ascii?Q?5SymfYI9mizRFwGuG8o7O1XI32xhf8inreYR+BDL+w4SpnNvtqoI5z2C1flG?=
 =?us-ascii?Q?cEuYhq0qy8UtWZj4tZeXZ42C8hDQX2BbTBjWvfvDQFgLjqZN7FuCeEGU2E/Y?=
 =?us-ascii?Q?Ykeo5WzlOQExmFbndoIOO+v019qnclhqdSE8JLDD3YQ62dNd00m88pqTlBVH?=
 =?us-ascii?Q?5sVIeoDiCLqxF5FHumGgt0/NFIXaxeGYjk0mc6Zt9oeCeC0BVxYLCdWVuFQ8?=
 =?us-ascii?Q?8fLe5yTyqtTwW6U4PKpnZe8eJFDxRoNE9+2IdOb/olMdJOFiYwkdrODb/m3/?=
 =?us-ascii?Q?QDIQPA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b243729-0325-42f5-c3b8-08db00793f46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 15:14:55.7733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2fogo38GRi+b9gJqXZTVEk8f+jVUmlrSSiNAh1jMlRL4X/p8g/Z2LsFSFjm5rCyU+wITfG2C1XTUvJFnenyTBHmoGobrxb0KvH5AA4pD7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3751
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 03:33:44PM +0200, Alexandru Tachici wrote:
> Add control for the PHC inside the ADIN1110/2111.
> Device contains a syntonized counter driven by a 120 MHz
> clock  with 8 ns resolution.
> 
> Time is stored on two registers: a 32bit seconds register and
> a 32bit nanoseconds register.
> 
> For adjusting the clock timing, device uses an addend register.
> Can generate an output signal on the TS_TIMER pin.
> For reading the timestamp the current tiem is saved by setting the
> TS_CAPT pin via gpio in order to snapshot both seconds and nanoseconds
> in different registers that the live ones.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

...

> @@ -150,6 +188,11 @@ struct adin1110_port_priv {
>  struct adin1110_priv {
>  	struct mutex			lock; /* protect spi */
>  	spinlock_t			state_lock; /* protect RX mode */
> +	bool				ts_rx_append;
> +	struct ptp_clock_info		ptp;
> +	struct ptp_clock		*ptp_clock;
> +	struct gpio_desc		*ts_capt;
> +	struct ptp_pin_desc		ptp_pins[ADIN_MAC_MAX_PTP_PINS];
>  	struct mii_bus			*mii_bus;
>  	struct spi_device		*spidev;
>  	bool				append_crc;

nit: I'm unsure if this is important or not.
     But (on x86_64) the arrangement above leads to a 7-byte hole in the
     structure between ts_rx_append and ptp.

     Probably there is much scope to make adin1110_priv more
     cache-line friendly. But in this case an improvement may be
     to locate ts_rx_append immediately before or after append_crc,
     as there is also a 7-byte hole after append_crc.

     Likewise, I think there may be room to improve on the cache-line
     friendliness of the changes to this structure in patch 2/3.
