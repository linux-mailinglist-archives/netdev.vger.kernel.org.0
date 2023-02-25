Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7E56A2ADA
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBYQrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjBYQrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:47:32 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2095.outbound.protection.outlook.com [40.107.244.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB4312BCC
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:47:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHIF+xMPTwPgipSRBcZayr1BpOp4PJvDLRtaxlCxffFmZheSUiYmHfixRdOrM0CRDp8fZlMxU3J8vEiLcjl45vaA+o0KU3GOvgtCvyNrif9mIbYzyFgziogTh3t82VgpZpLQiPYvokmXQgYIDupfVH8VzOy6oC2KC/SPb+APCE7pTzSmchDG+RgQIN14QArGtGoIFViw8Gr69St9wN/h4h1oEJ6uJOnlvaFow8Es9cNkS0RndD8c8CvzFXXHHWqrNVpm32//CD3SzuI9cGzbFgxRLXsRdMeeb2E+yB/WZoMrmsjf/psPWSX3sm/uL8LHTVnK5WCVhgYgSC7qJPU/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKpz09zDsz6WJyxWFSz1ekKaPind7WPQNu/h6hkb2is=;
 b=PZ+dY6iXKu9UUV1iIEuPmtdCTauu+fUAliDH/W/UhztoK6FXB+5tJzBHx3JiQZxYYidA6pBddLgEDoi0N5eYWMm6Hbujae2JZzCJfBus2bBTm/K/1fH1ad1XchXe1qg50rVHW85i6pIb7f5Xe4Q4kbEeyiGFs+8MmyuG6qo23Ps1i0rbdYFnxQAgT4YxWU04tsYo2AoQUZwrPAO8LRIIiQKtuas0XpdiXO+VdpmkaDTsY8CPWzWTGGNcsisQU9RKkRyMEZOReXi51xIe1OS/C37BuR7L7+fEzNuueJddnQAGdjVOrMVM67xNrCIHfPH/38MaUA4/VGqrkqVtfyFcsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKpz09zDsz6WJyxWFSz1ekKaPind7WPQNu/h6hkb2is=;
 b=lIlc0Zi4teRqzKHXOa+p0x9jNIOwe6I8pYoRtcdrYDn7r0s7YaUjjYLgHIwEEuc6awa97cYhj0IrBD2uNja5AcTLWEEA2qICBgVFOPQEwEhAxZpUQ6wXlzGoH8MxrmJGokMS9dzHqCm1H1tq9iImNoP97X1v+wNaH7gVPJL+VNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5682.namprd13.prod.outlook.com (2603:10b6:510:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:47:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:47:27 +0000
Date:   Sat, 25 Feb 2023 17:47:19 +0100
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
Subject: Re: [PATCH RFC net-next 2/4] net: mtk_eth_soc: move trgmii ddr2
 check to probe function
Message-ID: <Y/o7l2m51YRhC61g@corigine.com>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJA-00CTAX-NA@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pVXJA-00CTAX-NA@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR10CA0009.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: b121267b-6549-4c97-7849-08db174ffa31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLu9xxqNbLucmrQdf8RmX9z34Sslw7NiptSMPIs42H05RR6+TLd/Jpa364ObhJSWDSyQX5B0Y6KJvUIRLG3csRmRo3eF0cGQlAK852T4nBZh5cxIe2CSKwtOSo4cLmCK8CN3g6GoBJcHQxS/kO7i9lskfud+oIas1TvTWDLuZWzLfE/SEol12X1TrAGvwC5SC08gWiwpSu//4zuZlF+SNI7LESXY8Rvt0QaWyAE0yQKrAFVmF+2Vh5EHvBEdmfkrERtiUj3aCYUUm8EQkd43COxhUz5tbIvjXQNCNia6G+t2R/x9/5rHwgapvtII2fX+OZ10ZdPJuzNoU+Zpcg751fTYPhftsbDDqKBzcaOIi5dbIfTRzNo1fax0dMXhZAPAmUxtqfdKmCk/z25uUFq1txYJpQBrrA8SO/XPm2RbCNUrAgBYrdHy/8SI/oKY2RGkA4nNy1MS62wo9fqA2fPDcSRwz4VcMpow8djKxPZS+Eb6ITddJVNfhMZbPgAzhN2pbnQal00BY51goR2WcnI5CwxIDCdTk4hfcD5p4hk50Iio4/weKBnVSi0KbQKFb04J0ZXMJXq99QdccP0eTDUeyEok4EyEC4FlsMb5AfKGgJaTWq+lzQp7uXSAnAIOhefqNfiLBy/Yy3YqpeHQvBzUSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(39840400004)(396003)(376002)(451199018)(7416002)(41300700001)(8936002)(44832011)(4744005)(2906002)(4326008)(5660300002)(66946007)(8676002)(66476007)(66556008)(6666004)(54906003)(6512007)(316002)(478600001)(6506007)(36756003)(6486002)(186003)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8gmY8Xw5/w7iyZk18GQlqVD8hiuQ7MYRxqQHp/Hgmd1dCP8sTZUderS0fBiD?=
 =?us-ascii?Q?5vhJJzMC5ZnbG5aMzbhvVBnHoD4AsOJ9kPTTi1zCcyFDfX/x6M+LwjpsQXbp?=
 =?us-ascii?Q?hyJwtl14iVt+fs7A/3JY6HM4gwAfX1zRMaoCdG6KTAlc5jsIjab3L7Uqs/UM?=
 =?us-ascii?Q?UOimUZa6H7E3vIhF+T5Cefz3OFSDtx+IPOx5ZoMr3qe2ew3IbNMFW/tTDpzm?=
 =?us-ascii?Q?A3rdMUpkHzxRyN+7I0Wh1goo82UC8CcqJXcM2tdvZIuiyrUjhuBHuuEAppG3?=
 =?us-ascii?Q?dOJ9JSRLCMfCzKYP5xbhak3sQUAEAmCUUeP3YdCyTKTnDFA45CQN6mZ7SgIS?=
 =?us-ascii?Q?of7S0NkTx+QVlm+9YBA3h4FOG96iTdtt7EV72gma6DQWUqR29Covl7zwkKXi?=
 =?us-ascii?Q?PQ2rXcSQlrVaMdPBa2kPeoq3X9BEM1wQGLqYTLXmZK/WhmGWCNyQDEK0NZ0n?=
 =?us-ascii?Q?CtWkAHWSL+qUJyONsmZSa+FPgjV//EIkejaA8bOo8vLUvhjVKCIZ+CLpkLAf?=
 =?us-ascii?Q?9ljthA2hJJ2enbtMT2QMSX/VNRN6nIt9CNhJ+GaPuR9ja1tykclbY6BzbuLS?=
 =?us-ascii?Q?ir21H5x6dorMJkeC9IR79MC/1WBQBcXZ8QxQ3YwcXvH1oh0xAtG/rReuTza4?=
 =?us-ascii?Q?JUxykDBw4A5minHcK5eO+zYWLAU7Ll5zmyHV8pStY0dvzHB9C4tlaTPS9kJK?=
 =?us-ascii?Q?2cwjJ68x902UCSgufYVm0JnXi1Yq3f5c3qR67hsLHiOApMjpEiP5h7TVt9MQ?=
 =?us-ascii?Q?KCPK7Ae1WYVPNOESY2vdGsPIM/mLJzpmze7zH8XbvsuKHxDMx4fTKRTgx6Ar?=
 =?us-ascii?Q?7YE7A2xbEXok0CdM6fAGCRsRlqu9LU3sf81ZKGoukusvolBWgVKjnWAAiSQP?=
 =?us-ascii?Q?Y/Ztz9qFfnOnHf7r5cQ0zYo317cYxvZ7WAc8h6O3wBDOH3Np1jb/lCgU8Apm?=
 =?us-ascii?Q?5PlaUAauoXzaGPUWZ+VNaYlnvNsq/v38KMWL2BwUqYcTFjAkZQ61nSKTZzdG?=
 =?us-ascii?Q?VoCBROMLFsvwaGebIJNdWQa6oktLNmiQ5hGfcWh/u1x8OxWLCmrGzltoEV2p?=
 =?us-ascii?Q?NTx+S4l3FToZX+fkKzf0XBIi/o8FAzsrtlprXnABeo/rWovtzB6gfxLxOh1f?=
 =?us-ascii?Q?d8gipsNE2skfza3XrTIkuyc5uaXYAoJ5P7OWk16V8pQ1TpcFMj5H/WPhjm+v?=
 =?us-ascii?Q?ciJsueSpr/gHWovrBfJQ6cuPBWlLsysqu825c2tq+/TSmbZQ6AURhrPUwrIk?=
 =?us-ascii?Q?SIBhxUyZbVGcQCPymXbytd+BWPYoz88e82Dd815CQDzJVJBpZhPeFl1iLEnb?=
 =?us-ascii?Q?bgj6yrPAlNX8JnrULVAS+p1ueFgE7UODy6ZxkV/jR9T1j/lu4YVSbx8gAilP?=
 =?us-ascii?Q?X3F5kaYda4uxi1Bctr1Mo8WoNrFSWUY5lpbwQg+YGoynJedvKdent54SkBoL?=
 =?us-ascii?Q?b0Qf7XSwPDAHeTDG4v7s8ZA02HWGZNdWuTPW2+q9TaNgB1aH6Vot+q0JBeY7?=
 =?us-ascii?Q?U4k7sblD4MVkDMYUQ12vhyvQfW55jxOCJKo+J+PW4JohdhH/n2U1JdtFsVim?=
 =?us-ascii?Q?PsgfxpDOLyHImrd6WuH0W0vUmmGxrExv95StZpxZ65pdaGF3N/nggpxg0eu8?=
 =?us-ascii?Q?5lJnRulvYGgFiXT9cScMMTZeAJpAcyf2+VLzWK5J1OOg0uPUtbf6J5UPtrgd?=
 =?us-ascii?Q?3JedzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b121267b-6549-4c97-7849-08db174ffa31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:47:27.2021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCisBTrYUPvp5d6E6Ez+A29VJwZ8YlgWAAfJBXkh6+Ms8hFxDwJMH1nTnBRqso+efEf3EGs4QkT8aJ4l7TcbhBIBmHeKeNeUWHX8/YC8RUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:36:16PM +0000, Russell King (Oracle) wrote:
> If TRGMII mode is not permitted when using DDR2 mode, we should handle
> that when setting up phylink's ->supported_interfaces so phylink knows
> that this is not supported by the hardware. Move this check to
> mtk_add_mac().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

