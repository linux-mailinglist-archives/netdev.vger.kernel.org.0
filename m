Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B083E2025CA
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgFTSBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 14:01:40 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:45314 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728204AbgFTSBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 14:01:40 -0400
Received: from [192.168.178.106] (pd95efea6.dip0.t-ipconnect.de [217.94.254.166])
        by mail.bugwerft.de (Postfix) with ESMTPSA id CFEDF42B018;
        Sat, 20 Jun 2020 18:01:38 +0000 (UTC)
Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jason Cobham <jcobham@questertangent.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
 <20200619215817.GN279339@lunn.ch>
 <72f92622c69143b0880125dfe9f9a955@questertangent.com>
 <20200619223606.GO279339@lunn.ch>
 <eb6b5f84-2a5a-1938-0657-0eac9f2390df@zonque.org>
 <20200620143518.GG304147@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <62c2327e-0094-3369-fc38-7f434324a348@zonque.org>
Date:   Sat, 20 Jun 2020 20:01:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200620143518.GG304147@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/20 4:35 PM, Andrew Lunn wrote:
>> So yes, we can read the code here, but I'm wondering which packet types
>> would then get this flag set, and which won't. Because in case of
>> IGMP/MLD, the packets are in fact forwarded, but the meaning of the flag
>> in skb is to prevent the skb from being forwarded further, which seems
>> wrong in all cases.
>>
>> I'm thinking maybe the flag should never be set?
> 
> It is a while since i did much with multicast, so please correct me
> when i'm wrong...
> 
> IGMP can use different group addresses as far as i remember.
> Join/leave uses the group address of interest. But query can use
> 224.0.0.1 or the group address.
> 
> The bridge should learn from joins, either spontaneous or as a reply
> to a query. When it sees a join, it should add a multicast FDB to the
> hardware for the group, so traffic is forwarded out that port.

Yes, except it's the MDB in this case. But the bridge must also forward
the IGMP queries and reports to other ports, otherwise a cascaded
multicast router won't see the membership reports and hence won't send
frames to our switch.

> So for real multicast traffic, we do want the flag set, the hardware
> should be doing the forwarding. If we don't set the flag, we end up
> with duplication when the SW bridge also forwards the multicast
> traffic.

Yes, agreed.

> For IGMP/MLD itself, we probably need to see what the switch does. For
> IGMP using the group address, does the multicast FDB rule match and
> cause the hardware to forward the IGMP?

No, because snooping is enabled on all ports of the switch by the
driver, all IGMP frames are redirected to the CPU port and not egressed
on any other port, regardless of the entries in the ATU.

> If yes, then we need the flag
> set, otherwise the IGMP gets duplicated. If no, then we don't want the
> flag set, and leave the SW bridge to do the forwarding, 

Exactly.

> or reply
> itself if it is the querier.

If it has memberships itself.

> 6352 uses the EDSA tagger. But the same bits exist in the DSA tag,
> which the 6390 uses, due to incompatibility reasons. So it would be
> nice to extend both taggers.

But the tag format seems to be a bit different on EDSA from what you
described in your other mail. In my datasheet, the code bits are spread
across octet 2 and 3.

I'll send a patch for EDSA that works for me and solves the problem I
had, and then leave it to someone with access to the datasheets of
variants implementing the DSA tagging to replicate and test that.


Thanks for your help!
Daniel
