Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3436C5143
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjCVQvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjCVQvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:51:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2114.outbound.protection.outlook.com [40.107.223.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ED25D47E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmfK2bJBfRwJ7Kjrte/JZejecp2WiQPto+Ri+g6gKmXW/orQJfK2Bo2huxsfjmIFoWl6lijY8LzmYpU4okeshazgIhWezunhjfAr1cwof6ZrEhYCQYgjSj6njnNsZ5W1Q5WSPOBKpuS3UNPXtLirug6JYOgYaCOXNQ8TU/TUJFPDG3D2VELM64rEt1qoHtaXF7+Eg/55Wn1xmqOVVjQasxyYS5EREtxf7anM2Unt2YWRHM4xsF0foT73EK8l+YcKhJ6BVlOvKwJQ/Qqx4P9kZFeYzf13wFLxUKHyO+0UOd0JTuRYxUajiAl8cUU8NStoHiBlJcfVOfF30jLOPR4EeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVkAmOaJGvT4VipBUUWEBYuBOLLUj0mzLxnbH4ofifU=;
 b=Jbpx2iYVrZ+MaIQwBfSIky9Wq0FMSIZr8PUgHE7peRdiT3Iv7ClX9Ks7+Zd85tthANU4raqBfFs9pNta4eKhoH22cVSUtYJ9J+RZf2wRGCLyiyPc8RH1O27qpXaot2oM5vsaqaiavsoXkBfTYo+rhj0jkZ5PA5ESlxtGfNfvH7ghWI5WgrcSf64rur/uipqOXZDJoumJT2oMqj31ZhAuCxjBBdu86mhFvyn9bTfD2SyYoK87BiKmRngNJtE7mRPie1jPpbR8bmS6NOLDHDSJyXtzzof2mMstDfvdp9zTipOaIP5NzYexdv7BlZSr6DqcOl+pEe98djjlkzqWJapmiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVkAmOaJGvT4VipBUUWEBYuBOLLUj0mzLxnbH4ofifU=;
 b=DfaZmGqusahUpoFlXQgnaIJppZJcgbAm37iIwzy4eGfZq3tUnx9+7dcvd1N1Bt3bP7glBD8OOT6IALDwo65EZtUl3K1oIamv09CoWrh/Rys3YLqzGT/h3JgVUNlsPNExAF1L4JO9QzEfplt5DOvYNnQjj5d8f6ewRbtGE624aSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Wed, 22 Mar
 2023 16:51:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:51:22 +0000
Date:   Wed, 22 Mar 2023 17:51:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: phylink: remove an_enabled
Message-ID: <ZBsyA8JnoWpOQPIv@corigine.com>
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
 <E1peeNy-00DmhV-E6@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1peeNy-00DmhV-E6@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR05CA0092.eurprd05.prod.outlook.com
 (2603:10a6:208:136::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: d8e6da16-3928-4eba-af20-08db2af5aa90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3oQm4vnFSw8R55j4ZyPfFnqcflFb4HGfCUs9sPiomliZnSb1AJv5knIdAOWLWO+bjRFRzkjL4Vg4NjDumP8cfbmJvNJyd72NM56zNvYCol2T7Y3ryhZW8wNjcQ52Qa3Y584q9TjnJSh3lUg2oPSxGh3GklgOOPttUGVt2w4jPVqz2v72TyzZP5ELRiutd4E0X+pUuNFyjMHA0YaqhGaKmvqf4Eq79jurUZ7ksjivnKklRHw/61T+f5LlS9pL+ZyFtlaCSCWWico+vdbxNsxWqN4PwB/ogtI3LqCtnhO1S7543p3JcW5K9BOyg89dtAf+Ml6E1PH2S/b+YkUlWczpvawlrS1DuQrpK0zAUBr6nO11o0PgvaOJtFZJw4IxnQttc+uqCthkw9YEy6rGmNGwu2XxJd76gfV0Gn035GEam9Jo/cA43k0oU3WvNE//yVvhgjYIqA7gKCDVoY12KhHUc60sjuKn6rGEYER5myUyUO4d0/UcLphXXOufgywhcZcIZYnRPz2gmP9AWNWNEK7lWeisZMQOYOEX/e6enOK8iVmFlPLZZ+ZekJzOMgpLCpkpId+nT8jSJsDdJBQJFvPXqeSfqSLimMHlPp4RDVnKJ0xvlc1gME3ISFUEd0vkBmGoXPdKJGrpHrhgnib2y/pBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39840400004)(376002)(396003)(451199018)(2616005)(316002)(36756003)(6486002)(186003)(6506007)(54906003)(6666004)(86362001)(6512007)(478600001)(38100700002)(7416002)(8936002)(4744005)(4326008)(8676002)(44832011)(66476007)(2906002)(66946007)(41300700001)(66556008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Ym92MLelzJDSrM7llhqnuX6Vcy4gsDZa2TLN5IbH3Ut71lnapBotSx/4yWL?=
 =?us-ascii?Q?L3KYKyK9mk5l+ydqLu6F6WI1jJnJxJKlQoILPtkSxzS5ADw67ykrItfWTvtt?=
 =?us-ascii?Q?FkSGgCXgSAwvgWNUoBoxw4RNfkhZynjtgOrgrsOjlPyhghdqzeRvbdcx2kRN?=
 =?us-ascii?Q?iCRUDvpcAx3LLtSXX0ntOozYgDW3oEaIYCtE4P2STdpPVOW8a+8Y2AkxD1vN?=
 =?us-ascii?Q?o6zRYki9gsmGi1z8dv3bn1aGf9wTG9MOGQCtZs6iZ0QMZBSyWAGoSDWJzMqZ?=
 =?us-ascii?Q?rJ/DK4/KwRy/T/ypcRzu8o9eZCj8mqjuCQGIRsGixaj3qSWU/Qs9O4a+NCIp?=
 =?us-ascii?Q?ZHeKWZHfFLtvc92dPnwpv0wu8TRyUsRKQ0cTSoTt5vTCp3keAPkIKwgxlqfE?=
 =?us-ascii?Q?DgIRHIjuBfKEvX5jLPYRi24aC3gttMuwjiulNXcO3+0KDnLSw2PICP2FiJbX?=
 =?us-ascii?Q?ji5EMoG+/+roN33gaponmE/RQUBDNsL5OzhDpdGa4o2+8mJZaxRbdQ9uKXQz?=
 =?us-ascii?Q?1kna7RZD9oMpN0PSIFDtXvd9SuDyJbUIkNyJCqxZFqk1SdEuN5NPmfD98npV?=
 =?us-ascii?Q?2ZYSb8BL1W+2dPnd7+UN61++hd+/KayIZgPopWR6lxDE/7xNkeQOxv18csDT?=
 =?us-ascii?Q?q43nTGmY9TA5bbbvoENW1o2u3ZgF0ZPcs/P5djlh9vHpvNJA6eOPjihcMk1Q?=
 =?us-ascii?Q?grKNPF54usCn5BvtGmgy4FTYpk8mTbHN8i8hG7TPOIEwMyqq65V172xJfsGs?=
 =?us-ascii?Q?6TGdfi7VCEzZXjqAaUT5uCMC5j/eUC0PQtQoQvLOE88VFvg7jQto3LQeWQNQ?=
 =?us-ascii?Q?hdRIz2+AS1onoEUbpL88X90tie/DueFRfu3CRUiQZhHX25eFwXtXwu+9YvtV?=
 =?us-ascii?Q?Xiu9UPx5GLXVNAOAkSmA4PqetKKLai83v7GGORiwNzstbUDGsotyia/NTocZ?=
 =?us-ascii?Q?qYM2wzjzi+Mlaqy/BRWtIlqK8YV/GCPH5s/rCQ6bdV4GQMHWE9vUIES0yl/9?=
 =?us-ascii?Q?Yr4YtQyDyxkNgarwI1ZzaKWRft9g5KR9xuo8LU/K21UbLxV7eJ8h3oeEpo5J?=
 =?us-ascii?Q?/6hyAK0wNaR3FWoEkb9P6b9E374UytQ95iDXr7Jb9YBtEY1UVII6h2KH3Jq1?=
 =?us-ascii?Q?DopbUNh4wabx0j5Ge5oWGn5V4eYFmaWFcu57pZgGfUmdpqj3iFHkNus1EajD?=
 =?us-ascii?Q?BjP28Tpy7TtTLE1SjdEY2E5RZ3vYFkDpQRVoQL49y5RHQeL7VCQrDqEk8ZR5?=
 =?us-ascii?Q?mW9r3qLlVTtngjBeSurDjOk6R4JX/OjMrnX2btKfILtJc4UCoMRzkJqyPhyf?=
 =?us-ascii?Q?wscf3jTIufQoFOffUf8S/uZdXeqt41dDnazle2n44rN+Yi1fjNTJLwsuypys?=
 =?us-ascii?Q?ZwKXnzGPj//RJPgshW2NoSwY8+26QQ1Ngv0L7UnAIjzUk/1BRfEQU27xWvfp?=
 =?us-ascii?Q?HFDnw2qFvE955YXvN/M5Ev1SefbYAgXvia0XX1qVpckPOiz+TjwKmPSDhdqp?=
 =?us-ascii?Q?fsXyN3AojRG7xa7lAi7YfJy6JDLKpymrTGJCuFIhIWeGrLsbGDQVlt3cfRhS?=
 =?us-ascii?Q?OnQb/Z0loNlG70At8CEdF1Q13vTliXvK/JmlxscIEnoOKC1pA8phz0UfWEWK?=
 =?us-ascii?Q?f6RmisVdm3dsnOo6UOH7ca/zndr42OJuF6FqqYUrSpCTC3tkim19I34nN5bw?=
 =?us-ascii?Q?nsxFCw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e6da16-3928-4eba-af20-08db2af5aa90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:51:22.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzR1VJyxKAArpuBa9mbEU4ot/ceB+gKurPtWn+whW+EIwQVS77T9RjljDaPZLvU0TLI0pAOZvezd7aorqPzSWUAdrRvG78sFbGF8rtMEiVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 03:58:54PM +0000, Russell King (Oracle) wrote:
> The Autoneg bit in the advertising bitmap and state->an_enabled are
> always identical. state->an_enabled is now no longer used by any
> drivers, so lets kill this duplication.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

