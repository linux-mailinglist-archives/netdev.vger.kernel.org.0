Return-Path: <netdev+bounces-4797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8049C70E5E5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 21:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4290E2812D0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5879A21CEC;
	Tue, 23 May 2023 19:44:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413731F934
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 19:44:35 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844DD11D;
	Tue, 23 May 2023 12:44:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaOIYLMO1hkrGmaVzbKKjwnB5SlTGBehk5afNeuUP4O/htboFNnOO4WFLYxkapcPutfWoQZvBl/2RRWwXpxYyNPmp1ei344tpsghcWuvpC665y7lORqGLh7swk72oi5hvn34Jge+lv6CjgEII1wxZspqI0lpvAjtshhZNDnBJ0ZHfNaRV4Ly9ipDOn2NzS0teouWvUnSrYDf+gg65QdXjrYfp8ag4m+rAsWk55J1cp9ywGGwkE3PWpAun8LZM3SXWWL6IjXEjWycmz6q9nrUuYg1uKAz+JwUU3eHlpCDO6L2h5EVNoNh9lL6ZnOvMPzvsWPuG4M4ip8gh+BGZ+gitQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJuILywPI2p7Xvrz7IUeiTM3adpzC/i4xS68kBo5TLo=;
 b=LATOdYOW9ND2yFTESWnTUOthmKvvC71vx/avstoDptnlApszyrusSBp7BY8IOswENcXHmSnUiBlMZyQGySkA4TcWWb6L1z7lBFZp4LQBWNjOlr4w1zol7KPw7FbKdCHotCLG6d6cG6dH508T/iWN/CoMWBtOHQDDguBX//ooaIrwQfE89U3Zge6Xe7dy5DAqMu7wJF8t8vFwLvGKjYMeyrzvSEsEva8JijYXHXsP09LkFLmGsoEy0JnqpiIlc5nw3h1vPpMwA+v8sYIpYgh9Eg43FkW+dKTuP3tQ6BWLUrZKNtYZ+hv3ljhOVLAMVsf1PS7oAq4kT+c9ZiH+ifyBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM8PR01MB7068.prod.exchangelabs.com (2603:10b6:8:1d::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 19:44:28 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b%7]) with mapi id 15.20.6411.027; Tue, 23 May 2023
 19:44:27 +0000
Message-ID: <95eebf9d-3889-e639-68af-e01d7cfbf77f@talpey.com>
Date: Tue, 23 May 2023 15:44:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Content-Language: en-US
To: Chuck Lever III <chuck.lever@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Chuck Lever <cel@kernel.org>, Netdev <netdev@vger.kernel.org>,
 linux-rdma <linux-rdma@vger.kernel.org>, Bernard Metzler <BMT@zurich.ibm.com>
References: <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca> <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0029.prod.exchangelabs.com
 (2603:10b6:207:18::42) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM8PR01MB7068:EE_
