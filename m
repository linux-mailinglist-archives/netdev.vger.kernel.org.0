Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7D6E7780
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjDSKfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjDSKfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:35:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149ED59FB;
        Wed, 19 Apr 2023 03:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxIWHfhK9CMp1Fp5CUv/pkUZjnZUY4GikctPx/elF4FShnWu4d+ERx+BiV7JDbkfMb2HmD4GZqwoDHy7/8G8BUelrKgIolVGeW3FmqaZLjZlJmpTzcwo3+Yb5HjfMu3u+o5c/PcFQJIuDgTezdYl2lzEgstS3hRtN73cI39BECAGPtDS00/kjg79jXNi84fHKFrxXWVYbl/VlBJG5cp/FEUnbtQ2KWQgO/9cLmsT60Q2uBilpcZHs3Ww/EYeEextGiyQNuSP/NwyTrPXSkh6vX31W+dWqjYX+tz0EHzdK1l1zMg2Y60J9Hr33NSgHs38Iy7/LLVRClvt46DE4tGnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99cNKDKqQAEKJjifHoJFGLuRFA0Lk3Q1wfX6IS8vqiU=;
 b=kjz7YeoFTFWCCiJB8UgpDgw95NVlpy/Lcf8M6/8eUnFVXqJuneXZpA8/2OwPOuSxpkDSCNG2WlYoXLChdBOrRlMvl1JUG3KRVt7rPgQdwDKdAbvy+HxvFTEInRlRrRTUGdOYEArjjlvPgMz5xu1VM7tVHY8FwZ4suq5OIzeMHR7OPUq2e6Bb8wkN+MPvzp5/GYgFewnL9UP0vtKM/1cGlT5TDHyXYR3q3hmzli71wYePgelNbyetu9kJW3ZVN+cqey2QjuMS+g4V/BDgTuTz9hZa0SNMtG905cS/VZMEiA7Uu2LDVcFw79yzizDwpKMHrnuo5tLdDvbJHXY0/youGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99cNKDKqQAEKJjifHoJFGLuRFA0Lk3Q1wfX6IS8vqiU=;
 b=al2Xr+OEAPZFhc0AoNXZsNw9NYdMra9X+lH5Hp/tWSxdmdk+K74eCIqwchSIzUm+jR+qSm69SoSdj6NMy3Bfu/7ALOxJNJpgJ2ns3z+tnmRIBEy3mGFeSluKMLFKN6k/OHfon4Xm3S+qqa+yFRBAWspan1+OEQjFO6VBMMxxudo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5809.namprd13.prod.outlook.com (2603:10b6:806:219::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 10:35:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 10:35:33 +0000
Date:   Wed, 19 Apr 2023 12:35:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 02/10] octeontx2-af: Fix start and end bit for
 scan config
