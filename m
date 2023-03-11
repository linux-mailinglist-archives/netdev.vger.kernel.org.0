Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E8C6B5BC7
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 13:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCKMeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 07:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCKMeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 07:34:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20729.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485FE118810;
        Sat, 11 Mar 2023 04:33:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDhs4wCHE0Tx+yJ1gcEEy2E2Oy9Ppb1xe/odNACPvm6hVI7xSSUsswuq4KOsuadwHWT60kR5kChYZ2L1CGkt3GAqBOFvpLM3yy/4KiXLXK91lckOrkS4SE9294XU+sMhOL3jl1KIupVPPRgWZkc+TOghQptD9GgMDS7Oill9uD/Lcln+z7KNrB2drpQIwjuQf/twz+FuOClUwIITvgsj/xXgsIz9J2RGAatwf5ez4bdHwNNLK5KnEuyPiDbLWjoffRYx+ifg+q5mv91BaRFRAnNA4x8C/620zs0S6dAixYUmiUVGEVCikzgU70BdIyJpYndKm+0hzxKekRLTOGOFhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=243o76Sa2ZSJysL8qAgKomHSEQI3g8nsUtlHT8xXwF4=;
 b=h+jmZWRLnW06IVhDWK6Kwv3VJWGMyGDOc+qeivG5WSs3eUewcPXus1q0o8izE/sA+cBJdUWgXWz6xqfyzNe+yIQP8CjkHpSfik0dtyFdz5lFmHusMqZF0F76MbkJzBsznazFgop6pvL4SVYeZYrSJzGNDlEHluP08qzDKa99FVN+fhtOemS7q9PUujRk4wXw61R1DdHtXWFS+EtAgd5UHXAFVnBPpxsV3vwR25Jpwj54yt8HJD0/xE1WcXINoQdnPd6QPM/wN/FTsZ9PS6PBNO33hSMjFtbQ8PV3dZ/q30h1Z/7Kad5yeDZ3DQkP0RJ4CwOUSwrNbjT+lcuFTushiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=243o76Sa2ZSJysL8qAgKomHSEQI3g8nsUtlHT8xXwF4=;
 b=OJqfhFqNiYdYLjCAhucQMAv4KKFx94sunWnCK7kb2M//6W4cb5xOpZKhvMoeIYvXE/i/lbb/9Hx/gLyi7KZwnrF2okt5fY4kd6VvRUwjyn8nIBQX4vhWNS4pKHsM0dOCu2x5+GhTbykgPpK3qOxlRnyyoJBo8XnjVY28wCVSYOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4766.namprd13.prod.outlook.com (2603:10b6:5:38c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sat, 11 Mar
 2023 12:33:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Sat, 11 Mar 2023
 12:33:49 +0000
Date:   Sat, 11 Mar 2023 13:33:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v8 1/3] serdev: Add method to assert break signal over
 tty UART port
Message-ID: <ZAx1JOvjgOOYCNY9@corigine.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
 <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
