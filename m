Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3562C6E4A06
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDQNfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDQNfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:35:42 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2107.outbound.protection.outlook.com [40.107.95.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1438A73
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSqFDr8n3itVw+evT2p1M3eX44kUFQUN/6vbnRqfDrfvnUL7N1IZPqKQZWuNmpYeSTHhBc28othp7uAoAi/97HvXwYehZVGNyML1Up4FhBySX/NuQtHvDtwdXW7jgmr+OX65F8i/D6k/urT8aK4jHPU8u2UuBJzl1imI38MdZx4mBWzA9og50YVN4qkYD3hrOXO/kolDkRumtO7BnYuJupKB9kWWfv/besQvIZcpv36I6mcCCsHpvjtFIWL7UJp6BkiEW6ihhWsqTtO6E+kCXJAGSNhj2ADn6eDWMKVzNOMU/KosATe6N9d5nnR9a7JjHtt54bo8JOWvdde4NBEwLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIEbbeAcYca7mLE3pViHj1hQ87Pw31PHXFsmRL8i9sU=;
 b=nJSciCtNd8VobuWQgbAjT0CH2fo/0GDGaFvWtNReIhHwUyPaGqTtmS19C9X9YU8YV/GpEKy8ZPbzOUjoDPdD+NSOAdMszt4Y8Zgfc1dL/MVjjsa8FszDejAB9OZwuk8qrEm4cIQvbD8oBvFwtMY+pWjXc7UUBJg9HtsQxTGulSkuIj7ruVxtAnSXFGZHclnb7TnbBa/wypw8sHNXy0J+paRgnayHu7lfeXo+xd7vNzHoBbQBcadrt4ZSj9Kks+cgw0wMCv9xj5ubia66fQpYWEai6J29R0elHe+CQ0kjTyeCokmgkfI7W+LHF4Cf/j7jIXgxPTfPPZynUCfKtxthSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIEbbeAcYca7mLE3pViHj1hQ87Pw31PHXFsmRL8i9sU=;
 b=FUSEQbQYqpj2nkSOk8Ul7lsiyEkhzY/3VoqrpYoIW+KmHYE84cJQR1U4sKY//bTVci6oXuMXRo2d02FhviOoBeTMjqB6C7aHbkDaU57+YUet+v9gopEGNn5hh0Q/vgKDHMqhJ2CnlcM17OAATiQ2o0AAh8RHgiAlZtfE++oAFEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5857.namprd13.prod.outlook.com (2603:10b6:8:44::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Mon, 17 Apr 2023 13:35:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:35:24 +0000
Date:   Mon, 17 Apr 2023 15:35:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 09/10] net/mlx5e: Create IPsec table with
 tunnel support only when encap is disabled
