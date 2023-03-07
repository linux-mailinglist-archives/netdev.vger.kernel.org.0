Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33F6AE6B6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCGQfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjCGQfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:35:18 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1085A74;
        Tue,  7 Mar 2023 08:33:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwiPjrQiHdslbFrfN+l3rsPr6wpiDsIm/td0Vaf1176q83vnMDktZgRFmCO35OrGx/R6JeU8GXavgE1kmHuvyx29mTIXoS2bHtHPWsWEzAhmZm7Q7le4UjEnoX8S7mBfOBcg3NpDDVPl7Mkx62hteZ86Bn7+PQWVzC20Ds1qw1ReBnT5TEgKPFb9x44ZEcXDr/3nW2Blv+uSrPNjWHZGySFYIRaKifCO2w4M2UaEH+MFH42zDezBYVbHZVMLqiA8cwhmpTESnfQQoppko5pbLZ2yifxTSYpLGTsRYeK1oOynHgySDWSWr6FrTOczl+iWCcdiXvINndBVN45KH4jxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsovAYF3PeFhXk+/CSqwtsGb5esOsu71tTQ9fvrmB4k=;
 b=Y3WBGygdnNnFN100KKuBpY2tn5eQmwh5HzLbQkoUzTQzNEuFk+Lj59amUIp8AMrHfO7VSkU/MdQewr8EFcEF1+aWfIN1hq8gPevrYy10oAYYWvrZ9kM99S13AJeAQHUY7TNskmAg099ZWGLQRN3zKtEZyDs+I6CdgykF5FBdEvfvViXgdDWuxgJ7S/Up2LQkoYQQCkGlq1tS/Odu5bpRFXVxqxsO5UyRH1ylJ6r8gScUPeE/rIq8UAD+Y5Jjt7EtRrQUC2KeNLzG5HNv/MKsLdrfli4EyP2tpO8dEwEFgCNbkSpmbX/3ipt0xfKrecAjRnBWMvUFIqn6zCaJ1/ZTYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsovAYF3PeFhXk+/CSqwtsGb5esOsu71tTQ9fvrmB4k=;
 b=ngaZzAGWsW5BgkDUotK89mSQHIcMcAWpbRYp+Lu+SvXadWANMKqNTFkbFTxrhmZoynqAywhp6pU2s6ZUTt/wEsu7j6e1zpnPFIfPhNrtbZm/91gwHQn91Sqfu5Uh4O1HDtts6Q4fovx6lwsrKsw7HsN+t94VzaQSVD2N2Mu0UuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4151.namprd13.prod.outlook.com (2603:10b6:208:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:33:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 16:33:26 +0000
Date:   Tue, 7 Mar 2023 17:33:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        sumang@marvell.com, richardcochran@gmail.com
Subject: Re: [net PATCH v3] octeontx2-af: Unlock contexts in the queue
 context cache in case of fault detection
Message-ID: <ZAdnT/D3PyjDxaK+@corigine.com>
References: <20230307104908.3391164-1-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307104908.3391164-1-saikrishnag@marvell.com>
X-ClientProxiedBy: AM4PR05CA0006.eurprd05.prod.outlook.com (2603:10a6:205::19)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4151:EE_
X-MS-Office365-Filtering-Correlation-Id: bbabf001-3a73-4c95-042c-08db1f29acfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNeY41PHQSoXQ5bIYewMw2my0qrKNWIklvumj3v2FM5/EBGwyiMNwVuQjuzVNd9MuGH8mCjJxFPXG+wvizrYRgSvZLAmZlx8SSQTl6y3DdQYjL8BKyxsjj+4oHIn8s7Qb++/B1yYGC7BkAaXzkzGO7Piq2eUvlhVXIzEqq0pjaPAfQpf3AltJFeOhiId2enBbbhHXa6Tb072Gh5zeTyfhXkPg/wj6ZJftyELP6pj1b0ftm4ztmznkV1xbKuwp3CXxC0V4dZLpn6yjPN3tfX5c73MRg6vfentENN8pRHGLDMc5Fa6CvdAzZRX37Yhg4AnLrralonz2UdEvrYVKAXzbUzs6JC5TJLUmqEG5mx5Ndr453VviKaPs+DNeK19HPF4VjZu+ozRBrdpAufkynCcE5evQ++oG+6N/h36iJUbI0ZpvDN/2uWxbFrgMoPVUKipS27tRX7mNFkJJo/fnrNbxXFWb9WuZKn1S8Z1sgSEdtp2zYJzGujmhXootwCZ7Mh2PqJlLruyZSkU+tV9Us2NNhk5V/3f322uZvQE9DIVPfarGgz6rA4OBcnqPDfSuWz9q7HTH+u15tVUQDP4yNwpLwdXOlH0XOxo/67tU2oWWvJYabHEp58Z6PiwWfsX7kaTJDoarUJHRKm9sEHCkt8Q/Y42/C0b8oVFGw2OLUsufw/wIFbQizkhR4n7RA6YnIkN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39840400004)(346002)(451199018)(2906002)(38100700002)(186003)(6506007)(6512007)(2616005)(44832011)(6666004)(4744005)(66946007)(66476007)(8936002)(66556008)(478600001)(5660300002)(6486002)(7416002)(41300700001)(36756003)(4326008)(8676002)(6916009)(316002)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HWrvwsXv+bezfm1G5Olj4x9YxKDRgAxqO2JvB830oOlvbQ6Fqud6VhZKb4A0?=
 =?us-ascii?Q?RJ5TT91f/e6b8VOId0d5o3mRWtMYDe43RO+vmNIrfv1WVZGRkosQCFzYuNxf?=
 =?us-ascii?Q?z3ik7TD3OYO5srrON510gnQycUMLChCRxW0uSuF21rmxieRWoDfvXZDXB7Q5?=
 =?us-ascii?Q?aXaeNKC0yKVea4q4W+lU/u2xv7Lu9oOvSymC8RNn0vAXbRG0eJ56liKKksZp?=
 =?us-ascii?Q?xK25wJmcfvuOt6Wj29ctZgxVHbD830glDQkngg5kTsM85FMQAMXLFqklBXsH?=
 =?us-ascii?Q?XAjTuA5CrtnQ1GJELS9Rz4lHNnGYYvEux1jHxb+i68TStUrI+0A4csuxmm6b?=
 =?us-ascii?Q?Ooy/i4ItSUksZ+o3C+4DWfxZg9iMzKPVZ79d3TR7v1pkhrR/LEt+ZaPJWJ9v?=
 =?us-ascii?Q?keCaQgjU3TkGV0mLVizde82t9vqaSpyTmaYzlOL9OtpPoLEHHSi81K/mJvme?=
 =?us-ascii?Q?kmsM+JvCQrPFSUXN0/V03fObPHryvkTMLCP2xTPzVDGBCJvzMFflgkJ10vEm?=
 =?us-ascii?Q?URohfNqYOC920vZqVj7nArGO7+eUlJyn0aa3taXVgwZP0sVVo6jtdUaRZ8Vs?=
 =?us-ascii?Q?25N06JfNJYsxguBNBe/13w+o6y6o/p3PKEpk01fAbSxfWJMAWYkgnJj1jvbc?=
 =?us-ascii?Q?H5CpK9Xt1xUXc6VNZAalO0tyww4dUS+P40Q+gfEs+hqP7jWtqqAp8ZiEdGw6?=
 =?us-ascii?Q?s+hla5TOLa3oVXOwAqAU1xa7CXunri1LXIJckIDyt5oe2FmCQqv2CNpOF3YJ?=
 =?us-ascii?Q?kucXqJKcwztsisRE2Lukh5iYxmipCbqE35bgmUbO4+3hR+XFDukayinZsdR8?=
 =?us-ascii?Q?QndEi4d7Yc++3Sq6yLjjTIi2bR5b/56l/u/7dZr9MAwtiPW3F0k881b7qAKm?=
 =?us-ascii?Q?9/JVOfip86/czj2W8316VnJHc9fv76+9JVIEQfdRs1CWAd3lBKjWRUJKPChz?=
 =?us-ascii?Q?kE6t6vw6VCsnxH52puZdyhP91HEjSbs/py+/+YTF5c3FcSgZz78gZSTDJAxP?=
 =?us-ascii?Q?HFG0aFerZoaKJYTWdJ/XhI8utOfAN4rmdNPy8I+j1DQnUtzfIALnCYAuX/W+?=
 =?us-ascii?Q?Zzw9p9EirX1sbYy7CPz1g89VKNfh4hZJOw3mmzAti5427fSvw0/u6E50fiMC?=
 =?us-ascii?Q?jbd6OCaWXWpNwA34mCkOIokpKp3Rf1LCD/OOJ5M2lG71bitEU8quX4lRiaP/?=
 =?us-ascii?Q?/6XH4rUgR2ofZKdx/NztBSty4FSrHtxzTrgDzW70EceHv8FupMidIZURBIHQ?=
 =?us-ascii?Q?CxjoYyP18SZTI+QS2ahjZy6S2TSmmUHsLHA0cEAwTjvn76fEoR8VUGUxCGsd?=
 =?us-ascii?Q?CmoaL+5XbRa6hWetRt7s8Ytf4tpmV1lIF3HouwoeaA0Q4ETJiB0XJ+bPJ8cN?=
 =?us-ascii?Q?8WuylNryZ4jUrJe0GcG8EWlGDYH5upGoDS7VyOAiqyHjjco4JtVDh4/c7yV+?=
 =?us-ascii?Q?Q61J4udi27y+zd3C242JT7GdrHwRlirJgamXCTDUhjJyFvE6yLfJHzYAiJC5?=
 =?us-ascii?Q?Zf3iXRpCfCyb+Sww9JhNwfs94wx/kAwfOr8mX3daTfq/qntdA2iGNrHbkLoB?=
 =?us-ascii?Q?u6V1rI0Gz6Rm5XuIqeVoPu8u0b7rKfQTH+b0ca9gLzrR1NtDStlK0iuwA3KL?=
 =?us-ascii?Q?CTsTTN5uSfTOB+UE1MBun/BdlAU1MXb+5HT/CryUE7vXEBj7HqkOZ/9CywMv?=
 =?us-ascii?Q?E56nag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbabf001-3a73-4c95-042c-08db1f29acfb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:33:26.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPgBlPk0B6PKx9FLl+xgDJftHN03u/rT8mB03PA7CkPqnhzfX/amuxWL7XXipHEg40zTXsF/K8PqHZ5rFzmvD6RYWJMHh9DjRDzsYlysepY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4151
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 04:19:08PM +0530, Sai Krishna wrote:
> From: Suman Ghosh <sumang@marvell.com>
> 
> NDC caches contexts of frequently used queue's (Rx and Tx queues)
> contexts. Due to a HW errata when NDC detects fault/poision while
> accessing contexts it could go into an illegal state where a cache
> line could get locked forever. To makesure all cache lines in NDC
> are available for optimum performance upon fault/lockerror/posion
> errors scan through all cache lines in NDC and clear the lock bit.
> 
> Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue support")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

