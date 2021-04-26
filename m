Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093C736B792
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhDZRKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:10:03 -0400
Received: from dispatchb-eu1.ppe-hosted.com ([185.183.29.37]:16106 "EHLO
        dispatchb-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234767AbhDZRKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:10:01 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 62FEE7C0061;
        Mon, 26 Apr 2021 17:09:17 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyVsNwBgLnGmxErFF760NyzoPHguZe0Hq9ebfkCtU88HgrFToZ2k5sbC1tCCzYph++Q38BzMprl9QfpYv+Xt/upsVJwHDxDXVa7I5oHQkPPT2ZLa5WdRleZucbnh5agHAig74sYadPR5/4XFOqPb4ITRgiw5vBuBimEX/2VKoomiU0ipGwldGZggSqk/GBqJi90OYGCV1mkT8omG9uasW33TFez4t5zkqkjRUy/0YRIf4OSYoDwrpTTPUktiks89zvo3ObSwo+tt5z9ANAI7GtfBLuTIwZtlXwwhVkFpPl41F49XDVxYd3m2mRvERb22XBOStm2SjpDZDDR1Kd3MJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMR21/TtTCnl/mKR/AuTO+DnplJ64qL1Uuv4up8jI6s=;
 b=Ub0WCV5yT2sCMhv/aeWXa6kV1aEz0ajzye/4gUKd08EDCkWAHD2K0xVxh//wcKlBYXsLgqRE2EEJDrz/plm7SoNR/B+ktbCS7Ivbte7bAM2PvxFno8WuvAhjiTTW8L4khX0uYKxyfW1Xl4p/Tr76jeeooQR+lY2aQRJOCoWSsHsfqi84AYrX38PAAAW2J9NZP4EFWRAEnN/GTtEjeszvT5yJ34meZIPqcOTK+1xKmqATPz9RW9hRnyfKo8SHuV8Rb/e7v+FI652mqTfXqBgFbfL0kw6WFCM3zjAZll7T9x/UVBKGkqk63XHHgiOnio2/OL9hfZCZnVqckko9hfpQRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMR21/TtTCnl/mKR/AuTO+DnplJ64qL1Uuv4up8jI6s=;
 b=NsDULmQJIzF3m+/EElAs+aKrjBU+6CtG3lFJfjhqwgM14MxeoTM307Q5P0Tm9tgULDYwKawsbHuNpdUwr/+DEaIPcLN4VwrnkHioPV0Y0AJ7q20bzaxY0ADO4ovz34m036DmGyoc/bEeEASq4LMSDfs+7SmuH8M8LoUuQWgPm/o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com (2603:10a6:20b:10d::12)
 by AM7PR08MB5512.eurprd08.prod.outlook.com (2603:10a6:20b:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Mon, 26 Apr
 2021 17:09:16 +0000
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3]) by AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3%6]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 17:09:16 +0000
Subject: Re: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        John Heffner <johnwheffner@gmail.com>
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com>
 <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com>
 <CADVnQykBebycW1XcvD=NGan+BrJ3N1m5Q-pWs5vyYNmQQLjrBw@mail.gmail.com>
