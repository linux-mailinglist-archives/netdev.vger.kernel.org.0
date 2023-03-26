Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D4E6C94EB
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjCZOCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjCZOCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:02:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2125.outbound.protection.outlook.com [40.107.223.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C3A76A3
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 07:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6MjTjO0q5UJrjel69w/UkovhNN+0s0u9zTJwoOjZh0+W7GPteTj+5xo2J8zlTUshzXk2zG+X2crXh6UHYR3PpYu25w5LIeJ6JErxU+aEKMWYiBLloxOir7xrpCLxLV6uuuM9eIQz132SWfyMZkPScawL726RLvXtyyfmBIJTETESDE8jit6PHnNbj5LwNR1aYGUk3zZkCZSjqThoXp6n19s5LHW/1OPT0d/6XIrTD+Fd+frmtRdUh6H92D60E4fdruWu0IvlXtokZuJI3C802i8qdvtZyE37D/BHin6qj7kY9CP4Ue/YJudfvEPsaELXZpSxVIFbRya9BsmjADHIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDvTg6HBLOvJuSNTYp7FB8kBWg4d4P5U+cBdffnc6ng=;
 b=JSzNcBjA1GwhxZNzEyw2AoWL2If0Lqefmo3o5U5jD+jVbUvpyFes4Dtj9IOPo9KF9e4bj9GyrWlyPTm7n4pkhqu2uDbwcV92L8mUM9LiH9tY3SesB7padR/ffWM/inwAJG5vXz8NlWcQ+zodjfP/W6ySxKZ/Fb8eNxbqPW3u76hXA3hYpKboiB7LebF9QFKjmK/E5UlnMg4JvEpZX05avsMp1hodmgevEhAJ71V6ViNTwlpCbqA6jx45HJahlT+SMTVsQdqB7/zeSWUeEHNirTv17LB521+SUlHpHiRksPsc4FxnfoVXkvvQgHDmhPPeUNXWejXg/r8EenBl0yXSIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDvTg6HBLOvJuSNTYp7FB8kBWg4d4P5U+cBdffnc6ng=;
 b=t3ai8uBe09PKFsLGXU3OcJIKD+lUIg/0DTAmgzZM+GpDT/YXHLvJ/TLqE4T/+JaV8GsHKvt1UOoGV96Ba/gTyTdXl0Td+L/XpwzoJ3hjbZiyU3EaOM/USWoXzWefHCFmPCJdzpXhyBZy9/PUugO/95TzqPMDAcKnmDlfY8xF+3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Sun, 26 Mar
 2023 14:02:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 14:02:32 +0000
Date:   Sun, 26 Mar 2023 16:02:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 2/6] mlxsw: reg: Add Management Capabilities
 Mask Register