Message-ID: <ZD/D7j+LPRIbP80J@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-3-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-3-saikrishnag@marvell.com>
X-ClientProxiedBy: AM9P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 128692e7-f63c-45cb-289b-08db40c1ce45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JvsY3WuKSYnn8Iu/KTmBiasd1IiDT4IKbRUvx61lhk1+k26WrUu5fqn/uo+g+/q8espDOO24vvCz+m0chmoxgs64xnybJqT44jNNkjuZiAScLGwgD1PUB5wJjDiy3rDxJHIggp7CEJ3dbCFd3ln3Wanss6PzVQnJw0yTSLiX5JQZRKgw5eY3a2IsY/ceI7kRAaKGr9Pq5jWa/wyasFSw6ouuP47/3Wl9S497TkwewwkCqMrFHylmByKWdnX1tejLszL98M5+ZNNfKsndzqAg+YEUdD0Q0RKjlE+k1F9BGCWVcB1yQe8oHOR6z9yFQFO7A6Ikoihcn87eOPq0VRr6VUunsjFZZPddXgGg+8nQtq9M5CtSr3V8Jiz8IfqLxeMz+1BJP7f4tmjY1K0RehWV9OLvUb7djIVP5j+yNs+lcsFKr3hfWETY01m2zzcnC2O1jRxRJWq3R3/kE7Tw8hNe5F7e1pN0zlNwGMC4orxsXYOswmrZmUxMjlh24DFsEkKKJDL6ydMFqyqom87VfArtUdlyvCh8c3DfXdhhgnrXYYINenB4X73RCbkDGrJFc85d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(2906002)(8936002)(38100700002)(8676002)(7416002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(6512007)(6506007)(478600001)(2616005)(83380400001)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mSAK0AglRdWIZ1uZTnzQi66noOqoVTm/OcO2OBoPWBpUCjh++2RdI/MiMn2y?=
 =?us-ascii?Q?4U3iDuVovj9rYspPTsnPPHgTXpY3WByBKp7Lm5aUW7OUytPuzvSl1xxmryN9?=
 =?us-ascii?Q?Y9vDy1qlc6co6VI3zhXsmJOQ+ArDRWv0U4ubkyIxae5nZrMNdaSoWBq1f2x6?=
 =?us-ascii?Q?ScunyhNM6eOpqKx+SFsG7V17EbwrS7J9q6bS+6OYF0aYmgR8abOMORP6e9PQ?=
 =?us-ascii?Q?CaFfnjokjQRGbZh78eFKvIRRe4wrwgT1lVqoONwxayZ/K2Oh1xVzzlxAiLPp?=
 =?us-ascii?Q?wXA0ElyRKQxpEx4MkYzTQhBIeTdghBmFPcqkeutIparfMbElmLDmDXlfgaVA?=
 =?us-ascii?Q?OOdhBQcMPASTj4ueYh9nQ9iud+2Ciyzp24sU2Q6S1LCZ93SoNuyajamiaWBJ?=
 =?us-ascii?Q?i1c8f3ehYAJ0dLKN1mnH+9RXPYd64x4Dl3rsa7Be0yPbuB6VuGkIgsCRn7aB?=
 =?us-ascii?Q?M2YMNIfKgR8yu/H2Cr4Yt8wvmSd/O57My1mfTNKUIaDz6jEqRgmy+fR54VZt?=
 =?us-ascii?Q?dOypqEuIrGtAg6+0Kprg+XpijC71IzKQfqMH8XextdTHjZYpTmfoLusqTJGq?=
 =?us-ascii?Q?41D3bNV2jMcRt0tTQFa93Klzc5VfaihJnLje0QT1Kvnaeat8Et0kU1etPKUr?=
 =?us-ascii?Q?WFoJPVAuGfUiAhuIVBYIwJG/Nx8SnBRcQ+yU9IKpUnrI+59/eLXEkrrGU+Pu?=
 =?us-ascii?Q?oran586SZ9H2W9wsXdfCTMwT0TkZ4pofObdHK/I1EL5TL/wz1mloGADnTj/+?=
 =?us-ascii?Q?0qjZATNWeXLZNqbTuCJvWoFVHb7l+S0UBozHT/kuRvOCpUUgSTiOx6RNx5jt?=
 =?us-ascii?Q?WgGaN8dBNK8h1FC5qbUyiTuBTnvHHuYoDIZ9HYaOXx4a7/wa/TW3ejrZ0BLr?=
 =?us-ascii?Q?5LkPcT4FcFjNd8Cbr0hj4N13oTiZqQOlrknY8QR7ZT5mTs/bZXxH+J4IayS0?=
 =?us-ascii?Q?GIK8eviRnLQw5My2oJuTv4jkFeXep0Zv9n7bsGcthfz+d3ZcZXdyebFttnvh?=
 =?us-ascii?Q?dlw3I/jus6RI+JXvALtO5zOBOe7WzekSKMi6R0CoMLxdlqi7V75XJg1iObTo?=
 =?us-ascii?Q?67pEHSJ0EI56Uwx/A10slqJvF/TDiBcYKBf6HQFngQpA9RhA/UZRP41QOtYF?=
 =?us-ascii?Q?QaVX2XH7OOABrz3s2X0IJ6drYVjsvr5VaoK7WE83P7/a44T0AZF8cJB9uVAB?=
 =?us-ascii?Q?uOXCeTakkXudz77qLvvVGnrAtMgALV04RbVgYiMSOnLqkMurzzqo4vnr0Cxl?=
 =?us-ascii?Q?Ylo3aypRtKToxWmN2izfO6x3sAPiopfrZSMBhNjPjB9FO2GTM/XmdqscvFzM?=
 =?us-ascii?Q?AKSSBv2RWGYpnzk0/A7H/k38ZiKXOIamaALmb5X9omOHMwaGJ45pNR3HQVZq?=
 =?us-ascii?Q?Oxc8BodWulLHMKXghXjfaPCQaiij15NdCj4toNOV4AX96tUD7jcMNnuci8Nw?=
 =?us-ascii?Q?PVgHMCXUM7KRQC/sGWgOEQe7keI3WAPYBHpBnNiTfS+muNL3qf5k3wsV6JAi?=
 =?us-ascii?Q?3R0wSlhrtEg+pfzkTmIZiUHpAlqksDYC9RXaaD9BAgoJwZNflkvJu3qQ6dAV?=
 =?us-ascii?Q?S93v1CnsbJJCZ2bpSNknL3GKYgF2OQ+L1vEX6YBe0d1kD2TXkJtaa/3lJ+XJ?=
 =?us-ascii?Q?KcIA7mWsFAXD9dAMGUsnM2Ss/zyMB+Hl+AQ30ibgj4DYlNskdkEtUWRy9U4G?=
 =?us-ascii?Q?eSLdTA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128692e7-f63c-45cb-289b-08db40c1ce45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 10:35:33.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ck0Dp/Aale3kr1N02y8dzAdEB3GV4F9HtnJMNx6exrwPeFRKzxHXWgOo3DJi6wSaB1Edm/MOSXMNHwPUbm+czD3lVQwkPWVoXLrpr82CGEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5809
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:10AM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Fix the NPC nibble start and end positions in the bit
> map. for_each_set_bit_from() needs start bit as one bit prior
> and end bit as one bit post position in the bit map
> 
> Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

I think it would be nice to explain why, and what effect this has.

Also, TBH, I'm unsure why the start needs to be one bit prior.

> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> index 006beb5cf98d..27603078689a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> @@ -593,9 +593,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
>  	 * exact match code.
>  	 */
>  	masked_cfg = cfg & NPC_EXACT_NIBBLE;
> -	bitnr = NPC_EXACT_NIBBLE_START;
> -	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
> -			      NPC_EXACT_NIBBLE_START) {
> +	bitnr = NPC_EXACT_NIBBLE_START - 1;
> +	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg, NPC_EXACT_NIBBLE_END + 1) {
>  		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
>  		key_nibble++;
>  	}
> -- 
> 2.25.1
> 
