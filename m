Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C5A6CC258
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjC1Ooa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjC1Oo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:44:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577D7BDDA;
        Tue, 28 Mar 2023 07:44:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV9qdT/tWW6Y+MUofDCMRthqrkSQtNPORjSl4VT2O7hLi19PLuy4JS2Na6xp6jj7o/PvE28nnPpBKzIGhsvZutc+Gh1q1q+fiEr72DO9asPAhJ2eEAwY9aV6u1hh/a+exrU+KTRM9EWzW5WSuDSC8YfEEsQHBcIZkRScxW1ciiXMV3eHhs99dB6XQuQnwwgsiZ9VATM/tBdCNC8l3NpjoJOqH+lSnWk685c9yWbTIbroq1BG4NHA2yWBVV7/dMPU+r9ReQ10Ka/Ma28GzqQSSD4vk/ej2fbSZwk+dUAMPut66ZMFVdDiQrvcmf1SYVxNI8g4bZKXvFNMzOEZ/PvyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U32y6OUaoBJ+YoDQQ7L6aEGN6IYgH5zVI/yl7zfBFiE=;
 b=VIIr1FowJDhsfcfDqVVT9Xu6x+1yssu+TRU4tLanFXWSsmxS/dtSL0TiMDIP8uSxEY0mNUiav1sd8fNw67ROZ78RHxQEXAh/UiUKq7u8c3Wgy2KNc57OLqjgxR28C501EFv+Rq7a6vnNmYDlrpz16UAzj+XLbCVheI4iv5UPg+xduyaNdC2t0rMWMrTUcjbeMvKI3o0Hr3uhIw0usAxz1G8uKIwtRlItkdDRFpY91iYunO7r18hpC9a4Ej6PNsGrlMdqmpzDxIohunYppuNP9Pw9oVoFKbNm1cenpmzYHTs14BD7JnLlHTKh32ScuqY2mbeO99OdHQENEgEWld+BJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U32y6OUaoBJ+YoDQQ7L6aEGN6IYgH5zVI/yl7zfBFiE=;
 b=KfApa1k3Lng6v8KqkcVKwrYHxdLgh/BGAugYttYXETD30+ViQWAdPUL1sq3oLnbznib6V/hqXzict+ANtukiqfcIDuyNqcrRs3rod3GSsNeGDObtfT532OrWMlvkHQUMX+tuMyBN7grT3EVjdrYtjzENpUdi2EaDjqzzBxpd13I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4914.namprd13.prod.outlook.com (2603:10b6:a03:361::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 14:44:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 14:44:25 +0000
Date:   Tue, 28 Mar 2023 16:44:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v5 1/6] sch_htb: Allow HTB priority parameter in
 offload mode
