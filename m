Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A09593133
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbiHOPAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243030AbiHOO7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:59:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2111.outbound.protection.outlook.com [40.107.223.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C5825EA5;
        Mon, 15 Aug 2022 07:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWMpiH97Xr6vseL14A9HTBuXBcSNzkO9eX0CnRMO3qtshbhWrpA13iN+gCIV9G7ucV59b4rGLOBMUshrC+HANiGA1hfrRYgcmQofDZR66xyz5vSZpCiwxS92TJKBMZ0HYUDkxh9N72t2kud+cRVfbx8RBV+o2okv4eSuuf9PYFaMbiIKspANu5QWH0WbJRdhjzApnkBPgrV1btm9zFvdu+sXDVwWZWZ5TEInf7dtjHqmLqmU48emRo25UG8XbaUXw78IX2w2AmUTFMhRwbpXjo/TwxyPpSZ/eUUux7ydteQ8IQh4ueNsMe+Kj2+qRcBe2WixZ5uXdvrRUgZZvlbzwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUvtZWAv/Iu7kb6pImaALLcYMweiwYIoY8KX4iuJ1lc=;
 b=LddbNXn5qxhHoIr83SUMQ7Bu3BHic50hTpjZmk2N86eZJ5SYYsIP767FaNYYfc9oRmaWOIEV9IjcJNJWhbzMpUaHkS3lkbKQV8xfQ40nk5X2h5DahZ1+dHpnc1GbBUTSWe8fZwhZ6HyxrLxQunwcno4OsjWVr/8UQFIUX58anZqSseAccPlavdl305e2qPPDP3SrBbTEhz9BaIIHF2QR3BLW25nKmekBdFTQjKl89PXNjiVn4NiMAK9+R2nEd+5d12RDePJXFbNBJ4oELNh6jFd6rFklmC8yiX5cHYnxnR1NcHanJX6rI2hl/ZsJjSsF55EuqTPgkhHxQ8BQm/+xwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUvtZWAv/Iu7kb6pImaALLcYMweiwYIoY8KX4iuJ1lc=;
 b=SoHRmrLe1wTR/ktrd8vqMWiSZ7pA/Aziumgf+d/wbx1HjRI+Dl9z7M948ialcq1IDEEgY+kmZyao48x3E/rj5l8baemLks0hyU9uhOYmEPDi4QcR3VJH+13A4+5xaTfbQ4YFeJcmZvc5Zs1rsCLgs+P3KEKEaviYG/Th4wQPLaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4267.namprd10.prod.outlook.com
 (2603:10b6:5:214::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Mon, 15 Aug
 2022 14:59:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 14:59:17 +0000
Date:   Mon, 15 Aug 2022 07:59:12 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
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
Message-ID: <YvpfQCM0kJg4k5Zd@euler>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com>
 <YvpV4cvwE0IQOax7@euler>
 <YvpZoIN+5htY9Z1o@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvpZoIN+5htY9Z1o@shredder>
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8a6a6d7-8e5d-4683-f050-08da7eceb9dc
X-MS-TrafficTypeDiagnostic: DM6PR10MB4267:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVeDod8nXMNF0JKqNwc2Y8q3EDGb/Xy/fFaONxCIdH90z07X985MMtmnJm86AukHiAPhlUjkVT9u4FaO6lYHv3BCJT+IpoTfzlTeIUf1Kn8K1xgEPYWhrfQcf7z/oBvjCOsbRMmY0ie/1FgO2R9fc1Mcyp90O++MPr80UJX3rvN/ReHtNoQLUFkxmIlSQ1GahGbXuzx7WBb2KRD6XIrICseUFcaJkdcWPwBP/PTZTOwsgvcf/ia7MgEU721dVIXeoeVAoHWQNMnkBlt0S8GDL8+Ys8/fk5rtFURRXrIx6Y1Ok44aMOGjYfs494aInl05dpsGrg6az30MCtEhXtRVFYWHs2zvVo2NH5OAxxUcRa6XksW7OCzQqBnkR5HOrWt9VhMparLzdxFUTkYXaJRc+zhY1p5HlMyMdM5qQ3gXRzLsvvR9IHeu/sbf1ihh+wUW6Zsbef2JRHDtDzP8ZWOEPi0KyE+kTBtO38Ys5/A+dQoQe8MZQ0BE3crqGsntqS9rMd0XIlwF//I7RVnCWDOPZ+xSNTh12N9ljaFq8bjzihsroDiczeG9r0mDwKYlHiW/9OFxb+rU9b/AA8OU9SI/nWbgrd1ZrBiB3fjofDYWVLEbbbuCvfu+P9h3DZxHuQXDQy1KnbuKYZKk5yiXF5ILIKg6ce5WupMPZ6f4MTc1dBjUmVuNw3lf/y99af9TZScGKXlpVoVArgSBrDXRB/7jpm2SlbLRczoyO0wlEfDggfwszg+ZvG1gI253hwEs8Djs8ow8j+c6K5DjpBnlvQraTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39840400004)(376002)(136003)(396003)(366004)(44832011)(2906002)(6506007)(33716001)(38100700002)(6666004)(5660300002)(41300700001)(7416002)(66946007)(478600001)(6486002)(966005)(66476007)(4326008)(8676002)(86362001)(66556008)(6916009)(54906003)(316002)(8936002)(186003)(83380400001)(9686003)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z7pcBthLj6Ay17tIXEpcUO+fr7uHdeui9QDqtofgiaNbukwHoBEYS3+5kYoH?=
 =?us-ascii?Q?TWXOJR2gCiqFix9PMOhnznWzSWizMo8Ud7LlYusHm/amkO2Yep7Qtrv7ZIJ4?=
 =?us-ascii?Q?x9zF0osOzYU7flgb4mU2LB4jVUXnltuvnVwlD9IuFB3ZFYC1dWhdKA/1+TRO?=
 =?us-ascii?Q?1zgaJf+Pki4PtKs1HVUuMBDt3FPWCT1OcTHX6VVklLwDBfmMnIlrPRcmSR/I?=
 =?us-ascii?Q?eUGxLw/1h0OdVb6lo+ofJfPEPnpdj87tqQKPGvwP+GZzyioM+DhmzuxUE9kK?=
 =?us-ascii?Q?/zyXb0155uKgQe+0BINuSW0S1d42eobQPq65f6cRf2gJMzj7Cvk2pM8Mhm4t?=
 =?us-ascii?Q?eEd2SM1qIMxYXffSJiVv5F9Wberx0cTUzfRV6bPlkcNRa20c/OBBjTtv2tk7?=
 =?us-ascii?Q?5QYAA1Eg+Wj3xDuPFl2YR3V3IQfI9Amd2gahFRNhQhO0yqWEGZh+Qa+c+sjX?=
 =?us-ascii?Q?pvof9bP3R45vrCj2/r6//D4tabbjPmFB/2E6KydH8RiW+jYkUftBTxcE3MH0?=
 =?us-ascii?Q?g1yKR6BFlhF5sbUQKqWi9hydQHr7otj+Km3gxdZRdQu5xq6tFBYdXEp6Zi2w?=
 =?us-ascii?Q?vo4R8yhBc6J9j5wN1+2qG5pe99pBSgg1cbuA7P5Q0/Ww2lTotdvirp8F929F?=
 =?us-ascii?Q?CoVsd0c31z58+K3GWIQQiTi2Lskf377l25SGfu9hQ5PMC/hc2YDOtKKnTFdn?=
 =?us-ascii?Q?aMwxNWs0C2HnsAup2kevFRdBKDpWIfgLg/9mUvmKNcYJtTPLhEHX7wL1mqLD?=
 =?us-ascii?Q?tfPv6wqGfG0m0mXx+pFh1dtdbnP2h7F4gVeM8ODntOp9JdTCSDbtdR7phDVh?=
 =?us-ascii?Q?Sx0o8/FqZE+1tonbqczJOKVCq6rN4a66xS71PcrsaRjtGvSblR51tCQCTy4+?=
 =?us-ascii?Q?wuGSt7OI5EOUTxeRA+YHeWFbJKc1FaZ1fKvHO+c3mMac3QPfNiwNKoOebJjH?=
 =?us-ascii?Q?rIMlxWChahiEP3WJi+nMljxOSG6A1mjumCaBDl+xN4ZY6I+7cLoAaNj+yF1H?=
 =?us-ascii?Q?cYZWUB3wvBzJOanAI4fgIVCV327mVZMS+WEX4KA6yxC1WrDIgENOhSI8S8pS?=
 =?us-ascii?Q?Xy1iSko724aYgySWwdXOWrBRgj1FNdUtbXELNtk5p6y3Ekc6yHmF3BDrvAN+?=
 =?us-ascii?Q?pjJfaevsp8oQEhAktgeUD4HtN9jNdwiXslnBdVYzzPiiyWONVsRfcvT3Pqka?=
 =?us-ascii?Q?t3Lmzgp7BDYgfA6yue7m/6na4VTx5MsDSeA6n4OAuiwOWt1LhYBILA8wKzk6?=
 =?us-ascii?Q?XNd0fpRabyq6abPO/vD1eWsp6BXHE1NoYmHzNKN24x8VaaQf7BDB3RQv2x1+?=
 =?us-ascii?Q?JYx8VYqxxh79PLD/oP7JvP1yZ3vTWfjdnccOvFsxH/hSfKhxZGAM9rQnxTqX?=
 =?us-ascii?Q?960V4Kni1IMp/smrvkyCo6r15sMFb0vqae4PewP1wq9txO0S+ecB7GzWelf+?=
 =?us-ascii?Q?BbPLGyBVQN2SciuF/Tpsx7OW9dPVakIzzRwyoJB4osVJiuhhbmczpItOS/xD?=
 =?us-ascii?Q?Wq/ZIvJGhkGEjNER0tNww4D9e9yFqlRFTP1OHk8Q4Sm+EP/DSzOxfSHXOZYb?=
 =?us-ascii?Q?Hh7GPniLrlHH5JN0/sbjF+S+Xd/qx7jwmhQNu9m5eRkNMdVb6FEyU8lUzaJj?=
 =?us-ascii?Q?I7K6OJ915t66uGzDjIMAJAw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a6a6d7-8e5d-4683-f050-08da7eceb9dc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 14:59:17.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nLmYF6ROGjCzqME+0WOmntwDdEfh5kaqCpw9Q7y5ks0GX4wehCL/jlyZMMfPwAYHM1ss0o3xx+vis9xUNP9IrG6q3GmrHHMyjNfyIJ2s0R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4267
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 05:35:12PM +0300, Ido Schimmel wrote:
> On Mon, Aug 15, 2022 at 07:19:13AM -0700, Colin Foster wrote:
> > Something is going on that I don't fully understand with <asm/byteorder.h>.
> > I don't quite see how ocelot-core is throwing all sorts of errors in x86
> > builds now:
> > 
> > https://patchwork.hopto.org/static/nipa/667471/12942993/build_allmodconfig_warn/stderr
> > 
> > Snippet from there:
> > 
> > /home/nipa/nipa/tests/patch/build_32bit/build_32bit.sh: line 21: ccache gcc: command not found
> > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > ../arch/x86/include/asm/bitops.h:66:1: warning: unreplaced symbol 'return'
> > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > ../include/asm-generic/bitops/generic-non-atomic.h:29:9: warning: unreplaced symbol 'mask'
> > ../include/asm-generic/bitops/generic-non-atomic.h:30:9: warning: unreplaced symbol 'p'
> > ../include/asm-generic/bitops/generic-non-atomic.h:32:10: warning: unreplaced symbol 'p'
> > ../include/asm-generic/bitops/generic-non-atomic.h:32:16: warning: unreplaced symbol 'mask'
> > ../include/asm-generic/bitops/generic-non-atomic.h:27:1: warning: unreplaced symbol 'return'
> > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../arch/x86/include/asm/bitops.h, ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ...):
> > ../include/asm-generic/bitops/instrumented-non-atomic.h:26:1: warning: unreplaced symbol 'return'
> > 
> > 
> > <asm/byteorder.h> was included in both drivers/mfd/ocelot-spi.c and
> > drivers/mfd/ocelot.h previously, though Andy pointed out there didn't
> > seem to be any users... and I didn't either. I'm sure there's something
> > I must be missing.
> 
> I got similar errors in our internal CI yesterday. Fixed by compiling
> sparse from git:
> https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=0e1aae55e49cad7ea43848af5b58ff0f57e7af99
> 
> The update is also available in the "testing" repo in case you are
> running Fedora 35 / 36:
> https://bodhi.fedoraproject.org/updates/FEDORA-2022-c58b53730f
> https://bodhi.fedoraproject.org/updates/FEDORA-2022-2bc333ccac

Thanks for the info! I haven't been able to fully recreate the issue
locally, those are from kernel test robot. I'll give this a shot if I
run into it locally though.
