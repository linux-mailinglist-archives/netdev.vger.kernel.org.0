Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6DE69781D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbjBOI0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjBOI0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:26:49 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD6328205;
        Wed, 15 Feb 2023 00:26:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kh3SljzvOU+KuxdLM4bLdlif3MSg0Bigjw8qpBJCc+7OGUZ2RmUuzaRwX3F/Z6IT4qlqyuh5NJUmAo3Hlq3v0jHvwnYB0ZJiRWPTquhu1z6QWADo1g3jjOb46hss3DRZ9rX/4FMKYL7o0qrVXCGg5iXKM7zxt0vdgOr3Y3Di9zFz8pNEIcPELAULBJkhaBULExB6HokGOZPP+oZGeecdwTYaSu9wE0A0Y2K9SCYmuVj0m3jO1nT3hcEbjHsy9tkaDF8byKKZSOFNCxwCyiXuWDtaStwZnqbL0lR3aiDhCV4emu84/hgWX/E/nP0h3a2TGE+dPEyCn5NBDEQyTxg0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2+3kXW2poO7nTwZHsX9zn7itTdi2jF/BzycjwZ9H7M=;
 b=EXVjDrEOn3yvFdxLEVtgnH6DfPCa8cwv05IU2xXAmEO8JsiFiqe55EgY8uAsvYBgcyPK0QqEi2JS4zgClrx8u8b2fxTFNdz80iwTxWv0edVjxbiuyLh7z0XCv5R8BdXR6fGRK6rlztvAqz43fDYhSAio2AJbU/ITcK0UtE3fkURIPBBIzJl0kw6olREt5CDsJXsYsTpUrlGhJWGvctjUC1lMbzpLh70MIVCTPmCMTNRtGF0EV/UulkVbqtp9Ym8NH9qkbfvmskyuAiJkd83mrdf3vMA37qDwBv/sHCItPDK96VYt23BIoFNpCJ7HFyzad0gUqBVoCyleJ5MQ80Di9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2+3kXW2poO7nTwZHsX9zn7itTdi2jF/BzycjwZ9H7M=;
 b=MkJ2XbScx8H3DXprDLdMPOLQJcbPvhUHOB6UcdKiRf48t7K+qdIrh+ebwwGUvpVtFP7YgxRbYT4eQqvUV4f/UqcHUVX76xm5Q5AYDhq8lpdeqhJi30G1rHzLzi2DkUg/2vCZ1aOBbwbYIz+QNQaX6jPFCmii2kd/DM4j0OEtWLaKIJyRtcEAWBCC7gU/RVPv2CbF3hL/p7O4YF6UVkB+UzJNnu0i9HMpiFZnY+iKs4EurI1cH5lkStVIPvZwBUQ2nV3nXAVHZRTx9fj249T+bUiqNhRF9HpxtZlUmEef9M0IixsOe9cbcDMe/Zbsbdo/6bsVsoiKKOp24yykAGAAyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by CH0PR12MB5187.namprd12.prod.outlook.com (2603:10b6:610:ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 15 Feb
 2023 08:26:43 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 08:26:42 +0000
Message-ID: <38afd44e-a93c-ecf5-7c5c-48c5a6bf3b46@nvidia.com>
Date:   Wed, 15 Feb 2023 16:26:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v1 1/3] vxlan: Expose helper vxlan_build_gbp_hdr
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "eng.alaamohamedsoliman.am@gmail.com" 
        <eng.alaamohamedsoliman.am@gmail.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-2-gavinl@nvidia.com>
 <a5a43d44-277a-1222-a700-ddade69d6243@intel.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <a5a43d44-277a-1222-a700-ddade69d6243@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0052.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::10) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|CH0PR12MB5187:EE_
