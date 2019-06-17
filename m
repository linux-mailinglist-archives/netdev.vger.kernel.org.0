Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB71647D8C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfFQItp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:49:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:41062 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQItp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 04:49:45 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hcnKe-0007WH-Aw; Mon, 17 Jun 2019 10:49:40 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hcnKe-000XPn-4B; Mon, 17 Jun 2019 10:49:40 +0200
Subject: Re: VLAN tags in mac_len
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        jhs@mojatatu.com, David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        Simon Horman <simon.horman@netronome.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
 <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
 <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fa2b9787-c658-ac49-1c35-0d84d52b3ec1@iogearbox.net>
Date:   Mon, 17 Jun 2019 10:49:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25483/Mon Jun 17 09:56:00 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/15/2019 09:19 PM, Johannes Berg wrote:
> Hi Alexei,
> 
> Sorry for messing up your address btw, not sure where I dug that one
> up...
> 
>>>  1) Make the bridge code use skb->mac_len instead of ETH_HLEN. This
>>>     works for this particular case, but breaks some other cases;
>>>     evidently some places exist where skb->mac_len isn't even set to
>>>     ETH_HLEN when a packet gets to the bridge. I don't know right now
>>>     what that was, I think probably somebody who's CC'ed reported that.
>>>
>>>  2) Let tc_act_vlan() just pull ETH_HLEN instead of skb->mac_len, but
>>>     this is rather asymmetric and strange, and while it works for this
>>>     case it may cause confusion elsewhere.
>>>
>>>  2b) Toshiaki said it might be better to make that code *remember*
>>>      mac_len and then use it to push and pull (so not caring about the
>>>      change made by skb_vlan_push()), but that ultimately leads to
>>>      confusion and if you have TC push/pop combinations things just get
>>>      completely out of sync and die
>>>
>>>  3) Make skb_vlan_push()/_pop() just not change mac_len at all. So far
>>>     this also addresses the issue, but it's likely that this will break
>>>     OVS, and I don't know how it'd affect BPF. Quite possibly like TC
>>>     does and is broken, but perhaps not.
>>>
>>>
>>> But now we're stuck. Depending on how you look at it, all of these seem
>>> sort of reasonable, or not.
>>>
>>> Ultimately, the issue seems to be that we couldn't really decide whether
>>> VLAN tags (and probably MPLS tags, for that matter) are covered by
>>> mac_len or not. At least not consistently on ingress and egress.
>>> eth_type_trans() doesn't take them into account, so of course on simple
>>> ingress mac_len will only cover the ETH_HLEN.
>>>
>>> If you have an accelerated tag and then push it into the SKB, it will
>>> *not* be taken into account in mac_len. OTOH, if you have a new tag and
>>> use skb_vlan_push() then it *will* be taken into account.
>>>
>>>
>>> I'm trending towards solution (3), because if we consider other
>>> combinations of VLAN push/pop in TC, I think we can end up in a very
>>> messy situation today. For example, POP/PUSH seems like it should be a
>>> no-op, but it isn't due to the mac_len, *unless* it can use the HW accel
>>> only (i.e. only a single tag).
>>>
>>> I think then to propose such a patch though we'd have to figure out
>>> where the BPF case is, and to keep OVS working probably either add an
>>> argument ("bool adjust_mac_len") to the function signatures, or just do
>>> the adjustments in OVS code after calling them?
>>>
>>>
>>> Any other thoughts?
>>
>> imo skb_vlan_push() should still change mac_len.
>> tc, ovs, bpf use it and expect vlan to be part of L2.
> 
> I'm not sure tc really cares, but it *is* a reasonable argument to make.
> 
> Like I said, whichever way I look at the problem, a different solution
> looks more reasonable ;-)

Agree with Alexei that the approach which would be least confusing and/or
potentially causing regressions might be to go for 1). tc *does* care at least
for the *BPF* case. In sch_clsact we have the ingress and egress hook where we
can attach to and programs don't need to care where they are being attached
since for both cases they see skb->data starting at eth header! In order to
do this, we do a __skb_push()/__skb_pull() dance based on skb->mac_len depending
from where we come. This also means that if a program pushed/popped a vlan tag,
this still must be correct wrt expectations for the receive side. It is essential
that there is consistent behavior on skb->mac_len given skbs can also be redirected
from TX->RX or RX->TX(->RX), so that we don't pull to a wrong offset next time.

Thanks,
Daniel
