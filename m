Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F09D593091
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242903AbiHOOT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbiHOOTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:19:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2116.outbound.protection.outlook.com [40.107.237.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3BF22B35;
        Mon, 15 Aug 2022 07:19:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mY2m5FNQyvyCi3y9eqZB4fVZu9zCBPdhI1GuyiM3hfMnvKyeAlG3pxL1v1redAS3vQJTJpg+evZTyn5cV7ZPztCtdD+9jUO+haj3GkwWd+4ceSGJXYsnhPijdRy9KcmlfrxqcsuhDWwJWHGlWIIdEzdibZoAhST9EgeOvXixw2AJZ70rGN7WUCMaW0ELDA0bfSLbzixByyF5Hb3QyQbgbDoy3zYO4381jXppEkMQIwuZ7T7nx1opPdnxzzKJcm9MLULJDDic9lvZREy6yCAXxnyk1XsTJARSqVJaQL6LbdRxcdhuGp4fIuhEc25ktIrW8NsfNQyRIxVaZWF8EFhLLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mOW1wKU12L7UO6zkSVsn0AoLnI9a0BT3CW6qSJKCj8=;
 b=f7ews5b3fvVEOGGEtTxfe5XKsfv9IDwCm11Iv8FJh/ABuM6PRruioyu3sEiwwBadtgM12ARliUzY1BXOdXeVyMlc/Nd/n9XcioCA+35fhfKliY0zIW7ykr3wXNjFbZ35htMnfhiyPyEWVc9ij7DzuzWSEJzwSLnq2UzY+kF83Qjk77sEARlHqQMQCKKVtwlQiEMhp8tlMXMM/poh3fZUTQuzqTcLj88zn0gIX5iwFsysXSZXhXFQUqqAWOuDlS3Y3nZA/HuakOc0oJThrfwPk3kygLMlyFPsNpAXrgecbccB0S2fWP30M8IoMvNONSfhjSBi7+SlS9FXp5XQqX5nEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mOW1wKU12L7UO6zkSVsn0AoLnI9a0BT3CW6qSJKCj8=;
 b=QHQYgAFjKlvDKCZSuZ/s9iVc8Z1oiQ2HRpP28jsVXqnrE+SRGqtq+7GDfrajLXXTMit0R0Vt3FGKHpQIKsRqOLungCarL9OZmR3/uQMUl7HuorY10uCMVU+8xrMvIfaPKfcTU0C4veLyhh5/F0iNzs5MByy42z0hE4sjkyWTWMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5146.namprd10.prod.outlook.com
 (2603:10b6:610:c3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 14:19:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 14:19:19 +0000
Date:   Mon, 15 Aug 2022 07:19:13 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YvpV4cvwE0IQOax7@euler>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815005553.1450359-9-colin.foster@in-advantage.com>
X-ClientProxiedBy: BYAPR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::41) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4de9742-1e4d-4c12-f63f-08da7ec92434
X-MS-TrafficTypeDiagnostic: CH0PR10MB5146:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdQQNtLkwgs+nDIGL1f93d96XZC86ltvhelArL+mdyQekX6VaTIpBR3h6LHPL7rdf99cyR7qRJ6Bt29IGhE5v7ypx02KErocmHb0xPnSfSIamUjhhiqB0ceIBLja/79MM8Ru3/yY83dVo7Jq23tWnwlV42St/mnoUjWBeA7+mzvO7nSRTY4Jc4Ei02ZLDm7zpnKJJtYm7laQShHSe9U/Cu5AkSfXqcTZgxbN+4ZvRE3UFg2iIoWNcHUtrCcCPhgZ+1vF+RM0K3cCiOGbRII/rMa1DYX3hJm4lMpIH3Czh1r12z4H0o8RckEPTVLD8H8qMO+KhVjLPGsP8iPclPNmLtEb14Ci5I/7AxAuO1klh7evg9EUrHGKApmtetyKIMtuN7TYKup7DSY0wiCoJdB9qzlBoM7byRV+tI5iynmgklGiTg2tEetldXyidj1Shwo5ItfLLl7X/NFsDhVNBQkYbQFkfTLdPthJ0VzpSFWh13e+8N+X41xnKhdFVPpkXJYOaUO77xd8flpHAgIY03g1PE9xe1KECDswm3qEHP20C4fBxIZ3W3TDC1RAtcZajP8koovN6AAuaKqYgLWyGugKHCISyMDNLdlFNAGSTxQhXpUJ+6KMRnf8sQA8fj3EsPzJ9K8rgSjRrekaGFjafKkPIyHHnRCX3Qqwx6EPnp1cVJhdaON+OzdHEAUZ3+oGB4ct
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(396003)(39830400003)(376002)(136003)(346002)(54906003)(9686003)(6666004)(86362001)(41300700001)(6506007)(26005)(186003)(6512007)(83380400001)(316002)(33716001)(4326008)(66946007)(66476007)(2906002)(66556008)(6486002)(5660300002)(966005)(44832011)(478600001)(8676002)(7416002)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GwIt56T2BHYodAiAdIIEOx07IwvRRREPa0u+6ZCiO8fNp7bRK+KnnnyR1YV4?=
 =?us-ascii?Q?2vPpeeB809BdOFrQnD2QHk+UCP/u8W6NLN2EtdkzhE0CecTgfiEODYS64Z8p?=
 =?us-ascii?Q?4mp2bDPTTD+aqOJgdNGRtkddpHvWf3nX+1RpdVBsmUy1EJxM7s+voyVqPP4q?=
 =?us-ascii?Q?YHZCrfPey3WmpkxiuGXuuushhFpYuw1R/3v3LPnZNnWXFhrHcB4I5AbGo1Vt?=
 =?us-ascii?Q?lE0K9Q/SLMg7Gr3arb39iMUAqztMxm8QpaJHDw7rXDjS/7/CSHPTOQLoSLsk?=
 =?us-ascii?Q?d8I9GjD8XwZl8ukoPJrlJKg/i0VbiSWDlTztGeXdzXTXZrsRXdPwsJnMy9Im?=
 =?us-ascii?Q?pPMYmDi5PNDZNa2sbjDGsv2g7Rq4UtcKS4AJgSBPwSg0d7hI+Y1jZY0ZTRJk?=
 =?us-ascii?Q?FAvpmJ3KOhOM6aW28u9VswUv9TilwXQJZtpfogL45B/Lb5dLmsQFZ+AGlBoP?=
 =?us-ascii?Q?RJrx05mbh942cuoOVUHA1aptKM8W8pxGZzAmVG9DeCQP80Gye2HrNRegjdb7?=
 =?us-ascii?Q?EPUaILBKIrSOLQNylcFUk3YRsd0yAo0989i2OosUjDrhfH0DChlSVedY4P98?=
 =?us-ascii?Q?2jdK1unshrp7nB/4y8LSuK1wZ+S7c2BXIQZY8ZMrng6u7m6FYTZDiKuyDIpl?=
 =?us-ascii?Q?vKI+vvg4vA6bEaAVr/4szDbF4X+W9sMk+49/QfKJpIj4SBH+cz05qWYxkUcp?=
 =?us-ascii?Q?bXWQA++B5cm9KchYWm/+L0AxAUwudkF+l9hgE0iLr/hP2lGvzocHhkJHlah9?=
 =?us-ascii?Q?Jk/GGhoGYjeIbu+t/fSfOu8tW0ykPk+hvD0zfWLJgq2EcWl3Np6/SgZ1kSDu?=
 =?us-ascii?Q?yZ1083O4O+Ss7WYX78G+PNzHzDQNtyDRuX7xofW0ZsC46ESukd66GNgvJ1ms?=
 =?us-ascii?Q?ahGO5bSNChw90WJDj5yyj505/BdDDq5Z8sZuC6TpWUy2p1DGQ9wLJ0t1EH2M?=
 =?us-ascii?Q?RwTZxcJX8gJK6OH2p94pgdAnCFKAff5TJ+vqEctj9DFTvrGt84WxzR88zgMu?=
 =?us-ascii?Q?34SFMxfvV/cn6xmeM+tZ521wteYi4i2uFwngZG451mZoRpUVVwbhtDBdP2Zj?=
 =?us-ascii?Q?xf0QjetoHArSerkuCqnTQvZR4EpscxKX/g7cfy8HwjL2BLo2AbHlg4npOtny?=
 =?us-ascii?Q?W/0smehSP2Bs/UdGJdOW8HiK0dSYTiKv5FUXFLlM1kEG2SGT6k8zLHHRhrxI?=
 =?us-ascii?Q?GQnZCFfV1OP3iH3w+cN6ymiJI9sZvp4x7qcOASG5IxWXJnlv4z51xEFkq5Kw?=
 =?us-ascii?Q?3O73w1/iBiQ8rQFekEZWtauZ+vlwiOh7D204m/EsEfYnHFLQlcyAQFf9iBi6?=
 =?us-ascii?Q?eLD8sCo7Z9MzUoRB8sIzb2GOnqGjg5298utuExZmMustm11LRQxo95+SBSVf?=
 =?us-ascii?Q?uGoVcPVnoRm/rlq7WuBWWy9xRRnRvW1e3Wj8U+/PVJe0BBN+AlYFutdcNz36?=
 =?us-ascii?Q?1Ec3D1T6Gty8CPJML+4SMSBTTu0EwJ2j9eb7mhFGIYFdf1ApFrOehrQzlH+s?=
 =?us-ascii?Q?Xjgt3mixoj5Ognm5k468T+oQgR0Y7crchqJT5PK5z8cbi8WgPFWT/UyksfU0?=
 =?us-ascii?Q?JLah9OeVxuyl86ryCEAKBEM8ESi9Wr/ZSnzefN88W3Kc/Pq4mK2+qRYPixOl?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4de9742-1e4d-4c12-f63f-08da7ec92434
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 14:19:19.0135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnUghN7sQZFSzD6AawE/X4F6/HF68Esv5g6iFLufmlbOGJ0bHEgkyPzb8/nWSBtf/UQ4h9KCguBepF8EqZMmne1mZ4EZCWoccez/Pdzu5yk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5146
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Lee - My apologies, it seems like you got a new email address and I
didn't copy it on this series.

On Sun, Aug 14, 2022 at 05:55:53PM -0700, Colin Foster wrote:
> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
> 
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> 
> v16
>     * Includes fixups:
>     *  ocelot-core.c add includes device.h, export.h, iopoll.h, ioport,h
>     *  ocelot-spi.c add includes device.h, err.h, errno.h, export.h, 
>        mod_devicetable.h, types.h
>     *  Move kconfig.h from ocelot-spi.c to ocelot.h
>     *  Remove unnecessary byteorder.h

Something is going on that I don't fully understand with <asm/byteorder.h>.
I don't quite see how ocelot-core is throwing all sorts of errors in x86
builds now:

https://patchwork.hopto.org/static/nipa/667471/12942993/build_allmodconfig_warn/stderr

Snippet from there:

/home/nipa/nipa/tests/patch/build_32bit/build_32bit.sh: line 21: ccache gcc: command not found
../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
../arch/x86/include/asm/bitops.h:66:1: warning: unreplaced symbol 'return'
../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
../include/asm-generic/bitops/generic-non-atomic.h:29:9: warning: unreplaced symbol 'mask'
../include/asm-generic/bitops/generic-non-atomic.h:30:9: warning: unreplaced symbol 'p'
../include/asm-generic/bitops/generic-non-atomic.h:32:10: warning: unreplaced symbol 'p'
../include/asm-generic/bitops/generic-non-atomic.h:32:16: warning: unreplaced symbol 'mask'
../include/asm-generic/bitops/generic-non-atomic.h:27:1: warning: unreplaced symbol 'return'
../drivers/mfd/ocelot-spi.c: note: in included file (through ../arch/x86/include/asm/bitops.h, ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ...):
../include/asm-generic/bitops/instrumented-non-atomic.h:26:1: warning: unreplaced symbol 'return'


<asm/byteorder.h> was included in both drivers/mfd/ocelot-spi.c and
drivers/mfd/ocelot.h previously, though Andy pointed out there didn't
seem to be any users... and I didn't either. I'm sure there's something
I must be missing.

>     * Utilize resource_size() function
> 
