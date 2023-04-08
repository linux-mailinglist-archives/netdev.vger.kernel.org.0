Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57D86DBBCA
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjDHPVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 11:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjDHPVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 11:21:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAF6EF9C;
        Sat,  8 Apr 2023 08:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMnG4RjDhprLxzoV+pt/A5NCl17wOEnEqXlbOPlJMRpX/IbzQk9GiElreDx2yjBabJTh/uPBtE6gaMzboShf7Bh9H/4zCbjh0BJwy7dt7WqJR+zoeinRzg1trwG0aJ60d7FI6x6rBikg9qPzw2arki4/q57RBM0zzK1s7HPVlim6fBOt3u4oT8qwnIs4B/rOuSplnRXXRED6zsyVDQP1IFRZMpeQYWkaS80pWHaWlRMjTPKgjwpOGu7U/FMZOX30g5YmdhZ70FaZ2aS7UM1ctGvxCnTKG2GnhQnWkdRFw0J0oP/yoQt1MGEYPbVXi/J056bevWdZEOhsWBjvCVER3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYLB+YAbmVTZ7iFM7zlBmwzDUYErOzmUGfvNCmr/JSo=;
 b=WOdce44nfCqfxEsWe8nm8qzJ2hF7wkxID19xG6lt83wILvVN1jrKztGsvuekR5FJXX4lhGb4avw9Im7KMIedW/y3h199TdWa/vbt6OeuvAjgxRt+/SxP16uRkZmHIGLwiMICXKIsrr2KGttnmwJRy2zY+txIbhkFCBGaIzTUBC1JZQB6f+N6iHIhgAi/kCQhlcAH3QHVMddkCStAbehllxhNdD8U/7CIHFDZzEx+C/5LaFqrStml/aFzbQcPuZMtG4p8xxflf8BDEMbttThziThY8hxHUwL4D2EJHJxjdIw0bjIrj5HS2Rha2MeGo8k48E/lTPrX/aHjQ5Q9Z1jxvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYLB+YAbmVTZ7iFM7zlBmwzDUYErOzmUGfvNCmr/JSo=;
 b=Sug+1FZqQMv/8oFs2DMNX1a5kqQ7eLk2bPJUO/48L3UQOnvQ5oh3YZ+i0HUL5Wz2eQAot9dgREZq30/xxEH7Tvu59REFvglShFxzGjqF/0CIjpQkhAdzz0BlqDWCFdJt/fWw3t8F6u7AYBWfHHQLJPN2mINqUOd1eSbDPpINrtc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3806.namprd13.prod.outlook.com (2603:10b6:208:19e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sat, 8 Apr
 2023 15:21:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 15:21:28 +0000
Date:   Sat, 8 Apr 2023 17:21:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v2 5/7] octeontx2-af: Fix issues with NPC field hash
 extract
