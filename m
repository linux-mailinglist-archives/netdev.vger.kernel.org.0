Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE026F4723
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbjEBP1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbjEBP1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:27:41 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2130.outbound.protection.outlook.com [40.107.244.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1689D2701;
        Tue,  2 May 2023 08:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRGjOkHAmaLxT5/koH3urDIE+6vokmD+eUrICTOLGcxSyLzS28HRii3XmNOUFmIK9TzQtenKKTBfPIQEDeeBBSmj/yJs88J1SShiuBmlXYxUJGgMfC8d+y8obw/CPm32kb67Yo4VF5hHPT/hHktGrO3zQtpwaOd6e53th+SBUQYnWW5xE/oHZ2sQQ0hzDnCKuv7IasxPs5f6THNhRy/ub/fzSKRVZfX2v3rESkLzcd77hD1GmtGefTDaF/lFHkw2yCuU9dOChq9wQzMV/8/1vLpqH9yhfZ69qm8hIrm34Xo15V/KxCDi5fbP2+zF/mmp9M2TTzhHoqmvyRU0qj67lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0/fhKIHrNqrMaTXCqWzATqggBGTePEzC+dtnANkswg=;
 b=KDSMCljR3aPRG4zSyv6XqLETG61qudwh6msr6dewQyAM4VKiJ7jn5nclfexzudbYbIfl858/DGfSezsYQjqMufASn3qUmTmXRYgetO/wDWAtvtIWCmu/Dc+n58AP2Q5DgeZzYPU9Qo1LSyX2oixC2muLuY3WFwXXbrS42Duz68fZH4H6vzPQgUs89A3JH07Jht3n7CDLRLKau0fSaT0MWaDT42adtDLOxuOBoPpK2+I89cG1ZwNwLZdtFMKoyAMwOQhm5Agks95AaZst/CfGO9+TuXzv23pRlcySGDXJDu0JENomT+QvtQB9OSEXAnDk5TVfpFBDFDe+STVGEdpSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0/fhKIHrNqrMaTXCqWzATqggBGTePEzC+dtnANkswg=;
 b=Ustlv57TDN32jceHxMIt60le52tIlq+eJBmGeABurSCTiGMiCM/agyWOVxQi1Wle44CTzAyc36iRaexeowJanuqaOAPL9uiucxASmIYIvejKP5LqTRFfppApvTFyBTA1JXvr7ENYNNl++hXuHYoX0vcxWoxpl+0GilyfDXjlA4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3636.namprd13.prod.outlook.com (2603:10b6:a03:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 15:27:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 15:27:15 +0000
Date:   Tue, 2 May 2023 17:27:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, v9fs@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] 9p: virtio: skip incrementing unused variable
Message-ID: <ZFErzerdMYvMwNdM@corigine.com>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-4-efa05d65e2da@codewreck.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427-scan-build-v1-4-efa05d65e2da@codewreck.org>
X-ClientProxiedBy: AM4PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:205::36)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3636:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b78f36-c64c-4723-bab4-08db4b21b590
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z/oO2smPkyJ3rQinudUvjOp0APxQB2QZO4eXNuDclfmdHPpK75gLotkbJoWca29oE5/JFod3nTSzSN7w+qEN0qdmdg5UdHVfyNZr3kM9GO+e8d4QsykLxkZAaSmeNZ7mbMfB0BFF7WwGNrSHHYr/XBUf8vbkuSqInn6DxSny5D0waUS8M4aEN22PwtRbzQxKoWTZlu/FaqlrlPE6mbKQP1spvr0T25jLgp+znNvbnNh9a/e+4mJlGZlQASIEPUD+xWSOr26Pu6e6KFoxKHpAeHMQ99lPt6OVbS41QhNSrnLff/lY5DgOhjjeTH7K4mpnOEYmzbh0mc3SNn3p6ZOCitj1uyQGsCaAnvrs70xPY68pq4zhjWL4kPXSD2GpGzN3OzVdkYlyYvxX+Unel7AevRvrWWMSoZb9/+zCh6yX/xoRAxzbLETeFOJujPgYX5rB/8ue5RDrDn0iSYdAvxkcfD9frf13yZN+O6X6ehMBHRxE38V56nYGQLeXjSN1+5uxDBFmyyavjw6m3imBsp8R714wvVm2SuyYqPa1y5EfjjChAS0yNBQPgiYUIbdNuhl6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39830400003)(136003)(396003)(366004)(451199021)(8936002)(4744005)(38100700002)(2906002)(41300700001)(7416002)(44832011)(8676002)(5660300002)(36756003)(86362001)(6486002)(6666004)(6506007)(6512007)(54906003)(478600001)(83380400001)(2616005)(186003)(66556008)(6916009)(66946007)(66476007)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VSmp3H6sBm3P1KSHuRleb408EaaooStRX/KonOwwF9I9XcOGgAMjpux8RhEK?=
 =?us-ascii?Q?06LdAuJl7lYVIwSPlSbtotT27gApHXZyFhx+wQDcXMEFfwfLTAABLn7O4EIy?=
 =?us-ascii?Q?Gk6CDLBojpabs5oj3xYV3ELylBwDeEborVxrgUl/rQc8C4n1AF1YUdRFAWas?=
 =?us-ascii?Q?22+aaQYZ7fpjJuhzL3XJlsKc6IvMoX+so5G/COqucNnlxSMgN8XpMby6ym2Q?=
 =?us-ascii?Q?tnWH6SjScm/kW3HopGq56H6KJIU8kvRtI4X3NlSIOKb6tOMFoJCLej5F21DP?=
 =?us-ascii?Q?SHSVF7BnnRwNQXcvJoWOgnsmZf3slnrJjfWfVaA3WqhZ3czDsqZH3Wr5ie4B?=
 =?us-ascii?Q?9X3tx5yapTR+1iEjud0RQbCBuiUQQIuXdPoYB9S56Lg0txATWXPFurgsW7wP?=
 =?us-ascii?Q?TO4y+ANt0gDS80gN1Ia16tvGZHbFFtHcLonOZht0qQiIb6dR0Rk79S+TFLC8?=
 =?us-ascii?Q?1tkePd3/k0siAVzWJwQa50URoLJFGAGraL6IKfHxUuUgc/pXwAg1phoGu5M0?=
 =?us-ascii?Q?fbjkdTCgv+e7+oAOB+PgwX3HV/yQueLzUpyqSNOmXZpBYdZ+6aWGc6kvRBq7?=
 =?us-ascii?Q?HtLFGxihPCddGOSpQa61z3n4I0MOqDgx35v/25PYHtnudRMpNrRqRbq76fL5?=
 =?us-ascii?Q?wm1/uJWSYjjDN60vzhKEBDo6ak2+BDnTLl7nxsVKAkI4EmNPexbWdYBSuVhi?=
 =?us-ascii?Q?tSJs4oawQ+LJlSzSiBQU+OBba7XZy/5+eum3hvpdJt4B0fJi8XsxyFG5WrQ9?=
 =?us-ascii?Q?aqO0/S9jKypGze3AEFzwTLi5Z+wxOsdEFa7/4PanaY0GlESjFUE3v8botPQF?=
 =?us-ascii?Q?LCDXH0uNt6MkLWxkJtab+DWPyNuhBdiCDVTDLkmIsG973QVuF70KKqbRJ3LG?=
 =?us-ascii?Q?VKzyhF+T/YWyNia6EKt0elWV09KyeuwDwWFZD4pPWe9xOguOJk4ppvM93ixI?=
 =?us-ascii?Q?7c/cEJ6/vGQeQVa/BvCpzbw/ePLReQ+kdZ6AnWwa3bhvFlJLvl64oSoPRJNe?=
 =?us-ascii?Q?yzmptiYtNeK+lkXesdtUJXg10Ugs9SoCqK3dB/U9UTfrQ4+UdbOHylh/WXeD?=
 =?us-ascii?Q?wLPDigDalHAk9epTPxt6WuPs98MIHxtZDqVc8V5oxr0qanG0hCzlBVWyzvMh?=
 =?us-ascii?Q?4RufwnYHUnz2yc14YWfBJtiN9OXHkhLKdc84FdzpWE8sQFJxJ1J24VWQRi9/?=
 =?us-ascii?Q?7MDNM+vPLXCDK8nLdyRWFCD1LqidTwWH31R+Ko7Pk963fOJGfu7uh5YuHsIl?=
 =?us-ascii?Q?StyAwGRmztOoclgX2EI/cn/2rPYTJrnmzu2UPHdpVj4qTv9A74KE7gjY16+T?=
 =?us-ascii?Q?IiHWfzrmI9X0tAlNFPGrulUHYeb78nEuG6W/FY78JXSBn0XIf19nCFnerRhH?=
 =?us-ascii?Q?1tLJZ7sQvZFSgPWg/a8KbsDh1y3hUGrbJ0q3DsK2s0qq6pflZeZPIuZbFa46?=
 =?us-ascii?Q?BaBppanl/byS+vvhkqJ6VmMwCxSkXnlXqruAc9ZBBpMFd8exJ03gWSZd/mzR?=
 =?us-ascii?Q?C9yKW+cRK49QJcLj0ReOL1+bv62XXq4j9EftXBSeDVIOMROKt5xSIVJJI3Bw?=
 =?us-ascii?Q?R7xiMWBjAcdKQeHePXOR8LOtaBoMB6aSk/x9p0FOpPHNaBnnWfq9uWPcD5nL?=
 =?us-ascii?Q?fhNZTy1SFEacgGz0iaPEGueTz97kNqoeNT+TkeRiYMxWN/5vVCDzuTjdPXRB?=
 =?us-ascii?Q?rmieog=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b78f36-c64c-4723-bab4-08db4b21b590
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:27:15.7931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9148JDWCESwpFMiFqj/rEeHxfi/unPfhiq2aSm3IxCy4Qh33ajfljfgKyDAESFxmTTJbz6hQGIaNptGxiw+nPSrf7KgU2Z3WiQqN20omjLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:23:37PM +0900, Dominique Martinet wrote:
> Fix the following scan-build warning:
> net/9p/trans_virtio.c:504:3: warning: Value stored to 'in' is never read [deadcode.DeadStores]
>                 in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
>                 ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> I'm honestly not 100% sure about this one; I'm tempted to think we
> could (should?) just check the return value of pack_sg_list_p to skip
> the in_sgs++ and setting sgs[] if it didn't process anything, but I'm
> not sure it should ever happen so this is probably fine as is.
> 
> Just removing the assignment at least makes it clear the return value
> isn't used, so it's an improvement in terms of readability.
> 
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

