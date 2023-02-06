Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03268B933
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBFJ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjBFJ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:59:25 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E4B1F90B;
        Mon,  6 Feb 2023 01:59:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbMlZ4N/GNnzq/zc6U+0huWaqC5VMIMd1evWIAUyStYIdsp54bIij0ti+zbUk1dMv9+Y0s+ksPujNpCW9ubBTIDEqLGc7SZKrmiEq9p8JkvKQtw6PSnwpPeFvnUieUZG37+Y3SSv5NXCBOdhvngzvnooUqHTisWWryJL8llPffAbvKqu15OKETdw66HXQpecINh0JpmnKf2+8xOUni7dFr/5b+GTjQ3rk6naZl0HPRlbIwWym0NTBUcTS0bGBtpalYcaT1vh51TpHb9+pfPdjFkYkxk6Cn8cLWI0xulWVhea7BoZAaewVABxA+cAZp3z+4RS1P1maHmXd50LxfScBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlDFuUZcsKuplqUSkDLVc/XmDPdiLiz7+4YO0QxpTz4=;
 b=Me1iccc4IVbjZoKMY24Ku3hcOYmxJMSbGJoqYKnHwVbaDzJFRk4z0xe08APF8omHpcHpdPoGasuf12tqzW53tGUd6NaFWsXthECV4CLkoLScltT+v/VcgDAgd3d+4yFUwfY/kwcRL4fKiMVO/SA2sLwN1gcB56peNNOBc8DTtwzsr6a5FE9EkhAqiu7SwtYfzmluAIVm9FtQgVsdHbGwFbcDsd3UKruC72JYm9+BWsbkXSCQf+2zLdVhV9ywqJYfEbcHbWnkZDpZC5wqMwZJ9UJLZzr2WoKrWvp/57TG99l6RHdXcKROSIF2GBOR+0aWOhkNtZzqWPmzt16GtBC7QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlDFuUZcsKuplqUSkDLVc/XmDPdiLiz7+4YO0QxpTz4=;
 b=r36tQ3oqLstzSBqnBQyVk4jf8+hQHLbU2lZo8uS5TeS/sSm1ImsrjC2+k7/vuUB8i3NmPKlQGYqtkVz5dMpctj3km1V5bNij2Yi2Euqm1+R1EPfi0cMPhVjNeypN5PJKuDOGcz0z1EEmNz6GKlXcCFgbS+Ii1Ag1v9QXGaLO5V8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3752.namprd13.prod.outlook.com (2603:10b6:610:a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 09:59:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 09:59:16 +0000
Date:   Mon, 6 Feb 2023 10:59:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: lan966x: Add support for TC flower filter
 statistics
Message-ID: <Y+DPbbqPyskMBsSJ@corigine.com>
References: <20230203135349.547933-1-horatiu.vultur@microchip.com>
 <Y96R+oEaZijtdaFH@corigine.com>
 <20230206095227.25jh3cpix5k55qv3@soft-dev3-1>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206095227.25jh3cpix5k55qv3@soft-dev3-1>
X-ClientProxiedBy: AM0PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3752:EE_
X-MS-Office365-Filtering-Correlation-Id: f36ed5fd-5be6-472f-0c73-08db0828ce91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09PTa0v2XdNGUFUUBSEC2EpEOgak7e0rgjxDEIs1+viEMFvOLA5cUlLqsErkZQjwCik6ifMjGmnFcIf2a2M7WZ27VGPj3+ebsItMpHmqBM+XP90AieKYZPhkkTgRgJwltjknHWOGP1w84dQYNy66HdGjNFMdqFGXGLpcrARN0UbJduU10PlrkY6Jyt9gPJgGWjCiBIidI99xQpnzM1awGSQYKJuzhmlCHC44eAupvG8N3ZaCu0rSG84hHCyc9V3xL8a4GSxUp7j/Et+2jGNnU0Sk5AyjhBC8z5HRk6XgFRa6cyKVwB2rh3SlynfUkPPuW3M2gQOB/+lOizH/RPElL7agncNH4/FlQ7kIAugBj9GhTsrscOk4xC4/9PGEAsYsOPO85CLFlQGRC/eDcFr30XpF/dQo2jhZUQWNx/eCQT92MW+HhHeoslsEpEOPGnQ2kcBYZ+b3GeZ0rNz15L4P8idLw5Vpcq0Fl2Jiyuk2hCP9otXj+Kjor3sBL3xUxp1I4SvTWBT1E/YfWSvqMFP5fotby+A3FWN2jrJR90l9qVrQlyiEaoYv1XSjcIMjCt/aZCi0fNzuCv/z+9ZBpipLPa2UpCmLnNFbttKxs8chtq0fhn5e3GemUAcN/2ChW+kPbMgoDtTGvjI3k3ll1cKMMi11QWTyIjjUvWQ564Jl0RRjUgHd957p1S66fKAv4WKC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199018)(36756003)(38100700002)(86362001)(6512007)(2616005)(186003)(478600001)(83380400001)(6486002)(6506007)(4326008)(6666004)(316002)(8676002)(6916009)(66946007)(41300700001)(44832011)(66476007)(8936002)(5660300002)(2906002)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wzJ+UJ+3F7qFBNDVfJ4JBNhfZ4QRIg8W1rO2OOVLznC8zqAmkLJOnBuebrk0?=
 =?us-ascii?Q?QIYPeDLCGM8lLGTAxJcvWWgXb0xNwR9Vmk/gRamIYDkX6TEtYX7okAh8oNuT?=
 =?us-ascii?Q?k1JENOgITmP1To9JOSO8j8oFK/BYCnf+xTQeaUh+d7Xr8wmFgmaMVhIcp27j?=
 =?us-ascii?Q?UMZIRDp/UjXga48GncT+93PDpefm1xd7UN9W/o8VZeBzNqdrb9zbsCkDhtA3?=
 =?us-ascii?Q?hopqRe8M+6XShLdNbhQ5afh3Nj+qGbq0Qdt1ctJPnKvDVuV73IOJZ5tQoIrz?=
 =?us-ascii?Q?8xZCFPQ4vaqRlsZh2AKe3b2RZIKF+3nKcaRlW7E1yml8RrCbxNgt4UisJBKa?=
 =?us-ascii?Q?TMNVm/Y/Xmcx831VvxkTEvEIbXjtuptAoFUip8R5H2jDD0vPiVf5iAU4mROV?=
 =?us-ascii?Q?+EFfh4cGJ2VZagXa0KjFmnVSPDJcVC3RNo99gUgMsi0Xys/2jEdOqLr4aUAx?=
 =?us-ascii?Q?OAHsl3d1Xbggq1IcfeFV7ncORfPdfYZNj12C9sNyiMeG9ToAGbU7C8qxVOPe?=
 =?us-ascii?Q?XzAVy2G6cDlEH+h+C8O62zuqaBNRafnvC391tHZkpxU/gR6rMx07rrAglLyO?=
 =?us-ascii?Q?cDJcG1I2fZ0vSKL+Z0X/4Psp9hkomiyb+rQp4Q6gH08Oh3lhN+tgqqph02Gw?=
 =?us-ascii?Q?3Zmc4qkoXtXMVCRcmbQnj+MxGhKGn6YWA7xiKW4ViEHkMKDEg3LQLJA7zZFv?=
 =?us-ascii?Q?hzNxUOB4yWkRhuUtBuReN02ip+UDfP9b3favLPKXTYqp/r9HnzCVN2wq4Ztz?=
 =?us-ascii?Q?ec5jZzsCilxr3xZ4AgMX02yYlQ/yokWjZtUeK29dZUzbsk+8RZDP6JCTyIA8?=
 =?us-ascii?Q?LhCCd12RpI7R3x6d9l0apadY9CD6ZLzTX3vrKgkIAEzD+8v4V4LO0U9k5dbN?=
 =?us-ascii?Q?/KLMHqttcx4tQWUrlJWcXgYI+3fyjJLgUMcoMEVlQSb4LUi+c/DJA0uiqF5s?=
 =?us-ascii?Q?31PlP9HLHx20R0QcnwRR4Yzt559HYuE35t+wjp131oncOBrJ0nh5AWsQHK2l?=
 =?us-ascii?Q?bmjQSaBeNj3/CBBc6/trLqbI3bG8C3B8PzS1PzbECSMd12ourQ5B+uv4E07A?=
 =?us-ascii?Q?+TvFV1czYIkZ3fMeakXzpVu8WmwyfANdik7/RQSbRm/RRLafW/HT7x4R98ye?=
 =?us-ascii?Q?P3ZpbMYl55XXxnYaKiuH9zUGncBtLQkO0oFFRP+lC35U/YieIqYHQn/5wsOE?=
 =?us-ascii?Q?mvaxZa6evpzGqRsGnlRY5dpUSvGcp2oAn0if/Bh6l8ClP640iLn7GHwDYVWT?=
 =?us-ascii?Q?PaViWeNhtKlgWbMsncQwcS6h0SACB/JPUE+fOGWi0tb0sVEE4ymFGsVZUzx8?=
 =?us-ascii?Q?zrvnDtnRIiPiAj8KPrF9mBA/eyRGrTfSqmKqCf1noT4ejIZcZCAiaDCuxDmP?=
 =?us-ascii?Q?ueRrbRR2CMPI/mxu/kog+W6YkZdEVbwstl6xEVU8IEHpFtnaBRaRbkPQnxU0?=
 =?us-ascii?Q?mhXtLe+PFGiBRBSYqnCqOJZr1RPbxg1PsaMidi/pFsNr9e0Dqo1E+c28tKm2?=
 =?us-ascii?Q?QGpMKH1g692TX7K+G52hxz3FpCtSonPTDs+7NJTh7gswPj7OWagYSzT5sEXq?=
 =?us-ascii?Q?FEIAfhVzdOtYvrx7FvLI3BvIHttexRTsbvUbMl2lMwFNgW/4gkPWKigxFfbw?=
 =?us-ascii?Q?smN2SMTeXjWdPkprRuy+B0MJCdCwz13JkTS+dw5EnFG2gcH3X03Kyn4Z/JTe?=
 =?us-ascii?Q?+pdkeA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36ed5fd-5be6-472f-0c73-08db0828ce91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 09:59:16.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihFSEay7n3XntrR5spmar2VzhSGNSwSfGa2q0rxJyFOsSTS1HUcLUO4RXQBRy7+zTm3FjgZ4u+bwCFMH+8NYDDk+PPfNs6qvyuiCZz2B8vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3752
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 10:52:27AM +0100, Horatiu Vultur wrote:
> The 02/04/2023 18:12, Simon Horman wrote:
> > 
> > On Fri, Feb 03, 2023 at 02:53:49PM +0100, Horatiu Vultur wrote:
> > > Add flower filter packet statistics. This will just read the TCAM
> > > counter of the rule, which mention how many packages were hit by this
> > > rule.
> > 
> > I am curious to know how HW stats only updating the packet count
> > interacts with SW stats also incrementing other values, such as the byte
> > count.
> 
> First, our HW can count only the packages and not also the bytes,
> unfortunately. Also we use the flag 'skip_sw' when we add the rules in
> this case the statistics look OK.
> If the user doesn't use the skip_sw then the statistics will look
> something like this (using command: tc -s filter show dev eth0 ingress):
> 
>         Action statistics:
>         Sent 92 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
>         Sent software 92 bytes 2 pkt
>         Sent hardware 0 bytes 2 pkt
>         backlog 0b 0p requeues 0
>         used_hw_stats immediate
> 
> As you see there are different counters for SW and Hw statistics.

Thanks, that answers my question.
I appreciate that hw has limitations, and this does seem
to be an appropriate solution in this case.

> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> > Also, not strictly related, but could you consider, as a favour to
> > reviewers, fixing the driver so that the following doesn't fail:
> > 
> > $ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> >   DESCEND objtool
> >   CALL    scripts/checksyscalls.sh
> >   CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> > In file included from drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c:3:
> > drivers/net/ethernet/microchip/lan966x/lan966x_main.h:18:10: fatal error: vcap_api.h: No such file or directory
> >    18 | #include <vcap_api.h>
> >       |          ^~~~~~~~~~~~
> > compilation terminated.
> 
> I will try to have a look at this.

Thanks, much appreciated.
