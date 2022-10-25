Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A9260C686
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiJYIei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiJYIeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:34:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF6D959B
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 01:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQ8hmFvU3+w4+vHw0UK5CYDWRlje6v3yqxD5xqxVVvCaNn2PKPjB1RGxx87e2ahJ0zAObV21BiCt4akOwKsghvEofeSfRJoOGG1d4xL/HNSKPff4+YQRG/gSidMlu2sJO3ge8HFomGZMWRPdPODnL3/Q6uu7dbiNFhZD42kmZ1aLLfAarThb4UZ+WIOYfvPjR8VSnuQKu2TYEhUxQ+EGuh0lszopuVoGUYO/1n6E1Hrmt+vs4zbB5RHOfc7j5QXSj6LtWAL/GmWSwvKRrQucxx+d4AG+rVRdp5NF53RB+tq8Z8xvnbdypv0QQ6+/R0QBTQDlikI+8DdcWRxIDokLhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdH9051buqqiPZ9BgxVZZzAFcz9xpXY4LIeJf0uI3V0=;
 b=E2HEeeOqSVQEh/7y71xMMc4aG2wUDapTPdcPUmgNN+EmaBha1NPFQVWQy5g6XJgfC7oUfpUZknLT9Fen1+wuAzLKq2RaeIZyEuQu0RNDDxx4ydCyForlk2z63d2FwYQ2PJh+2ZS1G3N2p50DOgeGW0cJEBKXxBMGFf42IV6mXeMxlM5tvFnA3ejLY3Wl54LfqZ2ESH9x70M+sutio8IetWvaJ0lNf5Sjdug8X4vToOcF5sIzicuBLnD+fkbe/Cl/ZRUgbOfaQI8/OW2yPl/lQ4Tta+eOGAwTNX6ifcawC0X/AwEy3YokBw0dO0y24ugP+UnrGDBFBUlUE5oGKVFYKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdH9051buqqiPZ9BgxVZZzAFcz9xpXY4LIeJf0uI3V0=;
 b=g+7wBrVJ9+THX3RSGkQlaT37mOCPAhAC6fhKCnptuBZSfV6QhUCmjf2ilGTXj1bL9V+qmLjdKv2/8MOjgXdxAqq4ly7zNMq+LllNSIgw5Sj81w68JpIN+0ZhyWQFA9FbluxB0U7zpxj7pMwYuVCIJrHj/74QPBPyt3xNJ7+Ud5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 08:34:27 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7%7]) with mapi id 15.20.5746.026; Tue, 25 Oct 2022
 08:34:27 +0000