Message-ID: <ZCL9QQSRBWEYrT/R@corigine.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-2-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326181245.29149-2-hkelam@marvell.com>
X-ClientProxiedBy: AM9P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: bf336e79-ada7-4980-e552-08db2f9aed31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZHEAdQsrwES604azxvTKiJyB0e08+D7rlb4dTYY0OJa79Bw0IdTw4AdigC9mGGzbBm9PxsCQOeY8M3c2WrKhxN54H1ihFTL8x1Y0O1PNAgXH4PZyuHdjLPNGAOTf3ke5LlB9fKuQ2IiKbtRtszS5EkCbVnjwY+4KFis+VXFfuzdz3G4BO8VSSkIq1+Zh1bo4PKinefcpKjYVZJlBp3khsv0JvvfeVMvNMxNqawHlg3nP1ufirWMNyfnFXFxU5FSFSLg+FBwxYveLTP/2Hz+VrYPEVXeE1byuUOliGrf7wB3APxSpjGEB1cFoLto9NMnTuukC6AE5o8jxjo2blOGHHhxGfDwagU9cV3PLctMejM3aQW8iuuEKhJhIg7PiE3xP3DhhPDIAkSqAfRk316z0Tas+ETzvRt57r2hCfZBK1Sefxyd32t5s5lfBz3lgCnEA4qAeq+J5b/pWlABcFEAZmkW8+fGrGfp95qNZlf39B/8qd86iAze7P9oQ2XGpoVIMG95vd1jkJbItyG0T5q+SHXhzMkAkL0VQge47Tsfk8pw1cC3MQqvhO3UZrTSURXU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(396003)(346002)(39840400004)(451199021)(316002)(66556008)(66476007)(6916009)(4326008)(8676002)(41300700001)(186003)(66946007)(2616005)(6506007)(6512007)(478600001)(6666004)(5660300002)(4744005)(8936002)(44832011)(2906002)(7416002)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nvt/4pKcNe7z47hWIb531d7/oX4gaqw26p0SMh25qoMbJa6ek84R/twDn+f9?=
 =?us-ascii?Q?o7epjFQ2FDL/y6ZjM3M3esUd8P70TlzaGXsCBl+qTzqzLeybIouOv5j8kqEK?=
 =?us-ascii?Q?c96+E9qA++lwkCX/XleFY2RGgj0KuTduVPx1iEOfB1hFt9uOyf3eWXKzbSXn?=
 =?us-ascii?Q?E2K9ZeRutzfW+OPnOigRmJuiqb4srm8w1WCi9vXtQ4Jk/+PNldlPAfr1CcC9?=
 =?us-ascii?Q?RoSDpDsKulq+yEA7ojYTXMcRAt1MrglxmQqmXpXIY4Lgeg7HXI4W0kkqizwN?=
 =?us-ascii?Q?ZCwjjilQQLLmTFMW2vz7am2e3UHFgT7ovvgXe1Rmgjr1tPDYAYbc+ADBI1Da?=
 =?us-ascii?Q?cyB5NLahti1pB4OOsadP+ziGQYybBdeNQrJIw1oRNGr3hC4fAzUHKd6Coc/k?=
 =?us-ascii?Q?BHXPXRfzrvLjiCGxDDi0YD2IYdpSfP8sDtnPS7BLV1h1vHeVyWidcZuoHNzg?=
 =?us-ascii?Q?YoAtPZCzvma15jFGpbFavEd/AzwFEzs/a1iitDHdUBhVaF5jeEtXAFrG9f64?=
 =?us-ascii?Q?t7W5YemZ84QtrCHi61+SK1Kkgr2QRruMadxTghBZDM8RYGVbGJCQ0ZH/r91B?=
 =?us-ascii?Q?zmZVi6TMIoNH1c+ix6GBpRicuuLf1SRFBY37gcoQQwx/72Yru2UHn4n5ZPKS?=
 =?us-ascii?Q?4R7VgOWskvltaN6p5G+JLbrhrPPtG5qGm+vEcClXx65WoDKhv72QfGyIaoCj?=
 =?us-ascii?Q?sjTgpJTleLgPwxsH+SREXvZGN3V2f+bL1J2wvaXcVMohUaCS0WQPsEZdikTz?=
 =?us-ascii?Q?CtTniDL1UZ0d/VLvMdS1AVL8eraJM3qpwHjLvjFNu26pV37tz7QAhAkEUp52?=
 =?us-ascii?Q?Fweg7GgcRrnOhGmmzEgBXasjIRcou7XC+ZYymqltCsJqvrWRGy9jNyd+HZwW?=
 =?us-ascii?Q?B7WQhsFCJwpXA3U8sTIH1aTE8POjd8b3k8x+QDzF2rFudm9QMKIbJb1Yw+ds?=
 =?us-ascii?Q?CW8Sti00jETIKokUq2bB2TjqEyi3Yl4OMnal5hzsQebGUsv5oP35m/S105Eh?=
 =?us-ascii?Q?Mmmd3hDzwr+LQBb1Cq/Hp25uhjW4R4Ljty+bVqaE9XleKAOJtU6Hqs7JnMZj?=
 =?us-ascii?Q?uzdGvcM8cv90QqIEqHwqJHFmkCVu1wGc/PoK3dLEvgLrVtOSgTvz9QdIYM23?=
 =?us-ascii?Q?HuvCOZ6p7lXJ1E1BCHbj0+ctm4rMbh4Xsa6q5sYxh6zYe9gwZT4A8UZEILex?=
 =?us-ascii?Q?Kzvr4pJuAdmo0QRAUxZjwqq9pvKVdEMQxgSo4dBhz5E4GmqnQtBsM71Td/d5?=
 =?us-ascii?Q?uhq2UM+Hwm6ooscvVpr7Hm4NSzpu0t7YC8enFHCBY18YlxeyrqvLwBgEyfOu?=
 =?us-ascii?Q?L86NcwhMext9/trHUPYB5Z3rEakLes9fb/Cbl0IRBKcrrrIqiW+PuqszC+ce?=
 =?us-ascii?Q?uL0XFbkaViRg10YHKSY96kin3oAYVby0FX3QBywoqaEteQi77hGhZf5HU86x?=
 =?us-ascii?Q?mvy+/mUQMRx9cNrVaXSQkZkWYZ5skDt/195J71EwrRZq/I3e8FPjHb5eOO1I?=
 =?us-ascii?Q?XYNxcuadjc3jgtI1jRN8n52aXLbn1ZltaMAMdU3mWxvHTlV/0rauCBj/KPd/?=
 =?us-ascii?Q?5nITypMdde0kTV6NmWLkZ3LNltCEguoYS7SoR/tS1YrN7KQbSAv02O87bSrW?=
 =?us-ascii?Q?O3KYzi7LYfpLEt/bWNBg0KouzrAOUdgxyKN3nXvZ1vWk08ATDkMA93e5qlYM?=
 =?us-ascii?Q?ePTdAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf336e79-ada7-4980-e552-08db2f9aed31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 14:44:25.5750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCed7MMxllQ7RVP6MBQk/LhT2y5+FGZbF+FKqYLkIGYzmTRRe8nu/0EgfHJWSiThvfl+RYmhQyQuX0B5q1Xdz31BHQ1dLNfgl47EW+dWcmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4914
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:42:40PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> The current implementation of HTB offload returns the EINVAL error
> for unsupported parameters like prio and quantum. This patch removes
> the error returning checks for 'prio' parameter and populates its
> value to tc_htb_qopt_offload structure such that driver can use the
> same.
> 
> Add prio parameter check in mlx5 driver, as mlx5 devices are not capable
> of supporting the prio parameter when htb offload is used. Report error
> if prio parameter is set to a non-default value.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

