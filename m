Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B584F6E4848
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjDQMxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjDQMxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:53:41 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5FD3C2B;
        Mon, 17 Apr 2023 05:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjOdseMWHIxcb6+L0ZZhMFQ2cJQT++nt0efxRJycQIWp32ElPcwAV8DlPcVb87tnH0AWlzl0kMLH/YclPt6rCK5+YJtS4/Sw/mpCn30yRcpEHSP7hF28dJIK5JbGaSfBxBXiQXl3rJJ2EX0U+pRgGe9NB2fImMyBckpJ/6h8ShnAdTwp9cH2BKp1afZ52tqMf9xNHcfd0MyovGwv/DZqrkenDygpO8kg2USDmenF5//ae8gbFC3bUNvSWXBJxmmkupJ/hB24W75UQe3a6qLNstrqSB3AJImlPsDx9Fx4e98uplFkKzkqGiPaGjYA3kluja+Gfk4BQZA6RIoPvB3Plg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQcbR0shgUTbrkuAjFci0C+iBeFOYvpw/1IOvl7Dp8M=;
 b=UVyiRb2SCAcJFqBJW9iOxLjphfheZAfcyiHg4g/XbkkO2RQCB3aGM51GplZ0QUMnr3csKcevWJ8DQxBRPCDPKiD1epP25098gQf6IXyiCSScQFo/wwA10+Ubvc/ezepUFRQuXNti4R4MYsy/hmTZnW0ydaLVL8SNrDWOq4jiL7NGHda5es7BbZgjc/LrtJvK6S207POIxbMIgkupJpjTsMRizJghG3X4yHVJgk4g/ZZKthmcWx8neTuLUnCHxQKqrXx84qoWyLl/hwlrauFxGyXh1kMW/qOchBsgq4p6Fc8bfR81vc6wHf1ZOQlyJ1I2xPkNBXOIOMf8W/HAvF7PZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQcbR0shgUTbrkuAjFci0C+iBeFOYvpw/1IOvl7Dp8M=;
 b=APTPrcLLLZ0XS1mzf8XVNuWiyuzMhGYyWCp5Ww+oaNL3HBo9+ESaM5jiH+oWwAR0+DEi/HGyrkAoc2sFMmFcgGUbAjCGbqtpyJXcFutjUwR0ZwnSF1MwEn7scmQfFSFlBvv+c4Z7S+176akUt2dOiD9fSee8/h2afUpukesQGJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3996.namprd13.prod.outlook.com (2603:10b6:303:5f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:53:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 12:53:37 +0000
Date:   Mon, 17 Apr 2023 14:53:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] net: mscc: ocelot: remove struct
 ocelot_mm_state :: lock
