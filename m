Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2660A6A2ADE
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBYQtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYQta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:49:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2101.outbound.protection.outlook.com [40.107.244.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A87136F3
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:49:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqnJyFzXRZPWPPKXEyhOWjnjKs2+eYwBonBDrK6uwr1FH9eQUyyr6tthw19Mmpb63eN78dRYIpF57hDvgF1QdaRjdQ3SGhdm6LgfSPPcvgwsolx6JU36dhQShHmmFLV6FlNLtA/3dhITSqrMIVmJ1ezKvU99aqPZyXMiEAFapcuXFq9UBVdlSyAaYXuTVbvg4SCBvnYksGgBUAl829xxPXGmbpHgMlMV/ad5Q6/NSnMUabw8Kriz8ILuem04aGUwV/FFALsYwZspp8A/R7PggzoSkaRNor0zIJMScsjzpuNZsMvvHjxEnQ/ntpiQLlNu9WGBpS3cAwvtSoUtGC5thw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+C+p72V7OQw23bEGB2B7Tmx6x7vmHKzY7inzefY4bg=;
 b=PtCiR4nstVopAX/p8ayIEIngLDTvLsEjkYbD/ieEAiVFAuX4RglqcOSRkgdlF+7qvOB92EGuASAeMwJenmeL7ZHWFSE9wZKlPb3IAO+eBZ39IlyxMuD/CDETUbMSXn2lzL0KmGDLCGxPVrx5GyCA9P//GVbroYWOGYFvZd22nqpts6kg3TI8FmUj96BPTET1bInp3hEC+sXMWLagcdhvkC4DnHoYG2LBEhGymLektYJddhgPx6OXYaSCY2wGLAIKVsZrBwq8h04vpME/XM/WQSpYQKZ57mlHpnro9E7nICQe57nVy/Cor/CheXl5zyOfaTtMh6AHH8T2qdiNM0DFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+C+p72V7OQw23bEGB2B7Tmx6x7vmHKzY7inzefY4bg=;
 b=gqOOMlxJ4KsYuKqWnSotmAMQ7AvUyuQnDGVoNDbJC4btjhfSTtBMk2gFqMz5GSHQGZDP16KFpfGl6PEWF6k5WpVuYN3/qUBhZklv4DXCIt03Cw3Qaw9i70Gk8gNJCI4dSu6sliBFKSjnYI7M/LsqrFCsW1xOu8tG8pNnBW0un5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5682.namprd13.prod.outlook.com (2603:10b6:510:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:49:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:49:27 +0000
Date:   Sat, 25 Feb 2023 17:49:18 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <Y/o8DkLO9CY+ROkH@corigine.com>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM3PR05CA0119.eurprd05.prod.outlook.com
 (2603:10a6:207:2::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: 743ff641-e1a0-4e3a-0d4f-08db17504189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6q0zb3JIhDIXutCYAM3I9LWp63SgQ9RypPYkO44nfcjxedNvDq86c7JxI1OTzTKcReIo79vZZQyrW1GY8sLXCHqhrP9aNHuIdcDedLEYgjf20ZsgiU6sQIlMqVjFj/tESDc9AHyLv5Q8KD71MmSPQhdcTkBOWvAb8Efxb0dfyGMKrcAsZ8uX/PDLLvoP01KL55I2em4c41A8w4gdcRom20lp+Q/+4wi24pXjrLSsQvJoEsiGnqTqSHLGgFA7QaQnvcQMwpvSmu+Gdqdx0dJ2izbib5phfLFgl633kXygN8tM2h5/J4ReE/PIav3HrxPGJPV0AEu1RP2SJqeBNk3cpi4D18jO6gbPYccQ+W0bh+F8j2uG2aGvtzcVby6RT6TDL0uqxeHY2msbum4IS8A3wDc+g3axpGNE+bwOg8HeuaVbBxnp5gid5u8OYET3mrvu/lDA2PoxqmpnuqW8AnjE6vdonWLn5ccpbHdQOdKjxY2PPs8ex0eywSpd4eYlXNXOaRsbZQvXxpypCvJUIpmpPhYNINod0YTjhc6+o904bkQ/nhIT0tJAmC0X5LNogD1ES2+nSUswDlsYbzqAw/FrCRSAGQMkZIlhYovn6txzmeCct0cv2AIrZQdo8YvkgfZGoYRx4rciu/TpdDyocteCUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(39840400004)(396003)(376002)(451199018)(7416002)(41300700001)(8936002)(44832011)(4744005)(2906002)(4326008)(5660300002)(66946007)(8676002)(66476007)(66556008)(6666004)(54906003)(6512007)(316002)(478600001)(6506007)(36756003)(6486002)(186003)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eJiLrVp6HExO6y+aigAPPQ3JVloLJ9NX+4OfnmWn5agP+rFA6ohrEGUzC0ph?=
 =?us-ascii?Q?UzFLumDGxfCL51q+Cb/nzZmSj2EQjWqAmhPvoW18BTkHNGBqR98RZUUTvnEF?=
 =?us-ascii?Q?Od2C+vJau0V3SnbVNkIIiyimFrgiPxpiJdLcrGzW/OxTujho6vlWUDS9GlBa?=
 =?us-ascii?Q?pKiiN5GorhydAtqH4Zalg3COhaLvKGdyXICJkKuI0zgkwLPKEb88bD7mthsO?=
 =?us-ascii?Q?122OMKqK5RqTJsYp6EZaIrDCtyEmS9+8uEc6naxokt7iWcSwI12OJd55/Rau?=
 =?us-ascii?Q?SYrDWlCwMSzPN+WujabGpJTHeuekoPVYEPkdSHiY7Oy+pJwYOrmYO8xz7WSS?=
 =?us-ascii?Q?bYbWVxwjorDZGacf2mVBhurYOmtw0ukg9I7TZ6iV69pH///deZV5Es+p1EKE?=
 =?us-ascii?Q?fz2vDyVMwMWXsgZ2PFfPiCIjXLbu8eBDe/UlOTLPpPQ5noQQszGopC7GcHt1?=
 =?us-ascii?Q?h7zPUG8ScTefdGZP5TufRoDrcNm0N/CB0lBMjyFTDbnximg3/F6d5QSi+bQL?=
 =?us-ascii?Q?dg2f87TeIOxIfUYc0FrCjeCnZQwkGflxhksc5Q/5Yb+Ym+102xETYu8vfPA8?=
 =?us-ascii?Q?NVvao/zAey2X/O6KHWrnld6VM8k0iKy6QztPJZfw48gQSnpI06MrZmq3qFIL?=
 =?us-ascii?Q?WPWUTbkBLNMqrSOpr6SzbqHkMOIF+HW6RnuA9siVCKcqq1CiVqJta0YLgGl7?=
 =?us-ascii?Q?LMKdY6M1GBADWBDASR5Rnlw0+LftgW3qAEmj4IutzXuPL88p20DzSW5+0Qzm?=
 =?us-ascii?Q?FeTcDwdTQjlc7z63eBkLV2BEHDtJ24jd6szmFXWRvyvss+fp7RDzOh8N5o/o?=
 =?us-ascii?Q?DmH7LZF/jleev/T8kXq5AinjD8akaxDC4zpQHozUKWHyH6HxyNyHwM+VJGSN?=
 =?us-ascii?Q?OUSQbB6TEY+fZV24uJ2ej035rRzB3OmOvtz/3r6uQxEkRLaCI2unXxnDPrTd?=
 =?us-ascii?Q?F60w9Tqs3AHAf5yQ/4K8rAELVSrspxFzywFeXkO6bcyChSSSL81UIvtNIH0k?=
 =?us-ascii?Q?5lwWe9E0aN2I7uesqgt+QVRysj3qmICo4mQOYoNR/2SQSHugvCSRzB7hCshO?=
 =?us-ascii?Q?hvza8Kp71d47gqXd23vuBABlvS6woDgvehs4E5kldI2k1in2jTu7nx3Gvu8+?=
 =?us-ascii?Q?93fYypFHzb/o+e5Pmsl5AvHE71GJhuz9pFNTmSmqvX7zaIzuEvEc2L2+yEri?=
 =?us-ascii?Q?yqdlvLghc6UsOwLp9wcRIf5VQrwKEO4S4aLPJF9Oj3AxBr692P9saHTJqj1I?=
 =?us-ascii?Q?J5GRi6G9GYteE9wyRs+8vpLzZZxUrclDUnHYHanMgVOtF9jgJPHQnRz01om6?=
 =?us-ascii?Q?udRiV5ZjQJHqeutmFNgSiRilDmdLIdQu7ffmq/l5z6ItWulpApW0sf6xRFfM?=
 =?us-ascii?Q?uNk1jfB5ozM5AzLAz3cxAkKGFmkBpWBBD83480N6lh/UgoH18GKXOi7MdfS3?=
 =?us-ascii?Q?d/9r+OXzUac8j/mqnsV6jPqbhupXgtj49x8RLT0KMcHxihldEiGTxWhH9FEB?=
 =?us-ascii?Q?/TOrlBCXPA9zFRi5+33ppccBIntjZNp31c3Vl2HwRYVfTfPbHjFAP1UH+pX6?=
 =?us-ascii?Q?7LwrnrFRW/WybSAcysVxxj493M2Nr+7cYMUiudOnpF0GFobS6fyGTjO1QtCn?=
 =?us-ascii?Q?Fw0ELzJurBotDNSgGX4OeYi1nNeM1qb4hn7NwVFBgnXnIUCOS+4C88Z3Vm8e?=
 =?us-ascii?Q?LDS91w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743ff641-e1a0-4e3a-0d4f-08db17504189
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:49:26.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2YX8pukOfiilR9aZlGL7E5IOEw1/FkLQfcHpzlDPrOUuyP7vxGW0WnqkbuH1/YRSU0RQkbXPAnm55Hk+glim9mNUMUbsdbKwVjAxFDO6R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:36:26PM +0000, Russell King (Oracle) wrote:

Hi Russell,

I think it would be good to add a patch description here.

Code change looks good to me.

> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
>  1 file changed, 2 insertions(+)

...
