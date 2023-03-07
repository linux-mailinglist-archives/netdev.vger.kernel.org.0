Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4ED6ADA3A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCGJXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjCGJXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:23:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E57526B5;
        Tue,  7 Mar 2023 01:22:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRPgOHchQRsobcop4yLlifc+5+0dFaeIopJgznitXxzvAJZFTzAh9Y/GotU1lgf89JDcPULHxmQPGZv3haYk5eshd8GxN+Q/WbvTIvBstOADNOb6QoKQdTNHXaUDAJm7IT4/Nrx6V8XQmxBxwLMLkibsENcgmCOhSXlS3zKcwQPOFgexbJZ8ppUjXnWMwzB0ohsNfK6KVPQHr2EaaVpsO01EJofc2ZDsD8SoWqxcS0DBqXLPC9zy5tymowKRjKvS5RMsBcm0+yWA9ZH/eZApoESdF98DNQmHz0OAKI4p3W/7+PBU1eASyoE8kbvG4/dqemOXXntPU9wCtMq1QyHLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yuv4QRx2WbTPZQHi0acT+pA8X09wLJOEho3bqvKO3uU=;
 b=GnIlqbhKwjFayAG4QH1W8HtYucrqbG5y28gF+u5RTLvxDhYQZOiwBHjyHAseHZ6V5O+/zlrNoowFh5+MtGUBbtYfYcZNSYFtD11SjA5Gie9xFOBQgy6njhaG4/Z7/Q9EWMOKfjgDhDaHAj2C0rmUTmdeDVK0Wi5Uv7z0qGpF8d9r0zQXkQA4jHbghiWxy67tb1MTWaHQc7BsxCr7R5qi3sDQMjdX7TYEauxIMMd4dFb2gDVQpTXrDy8bFil/1mvKew/djxy1LiuRvcKasIWJWm67GjOO91Zy0p4eVDtqSRjWrJegWBIeyc5nRp77Ez/4rtqS65jR2ugLh/naOryadA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yuv4QRx2WbTPZQHi0acT+pA8X09wLJOEho3bqvKO3uU=;
 b=WeiphRs+LL4opSheXetbgRzWc/wBW4jFKEaGJ9T8geHpvnl6kpRHiSasx8yQqsNme2m6QyF3wsYquLd20BnfSrvwsAM9V89RAj3lwT5wPyC4Be3qymgp0fMGcqr72tEAR1kz+ELOgoOM82l/5TYI36tWJIa/otTpWUaUD+baKPQaEyqY3r+c20Zlz0tbADpGJMQfrY93KqBUGZAg/6j5MYowOS8wVADcnU+wEQYWmy/es/VvmYG0LY1n+91MftvFvItT1Zs9wte7IZDodNubDDHmssg0MKasv/mEg7I1E3N+tiJhTJNg8R2kljfrBoMpYyWe+ox0wFErBxOiV30FEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 09:22:51 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 09:22:51 +0000