Message-ID: <ZCBQcoypD44Upn9w@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
X-ClientProxiedBy: AM4PR05CA0002.eurprd05.prod.outlook.com (2603:10a6:205::15)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 702bfd9b-d007-4a3c-5cef-08db2e02be96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acgdMEbEiaWOdlysd/Jyq/ywp9zjuBlieSgzWQN20riyGVxh6zwZhtN8HnaWZCumlcj9AQwmlKeB60q95dZJjz6nlw+UK9b+rLPLgBJj7u8XHlgd2XAbk9AGbcJkeNI9yXblEwM+fqxaqoFvdknk/HfxVXHfLXZtOTD7F7DRklWejlrXMKowv0QuA1jsTk44F0xhOcoFJ2Qg3+HpYmkGz7oqt37TXck2kjPoDpP2f4PLNj6YyfepMSmEW0ISJHMq+wtac6NOx8p7rjO36I22/j6SNnnk9HdHDyxdDp+uMW8pYuQqqX1F6pxqlQq4JWNqQl9Vvyc5lm4uM5Aw/WSB7LhFCqFGeL+lfDXWDoLYYDdGAccvLeF43KSI+yezZYrL5eBAAnm3NyDDis/fRUSyZQ6gtBfcZ3bJzQ6N6uBWOA31V+Rdmo9l6pSSTrMdh3O8cwZRLBe1jPPrN7RBGU4/cNs/uTvurx0zo4Vad9TXfB97/+ZBMg+TvaKVWlNJ6xuLMyFGWPlYdtSidSdMNVlqJfv3aKzq3YG9kipe77cnMpMyDKrCZFjD3ASHEttACotr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(346002)(366004)(396003)(451199021)(83380400001)(2616005)(4326008)(66476007)(66946007)(66556008)(6916009)(8676002)(6486002)(54906003)(478600001)(6512007)(6506007)(186003)(316002)(6666004)(2906002)(44832011)(36756003)(86362001)(41300700001)(38100700002)(5660300002)(8936002)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xyOQlAaTvNZrqhAMNgRFemoyCPlnTIMBTQztn7Rxihz5/vZZbfC1sFeJPRCU?=
 =?us-ascii?Q?vamPWh0Oioo4QfLRcbFeR/2vjE4CfYbErw2zUzM4JjlhWDClwt3xpRcXbO7X?=
 =?us-ascii?Q?BlUm/zhCIs8Kk1NdKM8M0pIpiR14JbIb16WbvJo/SbtIji+yhUqQGYQgPhZL?=
 =?us-ascii?Q?zwyJ0w8Oeb4n7WWubeoQuAh/AOcptaXMWA/o7YmJy1Oh5HIQStfmUfD4Fg1w?=
 =?us-ascii?Q?9NZwa6n8IS3HIuwd/waDeiaR2DUxoS2yGekSmXNqyzRNlJwDLi8a/Z//b5lr?=
 =?us-ascii?Q?TU1RmbNCzeIJ0UcDlMzZIxaMLrCnvomJu8iOOYpfMSzGitYN3fubeHdQIEWG?=
 =?us-ascii?Q?VIBpEO0OIoYFfbNxjWAKdqXMD9EsNzAt4aktOlpFqpKk1VSLGshD7kzfwoiP?=
 =?us-ascii?Q?oyTbApqpuGJaB/G5fqjf9dd2dfx/Z+BFGByuxEoYoDS5B9eB3XU28en6kRXy?=
 =?us-ascii?Q?lDpKOIkCEE7arxsw0cM//B5TDrHJKImZqyOou0ZHjmj2TQcTG9gBvb+XBVdN?=
 =?us-ascii?Q?yZI2aom36rPVhOzNCHJOTwRkseHyu6nhyxZxEWhVnpRqbsl19VvJNBUXmnRN?=
 =?us-ascii?Q?AEIBqIxaf7QIKeMSQitQjvT9qVlmF7mUgvZVIZHy4EOJGfzu5VzKLrAgYob0?=
 =?us-ascii?Q?RQfZUWTsYpsThKJnM0Jlza8bhfx6bDWw3Db58tuJgZEnfqlmBePUYp+Slmix?=
 =?us-ascii?Q?ALPyK+SCbq92QSaYAk7LSGqfg0K5k/25EGKDoZj9CzBEqqUD65ooaVptO4Hj?=
 =?us-ascii?Q?EYNcIoJp9dLJQ9HfEd+lta0cGpVSCXsejzdK+wrk+1oYrYT5zJRCivQl56V1?=
 =?us-ascii?Q?aT14y+za3G18qMLAcSJsznbtlq+EdMJd/FVj+EU/6pf8kXkH++kmhAFcP9MX?=
 =?us-ascii?Q?Bw0+fIrfLD9wP/UFTIMkFKMPNMYddjLxOKwgr/CRb1PKN9vHcdeptAVcvjHj?=
 =?us-ascii?Q?b10HoogWqP93al2HftLk5+ImOich0LVVb5mjCP6msV9xp6BT0jWDBtHcKghz?=
 =?us-ascii?Q?h0Bk6wrSIN9qsyOHCNbsI0hziQdaI+lbEmhSOYQvhU1ttML9rZz3Gis9+lAE?=
 =?us-ascii?Q?EvB4kqfd4SEt6sRuomrzo9AtgsIlCugxdr2Ex3iTFOqeEFYYJefVBdW2evnQ?=
 =?us-ascii?Q?yZ1TS8NE5WZMJk49cmJEfAtudCAItN1rKOtWBE8kSGxR2W4/yDWOuvpVQtXJ?=
 =?us-ascii?Q?rqkiG8v66q/JEm6bfSu5pjmJgBtEHfr1YR3kgnPIdTRFu+tFjSjSeW7mtO0r?=
 =?us-ascii?Q?uIVDLs+AYwCgdhztnhxdTQbkBMWAhPMosg8DqA9CPeznX3pEaUYJbgEvwe8q?=
 =?us-ascii?Q?P2oAymS23aP2gF9/LCOYFc9vfGXwTNwNyF5Zz6FHMtJmC8YoobNHcvPpnXfN?=
 =?us-ascii?Q?Fu9klZYT8HDBRjWgXUcbVe3MmCd4TGo3MydzkDwJN9HxvQxSG0Io/+6TNOKc?=
 =?us-ascii?Q?0x3/bgNreJleCOGS6QZZA6UBSUjBOOyZw9EhyenBLRqnpg1RgSYe4fRMFMMk?=
 =?us-ascii?Q?yIBDGqK0h/IRn4Ll38RBgfojzKFwuZjBumVUFSG+SuUD5gh3xLvJ8O882a67?=
 =?us-ascii?Q?8l5/MRNTkSIQYPIbcbxn62ThUlkjSbVOvWXcsGZaZG5FT/Z8f2if7wRZq2s/?=
 =?us-ascii?Q?hNS7SLPPg89uYn8RreWutVFJsTTiq13DQxXyjftb2/ifUSXbkK07d8rhYlVV?=
 =?us-ascii?Q?M5jQUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702bfd9b-d007-4a3c-5cef-08db2e02be96
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 14:02:32.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JU2UAK80doZcJyM08oyz0wcXnNzV+XQdIPXl0ez5aqqBRbLGKpIBObLBpRjSPVGXkT/Rxsm4JrZlVTXdwIV0BCCb1tSbz3n3c19KiEgLqvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:49:31PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> MCAM register reports the device supported management features. Querying
> this register exposes if features are supported with the current firmware
> version in the current ASIC. Then, the drive can separate between different
> implementations dynamically.
> 
> MCAM register supports querying whether a new reset flow (which includes
> PCI reset) is supported or not. Add support for the register as preparation
> for support of the new reset flow.
> 
> Note that the access to the bits in the field 'mng_feature_cap_mask' is
> not same to other mask fields in other registers. In most of the cases
> bit #0 is the first one in the last dword, in MCAM register, bits #0-#31
> are in the first dword and so on. Declare the mask field using bits arrays
> per dword to simplify the access.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

I'm fine with this patch, and offered a Reviewed-by tag in another email.
But when sending that I forgot the minor nit below.
Please regard it as informational only.

> ---
>  drivers/net/ethernet/mellanox/mlxsw/reg.h | 74 +++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
> index 0d7d5e28945a..c4446085ebc5 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
> +++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h

...

> +static inline void
> +mlxsw_reg_mcam_unpack(char *payload,
> +		      enum mlxsw_reg_mcam_mng_feature_cap_mask_bits bit,
> +		      bool *p_mng_feature_cap_val)
> +{
> +	int offset = bit % (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
> +	int dword = bit / (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);

nit: checkpatch seems mildly upset that there is no blank line here.

> +	u8 (*getters[])(const char *, u16) = {
> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw0_get,
> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw1_get,
> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw2_get,
> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw3_get,
> +	};