X-MS-Office365-Filtering-Correlation-Id: e280b708-b5da-4d56-e597-08db5bc61e64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZSQW4sG//7C74wzogziTkRTIT/sHUNLCG41v0Ump5zUJn/ZNIfrSvU8MEbRILZh3rclG6fuMK2btCNjP0ZoO9m8zyHJ86TgvHZp2uUdHiDILjLZVMC6zR7DS7irImBQGfdyDkSmi5wAlkdTTsxg/HyBDDSLuWeis/jONAOdgKwGS4HOOo0G/IslKAvvpVrWd8wfRwsiVs7D30TkTrU0VHX0zdNKSWJ6nWJiCs51NnyvcX1Qq+qhtpjnEI2gHnLzMIiz3sM3llV9HMA74oN7944qvFuMF1+cZo0pchE7mriALNNZADA7NoygsyVuXnt9H8cGQ7R0ZbgVQgT9AvOLcVFA+3d6jEULLI6CiKdidZjzLqw1+AnvdqLFDxrcoHyDPxNPwB2tb2hplQEmV9njoH/WMrtWnqI5TEUhPQBsk1VQlibXp+28Q8wvXwJbN1NcbGYsu4DFu7edS0kCl0FfbMDsnMzTjvQ/i323SfKJAhHU2zacJccp0b0dA3kK4/4HXHqraK4rSCs/VsoqZVfVUT/5EmGpxyvsLrJuGGcqgiy3tldgEqKpxvNyqB3+b9PzeGaQOBb/mXpiUOiR7+hfcWvLozbEUt3jxXjZDNR6p/Hq8kmVUVvmIyYJzCGsuvX48rjTfygnHVidBJl2ZY9/qQg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39830400003)(346002)(136003)(376002)(396003)(451199021)(8676002)(8936002)(5660300002)(186003)(26005)(6512007)(6506007)(41300700001)(53546011)(31686004)(38350700002)(38100700002)(110136005)(54906003)(31696002)(478600001)(86362001)(66946007)(66556008)(66476007)(316002)(4326008)(36756003)(52116002)(2906002)(6486002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0V2SjJLeUhWT0RSUW5qY2Y1ZXFvS0lXejY5QUJGRHcxOGJhaXVNYTVvNHhH?=
 =?utf-8?B?cFAyeEpYc2Y3eVd1QnRvSG9sS25ydzVCMlo0OUQzUU1GYjdQSTlOOUV6UEpC?=
 =?utf-8?B?aHBudU03SCtzZW52SXFmdXdtdUN1RzFITUk4NDRYNTVjOGx4anhnbU8ydjhV?=
 =?utf-8?B?ZkZHYmhZNzVKS1RhNWx4MjA1K3BRNmVMc081akVsVnlwcjdVcnNuUCsxcjZF?=
 =?utf-8?B?Q05NZHh1eEtPMkwvdXVJOW5PRXdKdFBrc2ttY2lMMDZKTjdkbzFpQ290RSsz?=
 =?utf-8?B?bjJyL2RDSENNTExFL1ZaMHVQb3FkaGk4czZ5eGRVSWdRbWpqU0t5TXpvMVJ6?=
 =?utf-8?B?TWtxd3RzRGNIdmxHc2JZUC9DRk5nNXVUUy9TeHY5cVlxS2ZKeENEbDNCOTVt?=
 =?utf-8?B?YXhjNGpOb0ErU1hBbk8xTzB3UXZGSU5QVTFickZWYVFLYlpic1JQQVhOdXBH?=
 =?utf-8?B?dVFDS2dQaUx0bVFFRThMR3ZORjA2RnBZdUJDdy9jOTdVSGNGWXVGQ1RlekFs?=
 =?utf-8?B?M2xRMEtKVEI1NXBQTWdyUUI1UEdIZGFTV2xLeUVvWGdvYS9pREpuZ05uUTNq?=
 =?utf-8?B?T0F0K09OKzUyMVQzN2piUlV3djVKK3VHcWxtR3pFK1AzUFNtQjVWU085ZWxD?=
 =?utf-8?B?N1J1NEJ6VDVnMlpFS3oyVkxJemNBMTh2ellER09HVEViTmhVbUg3V3ZrZUdp?=
 =?utf-8?B?azJja3htdlpHcWVXcTNFa0dRWCtqRzRCcVIrdkJubkg3bTBCc0NEak5jd1N6?=
 =?utf-8?B?eWV0enNZLzZrTlMwZHNqKytzK0t4dm9LVUxxdkpXOTZZcEUzaE1YQzQ4UTht?=
 =?utf-8?B?bXViVWZBWmdhenRNYmpwb0oyRWZJT1lwYjJwbmxHYXg4blQzMTZ2N3c4Zkpp?=
 =?utf-8?B?REl1M0ozL3VPUEpBZFdjWExlQWJxa0RiRGhxZjEvZFdBekpQYk9ERkp4cS8w?=
 =?utf-8?B?SEZ5M0JidDFMRlNXblQ1Q3dnQU9PcVFESGZobHhaWHpnWWJ5TmQrNkNLK0Fv?=
 =?utf-8?B?ZFVUSzRSSUZIR2swR213c1V0bGVFczdEcnpESDc5b0JwVnkydVRnRkIvVXNh?=
 =?utf-8?B?SndsWTcyWm9JM1RsZlAraXk0OWRjU3ZmYkN2eW9sTUd5K0tlYUp1QUVGT3NE?=
 =?utf-8?B?cUNod21zVUx5cDd6VWg0UWdQQmN2MkVhbVBXMG8yS29RL1R5VjljdHZPcGF6?=
 =?utf-8?B?UTNGNHNxRGdSMmZ1aWtlYlAvbjVYc0VBMTVkeVZxbTBxVGg0RUtQSGg0UlBt?=
 =?utf-8?B?N3lVa1BEc3hSdVhrd2dHemRnUkVPUzZhOFkrbHNxemorQ2hBUWIrUlE5S2tQ?=
 =?utf-8?B?UUtQN2xPREg1QkJRTWpwRWJUdk0xMnFOc1RMUFRvUjJnVEFySjZ3ZXNnallS?=
 =?utf-8?B?aHp0SGcyNWw0VklLaHZSa3h3MUJueE5ZRTRDWXhCM05ValZyb05JRmtBWGVD?=
 =?utf-8?B?L0ZWUTluUVhSVU1vMmQzUUI0WEhPTW1YZDVabDREaWFYKzdmZ1F2K1JaQytX?=
 =?utf-8?B?SFNPNHl4QU12Znd4dkFyblpRblNCdkRYa3NIdjIvYzg3SjhaMitnMFF2VFJF?=
 =?utf-8?B?VFN2Y0xBZHg1V1VCQXdTMm94elhHNDkvNGtLUmZSa3pzNE5IdUpwbmxhUGVO?=
 =?utf-8?B?ZzR2bHZWUGZCa2tvQmxIOTBmMDZPd0NBL1hHbm4yMkc4TmVxQkZYRTJZYndT?=
 =?utf-8?B?OXg1V0wyT1RlMjZYOFhsMnFsdFBmdE00aUNGVm1IcHgxOU1xTVBrdFNkTURK?=
 =?utf-8?B?WUFMeVEwcG5aOFNzUmJvcHZlQWtFbllOVTMwOThTV3VqVlhGcFFpcW5CbklB?=
 =?utf-8?B?WFRSSkdWNE9BeFdKUVZ0Njg3cWVZTW1naWRmY3I0V2ZtMTYxSTlDVGNNWnpw?=
 =?utf-8?B?RkszR29obSs0ZzFpcXloREpIbndFcWh0Q08zZVJ0Z2JTcmVOSWY0NS9rd3FJ?=
 =?utf-8?B?S0lHaDV0WGt4Ti81TEVUZHVhckNsZWVZa3VhQ1FpcVF1elJKMG1IRjZNcjh2?=
 =?utf-8?B?dHBjMXZqNGhDTU5zNzBUb0FualV2VlVGWUhyWHg4eVZhK2szUlRhdWtRb0kv?=
 =?utf-8?B?aUtnZE5WU3d6VE80VUMzcFZqSll0LzdHRW9JdEF3UkVLNEZPditENXhzQ1J4?=
 =?utf-8?Q?FD/mE7w0f5jqJH4nKUp5YDQzy?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e280b708-b5da-4d56-e597-08db5bc61e64
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 19:44:27.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAvziwqo4GCwwftN9VCHD+LVCsogHkHld032DpaulyIBBx+q6NQiFIc6TIFfa+xi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/23/2023 3:18 PM, Chuck Lever III wrote:
> 
>> On May 5, 2023, at 3:58 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>
>> On Fri, May 05, 2023 at 11:43:11AM -0400, Chuck Lever wrote:
>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>
>>> In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
>>> addresses. siw_device_create() would fall back to copying the
>>> device's name in those cases, because an all-zero MAC address breaks
>>> the RDMA core IP-to-device lookup mechanism.
>>
>> Why not just make up a dummy address in SIW? It shouldn't need to leak
>> out of it.. It is just some artifact of how the iWarp stuff has been
>> designed
> 
> So that approach is already being done in siw_device_create(),
> even though it is broken (the device name hasn't been initialized
> when the phony MAC is created, so it is all zeroes). I've fixed
> that and it still doesn't help.
> 
> siw cannot modify the underlying net_device to add a made-up
> MAC address.
> 
> The core address resolution code wants to find an L2 address
> for the egress device. The underlying ib_device, where a made-up
> GID might be stored, is not involved with address resolution
> AFAICT.
> 
> tun devices have no L2 address. Neither do loopback devices,
> but address resolution makes an exception for LOOPBACK devices
> by redirecting to a local physical Ethernet device.
> 
> Redirecting tun traffic to the local Ethernet device seems
> dodgy at best.
> 
> I wasn't sure that an L2 address was required for siw before,
> but now I'm pretty confident that it is required by our
> implementation.

Does rxe work over tunnels? Seems like it would have the same issue.

int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name)
{
...
         addrconf_addr_eui48((unsigned char *)&dev->node_guid,
                             rxe->ndev->dev_addr);

static struct siw_device *siw_device_create(struct net_device *netdev)
{
...
         addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
                                     netdev->dev_addr);

Tom.

