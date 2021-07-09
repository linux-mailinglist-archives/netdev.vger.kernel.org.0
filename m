Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01A23C21B8
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhGIJoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:44:07 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:48767
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231954AbhGIJoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 05:44:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXpb4QJw6sn/zmvtjZgngDNg4ItO13K4ku7ad0M/jYr6zmyNujYGOdUHHWqbLa4Pq4oViQknEPp+CoLemVq7spio7zQXxwyF72TqBG+52HGcQzyDKQDyzGDevLW62kgdLVQxc5MxBmVoG6Jv2pN2o16MaCLESZvH1MiGlk8JmdhAz/B+srzsYGvzRr+wviNJV/2Riy+c2WOLIGnoaM468lCZlG80Svb1TbERaB8rD0CgQklaVdhLB70iQKEQm0WMakfSV/TVjaxlu86BZCEEhpoJ/vQasCI6kaq6K5RJZ6DyLjUA/6q6R0G8k1sW582aCDb+6JyxGWK4XX/T+jVemQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CT7ZjpkGnpUSXhWUCX/tvGqlRP1n7be+KVMImQEZaGk=;
 b=AmLL1RTLIeUbGaYM/3Qhdit766WjUsMtYbsu2aiIQoRVzTTByXNQKlv0DiA7J2lZDRxcIdlT4exNtpAwznOl1EbeWOIXP6p8zBRDKoIijaaEd93BF3BN4jktkYhCVD8bSc0NQQZWyI7Bc9EsfjE0ETnYoDbmHVsKRrQIml+Kii4NT5IkrH9tIdQ27x1+iGuTIPbjvqFflwUF4Rp1VH3J881DK4tcsr2bvSZ04qCxRy/66VgmYyzl5SO6M3ZWfs8+/Vrx9DdSuw24y0qi2/po5mZ+s46JJdI5cwSs4pcG5J2pKTqtz6MuW8ByKRe9Fl/gjcDKdTxGiTBZGS28/jOOtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CT7ZjpkGnpUSXhWUCX/tvGqlRP1n7be+KVMImQEZaGk=;
 b=LNg7p3nz7TlQYbUu/J5a/ZtS13Ptn8+TA/+H1fKkenkkkc6vsMeSvogp9bZARI5aoF05zEbmTNrLHI+nW4w9hQZ01YUeU76Skx/D90xCCJhnqitmrHlk3J4qJLln9AJehApA03Mg3Tvok+fAsYRejcANBgNsboCftPUQq+xC3GA=
Authentication-Results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8598.eurprd04.prod.outlook.com (2603:10a6:10:2d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 9 Jul
 2021 09:41:20 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::600d:b73b:38a9:3c5f]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::600d:b73b:38a9:3c5f%9]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 09:41:20 +0000
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev queue
 mapping
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
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
 <1a5057b2-06f4-1621-6c34-d643f5b2a09d@oss.nxp.com>
