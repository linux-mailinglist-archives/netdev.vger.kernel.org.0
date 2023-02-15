Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262CC69782E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjBOIaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjBOIaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:30:22 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326E46A7;
        Wed, 15 Feb 2023 00:30:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRnzSSGUDRstTSJvr4Mo/8m9R8afz63o0yVXpzF1KopBPxV93WT9oeLOHWod9btyT5zVfC0pJ2drlLz2B9qXOdZq32r5G3lC7QiMF6TGP7xQZU7/EzpeOj3wyFM6GgFIO5qDIyVinkJ7/8ZPZlhjaoldsDvN+v7IZvRpU5y/9h2eqa9iJW8+CWNWd30WXcc6C1H33cNdm0nJgwxR3ktNgwvU2UGDNPV3feFmmPXy3M9cB72FEQTyCXwEECFaRWuU7wxtpPZ3Xcg1cIDTE5572J+ZpcSb9xYAoNDYt4Cyvsvzqs/J85lctN+xAnA3ZkbeIRd2G8WMe3ImanODXxZjSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGjGnKSZBGLCXrkfn1CiXoJ0fJnz/tIuu+lcwPmN+yQ=;
 b=iibMhoitdp7g4VU4sxgnNKhcM21VhHaJah+D36mEN8UsdKaM93/C55lxvY8T66SrNheOzsNKddo9IbHN3ZkArstYvyr5txi4S4FZS5zACMey/lTqYKGp8Utu6SlKxd2k2xd84iKGXSpMftRTxoxs9bF+JBxGBWYKAGvudeuBK9rXWuXGH4Xh5H+EFF/OmkIx8DLt7A+nQkj7Jt9A9SLwZwnfGMI0/tp/iDNy9bnpB+6GSSaDgaBls8ddV7uMN+/bhqZ5CgUVjS9FaUKSZ7PSWa7AwdCZ2t2F2bScbIesibBPprtZbt6kUH7Lx6P7aSJX68jYam9Pc+KIs1kZXhtCJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGjGnKSZBGLCXrkfn1CiXoJ0fJnz/tIuu+lcwPmN+yQ=;
 b=ag+NHU813o916aApJgZ6QmtQS/YYOpIccmRN6//cOJsANwSdAItPtujWHq0qPDHIQKM7vqy0va/wIFNyM5AUNX9ohGhLl98x01fs18l3GGulTrLZELyUQwkd+olpIMsOtkp2hP4co5fhfu8kGRpUrmYi7C6+B1eDIcaRdmUFTyUCAbG6NFpJXo4UtOLvG2LI77gt8y/8l1FH9Em4DaR5lq5435IzrhJNS9zJae+1fOiVMryfxIQHJbDY5dj76kXw2b1+QcDuf/necvCukhgNgC6A1zKbZbv2AJ1LeoFSiIIqnQQ+j70a8TyW0u/XJlWbKgvBNO32QKqfi15ZZk5z5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by CYYPR12MB8731.namprd12.prod.outlook.com (2603:10b6:930:ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 08:30:18 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 08:30:18 +0000
Message-ID: <92d83584-2238-f8e8-3ed6-f292223e4061@nvidia.com>
Date:   Wed, 15 Feb 2023 16:30:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
 <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
 <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
