Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73064A6306
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiBARy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:54:26 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:64755
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230439AbiBARyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 12:54:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Egc1nF6IXvdN57iVYj8gJ8Hq9A118YPRpUv5ENnqxBovEv+cVmFWmziQi6DIENXKLdytFn0JjNedcybCCSQDQl2m4oYvJWJdaj7EYx4u2urqxnBFH0sPKO/N+cGtXBe8puo8Cv8Nd9VaoXdipY3oiGnaW1X/4DfjzNhAIpwPTWR2dcl1jDOx0ne7sAtKG8rW1rtl8WgY4vq92u8jRtowoV/RIoba4avbt6Kv4tfNCMUqqrxl3bMaUzbYaZ6S63MSy16vnpEfOGGEuqpdjMvmMEV+fja5ZIon6w0vTSu8HXs422F0rgr6+a1aYywddIwyB2K48ox6TAbdZ/LxxnVi0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMFJOlO+yRaKDU3TTKGakGub09Xj5hT9Pgd13gpkMXo=;
 b=dAkOIaWJzewbrBsPecfygFh+WR0yFZQ64GN2zwCNDqqtzhF3LAqc02EmDexHmkUnv0H6iVF6Xjw7HqmGAWZjL/+wi1l0qvIwkj1hvPrR7HPjsnXFqGiz5Unv8pv3Wjm5bNXOs2M9S8JeI0aHZFNKX8XXdNQHSelmKPwNNj9ISnjufFj8+SlslTzEXDOJ11zHCJE1Q9EjtDmX+2BIFR7w4GR+qBgT9x/Unv3+BLaqUgZA73oCtMod3tBivYJyPudd+L4N6qVHQcefja+PjinDt9X055/z/0vvDvJpkWwHJmi2GfcDMcP2fbE0E6gp72GFkzeJX3edPi2VPpBcyvkM8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMFJOlO+yRaKDU3TTKGakGub09Xj5hT9Pgd13gpkMXo=;
 b=X0FmmlowFGXL1vqNoQEv8HxwjDWEOMOywoj3XlhVzRyChW92sQCOqrwxQWbpaaw9d+ZSDMVYr023/vpXXQ/+jG3twZ+gteZtsgrptRGtty4wSnAXR89UsC5WS8C+kPQWN/GYW9yZwVioPm624zipF041tHP1CsLADbZ8PpRosQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DB7PR04MB4345.eurprd04.prod.outlook.com (2603:10a6:5:25::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Tue, 1 Feb
 2022 17:54:19 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:54:19 +0000
Message-ID: <8da4d928-d7a1-9239-4c11-957b108b0184@oss.nxp.com>
Date:   Tue, 1 Feb 2022 18:54:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] net: stmmac: optimize locking around PTP clock
 reads
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
References: <20220128170257.42094-1-yannick.vignon@oss.nxp.com>
 <20220131214200.168f3c60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
