Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AFA6C2BD9
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCUIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCUIBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:01:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2131.outbound.protection.outlook.com [40.107.220.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5873B869;
        Tue, 21 Mar 2023 01:01:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erFqLGVjf/MMh+v3u2GqxWwZaHC3+moFhjMsq10VQJR0/kEFoLTKn5YJcxfkDENz6n7XsCVOnX5GaZyIhFs6IjlM3Z9SfmMAZTdIfjFlgvOgDwaW5GuQvmmNSlZRXkRmE+XY0YIWoQbMUJxENKLu7qZtzdmy4tLHwLjYeNaN+woOVluFxcVbWtt3HO64wGIudPaVpqNBnLP18IfmCpDzuDT5VB6E4mYGQEdASvHHP1Vh4Z/nlX/Kn8rEFw4mw7yHvS/cLVKmAK9XKk0YeLR91JawmuOE4fc+l7heeehrFEg3xY0tjmy0BgPO/yN+ccM/hcTgdONVdUXIJk7x8ybqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3md80SeLaJA7eMdXg3IFlbsE+AcTDY1SftX49Io7cc=;
 b=jfjm4b6+AA9iRplUtazZe2IvYT4QttR1rmcHHzMXbFpIo7wFrSXI5avInhurIb9QqyPdHDCc0YJFzJRkkoL7rXnr6x0Lm4katCbDUfEVanRym0ZGEuoOcwV6soxFyRiQraGATdJ335g19Cc/qf3exKBOqMBDhr8zDdzHd1s8rik4L/dDYo1sisRNprloOEbEOL8hHqy1rZwpm2ZIcQIW5xCH5lHUGgyfivASYubu46cwEKObBhxpArY72ONZYgpwYDtb6f8zSfIDYbpuwl8+KkObXQgLjU0y9Cnk/sQviry+E6HwNT+04DtLBWFYl4Esfl9LvKQ1Q+oQiBU8p+wN/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3md80SeLaJA7eMdXg3IFlbsE+AcTDY1SftX49Io7cc=;
 b=RPvoZb69zfXjq62zXxPH+Nt7iuK5Jk4dW1T1CHwApeFLW5nbjMyViIFaVgNXRMbtcjqGQFOV3lxjMqtWT9WcN7Y7scNj0fpbY8FMZETemkwQnQlgQos2h0i+bnjBkXqxPK6bIwclr29GmcMiXApWxfIs6kK6aPupBennf8QW3kw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4494.namprd13.prod.outlook.com (2603:10b6:5:1bb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 08:01:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 08:01:48 +0000
Date:   Tue, 21 Mar 2023 09:01:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/9] net: sunhme: Clean up mac address init
Message-ID: <ZBlkZxOxxfFnIMyu@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-8-seanga2@gmail.com>
 <ZBV+cK8YAXI15tsL@corigine.com>
 <7389fef5-8fe8-4f24-f762-4f3597ad0943@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7389fef5-8fe8-4f24-f762-4f3597ad0943@gmail.com>
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4494:EE_
X-MS-Office365-Filtering-Correlation-Id: 246091d2-d288-49a2-1ec7-08db29e285ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /gx02pDKdWg7j9JA7A2LPF6pj/RmEQ+UJqG6CACEh2yT4lf7GPjPAEp3tSDv8pFWQfGWxoq5Mbhx7dxOwaZ2BTOdQPZzuAq7sv+uDiLw6v4RUmnzV2I7SmvCbkmoTcWQyUfkhcwNKXSESTa5ZMl87Tz0uOYnFsctYWszv4zHDtWUI5Oapq/3z73P2m4U1RDevmqfQJv8TCIIrZvn0m9pTgnSFPSJxNM23V6400DUmob+AqwZ3sq/y/DLMgb24YBfOn5xS+D+7QUzReOxVkWWbJh+RX/aA4LjX8T9rBykGMCQ0q6AlNspD3ivG46P+2Fv0Uv7Qeo9KaxfONFOwsisKEfMP4yqs0At8i+rS82HEDFpIJiljN2mykGwMdW8WzlMmImlWATS0dHCimX7iUoHB2osVY6fca5Ni/dErXPCpxs4Wi03T010mqncVtMv4FZ43/BBBqDL9DnbaTnODd6gD9WYkBIU4FbnfoMqmrk+eMgpCRnXsM9ErLd0CGIacZJT8d2JU1dhRcJFIhfOeb6StN0ugc7hsUT9JRsofASQEp7qr1TWahj/EbEbovCDsB5MJSwnwRzOvNpHLsWxaynnZCdq5csTgZTbN5O8gmBtr9J7640sT5tnBn7otYH46Wu54k/GlM1/K0MSkMemtz3ikjymhTmlBmbUdUagVQg4D9hsKBJ/0ADRi8S4OiAHnLmA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199018)(2616005)(38100700002)(86362001)(44832011)(66556008)(41300700001)(8676002)(36756003)(66476007)(8936002)(6916009)(66946007)(2906002)(5660300002)(4326008)(478600001)(186003)(53546011)(6486002)(6506007)(316002)(54906003)(6512007)(4744005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R4zfSVuMQV5BIqlXH/VgljqwK9n7dBTl76JxIHW1FBY6TrXGr3u2Qu2gy5DJ?=
 =?us-ascii?Q?fg4Nd1+Dcv6CKOLU1SNfBvc0AIBoqr6zSgQxyi3XfrKN9jwV+1XBIaYwvm0I?=
 =?us-ascii?Q?sVlDkEoZKGuyU+5V9i2kt0MIGQ19vX6Yu/KRiU6L6xjllw1oga2Tu4VzJMmZ?=
 =?us-ascii?Q?GyQ2CMs0ZIw/0ddPDyFpe40PGnkTwWcleJsAkrCsN3nzMHQ4kaSJAdznE0ZE?=
 =?us-ascii?Q?Bza2t3LOlh8fQjGXp1ouB/FralJ/5CsUDu+HqUPAxqy6gPqTWSsdzZDrtT3u?=
 =?us-ascii?Q?edp9z5OqpjzjrF1b1J0y54hr6uODFNTdc9N224m16KVVNE2lxuUxMlMr5q9X?=
 =?us-ascii?Q?EQyFOFEe+GW4TcrUYi96LtI0QN1UX7eNuflpX3xpaInzoiFpdtlVWekcIMVX?=
 =?us-ascii?Q?XtwkkeNisTRTqc1+OFiNgrv6cWl4x0nSa6Edbvdg5XoE+o2HNXzGy3acRl8S?=
 =?us-ascii?Q?RxFe/+h8HfVpAed7QKUlbp3iTZ7KYQBmOSk3IzblR441rBwVx67hlek9t7H4?=
 =?us-ascii?Q?zftU6ZmIqtA1qyE/t0HUQZZDmVZnfF0CunpAOUIe5IhCp5qIJSOk0G09YS9V?=
 =?us-ascii?Q?2rAQO0F85a3+VsOq/9ksFYZ42EwbeiBEcMzK/HZLdrRxBdaMRtYcU1CGIVtd?=
 =?us-ascii?Q?M3N5ln7H13N9ecirPMXKLzYnk9yL44+DZ5K3ZyIvBgftbw3iI6t/z5Bm0t59?=
 =?us-ascii?Q?SN2Ouv5zxcYCZnWRC8U6R2Oq2OC34URzJYP7bUM3hsUqiC/+bfb5EbvbVrU9?=
 =?us-ascii?Q?ktjMzy+15CRubSJJsfXkv82xXuThPTemjnZZll8RZj5O937gwXnVQvnkRK9Q?=
 =?us-ascii?Q?TNFGmLQtM4PL2whLFXfMD1iuMnjHKnKaMHZbLTYbcNDF1oxc4ad0ecy3mcVm?=
 =?us-ascii?Q?vC1DgzI0EIamOYSxayhk/88AJf0RWPwtByhvp/JoiMek/cHFGT1cl1BSQgPq?=
 =?us-ascii?Q?bADgrs9WzOPL59GJioo1zJZfwwLMF/udkJ3uZWGZiRPPAoAqpD8PMFzZPZT/?=
 =?us-ascii?Q?w+WGfFTFpunIY/UBdd3Xpga05YgAtGPQ0thgcSs1S01vLTCAmo4ApKvsyMiu?=
 =?us-ascii?Q?GjAoSXj7l5Z5vDU9Q2FrK8pCSsmGoFox1tBPzbRfiY7QS4JNqhH0fVaAq1YS?=
 =?us-ascii?Q?Cnmzirf11mzHdekwQ1vf5lnTa4uD//Zv+ud2wgbITEHSUxXc18GHm1eU8BIq?=
 =?us-ascii?Q?JK3BJTKiZy+e1qF8YopyokMaJ6ZAsQ5oztbvgr1B99B1e2YDAM7XbMoWrvw2?=
 =?us-ascii?Q?G8u2ZiyVs0BYMVwz6ZTQj27qJa5D+VCbD8DKnCxM7haZrzN2JZqFWqXE5LC9?=
 =?us-ascii?Q?NdhB1mcwNJBg83ASLWm2nqSI7q61JL77q0gQVlU/bdOVng9H9ZGFQ775wGeU?=
 =?us-ascii?Q?GhEglp2a5q95kp4f7fvfl+G246LZffW9Q3a/2jv2RpJGDVRXhGn41bYJAo1W?=
 =?us-ascii?Q?oPm+ILhxOHSuNyPIwQqktHVZXBNmLe1lOz8ePutVbR58cVwtwGKf4tZv352r?=
 =?us-ascii?Q?tf6V2Nn9haekWgI1UA8H2ociaGU1ZYYCoiv6qrd14crzCQZ2Ay7P4ZsVpjqR?=
 =?us-ascii?Q?AAsXJT+lnuopKjS8WbV8L9aOszS3jHHMRmHHyNbs3G3jKY/gH2xetsVTm7s1?=
 =?us-ascii?Q?llCN0tkDDkr5Ju5ZYOZfsfHglb52YFY63OwPl5laNl+LYX4uHQENelM6MXQb?=
 =?us-ascii?Q?CBkUbA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246091d2-d288-49a2-1ec7-08db29e285ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 08:01:48.7378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsGibkSTuyMvzXJkiiSNnYafr2Zs0ktsbnLuJTm18KJ4GqZaoV34kRBqx24b0fjZ6BNkNXOUhtU6pOl8x1bh7eFeQRnPxjsA5MGLmJfv9d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 11:43:16AM -0400, Sean Anderson wrote:
> On 3/18/23 05:03, Simon Horman wrote:
> > On Mon, Mar 13, 2023 at 08:36:11PM -0400, Sean Anderson wrote:
> > > Clean up some oddities suggested during review.
> > > 
> > > Signed-off-by: Sean Anderson <seanga2@gmail.com>

...

> > > @@ -2386,7 +2385,7 @@ static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
> > >   	dev_addr[2] = 0x20;
> > >   	get_random_bytes(&dev_addr[3], 3);
> > >   }
> > > -#endif /* !(CONFIG_SPARC) */
> > > +#endif
> > 
> > Hi Sean,
> > 
> > I think this problem was added by patch 6/9,
> > so perhaps best to squash it into that patch.
> 
> > Actually, I'd squash all these changes into 6/9.
> > But I don't feel strongly about it.
> 
> 6/9 just moves code around. I am keeping the modifications for other commits.

Ack.