In-Reply-To: <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:4:7c::27) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|CYYPR12MB8731:EE_
X-MS-Office365-Filtering-Correlation-Id: d6810a69-466b-481c-d691-08db0f2edec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKQLno2QnkvI2HJQwQZ1QtSlNWykgM3+I++kV0+Pe1w06OoUxig8kf4N7gjxGlpxoFT/g9JQCkzwC4dBbm6KfDK14wGX+6qa6uVTVLYT9NWXRR0eXnjm79yMu52+nEt3Izf+bGwVSHSnCjijK93vaVe9+8GHRSCXNuvELEXx5qsUk6GnAR5dQtvkXncf7zrSXIToY539vQndS8rgrmu39Vfvmcrwx3waft/cNrFm9uWneCehjxMEILvvBdeU90+MCyLYSM+SSs50YteWGwBqkvtt2XVkqIIRvfyTaWTal3vRguIVHCuNBjbycG6/GjOK7VWn+HDcWWsC4BC+Z5QasReD2DVQX+xBEwZSzDGF9JXeeE0PSOGRpKUjlM767Z+VM5aUlmjPi1C9UvCAOfoSyp3cKkG/0I1994DWxZMj9QexfcJO75nrjuOrBXOT6kEJQ16lKjw04geULe+ztY5fXfaZqgI9na/aS897EeZEFvYzk8Af1hvghyqi5gvEa7DacpnE0sJEbiipqO36FhiVMq49aRSZKwknsCLY7KBFQFHLmQ0wzcsoWoPnRTe7XQ3yHU1v0Xt8Sx2jUp6M8ODrOXI3oCqOPlVg/nvxs9+YymmqXiy32XhnpXkzn/4TY/nLRs++m1VeUbFC/QCfDQV7JtPnFMKmdr14LD5qtwbdckf8mfDypem6bBHt+HcAnfdPvwm3VBS15u+YQK4KXJLB4GQrZiSLk/7H5wJuIffbOto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199018)(31686004)(86362001)(36756003)(38100700002)(31696002)(6486002)(83380400001)(2616005)(53546011)(107886003)(6666004)(6506007)(478600001)(6512007)(186003)(26005)(66556008)(66946007)(66476007)(6916009)(4326008)(8676002)(5660300002)(316002)(54906003)(2906002)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm54Z0FVNk5wcWJhd05VVXBLaW16ay80Q1RLekVGcE9VYzkzcWRua3Y2VURu?=
 =?utf-8?B?d05tbkI1MmVLdHJ2R1lOL3FJS3RhTjJ3Nm1qcVVVSmVtbE5makxYUUxRSDNl?=
 =?utf-8?B?Zk03bmNPMUxBYVl0YmE3d0xGS2wzZ1RxRGNYVmRDV0NPTEdhZTFjL0dXVjlK?=
 =?utf-8?B?MEpWS1hOV1J4cXZndmZoelZLbW9NaUJhSUZFRUFJVDRJeEdoT0FjZE9SV0NF?=
 =?utf-8?B?SkJQZ21WWkhIbk5ZWG11My9xa0pmT0FSMEFWQ0ZpT3hzbm50OEowSGQrUzll?=
 =?utf-8?B?SnlOcUpHNE5zTUJoSHY1Nk5CMXNNN21HKzRjaS9PZUYwcjJyTWJ1RFRRS043?=
 =?utf-8?B?enpjbHZxNk0ydlMvMjhkWWk2RlJteEpra2ViSmgzUTNnZmtTOWJPbHAzMFZV?=
 =?utf-8?B?NXVkaGNMN0xySkJ5TnAzYjF6WG9SV3AwWXpHOVh3b0pQaWZ4WjI5ektlVkp3?=
 =?utf-8?B?MHI5aWlidGhzR1dHbUhOaWZCWWt4ekU5Vm5qVVZGTGxQVEcrMjhrUGQ1QXdJ?=
 =?utf-8?B?MUIvTzllcjFxY3krb3M0a2swM2FMNGNTZ0JkMUVtNzArbk1jOFJERDhXSEkw?=
 =?utf-8?B?UExDSUF4bkdCR25YeDRIL2NzelVlREUwK3M2VWpaQ2tqVVFveEtCTzcyd0xT?=
 =?utf-8?B?MTAzdGVlVW5xMEc2WUlHM1haVXR5bnUrUmdoNGZ4TjBaNnpQOUFHK2lEMEI1?=
 =?utf-8?B?d080SDBOUGxjcGFtcHJMaFlWd0pIYzRoWVE0WEdzaXRkaXNwbDRvL0dwUGJk?=
 =?utf-8?B?RFBrcXFOdnpXcDhQY2hCZXIraHZtcWdxeEllV1cwWDVaZURaaHRzRUVxS1hK?=
 =?utf-8?B?SVBmbjVDWTdRQWxsL0RMbmEvQUpOemEvWGs2Z25RQVVIbEZIR3JVMXlrT000?=
 =?utf-8?B?VUFIbDNGYUhMaFNXY09yTldtM09rcUtNY1FmYlZETXBLVmM2RE1RZ2Yyakhr?=
 =?utf-8?B?RjE5Tjh6TGZZS0FBM1NVZUJiL2VOY2R6VnZUQUpPVE9YRjh5VXVseklhbWZJ?=
 =?utf-8?B?MTMzK25CdWlMNlVhdzJ4MVVNejcwTHc0eDFpMzNoWXBEcW9rRW1VaGI2YVF3?=
 =?utf-8?B?OXFNcWpWQVQwTkMzRHhTc2c0U1NYSzRVUlMyVDFJOEpCRGtTTm1nTUtudHdJ?=
 =?utf-8?B?WlZZSWx3aG1nL2MzNU0ycUJ5TW0zZE9JalpZcjRwbGlMdEJEUzBZdDh5aGhW?=
 =?utf-8?B?b09FeDRqdTRiNlNKd2dHKzc3VUJXOUJZTU42Q2oyMTFzRjZ2VTJPWmZhM01K?=
 =?utf-8?B?STRiRi9BSFIwVk1DOXQ0akxQMHZ6V1FJTWFYdVJxL25Kb1FSeFVKUGJDeUl5?=
 =?utf-8?B?dk16d1RsdzUxbml5WXFpRVNlWnFYNWh4T3BQS0lwNzZCSnlzcytud2lUaTMv?=
 =?utf-8?B?cnRiQkZSdEFiZWs0YkdpckpJTWV0WDIzRDZnS2VKa0Q4eGErc2lwQ2V5SzBT?=
 =?utf-8?B?T1d0bEordmcxcDRrdGVJUEV6VXZTa3ZMcUtFbTkvNlVLYW01cmk0bnpkUThk?=
 =?utf-8?B?RGVJelo4Z3NMM2JseTFMYUFhYjNkRjdjKzNyYmMyS003em9mV2piVFlCalp1?=
 =?utf-8?B?RWdUZDZHeFF5QnZzSE9OeS9ib1J4U09ZN0xEcis2eTl3WXI5eGpmNDJGSG1i?=
 =?utf-8?B?YWM2WkNzMnI1dVYydEJNZjFaQUtZRUpLaUU3d0tXbjdtZExORFp3d3Fpdm9C?=
 =?utf-8?B?aEFOb1dIaDhQWEFNSS9QYXZHejFnT3FBbnIzN0FwVGVNeU44QTNCRmEyUzhl?=
 =?utf-8?B?YWx2SFoyY3FyODdoamVmYjJyTWRkdG5UVllMQUVNWThwNGRmZ0tSQVRiRys5?=
 =?utf-8?B?Wm4zWEhyNy8zUWp5emw4K3I4Zkp1djR2aUNlZGVqYVpQZ2pHcWFwZG0xVHlM?=
 =?utf-8?B?ODJOVEhRV3d4Z0xOays5aFdlVTh1NnFTbzJpV1M5aHhFOXpBZjhWVXB3eXpU?=
 =?utf-8?B?YmpqdnRxZTRoNGpLNFRwM1NmaDRabUROZ28zQkFCYXdxa2h1RjJwUFQwS3ZG?=
 =?utf-8?B?Vkh0MUNlZU9qenluNXM3d21sQ1BIeHRTQTV2bkhTekIzbU8xb2hHL2RuTlNo?=
 =?utf-8?B?cmpTa1oxdUh4ZWxqVHlFZWJCUzhnVzlUL00vR3ZwYlczendWc1JjbWgwTjdL?=
 =?utf-8?Q?iKcwipohChTbl+zJtINUSFtmQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6810a69-466b-481c-d691-08db0f2edec2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 08:30:18.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/RzKuDakRgCynPZ/lJC2mZxb70EsjpDte6bYIgzf31lAEzPbXrOFncpiOKBs6b2q+78Q2uWtyXF+1b89mRtew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8731
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/15/2023 11:36 AM, Gavin Li wrote:
> External email: Use caution opening links or attachments
>
>
> On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Tue, 14 Feb 2023 15:41:37 +0200
>>
>>> Add HW offloading support for TC flows with VxLAN GBP encap/decap.
>>>
>>> Example of encap rule:
>>> tc filter add dev eth0 protocol ip ingress flower \
>>>      action tunnel_key set id 42 vxlan_opts 512 \
>>>      action mirred egress redirect dev vxlan1
>>>
>>> Example of decap rule:
>>> tc filter add dev vxlan1 protocol ip ingress flower \
>>>      enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
>>>      action tunnel_key unset action mirred egress redirect dev eth0
>>>
>>> Change-Id: I48f61d02201bf3f79dcbe5d0f022f7bb27ed630f
>>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>>> ---
>>>   .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 85 
>>> ++++++++++++++++++-
>>>   include/linux/mlx5/device.h                   |  6 ++
>>>   include/linux/mlx5/mlx5_ifc.h                 | 13 ++-
>>>   3 files changed, 100 insertions(+), 4 deletions(-)
>>>
>>> diff --git 
>>> a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c 
>>> b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
>>> index 1f62c702b625..444512ca9e0d 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
>>> @@ -1,6 +1,7 @@
>>>   // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>>>   /* Copyright (c) 2018 Mellanox Technologies. */
>>>
>>> +#include <net/ip_tunnels.h>
>>>   #include <net/vxlan.h>
>>>   #include "lib/vxlan.h"
>>>   #include "en/tc_tun.h"
>>> @@ -86,9 +87,11 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char 
>>> buf[],
>>>        const struct ip_tunnel_key *tun_key = &e->tun_info->key;
>>>        __be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
>>>        struct udphdr *udp = (struct udphdr *)(buf);
>>> +     const struct vxlan_metadata *md;
>>>        struct vxlanhdr *vxh;
>>>
>>> -     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
>>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT &&
>> A separate pair of braces is preferred around bitops.
ACK
>>
>>> +         e->tun_info->options_len != sizeof(*md))
>>>                return -EOPNOTSUPP;
>>>        vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
>>>        *ip_proto = IPPROTO_UDP;
>>> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char 
>>> buf[],
>>>        udp->dest = tun_key->tp_dst;
>>>        vxh->vx_flags = VXLAN_HF_VNI;
>>>        vxh->vx_vni = vxlan_vni_field(tun_id);
>>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
>>> +             md = ip_tunnel_info_opts((struct ip_tunnel_info 
>>> *)e->tun_info);
>>> +             vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
>>> +                                 (struct vxlan_metadata *)md);
>> Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
>> arguments instead of working around by casting away?
> ACK. Sorry for the confusion---I misunderstood the comment.
This ip_tunnel_info_opts is tricky to use const to annotate the arg 
because it will have to cast from const to non-const again upon returning.
>>
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv 
>>> *priv,
>>> +                                            struct mlx5_flow_spec 
>>> *spec,
>>> +                                            struct flow_cls_offload 
>>> *f)
>>> +{
>>> +     struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>>> +     struct netlink_ext_ack *extack = f->common.extack;
>>> +     struct flow_match_enc_opts enc_opts;
>>> +     void *misc5_c, *misc5_v;
>>> +     u32 *gbp, *gbp_mask;
>>> +
>>> +     flow_rule_match_enc_opts(rule, &enc_opts);
>>> +
>>> +     if (memchr_inv(&enc_opts.mask->data, 0, 
>>> sizeof(enc_opts.mask->data)) &&
>>> +         !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, 
>>> tunnel_header_0_1)) {
>>> +             NL_SET_ERR_MSG_MOD(extack,
>>> +                                "Matching on VxLAN GBP is not 
>>> supported");
>>> +             netdev_warn(priv->netdev,
>>> +                         "Matching on VxLAN GBP is not supported\n");
>>> +             return -EOPNOTSUPP;
>>> +     }
>>> +
>>> +     if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
>>> +             NL_SET_ERR_MSG_MOD(extack,
>>> +                                "Wrong VxLAN option type: not GBP");
>> Fits into one line I believe.
ACK
>>
>>> + netdev_warn(priv->netdev,
>>> +                         "Wrong VxLAN option type: not GBP\n");
>>> +             return -EOPNOTSUPP;
>>> +     }
>>> +
>>> +     if (enc_opts.key->len != sizeof(*gbp) ||
>>> +         enc_opts.mask->len != sizeof(*gbp_mask)) {
>>> +             NL_SET_ERR_MSG_MOD(extack,
>>> +                                "VxLAN GBP option/mask len is not 
>>> 32 bits");
>>> +             netdev_warn(priv->netdev,
>>> +                         "VxLAN GBP option/mask len is not 32 
>>> bits\n");
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     gbp = (u32 *)&enc_opts.key->data[0];
>>> +     gbp_mask = (u32 *)&enc_opts.mask->data[0];
>>> +
>>> +     if (*gbp_mask & ~VXLAN_GBP_MASK) {
>>> +             NL_SET_ERR_MSG_MOD(extack,
>>> +                                "Wrong VxLAN GBP mask");
>> You can use new NL_SET_ERR_MSG_FMT_MOD() here to print @gbp_mask to the
>> user, as you do it next line.
ACK
>>
>>> + netdev_warn(priv->netdev,
>>> +                         "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     misc5_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, 
>>> misc_parameters_5);
>>> +     misc5_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, 
>>> misc_parameters_5);
>>> +     MLX5_SET(fte_match_set_misc5, misc5_c, tunnel_header_0, 
>>> *gbp_mask);
>>> +     MLX5_SET(fte_match_set_misc5, misc5_v, tunnel_header_0, *gbp);
>>> +
>>> +     spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_5;
>>>
>>>        return 0;
>>>   }
>> Thanks,
>> Olek
