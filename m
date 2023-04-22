Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482F76EB819
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 10:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjDVIvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 04:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDVIvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 04:51:04 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5989419A1;
        Sat, 22 Apr 2023 01:51:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCbYKJR6P58JUpOWzrVMWdW8SFwZPQiNLQw4Pgom3eLYa8hOqmqHpsP2KatI868JgTixM7bBQ+y8OC0l7UZpntZN+hbO6hhh70V34TYhrPk6tO2SB9dufdLH45daBkXWMiyii6ds2L/NN4Sl1966Hhs+1Hl4WwrAHhimGtSXIEmPAOj3Uynd+KihL7mlNmJ/y2pTshuQQJFvURs+MUOiPx7taxgdpSXqXNXCFKqvkHdt7JetpCvwvF1TMle+iTZhqiC5e/RBS2TXVV1KafAfsq+yv+TkS28tfHpIdjAH/3UVB3ILAXwmmxstzYIp+MtWT+fyvyFDsXBumQ2oOnjfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5XgsBe70xVODUt2fFr8JSI8w9cbJCfpS4d19eSB7rA=;
 b=IALz/TTPPVgiq54d8renmv/LwObSXu0g7aoslV6B29Ubv3l67+nSxqqWSkul5P9KyWjDUgFNEHRuUOzjQoY0zH32BLEoL2zRdSsTJvN15Ve2MC8ESrYyQO5s/5pTZ9XlCBENUM7dQFzJ4I425Xinclx57cnD22P90fvG6jIZu9FD/0wHRHlWa0ImhziHmt/MTinMHVWfSvLWV9/DvVq9Bap7JU8EpZ3kIsixNBkzplJRv3rX0cI6tFvN4snBiXXhOppibugCFzXBMBzzl00CEti3LI3UXw9yzLuM8BkxtEufc4LO/ZfjMbUbThvFIHzxqv3mXyTQeM3zbRojJn9PoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5XgsBe70xVODUt2fFr8JSI8w9cbJCfpS4d19eSB7rA=;
 b=EFVFeVBEOSQ9Whh/7HXD69k3i8C3rNJGq6js7uTdkLHId2p9l/p1kFLcRCHYMtZxQ4HoQzI3+iJMX44AiyFn6Mpy4UhY8ca6rOs2UaWNgMvnHYsmzEtl6WVdgG6sFxurkg6k9oe4dqeLKh6lVJ58Tn46iSKTdItzax6udRNio04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4994.namprd13.prod.outlook.com (2603:10b6:a03:357::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28; Sat, 22 Apr
 2023 08:50:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 08:50:59 +0000
Date:   Sat, 22 Apr 2023 10:50:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>
Subject: Re: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
Message-ID: <ZEOf7LXAkdLR0yFI@corigine.com>
References: <20230420204316.30475-1-ps.report@gmx.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420204316.30475-1-ps.report@gmx.net>
X-ClientProxiedBy: AS4P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4994:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e0d0e0-0211-46b9-c7c5-08db430eb14b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: czTRt59o7k0uDjb7PhhpvVzgyn+nd8wUFWjDoNF6yQ+Mm3aO2Ae23rwnLurTh+YmqQkrhuV/nmMrupRV4kZCEu/NY3zXycaC+Z4Gjl9EBybMQZBHGX2qbT2gtB3/sJYky4Yww4sgFyKG++ey1CzdHfpEC/hJJqCv3vUATyJupLkKCNltMCG6+Q3p5uAMPRY/u/u6qkAUht31JfSW6yBAfrRqZUjsM1TCx1jlyBOsrDpyma4DkehIyZv5tc8VAa5JCbFSZ39J70D0P164/niGosPepGt7pPNwQJXj1BD6yd/S5cM9Tfw9HoOiz+dj0KrBZBWIG4JgyOjo3FJsqaoZHRmVbGAH5DUEb2/zUgpDjUIMz5jwwv8JxTkgqZa2YeLSwXEbZUoIia9Yh3R/ttAYfKZdcKk4qRYIq86MIIBkNTMx4/u38z8DI0oQ/X+BLTp44Qbf+W39JKtv3XGIS9Q2wZFh30cUVopAxdR2Q01PZfBS2x2bZFuo9zsDE+WNTGAZNOa7ohDBFo/03m+0NbwbAhyj1XbOPx3cXhxyLQi++XY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39840400004)(376002)(136003)(396003)(451199021)(44832011)(2906002)(38100700002)(7416002)(5660300002)(8936002)(41300700001)(316002)(8676002)(66556008)(66476007)(6916009)(66946007)(4326008)(54906003)(186003)(478600001)(83380400001)(966005)(6486002)(36756003)(2616005)(86362001)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jpx6BtB6OtIzoy6MQh1uRnofkkmjmYX5MaUH6hc5s1DeRPbs+rXd2fFZvk7H?=
 =?us-ascii?Q?kz+45VhDiMgTbHJrx2p5YIlRYAIWo2rzQKLzbAUVuIwWzUd2u8TO0IxnIhEM?=
 =?us-ascii?Q?sWefJ8KW67tgjDaGzVD0mgDWG18ROIi6zXALSIxDfwTunaR4ZbyfptgL6C9b?=
 =?us-ascii?Q?edXBN378wC3jYnOvhxTM7H5o6/ZYVkIuH0GSKsbmKbOTUcEbzZ17uNQAKNb3?=
 =?us-ascii?Q?vM+8opsz5oxm03iyGzUcWJqpq5KkCZJ6o1HS6G3lkv9mhwafCbPW0JA+NXjj?=
 =?us-ascii?Q?bpbWnC8YnRhKC4QqWQMGIO3cphrDskd3XXXx+DSXD5BaN7mhlpub8EpPx2Xz?=
 =?us-ascii?Q?1eSGSx+rE8RxFwUaG/C6iWg7qS+4M1TroPm+nCEluqiwgkzW1yQtWJPAW3Yn?=
 =?us-ascii?Q?swzlJvKexiPp+qs8+n2xReTmPDOyzl5ZJTTVW5+xmvsRcbPFtyYtWtdpTANw?=
 =?us-ascii?Q?HtdRdCIwhiucAvVDLlRjGb9Q6E5yld430CsweEEmnWzN9OtAPSreKiEbAWgc?=
 =?us-ascii?Q?5XvuJSfh18XVcxW1fp+tUySmtHPwoRhLPoVc+Cny3XeN6qEw8T/3tHrO/qdH?=
 =?us-ascii?Q?pmW0dpZQ4kulhDw+NDImA5J1IRWdTGMvyj3p7GDaThl75Mlss+nv3CxnQx9h?=
 =?us-ascii?Q?1eZDqCxv35opQKy434YrgGUAyvxxxi544StnYfZ5s786jBpYNdH9LOCORMh2?=
 =?us-ascii?Q?bu/7ErjsLaIEjILIjW50V8l4vVF4aIEu36i7InV/5D+LcGF/8a1pOtveljMv?=
 =?us-ascii?Q?zNfCRyHE6OSTj+wipY97+OGL9yoYHCkMHYSnurXYYcPd2iZlBwTAglw375bj?=
 =?us-ascii?Q?6cv8LsVX95U+4LQb/tHtcdfks/eKx/Na2zHla7/deAc0opdcg8wx/CXgBNTO?=
 =?us-ascii?Q?si/XHwxmFBcu7yZXgIlXwFKxfpFQLSkFABpPUagOCUF4hihF7wNnETY7gqr+?=
 =?us-ascii?Q?VGWAdVo7tC/5rMCAeaaE2aT8GvFSgccJBIvtd5PfJ6mRrFpRUi0Hih+ot2U5?=
 =?us-ascii?Q?i7u1XZbBoAPHs/BuprPp3aC/7qU0zTtrpJVk1befHMJFG2ypoNLgex6AZ7L8?=
 =?us-ascii?Q?/qR3f0SPaWZGw5orabb6JDaDqPwElXD489ptKzrGy6fcG7wYlfgz9WwT4r7Z?=
 =?us-ascii?Q?WYTU+EtDbL10k5Kp6zdfdl1P9tBGqaVAZ3p1ME6RgVn2Toh2LKm7Sqbfz3D4?=
 =?us-ascii?Q?CrWXBC6aIucbqo7AdQBuTU/GVa23AFA+pGElGPRGCHCDVYkZB708m+QilZ5X?=
 =?us-ascii?Q?KfTNjSQoRXPGOn7GzOZFje3C4vqY3bz6f/cXsVBMbXQJAHV64pmaFY0DOgaj?=
 =?us-ascii?Q?Enq/Rwxc/OgqwpIDLCMs9etRLELtoEdjb+UnNCCXJMUm23LqK2Q81ZBagXxL?=
 =?us-ascii?Q?2CsNFe+/ZdDJ8jLGxXR3tB9dhHR2q2ogIBsDeouqfTkTMy7KKOiihlmrb0HI?=
 =?us-ascii?Q?ni1O6sE4lZ4pZ/0TH0gTV1CT3LzPY6ZzVYQwV2bQqhD+ATkaBSLeAjRez6E5?=
 =?us-ascii?Q?Fv/eujzGap4xdPNkjoEoqrurB4J7NNPjSP0tUrzpMXzY0TZb1nyc9SUq2Hv3?=
 =?us-ascii?Q?wLUdc7Y9hCwI+7aHxXkmEfbOlK7C2CjTILkzSv+tcaLwRc0V/5Q0EkXmBJGy?=
 =?us-ascii?Q?k3iaN5mD5RcmPTEWwAFAHNxysT6LPJ7FlJk/z8GdF98nQiCdSDaIoORHIyl+?=
 =?us-ascii?Q?cx8KIg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e0d0e0-0211-46b9-c7c5-08db430eb14b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 08:50:58.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZWS7od/sZ3DI9up/he3WkyjHi62IfiODFImQUtPnP2i8S5Xk0o913rwIdUVRDL/Ai/DOOA3213dndswO6MhTiTMfO4msRfYjNPikK08SRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4994
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 10:43:16PM +0200, Peter Seiderer wrote:
> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> calculation (do not overflow the shift for the second register/queues
> above five, use the register layout described in the comments above
> ath9k_hw_verify_hang() instead).
> 
> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
> 
> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F0177FB722F4@seqtechllc.com/
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
> Notes:
>   - tested with MikroTik R11e-5HnD/Atheros AR9300 Rev:4 (lspci: 168c:0033
>     Qualcomm Atheros AR958x 802.11abgn Wireless Network Adapter (rev 01))
>     card
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_hw.c | 27 ++++++++++++++--------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> index 4f27a9fb1482..0ccf13a35fb4 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> @@ -1099,17 +1099,22 @@ static bool ath9k_hw_verify_hang(struct ath_hw *ah, unsigned int queue)
>  {
>  	u32 dma_dbg_chain, dma_dbg_complete;
>  	u8 dcu_chain_state, dcu_complete_state;
> +	unsigned int dbg_reg, reg_offset;
>  	int i;
>  
> -	for (i = 0; i < NUM_STATUS_READS; i++) {
> -		if (queue < 6)
> -			dma_dbg_chain = REG_READ(ah, AR_DMADBG_4);
> -		else
> -			dma_dbg_chain = REG_READ(ah, AR_DMADBG_5);
> +	if (queue < 6) {
> +		dbg_reg = AR_DMADBG_4;
> +		reg_offset = i * 5;

Hi Peter,

unless my eyes are deceiving me, i is not initialised here.

> +	} else {
> +		dbg_reg = AR_DMADBG_5;
> +		reg_offset = (i - 6) * 5;

Or here.

> +	}
>  
> +	for (i = 0; i < NUM_STATUS_READS; i++) {
> +		dma_dbg_chain = REG_READ(ah, dbg_reg);
>  		dma_dbg_complete = REG_READ(ah, AR_DMADBG_6);
>  
> -		dcu_chain_state = (dma_dbg_chain >> (5 * queue)) & 0x1f;
> +		dcu_chain_state = (dma_dbg_chain >> reg_offset) & 0x1f;
>  		dcu_complete_state = dma_dbg_complete & 0x3;
>  
>  		if ((dcu_chain_state != 0x6) || (dcu_complete_state != 0x1))