Message-ID: <a57076f5-e4eb-f7c1-3609-d49a79815c12@oss.nxp.com>
Date:   Fri, 9 Jul 2021 11:41:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1a5057b2-06f4-1621-6c34-d643f5b2a09d@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::18) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.18.89] (90.8.184.39) by AM4P190CA0008.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 09:41:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11015aa8-b38f-419f-ad15-08d942bdb4f3
X-MS-TrafficTypeDiagnostic: DU2PR04MB8598:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB85987E7AB37825F5AAB9B28CD2189@DU2PR04MB8598.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qifxc++TxF/jQ9rAbUVKs6StN04u+JcwEYbFuEJj7yQY91/slUZwDoLhh7ZYEyt4HUCabfa1pX1Pge172yC1PyJIgGOI7ThG28tz79K0sklBd2OaRxYlnI1oMe2JMDsLuDBGE+097rjRs184ogBRS8y6WyAggm5iY2QZcm5UXysVTuMlM7+23+nmj8+ZhD/CKeQoOW5wDh5Q26pZ1PyxKviFBFzBI+t0ykJLV24c2pybPX9nkq7m7svhjYG55yhPBUOxH+PyEbADNYKCMdSnf7u9falZmvmlokhydx2cPrN9y63KS+1Rx18vYSxHDtpWXzUIGX2mjSUTEHQR3nOQAXjzL8XiY/zoRXhQYAmV0wKRqtXfeh5qL0cbPziTZFvHoasSWGbTo9IA2xlB/LYVg4tkPFk5eYAXIl7zJSaNFiNHYkU4x1gSkD2ZDHUBiLHY3YEF2fa9ot0AvaolEjMYkYzEEBUiWeD5peNSCDzfsSaO3SzVCWAtSsGzbl4nftSiu9xr1zc5N5wZzjRb5C9fOfaEm29v5EdoipTSq864k0U1xlII3TrJaz0YZBqBxGLeT0V8aeoxnozAxujti+xukRCqfogVxo3QF3VEXGd43Y0+ZrMTOAm7fP+KUro99QEs3WqPbQIPhRxyrG00QasTKCZj/YkrLrI3uhjQm5dLxghbV31XfOc54LbLMYrnJa6L2BcoCqg0qQXP7WNlB4wW/rr65DNsn4AdxzoMk5+1H9c4DI52fJ7pthYUIX4h84RPVEX8v7vlo2ERqdEkwmMcyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(16576012)(66476007)(66556008)(6666004)(31696002)(83380400001)(4326008)(2906002)(6486002)(52116002)(316002)(66946007)(8676002)(8936002)(31686004)(38100700002)(38350700002)(7416002)(110136005)(53546011)(26005)(478600001)(5660300002)(44832011)(956004)(54906003)(30864003)(186003)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VllYS2JSeGFLcWhqeWRCOU5MNWg1VDEvdjFMUG1SeUY3VnJmRGswRXBtZFJB?=
 =?utf-8?B?VWFld3ZyWXBpMk5uN01tQTM4Sy9COUlxeEpReThXM2h2dVhpM2JjaDArQUdG?=
 =?utf-8?B?bmMyMU9mQVZ3SFkzMWVSM05xMjZMemhoUlF4cW4xSi9VMWFBQU1JOVMzQzRn?=
 =?utf-8?B?c2E0V21KeTFITjByQmJLWGNNMjRZYkpxK3hQNmRmSENjUVMrNS9LRGVTc1Ux?=
 =?utf-8?B?d2pwTEpYbVBPTVUydkpOc3FDSEZFck5pUlNNaExqcGVoaDhVSjhrbUVveHZT?=
 =?utf-8?B?WWFXc2RqMysrRU5iOTE1LzBPMGNIYTRtaEpBNytxVDhNbC9mTXNIcjJ4VThy?=
 =?utf-8?B?SjJISTBUemhyMDFUYkY5Ui96V2ZBb055clpEbXhEclBJWWlONDJBQXBvWEZl?=
 =?utf-8?B?UllBdlZjM2ZLVzg2QzBCTDkreHNjRU40QkVtTXVqRlFOc1Bsc21xOEdxWEdk?=
 =?utf-8?B?eGc3Ym12M1pxbUJnUzdKMFJsUGMzUHI4Q0w5Y2tNL2tqNGphMS9rY0h5WjJy?=
 =?utf-8?B?RVRGV29ZZm94MGFMOW5ncDdpOXR4cWltZjdsTC9WOEdaRnBKWWtsV2NuUnFu?=
 =?utf-8?B?YW5kZzFQQ1BDS1htM3ZwajA5TnloZjg4dEk1cmR6ZmVzOGxMNExLTU1PV0lN?=
 =?utf-8?B?QjByNVVCckdxUzI4azY4cnpsM28zZGMycWplRGFPUlowK0lvRmxOQlg4dTg1?=
 =?utf-8?B?dTFoMnkxbVF5eGJUWDkvTGtXVFhZQmVEV3Y5dEIwMEdzbXBqbjkyeDZTNzhz?=
 =?utf-8?B?Nk8weFFPV3NkL1BTeFFZK3FmWlg0ampBTjJEbU12U1BmbCtkSlFnazVjSE95?=
 =?utf-8?B?bGhRZjZ3aUwrellKN1gxaHZvMnNMd3JnUGlPVXRDK0JrbXNIOUFoUHE2UmJG?=
 =?utf-8?B?OW12TVBsVjliU1YxMm1DZ21lUEUvS0lrVXlwK0t1TnMyM0wyZDltcjMwMG1p?=
 =?utf-8?B?K0hzMEk1eGlHcTZFUWcza3U5UkNQbDZhUlVISnd3eCtCTGw4aFNzUC9qQk5G?=
 =?utf-8?B?cm5ZdXR6dFkvMzYzNFN3ckJsTWlvMUZFVStHQlhKWkZ0R0Y4WnI4TGxtbjNT?=
 =?utf-8?B?emJvb0xlSk1iQm5yVEFjcXhOZ0JhdzdPK0oxc28zOGVtdE9FekpFTEpjN1ZB?=
 =?utf-8?B?bmVrejlKV0dGcXdoTUxPYXFqbEtTdnVjTkk5WHhwMEQyeXptNGFRUzVzQmJw?=
 =?utf-8?B?UENWdnp3bXJrNmFUbXkvWjVqdUgxd0hZYkJicXNHbElUU0NhQlVIdzdGdzE4?=
 =?utf-8?B?ZnhkaEZXOGFMdjhYb09ZSnUwUFlNc2FuaElOalJyQytRYWJzY2VrNXRQZHJr?=
 =?utf-8?B?UnE4dklDaHRwUi9jZGlhdDIzeXUySVhtbzBWOHVUNXJKenFCemVjUkFmQUhP?=
 =?utf-8?B?ZlhKQnZDVG54b0t2bzR4SXJvVTNpZy8wK0xXemtVR2pZcVp6cTF0eEo2RGIz?=
 =?utf-8?B?U3FNcUF6b0xVN1ViT2loUjRZV1J3am5wWk42eGQvV0JzZ0xONTUzYlBoSEVj?=
 =?utf-8?B?SkVYcURCalVxNDJwdjRFVkJnRVdiVHByNnBBeEJzNVNuN2RHZ2VvNWZHU1l1?=
 =?utf-8?B?TXYzSmhDenJEa09OeE5DZnlPd01SKzRXUEUxcFQyYXN4bENVZ0E4WDM0U2dS?=
 =?utf-8?B?dDUyNk1maUg1dDYwR0NoUUlMWCtibTVkTGFzSHErYkVzbnJja3VWY1l3c0tS?=
 =?utf-8?B?WkdwSVIrT2w0bU9qTTZEVjRpNUtuQnpseVRIQVI5dzRLUnlsZU1uZVl4Y1Qy?=
 =?utf-8?Q?BWwy1yKUqHs/9cqOMAiYYwWL4aIxcOeZSClsRtb?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11015aa8-b38f-419f-ad15-08d942bdb4f3
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 09:41:20.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvZBRY1WvFPhO8buwKp/RpFuJcxbEC6XP3xo8igTtTlm8/7hAqdIYzCjlwO7aP20QdCHgbnIE8bU8uTeKpxigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/2021 4:34 PM, Yannick Vignon wrote:
> On 5/18/2021 12:42 AM, Vinicius Costa Gomes wrote:
>> Yannick Vignon <yannick.vignon@oss.nxp.com> writes:
>>
>>> On 5/15/2021 1:47 AM, Vinicius Costa Gomes wrote:
>>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>>
>>>>> On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
>>>>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>>>>> You haven't CCed anyone who worked on this Qdisc in the last 2 
>>>>>>> years :/
>>>>>>> CCing them now. Comments, anyone?
>>>>>>
>>>>>> I guess I should suggest myself as maintainer, to reduce chances 
>>>>>> of this
>>>>>> happening again.
>>>>>
>>>>> Yes, please.
>>>>>
>>>>>>> This looks like a very drastic change. Are you expecting the 
>>>>>>> qdisc will
>>>>>>> always be bypassed?
>>>>>>
>>>>>> Only when running in full offload mode it will be bypassed.
>>>>>>
>>>>>> And it's kind of by design, in offload mode, the idea was: 
>>>>>> configure the
>>>>>> netdev traffic class to queue mapping, send the schedule to the 
>>>>>> hardware
>>>>>> and stay out of the way.
>>>>>>
>>>>>> But as per Yannick's report, it seems that taprio doesn't stay enough
>>>>>> out of the yay.
>>>>>>
>>>>>>> After a 1 minute looks it seems like taprio is using device 
>>>>>>> queues in
>>>>>>> strict priority fashion. Maybe a different model is needed, but a 
>>>>>>> qdisc
>>>>>>> with:
>>>>>>>
>>>>>>> enqueue()
>>>>>>> {
>>>>>>>     WARN_ONCE(1)
>>>>>>> }
>>>>>>>
>>>>>>> really doesn't look right to me.
>>>>>>
>>>
>>> My idea was to follow the logic of the other qdiscs dealing with
>>> hardware multiqueue, namely mq and mqprio. Those do not have any
>>> enqueue/dequeue callbacks, but instead define an attach callback to map
>>> the child qdiscs to the HW queues. However, for taprio all those
>>> callbacks are already defined by the time we choose between software and
>>> full-offload, so the WARN_ONCE was more out of extra caution in case I
>>> missed something. If my understanding is correct however, it would
>>> probably make sense to put a BUG() instead, since those code paths
>>> should never trigger with this patch.
>>>
>>> OTOH what did bother me a bit is that because I needed an attach
>>> callback for the full-offload case, I ended up duplicating some code
>>> from qdisc_graft in the attach callback, so that the software case would
>>> continue behaving as is.
>>>
>>> Those complexities could be removed by pulling out the full-offload case
>>> into its own qdisc, but as I said it has other drawbacks.
>>>
>>>>>> This patch takes the "stay out of the way" to the extreme, I kind of
>>>>>> like it/I am not opposed to it, if I had this idea a couple of years
>>>>>> ago, perhaps I would have used this same approach.
>>>>>
>>>>> Sorry for my ignorance, but for TXTIME is the hardware capable of
>>>>> reordering or the user is supposed to know how to send packets?
>>>>
>>>> At least the hardware that I am familiar with doesn't reorder packets.
>>>>
>>>> For TXTIME, we have ETF (the qdisc) that re-order packets. The way
>>>> things work when taprio and ETF are used together is something like
>>>> this: taprio only has enough knowledge about TXTIME to drop packets 
>>>> that
>>>> would be transmitted outside their "transmission window" (e.g. for
>>>> traffic class 0 the transmission window is only for 10 to 50, the 
>>>> TXTIME
>>>> for a packet is 60, this packet is "invalid" and is dropped). And then
>>>> when the packet is enqueued to the "child" ETF, it's re-ordered and 
>>>> then
>>>> sent to the driver.
>>>>
>>>> And this is something that this patch breaks, the ability of dropping
>>>> those invalid packets (I really wouldn't like to do this verification
>>>> inside our drivers). Thanks for noticing this.
>>>>
>>>
>>> Hmm, indeed, I missed that check (we don't use ETF currently). I'm not
>>> sure of the best way forward, but here are a few thoughts:
>>> . The problem only arises for full-offload taprio, not for the software
>>> or TxTime-assisted cases.
>>> . I'm not sure mixing taprio(full-offload) with etf(no-offload) is very
>>> useful, at least with small gate intervals: it's likely you will miss
>>> your window when trying to send a packet at exactly the right time in
>>> software (I am usually testing taprio with a 2ms period and a 4µs
>>> interval for the RT stream).
>>> . That leaves the case of taprio(full-offload) with etf(offload). Right
>>> now with the current stmmac driver config, a packet whose tstamp is
>>> outside its gate interval will be sent on the next interval (and block
>>> the queue).
>>
>> This is the case that is a bit problematic with our hardware. (full 
>> taprio
>> offload + ETF offload).
> 
> Based on your previous comment to Michael, this is starting to look a 
> lot like a work-around for a hardware bug. Would moving it to the 
> corresponding driver really be out of the question?
> Note: there are currently only 4 drivers implementing ETF (including 2 
> from Intel), so validating their behavior with late packets would likely 
> be doable if needed.
> 
>>> . The stmmac hardware supports an expiryTime, currently unsupported in
>>> the stmmac driver, which I think could be used to drop packets whose
>>> tstamps are wrong (the packet would be dropped once the tstamp
>>> "expires"). We'd need to add an API for configuration though, and it
>>> should be noted that the stmmac config for this is global to the MAC,
>>> not per-queue (so a config through sch-etf would affect all queues).
>>> . In general using taprio(full-offload) with etf(offload) will incur a
>>> small latency penalty: you need to post the packet before the ETF qdisc
>>> wakes up (plus some margin), and the ETF qdisc must wake up before the
>>> tx stamp (plus some margin). If possible (number of streams/apps <
>>> number of hw queues), it would be better to just use
>>> taprio(full-offload) alone, since the app will need to post the packet
>>> before the gate opens (so plus one margin, not 2).
>>
>> It really depends on the workload, and how the schedule is organized,
>> but yeah, that might be possible (for some cases :-)).
>>
>>>
>>>
>>>>>
>>>>> My biggest problem with this patch is that unless the application is
>>>>> very careful that WARN_ON_ONCE(1) will trigger. E.g. if softirq is
>>>>> servicing the queue when the application sends - the qdisc will not
>>>>> be bypassed, right?
>>>
>>> See above, unless I'm mistaken the "root" qdisc is never
>>> enqueued/dequeued for multi-queue aware qdiscs.
>>>
>>
>> That's true, mq and mqprio don't have enqueue()/dequeue(), but I think
>> that's more a detail of their implementation than a rule (that no
>> multiqueue-aware root qdisc should implement enqueue()/dequeue()).
>>
>> That is, from my point of view, there's nothing wrong in having a root
>> qdisc that's also a shaper/scheduler.
>>
>>>>>> I am now thinking if this idea locks us out of anything.
>>>>>>
>>>>>> Anyway, a nicer alternative would exist if we had a way to tell 
>>>>>> the core
>>>>>> "this qdisc should be bypassed" (i.e. don't call enqueue()/dequeue())
>>>>>> after init() runs.
>>>>>
>>>
>>> Again, I don't think enqueue/dequeue are called unless the HW queues
>>> point to the root qdisc. But this does raise an interesting point: the
>>> "scheduling" issue I observed was on the dequeue side, when all the
>>> queues were dequeued within the RT process context. If we could point
>>> the enqueue side to the taprio qdisc and the dequeue side to the child
>>> qdiscs, that would probably work (but I fear that would be a significant
>>> change in the way the qdisc code works).
>>
>> I am wondering if there's a simpler solution, right now (as you pointed
>> out) taprio traverses all queues during dequeue(), that's the problem.
>>
>> What I am thinking is if doing something like:
>>
>>       sch->dev_queue - netdev_get_tx_queue(dev, 0);
>>
>> To get the queue "index" and then only dequeuing packets for that queue,
>> would solve the issue. (A bit ugly, I know).
>>
>> I just wanted to write the idea down to see if any one else could find
>> any big issues with it. I will try to play with it a bit, if no-one
>> beats me to it.
> 
> I looked into it this morning, but I'm not sure how that would work. 
> With the current code, when qdisc_run() is executed sch->dev_queue will 
> always be 0 (sch being the taprio qdisc), so you'd need my proposed 
> patch or something similar for sch to point to the child qdiscs, but at 
> that point you'd also be bypassing the taprio qdisc on enqueue.
> 
> If removing the TxTime check inside taprio_queue remains difficult, I am 
> wondering if keeping my patch with the change below would work (not 
> tested):
> ***********************************************************************
> @@ -4206,7 +4206,10 @@ static int __dev_queue_xmit(struct sk_buff *skb, 
> struct net_device *sb_dev)
>                  skb_dst_force(skb);
> 
>          txq = netdev_core_pick_tx(dev, skb, sb_dev);
> -       q = rcu_dereference_bh(txq->qdisc);
> +       if (dev->qdisc->enqueue)
> +               q = dev->qdisc;
> +       else
> +               q = rcu_dereference_bh(txq->qdisc);
> 
>          trace_net_dev_queue(skb);
>          if (q->enqueue) {
> ***********************************************************************
> One risk though for multiqueue-aware qdiscs that define an enqueue (only 
> taprio is in that case today) is that the child qdisc selected by 
> enqueue would not match the txq from netdev_core_pick_tx, so in the end 
> we would call qdisc_run on the wrong qdisc...
> 

I haven't had much time to work on this, but the "naive" approach I 
described just above didn't work as is.

More importantly, I thought this patch was still under discussion, yet 
it seems it got merged into netdev, and on May 13th, so even before this 
thread started...
Did I miss something in the submission process?

> 
>>>
>>>>> I don't think calling enqueue() and dequeue() is a problem. The 
>>>>> problem
>>>>> is that RT process does unrelated work.
>>>>
>>>> That is true. But this seems like a much bigger (or at least more
>>>> "core") issue.
>>>>
>>>>
>>>> Cheers,
>>>>
>>>
>>
>>
>> Cheers,
>>
> 

