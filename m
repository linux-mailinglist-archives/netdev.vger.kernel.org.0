Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F003A36AA9B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhDZCfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:35:13 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:55093 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhDZCfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:35:12 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 299A98006E;
        Mon, 26 Apr 2021 02:34:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6MM3ZupdAqqO5Lrw1cVL0Hp15mracjBlCzljVwkmAUp072ManHvLFP2zZieb8ROQgrqGg4O5clTGAReBzs11C9Irf7JcjCItkcT/lAGtfeEIaxdBGt1L79ngSkSeESAPqukwsBHrWSlAjjOffwVyAoCqtQmbMHvjvRkZZStA5j5PLyEaP1mTwX/YeHUoREvenfG0WlR0/0yRYHDokjne9xMrcqIuhnViKcrW0yzhiY9+C64zf6VpGs6YCJKvmJyW5wcQn1SnsZ3XFfVcMiRppgRHYUIvkmO+4PLZ2L663mLT/umTboi1QTJfwHY/RO0keJoYAKygdeFh00u9Yci1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzucKHPJmkB901NMa/FTiGc+7oSiG/+OExf6/c4Dg1g=;
 b=HYLw8vQCSQ18FUvn/mbvM1lFlj028S1H3HORW1ct/BY92BDl3MrpG09l6aCLHclCuMKQqxfJPDAar+icKgMa/nwqTLsRbssxma9RCh01A4hu820Kbet+pe0TdYz54Qy3Xzeb5uXzce8PJ+MkN+oI6c/Nbe79cJIFuYMOoW1jSrxf2y24my1WLacHROR0fFToIph9ZA41c+ySs26lkVnpLKTaK10mhwifovgyM+CySM9BLGqRuUgvOkkVeJKK/U7JeuceoH2t4F0jHlpWFtygb8PQH50L9/HVIT7upXmfQXR2LzR7mbWuzNAvitwXdPU1oMo2T6Tu5PlOFsr1+HSK0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzucKHPJmkB901NMa/FTiGc+7oSiG/+OExf6/c4Dg1g=;
 b=qHsW6ZuqJRnvGf0B9RNYCEyExlwm/C2o68NZ0T4HGp7Wl3B96mpdyw7r4Ow3yofGQeSyXXRWPXtmP7l8nYggZhf9DWV7in4nWAwOHWpW6hkDOPbW4jJoOmq3kL0H36RvQZCeSSbmpJEHrfdrbmQSg5zb1162my3I5bQwuOV4JoE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com (2603:10a6:20b:10d::12)
 by AS8PR08MB5991.eurprd08.prod.outlook.com (2603:10a6:20b:29f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Mon, 26 Apr
 2021 02:34:28 +0000
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3]) by AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 02:34:28 +0000
From:   Leonard Crestez <lcrestez@drivenets.com>
Subject: Re: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mathis <mattmathis@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        John Heffner <johnwheffner@gmail.com>
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com>
Message-ID: <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com>
Date:   Mon, 26 Apr 2021 05:34:25 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.96.81.202]
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To AM7PR08MB5511.eurprd08.prod.outlook.com
 (2603:10a6:20b:10d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lcrestez-mac.local (78.96.81.202) by LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25 via Frontend Transport; Mon, 26 Apr 2021 02:34:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84290cce-deb1-41f9-1548-08d9085bd066
X-MS-TrafficTypeDiagnostic: AS8PR08MB5991:
X-Microsoft-Antispam-PRVS: <AS8PR08MB5991F467DBA90586FD2FECCCD5429@AS8PR08MB5991.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Knvk61iwOR8HgoocEZNjj1fv5zcbj2407uDjF+zKXT68Dc8PwkuwDilygSCXlP7mZ4C7drWxDv/6m1HfB8AIoKgLJq+YPlDWKe6MAKB+786HCt7zpkHTqfLJzurJpPDr0Xcb9GxLHhWp4xXbv/JBykuHm8H11bMjfJZudww3AqkembtndoUOTKDeghJDm+JUlydpXCQqsZodJDt3E3Y4MLzr5YqYmCs2WyTFIILTZjKKHBtBYPeEqUiQ2q6CreS6yX/mpV3Nx2pRKDEttH0BRJvVi/QvaSGnFje7kF8sv+NWfN7aPGSNvFhiGbLLZc4lmQmS+7CQtzWlgqEk30KpwhpwywLOSHzqnE9ZvoPKXtYOBt52Ls83i7IEwsMW3/1ct+hfRFyqzjUhZUYp7KqoIm6HXo4LfEBbYdNUPfGynlAXiVL05YI15vKrrHL/2EeCTMAIEh/Q9c23CSB5M0QOv5iYiT3mOC8PoAdT7omFagRE0uaC57ue65N9vTwHqwoKI/XhuLpJ9OYpn8SSWam/ZnTghB8+dMbMnyZiCL5QvsPY39hR2ba8p/Ou3srhzezowurw0zXNizpkfo5AF1oktiVMHPeR0Chfx4szq5YAgoZ6p12+fmOGr8L7r5CbNcqVxRJ9kmaoNsrBW71zBEPwmOReIT/yxg1kJ1Q/3/VzRNo7xnAowG74Rc9NUULHs4/XX67+2MMZnMXRCDUpuOLkeL3Tjf0XkrXuUD9yyOWybXGamg+DgRK/WrRSgM0atNxmBXAH294vI+Ecw/rTw6qqyPfcs0zhZqg+cIUJXMd1Yk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5511.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39830400003)(366004)(376002)(966005)(478600001)(86362001)(16526019)(52116002)(66946007)(31696002)(7416002)(38100700002)(6512007)(66476007)(2616005)(66556008)(38350700002)(36756003)(26005)(5660300002)(83380400001)(4326008)(186003)(31686004)(54906003)(6486002)(8676002)(6916009)(316002)(2906002)(8936002)(6506007)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ODRFWCtYcXBpZ0VlSnZhcjFSTkIvTms0Yml2MkVIbWxFYXJxMlBTM0VMUm9J?=
 =?utf-8?B?WHo1Zi9QQUEvRFI0MDY5VGw0dU9MZ0FXd04vV21GK0JBS2wyTjl3K0JQamdI?=
 =?utf-8?B?VEF3eWJ6NDI4OHJKOTZ6QXhkNmxLRTVucUw5eHJNQ2hMazFza1JZZDR2bW1S?=
 =?utf-8?B?NjJESTZTcmpBbGxOenB5N2VmNmxNV2tmbkdBdlRMa2VXZnpsWEkzQWdoaUFX?=
 =?utf-8?B?Qk1WdUgrVGtZQ0RhVWxRUWdzbWw2aFpFanBmM0dLRkJYZHRHZ0w0RFFFTlR0?=
 =?utf-8?B?UjQyNG15M3J5T0dmWkx3aDk3dFVzWkJZdFcvRVBPeGVEVzIwcEo3OGYrbWRM?=
 =?utf-8?B?cFZFZ2hQdVNwVDEyOTk4STVIaUt6TC9wdEdZbzJwdVdldE95WDdsWW9Ja0Fh?=
 =?utf-8?B?WjBmWFdVZ204a050RlhmQXpBUHhmYUdxOUVYMWVIeWpzT1BxTHpLWWdRQjdw?=
 =?utf-8?B?ZTZzRHA2OHVuU2JrTXE0cE1SdlNGU296VmdMNDFCNW5td0x3cVlMeERTQSt4?=
 =?utf-8?B?dTZEbUd3M0ZQREk0RDdMblFtZ1ZFUHFKUDBlS253aG9ZaXpLRld1dllrUzF4?=
 =?utf-8?B?azlhRjM5aXNvVDFDWkZUaXFLZGpzbWY1blByMGY2Um9qR1NkdU5CcWJ6QWtD?=
 =?utf-8?B?SkJFYnZ6enRZUE1lam9ReGYwSGJJQ0FFQ2UyZzBBWWZvTkFMRTduNjNsKzkr?=
 =?utf-8?B?aVYxM1VPaTJWWmY1SkEwZ2lGcWFOSVlxVElpb1Q0TEFFOGs5TjArVWlGRGRl?=
 =?utf-8?B?N3QvazU2NFN0TXR4azRWbXlJOUhXcmh3dEN2TmRZOHdvYy9mU2o3OU02ZnFm?=
 =?utf-8?B?RkR5eFBYTnZJT0IyRnpyQ0VsMWphNnkrb1NNSkJmR2RadlNFai9sWEovMUgz?=
 =?utf-8?B?QlNkSzNONEVFa0p0Qm9tSXZQMjA3UDNLUmJrRHZCTWZDT1RlOFJhVjdRa3Fh?=
 =?utf-8?B?aUhJUXM2TWJOUkZ2U2dOaUdFVTFxMDJRK0Y2OTUyME5reEhhVUs0MWh5ZHh1?=
 =?utf-8?B?cHNpZVFzcHpDQjNYVklYNWM4OWsvdHl2L24yQmlpc2U3NXhlWWYwL2RuZy82?=
 =?utf-8?B?ZU1mS3JlYlhXSlpyVFZwMDVxRjRCMVRaakhYMDIzYlVSdm5VMDM2dzhjUWVD?=
 =?utf-8?B?QWtmYUVFeGtCWGp2YnFCbERaMHNqZEc0dWphajg4bngyRDNYNFlCdUJOazRF?=
 =?utf-8?B?ZGEwN1pnMVd1VFdyR1U1d1ovdjV0N1I1d1J0Mm9rTVc2cVkwSGxpcHJZcWNV?=
 =?utf-8?B?ejBCeDZGek1qd1RMM2xrMzdENVM3MEhzVlhjUTBxZTY2eVJiQUxmTlVGQmpF?=
 =?utf-8?B?clNQdUZ6YzNJbVNjVkw0enBUVzJEZko0TlF4ckJoUU1BZ2Y4ZHpGWFhGNGVz?=
 =?utf-8?B?ZHVPVFZRWDd0enk2cG5NQjFMVDA5dWlyREZFVEozbFN4b2Y5aTlZekIrU3U3?=
 =?utf-8?B?WE8wQnZmaTFLb01BNVNhTlVRZitETERtUWFWWElldUp3MU9JRWVucVNiOU9E?=
 =?utf-8?B?S3ZXdEJwYzBEVkxJVmc4SFUrVkx3dHhkaUdndkZlNlJteDRoQ0hGRjJsZlZJ?=
 =?utf-8?B?S2pvM29HSTQ4d1ZjZWxGWnZlbTFZWjdwT1cweUVlSTBGN1hmdytJa2xZNy96?=
 =?utf-8?B?L1FGQU9YOHpJVHBDQlhDVFVJMnhsZERlSWN5OXZ2a1BpZzBwYnNzZHdFcmtr?=
 =?utf-8?B?NjdQYWxQWmMzUTh0Qmh5T1JDVTh1REFTa3lhZE5IanFVQVA4WHNiNFZiSmJz?=
 =?utf-8?Q?MeoKVgjMZLi6JrC3fAv1UToQ75qH423AEBMooeY?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84290cce-deb1-41f9-1548-08d9085bd066
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5511.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 02:34:28.1720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkPSVR9GtVL/zTiD1db6J6DlL2sF2cXaQClGnRkOFHTqz69Bh6ASkmI9XTFK6sMpu90efXZQtu67ypUDa3JnrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5991
X-MDID: 1619404469-agaEpF7xxM3z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 3:47 PM, Neal Cardwell wrote:
> On Wed, Apr 21, 2021 at 6:21 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
>> in order to accumulate enough data" but linux almost never does that.
>>
>> Linux waits for probe_size + (1 + retries) * mss_cache to be available
>> in the send buffer and if that condition is not met it will send anyway
>> using the current MSS. The feature can be made to work by sending very
>> large chunks of data from userspace (for example 128k) but for small writes
>> on fast links probes almost never happen.
>>
>> This patch tries to implement the "MAY" by adding an extra flag
>> "wait_data" to icsk_mtup which is set to 1 if a probe is possible but
>> insufficient data is available. Then data is held back in
>> tcp_write_xmit until a probe is sent, probing conditions are no longer
>> met, or 500ms pass.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>>
>> ---
>>   Documentation/networking/ip-sysctl.rst |  4 ++
>>   include/net/inet_connection_sock.h     |  7 +++-
>>   include/net/netns/ipv4.h               |  1 +
>>   include/net/tcp.h                      |  2 +
>>   net/ipv4/sysctl_net_ipv4.c             |  7 ++++
>>   net/ipv4/tcp_ipv4.c                    |  1 +
>>   net/ipv4/tcp_output.c                  | 54 ++++++++++++++++++++++++--
>>   7 files changed, 71 insertions(+), 5 deletions(-)
>>
>> My tests are here: https://github.com/cdleonard/test-tcp-mtu-probing
>>
>> This patch makes the test pass quite reliably with
>> ICMP_BLACKHOLE=1 TCP_MTU_PROBING=1 IPERF_WINDOW=256k IPERF_LEN=8k while
>> before it only worked with much higher IPERF_LEN=256k
>>
>> In my loopback tests I also observed another issue when tcp_retries
>> increases because of SACKReorder. This makes the original problem worse
>> (since the retries amount factors in buffer requirement) and seems to be
>> unrelated issue. Maybe when loss happens due to MTU shrinkage the sender
>> sack logic is confused somehow?
>>
>> I know it's towards the end of the cycle but this is mostly just intended for
>> discussion.
> 
> Thanks for raising the question of how to trigger PMTU probes more often!
> 
> AFAICT this approach would cause unacceptable performance impacts by
> often injecting unnecessary 500ms delays when there is no need to do
> so.
> 
> If the goal is to increase the frequency of PMTU probes, which seems
> like a valid goal, I would suggest that we rethink the Linux heuristic
> for triggering PMTU probes in the light of the fact that the loss
> detection mechanism is now RACK-TLP, which provides quick recovery in
> a much wider variety of scenarios.