X-ClientProxiedBy: AM3PR03CA0053.eurprd03.prod.outlook.com
 (2603:10a6:207:5::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4766:EE_
X-MS-Office365-Filtering-Correlation-Id: c3e35043-6505-405b-f741-08db222cdd6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAkfuQ346nGdjw9pVPVyTjaejWgkbR5wjRCUeUBbMLA170BRM86d++4NZ5Gt0HGs8YIMBN9lEmeS6ZSKFciARXFAkvsgXtkOjtRIcVxSy5dudV7YDQlD8K5/oiRuRJEp5dpUeMTFczaPZ7p2g7oi/iaprxuAjqUuLfKZ4phl/61ccZrUEs8I3gYOIztEGdxNuHtXKWgtABanG7nav1PKK1DFc664gEwfgQoLmCmOut7598dwNQc0xw1ZpSuv8wJGOffVvIF6HHYdBiwVitDKrZ1JDz7Fb31zzbVOzkLajTqexKTMaLPbk6YR4a5h1Fow06ri4DEl3E/nInh3xdZ4nQQu6VgOsh9mA4da7IwliMIRZwzsN1yziMT/RCkrimUK4P3AlaxwaJcK/6L2dNP+lWctSbSzAoSXAMUaHTgA/S1TjDSsCFLHw4uuguIlpeiicfrfbziDwY7MsPdVsTTxdp9UsgrFbeYurzJJUxDt/UbNJIf3wK2QZcMXc+K+a2BO4ivXt8cpz27yeOVl3CQojGn00suH7tKEjMyUPQo+gJ9iozYTBgH6X/q0WzemcjKls0DUfDRwJUuEe9Vvmd1zhS+NoBwNhJ8WlQt+bV5SHViMGwhr4nhP2eSdhFEvdp6jORWBbaWqN2ck6upYqPG+9TaokmvRX67dwCR5yUfOrpXU+HTySAvm/I8worlfC0Gj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(396003)(39830400003)(136003)(451199018)(8936002)(7416002)(41300700001)(5660300002)(2906002)(44832011)(86362001)(36756003)(38100700002)(478600001)(4326008)(8676002)(6916009)(66946007)(6486002)(66476007)(66556008)(2616005)(6666004)(316002)(186003)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NY1TizAzkW9O+hugywvI/0VyG+LHP7amy5VBHLroVuumqgeyWrMl/PaHGn50?=
 =?us-ascii?Q?hiqVanscinR2uNY1qdL/33kGOzuK+OVjKo4XL7HodDDRBtYky4fdkwUjM024?=
 =?us-ascii?Q?JkIQDlc7Bv8AdsDns5z2vRsgnT6KWOcNngfcqaC9uXcx2YTRtHJdxEz7N8Kv?=
 =?us-ascii?Q?XJ98iC8R3h7hVZCtcdXgd0WQsr5dy44Ea8Ox1yYqUK1n3iOCWdN6TsBiyyVe?=
 =?us-ascii?Q?8hd5ifAFl2ljX6LyEEEmUcOc01+5/EX1bIbgM25XNf7U13JEE6Nzao8TR15y?=
 =?us-ascii?Q?vIjNjP3SqHx97nXeTOx4E0U0flypIqYjE7VYzhYmEMMNEVOzp0w3vnUQxcpd?=
 =?us-ascii?Q?Wl+AkxeZ7xtnce6sttiNHULcAWwbGP3aLvdW6yDe+SCQAZUqVC69et8MULjX?=
 =?us-ascii?Q?kDYBYDDnVdxzsPcssb3BKYH0b6KoU3JCYUPgKAT32DzwQsxq1nthPKiF4EY4?=
 =?us-ascii?Q?OQxJjH1UfqF6K1LjGLx/3TVArIib9VuUV92ysSF7ZsL3S432UgZLjELw9gmD?=
 =?us-ascii?Q?/3IMpt2Ka7TMw/rJWuXoQCi1WrYSF+MqOXuijTd0kk6RUUHd8PVbm/KDqRri?=
 =?us-ascii?Q?Oxvmxp6TukgSTniDB/Qt0K4o55//HnWi4lQA52chzhPXW1FI+IBjbeqsIMOM?=
 =?us-ascii?Q?GdFNCk0qrYW6AjW3AGzLb/AkIFeCELOFe5pRKjaQsmwGiVVU3lHgN03L0j4I?=
 =?us-ascii?Q?sDHfDfph+rxrqaB0OPXHtKcZu7gpy3YFhpW8Dbwj9dSry/xoYZxAxD313Jhu?=
 =?us-ascii?Q?cAFXcWXbS1xih1JWawYSH/sjc6c+leKIuv1VXwnFoW1TIhBr43Ce2rJhkxWc?=
 =?us-ascii?Q?KMZbr4ZhTiMi7Tbujbg60OBZ2yhXwopUwLjyYMPb6D9XOsui8JaHXGso4enn?=
 =?us-ascii?Q?bfscplVuYkgoRuTTM4QUCLXccrcwNbbE3shNnnFtcsByPRBQJCcA7PJbUVgZ?=
 =?us-ascii?Q?CGa/RFQPQyhjMoNTtDnSfRlCZhuQu8xOvXuH6S/8PiKjxigiY8fL5vd+dDrv?=
 =?us-ascii?Q?iAfXaji6NZsi9qmx3PH+yWBRmC23E2O2vc7Am+s6Ppr9kO6PAF10xG4Rb8nS?=
 =?us-ascii?Q?GcsJItOxPyTYc6wDY/8/uU1AATfQvUMOm7tM+E2MrVcAHtXVkCL3LzZVvT1s?=
 =?us-ascii?Q?mBv1ZQjW7Gf3U1lQxrAKVgtw0GXfFoXe+bGQuHf/j3eQ7Xo9xkZ4NDP25Q5u?=
 =?us-ascii?Q?/x1i2jRTs4ufEmzQXmcYVsyoIpAK3lLSorxgW6CX9L1UZflRfS03ECvbD+RL?=
 =?us-ascii?Q?8yhdUDizipV+Gmd6cYBd4i6LLVn+Xst1KhyUSrJrTjfLAdTrAK4JjehxZeKZ?=
 =?us-ascii?Q?jkD10M8l3RvYZ0yF7A7KgKQke1QNKwG4QVKHwwm0nw7E+8NJ9WXYR0T45/7w?=
 =?us-ascii?Q?OQJiiS33XLXUHb5FxlhzzP7nvKk7/EbVLoRhb9rIde6LatwrdGdHjn354iYa?=
 =?us-ascii?Q?16WiLw+GITshQU4ioFRKACoYiUXh1JktG40fDs+5Qk7BPrwp6WOz9eS/g+jh?=
 =?us-ascii?Q?jsqAYdb6MjnmbGVski/uOMZA2CPi0t9KLZkaU3otx+VYCcWyIfsquVcWV0F/?=
 =?us-ascii?Q?LHuVPgew38/9XGOa2m2s56g24xMU4hORII5NMtb/VC9N34a5hGGunVLzPhGh?=
 =?us-ascii?Q?FboV4WOJlWKjeXPVSvFQrUlMWjZJVfDptDIzp9BHqdheBjlqFT1TQC6ZUIxY?=
 =?us-ascii?Q?AiiP0w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e35043-6505-405b-f741-08db222cdd6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 12:33:49.5905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynIZBydM4dnQMZS/lZxilEt8oIX/MVMXUfFP4pOeN6i7wl7nHc/A/3AwgMYEV2oAoZLByvm/2QpM0YtyX7heWFmJtRdaBUU5qw6yaRwjf8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4766
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:49:19PM +0530, Neeraj Sanjay Kale wrote:
> Adds serdev_device_break_ctl() and an implementation for ttyport.
> This function simply calls the break_ctl in tty layer, which can
> assert a break signal over UART-TX line, if the tty and the
> underlying platform and UART peripheral supports this operation.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v3: Add details to the commit message. (Greg KH)

...

> diff --git a/include/linux/serdev.h b/include/linux/serdev.h
> index 66f624fc618c..c065ef1c82f1 100644
> --- a/include/linux/serdev.h
> +++ b/include/linux/serdev.h

...

> @@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
>  {
>  	return -ENOTSUPP;
>  }
> +static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
> +{
> +	return -EOPNOTSUPP;

Is the use of -EOPNOTSUPP intentional here?
I see -ENOTSUPP is used elsewhere in this file.

> +}
>  static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
>  				      size_t count, unsigned long timeout)
>  {
> -- 
> 2.34.1
> 
