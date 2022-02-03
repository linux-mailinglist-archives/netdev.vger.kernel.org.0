Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3F54A9141
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 00:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356023AbiBCXku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 18:40:50 -0500
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:64325
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229532AbiBCXkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 18:40:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEsMvmoo2T3eWgngO23J2CjQRmdLvL5R37cnOSmzQ2Wp4e5cXltkbOHG1P1R/xaSuk5MCXkdPDY7vfVISCloX3ejzZ7pMkzHlC7GmP94Iu4WW1fOhRsTb8sYVDLzXIdEdmYXJVO5zT+GK6916wBit2qiOjIel8+gDT1Rq7BvJ6/07AC0PTYOobwQnTEiaZd/+JYaEorpKtaA/TLjSC/vAuIe4+1Bk5sBbNBxB6j8CPDCv2ABcc3PUXXoZCJg+k6OoSgMiGQtdPEgW4odDzvRuk6cyx2hncEGTLyjZ54S+MqvCNIapLr9ALRZ5jfTI48n55UGrZh0D+eYqGcY325zpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YdYICibdQf4sdZ7WavRWToPhrlHKXE5ZSfl61xZyUY=;
 b=oQvEY5zCZqADt2Z+acBFEeWvsgw4noUgGRX4iRZhASId5mo2jIN2ybmrsxc7SDxFNlwwskSbC3Xpsaydv58xQ53bYaNE4/X1qZ9BZ8BVw0dOIqBJV08hXow6bsNzhFAxGEBAY1UzQM0ya5cLUlx3hmtxxyhybG3lOQ/f25fzcifNeMAGqPp8r+aQs9xR+Ra2Al6Ro6JpOx2Yd5lgk2aw5N5u++EXmzN1w+L9WY9hdzO7kEWmAFjXF/Lmi6ej79NnP7MMWKWY7aDZoIo+hUqtAj7a00BFw2eF/UU2DiX3lB6blOY2Bxs+aY+0RP8nHrJlqwbryv9l2fd//Dq9DHk8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YdYICibdQf4sdZ7WavRWToPhrlHKXE5ZSfl61xZyUY=;
 b=Ei95KH9H9oq0wIx5qywsK6mK2tDladCynAFcqQo048pyVDeGMrtRX2e6xet03Ch8Mr16UXmplxxSqa5R6I7DUGc5ELG9OLwRAaSvhHvFLuXh58WJZuySyHwTvBqDIFvVni8WYhC2HY1rE0AdQuZNo53yRkYCdB+vbZLi6HWKwjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by AM7PR04MB6805.eurprd04.prod.outlook.com (2603:10a6:20b:dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Thu, 3 Feb
 2022 23:40:47 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 23:40:47 +0000
Message-ID: <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
Date:   Fri, 4 Feb 2022 00:40:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed after
 scheduling NAPI
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
 <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
In-Reply-To: <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0186.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::23) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fc36d64-63e3-4ab4-29df-08d9e76e9969
X-MS-TrafficTypeDiagnostic: AM7PR04MB6805:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB6805E67C1B36257D13E2D485D2289@AM7PR04MB6805.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwvzI7jb3qSnLIUPggTi/ZCfg0/Ogi/RmU9jru8PHSqTYymqZlKv1Vh96LQ25a2F8z4V+qlKjFPJmFxygT3mlUedHa8yNUj0jIh4Rv099udaN7NxWB/ZoUssA/zYOXSpp6xoUzvdi/gpKtkmFl4Wkv06lbbKsQTz5yTGKzZXlFBOTntA43EsRiXcxl8E7hx2xYW9qgKEuxA8K74+Zf6TbUoTGeJExovi9z1evE1TvrTgBgkaWsVXp9aYVoRTOkpWVzVDM3Fll4sE6iA+YC+ie3tDriIdWtWnhZTnMY3Wbl1L1s7VxA14TDmx6El4XiYvAQ3k5+gMCuq3RBhz9UyhGyF3+11J1zrU6YYjcW1j1dCwgJs3uJ+Z1P1i6yzk+Dn30CKDhhgA+cZEM6z8hy8mGn2uinjuvhbRVj1IvYR/lqHNQDdslAINXm8POb3lNmp5C030DLN2R77aDRNmh0eACg1KLV+YbLtCUjnNLC/taga9Y1xzUgMVHrY+XpHMhN1DvqKeSi/HSKnG9miMM0aPsda8flmxFwPUGwgMJjVRgxYUDyETDXQWo1Lw0sVWi55LDl2FTcFiERw+4GTCDtrxgbcpndyyoxCs8v4zGEnZu9OX0ciq/0TwMRc6QsfQhVSNrF2/jPOOUsTnQLvHWCrtPSttScIsTasCqhMkFH4PTia9wDYU18o7OzmoP/9b8jmVEDDHVhv5/LD0Z77R6V+OVlbeLuZdEuG6RREwUYhKTEUM0WNLd+64HTDbxxvF1wbWLCUsRYhP5aQRidfW2ALPjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(86362001)(508600001)(2616005)(316002)(186003)(38100700002)(26005)(54906003)(7416002)(6916009)(38350700002)(5660300002)(6506007)(4326008)(8676002)(6666004)(31696002)(8936002)(66946007)(66556008)(66476007)(44832011)(6512007)(53546011)(52116002)(31686004)(83380400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEZINUdDT3ZzTUtTcWFnNTM3cnJPU1BxeWhISERrV1JPK25acWd0Q1A2ZVNr?=
 =?utf-8?B?SFRCdkR4cCtJM09XZGF6T1RsQjRGQUU4ZEpBY3ROdXBpZjdyeXZ2Y1Z2eU1w?=
 =?utf-8?B?V0xvYzJtcFhwOWUralpVamkrRkpObmQ1MVhLZCtpeVJ0TDhqSXd3UXQ2dXU0?=
 =?utf-8?B?RUJFWGJNbXpxN3dzT0kybS9Na0pJZm9FNUR6S09MMUpyRFY2MVU3WTlITisy?=
 =?utf-8?B?Y3orWlhaVnI0M1RybXJ0dytYOXRRQTd0WWN1UnE0OHlyWlcwQnlpd1M5dXlQ?=
 =?utf-8?B?b2tVZCtmOWJPRmZkZXlHZTFwOHVBUTFidm14TGFXMjNHNlVjMlFBU3BiTGhC?=
 =?utf-8?B?ckVPeEZ6dkYwc1I0MTA4d00vZXpoSG1NVXVLN0FhUlNERVRIZ01kSWVLN0lH?=
 =?utf-8?B?Mmp5WVNWTlcyNkVBcXFVaFhqL0xmSHlVVTh3RWdOSlQ0TjlYdDBhRjJGRko3?=
 =?utf-8?B?NUJsRTdtTXk1VlFnZGFkSFczMVlYTkZxTWc0cytOcFJBWXgwczRnT2tEOEJT?=
 =?utf-8?B?U2pmdERZUVBZakZ2ZTNXQWEyYUpDa214Qk5waDEvZDh6YlZaekNTa0pnQ1k0?=
 =?utf-8?B?Y28yZmluaGFCd0lTUGtlZ05Gc0d0aWVWUzVpb0t2b01GbGUwbEs1OEpva1Bx?=
 =?utf-8?B?TUJhazN0TlpNQmpUb2prQ3BnejArcW5yTGFsU0ZKaEZqcDIwVElVcTNVRTRP?=
 =?utf-8?B?MGNZK2pJQXNTaExXM3BCNHc0VjNvbWV0R25GSFdjMGpZbkkrZ2pOZEpsRzVv?=
 =?utf-8?B?djQ0b2RVVVJKekR1cFV5T3czeG1BeStncmlYeGNPbDZFU3JJclo3cFRBRitz?=
 =?utf-8?B?QUJqT0c4ME5UQW11U3lmOGZKWGtudktxOUM3cU9SYlM4S1AwSTd3NzdwUi9U?=
 =?utf-8?B?d0RWR2RBS0N5MlBPWDlaSzdKYlBWcDM1Um10Q1ZIMWR6akp5RDdGZGhqR01h?=
 =?utf-8?B?VHMwejJObGZXNGFoOWwxcUdUYmRFaUlINWZKUjVOV1hGZTJFeWY4eTlBQjhF?=
 =?utf-8?B?UWZWQ2o0K1lnaFJ1c1lzbGZqdTlLV2NyYyt6L2RBVkRjZVhBTEo3UE5GRllt?=
 =?utf-8?B?VzhzdUltZkUzdUFOK21FaGt6SjlGaXhOQWZMNU1JcXNsdjIzMHdvR0hIbTZ6?=
 =?utf-8?B?MWRqNDM1Vm50YnpuODZzc3dHSWlTM0EyWFMxNkI5aEFqYXBTeUdQSFJkVkNN?=
 =?utf-8?B?Q2RsbjVibGpXMHJTS0pkRmt5YkVYNUU2Z0JhbGpwdDB5UTNtMjdFWS9rY29B?=
 =?utf-8?B?TG5ISWZYUHduRGwzdEtYcnI0Y2R3d0dobTRwbmxkZzhnQ0dSOVR4YzNkMXhH?=
 =?utf-8?B?SEhWdE04QmMvY2NyTm5pUmM0UUFPWWhXcXNRWG5EMEVkV3FTN1lBRmUxM3BC?=
 =?utf-8?B?d2Y4dkdYaFZGbVZLZXJhdHo2Qi94OUFBdmJBeC9jNkpDNS8wV05GTENMM1dG?=
 =?utf-8?B?SFhWcFdaVjJlUHNxaUdLWDlscURFTCtEY2QweHFLSEZXQUkrbWwvT1dTdWk3?=
 =?utf-8?B?OXZSa0ZhYzRka2FMZ25Ibzl4Y3hYTWVyMVlYRnZ1M3lNdU1EaE9mMnJRYm9x?=
 =?utf-8?B?YTJKTmJmQ2wzVnhYMStzbXpWUjZrL25tMEZ6Qmp1UGRKZlF4eEFIMXRIdjhY?=
 =?utf-8?B?RDNPcUdBVlpHbW9JdFhLVmMrWVFNdElxMnREaHVMZUU5aUhkSVdSR1JiRXVj?=
 =?utf-8?B?U3ZDN2d4WC9tZU5DenBCQ2FqQVdkRFdpcXBvYUdJSk5QTlJmZkpreUJNSGxY?=
 =?utf-8?B?V3kyWkNsckZaR0xaejhnNmJJNXZSZHYxbGhhN2hLQUw5djVSNGJZZVNWdWRQ?=
 =?utf-8?B?dnd5czhlVk1PT0dHYnlnVTlmWUg3MXpzWGk0aG5UVktPL1JzTWs2Wi9zZm1S?=
 =?utf-8?B?ZjNoRXAzTVk2cUZtRmx1UktHVmZoMWFMcndZSUZPTm9VczlFTjM4ckdrWW81?=
 =?utf-8?B?bFFHUGJITWhMVExNN2w5a2lMTW8yNnhScjhMcW80RGlEUHZJQjJnUTNOaXBn?=
 =?utf-8?B?YmV1STByYThVTDJsYVk1Z1NiNENPd08yTkM3QWtsZ1NCTGpTVkxvT3ZUMGFu?=
 =?utf-8?B?clFiZ3JBeXZadStkTjRHY0wyTDRhdFBwYkZEaUFXbW8xSEduc29WcGdmcUVn?=
 =?utf-8?B?MzN4SEtRU01LUS9PV0FNY3JZK3FmazN5aytpbDI5RjBJaXVyVXJ4TFlXWUgz?=
 =?utf-8?Q?LH1bW4oql8UMaaChPcLZTM4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc36d64-63e3-4ab4-29df-08d9e76e9969
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 23:40:47.1964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Q3fh2rAXDApFhSjIP0JIJmnFvRkT0K+LEbA6wz6usxD8501MPK/2/JDOuKybPuecgv3vphenWliwd18ttXBbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2022 8:08 PM, Eric Dumazet wrote:
> On Thu, Feb 3, 2022 at 11:06 AM Yannick Vignon
> <yannick.vignon@oss.nxp.com> wrote:
>>
>> From: Yannick Vignon <yannick.vignon@nxp.com>
>>
>> If NAPI was not scheduled from interrupt or softirq,
>> __raise_softirq_irqoff would mark the softirq pending, but not
>> wake up ksoftirqd. With force threaded IRQs, this is
>> compensated by the fact that the interrupt handlers are
>> protected inside a local_bh_disable()/local_bh_enable()
>> section, and bh_enable will call do_softirq if needed. With
>> normal threaded IRQs however, this is no longer the case
>> (unless the interrupt handler itself calls local_bh_enable()),
>> whic results in a pending softirq not being handled, and the
>> following message being printed out from tick-sched.c:
>> "NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #%02x!!!\n"
>>
>> Call raise_softirq_irqoff instead to make sure ksoftirqd is
>> woken up in such a case, ensuring __napi_schedule, etc behave
>> normally in more situations than just from an interrupt,
>> softirq or from within a bh_disable/bh_enable section.
>>
> 
> This is buggy. NAPI is called from the right context.
> 
> Can you provide a stack trace or something, so that the buggy driver
> can be fixed ?
> 

Maybe some background on how I came to this would be helpful. I have 
been chasing down sources of latencies in processing rx packets on a 
PREEMPT_RT kernel and the stmmac driver. I observed that the main ones 
were bh_dis/en sections, preventing even my high-prio, (force-)threaded 
rx irq from being handled in a timely manner. Given that explicitly 
threaded irq handlers were not enclosed in a bh_dis/en section, and that 
from what I saw the stmmac interrupt handler didn't need such a 
protection anyway, I modified the stmmac driver to request threaded 
interrupts. This worked, safe for that "NOHZ" message: because 
__napi_schedule was now called from a kernel thread context, the softirq 
was no longer triggered.
(note that the problem solves itself when enabling threaded NAPI)

Is there a rule saying we shouldn't call __napi_schedule from a regular 
kernel thread, and in particular a threaded interrupt handler?

>> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
>> ---
>>   net/core/dev.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 1baab07820f6..f93b3173454c 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4239,7 +4239,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>>          }
>>
>>          list_add_tail(&napi->poll_list, &sd->poll_list);
>> -       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>> +       raise_softirq_irqoff(NET_RX_SOFTIRQ);
>>   }
>>
>>   #ifdef CONFIG_RPS
>> --
>> 2.25.1
>>