> After all, https://tools.ietf.org/html/rfc4821#section-7.4 says:
> 
>     In addition, the timely loss detection algorithms in most protocols
>     have pre-conditions that SHOULD be satisfied before sending a probe.
> 
> And we know that the "timely loss detection algorithms" have advanced
> since this RFC was written in 2007. >
> You mention:
>> Linux waits for probe_size + (1 + retries) * mss_cache to be available
> 
> The code in question seems to be:
> 
>    size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;

As far as I understand this is meant to work with classical retransmit: 
if 3 dupacks are received then the first segment is considered lost and 
probe success or failure is can determine within roughly 1*rtt. RACK 
marks segments as lost based on echoed timestamps so it doesn't need 
multiple segments. The minimum time interval is only a little higher 
(5/4 rtt). Is this correct?

> How about just changing this to:
> 
>    size_needed = probe_size + tp->mss_cache;
> 
> The rationale would be that if that amount of data is available, then
> the sender can send one probe and one following current-mss-size
> packet. If the path MTU has not increased to allow the probe of size
> probe_size to pass through the network, then the following
> current-mss-size packet will likely pass through the network, generate
> a SACK, and trigger a RACK fast recovery 1/4*min_rtt later, when the
> RACK reorder timer fires.

This appears to almost work except it stalls after a while. I spend some 
time investigating it and it seems that cwnd is shrunk on mss increases 
and does not go back up. This causes probes to be skipped because of a 
"snd_cwnd < 11" condition.

I don't undestand where that magical "11" comes from, could that be 
shrunk. Maybe it's meant to only send probes when the cwnd is above the 
default of 10? Then maybe mtu_probe_success shouldn't shrink mss below 
what is required for an additional probe, or at least round-up.

The shrinkage of cwnd is a problem with this "short probes" approach 
because tcp_is_cwnd_limited returns false because tp->max_packets_out is 
smaller (4). With longer probes tp->max_packets_out is larger (6) so 
tcp_is_cwnd_limited returns true even for a cwnd of 10.

I'm testing using namespace-to-namespace loopback so my delays are close 
to zero. I tried to introduce an artificial delay of 30ms (using tc 
netem) and it works but 20ms does not.

> A secondary rationale for this heuristic would be: if the flow never
> accumulates roughly two packets worth of data, then does the flow
> really need a bigger packet size?

The problem is that "accumulating sufficient data" is an extremely fuzzy 
concept. In particular it seems that at the same traffic level 
performing shorter writes from userspace (2kb instead of 64k) can 
prevent mtu probing entirely and this is unreasonable.

--
Regards,
Leonard