Message-ID: <ZD1BSiBsXvunUgKj@corigine.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415170551.3939607-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3996:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bea9f9b-e763-43b9-3687-08db3f42c2b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ea/gNlCdvr+4zAUbpJOKyokiQvmqcuQN/DAjUjGSs4JalJG3i/LOy+TyyVIVH5wdoyJySAyucP0/PCWG9vGB6Z4A4AQe1s29rz7meWQzMy0OzRMgXIeY8zqlKYBRxWF0avX/j8NGVfFban6x/bF74KullkgASsH9r10gCE1IOO7IqThAYxXWYCbkxeMx5yUyVXhKf5fQAfqOEXAx7VCg+FnqbruwognBbq1rFlCv+4pnP/zlKCVq8JHccVix7KluTV8yO/xDN5qgi9GBi5mA0tyKCveB/mHaXJkfUc2a+IXn4+glRgOQRSLyHTg2FMs7BSxFZnMECt31eqTsjC9gI/rC15GFjL74UARBChzngzg54JJVg0T+9GSO07tWSMbey5KM2MuWgK5UU+mdl5lJnolFgxUjjicpxYPc8npvCM4dmJ0x/WDRlHzs8ud8XqBv3TPClk0u5yt8LIexFQ+cDc2DGtA0VkfwRH3imjpcJztfKeWiCHYWbV+rXlxQcNdQ2iL8ULZWbVxVZNP1eHP/ctog+E4zzYZp4B9Ug09kIymUuTg4k45FYj0nLAs4Zddc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(366004)(136003)(376002)(451199021)(36756003)(44832011)(7416002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(54906003)(2616005)(6506007)(6512007)(186003)(6666004)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VQRxIO017CunCg0dnLRNApcTP3O+OuNuMMy7QVFmiXqJuqSW7ohhdXboVygX?=
 =?us-ascii?Q?JtoBG0iUgR+V54D6MaQzXbL8AkbK9a8TiHsK2eBy1AKBJW5p5+gAwTRjAB1v?=
 =?us-ascii?Q?xEIqnKO94axznIrJrFEjX7zGNwqDieigIiWC1cthl+3JFnsfzlmpOZ9eFSwQ?=
 =?us-ascii?Q?LUrL3zW/M0rg5bSepOeMzUC8P3JRbRjhNwO8R9EBeWIvYGNUTJpwV4n/jI5b?=
 =?us-ascii?Q?B4NfJeSG2226Py2HoRRDTGYK/Z+W+Xs93AA5Oi22mgzh0n0daQuO/zMyrwXU?=
 =?us-ascii?Q?OJ3USlqf5unppvmsN1mQRkKJ067Xiug1O78XGoFXl1VVcQrGwNtQaLC82N+x?=
 =?us-ascii?Q?2nKNQYzxxV3faW6a8nfIm8foEm743lEWZcTa8QOVnUOX+rVziC0xA4yYQJ8y?=
 =?us-ascii?Q?4BsDww0FVXDbz0G1jlu/+62S1R0i9v+058I+9Y1EibwIKlzHvCDCwsXJ0yae?=
 =?us-ascii?Q?ddtA+XGrI2JUTCLRmX++khLoSv7yQbSvhm7bZy+AVZw5lKcLJRPENPW7suFg?=
 =?us-ascii?Q?adAieUhk6XsBFodJ0WIqs0oaNRM1XZH6VYQqdEzvtup1RI6Wea4tE2nZ2TjJ?=
 =?us-ascii?Q?IYrhYr41DHpXsRj59N8kFroT5WHTrs4DUkGS7jWOoB2rMgL8qWBIYwWuFUPH?=
 =?us-ascii?Q?kDElEJRm2ChQnRwTzGP361Hj7SwGl+U3LSIAO6FljZnajWudV6a9nmNNKBBH?=
 =?us-ascii?Q?Oy2XN/lQB+WWMvci2eDz0L7OksHTbxSs8lIU1O7Z4PPoyT4kesTiXDNNgl4o?=
 =?us-ascii?Q?Q/F/Z1y/RSUtBNGt22A7BuErRyfv+tSWobQYUelHzEjwrSlK3jPaWasSkrOn?=
 =?us-ascii?Q?1yY1k8GqA1ZLcmeMVmnPEhw8Zn5L1FZLo0ylGAa5CtedYLT0xPdTZJjFp0/6?=
 =?us-ascii?Q?Xws0gujB7W2wBHVhUz/GSEIcYGrzbhbbQ6IOrwVBUecDrQnVk/n5n4pAjw/D?=
 =?us-ascii?Q?KSFQxNEF3k1xNXT9XHyRCXgUrLUvOOTDpJb7+UzCp6vdpYIYNs/5YPzjXE9I?=
 =?us-ascii?Q?jhpvsAfMycWe0FCSQ7WN8XcyAbMlA9dIqHhR+c0Dt48En27kQTBY8ZndRqxR?=
 =?us-ascii?Q?wns9aLzUyNYezeVKa3zXc5x1jrmFAq76IRbmtqMpEf1T21aupMqi8AG0aTLU?=
 =?us-ascii?Q?6PijlPDVzGM961mrhZCoITlOemAJtDEdkqR7Kdb/aRxTb4CY1eyRDSbG74ik?=
 =?us-ascii?Q?AN8SrzODDyH00ZMl9MPOiECJwaJhFdAQbgeEZT0c2GqOHhBgJfevm3yMzC/+?=
 =?us-ascii?Q?kqXeFK1TOmZu9h8NeOsdQR3ovq0RNqoJ6TqQoZ6ZKo46JKNMME5IQbB7SWJT?=
 =?us-ascii?Q?AsQ9ADnyotuX7oZDbus/lKuWVZbQgkKXi4nWYwqpoUhzr1GsTyyAE8U2llpH?=
 =?us-ascii?Q?O7vQOlD+y/d7R6NZtp1zV7m2OcC/q9Oe3S18szOs7gK4iz+/cCvxpfPOko5v?=
 =?us-ascii?Q?2TDcsVU4J4P71Nnz3bgPnNgMmIusyat6qFan43+8w2BIoVa3zwbV1W2Rybwi?=
 =?us-ascii?Q?yr8a5EUW/6yVYhKw1ggPfh3IPsFBFJ3WPhPnvI48cJ3vvX+EPhbu2bhB20fh?=
 =?us-ascii?Q?ho9G3F/lnFua0Z6wpEvXRO4fqrUOVuVuhzfijPSYXV80JRzk/I33N+uI3a7k?=
 =?us-ascii?Q?PEb7khR75s0C4c+LFKw7eCAR+XRSCu52/Ps6Rc/4zjhJYqnXg03OXHk4fyd7?=
 =?us-ascii?Q?Cxu97A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bea9f9b-e763-43b9-3687-08db3f42c2b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:53:37.1646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8TOmf2utuXlxeHemq7Y1PbPw7zNUNTcFuJjKzSxOW5aqN3O0uNzH3o454FGi7R7Vv54nr9hk8jpLbsaUmBHV/ZteC3xuO7hGTjHUSv5Pp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3996
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 08:05:46PM +0300, Vladimir Oltean wrote:
> Unfortunately, the workarounds for the hardware bugs make it pointless
> to keep fine-grained locking for the MAC Merge state of each port.
> 
> Our vsc9959_cut_through_fwd() implementation requires
> ocelot->fwd_domain_lock to be held, in order to serialize with changes
> to the bridging domains and to port speed changes (which affect which
> ports can be cut-through). Simultaneously, the traffic classes which can
> be cut-through cannot be preemptible at the same time, and this will
> depend on the MAC Merge layer state (which changes from threaded
> interrupt context).
> 
> Since vsc9959_cut_through_fwd() would have to hold the mm->lock of all
> ports for a correct and race-free implementation with respect to
> ocelot_mm_irq(), in practice it means that any time a port's mm->lock is
> held, it would potentially block holders of ocelot->fwd_domain_lock.
> 
> In the interest of simple locking rules, make all MAC Merge layer state
> changes (and preemptible traffic class changes) be serialized by the
> ocelot->fwd_domain_lock.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

