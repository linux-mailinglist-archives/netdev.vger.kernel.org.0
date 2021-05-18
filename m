Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAD9387B33
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhEROfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 10:35:43 -0400
Received: from mail-db8eur05on2082.outbound.protection.outlook.com ([40.107.20.82]:7181
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231402AbhEROfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 10:35:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jsz+vqsRYsdAJtNdwbkN8Arsbf32WYR2snODLe+BDGs/5o4xhcxngzNwjYoxmnjk/PnoAYMWrYHqtoC3/rg5x7wdgbFlAPpc4KoKeEXRdfIjBA8vAL6/jlO7OVFy3m1SoxrJid7/0v6Z1NTVfreTjwNJ2XzoyT5FjKsfnnw8hHdUYNn9njKzT5db3hZc53hFz95Bqj9kfHscNA0Yggc82bBGacKruPrej/aanpuQwC1mvnaAX1O+eUIy7dOCJELKFyDvUflGNdvnzPaXCFvAt/WXKYUmvnjsThmtE7tjc2AJ7T9x+KaFkx6rMfy4JUExqlVdHrUymaOjxx4g6YiNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2FzPKNOO3MQZQ8AN5bpQOuLsqKvhOXh26VpGCmlDiU=;
 b=Ap1jW4lsNNyR1W2dI355revjnlEnWVrBVYsD/ds2zicoLEnPW1s2chHl9LraUYRXuHk67fotSKfj+ZNSlkqJkyy/In+oBd3G7vw63KlsI2PFO2u+rnHvUpw68vVlKKOXUilPeIOaurrgbVaSLt7UsvJ/XB2lBE+UooY3IzpbSi/Gi/CPXc7iMexkZbzfPt61G4ayZWeZglxH6yDpkTE8uy35F+EniaAOQAE4AoZRKkXAzLghI1WbEQs8qbWcpAuH1ufics7y7SQo4AIswRyYzW4k2e1G5LZTqE+G6FpjwSlBatWuneiiiXdFEHvzy1vT4YYQGnO1v7CCw1eUhPof0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2FzPKNOO3MQZQ8AN5bpQOuLsqKvhOXh26VpGCmlDiU=;
 b=fH3HnqrEYQ3ecBDPGl5wvYz+8+rUOwortjc283NPiUrkZxnQKXo98SaFrtzkGJYOinHhvf77uvEAV1G7TCwy2XmhIYxpoxLIS0mfwOQx3cR34N3rI98mNWFsw+YseRTWeUHRkoFe5QtuGedp88UGw6p2rP+VubIE2WMvqQYuREM=
Authentication-Results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8726.eurprd04.prod.outlook.com (2603:10a6:10:2dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 18 May
 2021 14:34:15 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 14:34:15 +0000
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev queue
 mapping
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Michael Walle <michael@walle.cc>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
 <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
 <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
 <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
 <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
 <87zgwtyoc0.fsf@vcostago-mobl2.amr.corp.intel.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
Message-ID: <1a5057b2-06f4-1621-6c34-d643f5b2a09d@oss.nxp.com>
Date:   Tue, 18 May 2021 16:34:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <87zgwtyoc0.fsf@vcostago-mobl2.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [109.210.25.135]
X-ClientProxiedBy: AM0PR04CA0053.eurprd04.prod.outlook.com
 (2603:10a6:208:1::30) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.18.89] (109.210.25.135) by AM0PR04CA0053.eurprd04.prod.outlook.com (2603:10a6:208:1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 18 May 2021 14:34:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb374fee-2a8d-410f-a858-08d91a0a0314
X-MS-TrafficTypeDiagnostic: DU2PR04MB8726:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB87266A3A13B9F725A66C93B5D22C9@DU2PR04MB8726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UytJr0ol6LsNzBLxDPMgHh/dOAZP/UO8mnZ3bUVKUrDxq4KNOfXnGFZawqk7UT5s/k1myf4bIESz0sw9Fpr9R1Oq2Qca2ZW3fF7PhcXUo3ZqDWcIBnKIsGwPFp8odg1WNtN7o+2kkatz/kpWZZiocfXgKXcozNFEYrGH+SsZ/Fq1tacSkXNFt53wzzWSagPUM6mlDTWiJOUITAHQ8x/TrQIf5E9rGRw/OOdRsKJEPm56bWz2XNeM+4CYiGlpDsRBr0qAQxAuyu35pG5Tdn2805acxRQGLZJ+FxQQvuDxvukZPwb4WWsGuDNtVk+qANtKMgl+//BdW/yu6oEsFkBAYwC/W7KIoOL1gIpdFj7RyjHsMLPie7+H82D5VLib4SvWzOqW3VA3DqOyKvUZphZ79o/7FXwREEkKuIzf3GaMBR5QvaIoeCaRwXUyu1mALKOvLMgRWq7pqEwiNPu5aiKiRKYaAEb6ckURqoZCSWbwFQELggT6FGq1sI6tbC/PiOpPlbSWkyg05vgPqYboxjJnKEMHOoqPRb618WYo7Al/Xdn8JCJNl3aeqlVkfsHQyC3FzSJpkqllHlIYIORRJt8c9dQX9yDcXYW+7MRF18JAykbyVSH4cN3/dto4rQyjBtIUjJUyCd1JWBJ1RH/5U7ZK6yqvyuCJ8T1hfByzxA3LxW67tdJH7D1RxkX3GZiZxOYLS87A4eEfZdK0tA/hn2xWSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39850400004)(16576012)(316002)(110136005)(66556008)(4326008)(31696002)(66476007)(86362001)(8936002)(54906003)(83380400001)(52116002)(8676002)(7416002)(66946007)(6486002)(2906002)(26005)(53546011)(186003)(16526019)(31686004)(38100700002)(478600001)(5660300002)(38350700002)(956004)(2616005)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WXl0ZUFodkNwTTZ0akdjbmxxWThLSzFKaEFSZnpwZ1JWNkhwZkdmQ2QvNkI2?=
 =?utf-8?B?YW9Wb2pIWmUzU2ppWFRTaCtSc243Wm9nQ1hvTmhEd00xdlFJVUFJMU5wQzQ4?=
 =?utf-8?B?M2FwMmlCZUlMRVVvMHArdWFleDlOSTZyMjBGSURYQ2dZd095bUlPMHVobytW?=
 =?utf-8?B?THdlTVJXUHJxaWZWS3dRckxnNmkvUWZqSmh2RGc1WHpyampIdnhFTGpkQnUr?=
 =?utf-8?B?anE0dVB0UEpMMzRZQ3Y5bXJZQW9OM1YzQWdzTWh1RHRxMWU5SWViZ3RKYWRo?=
 =?utf-8?B?OENQVTByUFh0amo1VjFWWnhiSFdNcEVzWXN3WGNWeEFnaGNVdmJIMlV3czds?=
 =?utf-8?B?MER1Q0dOTm1zZ0ZHOUcvbkRZaytrYzlBOUJWQk83Rm9CN2M3V2hVb3FwRTBK?=
 =?utf-8?B?alZab0hQdk1ySnNJYWxxVUFOck1WTTZKYXRTUEQzMVhXQXg1K3JLWGE5V2VV?=
 =?utf-8?B?L200TFJWNzV0MXlua2NKcFhKNGUzemxJOEhJQ1hPMWcrNVBLcWlEaWRibXFT?=
 =?utf-8?B?SkZySzJhK2VpOVQxSXE0cHMxWWp6M0tqajRncnV2T2JCYnA0NnVkM3VVb0d5?=
 =?utf-8?B?TFUyQm5FaW42UjVrL1Y5NExqSGFwY3cxbityNTFpYmIzYXRPY2pIRzVMRmUw?=
 =?utf-8?B?elRaMHE4N2VHK1kyc0w5bS90L1c5cTd1czNBVFdSdGFpU0J6Qm8vYlllWXVW?=
 =?utf-8?B?Z0JFVlByN1UzbTAvN1JrTEtQOXdubXRPT3g1eEUrcVpHV0xMR1JaVXVKUXZ3?=
 =?utf-8?B?RElCOWUzanVMdUpsWWgyUDJScytvYURKRUc1bis0Y2NOdXRuZDFBaDZqdS80?=
 =?utf-8?B?dmhqQ3R1ZDc3YUJMYVRhSFBrUmF4TEVHSHgvOWlhSjRkZG5qUk9XbE9Tek9m?=
 =?utf-8?B?ek1oak9rWXc0VnhJc2pubG1GVmszNFYrWEVlY256VE1mamhyZ2VyZWEzZmli?=
 =?utf-8?B?ZzdMWUo3dlRCaXY3elBOZTNRaDNOcXBnVW5FdVo3VTFqQmt0R1QweWZMSnZN?=
 =?utf-8?B?dWloc0Z1M2RjY3lRbVZ5dUdOckxCUzZtT0l6V29mekNmd0pQeTVpdGR0UW1V?=
 =?utf-8?B?TnNvZXdVMVhTaWJrT1lZT0t3L2FoKzFybnNHb3VYYlV6bERCa3hTbDBkZGJw?=
 =?utf-8?B?dHpseHhDVFIxZDZWSEJpUTV4OTZGcTJOYTAydG52NmNoemxzbm55NXVoZVBD?=
 =?utf-8?B?TnduTnprMVh2Zis0dXlFQUF2U3h4TTBkTDZzWGMzMzAySzlqeEhlNi8xUzVW?=
 =?utf-8?B?U0lGblFPempRTzlvdzhKaHV4TllyQndMRWtiM28zbGErS1ZRb3o5STZJMER4?=
 =?utf-8?B?OVR1UGVjbXRobllSTjdFOGZKM1ZNRTNiaFdobUpXdnludXZ0RVI2WmY0aXVK?=
 =?utf-8?B?ejdraCs2NUtsbXhaMVpyYUpPdGZaeitxN1UxMUVsNm41Qk5lN2VZRnVwK3VQ?=
 =?utf-8?B?ajdNOVNtT2Z6aU8wRVcwaFVmRTZPRFNKRytjdUxJeWJFME9TcEhxa3A2a1ZL?=
 =?utf-8?B?dWNWT1JpOCtIMEI3bjNtR00yWS9jK3RLTEVUdEl1ZlpUM3k0UWxhZDYzV3gy?=
 =?utf-8?B?eWMyWHErZm9Hd2lIZ3dGWnVCREJYalpVbG95cVhxK0x4LzM1WGFEUHY2QW04?=
 =?utf-8?B?WDVNTm1hTGsrWEM0b3BxL1grTUlGcCtLbHZEbDA3Y3hhQ3h0eWREMGNJY0hx?=
 =?utf-8?B?eVFrNmxQZFNXOC9ZRXJpUmhVK0NKTjJLcXV3SlBYYy9BQUIrNmI3eG5VZTRG?=
 =?utf-8?Q?FbUdrvA9LytYT2/79OJ8XZ9TuVF5+RQ2L7nOm0D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb374fee-2a8d-410f-a858-08d91a0a0314
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 14:34:15.5974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xS6PnWHvq8NPtpHkY1aafRR8vCqrbXQ+l09Tq1+uSiZItkdP8YjTJJ2UZzk1ROmMYoOxxtuGENe5hgOUTKY65g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/2021 12:42 AM, Vinicius Costa Gomes wrote:
> Yannick Vignon <yannick.vignon@oss.nxp.com> writes:
> 
>> On 5/15/2021 1:47 AM, Vinicius Costa Gomes wrote:
>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>
>>>> On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
>>>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>>>> You haven't CCed anyone who worked on this Qdisc in the last 2 years :/
>>>>>> CCing them now. Comments, anyone?
>>>>>
>>>>> I guess I should suggest myself as maintainer, to reduce chances of this
>>>>> happening again.
>>>>
>>>> Yes, please.
>>>>
>>>>>> This looks like a very drastic change. Are you expecting the qdisc will
>>>>>> always be bypassed?
>>>>>
>>>>> Only when running in full offload mode it will be bypassed.
>>>>>
>>>>> And it's kind of by design, in offload mode, the idea was: configure the
>>>>> netdev traffic class to queue mapping, send the schedule to the hardware
>>>>> and stay out of the way.
>>>>>
>>>>> But as per Yannick's report, it seems that taprio doesn't stay enough
>>>>> out of the yay.
>>>>>
>>>>>> After a 1 minute looks it seems like taprio is using device queues in
>>>>>> strict priority fashion. Maybe a different model is needed, but a qdisc
>>>>>> with:
>>>>>>
>>>>>> enqueue()
>>>>>> {
>>>>>> 	WARN_ONCE(1)
>>>>>> }
>>>>>>
>>>>>> really doesn't look right to me.
>>>>>
>>
>> My idea was to follow the logic of the other qdiscs dealing with
>> hardware multiqueue, namely mq and mqprio. Those do not have any
>> enqueue/dequeue callbacks, but instead define an attach callback to map
>> the child qdiscs to the HW queues. However, for taprio all those
>> callbacks are already defined by the time we choose between software and
>> full-offload, so the WARN_ONCE was more out of extra caution in case I
>> missed something. If my understanding is correct however, it would
>> probably make sense to put a BUG() instead, since those code paths
>> should never trigger with this patch.
>>
>> OTOH what did bother me a bit is that because I needed an attach
>> callback for the full-offload case, I ended up duplicating some code
>> from qdisc_graft in the attach callback, so that the software case would
>> continue behaving as is.
>>
>> Those complexities could be removed by pulling out the full-offload case
>> into its own qdisc, but as I said it has other drawbacks.
>>
>>>>> This patch takes the "stay out of the way" to the extreme, I kind of
>>>>> like it/I am not opposed to it, if I had this idea a couple of years
>>>>> ago, perhaps I would have used this same approach.
>>>>
>>>> Sorry for my ignorance, but for TXTIME is the hardware capable of
>>>> reordering or the user is supposed to know how to send packets?
>>>
>>> At least the hardware that I am familiar with doesn't reorder packets.
>>>
>>> For TXTIME, we have ETF (the qdisc) that re-order packets. The way
>>> things work when taprio and ETF are used together is something like
>>> this: taprio only has enough knowledge about TXTIME to drop packets that
>>> would be transmitted outside their "transmission window" (e.g. for
>>> traffic class 0 the transmission window is only for 10 to 50, the TXTIME
>>> for a packet is 60, this packet is "invalid" and is dropped). And then
>>> when the packet is enqueued to the "child" ETF, it's re-ordered and then
>>> sent to the driver.
>>>
>>> And this is something that this patch breaks, the ability of dropping
>>> those invalid packets (I really wouldn't like to do this verification
>>> inside our drivers). Thanks for noticing this.
>>>
>>
>> Hmm, indeed, I missed that check (we don't use ETF currently). I'm not
>> sure of the best way forward, but here are a few thoughts:
>> . The problem only arises for full-offload taprio, not for the software
>> or TxTime-assisted cases.
>> . I'm not sure mixing taprio(full-offload) with etf(no-offload) is very
>> useful, at least with small gate intervals: it's likely you will miss
>> your window when trying to send a packet at exactly the right time in
>> software (I am usually testing taprio with a 2ms period and a 4µs
>> interval for the RT stream).
>> . That leaves the case of taprio(full-offload) with etf(offload). Right
>> now with the current stmmac driver config, a packet whose tstamp is
>> outside its gate interval will be sent on the next interval (and block
>> the queue).
> 
> This is the case that is a bit problematic with our hardware. (full taprio
> offload + ETF offload).

Based on your previous comment to Michael, this is starting to look a 
lot like a work-around for a hardware bug. Would moving it to the 
corresponding driver really be out of the question?
Note: there are currently only 4 drivers implementing ETF (including 2 
from Intel), so validating their behavior with late packets would likely 
be doable if needed.

>> . The stmmac hardware supports an expiryTime, currently unsupported in
>> the stmmac driver, which I think could be used to drop packets whose
>> tstamps are wrong (the packet would be dropped once the tstamp
>> "expires"). We'd need to add an API for configuration though, and it
>> should be noted that the stmmac config for this is global to the MAC,
>> not per-queue (so a config through sch-etf would affect all queues).
>> . In general using taprio(full-offload) with etf(offload) will incur a
>> small latency penalty: you need to post the packet before the ETF qdisc
>> wakes up (plus some margin), and the ETF qdisc must wake up before the
>> tx stamp (plus some margin). If possible (number of streams/apps <
>> number of hw queues), it would be better to just use
>> taprio(full-offload) alone, since the app will need to post the packet
>> before the gate opens (so plus one margin, not 2).
> 
> It really depends on the workload, and how the schedule is organized,
> but yeah, that might be possible (for some cases :-)).
> 
>>
>>
>>>>
>>>> My biggest problem with this patch is that unless the application is
>>>> very careful that WARN_ON_ONCE(1) will trigger. E.g. if softirq is
>>>> servicing the queue when the application sends - the qdisc will not
>>>> be bypassed, right?
>>
>> See above, unless I'm mistaken the "root" qdisc is never
>> enqueued/dequeued for multi-queue aware qdiscs.
>>
> 
> That's true, mq and mqprio don't have enqueue()/dequeue(), but I think
> that's more a detail of their implementation than a rule (that no
> multiqueue-aware root qdisc should implement enqueue()/dequeue()).
> 
> That is, from my point of view, there's nothing wrong in having a root
> qdisc that's also a shaper/scheduler.
> 
>>>>> I am now thinking if this idea locks us out of anything.
>>>>>
>>>>> Anyway, a nicer alternative would exist if we had a way to tell the core
>>>>> "this qdisc should be bypassed" (i.e. don't call enqueue()/dequeue())
>>>>> after init() runs.
>>>>
>>
>> Again, I don't think enqueue/dequeue are called unless the HW queues
>> point to the root qdisc. But this does raise an interesting point: the
>> "scheduling" issue I observed was on the dequeue side, when all the
>> queues were dequeued within the RT process context. If we could point
>> the enqueue side to the taprio qdisc and the dequeue side to the child
>> qdiscs, that would probably work (but I fear that would be a significant
>> change in the way the qdisc code works).
> 
> I am wondering if there's a simpler solution, right now (as you pointed
> out) taprio traverses all queues during dequeue(), that's the problem.
> 
> What I am thinking is if doing something like:
> 
>       sch->dev_queue - netdev_get_tx_queue(dev, 0);
> 
> To get the queue "index" and then only dequeuing packets for that queue,
> would solve the issue. (A bit ugly, I know).
> 
> I just wanted to write the idea down to see if any one else could find
> any big issues with it. I will try to play with it a bit, if no-one
> beats me to it.

I looked into it this morning, but I'm not sure how that would work. 
With the current code, when qdisc_run() is executed sch->dev_queue will 
always be 0 (sch being the taprio qdisc), so you'd need my proposed 
patch or something similar for sch to point to the child qdiscs, but at 
that point you'd also be bypassing the taprio qdisc on enqueue.

If removing the TxTime check inside taprio_queue remains difficult, I am 
wondering if keeping my patch with the change below would work (not tested):
***********************************************************************
@@ -4206,7 +4206,10 @@ static int __dev_queue_xmit(struct sk_buff *skb, 
struct net_device *sb_dev)
                 skb_dst_force(skb);

         txq = netdev_core_pick_tx(dev, skb, sb_dev);
-       q = rcu_dereference_bh(txq->qdisc);
+       if (dev->qdisc->enqueue)
+               q = dev->qdisc;
+       else
+               q = rcu_dereference_bh(txq->qdisc);

         trace_net_dev_queue(skb);
         if (q->enqueue) {
***********************************************************************
One risk though for multiqueue-aware qdiscs that define an enqueue (only 
taprio is in that case today) is that the child qdisc selected by 
enqueue would not match the txq from netdev_core_pick_tx, so in the end 
we would call qdisc_run on the wrong qdisc...



>>
>>>> I don't think calling enqueue() and dequeue() is a problem. The problem
>>>> is that RT process does unrelated work.
>>>
>>> That is true. But this seems like a much bigger (or at least more
>>> "core") issue.
>>>
>>>
>>> Cheers,
>>>
>>
> 
> 
> Cheers,
> 