X-MS-Office365-Filtering-Correlation-Id: 62602de7-f40e-4395-b1bf-08db0f2e5de0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w390f1o/knONpOVaaQc7Ef7dy2ezL7JVmjSGzrkLFEsNXoyTWigK4iXkQY2lCH5yTj50gW7dqNGsIIZFqd0ASCzc1QC0RO4KZ2JDLGlsxdCjcvL9o3JmDVo6IL6S0mHyBxBuOvJqIrdVoAi6lZUd7Rz1OH4aYgJj26P/ohvToChLrA0X1EugqLyJb0cCGAl8SNuhzdP6g6HqMKNZ7ShYDEcDHyDcHpm6FpYmxvGF1r+p0lYFLkW79sDFbQVSV/IEFa/9m4kdnH3r3ZvIeH6rjZKg1eS5qHPLYiNZBFAV6Jyt4NRzBc1E3BudBNPnJLyn36HhyZwIgV8UCbJ5rujPIXkHP1wwCqIRHMw4WWngqXQf9j9MKjxQwj4Y++B7DJ7R4vD15Tzz7PSVGAVc1qOmPu8RktGlOGcHNyWXvBxdvvjIskOiaD4fFn0wKHSgnxROMvcHk4NDzH71UPHJKILxrdvV9/ysgRVmqvxmFPHApeAgjLMDXHBYKNAKl8LVutbfDqPS0NVdkut5Zy9Pl1tAvf7znufD3rhYTe2vR+zAUtFN3zeeM4getZ4dsTOFhOnFBguxG3oGEX7jWBDVYtcnwfTOlTUMRVRBtB7OJ8rfnhMGnwAiUbfgfVXD93k97bDFXa4ZGyZbSD841bHCWWp1T6L58ocYnd5U6MLhE5EZnzvf+XvNJR10nDIXrdISHf+VpI/0U6h8QXQgemHbdqJQw6QBM6y3rbpxyzIrEzX3vbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(83380400001)(8676002)(66556008)(107886003)(4326008)(2616005)(6916009)(54906003)(6666004)(66476007)(66946007)(53546011)(6486002)(478600001)(6506007)(6512007)(186003)(316002)(26005)(8936002)(31696002)(86362001)(36756003)(31686004)(5660300002)(2906002)(38100700002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WERTbldwNmtPNy9TU2RyRFZ4czcyeVVROFNHUVV3dE5GR2syUGxGTnNCMVJO?=
 =?utf-8?B?ZkhheTBhV0k4R3JONDREN25za29pM2NCK2ZldGhZZ1pnMitNZmxCMTBmQWtp?=
 =?utf-8?B?RUNyb1c1dUtvWFpUUjhmZ1NPamNPc2J0eXhQYkl1VUZUTnQrN2ZZS2RSOTJ6?=
 =?utf-8?B?ZkFveFl1OE5DK3IwT3QyUk5EaUNIL1gvZWMyb0R6U012Tnd1VExXUE1ZZHk5?=
 =?utf-8?B?RDlXb2VkRG1iaDhrR3FESzQ1MkplY0ZVSm9QUlJnVlJuaGxIblVwSkxNQXJr?=
 =?utf-8?B?QzNyVkxEbUFMMlZTc2pNNHdoYkU5L2xWa3Q2OUZDZ2FnMHhBNm1iWGZFb3NF?=
 =?utf-8?B?ZDZ5cVpkdjc0dktUMUVJRDRGaWR3ZTdTNUg3YUVzZVV4Rks5alkrRFpRNEtl?=
 =?utf-8?B?UXZLTVlCTmVNcktvTjQweWRQWHFGQmg1WWFGKzFnc3lqb09uY05IcFplaXhE?=
 =?utf-8?B?M0pzWDFiVTRCbmNrV3hlTEJHWGJnVnFwckVuRkU2SUowYjZwL3pHRzU1YlBC?=
 =?utf-8?B?dGtNNUdaOVdzSVdHZ3pYVGF6SVhLRmdnR01uOUhoVDlTNlJJMFNVWUQxWWZM?=
 =?utf-8?B?NHJOVENGK2JTMk1pNU9GbCtKUlM1eElYQXY4RFI3cGJRdUpjQWtUZ3dyUW5Y?=
 =?utf-8?B?Q3QyTFIwWGlJNlRwb2MydE40bnRhUnY0cDE2dXprYWNPbUFnUmowajZRSnBs?=
 =?utf-8?B?OGdpTXJrb1RneThvSDRRWFFnRm03ZHpPRjdlc1hIOXI3UEhGQjBmUHg3SHZH?=
 =?utf-8?B?N0NTWkUrNllEQzhMM05NcmZNVUVwU3lXSGNnV09EWnJZMzc0aHJQV01INlNo?=
 =?utf-8?B?QkFQUmxpanlmZ0pvRk56OGZKdzJ6NHR0d1E0UDJyUnlFcEVZd1JVTUlwUlEx?=
 =?utf-8?B?OTAzVmhhbjkwa1pxajhzbTZzY0J2bnZQUHlQSVdaTnR5ZDN2OTNYUDBxVnlq?=
 =?utf-8?B?ZHpwT2ZTVmZBdUVwWjVtNVp6aXNzcHNocFFXN0J1WmFFY2t5SkNCRk92bnl5?=
 =?utf-8?B?eERnSlhRU21VbVQwOFkyK2hPbnNFUmVzNEw5aE5kcStHcDZJTS9qMjlhVzJY?=
 =?utf-8?B?cG9IU1JiU3RlbXlDYlM1VEYwZ0VkeEVoM1Zud1RMMVFwV3V6cXlQSUxQSWZ4?=
 =?utf-8?B?SUllSkxHL25kcWg3VWJGSlZzektuYVU4UzlOTkF3S0pDbmxvc25JaG83aU4w?=
 =?utf-8?B?ejQ2RXltNDhkRC8yeXRUSzJBeERjVjJ1RUx4RmlYT2hZM1NsZytvZ3FESjdB?=
 =?utf-8?B?M1IzT3ZqdXpvMEM1QW9tNGYxMDl6cTAybG92VzJBYW9TTmxEMFMwZTZQMHdF?=
 =?utf-8?B?Q3JXQUdma3Q0L3V3Qm9SOWtFUWRUV3g1Qi9yTWtzem9qSFV1OUJhZmo5ZEpG?=
 =?utf-8?B?aFd0SzFJc1ZoUXJid0RCVEk1RmlFUU1WU3pYVWtlRk1EUWFTbTQzbXpVNzQ0?=
 =?utf-8?B?MEYxeUI3RmJwWDlnVGorQnhoMHpLdG9VQWgvMGFSSS9JdmpaWGkyTklGSjJ3?=
 =?utf-8?B?dUFRc0Q1cDJkVUQzTWR6YVlFM1B5VFBneHAxbXVhLzFzQXBER0FKMXdhQ1BF?=
 =?utf-8?B?c3JJZjhsSDVnY09BT2lUbDVhbklHUll0djM0cC9ZTWY0OWM3Ti85VzBzN3Zw?=
 =?utf-8?B?K2RGZ2RBM0Y0QmF5bnczc0d3MmgwUE02eTBWcTJWdVI5U0pvY2NnNkx6bC93?=
 =?utf-8?B?TFF1MXloT0VJOWcyc2oveHBxYmNybnVzcDl4YmhIWEVlbW9BZFdWTGVlZFhp?=
 =?utf-8?B?anhlWGdUQ1lXZU1YdElVNVJGdHBaQmoxTjNreVpQYjQwRkZDNnRldmtVQTBC?=
 =?utf-8?B?TU8wTkRlYitQZTlTV1Jha1ZKMGxFT1JiSkZnSmkxK0RKUTJqTEJyVUM4U3Y2?=
 =?utf-8?B?dHdjTUxYZVRWdTFJN2ZvU1BPelRYa1ppUVAveGdoNG96WGVxVTBtVjU2eWRx?=
 =?utf-8?B?aGkxUU9OWWwzU1FPNFkrUVFCWGNTOHp4MXFXM2xPbGpKa293V04zZjFhcHNl?=
 =?utf-8?B?VHZkUjV4NWUvNEc1L2hSUmd1VEZOL0N0SFFSRmJQZGNvT3ZwMzNEME9Sdi9X?=
 =?utf-8?B?SVlTbm5DRXBycHplb3VaYzVWd3R6ZDRUSCsvUFZIUnphWXFUOTNtS3ByQnE1?=
 =?utf-8?Q?YNAG98gQji95U1IY99GN15CZ5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62602de7-f40e-4395-b1bf-08db0f2e5de0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 08:26:42.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsRAcgUOy4Tc4eFTLzA6Hy8AV+8NUhF+tzK3Zb6x/j9AIcryH7ITRZtvZcq3hrePl0eTf5zUJy5uf0KXyPZlAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5187
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/14/2023 10:56 PM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Tue, 14 Feb 2023 15:41:35 +0200
>
>> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
>> vxlan header according to gbp flags.
> (not sure if it's okay to write abbreviations with non-capital)
Don't sure either but most of the functions in vxlan (if not all) are 
declared in this way.
>
>> Change-Id: I10d8dd31d6048e1fcd08cd76ee3bcd3029053552
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> Besides the nit above:
>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>
>> ---
>>   drivers/net/vxlan/vxlan_core.c | 20 --------------------
>>   include/net/vxlan.h            | 20 ++++++++++++++++++++
>>   2 files changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
>> index b1b179effe2a..bd44467a5a39 100644
>> --- a/drivers/net/vxlan/vxlan_core.c
>> +++ b/drivers/net/vxlan/vxlan_core.c
>> @@ -2140,26 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
>>        return false;
>>   }
>>
>> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
>> -                             struct vxlan_metadata *md)
>> -{
>> -     struct vxlanhdr_gbp *gbp;
>> -
>> -     if (!md->gbp)
>> -             return;
>> -
>> -     gbp = (struct vxlanhdr_gbp *)vxh;
>> -     vxh->vx_flags |= VXLAN_HF_GBP;
>> -
>> -     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>> -             gbp->dont_learn = 1;
>> -
>> -     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>> -             gbp->policy_applied = 1;
>> -
>> -     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>> -}
>> -
>>   static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
>>                               __be16 protocol)
>>   {
>> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
>> index bca5b01af247..08bc762a7e94 100644
>> --- a/include/net/vxlan.h
>> +++ b/include/net/vxlan.h
>> @@ -566,4 +566,24 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
>>        return true;
>>   }
>>
>> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
>> +                                    struct vxlan_metadata *md)
>> +{
>> +     struct vxlanhdr_gbp *gbp;
>> +
>> +     if (!md->gbp)
>> +             return;
>> +
>> +     gbp = (struct vxlanhdr_gbp *)vxh;
>> +     vxh->vx_flags |= VXLAN_HF_GBP;
>> +
>> +     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>> +             gbp->dont_learn = 1;
>> +
>> +     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>> +             gbp->policy_applied = 1;
>> +
>> +     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>> +}
>> +
>>   #endif
> Thanks,
> Olek