Message-ID: <ZD1LFI9aMPWSi+Nu@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <95b253445bedd2167a6c156d242fd47f37de6ad1.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95b253445bedd2167a6c156d242fd47f37de6ad1.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0219.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e1a2dd4-bb81-44f1-930d-08db3f4898e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EQdLXwM9S05CXRAuC+BsD7dnx9DUJIGGaYxtrLYBklmPjuH0bR8l/orVhP4R8P2C/b+O0HSB3f6Hw+3nxNpkeyY/KOB+PgHaj5uPgqIn9x23B2KfLZpmJDaKgHRC48sH+N4hOJke1ra4c3tOPiPT1WbIwi1UOq2JiKoEJm8Uz4OrDuOCITPYZEfbvagN0xhRXo0p2X2JN6SULliWDyiKyJmlgezGkEFnPZQ5IEgpg2lBOsU9TZJ6Gntq8GwXj5QZBjOWRipoU3YbGAceV6od+VXQLMAF3ObL0YTBAQoWdWwaokT9RoMQnj6LXjX+pTq/AYUs+BIX9uS5+AmHZH9MSvoxF1QiL3P3YdBttr/rtCzPkOLEejhm0edsZv/j2f6zHczGfacm3N+awayj9ihd4pMq2WUEZ5MNsuEWXDuOpJNNbEdP9vTah8aCsE7rls2FicmyMo14I39fyWb2vIbU9FJ9xQW3a5Bg5vJTus6voI6jQ/OfMDY3CgfTbwP8v/447B5z9hlgd+ml7FbUGDY/1Kk0YvmZMRz+WgrbKlVj/TtfDWfKToEWxN5+D4GnXvVAjcIlceWJKvRaFI8un8COgGNMR0mumUceyZyjQFrz60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(366004)(39840400004)(451199021)(5660300002)(4744005)(6486002)(6916009)(66476007)(66556008)(2906002)(4326008)(66946007)(36756003)(44832011)(7416002)(86362001)(8936002)(38100700002)(41300700001)(478600001)(6666004)(8676002)(316002)(54906003)(6506007)(6512007)(2616005)(186003)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oh3cdDAcO0tbXTD2ZYDAvv5YM+DQVepm3/e1FuwF7J44I2C7DwKtjsCydJz4?=
 =?us-ascii?Q?RoaO1SZCXU14QYQd8U8coxeF/qMr4K5hKIgWL+nkFv5jp9FV0QuIdsvv0uSQ?=
 =?us-ascii?Q?1HP2/Oceh71sSpTB7UCUyqP5Cp5Udh7XkxTT8b0PgRjmBD32SDwNRiL8dgBq?=
 =?us-ascii?Q?yIGjTUvEqa4NnD7SQIZSFKnHbCaKqV9gQVdYehaUXvmZ3vshPHpQyVh5TPAB?=
 =?us-ascii?Q?T59vfe/bqe7D0cG2iSDWO8WGt1aik2zd02qpgzaht9XfuVxzJCESMpIqR3Qm?=
 =?us-ascii?Q?h/SHvFMRNTSLMcLK9vN9PHd4dCcAsOCEfYl8ZK2gQ4CnPGApDLtLmUdvCWVK?=
 =?us-ascii?Q?beXEjtzlZ1YUBYzDUHNpsdJT/Gr5WzPd4OHgtgOenoz5HwQXS5Nd/QisU9eH?=
 =?us-ascii?Q?SHZqraA+5HvLEIgSaVq7edFnZPKiiVPhnZI9eMPEq8oqzlh8KXqr8wNxdOdv?=
 =?us-ascii?Q?TZNHKVy7z4OYpbV4KUq+F6Dt8ovdlQuqjBWEe2NUmHGEBd9qavPjg22MZypR?=
 =?us-ascii?Q?SKaRzd9nl/8MAjrDkkGSKouqOxX+I5rMcNwIUAhxClILUiFIrLJaicEPZvA+?=
 =?us-ascii?Q?9mrqOlSy4KaPuP7YZjgptOsvr6tnW8leDt/oilXq+WClsqtBNSdg0WtMFHp4?=
 =?us-ascii?Q?MaI99kDYxwIC8p1t6/kFE6wkUZTpDHmcCK3A8wxb1KXRL/r/dSfoOooRVtAw?=
 =?us-ascii?Q?u3uIQJmfPic+Hx2qbBr47zSUoWoEaICxNkflbFAW3+LLn4zHltUMj/kNkzwb?=
 =?us-ascii?Q?lNYwcqEPOdIOwja9rZssgGvFjyE6ZjFgPe2kxIBBu9aVNeOBqsrG3PvfTt5m?=
 =?us-ascii?Q?gSNK+bzkWTzXDw06dpIPIsVf8txQLdZGPK2Uru1jPi62inzUeN2UTtbVp3VW?=
 =?us-ascii?Q?Euo/lHICfGGyKjBRCd4VgJk3ALBIdhBT1akeuT52ff6b/LIXEL9OpKKMiDqC?=
 =?us-ascii?Q?h/NI6ZDsINN5Mb0rI643gSkPDMZhRKKAmEByMiYpPCmfmtKU1VgMJWO2Ys26?=
 =?us-ascii?Q?4RmLvGDX1HtGHwdL+CRS+3G5LMaIhlO3UpSpB392QODX+mb2JPLTtA59rQ/o?=
 =?us-ascii?Q?Rju+GzvNOD2eH7w09t5vTgA4tl3EH32HMcwASI/0D7wHbNFEpSYnVqkt0u64?=
 =?us-ascii?Q?va0lWihuM73zGyZ6+X1w5J+psp5e5YNTbcR7Fgpf5PQdZeIadBeNhty+2RXR?=
 =?us-ascii?Q?HTumage3BKGOV8srU2fL92kmLGqmvy5Cu+ogsbH3qcJwBYJaUhHBIkQkOxNd?=
 =?us-ascii?Q?LNaWTQhMWQh/IzoP2pAKFSY4K2zGkMeJ9au3Mw4PQMk26m2A9MqNInP3YyjC?=
 =?us-ascii?Q?kG8kh+Uc+mRJYWAn6Rlo8WA49SA8b8CNIIMNFbqUoUeW+p32AVelBzk9ZU2P?=
 =?us-ascii?Q?f17WmlTCCgn9Ysnxw4pgkbubrwmA10vRf7YlrSs4QOPzEqjA2BMCtKZhp6rY?=
 =?us-ascii?Q?Ok7uig3eFHtLlb2BbcYCsxIGn7XU0NQ3ZTorrjK2ExpemvOHIvoopInFal8H?=
 =?us-ascii?Q?h1+FiXE5ZaJB1MH4MxeLMUF5DltCxgsh23Zi/mpjlIJtwKjOM0ry0qdSBfMl?=
 =?us-ascii?Q?ExBYXQfl1hTtqDH33K3xDlMuyjj4LiwVmTnSvoD3DdbgnZwW+3Pis1U+Xmz6?=
 =?us-ascii?Q?SRdAhZrmNB7BQ7gBkKu/6r3OVlgqj9J84D3dAdX7fpv4LVc9xAX08MlfvIEJ?=
 =?us-ascii?Q?TD8rjw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1a2dd4-bb81-44f1-930d-08db3f4898e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:35:23.9644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPGjIEqhBPHKUcVk2nTX75CFvDgwh3FrvVJLSaNAVugMecBx6u/+LMNt4TxSY7gO71oxCiXv9HrHB+35EDl45vPnwYkTB5RxXzg3MdUIIQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5857
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:27PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Current hardware doesn't support double encapsulation which is
> happening when IPsec packet offload tunnel mode is configured
> together with eswitch encap option.
> 
> Any user attempt to add new SA/policy after he/she sets encap mode, will
> generate the following FW syndrome:
> 
>  mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 1904): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed,
>  status bad parameter(0x3), syndrome (0xa43321), err(-22)
> 
> Make sure that we block encap changes before creating flow steering tables.
> This is applicable only for packet offload in tunnel mode, while packet
> offload in transport mode and crypto offload, don't have such limitation
> as they don't perform encapsulation.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