Message-ID: <22501426-2271-2f54-a80e-920ad5461d4f@nvidia.com>
Date:   Tue, 7 Mar 2023 17:22:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 4/4] net/mlx5e: TC, Add support for
 VxLAN GBP encap/decap flows offload
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <20230306030302.224414-5-gavinl@nvidia.com> <ZAYBbP8HCXf/DHdn@corigine.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <ZAYBbP8HCXf/DHdn@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0007.apcprd04.prod.outlook.com
 (2603:1096:820:f::12) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: d2cc81d2-b7bd-46a3-763b-08db1eed8691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+X5/ttAzwZwwQ8W7kWoz3gX5/lc+kuW07lqHhoIIu7B2O9I2bOsRMwiPntNE5UmAGJmIRkOfAr7bG72Q9hh+nNZdMCrpjKN8gAp8oXQINGJzdYiKYKdqor5rZNAM3zvNKL+qL9Yr31z7b9fBWj63XNXC/QIgOIm8/CAGpUAjDgoRT8gXhu4/soaEDIGY+gzi6sKH8H6H63+SZI2eQHDBVX/X5Zs7RqyP4KK+csYpmds3mHabYk2U2J7bMR0Fa48piL2vAFc6knKtL+uZGRRKOEmBmNtQ2u7ZeI3aA0Rub8R+LxDVc5+WZWDmt6+asy8NAGMa1N4EYrHLo6tzTEZfrrdyD37KWdAioaVNo8HSKczMB7x9vyj8hFbRKFXURtB1PuJ0IUkd9Co/rJQgMXyEQz4jxKEQRNhNMvwUbeR259a1nZpi0RRLQe9y3zb8aG0ml7HshnG+vSRuh8cMfED0VxtU4dxFhGuewp4hDg31EzXFpbSx1ixIlCp2GYFjxigBqPZrJxQIxSJd5dT5SrhQi4bWAr3KssLy/U7/9ho3s36XIwrb7KWEWKYhy/Yv25vL4JM5clJ5LrxQygBKkcIS6u6Ne1Q/NmAZiJNyqYFDu21eW+hHcnGOtFr68GVWBi2mzAyJ4USoQLMYdJ9/AfUi1JcrWMQrc807eZK0Lsx4G1u+cHaVVMTj8ZAsf7iFQZxPy/8uIfH9o5b7asxGYEYG2Q5zXRVRyAwVv2ZUnfo/tQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(41300700001)(66946007)(2616005)(53546011)(6512007)(6506007)(26005)(186003)(38100700002)(316002)(31696002)(478600001)(4326008)(8676002)(66556008)(6916009)(66476007)(36756003)(6666004)(86362001)(6486002)(107886003)(2906002)(31686004)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUZhNEQyVERTczM4em1CZitmd3VtdW1VdmFOVUF4Y2hXbkpPbHN6VkNXV05Y?=
 =?utf-8?B?a1h1Qi8zUTR0djZkeTdhMFo3bU1oRlA1bzFLNXJNMUJtNGdqSWVFK2Y1SHRs?=
 =?utf-8?B?SytlWmxVQUpWZXJXSEdRKzduSndsS3ZqUThCU1B4OFNIZFZ6SFNMVkdYdzM0?=
 =?utf-8?B?UmcvRmdKNVBTbEYzdFJ3QndFMWpyclRuQUl2YnZyenFQbDF4NFJyaWM1djRz?=
 =?utf-8?B?Q3REVTM1WGRUSjVsZzF6MnE5Ync2N0lRVmc5SWo2QUljM0VPekU1TjlHS2Ir?=
 =?utf-8?B?ZlljN1lYYy83eldqb3dMMkdvVXNqUWQ4OG9jc254VmxyYmNaUUxNeHAxcGtG?=
 =?utf-8?B?NXV5ZjFOZnV4WjJveWUxRWRqMzY0ZWRuSXhzSWdRTVFsVmxtOG5iU0M1eWFL?=
 =?utf-8?B?YTMrc1k5bXoxaU5oWHcwSnlSdmR6dDFFTG1VREplMFU4UnJEQ3k5R2hodkg1?=
 =?utf-8?B?eXJ3YWF5RCtTVUR1cmJkUGtBTU5JMzdCMlYvS1FnTDBlYVhha2VFZjJBdDUr?=
 =?utf-8?B?TVFVK3lLTitDYklHVGc2N2Q4Tkh4TnM4OEF1bmo3UzdFZGNUVDhxWUVpRlMx?=
 =?utf-8?B?b1IvQTZMV2Z3QlZtWDZrV1E5WTdtZHY0dDVwNUV2U3cvMmtwMmJwOXp4MlNN?=
 =?utf-8?B?eElIL0hua21zNnd4TGFVVWt0enlDQkxhRGRzM09Wd3B3L1JocU90RnRXMGtj?=
 =?utf-8?B?QjJBYWFWMWoyRjdwdm1rMU5OVVhudWJJZkJpMGFrNDFzanNkL21JV3FFRk94?=
 =?utf-8?B?bFdrU0NFeWhUdDFkTkNWK1JRSzcraitIdWVRcGxEeVRJdjkvZUZpeFdxMVAv?=
 =?utf-8?B?M25EdlRadGNuT25Mb3lBblBHMDRPaW1IcWRxd1pEMUI0QmVZMUJjRTBNSjJ0?=
 =?utf-8?B?RFBZaGNkTitJajBIazFNaFQ4cTNFZXRBYU85cWtLbVlwWEVoT29aWXJPQllv?=
 =?utf-8?B?d05PcmxKSlVlbVNDa0NudkVoU0UzRGRLMUhqM1d3Ti9qQmZPTHRhWisydWJP?=
 =?utf-8?B?ZTVrMnY5em9hTTFxTU1ZT1ZudDNOWks1QUlGckRsSjVkcmRjbEJEdVJ5NnZZ?=
 =?utf-8?B?UUNpdGtpM0xrL3JPdlpNVXFGK2lOL2JHa1lNdHdxeTViQzVhRVJJeFJ5WkZ5?=
 =?utf-8?B?bi9OcTJXSmlZMC9qaklNSnVucUJxZG53V1h1cXRJVldIekJKNW40VHM2UHBN?=
 =?utf-8?B?TEcyWDcwQXJzaUl2VFFHc0k2WVRsRGpFTUw3ek9YVFJ5LzEwTlFibVkvaERQ?=
 =?utf-8?B?MWtEWWJVK0djRkRYZDZaNy9TUEVRcWF1MmtOWDVGSmZVQSs4b3lSelpSeXZ5?=
 =?utf-8?B?Z28rOGg0RGxTeUVSaEV1VG9qZGErSjJ0czBjNWJ1Yk9tbzlMckhhL01qMUJX?=
 =?utf-8?B?KzZ1RnZpLzlRZG5PN2E2VDZsSkQxVHUxQjVlYThYTnB2NGxqNEdyaW81N2dz?=
 =?utf-8?B?SFFaVExEaU1zMkF2Z1YvNEFLcDFsWWUrT1J5Z2lhYkdBemFiRUp1ck8xVHdQ?=
 =?utf-8?B?T1Y0WjFaY283WWMxZVIyUk9QSHRidUlZK0cwY2lIZyt5NkxxR0dBWktac25I?=
 =?utf-8?B?czcxOTRPcEJTcG1GV3pGTGdTSEtoZWNBM2srblZEWHNmaS9TUlorVWdBUWNp?=
 =?utf-8?B?MWhaYXJ4TEFhbi9pNXcyY0x6VVlGRjRzSktHV1oraDUzUnlmNFk2Q1VNTW01?=
 =?utf-8?B?NVhkMTg4VlJLSjRHbDkrWGU5cEQzSld2TWk5SGhERTR6TWFNZkJxd21rRkFU?=
 =?utf-8?B?MmhlVlFnSmI1V2FZOFM5UlRFUXRWS0gvdjJXVWRWSXFpN0pjUkVWNlhaMEVM?=
 =?utf-8?B?RlF5OXg5RmFFcE1UZGx2cVB0SGludVZOc3BPL1Z0QXEyMnlTekNWZXg2Rzhi?=
 =?utf-8?B?VWpVSENNY0grNE1EeFEyVU5QSnJZOUlxWXRoMW9sRXFsMHB0Z2I3N1d4NVYw?=
 =?utf-8?B?d045MzJyc284TXBXNGVybzhNYTAzUEU3SWVjckhXWG1GQkdXQWNSZVJwNWRh?=
 =?utf-8?B?SnJPbTJ3ampuS01sZFF4S3I0ZXZWVmg5SmFCcW9Qby84Nkk0bXkvVXpLaStB?=
 =?utf-8?B?RG1BMytTN1hCY1Y1YURaQnpGK29DNHdqbDFiOUdaaGYvbUxtN0tBdGxvcFVj?=
 =?utf-8?Q?OZyesH7OxMKAuGTVX4b5DJOC3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2cc81d2-b7bd-46a3-763b-08db1eed8691
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 09:22:51.8069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0R7pqz4OkghonnMJQER+i3Ch3oWRq5y2iIRJ+Nup3uDR7c4eQx0QHPXXcn38TpKRvT91MH6WQEjtO3Mu/7l2/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/6/2023 11:06 PM, Simon Horman wrote:
> External email: Use caution opening links or attachments
>
>
> On Mon, Mar 06, 2023 at 05:03:02AM +0200, Gavin Li wrote:
>> Add HW offloading support for TC flows with VxLAN GBP encap/decap.
>>
>> Example of encap rule:
>> tc filter add dev eth0 protocol ip ingress flower \
>>      action tunnel_key set id 42 vxlan_opts 512 \
>>      action mirred egress redirect dev vxlan1
>>
>> Example of decap rule:
>> tc filter add dev vxlan1 protocol ip ingress flower \
>>      enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
>>      action tunnel_key unset action mirred egress redirect dev eth0
>>
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> FWIIW, I did provide a Reviewed-by tag for the other patches in this
> series, but I don't believe I did for this patch..
ACK. Will remove in V5
