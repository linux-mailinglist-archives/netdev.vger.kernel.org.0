Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD4C430853
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 13:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245469AbhJQLZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 07:25:01 -0400
Received: from mail-ssdrsserver2.hostinginterface.eu ([185.185.85.90]:56798
        "EHLO mail-ssdrsserver2.hostinginterface.eu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241903AbhJQLY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 07:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bobbriscoe.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0UA4tXlXVjxMRLtbcPxYVdZJf8ukkS6nBk3kdL6DRRc=; b=Wc9uFj4XNqs4mgiOmIb51X0be0
        rO/KPExfl+YUPgwLO0qo2U/KqusnXsHx0ryefmSJ6jtu8iM8h3DWd4aQd7KTXqA6urWynmwWYZLFx
        ZDIHPs7t0Kr7b5a4ovTBoMVWD9XajT3zJxZQOCErWh7RQcm+E1LvBDpZF22bZvcXDXOsxVlrnyDsd
        iuH6nqePn/Nvbg2tydACCws1YAiL7vvFrumKlt+6spiJDOU3Y+JmCRHpvvZ8YwBbD5lMkTFZExsjH
        +XblAuL60zxNYS2Gxn9Cpd8ZXcIqyKv5/d1Z3zInF5s+PRfvaB259LvWA0ca67KfesDbc03JI0yeV
        YdF6TCzw==;
Received: from 67.153.238.178.in-addr.arpa ([178.238.153.67]:38292 helo=[192.168.1.11])
        by ssdrsserver2.hostinginterface.eu with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ietf@bobbriscoe.net>)
        id 1mc4Fc-002nau-Ce; Sun, 17 Oct 2021 12:22:48 +0100
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     Jonathan Morton <chromatix99@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <87wnmf1ixc.fsf@toke.dk>
 <CANn89iLbJL2Jzot5fy7m07xDhP_iCf8ro8SBzXx1hd0EYVvHcA@mail.gmail.com>
 <87mtnb196m.fsf@toke.dk> <308C88C6-D465-4D50-8038-416119A3535C@gmail.com>
From:   Bob Briscoe <ietf@bobbriscoe.net>
Message-ID: <9ad3a249-1950-c665-5996-e15352867924@bobbriscoe.net>
Date:   Sun, 17 Oct 2021 12:22:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <308C88C6-D465-4D50-8038-416119A3535C@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ssdrsserver2.hostinginterface.eu
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bobbriscoe.net
X-Get-Message-Sender-Via: ssdrsserver2.hostinginterface.eu: authenticated_id: in@bobbriscoe.net
X-Authenticated-Sender: ssdrsserver2.hostinginterface.eu: in@bobbriscoe.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/10/2021 08:39, Jonathan Morton wrote:
>> On 15 Oct, 2021, at 2:24 am, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>>>>> Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latency,
>>>>> Low Loss, Scalable Throughput (L4S) style marking, along with ce_threshold.
>>>>>
>>>>> If enabled, only packets with ECT(1) can be transformed to CE
>>>>> if their sojourn time is above the ce_threshold.
>>>>>
>>>>> Note that this new option does not change rules for codel law.
>>>>> In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
>>>>> the default when fq_codel qdisc is created), ECT(0) packets can
>>>>> still get CE if codel law (as governed by limit/target) decides so.
>>>> The ability to have certain packets receive a shallow marking threshold
>>>> and others regular ECN semantics is no doubt useful. However, given that
>>>> it is by no means certain how the L4S experiment will pan out (and I for
>>>> one remain sceptical that the real-world benefits will turn out to match
>>>> the tech demos), I think it's premature to bake the ECT(1) semantics
>>>> into UAPI.
>>> Chicken and egg problem.
>>> We had fq_codel in linux kernel years before RFC after all :)
>> Sure, but fq_codel is a self-contained algorithm, it doesn't add new
>> meanings to bits of the IP header... :)
> I'll be blunter:
>
> In its original (and currently stable) form, fq_codel is RFC-compliant.  It conforms, in particular, to RFC-3168 (ECN).  There's a relatively low threshold for adding RFC-compliant network algorithms to Linux, and it is certainly not required to have a published RFC specifically describing each qdisc's operating principles before it can be upstreamed.  It just so happens that fq_codel (and some other notable algorithms such as CUBIC) proved sufficiently useful in practice to warrant post-hoc documentation in RFC form.
>
> However, this patch adds an option which, when enabled, makes fq_codel *non-compliant* with RFC-3168, specifically the requirement to treat ECT(0) and ECT(1) identically, unless conforming to another published RFC which permits different behaviour.
>
> There is a path via RFC-8311 to experiment with alternative ECN semantics in this way, but the way ECT(1) is used by L4S is specifically mentioned as requiring a published RFC for public deployments.  The L4S Internet Drafts have *just failed* an IETF WGLC, which means they are *not* advancing to publication as RFCs in their current form.

[BB] Clarification of IETF process: A first Working Group Last Call 
(WGLC) is nearly always the beginning of the end of the IETF's RFC 
publication process. Usually the majority of detailed comments arrive 
during a WGLC. Then the draft has to be fixed, and then it goes either 
directly through to the next stage (in this case, an IETF-wide last 
call), or to another WGLC.

> The primary reason for this failure is L4S' fundamental incompatibility with existing Internet traffic, despite its stated goal of general Internet deployment.

[BB] s/The primary reason /JM's primary objection /
There is no ranking of the reasons for more work being needed.  The WG 
had already developed a way to mitigate this objection. Otherwise, a 
WGLC would not have been started in the first place. Further work on 
this issue is now more likely to be wordsmithing.

I hope this level of brevity was useful for netdev. See tsvwg@ietf.org 
for details.


Bob

> It is my considered opinion, indeed, that moving *away* from ECT(1) as the L4S identifier is the best option for improving that compatibility.
>
> I believe there is a much higher threshold required for adding such things to publicly maintained versions of Linux (as opposed to privately maintained experimental versions).
>
> - Jonathan Morton

-- 
________________________________________________________________
Bob Briscoe                               http://bobbriscoe.net/