Message-ID: <e9fcf40b-a2f1-d6fe-2a18-1d0aa1964540@amd.com>
Date:   Tue, 25 Oct 2022 01:34:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 1/5] ionic: replay VF attributes after fw crash
 recovery
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
References: <20221024101717.458-1-snelson@pensando.io>
 <20221024101717.458-2-snelson@pensando.io> <Y1aBL+jfY8uXS9Yx@unreal>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <Y1aBL+jfY8uXS9Yx@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:332::24) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 7843cddf-f183-428f-bd5c-08dab663baa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QVVuQ2F92hNNQ4JfgEQALd3EJMDQmjEjMXS9wyBBJiC9leQuTwBmsicAp3mOI4D8jnjgU93LVBORBnN2foN1S1UdZY8A9ywvvYMVLQFlEcbPbmcAZvQcuinUXWaIHm5OzatSbqfk2qAkx1usXY9yhKfgKLVn9EbfD6uORuVzILSqyBIz22RN9uWAqsYd6mRYMFkJE2wjx3MOnbCmrUMkhZu+trFX2OWbkQMOntst6l/Gz2GyQvx0gxYUOHv/DCYld1Y1FlVVC7o6oomYtC+Nm0u4TDoZKuJDGXvSTvUWyv+Z0TpGGSgsbQmo+Gedt7FRH4/CVaAgVmJIsaTF0snOrWF8OG/xFT9lxA/QdH16eJVgySwv6UCcBI3SxKAL4UuPetWBUC8yNxuCAxoqblJ3NmbHOCUvAnEXHydl1ZqoV6NttXHciBWGFxHcF0D1sUheCiYdLHdyGc7azCaMKsJGCCcNQALdV7XWX5+iC/mGGUDLz/LA5bjpexmrxZ07MuSRNoz06e2dmm+XoHqKutMFJ839FAzSWaKY3dAoOSEyc+cNYPNBkLSovv6So193vR3tMgCGVgGU/vu1PvOPfkfPZH3rH29XepYcJXlXhlJx0pfZF4d801TmbdOSj33MPhB1alW29/E5nc9u9SFVaGMHhspzz977/o4eUTQYOUqrJX9/l9kJORkjair39y2dLAc4U1z82r0O9CoW2lcPU7WoWrdI56+wB/HyeIty9KVPrITl0Ud15+5egvR6vufsXaOykzX/X9OSTufjE0pRU4Ra00YVkkvBUcLtkm//naOiVLQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(31686004)(36756003)(31696002)(4326008)(6486002)(8676002)(41300700001)(83380400001)(2616005)(186003)(53546011)(478600001)(38100700002)(2906002)(8936002)(316002)(5660300002)(66946007)(6512007)(26005)(6506007)(110136005)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWU1VmhhVGs0bUJSVWs1Z0VITlIwVHUxcUc2YXZ0N1NPUm5RWUdGUHRzMHFh?=
 =?utf-8?B?dnB3RUVDUlpKWktuRUs3dkY4S1MyRnE4Q1g5WnV6MjJUVFFhamFySm5SaDJJ?=
 =?utf-8?B?RHYwN082RXp0UjZ3T29pMW5rV2xkTXNRNCtyTUJOUHAwK1VsWGNDNnZDQm0y?=
 =?utf-8?B?bGh5QXkxa2w0cm93YTF3ZCs1RnB4c05GQjF3bDNwVzhlZ1lQUThJMjBzRFRw?=
 =?utf-8?B?NVJqSVZuQlI1VEIxeEZJcXF2OUNuZ0s3eGxrV0VjVVFubHFJUUNDSHVQUVFw?=
 =?utf-8?B?MGVHWUdyUzZmS1JiK2RnKzVYNENsY3BHa0lPQWQzT1VBOXlVNGRxMWlZMWtq?=
 =?utf-8?B?YXp6S1g5dUlzTkU3djJzQXgwQ0loc0ZnNlFoaUJlM1VFaTdHNVZFVng5ZUtE?=
 =?utf-8?B?alNmOHc4VXFhRkVGWlR1eUV2dlA1RGVsb052eXZSTEQ4VnJLcERHNmlWUnBl?=
 =?utf-8?B?NENJcmFoN1RUTGR3ektYZ2MzUnN2NG5FQnp3Zy92aHdKY1VqZXZBMG56d1JK?=
 =?utf-8?B?MlZNUFZoZjhwY3ZTdWh6Qnp3NmVjU1FjbmdzaDJwb0cxVHRCakhyVFVmQTRD?=
 =?utf-8?B?Z3YyaEJINjFtK3RydFNRMmNRR0NqNjhick4vU3M1YVE1Vm5POFJ3ZFA0SmlC?=
 =?utf-8?B?U2R2MEtDMm1XKzFxcmQ2K1dwYm5JdkJMR2hsaW03Q3hDZzdVRDc3MnovZUtr?=
 =?utf-8?B?WUZvTUtTdnN6UXZrNEpMQ0w0U0l3ZXpPMU44eisxK2JCQWdCQlBpWGM3ZmFu?=
 =?utf-8?B?aExTajNVRlI0WVBTbTh5UmFjN2hDZjRBUHZWVnVYanBYMDBUSmRBZ0gxMzRW?=
 =?utf-8?B?TFMxRS9WQm05SFhwcjJway9odlhQZnN2SGQ1NkZwWSs5Q2U0ODkwVWNGOVNm?=
 =?utf-8?B?R0pxdjFhWXNNVXRzWUhyK3libHc5bm9DMVptLzV3dFdqVE4yZXBaYWp5bmlN?=
 =?utf-8?B?bVlGc012UGdrdHNCT1N0dENsY2NLbWZYL0ZYaERnTGpHQ3c4RnRQWEdvQUI5?=
 =?utf-8?B?U1BlWUhVa2VrMHlXdjNhWnJWSXlwQVBGRWxWVGN3aXNsQjQrWXk3VWwrS1VM?=
 =?utf-8?B?WFVnQVc3d3B5c3I4ZVAyLzNPRW9QbDNLb213MHBnb3RjT3hnZUZvRXdhNHNV?=
 =?utf-8?B?blZRZ1lVckV1T1dUWXh4ckQ5WUZOZ25yNTVWelNUUmdkSWlDaEpDTXdtcVlI?=
 =?utf-8?B?QW1oS2ljTkdWRUhDUFRaTS8wbi9xUTd3Y205YUZvbHhHQSswWkRLUGE3bUdX?=
 =?utf-8?B?MmdHb0N2aEVGaGt1Vzk1dVdjeGxnbERwWHVUK1BHUjJVNDM3Sk0veWs4elVI?=
 =?utf-8?B?OENQYnRHYzdlbHhrNlpUdkJiZ2wyMUJKR1hweWhKRXhmL2ozUHlFUy9CU0Nq?=
 =?utf-8?B?RTVSTWJZQjNFMmxjTmRmZmpuQWJRKzRjUStCeGhYR09tVkUwQm5idXpySEFM?=
 =?utf-8?B?d052TXZDQWFGUnd0MlNIc09PbllaTVVTREY4WnJaWk91QUVUWGt1WFB2MTIv?=
 =?utf-8?B?ZEFYK0NENHY4enJjTyt0VkdDcXpSL2VybFR5U1NPb0RDb1hDdnFNRTJTbWhw?=
 =?utf-8?B?VW5jUWZOMkhqTGYzdG9DRmJESXN6dzc4UUxqMWcza1lYUzVSbnBPTmxIRWpD?=
 =?utf-8?B?Qi9BdlRjbzhaU2hsQWNFWnhpZFRBc2JidTdEemxLM0h0VEdrOTgvV1l6ZEpp?=
 =?utf-8?B?WTVsUG84RTVpZk5WR2t2czhqc21LN3JzSmx1VUJvNW5jaDdpV0EvOW1jVWNJ?=
 =?utf-8?B?cWkyWnRReEp5YnI1WWlIbUpvc3NRMW9uQjQ0UnViaTNrSWNPV1pzVXVQYjBL?=
 =?utf-8?B?VkdlZ3NSek5hY2lzQXdOYkZRaEdaamJ5Mmd5dktuMnpJT2h6UllNTDR3dVJ2?=
 =?utf-8?B?Yk1PVVBtL2JvbElTSS9TZlVuNWlXNGRndDR1anRRWEc4ODJ4R1VhZS81MmNx?=
 =?utf-8?B?RHM1a3dDVm9Ccm5wK2F0RkVSK1hpSkU3RDd1UEVKWXI3dCtuRUgwWHFOekF3?=
 =?utf-8?B?T3Fnb2t1cFpvTlN1bFQ1UVY2MVl1UVRKeWhuTnArMytWRDZnSEwzMVU0TnFw?=
 =?utf-8?B?Vm9JdWErRTROM0JHdTNjcDB0OE5ja1ZsTkowUkhPU3pCeFdLYjZaamcza1Bn?=
 =?utf-8?Q?AeOlNj+mZkI8bf+/TH6NiZCpP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7843cddf-f183-428f-bd5c-08dab663baa1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 08:34:27.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2T4yITGkzpmTFL4r2W2W/4s0lWZlom9MADZ2S72e1mYZ/X0+QIdr0HWZPvJziEDC1iGg++cmC3QiKilJaYbnTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 5:12 AM, Leon Romanovsky wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, Oct 24, 2022 at 03:17:13AM -0700, Shannon Nelson wrote:
>> The VF attributes that the user has set into the FW through
>> the PF can be lost over a FW crash recovery.  Much like we
>> already replay the PF mac/vlan filters, we now add a replay
>> in the recovery path to be sure the FW has the up-to-date
>> VF configurations.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 70 +++++++++++++++++++
>>   1 file changed, 70 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 19d4848df17d..5d593198ad72 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -2562,6 +2562,74 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
>>        return ret;
>>   }
>>
>> +static void ionic_vf_attr_replay(struct ionic_lif *lif)
>> +{
>> +     struct ionic_vf_setattr_cmd vfc = { 0 };
> 
> There is no need in 0 for {} installations.
> 
> <...>
> 
>> +                     (void)ionic_set_vf_config(ionic, i, &vfc);
> 
> No need to cast return type of function, it is not kernel style.
> 
> Thanks

Sure, I'll fix those up - thanks.
sln
