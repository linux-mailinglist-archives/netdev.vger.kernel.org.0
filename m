Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54EE6E49FA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjDQNeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjDQNeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:34:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2130.outbound.protection.outlook.com [40.107.92.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEC21FF0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvJ+6b2sDQFJbxlrH8IzF1zSfww8SPKwVgt21qfBij8pAGWpzOlBPTBn83Kfj9OaPrEaI/0ohZDQpkGKHdncCXKtCzRQUooMV5Os8TW9bAbcYdglv5F2n0G6p2Lk0M6Qk6c6gOPjtTTSOvJW6lNn2x7JNHeqGU2ZPqQo7q5czwIc7RpmcZYmtbSkyZ3bWWoahSy6YAzhF6ZcEK5XrFbTRzseGNRCVfb7OWwMzWbJ4fX7uIj/T2PRvPglAJ6pwwE3XKaNFbH0/pe92326l1qbfa143JDi3D/zMz8AGC1yLQqyKDtS+IBydPmFkgwHpN7mBZvEg8sQKI58HiKy6DAlBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6s7UNWGZTGTEUj+nHfDEowc4EA3sE6cocSnksF3CQUw=;
 b=e9gVF0wMTlTz6yv6Eykfb5l2tTMHc520e85h75akN64e9BvMwQUouTtCzZOCHBNGcvwZbxIN19rg7f6BoHVnUNMT4bfdDGJoXS7MxuqrHC6t/CkXIxt/AUVUxrlgaQtEUdBh3bWEiYuTZP+r5RfHg1aQRoD5pZsOnu4mYlYlHQzwOUJo41EMF4sfYBHoTvIoDdFhljQvwBYTHtWy0ZdPIA6V52SyxQoxd1Vv4cg4Pc2UHluJvDYzKLO0E9Xvj3T7MSqOZmKaZdw/yiqhMQ7L8z4VmvYQ8kwlcqyE5mg492IJj92ubpywLvTtXwp61ZSdPtiTWY61hQtroVKHFz9K8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6s7UNWGZTGTEUj+nHfDEowc4EA3sE6cocSnksF3CQUw=;
 b=lO37w+NA90WbDIrQIDt8xQKJfn2rU9YOVw4K/Zspk5Ln9Kcenq8ff5/dwKbUaRDE7gAS7a444OPtFrkbYkTxaF3v+6//ZMRUeVQ87KF30FkodkYw8TrPy5NEbrDrQC3kMmQ+8jHuM2KNwNUsZyFH9Q89vZs6SK/EqDD9u4NXZXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6057.namprd13.prod.outlook.com (2603:10b6:510:2b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 13:33:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:33:31 +0000
Date:   Mon, 17 Apr 2023 15:33:24 +0200
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
Subject: Re: [PATCH net-next v1 05/10] net/mlx5e: Support IPsec RX packet
 offload in tunnel mode
Message-ID: <ZD1KpM6mccoGkD82@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <10b2ef977bb38508edd9a9c8f35fe3ac9e5e582a.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b2ef977bb38508edd9a9c8f35fe3ac9e5e582a.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AS4P192CA0011.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e106fb3-1672-49ca-fb38-08db3f4855ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISy6PCTxn4i+sZGNRqtByXJ7npSt9C/znbzApnkoy664Q8s6cveiFiW9pPbQzvv569QCCoL+nAHCO9A29gkUPdFf1YHCqLLChqt9S3a5mWNIaT7ydcMibnqSUtZuD58ufKkvWDRvhBoBJTAMHLw1rLQ9sZXAxC4Ka84wjUSemzlLLhfz5zhQVWQG+xhg9509ut0OMmRzKwtMj9RwzFXfJsz5WrBlAoXIrn2X0VXzWQshE3lzXGszK+thNsB6RVqaOOI05sKAvkH6tSOQCgjJJN21hiuPbhas0PtLjGywXrenSFKG7Yx9HYgHsmbZOk9PcgGM1k8c6uKFZ0yrV6rJSbY/iEb4NUGOvAwH1VkYNEOCVpXDorA0vQSbQ68+npibppHF7gR/mzW4LPIhebpWwAiuAyCvt4fsappV8pI3LGhEVvmiQZhJqsik12Az6Byb0KaiFfRsopV0ZfGTXPmDdOcC1I0aD7xx3aPoMeroTUoHkIoNV18j4kjY03FxpaCQcUEytUM+CwsglpAKefnUCmy9H5llGLTL/UMiBxbWApdXPnMa/McP0E4yxdDUfz7Mn+DuroNgAlQBJuwownuDtyV9MstNGN2hdDbQHEc5Rr8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39840400004)(451199021)(66476007)(316002)(6512007)(66946007)(4326008)(6916009)(66556008)(54906003)(6666004)(41300700001)(478600001)(8676002)(6486002)(7416002)(5660300002)(8936002)(44832011)(2906002)(36756003)(86362001)(4744005)(38100700002)(2616005)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rxFTHt9ROs2JnURDRPXUzyEQJAURf3gDm44YxZKWeKloaVC1s1alXsWuh/Nr?=
 =?us-ascii?Q?YRlqvVUMYkZQ6bUfqsVUd5MmfMC8WMyntPE5R3edW+1mcGhyr8YlsfhkksbJ?=
 =?us-ascii?Q?71AcZHBQR/J4hUz1iiGCaoZniDrv7OHlaGR0fcgL4V1b5QuozdbxQz4uDLBg?=
 =?us-ascii?Q?Wgw7uH1ui7QS9nOCZjNw421qB+ODa9kF2+VsoYRhyzSNKlv3O+PaiDDF9rXW?=
 =?us-ascii?Q?uutpFwDAG110l6uEegq3DtPdQe82bJheIlSkYHfTKZkn+Lc92MypzaipLLDW?=
 =?us-ascii?Q?WJ9GrqC+QVMDfWzaKJX8gO2U4DKpa2mjhx19n6414Nb50Z5zq99P9wbe90Su?=
 =?us-ascii?Q?kJ0qYrLwaNo28ul8VUSOIvmqETmJd9eEdq6c9xkkMZPeHeJYjisCKosStNiv?=
 =?us-ascii?Q?oVOg/NONhL+vnB5fbu/1ykjB4a488jKpdQVkMma12o5MNw+kkJdgAOOq98+0?=
 =?us-ascii?Q?zqB/lnHvSVT78QsClfanSaMtVguL7uTJOyI1jBio85+e4ZJC6Kj8fIpEfZP+?=
 =?us-ascii?Q?x86O+TQ85d9gvZxah3h46XdfM0UbcYvgxYsSpcHWcmdYmg6XBDdR1VtsYTY5?=
 =?us-ascii?Q?JxSeV6QpkQNMv8gTtPtKCl5I9EKm7DRf6AUEW5s8oiWbKnXOZVht8Jy6FUAS?=
 =?us-ascii?Q?YMCe1jpJa05CmXOuH/r5N0E/8NDqubnLcjp5kZbqurlwfB+AyMiP6e0GBBzA?=
 =?us-ascii?Q?sX8w3aZT155GAR/Gn6WGLQrTl8Sh7OLhzKNqufoihswrq6qxFMD+S+r5JZm9?=
 =?us-ascii?Q?hhP38tvi0AJiQ8XjAZgATezRr7+7mwb5zerjs4/4hkubOWfnktn4CJdMPJwg?=
 =?us-ascii?Q?Prl6q2by1Vr/B73RP/JTN51yLZQXFAt4MvxtVguUiAzI+uPLoKylN9T7pT9D?=
 =?us-ascii?Q?EwGd+AtBm6sKO26qXc5ggwHYK/SWmhx9880ApcEfhhFUzhxZ6CHiejX1PLId?=
 =?us-ascii?Q?tWTdvRa15ArBACp1Z3q1oP5y+DQyxyUV1oxutdwO/QVpnjfbjNiBlXWK86/+?=
 =?us-ascii?Q?FxwG9awbxPzy6j2M8SnJ1OfiFjZvQ6EmvUK+5/ZM/Ag2C08E0w/XntC7dPja?=
 =?us-ascii?Q?Pcqf/kRIhmK6/DlSHll91rX+M7bY1kh8rU+QFPRaGNKAFNIUW9x68s12S3a7?=
 =?us-ascii?Q?Q1dn4mxzOq+T91Tw7fXctwAnTXOVcAep+9a/4EI7NyUDs15pj1BqvXiO/ppD?=
 =?us-ascii?Q?Vlaba3uoVYdZfVEXlZPA1xhyrNF5dM1TWRLrDX0vejeCPf2AHyUIkStkNGkW?=
 =?us-ascii?Q?O3k6kZ5687nPKzpd2wiZy3Fa2AnJDqdcaZjpI4dDBVJbBsZKLyrOnKJl0kg/?=
 =?us-ascii?Q?91lSnrxVvBFrX092t8nToCRrqmVKC+DS7gQXOUfc95vY6GbiknWR9eU1Zwnn?=
 =?us-ascii?Q?XOJ2Gc486kCVNK5jRQ6gs+p29/sn433VMnOyIena4haTBAbfNJN8xo7tG8jw?=
 =?us-ascii?Q?LAF9mVKau4N6S0y/iNWnMmSk1zU/mFeyQhetWXRup9b/Uv7ZCfhbZbep6DRL?=
 =?us-ascii?Q?hUosjerZfmuHlMRjhqgXZXi8c4pkywq4TIZG4UMnYeLIvwj4ORa+UCwPw1Qz?=
 =?us-ascii?Q?ZWcKk2OFuIyIG0akoPNScA582ooyrc5f1itPSt8XS77Xg7aVtVKVLvV/xLwE?=
 =?us-ascii?Q?3AG/CjGNzOKo03l7aDoSEs4aUC2R41/2JOOFbAG0BgRuBHDRkwcyfL2O36Km?=
 =?us-ascii?Q?nB5zcg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e106fb3-1672-49ca-fb38-08db3f4855ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:33:31.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDoX0LIACGYm83GbIYIFP4cCaR7Quj9lRJ/HgzznNE/uE2sirZZsCPbUP6xrwAINcdBLq6qdcWin5ZJdcAdvvhT4GHcmWPPSfG2yZD9sidk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6057
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:23PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend mlx5 driver with logic to support IPsec RX packet offload
> in tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