Message-ID: <ZDGGbyXDjrnoJRcd@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-6-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-6-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR01CA0176.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3806:EE_
X-MS-Office365-Filtering-Correlation-Id: 23053fa5-6613-4968-da63-08db3844ec88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iOj579rOEapKEXa6kcasSuM2cCU7dsTyzZEPLl3J9RhO3jGawaybCN8oGxdUO4OwVtR1L71XPniNufEZ44rzL1uc+zcD7iZh5YpFp4TvoEhvCk2mqz5gOijs7rylwJLFO0ToRlGHFjBpURhIgZEGhHPCTLUQR5lnhj639ggsIRFXnhBev0beDRTGkucuDvjeu0l+l6q7/KIrmMhSaAmJ/H272ZdjWUHqG2uoX0Cmdb8iGvQkpKujyjqx0O6Mq47W72eL708PkgHaljY/Ah0oDVAigi2Mkt3X40qS9HP1Jzf4+WeBCROkfGgVqSTGNk9zvYS9okhfg21FJNQs1l4FivrDgRzoadZ4PDZE4tZf+0U/iyLoCK9XGrlc5cqec+yXvE5xjXYFNKbgrI/Wt0jrh8UHy4FuvennvtnptLflVoa685iSr/SzEVj/5czfJuYpTP4mhfPOGOJBvm1mgcUmEsSM330DuGZlzadDiDpK31qZbtQZ6J8vjNZyAZ0BGtUv1GuwztVOXqTVWeSaQDrC4XZdIoP4fbemPO5FgWvFN9fQWAtpfliNKpn1XAlQkXkB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39840400004)(366004)(346002)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(4744005)(2906002)(44832011)(316002)(186003)(6512007)(6506007)(7416002)(66476007)(8676002)(6916009)(41300700001)(8936002)(5660300002)(66556008)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hgbzEyChY4QTPeDoX2im9R5sL/yvFc1yGJqHrPSQfqivoRvAOsbpSWVYfOe8?=
 =?us-ascii?Q?trQuRWBHdqQqGUx9/7IXdbTYhI64T/5oMKL9G8pPf7u6fnwsSAcuqEFvHiTs?=
 =?us-ascii?Q?ekyTgQG/YWwtsftJgORgS+qVTlJRWUu8/yeFnhA4lbIZFLdCBiXl9SoaCgfR?=
 =?us-ascii?Q?ryx95W8GUIMbG1LWAqUhR/fWWHYMZhAV/L7y4P1bwlUD+L2MqpXqWtX13DAe?=
 =?us-ascii?Q?1xDIzZ1AEcetRnF2DYTijY9BYbbWgjgTvsnGBG56cVLUgoLU2A3E+Q5BPEaT?=
 =?us-ascii?Q?3gRLUOzIKieWIJBj0ak62eTKvC5f+f2ivgZJhV2soD4xHda6dpEmR2YRaLJL?=
 =?us-ascii?Q?IXouc1SlEEgkfzEY+iGCXQ3y7LPaWhDkuSF8WJbQzwb6nEJnVLKhyg+Buex2?=
 =?us-ascii?Q?Q/wt4GgbcmtQLULmeuQrf5/AqZ4ZPDfv9rCW39z2Sg0kQttp+CVbT8rF1/Df?=
 =?us-ascii?Q?nYka7NLhqLlR1ZwsHaiSyj5pCRMUAHUubbfPKHEyi5gyNFbBSXqm/MMIS1DI?=
 =?us-ascii?Q?03zHBkIUA8NQAAHDN+BNCmGv6iqL9Wvq0+micl5muXShcp6rvPjlD8/ElKyJ?=
 =?us-ascii?Q?wTOwzfuyzuhmIBsrBNaI6NKaW0ZSwKrRDKjJZbQggCLqhhEmhGnMZVrya8Hh?=
 =?us-ascii?Q?tqYxGXjhcYXcNgo1dTRQ+mh70NlB9AyQX10uMRs1dD6dCN+6nazLUhAWl8So?=
 =?us-ascii?Q?VEpaTktCmnZFLxPoNVUuezGRSo9OcQxv5/RDmR1375JVAwuByHNwk9YxBEBf?=
 =?us-ascii?Q?3+6Elq6GsH7metsbI6kBBAn6A+IrcuMYwKb6lMvMEDiB9rgQrV0kurXAiVOB?=
 =?us-ascii?Q?jv96Yq0iFwwKaq/xQW1ZPvEBJGD1+aVy7eI4HYUqjpQDJWMhnuSCJq/Essk0?=
 =?us-ascii?Q?NqCvxRKch8LuMr0H0+wvwozvfKnOh/8ccOCvlWKyqB0HbA0xbNHMq1LjR6s6?=
 =?us-ascii?Q?j7w55AeS8SFLwdwVN2VGE0umAtxyMA68DNGVRxgNohAT3lx266eHycmyr7M1?=
 =?us-ascii?Q?DDi/vbvWe6fNDIg1+ucnDzxpPmvVlDs9onfTZRF+xXEwjkOfWeBwF+n5FKLq?=
 =?us-ascii?Q?0XNb2KkX+xNyfbKYeXyh1cVmdJtWH2Md12TSzu8SRoEzWcWVY58w7e5UKX98?=
 =?us-ascii?Q?SFmv1cPVu1EI0b0zuFLoAkzYY8kP+jLHrVMXgjgHRnbOVT0JCa2tSfS/yv6I?=
 =?us-ascii?Q?up2zPNC8ukVkd9WtZ80evVOYDnAlFy1+WduS+qcVIk1l0QT1aLlmuDUA1HJU?=
 =?us-ascii?Q?hXXGECWrwq5XuTHXnfOS+F6tvnKhhpGUXzOJ+ZPgw03XJRsJ+DD8yx3n8rxy?=
 =?us-ascii?Q?IFXCA6oY5XBKtNHOlkYKMPLqNL0PfW6Q7e1PwzTDMRljXvwZvzrzuAC3MePO?=
 =?us-ascii?Q?EaG42abDWBXEMYYymICxgawf51W84wDrH4TTVl1SMxkcZIzEDl+iEj1wHjST?=
 =?us-ascii?Q?csPNT7MuRobIWTjO6fYurK3S9K4rn7hGJ6rhWWWOjF0rh9VlVTky63IzqkBU?=
 =?us-ascii?Q?IqWSR0M9Vmyu32Q/nUnzdsOJdxNz94t7kUft1vfkms31qajWRoGcvG7YZfnf?=
 =?us-ascii?Q?hu4pAS5RHE/05Q43DAKTkDpRMIKNuWYlH4k2cSQtmnrl84E9fHjneM6Qk1r1?=
 =?us-ascii?Q?nhE1XVqfYJOyz7LBt8b6CJofvuWNDWpFptkl4+EN36ZwalD86Y8AS7qn4L4i?=
 =?us-ascii?Q?V66Lrw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23053fa5-6613-4968-da63-08db3844ec88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 15:21:28.3368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jpxFGEFoP8YGKqPRenMEHmGvXTg3MI/6whKfha6C4r9ne0ZIUPBBqkmmoP/YE2Gt1oh57VJL/CbukksUvhUOZbYynjJ9GSBhFTo+NhQ64Ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3806
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:42PM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> 1. As per previous implementation, mask and control parameter to
> generate the field hash value was not passed to the caller program.
> Updated the secret key mbox to share that information as well,
> as a part of the fix.
> 2. Earlier implementation did not consider hash reduction of both
> source and destination IPv6 addresses. Only source IPv6 address
> was considered. This fix solves that and provides option to hash
> reduce both source and destination IPv6 addresses.
> 3. Fix endianness issue during hash reduction while storing the IPv6
>  source/destination address as hash keys.
> 4. Configure hardware parser based on hash extract feature enable flag
>        for IPv6.

Hi Sai and Ratheesh,

there is a lot going on here.
Could you consider breaking this up into more than one patch?