From:   Leonard Crestez <lcrestez@drivenets.com>
Message-ID: <5af52ab4-237f-8646-76e4-5e24236d9b4a@drivenets.com>
Date:   Mon, 26 Apr 2021 20:09:13 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CADVnQykBebycW1XcvD=NGan+BrJ3N1m5Q-pWs5vyYNmQQLjrBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.96.81.202]
X-ClientProxiedBy: LO3P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::10) To AM7PR08MB5511.eurprd08.prod.outlook.com
 (2603:10a6:20b:10d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lcrestez-mac.local (78.96.81.202) by LO3P265CA0005.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25 via Frontend Transport; Mon, 26 Apr 2021 17:09:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c42c61d1-f9d9-4bc8-666f-08d908d605a7
X-MS-TrafficTypeDiagnostic: AM7PR08MB5512:
X-Microsoft-Antispam-PRVS: <AM7PR08MB551284370C484EE82A96FFD0D5429@AM7PR08MB5512.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +i7n0+sLza8sxPY3rTD0fohfslbUdV3B/+t8WL/ggWNXs1L1yq3VOQpGugXG5XfiNr5FSu96A75Qtvd8nO1m6dT2AlX0vEekrm3+YTQNsR93m6Zf0D/DgWticVB2xFxCUR/U3//cq/Tig2BS8OcGf1TgRHSRSC3XC1X9g9eCNIfMh03DrEkZAxoouFhmgNk5Prc4OtAfxLnRN7QOmyOSak0DkLZh0Wbr68fsiBJ8lLSDDGrj9cI6XLz909Llb6zx9T3COf/kv7myuE20zOtdTB+hkPYGMJWf722F85Hyb9kIpUM/Ofwgp39KizmqEE9UEC57FEA7RwA0VV/fWq1PsNZapqItQp0sH//swgD9D5ARfIUU5BlTmjXALPXIHo/1EoW40PwcCZZiGkgcJVYWOorSbZ5G01J52gZwzkl2rCxz04qFDYRcwGiUuozF46cCLpjO+g5JN0AayIi4YUDv1GVRobuUdOiVb6kSkpTffcrYjQ+doaJGVaTTBQBpStGcQnwEG+XPKbxspLddlDMlL+ee4KDiPRIXgKz10p/ufQjdx0g4ochhLUVFeUzNwwgeN04lhNrULn2vGbD59YVB1WhJD8xLxJlyjXecvnVs1q8vWD45sxHQ7u7EHfFnrMODxvlDYlvqFLfuY0BWmI6gxH2EwfmrYFJqnLKCWcyjNmWKb9/MpieTOSpJRd/c1yUWjI2rQIMnqsCZPedDsUCmfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5511.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39840400004)(366004)(376002)(396003)(53546011)(6506007)(31696002)(16526019)(26005)(956004)(186003)(7416002)(2616005)(36756003)(316002)(86362001)(54906003)(110136005)(66556008)(478600001)(5660300002)(38100700002)(6512007)(38350700002)(2906002)(4326008)(8676002)(31686004)(83380400001)(66476007)(8936002)(66946007)(52116002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aER4UmVYQVd4S2dwdDVaSFZaVlcrRW4zTVNzcWFSWG1mcmpLV0UraVRjek5m?=
 =?utf-8?B?cmpzRU4vQVF5UFExcTYyYjluWVJCWTBTUFpDUVV1OXRRK3dBN3BkaEJkYmF1?=
 =?utf-8?B?NmVRT29HZmczUlkxLzkzVEZnTVlLR1FwN1pxbUhjbFBudWNEMmhsa1RQdlNR?=
 =?utf-8?B?SzQ4TEUrdFpWWFhGbDJsMjBxTzg5dW9LTEQ0YnNpTTJmSm9LYXc3cWV4azRO?=
 =?utf-8?B?VGVrZUl5aUE2VHI5OFZvaDZRMzhRUnhnY2Q4NGRCL1NjNENsa3g1QSs0WXpG?=
 =?utf-8?B?emV2eVA0N3JkbDgrQk90TER2aVAxVVNUamNkTzVOZXhXVFVCTkVCRXJwWW9k?=
 =?utf-8?B?UjZlRzd6Rnc5NUhDUWZzYjViYkpoczcvRW1uY2owTlI4UFF5ZVFhWFAxSmR4?=
 =?utf-8?B?ZGNDZXNJS2dySVZvRXFCRURGQTEzeDhHeXRMQ1c2aTlKU3hndXVJcDlkMEwz?=
 =?utf-8?B?bmdvd3M4WklKNDZTeERMSUlTdmFhUU1tL2xWbVdOSmFVSWgwaVlheExwYVMy?=
 =?utf-8?B?akVhRitNYWo5UmVZWm9Ea2ttVThROFIvTndabTFDaGw5OWlZUTUxYUY4aXJ3?=
 =?utf-8?B?dlhNQUc3SWpWMHNTZitycnNwMU0wL3Zra1N2ZnVEcnZCL0NqWTJhNXhVazhV?=
 =?utf-8?B?R2k0NnZlNGdBQWMzNkQyQXVNN0E5KzN4MW1FcnpzS2JiN29qbUdNeHVtNlEw?=
 =?utf-8?B?TUpUUGpqRVJWRjh3blFoVnlsbnFFZGN6QW01N3E1NmpJaHlNSmJhZnEvSE1Y?=
 =?utf-8?B?VFc3dE02amJUUUtBR28rMXc3amhNcFVuYnk2QURJRCtnREpuMmdWT253YkRV?=
 =?utf-8?B?V0xlV1RVTTBXMW9HazBDNWZHd205aDEyYmNzNzFDZjcvNmwwUWxReHNUaXJU?=
 =?utf-8?B?bWhvRXpzSzExKzlxQWpZM3d0cGxoV1dpdFZyaUwyT1pCeEZUMXFRWWxZRU1B?=
 =?utf-8?B?NXNzdGZiSnFLUGNoek0xeG03bEZYaGhSSWwrWHVmTDVLMzhyays2TGh6NExz?=
 =?utf-8?B?eGREbnZhb28xOE51b0tLR09Bc1F3eEpCa0lmbHF0OHhDQVB4SUFST1h2VnN1?=
 =?utf-8?B?eWRpSmZ3RTNuVFVxNkxvazFYaC9vbmQrYkhsWXlHMzFaeENTbjZSaFlVeG82?=
 =?utf-8?B?SWM0YStXZjhyRUp0RFN6cGFCb0hFYjY0eGN4QTNJQmZRWUxlWkxrb00xQ0dn?=
 =?utf-8?B?Nyt1SjlMMnZTcGhCM3ZwMUZSaERYM0JYRFFmWi8xQzJ2M1dxQzR3VjA4QnE4?=
 =?utf-8?B?U2ppaC9TMVVMc0J1enlNWG9DRVNwakp1ZDNMc1NSZ0I3TUhueW5qSVlkV2Mv?=
 =?utf-8?B?d3BJYzdkd1N2VnpBbTI3Q0lKUW1YRTUvT2VmdlVqcjhWcUViVWFLNkl4RzhJ?=
 =?utf-8?B?MENjV3hLZEJwcHpPVDlnMk1weGpaYmZrdnZvKzVPdEkxMFhWVXNqVzBwcmJR?=
 =?utf-8?B?UVMwMkc3TmczejVwUTZiQWFqMHgwZjcyUVNZYWRXL2JXRmlzK1FwSEN3aUp0?=
 =?utf-8?B?dnMvVGV4SUkxeUVnRE5WazV1ZE9OOHVNaWlVeWxKOGFuNG9lRGFqaTUrS3po?=
 =?utf-8?B?ckphZW45aG1jR0xkVXlTbGZqNVZicURER2FDN0sxWjBDRVhSRmVyMDgzUDBK?=
 =?utf-8?B?NDlXTllxNmtMalFMbFhmTHRvNDlpSW43Z1hGOXN6NzkvekdsWlAxeTVyRHM0?=
 =?utf-8?B?ZHR6NGNrMGtJSVdaL2trY01TSmhpYnowRzd5WFJobWcyck5zV05vQkRtSk1E?=
 =?utf-8?Q?/TDcqsoRafImkqh32ocw38lgO1zn1JoJY67nX6X?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42c61d1-f9d9-4bc8-666f-08d908d605a7
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5511.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 17:09:16.1143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cnag+3siUl+i4v6U5LDek4tK28xfVbJGeg6P8k1IPvFWmkXbDdWQiaHmMqR6koxuoe4MXEnQ6o7SEQ53sNP3pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5512
X-MDID: 1619456958-8LyWAdv5FtGY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.04.2021 18:59, Neal Cardwell wrote:
> On Sun, Apr 25, 2021 at 10:34 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
>> On 4/21/21 3:47 PM, Neal Cardwell wrote:
>>> On Wed, Apr 21, 2021 at 6:21 AM Leonard Crestez <cdleonard@gmail.com> wrote:

>>> If the goal is to increase the frequency of PMTU probes, which seems
>>> like a valid goal, I would suggest that we rethink the Linux heuristic
>>> for triggering PMTU probes in the light of the fact that the loss
>>> detection mechanism is now RACK-TLP, which provides quick recovery in
>>> a much wider variety of scenarios.
>>
>>> You mention:
>>>> Linux waits for probe_size + (1 + retries) * mss_cache to be available
>>>
>>> The code in question seems to be:
>>>
>>>     size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
>>> How about just changing this to:
>>>
>>>     size_needed = probe_size + tp->mss_cache;
>>>
>>> The rationale would be that if that amount of data is available, then
>>> the sender can send one probe and one following current-mss-size
>>> packet. If the path MTU has not increased to allow the probe of size
>>> probe_size to pass through the network, then the following
>>> current-mss-size packet will likely pass through the network, generate
>>> a SACK, and trigger a RACK fast recovery 1/4*min_rtt later, when the
>>> RACK reorder timer fires.
>>
>> This appears to almost work except it stalls after a while. I spend some
>> time investigating it and it seems that cwnd is shrunk on mss increases
>> and does not go back up. This causes probes to be skipped because of a
>> "snd_cwnd < 11" condition.
>>
>> I don't undestand where that magical "11" comes from, could that be
>> shrunk. Maybe it's meant to only send probes when the cwnd is above the
>> default of 10? Then maybe mtu_probe_success shouldn't shrink mss below
>> what is required for an additional probe, or at least round-up.
>>
>> The shrinkage of cwnd is a problem with this "short probes" approach
>> because tcp_is_cwnd_limited returns false because tp->max_packets_out is
>> smaller (4). With longer probes tp->max_packets_out is larger (6) so
>> tcp_is_cwnd_limited returns true even for a cwnd of 10.
>>
>> I'm testing using namespace-to-namespace loopback so my delays are close
>> to zero. I tried to introduce an artificial delay of 30ms (using tc
>> netem) and it works but 20ms does not.
> 
> I agree the magic 11 seems outdated and unnecessarily high, given RACK-TLP.
> 
> I think it would be fine to change the magic 11 to a magic
> (TCP_FASTRETRANS_THRESH+1), aka 3+1=4:
> 
>    - tp->snd_cwnd < 11 ||
>    + p->snd_cwnd < (TCP_FASTRETRANS_THRESH + 1) ||
> 
> As long as the cwnd is >= TCP_FASTRETRANS_THRESH+1 then the sender
> should usually be able to send the 1 probe packet and then 3
> additional packets beyond the probe, and in the common case (with no
> reordering) then with failed probes this should allow the sender to
> quickly receive 3 SACKed segments and enter fast recovery quickly.
> Even if the sender doesn't have 3 additional packets, or if reordering
> has been detected, then RACK-TLP should be able to start recovery
> quickly (5/4*RTT if there is at least one SACK, or 2*RTT for a TLP if
> there is no SACK).

As far as I understand tp->reordering is a dynamic evaluation of the 
fastretrans threshold to deal with environments with lots of reordering. 
Your suggestion seems equivalent to the current size_needed calculation 
except using packets instead of bytes.

Wouldn't it be easier to drop the "11" check and just verify that 
size_needed fits into cwnd as bytes?

--
Regards,
Leonard
