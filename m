Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C3C686C76
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjBARLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBARLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:11:42 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2100.outbound.protection.outlook.com [40.107.220.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D64840FA
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:11:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuLJ36uwWDb3WmKlTEFG+OfuP56qDit7KcILu7zT/gJSvofREm564uwTrpdY0xXpHqm0UGXZVu0faRErpo8S3bTltPyCOWk9QL0v5dgrFvpBcelZDMHLB884sFztAlSmVp6MzM+h2fdu+l92n6IFDJQUj9uOumPnoRaH9pEecKtrbDFS+oNvn0lIGtzkVUVnAFOqBh7pxVIaRAgHTuz72Nt+7uzjKYmGCGL7Fc2p0YqYX21HO1AdjanngXnLAR8tUZl7XqA2qVJZH+Kt3Uo3NsSJQfcuf/8IJyIr9hEfdGWleNI1XP2xKmYYV6S8mrDo6K8mIuOhnyqDZHkIJoTOlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlJ4U9RaQQQg7SMRvIVHCV9CaZdnOmH1qxz0ROwGrAw=;
 b=gmG+rCH0/iv7LPQSomZcx5BlPAgelpFFfwWZ1eDxAuOzf6OV5nYUeBYC9rO2oum/JVrlxS5rBrYlti302IN4QmyOGYGBDIQD/PjHrGM4oJ662yJ2mvVtqEBnM33GR4JaXeqqYif0Ev5FZWaauJa82n18rFSGiLMSH0pQOWPEV4wcLufsWtXQJ8iw52koO43p0tLj6I4zzvSCbc8KyCIiQ2qzQEcggR4dbR7ftVXjps4aT3rmHCpFIr0X+D3r7L2ZxouZywK5zkGX7VHI+AaBWa0XspG1yWZrd0bp5L8vCFeqD0lc68czKFLHcgb0LPGuIYNadmDwRqzmBTszSq4TFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlJ4U9RaQQQg7SMRvIVHCV9CaZdnOmH1qxz0ROwGrAw=;
 b=GEe2mAVVlafQGfq1qnZm4JgWTEDUKsMt8s5EGrBZlkVsdbhMToyRzkWtD0NnwcoZUgQkapFZSCAl+JEM6965/CxxRxeAxaz2Bl4qZrRqa71Rlp9ddKDubQIKHEeblj+h7wCWUA3EAiYDDwy93XQBGsEkYE0NP3qYuX7DwYL/M2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4990.namprd13.prod.outlook.com (2603:10b6:806:1a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:11:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 17:11:39 +0000
Date:   Wed, 1 Feb 2023 18:11:34 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH net-next v2 2/2] amd-xgbe: add support for rx-adaptation
Message-ID: <Y9qdRsS5txwu3MND@corigine.com>
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
 <20230201054932.212700-3-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201054932.212700-3-Raju.Rangoju@amd.com>
X-ClientProxiedBy: AM0PR03CA0038.eurprd03.prod.outlook.com (2603:10a6:208::15)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4990:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f922ca-b694-4479-4143-08db047761e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UWq9OJ6CdQ3n1hlHyBqLCBSg1b0nwbKJMh3jf1NRLcxHvL2eYbLUCFaJ/QwE/UoJoFSdyIx3BEteAmXZofB08/kK7E0vzttmdm3YCSkAzOG4aHMgzDavo+M3dipKyBjotP8rKE44s8Th/vfQS3IOHzs7iRjBgzwgezKXF7zfPXFE+FFdP0getaN5EpUrkQSWcEXQ7Mo4zXScqacLKCzY77USBHzBulc9tTfPe4uicqzPjB+2bXEUhMHW6Z1uoPkfdDdeW3EbVO4KEuA+dG4V602uFxXyO1vpo5a+VJGO6mBpeyn6BaYeB9vIjp+O93KEPbe04wMRvqmjh+gwKEsEqDWZ+S+PY6CD5J1I0YPXwapwfRdt9UR49dH+LOPyLW9OPO7gTUBwJi903wKS9T1iVz+5XJ06avB/HVNj+UN5v8ZFXcBe4cu59HOxwomz+5305f0NuKro7PmjrgZXZ5T77yd/bYJK2gFwQ5v9g19oNOr+4JhizzWoJHPHB7qZhxtdBcHiI9J3ssDZco3hIzaSVbK0R0tK0dTm4t/v3RNa0Cqg7JA5THZWazBr3il3/13vDfTMQfyt6vU3zIgGciO6zHiPFMwAylgGEtblq49xSLKtHczjJHPYFjGdxRX00h7kIodRPPeMuUWS5WfFGo0ApLY7elv9kzPYEeMJMLWLx34okY8FIsGV8IBZsu3DtZp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(396003)(346002)(136003)(451199018)(6486002)(478600001)(6666004)(2906002)(86362001)(66946007)(4326008)(6512007)(186003)(6506007)(5660300002)(316002)(8936002)(38100700002)(66476007)(66556008)(41300700001)(36756003)(2616005)(8676002)(44832011)(83380400001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kfAq7kMg/AC1UQjG959RH/qtqzbenB32lFeGNTV7qb817Zb3+/hDIbXBZQO7?=
 =?us-ascii?Q?szsp1lZ3g6ZIfNKi5bIP/dcV7Xhpas9hGJrMpEWsNdlKcn6Sgh7fANSCkLWE?=
 =?us-ascii?Q?opanrArnFRjdSqWbs+SRvEXMRhs2PjpClZOOscFoXoQzIywHDzxQPVqVSJcV?=
 =?us-ascii?Q?l00g6Q+jsevG/x8/wCLVTQLMPEOUtbDzfN4UaCO94IlaED7WrXseg1L+cP9F?=
 =?us-ascii?Q?tM0v5B6AO5y7rgayLeGegFeLqiPFgWIoEPDSI2QtvHVZsHrCNWesXjTXUwqe?=
 =?us-ascii?Q?cXmZH15wEilMQlXSaG+jhrf4MqSLIfABU6i6eQWznywTjtnikqj8QeX6j356?=
 =?us-ascii?Q?NZXbV7HFRHW+K1mCJYVMfREUez4uvma9jMQiIc/+EEG89iTwLvL0BYt1cNlH?=
 =?us-ascii?Q?5ng/O/R6hwwiqKac+epQk3RAw881x1Dsz9WrxAbf50nmxavP/idH7PEFV7sL?=
 =?us-ascii?Q?sLfTt91wIzyBb8/qLQmmlVgTXP5BS57dKHK/Op3pMGjJ+nLCmywnGls9kTjW?=
 =?us-ascii?Q?KxbS4nBEOFGP28c6mKn4f5y4dgQmtoEg4u32GFBREC2crDGz4O0cjwIxu9X9?=
 =?us-ascii?Q?QeQSSh22Ow1CihqtN+qVWxyZpYx96x7Arz0AU+8BhsCT0/+3kmqggTnbwYaT?=
 =?us-ascii?Q?RuCtVHeVHXhRsT9bSsM7DF8DS/94JIWV5PU5J+AgEO8Dtnn5XfzSmUmitOSI?=
 =?us-ascii?Q?nGLGuLzJRntLnMpQqPkxdtcWYXlitBK4hOfinet90TwI6VZg13k5DiWfalAK?=
 =?us-ascii?Q?H153wim/i29AB8hQ/BjlRTm2BF+QjYT0L1ew+wydD/+MVa9/UxLEAQ6VQywz?=
 =?us-ascii?Q?nK+aWQkG2yggTvfG2nN8+F3QAMEfdV4gEc5+bvWJkvQE8WQiH0JuMM5D0zzJ?=
 =?us-ascii?Q?npPSbcQlPUi0O5fnDrDTTU6J7XTPiHBblumGgubR0sizdEhM4LxVoVqb9Mvu?=
 =?us-ascii?Q?r5fwKxJURZyG9cFBYBZ/R1ChIO1A+gG834pwT7u9t7xzbOTyRqac1GnTB30y?=
 =?us-ascii?Q?hFFRx1PZg5r8+ix2P73joqi3jrF321yAEvbNtyCKH/DZ3aI1htkGrLc1XWH1?=
 =?us-ascii?Q?HdVGnNnW1wR5yuFxIHdtZOpb4YgwArE7BvpnKhCAMyTkuw1mUwYCdYEZKD+P?=
 =?us-ascii?Q?ObUVkbpM4UX7Sj+iYqZBjGkgDde8vhzfriSheW4L1X8rSB1proDLWagljxnL?=
 =?us-ascii?Q?SCDATxXbBGor+6ESoJhGb5e6PCvdKYLTpHrgLuamAyTQOtLIO50W4pohRxis?=
 =?us-ascii?Q?HTAOFDsNdFCi2h9014dXXvo9ojA7v27J+eVRHDHZYNnq7xzZeQg7OybOMKJX?=
 =?us-ascii?Q?rWVl5eB7jHZnxF3cam+JT1/HAJlpoLj/h6ZiWUJG+7shUpV9yjHuM2P9wsLe?=
 =?us-ascii?Q?tZYV2JxsziMdMJvVw5nEgL5S6ZvEcQd8nAeIfi4O7eX5h+U8IleSfc3QSPro?=
 =?us-ascii?Q?Za0qUivKQIo9AuHQ01EkuOhFINJdkWsNgfKWsSYcrYx4G0ZVaNduHH7x7lA0?=
 =?us-ascii?Q?cMcbyr9+MfgSExbseTo5V7vuvcVmhfL2epawFLth4toMfSovYh5g7fVwi5xu?=
 =?us-ascii?Q?Iy+3M5O2n2BRzMUDuMYu15tQdaoEZJ05MtYbJW2eHL2fY9NcMBXmPtfor4J2?=
 =?us-ascii?Q?U7l5PXjG+DgYcpmzGK+U6wvTdsAR/llAGNxPq6CT/IqJxA1DgEkkOfTj6BHR?=
 =?us-ascii?Q?AFV2gQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f922ca-b694-4479-4143-08db047761e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:11:39.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBHC01Mc+rj2lbUC/gqng0i+5w/j/sKEoOwob3jFZaRG/KzDET5aCNt12+YVADDOwkCk6iHM1D4ITfIWghcIgGcpKIKfsoimMBQBjDLt8n0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4990
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 11:19:32AM +0530, Raju Rangoju wrote:
> The existing implementation for non-Autonegotiation 10G speed modes does
> not enable RX adaptation in the Driver and FW. The RX Equalization
> settings (AFE settings alone) are manually configured and the existing
> link-up sequence in the driver does not perform rx adaptation process as
> mentioned in the Synopsys databook. There's a customer request for 10G
> backplane mode without Auto-negotiation and for the DAC cables of more
> significant length that follow the non-Autonegotiation mode. These modes
> require PHY to perform RX Adaptation.
> 
> The proposed logic adds the necessary changes to Yellow Carp devices to
> ensure seamless RX Adaptation for 10G-SFI (LONG DAC) and 10G-KR without
> AN (CL72 not present). The RX adaptation core algorithm is executed by
> firmware, however, to achieve that a new mailbox sub-command is required
> to be sent by the driver.
> 
> Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>

...

> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> index 16e73df3e9b9..ad136ed493ed 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> @@ -625,6 +625,7 @@ enum xgbe_mb_cmd {
>  
>  enum xgbe_mb_subcmd {
>  	XGBE_MB_SUBCMD_NONE = 0,
> +	XGBE_MB_SUBCMD_RX_ADAP,
>  
>  	/* 10GbE SFP subcommands */
>  	XGBE_MB_SUBCMD_ACTIVE = 0,
> @@ -1316,6 +1317,10 @@ struct xgbe_prv_data {
>  
>  	bool debugfs_an_cdr_workaround;
>  	bool debugfs_an_cdr_track_early;
> +	bool en_rx_adap;

nit: there is a 1 byte hole here (on x86_64)

> +	int rx_adapt_retries;
> +	bool rx_adapt_done;
> +	bool mode_set;
>  };
>  
>  /* Function prototypes*/
> -- 
> 2.25.1
> 
