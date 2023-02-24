Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337676A199B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 11:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjBXKJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 05:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBXKI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 05:08:57 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2097.outbound.protection.outlook.com [40.107.102.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADFC64E24
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 02:07:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWQHx/Ya21bNElF+xT3kYmrIf3GWNBfSvN74zMJjoEGOVr8gh1rmWzDw+/6sfrUK7Sa7DVAR4vfuFU4epQiEmDFY0JNi8HY/KoatdjD8CW/y7Ibpo7RgVc6cnVMDgoRWCHYyo+fhU39aK+W9Fn7aiJlXUbdima4idf22HwOZ9wPTRun8lg6bOJMN8qpAv77u9rd9+hlAbVCNARmyXERHnorZfb0WZzknw4wV0+saGUpoLv23XahpdHGhOdHgw4j8yBtLAwu5kBQGTgigMlyUU7JhjTwM7ft7wqzhgcmuOUOk76bIUdVjwa7G87T4rCx6SYNsKemBvtaqeZKBGaPA6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IUR6bb74UdNO8Vks8tdr0PuxavpGt/20iJT461nFtk=;
 b=DCvVb6ASuoE6IyRpfFre4+VLB/3tPATqdU+aKCbRqJCo0XGT9uZByy/12jFr2BjmjC6//zHB05OCe4C5gbL2UBVOpvQWhwQimrF9w+y91RNpPku/EYontQGeCeGtLX+T1HRwTpNUVmOqpgUZKOkNnx3ZOwpe+DtjePoPHsAa85z3lI8Un/ld4Nqs9vVYt8T4MqOmWg2PJCKBGBg0YWyPQCce+rAPW802+orjyGNW9qqiK1+/+z5UghppccNTqkmDv9IOhbRhrw11xoEIEt/wFLkAJ2/3wXSDGujs/JtfN79/BNkeGEDdADizYZkiEhJxEPXilupn7bBft8esAMt3GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IUR6bb74UdNO8Vks8tdr0PuxavpGt/20iJT461nFtk=;
 b=PhK8bookROwebcCFSRthA5TTD6sUr6L1C6YLCjcayq62XmDtH602nNPqq3w66Oga/oKuOHAQpFepSbhKTnUhX0R19EGqAKba2EZz37eFK5cuScr2ModQsRA6MDot+ISzHVdUYl5vEtHugYtRHAOAMvMQu1Cy8nCUdkcfmPOrdXs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5564.namprd13.prod.outlook.com (2603:10b6:806:233::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Fri, 24 Feb
 2023 10:07:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 10:07:15 +0000
Date:   Fri, 24 Feb 2023 11:07:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     netdev@vger.kernel.org, Edward Cree <ecree.xilinx@gmail.com>,
        linux-net-drivers@amd.com, habetsm.xilinx@gmail.com,
        leon@kernel.org
Subject: Re: [RFC PATCH v2 net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
Message-ID: <Y/iMTcvQZ3uW8bgP@corigine.com>
References: <20230223235026.26066-1-edward.cree@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223235026.26066-1-edward.cree@amd.com>
X-ClientProxiedBy: AM3PR04CA0150.eurprd04.prod.outlook.com (2603:10a6:207::34)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5564:EE_
X-MS-Office365-Filtering-Correlation-Id: f671b287-de0d-4ce1-51d1-08db164ee779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PI+5ki1DZF+kfhtcx4Kx+qIaKN/fr4x1nEEhsp9abg9YFFPeDPv+Jy39Loyakv0Z8a+l+ppj0DS81Naje2/03wmWSGspDL/IHn5aHG3CLXUSO1f0kCE89JqmFXxFIZqHteYDun92XlPGOqK9vIMY3+iNRFFYGGNdCb5hfDb/oPSYiDwhtRGwYwX6KmEvRCxtuI0PFTz4mFqoLVR6dmGfTYhTqoAe4z2mLTRS9PGN8o0k0raNcyDstzuuGdX1GuOYlhUrbWbgcjz8jRcIg27TM57Wcke6XxuNvhPzeLzzH58lpb8xJ+CUYxeSQ/sWynvIEWoX18YRAFwRffJ3ZwiBwTBqTEWP33gMiJlzGAJ8PCqv6zxqsxyDmBw3ik+PRKSoQFUqg9gFzzKL/fpeEGbIjU8B3wok6PnuXYk/WLIZRva7tCHVJ/RSZjlvCW6VRHQvt/HfZSnBFOhF2kkCGGRonivYT+Wi2Tx7t58Kt7Lqk4z09tzcw/Y1wA1QlVSfJdMu0Lxjp3Ct91PsjVdSJOzzPGQIfgrMFYS/QkK3ofSjfad4EeaQTjDSOmzkp910NvIBBs4SCN29mhfUqz8oREJ/Bq1r50UE7V4Lc7kA9mx3pi1MKwxPvPF0837GY6c6/m6mN7VdIVZcL0AFjHSlfnt1pAf/MfjNKhqZ1revATIG3wFEt0l3RCwVSxAB2hgLxwVb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(376002)(346002)(136003)(396003)(451199018)(36756003)(83380400001)(316002)(86362001)(4326008)(41300700001)(8936002)(2616005)(44832011)(5660300002)(2906002)(38100700002)(6916009)(8676002)(66556008)(478600001)(66476007)(186003)(6506007)(6486002)(6512007)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?enOKXdCupY0tgdLPrzBSiXJoyfGGoufoTVa2TXivv38oR9lk9lcv9zZnqIS0?=
 =?us-ascii?Q?D7Zlki8sT3GHiNOuQvi7KqNd/+OeQUYVRySJHC8km0MmwKK5Sw7j3jYKnDm/?=
 =?us-ascii?Q?e4H9id9WjPMWYsT4wGgGkEzn2wa8CI+SujpT6bfe5HbbCsU+ynGhFnLVYg71?=
 =?us-ascii?Q?L6eAIJ5Kf+OLFVJk//3/dcFuwAa2YGGrzspygMZfd7qO/DgJI4lL8/tajQ1j?=
 =?us-ascii?Q?TmGqc+aCFS4gfmZg+yDln9x4cvlhMI9rOQxZ3rNrh1FQMxRCIk3ec3JzDyF0?=
 =?us-ascii?Q?axqibdWHQJ0U7ytR2FEIz7Uua/p89bM87E/Qnz+QyHSIwq7uSTy3AkxlHaCf?=
 =?us-ascii?Q?BbgH0HN5SxfwT79RXE2Pf+j9xGJae36/9Qg0sTQvYpJxDm7Sn2/OpvaEvuwz?=
 =?us-ascii?Q?agiE3MvAj0Rq1Uw4663Hv9R+2hOUFL0AfABqRxYTj3ptddrdJd5giDzHamKo?=
 =?us-ascii?Q?RotBv8lMTDgu3gC7m5xzGYn1GXEiRBMDwos4JPZYe/jjxrVEuOteTcHaAo7Z?=
 =?us-ascii?Q?5W5QiYpJ68ME1AKJboMaHKPUud+T0N9IP6/m1YAMj1Tudu6qVBS4fmmFZf4R?=
 =?us-ascii?Q?mEuhRFCLTut9np556Q5Uymw2G6f/EKgTEjlO4924vrOoWGVqoT5v9AGDqZeF?=
 =?us-ascii?Q?QSVnBLf8BPQ7s0JDpbnOHWnlO5cX6Y8F+iFU4X6CclIvicQXZqlbIHcGPn/M?=
 =?us-ascii?Q?4BxjrzcQFRfAh65CFvcSeLMe07R9iuJI3IAzwj7w8ptXNUFm2J0myYRvBHP3?=
 =?us-ascii?Q?T5X7QRhePORfJHdtM7W4/lcDwJy7EyNDehpjYR4ksvogIc9fo8UHWgPOItyZ?=
 =?us-ascii?Q?jVG0K2Zh5Pn9rQvtR7pCFQIczn4J+k8xt1ihDhvckfe5rfJOawpMIy9Pe30v?=
 =?us-ascii?Q?R3TBUlJrAoxA6pr4rjJmvFtFt/wZlViG6qZV8S2MzzaDuccCZJuwNA+fhE7m?=
 =?us-ascii?Q?GhKRZOhSd6vCh0am0SyjOw6QrNT9ggEwz93IdnGPSY0AZNDPafzcPlN+XU2F?=
 =?us-ascii?Q?VYBUFjUFSIXKDEzspYcjYbYHdEzk7DnSZ3LaqlIdOZFW1v7W9QKjq+JLC30H?=
 =?us-ascii?Q?cfXsOQJ+QJ87GUh4CAhjZOUj2p4t/J9MC3Nyyf7tO6YcWOYbFNw9BA4aqg/K?=
 =?us-ascii?Q?FYtZpxHMVNIo4M0Pm9F0QUMzZSOFPwNFUy4ejcdV8VD7asBh47A0qNw67ZGd?=
 =?us-ascii?Q?TtRhrNTvFJt5mtSwlOAc/JR/eAbNcvwhG9YvIeiWPkUQ8PJMGhocvTgUfnAZ?=
 =?us-ascii?Q?LWQELteXeXKPANUU2xBF8p4mhEN93eLJr11s1SfCZvn9zRrdMNw1Z+bqXNya?=
 =?us-ascii?Q?uiNi3F+iB5IbcQPZqqGypCV8KfMKeNColhPbAPMDqb7UyOeF3aEeTcUGKMNr?=
 =?us-ascii?Q?ek67FfewwoHQPDYD3ckMldgrawVKU6jCMCNDqkDoMYgLtemly6TaTIDAjfU0?=
 =?us-ascii?Q?8phfRiiSsuA6sRmyDa0T2c1tn31vbHIKB0opytMZb6nGRaqya/mm18vmRedt?=
 =?us-ascii?Q?RhA9qJOR/Y0jOgw2h1ovUw8j1gU6eeTp8to2RD+F1W9HEuF2KDr2nMS1po9S?=
 =?us-ascii?Q?lQXE5c0v3s0dArKaQS6VzzA8alnfisu6Pe2x1A93EszXkQ6ojqu8FzKUh2cO?=
 =?us-ascii?Q?V4H4L06ZZ2buz0WOz0XGEzIbTQe2C6u4FKHFNCej0dFbErQgFJU5E4kZAp7n?=
 =?us-ascii?Q?QTRwtQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f671b287-de0d-4ce1-51d1-08db164ee779
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 10:07:15.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8jURIUrE736Re4YIfZkDCRsjOp62s4vwJ+3wsFOEEpRmuV2BCrHv6l4GbEbmYplco8R+fCvkwE2P8+JggfQJZOBByOsSbiabPJkWCrq7q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5564
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 11:50:26PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> EF100 can pop and/or push up to two VLAN tags.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v2: reworked act->vlan_push/pop to be counts rather than bitmasks,
>  and simplified the corresponding efx_tc_action_order handling.

This looks good to me.

As you'll need to repost as a non-RFC I've added a few nits inline.
But those notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index deeaab9ee761..12b34320bc81 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c

...

> @@ -494,6 +511,29 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
>  			}
>  			*act = save;
>  			break;
> +		case FLOW_ACTION_VLAN_POP:
> +			if (act->vlan_push) {
> +				act->vlan_push--;
> +			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN_POP)) {
> +				act->vlan_pop++;
> +			} else {
> +				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pops, or action order violated");

nit: I'm not sure if there is anything to be done about it,
     but checkpatch complains about ling lines here...

> +				rc = -EINVAL;
> +				goto release;
> +			}
> +			break;
> +		case FLOW_ACTION_VLAN_PUSH:
> +			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN_PUSH)) {
> +				rc = -EINVAL;
> +				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pushes, or action order violated");

... and here.

> +				goto release;
> +			}
> +			tci = fa->vlan.vid & 0x0fff;
> +			tci |= fa->vlan.prio << 13;

nit: Maybe VLAN_PRIO_SHIFT and VLAN_VID_MASK can be used here.

> +			act->vlan_tci[act->vlan_push] = cpu_to_be16(tci);
> +			act->vlan_proto[act->vlan_push] = fa->vlan.proto;
> +			act->vlan_push++;
> +			break;
>  		default:
>  			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
>  					       fa->id);

...
