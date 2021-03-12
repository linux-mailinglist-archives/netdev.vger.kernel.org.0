Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534B933953B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhCLRlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:41:09 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:22880
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232176AbhCLRk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:40:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMGW1ilXuz7ABo/BlYkOpXziWeV4KEf4PHaKn/gxtCKrxCREY3+98JXphxT1YGAaeT7I6FUzgY2grIfVzg8e08+MVhvVkyCgVda1HG3v82Unm+BBUfCtT+sdIrRf06kDkVBrsCrXkQP0RDlVK80vod7a1t+X997SjI3rWpcuu0Zk1YOHzQVesJmGLNieGSd7o6OCn0+bQb6o6Z8O+S8LamW8qyzNU3Zzy7IPZFSe6N0GMI4NA/Z/8MLj3MjJfIh5E63gylmKzWGttMrSatzPL6LH8TxdzF49FwujzcUI552TCwvA3VdhZwtJluwXRUyjtJZS62mdNZl++B/1Z0cSuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rSUuChomcGF24ZceDodFmDEfMlZ+sMyBz0cAWDsSDg=;
 b=YQr4oDOMa09ZpxfylR8H+GJR2ynXxthgg3H33nHeV05rNJEzpKy5R6SK1kj7bGimTBMOMWPQ1gO/EM0nIgobF0MM1yPLb1tppbd4kTYYH9DVWJQqaUb9f4yfTj4cligal6QfkbEuIYKSNggZk9QMQJtfX6H9MmWLNwTKsMdY7P7hbtdrx53oW6Col6aZqxxeQP5BpkTDJIwbezeKADKLHh+T2lmP3iz38xvhheLNOLaJdFAm0Mwu0UtH5hUMpvDobUwZDMkMgCjVfzHTOru12HIfJNZcRF+/9zdN+BiuH0tUm8SwAu1BZspfBBOBSoru9c/jkE1TAYBSY2T7AOnJTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rSUuChomcGF24ZceDodFmDEfMlZ+sMyBz0cAWDsSDg=;
 b=GXfWcFAi08ckw02C2aSH8VcJ2ecYvYMZCf/dEGW9mGG/7GlSGxtAc8ptN6H6HkC4KNQ5JFBGxqaAM7FRfZRk1cmQ8+ulJLRyoO3yBFR3JP/c+QeLJk15mPQ6VQzjlbEUJ2Trkc2ZpeX265jMgZsz1rTaRW62vYvaUABguOIrwmQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com (2603:10a6:208:11d::20)
 by AM0PR04MB6465.eurprd04.prod.outlook.com (2603:10a6:208:16e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 17:40:56 +0000
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::28bf:1b64:a9fb:b7b2]) by AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::28bf:1b64:a9fb:b7b2%3]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 17:40:56 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
Subject: Offload taprio qdisc issue with concurrent best-effort traffic
To:     netdev@vger.kernel.org
Message-ID: <ace06e91-ddd5-1bf4-5845-6ab8ae4e8f55@oss.nxp.com>
Date:   Fri, 12 Mar 2021 18:40:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.210.25.135]
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To AM0PR04MB5572.eurprd04.prod.outlook.com (2603:10a6:208:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.18.88] (109.210.25.135) by FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Fri, 12 Mar 2021 17:40:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e32f91b7-1a30-4f65-b657-08d8e57dfd19
X-MS-TrafficTypeDiagnostic: AM0PR04MB6465:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64659A55B680E75B1BBB2874D26F9@AM0PR04MB6465.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euvlCdpcVa22pFv4dSHHeHu4Yso6q/afjBS4gtDaWrUg0D+ODX265tpGFub5k/EY+cIX9ijO8G+jtMv0KUR/zPgHnykDXP7av+08yibL+vB1sf4r2IO4LFbvL3cxChIz0JQyMCYrUGF0IV4oCtOx9RXgKl4jqFCuKNrW6eS7SdwW/KqxZCcguscwpiuU0Xo7Ydg1pC17JOg3II9UsC0VdmspWKhSCpRvcgTlOrtAC8BTi6w5X1ZRWkRLn/M4ffJu7AHEkU+k9ijYfobflEfSV7vWAdA1Kg8RitItxp5QKoFMya62/Sq6YjDKD0iP/vds2mNPpiTXuqh1HHHVN9JAeRS8OsMgzMUZeKyX8gbgLoLYeFKHWQhHy7y8iHVybFa9yilKXCoyp37C3yWLcGPW+dT45t/D0MIZTH8BfrUM3imnwh8Lwgc/ZPWANmxWgnKC8ZDr6PIOwto2uSllgtn075OYJeXRChXBbgQpzP4PQpp103Toq5mxv4NkRcb3KBiZwrUNBqju299QxEA6dyFSMnt7l3ZKpoZE4E55GfERg30tRrrfyxQODEDMbAoY7Ur+OBaqm9DYn+OaMKy4pp18eu2TM2E1bicyr6TtWclt0oonJddZszQrGxvaHxIDlWE4qpjxQ6OxRHlMa1nMtoIDJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5572.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(478600001)(31686004)(8676002)(8936002)(83380400001)(31696002)(86362001)(2906002)(16526019)(186003)(52116002)(26005)(6486002)(44832011)(6916009)(66476007)(66556008)(316002)(16576012)(5660300002)(2616005)(956004)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1NZRWJzYlFuKzg3NHpvQzBJOUQ5NDlLcjQ2UUkzSHJuTUpkV2FjNS81bWM4?=
 =?utf-8?B?aEtHMEdPR2k0a09UbWNMOTFpNzdFYjZ2NWhOb0gwcXAwU0o4dFloN0NML3Y5?=
 =?utf-8?B?YklvcEJLK0VyYkhtc0NoMjU2ekV4aWUrei9obGRKVUQ5WGo2YnVoZDBXTWNY?=
 =?utf-8?B?SzlrL2ZLbXFNeFpsZ0JydCttUVpaWGpvbjh1OThCd2RNMmJVMXFPWkJ4Qmpj?=
 =?utf-8?B?b211aHkvRWw3WlBmNW9Mb2lTdGxyd3hSZ3BBbXFGbjBVWFpJOVpnWjdjQUVG?=
 =?utf-8?B?VUI2STVHV3JoOGlxUWNHMXAwNU9NbUkvQzBHN0NRUG1NUDNmK1VZTi9aKzRa?=
 =?utf-8?B?bTdXc0o1Qi9sb1lNU1pvYkFHZzhjMjJyN3lJM3VIY01JMnpXbFZuT2JYdzlh?=
 =?utf-8?B?dCtxNU5ObmhNV28yRzBRYkV3NWsyUWFuRE9BSkwyb2graDJxbG1XdW56U21j?=
 =?utf-8?B?UWdZSTJJL0dZdWlVRzl2cW9PUlgxSmhXaXlOczBSUGhDVU51NUx3cXlRNlpK?=
 =?utf-8?B?V0gwNlBrcnB0eFA0L3MwdWEzWkpOM0VPYXh0WDViRWg0TUJ3dUlvVk9uUzlE?=
 =?utf-8?B?ZExoY0lqRVpuNTI4a3JxMmd1ZkpVOHBDNWo0c3R0N1hQZkhsRXlzaTU2ZWVh?=
 =?utf-8?B?eVR1VmZVRDlKc1E2YUx6T2FwTU4rS2F3MjliZ0IvQStOS09KS2ZYY2RHR25M?=
 =?utf-8?B?K2NVeHo5MFN2WWlVRVVRMU5nelRPbDFDT3NpV0l6UklrWDdLYVBQRXBTWmww?=
 =?utf-8?B?QzVEL3RYRWYzcURVaXFwUk5DT2dKTVZDTzhPYjVzcDJUTmFTQmZ4MnZ4eDRo?=
 =?utf-8?B?Si9qc1M4Y0tFaFRncWdXaFV0a3lwcFpZTzZEdytsVkdUT0dBYmxKanlrbFha?=
 =?utf-8?B?NytYR1Jvb0xEYW94RWYzQWZwZ09NNzdTK0hlWkp5Mm84eVBJa1Y1aDFBbksw?=
 =?utf-8?B?MWtVbjJhQ3hUZGdWQXJzNHRSLzdKU1l4UTZGemh5T1plL1MrcVBTK2dxY1JH?=
 =?utf-8?B?SnA4dEhBNERiVEdKcjlqYWl6WGNrUjM2M0Zzd3JnaEk3RW91OXErdjY2VGgv?=
 =?utf-8?B?dGFMVTdtU3YyMFlXYWJpMkVmUVlHUlIxRUdDS2orS3I3VG9WNkR0Q1pNZ3A5?=
 =?utf-8?B?NU9ic1NUdElnVzFCTS9uUFhRSWF2OHh0VjR3V2JSSWRHMmJmcTBLTld0eE9B?=
 =?utf-8?B?UXQ3UjdFbVU5VkxGbzMwZG9TYnE1ZzkzeU14ODUyQXU5d2ZDWlFxcG9KaEIr?=
 =?utf-8?B?MldIY1hhSmhCTXVadkliMGJaQVJmc3dxYm9PNVhFYU9uemtLQVB3bDVzODQr?=
 =?utf-8?B?Tm8rVDBsQjJRNTVMQnh2MzV2NExyTjMvbHJwcFlrTk14UXVHUUNNTTFoOEJE?=
 =?utf-8?B?d2RzbzhOVzQzM0hHdGVOa3NtM1prT2g1dG1EWlUxcEc3K2lMMUtOa2J2S2ZF?=
 =?utf-8?B?b2JDU3JOMHhSR0g0RWdpbTZGQ2tUQWRCb0FTaWx6d0R4RkdXWHIrNDkxS1hQ?=
 =?utf-8?B?NUdndXdTK0UyZy9hWk1Mc1l4azVnT1ZudGJ3OGhwYjk4S2dUcXJGWmN6Wmhm?=
 =?utf-8?B?enBLNjhubUxTYkVQM25hcVVmYVYyeXM2bVFjMmJmUE9Zam83blVGVXU4bmpz?=
 =?utf-8?B?RVBrL08vZzFzcHJqWnZOUG9xc0l4cnVuL2FTVXZHVi9QMEhKUWlGS08xWHdy?=
 =?utf-8?B?Zks0amRUK0hoRXYvNDFlQVYzTDB3UzlxUW5ENWl5UEVja1pLaXFWVllPaEMw?=
 =?utf-8?Q?4Xx6IX7DILNLXS54O7RXmSYhYmMEHdKUS92omKv?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32f91b7-1a30-4f65-b657-08d8e57dfd19
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5572.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:40:55.8945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTZ5S0PVRpPX35DhuUurkBRlZzQmZWiWOOy2w41CrUHbVN99ewj1StFNwKE3E4BmW6/xxNYvxqwfntXeiHjMbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

