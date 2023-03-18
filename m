Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE856BFB28
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 16:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCRPUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCRPUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 11:20:10 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2113.outbound.protection.outlook.com [40.107.101.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C53323C47;
        Sat, 18 Mar 2023 08:20:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mb5yjzTqqrRRRbbDjFheyWm2G01awtxLqo0Y/Sq97xc3r56c/3i6u99rrmE77Mm1ldAiVkNqQIBrUqP/RGR3GveCV9odbH6DvG0HV2ZXN0Owfh0e6TMzaX0MOj94MeNuIHHLkyAzZeZrRGTVF8mk3THJxNKzldMTJKxw2ajhU4r4H3UHNqsEY7D7ftg6Ilxo/XC33UESzFnPN9BBKmfwmy34mFL84CFNQ+y6TmMqIqNQiJyhSHXba+OuA2FT6cZODdt7OLaoZ+IzOPN0fBg5YEoZO2+BUGDJUUh/nTXiMNGf14bsb+jWSXt+nm6Y2bxQncm1IhG0HEdiGrUuHYdU/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3tK925NnJXlnrbMD7j2mmqOynithnthoOPugk9i6K8=;
 b=Q4uKrO9+yzY2AtZP/BbfWidfUbZzScjp58AIxBUNtdKtiU448HaptzZvAzKgIgpMpkScldNMkSaetVrpRDpw/9EPlOExLWwMc8VUznlNBwoN7qev/jjvEyVbgwQ6zI3w0tiKTGsl1JjIbWnR/wUGInTLaiHF5LaMsx5yB/EkawlfZRZiq8XT5/7CH4fUwiXcLh2ffLfarp582L9ZAq75wVYd6zw0upj99xGWPJJFrZxtvxYxxMNxP+beRorqoadEEkjQ1zT5NuQfPmPElD4Zz+NqYV15LZBBr1Obi45CuodkNQRE5YlndZvrfsCYU7he99F++FZPP1V9FyMKw02pXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3tK925NnJXlnrbMD7j2mmqOynithnthoOPugk9i6K8=;
 b=hHca+fLkTlC9+8VNhMSp4xZypyZe1jVd2PQe0vYynfGUoF7LY0+x47eFHeeoYSqxMmrOs+2mdRbDoXdRLhl62WlKQWdKJVS2K9ERbBEEFUYjLJgGBfdLBPm+L7MrYNYzpM3KcmuY4GcyyIBoqgD/hy2gUHDZBsWYfJkjkEYsoEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3763.namprd13.prod.outlook.com (2603:10b6:a03:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 15:19:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 15:19:58 +0000
Date:   Sat, 18 Mar 2023 16:19:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] net: mdio: fix owner field for mdio buses
 registered using ACPI
Message-ID: <ZBXWl6AUtiuhKOPu@corigine.com>
References: <20230316233317.2169394-1-f.fainelli@gmail.com>
 <20230316233317.2169394-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316233317.2169394-3-f.fainelli@gmail.com>
X-ClientProxiedBy: AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3763:EE_
X-MS-Office365-Filtering-Correlation-Id: fb796dc7-94f4-4dac-5bba-08db27c43c2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1pWuXnlqmRSS2uSO5pXgwg1hYBM0dGUnQgUd4HzmgJQQ1f1Tv5/gos2apZC+UUaXk7+TdcKMrUb67pIrQn43yGKEVKCT5jpn+8Cv3VNNxp3RAN7bsy9/i3dLIkFAAZN6+Pbgn7wtR2nnO1P9f5sF5WUBBaAfvhQYWT+/EzsetyJpvEI2BR9v5E36UgZTPohfojNOMlL64DmcOLIhiJtT0iX+qjd7k4KsOsVg/3bGmriAIR3IYn8nt/0zsDIRsRLJiVCWO7XzMhxsW49q7G9PWGBUco5I4GN+SL1VUllEYDSbeXdbfW/LWZ6tXzdoIQrzaJC21BMqf++G3qNJb9KB7qYiD9pdWADwvnD0c275XxgIMW8Ri1w9TS1fvjq+UyFjU7ErS4P3XkWFyshaaLhU8BdHtRRf1CtMK1YiS2/pvcczzwKPspvqTr/Ui2BRUf5rTld5/HsC8RYN7uSSR+wfTe0Db0zAng64tLzEi/MmA46DgHQj35Ku+RwUsiIfIGGkLEjkMtqC8TtBPrBtju7ECTro4yZS1cXkNbq+shpfFksthJyg/mjkAUrkIry0BO/yGqMUQL12hN9UcP6fQSv2icvHEzwLfhE9uGa6yZnbyMwNgGrzvgFRa93Z2AXk2lMbVdwfQ9YP5TWBZpEe9LcPqTO4YKkonxjj0y188N9TYitqvomgAL0YQjqO7QvK3WCd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39830400003)(136003)(366004)(396003)(346002)(451199018)(316002)(478600001)(6486002)(54906003)(186003)(8936002)(41300700001)(6512007)(6506007)(8676002)(4326008)(6666004)(6916009)(2906002)(7416002)(2616005)(4744005)(5660300002)(44832011)(38100700002)(66476007)(66946007)(66556008)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OZ4TXRNNpzdNbiBCoxIuH/sM27NaBMlXNCzF99kNxCOeJh8XgRx/5cxfeqkC?=
 =?us-ascii?Q?62vRN5a8dxQkSDTm3xViEI/K+HEXeapmzcva0Rb80qVRSouWOxkWNI1Yn3f+?=
 =?us-ascii?Q?e9TYm/WIUPS3+NW6+8iAxFyVeQ+bTBdfKBozu4ZLGkE6CHmV+WVQEFjJw+D7?=
 =?us-ascii?Q?ZPLgdovMk7pTVoZxuLTj2vFAnJyrDIBXcpGtW7AXChkO6Dek7OvtMBL1HyGt?=
 =?us-ascii?Q?cktFOU0cncnuzj2jbjz3X6drjQBTNr1JToZ5p+igv1snUaeIET8GY/LbP5Et?=
 =?us-ascii?Q?pvvuhk1++yue1ukO1NoNe1gDxP7kq/9+nEuq87tpaq4/zXhad8cIAnHpgfTb?=
 =?us-ascii?Q?aJszOqC7Ad6xEyNHx8bc2tjTyCh3RCC4FlCPoqRZuCsuBkLqN5RG/nqm9IwG?=
 =?us-ascii?Q?PznDeLs7fOPZALKd5S/Mhpd6AuE0plqGNbCmssjCme0JMWwEHfZO8gOkR61w?=
 =?us-ascii?Q?G+S3jwELrGBxwM/ccHs5/OCurNVSb+qUaBuTx7eTNe3ysk/Wacx3Neyk/ZR8?=
 =?us-ascii?Q?eRH3beGohsP8djYSTcwH5g0wJp4VIWYERLwjLCHALNuNWQkbZzrxf/ZjvJDL?=
 =?us-ascii?Q?bqwHelkUyM/7+mb9TlQGxq56WCRtSexjLcd+y5AAoQ1TkWGAKTKAwBycCAy2?=
 =?us-ascii?Q?CGKjNBmDacMSaDQHPCbFhwipxptSlRNvH+0EQKRDf478zPtqtWomwP+MWJOi?=
 =?us-ascii?Q?clSpieQXU5ZyEv8KKdbt0sD1zniH+WgM3Xa2w4cHuesRcmCVZcSZAUa0xzSD?=
 =?us-ascii?Q?gH8h2kNOMp4gddYvB7pfTxw8Mz+piP6N39zW3/wzHosp+CI+xHyF2sWbHV33?=
 =?us-ascii?Q?RewzmH0Y7AFVRyaALu8LgGKAS99b2IqJnPEotaPyZp99VYiFBOWpAFxO7wFJ?=
 =?us-ascii?Q?THYhL1QiCMIeNfIwiMySJawjZelqEZST0tFE8wYuJnUOor2h4jPsSVBeKJzo?=
 =?us-ascii?Q?1KhmBX8L4T+mz4NQ/wJ/ZYyHYWjWuCtGt3oVUGK9cq4TzFb7OCOxfpIntKIJ?=
 =?us-ascii?Q?QQWCymBsW1BYkDjnV7j1YtdJ0X6AdhfoxqrxwPLQdEVt/mZuXwN0G/Tv2DYM?=
 =?us-ascii?Q?y8pPkF5Q9lqFDbI00TbHwhgfUyYMmaDTfcURml/Ib8vqk8/EV6nYHHtMYSiu?=
 =?us-ascii?Q?Jfga6Vm5aZ8vdtcIiXgwtTo2sS6eJmC+EzjgCQwqpTF0dK9+NriYEZtl1ZY7?=
 =?us-ascii?Q?16cWI3mVcmU3654LvwdZhruGylvgjOb677lgv7IHAgJh5jlJ4ahI2genlqzS?=
 =?us-ascii?Q?J0V+WgM7W/KJbyPHqfkZ3140l6gO5d2hs3VoRZsVjy3CuDSg7bunai6ZYqg0?=
 =?us-ascii?Q?JhPJfNUOMYzo+q5ZQpc/rhmfxa5y/UDrozRUIPHGJpBxU/rBvzvrMpXRAx6D?=
 =?us-ascii?Q?JOnSX1JRnWWhtId0WWHWHDEc6WYbvFq1zRyOrUyNKmJKC+Y4hvlrJgnotkLq?=
 =?us-ascii?Q?lBbpLOatlalL/WDC/ZoeZXJc/SZVVHXxcgLw/lDRPsk/wRE4mQfxo2rEFua2?=
 =?us-ascii?Q?rek4fyKFF/SCeQpapxZlMWGG8vphH5B9AmFFatHEbNKRd2MqvqnRMEmDHxDm?=
 =?us-ascii?Q?sxYBfgGpL2ElTahA14u/mpn915LVgm655zgcGUduOzy4DIsWm/EiyVna1XeD?=
 =?us-ascii?Q?wdZEVZWbqbeUlD0X+HrifYut2pQ8aPJE2tMJp1LYS8EQfRQ14gyLXBm9XlI1?=
 =?us-ascii?Q?ltrXUg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb796dc7-94f4-4dac-5bba-08db27c43c2b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 15:19:58.1167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPpeGXvj7OVGMrIjHblCoj/rVJRhpBR/npGsjpUCFfTYB5csY+MuiC4dNF9hbK3B0mVf0pAZeQa4rkITn8hmcySoE0awgya827ZawlRj4b0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3763
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:33:17PM -0700, Florian Fainelli wrote:
> Bus ownership is wrong when using acpi_mdiobus_register() to register an
> mdio bus. That function is not inline, so when it calls
> mdiobus_register() the wrong THIS_MODULE value is captured.
> 
> CC: Maxime Bizon <mbizon@freebox.fr>
> Fixes: 803ca24d2f92 ("net: mdio: Add ACPI support code for mdio")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