In-Reply-To: <20220131214200.168f3c60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::11) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35216a5f-7e7c-4e13-de33-08d9e5abded5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4345:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB43455A7998F590C608CDF6A9D2269@DB7PR04MB4345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2dxZ1OeP1dL/vKY9jzH871QOeI6TFRcXAVdnU7rGZRsVeJ1ywWlw1DjQJ5/D32QGG51BXVBZm0kXCxRY9AeYwEDmZw760KV5GwsltgYzDSXxldZyjIfJ4GSCp5uiK67bvBDtlbIC9/Te3hB0UGNGqbdHyvTzshGrLMHX6nio0MqPQtwkpDsp8sOnM0BXpB2Mo6MC6wsIfl86GCSklcAn9FvY/z14W09+jKFXRheqGm4xa/O9xbt/MfRpEupWVRWS3nmElQ+sKcDsO9L62J16UMC199/faOU9pkh6yYTpaWjFZRepDU2sZiP3dNv/4np0cA/c39rKf0Y/JZSB12ODPLVTSc3l92Zj1czX+ZEyT/AEOGrUYWn47EjrfHBNY5O1OU2hNNWoFH8vHwPVQRQXdqk201pYsmlA8+gi1rkgTA8GAcRFfCqupNAJIjP/r5APs2B3n2C0hR3u3Mi80RANDBzqJ+GvI/2bA+duYOVSKU+07si6OqJte4pXddrDKVyaMAkbxe/uHptBpk6dMC5PmLeguDoh7K5ILK2WdlBa93SHCyD9cWw/FWX0kFFHkCcZOSJP1NZ2ihWdZvu32pYgtQol1BidJE+4Wp/awH7ypEMSNshgbd+SM2WqEjDFrPg2yfbnQPb3PCEutk6tdc4gnuJXJP5JKBjs12G6n13VEpJ1+JgUVodrr+A5a1A9KNT9nMH9lLRpxtK2EInucYnAylVWs661TYUhCzc+nIz32z7dCRvkExWc5Eg7mzpSGzNSOTm8dn2y1fXt/lgPtL3vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(31696002)(44832011)(316002)(83380400001)(8676002)(6916009)(66476007)(508600001)(66556008)(66946007)(8936002)(4326008)(6486002)(54906003)(31686004)(6666004)(6506007)(5660300002)(2616005)(38350700002)(2906002)(52116002)(53546011)(6512007)(186003)(26005)(38100700002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yi9EcnR5T3lYbzdWY0FjQ0U3eXViQSszR1pqY1ZQWjRpbElNQ3FRekNPSzFi?=
 =?utf-8?B?b3lHU1JaWk5Hb1Z4Nk5pUUNjR0ovdk9VNnBVWW9nMU9QVCtpUlhMTi9ITXVs?=
 =?utf-8?B?Mllwb2ZLUE5zWnAxSlVKRnRkajdkTHBabTFkYkVOZlliWk43SGUwZnJIY0xt?=
 =?utf-8?B?azBIM2pRS3pDMGVQbWRqWjJvZTJYN2kzdlBvQ1VYYnlybk5hUm82bTUwMkll?=
 =?utf-8?B?OWc3U2hNRDdPUStrc2txcy9WZkR3MFY4enhVUjV4eWd4bFp1OTdQeWYveld5?=
 =?utf-8?B?Rnl6U2hxN09OYURRcnpVbWxpck84KzZLZ2pVS28zT01neHpjcks1alAxRWJ6?=
 =?utf-8?B?MFpiRlQ0MUVLTWVZWFpzMU1WQ2oybjNmZWZ3OE1MQzJoUDVRZlhieVJMZmZi?=
 =?utf-8?B?dENKY0RsdUE2blJPY2NuWTNSNHZGOVk5ekkzRHVaUllRcVRDQ0VCK0RGMFdU?=
 =?utf-8?B?d0xYS3JOUDE0MXFNYUV4R1lOUks5cjcxVitHcXk2Zld0SjR4U2xwT1E3THhI?=
 =?utf-8?B?YjhHcWJZQi85MTQvUVBmS241THBPa1l6UFAydzE2VVZUa2NpSkxOa0RqSnNW?=
 =?utf-8?B?aUtBSDBmV0RTdFdmc29NaXZFSG5panpoaHFoNzN6NDJyVlREenJaWTVaV0Zv?=
 =?utf-8?B?TWUwMW5HeWwxYlg3N3BjYm05cHB3YkpsamdlU3FRWFlFdW1aWW0vRDB6WDZp?=
 =?utf-8?B?UzMvbkpBcjVwUkNvQUd6OUF6bW1wbWJIV1lJazNwT0QyRVNCZFZmcVZueitt?=
 =?utf-8?B?ajdtQ0lHL09QWC9DWHRucm5OeGFqNWtMRkdRUWtod25IWjkxVXFUYXczQ21O?=
 =?utf-8?B?ZHJ6NXQ5T2daMDR5cHpjd3dqZHdlUi80UjZDYUNOc1VPK29jeDc4Sk1mbnZ1?=
 =?utf-8?B?Y2xibHZDd3RQbnpCa0NxcVFkalhKbDIzSE16WG1sVWZ4cVBRakZBaUpaeDBr?=
 =?utf-8?B?YTc4a1RBSFdZbFVmVHR0QmNLNkI3Z0UzdGNLVGFvZGlKZDV5ZytnOVJKTkRu?=
 =?utf-8?B?dTBRb3Y5SHpIWTZsNUFHbFlNL3B1V2poK0liVkcxTlNRbVJ1TkUzSjM2NDBQ?=
 =?utf-8?B?WEIzT1lVSmxYNE5KUDlja0g2aHcxQk4yc1hPNVpVbms2alJkaXV4Z1lsVTNZ?=
 =?utf-8?B?MW5yZllHRnprNlVNK2loNHhGMFM5VjZDWVZNdmYxZnQ0S0p4c1oxamtzRCta?=
 =?utf-8?B?cXNVUzJuL01qWEJ1VG5LVFVQWU1xVjlFTlJrTFN0Y28xOTFrK3Y3TU80R2RX?=
 =?utf-8?B?YUQ1MXhpcFVlSnFiQ3g2WGZZbThORGcrNmNNTTdxQVRDeGk4UjFpTnM1MVo5?=
 =?utf-8?B?N1JYY1BBM2x6R3U3Smx6TW9yV2cvb3I1eklJZ1ZicHZiQVViZ09hcmNPaE1s?=
 =?utf-8?B?MkI3Tk14TzIvUkkxeEVXeXhWenQ4dk5rMEpKQ0xQMTlIanRsajZBREdSVWNZ?=
 =?utf-8?B?MWhibEliU0R1QSt3VEpBR2dGeHNEYldaOGpzZm9zOU5rSXpTOW41MWhrb3VD?=
 =?utf-8?B?OGpTQmgrNnJjcXZVdXJRblRWU1ZFbHI2QVplTnRxVE1sZWIzVmtURkdOV3hm?=
 =?utf-8?B?Tnc0cjQxY1dCSFlxMnNqK0M4blFXL1hiNU9NeEQ3akI0Y21qQ1U5MFh1L09W?=
 =?utf-8?B?M2p1NEVvVU9KcThMOWxjR1lQV09hQkUzbkJVZW53alY4TXJ1aGMxT2RLaGQy?=
 =?utf-8?B?MGFBaGVrei83dFpsMFdiUXdrcFVLMUQrMXdtSUdWLy93RFZKckJvVUtJRnJI?=
 =?utf-8?B?eVBVS2xrZjNEOHVkRjhyMCtMNXFFaWx1ZnlFWk9XejlZeGd4cmM1V2p4ZTY2?=
 =?utf-8?B?MFFiaUZ3b1BsSDZuN1FMak5WeDk5VFdrQVJwd2pscXNrNkxrcVZ1T1ptUzlv?=
 =?utf-8?B?N0U2eWRXb1VSWWhqaUJyQlNHNXVsMUJLbDBhYW1zcWZvdzUwRlNnYnFXTkdE?=
 =?utf-8?B?ZHI4RVg4SlcvUWMxN0tnSThwekl5VkFnK0FiekxiWi82SjBQckZTc1MreWxB?=
 =?utf-8?B?VVVqNDJYR1o0V2R3WkNGQTM3elZZOHNXcmw3RkdQeTUxZDZZNFhXaWZoSVNC?=
 =?utf-8?B?aTZzd1ZnL3Zjb0lqdlRmOUVYT0lHWUplU1AvVGVENm1Mai9rMkFsYTF6dS8w?=
 =?utf-8?B?ZnlXZjNSTUVQMURWRUkvdGJrbjJLVHpPOS9ubUxZVUFWb3hSR0dkRE1VMHZa?=
 =?utf-8?Q?kURCNXMdX7p29TWHH1NzHtY=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35216a5f-7e7c-4e13-de33-08d9e5abded5
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:54:19.5517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sqVc2jeD9m/wfjdES79nKBvAbZtA3ZTf2fLTBQVJ2huKkeBlniSZR2xw1WdY4P6RdEseYX9sZXt2LulrZ3znaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/2022 6:42 AM, Jakub Kicinski wrote:
> On Fri, 28 Jan 2022 18:02:57 +0100 Yannick Vignon wrote:
>> Reading the PTP clock is a simple operation requiring only 2 register
>> reads. Under a PREEMPT_RT kernel, protecting those reads by a spin_lock is
>> counter-productive:
>>   * if the task is preempted in-between the 2 reads, the return time value
>> could become inconsistent,
>>   * if the 2nd task preempting the 1st has a higher prio but needs to
>> read time as well, it will require 2 context switches, which will pretty
>> much always be more costly than just disabling preemption for the duration
>> of the 2 reads.
>>
>> Improve the above situation by:
>> * replacing the PTP spinlock by a rwlock, and using read_lock for PTP
>> clock reads so simultaneous reads do not block each other,
> 
> Are you sure the reads don't latch the other register? Otherwise this
> code is buggy, it should check for wrap around. (e.g. during 1.99 ->
> 2.00 transition driver can read .99, then 2, resulting in 2.99).
> 

Well, we did observe the issue on another device (micro-controller, not 
running Linux) using the same IP, and we were wondering how the Linux 
driver could work and why we didn't observe the issue... I experimented 
again today, and I did observe the problem, so I guess we didn't try 
hard enough before. (this time I bypassed the kernel by doing tight read 
loops from user-space after mmap'ing the registers).
Going to add another commit to this patch-queue to fix that.

>> * protecting the register reads by local_irq_save/local_irq_restore, to
>> ensure the code is not preempted between the 2 reads, even with PREEMPT_RT.
> 
>>   	/* Get the TSSS value */
>>   	ns = readl(ioaddr + PTP_STNSR);
>>   	/* Get the TSS and convert sec time value to nanosecond */
>>   	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;