For multiqueue devices, the default mq configuration sets up a separate 
qdisc for each device queue. If I'm not mistaken, this is done in the 
mq_attach callback, by calling the dev_graft_qdisc function which 
initializes dev_queue->qdisc.

However, with the taprio qdisc, this is not done and all the queues 
point to that same taprio qdisc, even though each taprio "class" can 
still hold a qdisc of its own. This works and might even be required for 
no-offload taprio, but at least with offload taprio, it has an 
undesirable side effect: because the whole qdisc is run when a packet 
has to be sent, it allows packets in a best-effort class to be processed 
in the context and on the core running a high priority task. At that 
point, even though locking is per netdev_queue, the high priority task 
can end up blocked because the qdisc is waiting for the best-effort lock 
to be released by another core.

I have tried adding an attach callback for the taprio qdisc to make it 
behave the same as other multiqueue qdiscs, and it seems that my problem 
is solved. The latencies observed by my high priority task are back to 
normal, even with a lot of best-effort traffic being sent from the 
system at the same time.

Is my understanding of the problem correct, and is this the right way to 
fix it? I can prepare a patch in that case, but I wanted some initial 
feedback first as I don't think I've grasped all the details in the net 
scheduling code (if anything, I suspect my changes would break a 
non-offload taprio qdisc).

Thanks,
Yannick
