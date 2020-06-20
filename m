Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D822021C9
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 08:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgFTGCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 02:02:30 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:43136 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgFTGCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 02:02:30 -0400
X-Greylist: delayed 30679 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jun 2020 02:02:29 EDT
Received: from [192.168.178.106] (pd95efea6.dip0.t-ipconnect.de [217.94.254.166])
        by mail.bugwerft.de (Postfix) with ESMTPSA id D3F4742AEE5;
        Sat, 20 Jun 2020 06:02:28 +0000 (UTC)
Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
To:     Andrew Lunn <andrew@lunn.ch>,
        Jason Cobham <jcobham@questertangent.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
 <20200619215817.GN279339@lunn.ch>
 <72f92622c69143b0880125dfe9f9a955@questertangent.com>
 <20200619223606.GO279339@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <eb6b5f84-2a5a-1938-0657-0eac9f2390df@zonque.org>
Date:   Sat, 20 Jun 2020 08:02:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619223606.GO279339@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/20 12:36 AM, Andrew Lunn wrote:
>> I've run into the same issue. To resolve it,  In my case, in the same file, I've had to send all IGMP control traffic to the CPU:
>> 	skb->offload_fwd_mark = 1;
>> 	switch (ih->type) {
>> 		case IGMP_HOST_MEMBERSHIP_REPORT:
>> 		case IGMPV2_HOST_MEMBERSHIP_REPORT:
>> 		case IGMPV3_HOST_MEMBERSHIP_REPORT:
>> 		case IGMP_HOST_MEMBERSHIP_QUERY:
>> 		case IGMP_HOST_LEAVE_MESSAGE:
>> 			skb->offload_fwd_mark = 0;
>> 		break;
>> 	}
>>
>> I'd be interested if there is a better way.
> 
> It might depend on the switch generation, but i think some switches
> indicate the sort of packet in the DSA header. For 6390, Octet 3 of
> the header, bits 3-5 contains a code.
> 
> 0=BDPU
> 1=Frame2Reg
> 2=IGMP/MLD
> 3=Policy
> 4=ARP Mirror
> 5=Policy Mirror
> 
> We can look at these bits and not set skb->offload_fwd_mark depending
> on its value.
> 
> The 6352 family has the same bits. 6161 has a few less bits, but does
> have IGMP/MLD. I don't know about the 6085. Do you have the datasheet?

Sorry, I was mistaken in the model the board is using, it's a 6352.

So yes, we can read the code here, but I'm wondering which packet types
would then get this flag set, and which won't. Because in case of
IGMP/MLD, the packets are in fact forwarded, but the meaning of the flag
in skb is to prevent the skb from being forwarded further, which seems
wrong in all cases.

I'm thinking maybe the flag should never be set?


Thanks,
Daniel
