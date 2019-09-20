Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E70B9ACE
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437334AbfITXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:40:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:55974 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437324AbfITXkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:40:08 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iBSVN-0003sS-Uj; Sat, 21 Sep 2019 01:40:01 +0200
Received: from [178.197.248.15] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iBSVN-000X9e-KG; Sat, 21 Sep 2019 01:40:01 +0200
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin Shelar <pshelar@ovn.org>,
        Simon Horman <simon.horman@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <20190919.132147.31804711876075453.davem@davemloft.net>
 <vbfk1a41fr1.fsf@mellanox.com> <20190920091647.0129e65f@cakuba.netronome.com>
 <0e9a1701-356f-5f94-b88e-a39175dee77a@iogearbox.net>
 <20190920155605.7c81c2af@cakuba.netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a75fdbad-d1e3-d11e-ee13-de023aa38349@iogearbox.net>
Date:   Sat, 21 Sep 2019 01:40:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190920155605.7c81c2af@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25578/Fri Sep 20 10:21:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/19 12:56 AM, Jakub Kicinski wrote:
> On Sat, 21 Sep 2019 00:15:16 +0200, Daniel Borkmann wrote:
>> On 9/20/19 6:16 PM, Jakub Kicinski wrote:
>>> On Thu, 19 Sep 2019 15:13:55 +0000, Vlad Buslov wrote:
>>>> On Thu 19 Sep 2019 at 14:21, David Miller <davem@davemloft.net> wrote:
>>>>> As Linus pointed out, the Kconfig logic for CONFIG_NET_TC_SKB_EXT
>>>>> is really not acceptable.
>>>>>
>>>>> It should not be enabled by default at all.
>>>>>
>>>>> Instead the actual users should turn it on or depend upon it, which in
>>>>> this case seems to be OVS.
>>>>>
>>>>> Please fix this, thank you.
>>>>
>>>> Hi David,
>>>>
>>>> We are working on it, but Paul is OoO today. Is it okay if we send the
>>>> fix early next week?
>>>
>>> Doesn't really seem like we have too many ways forward here, right?
>>>
>>> How about this?
>>>    
>>> ------>8-----------------------------------
>>>
>>> net: hide NET_TC_SKB_EXT as a config option
>>>
>>> Linus points out the NET_TC_SKB_EXT config option looks suspicious.
>>> Indeed, it should really be selected to ensure correct OvS operation
>>> if TC offload is used. Hopefully those who care about TC-only and
>>> OvS-only performance disable the other one at compilation time.
>>>
>>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>> ---
>>>    net/openvswitch/Kconfig |  1 +
>>>    net/sched/Kconfig       | 13 +++----------
>>>    2 files changed, 4 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
>>> index 22d7d5604b4c..bd407ea7c263 100644
>>> --- a/net/openvswitch/Kconfig
>>> +++ b/net/openvswitch/Kconfig
>>> @@ -15,6 +15,7 @@ config OPENVSWITCH
>>>    	select NET_MPLS_GSO
>>>    	select DST_CACHE
>>>    	select NET_NSH
>>> +	select NET_TC_SKB_EXT if NET_CLS_ACT
>>>    	---help---
>>>    	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
>>>    	  environments.  In addition to supporting a variety of features
>>> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
>>> index b3faafeafab9..f1062ef55098 100644
>>> --- a/net/sched/Kconfig
>>> +++ b/net/sched/Kconfig
>>> @@ -719,6 +719,7 @@ config NET_EMATCH_IPT
>>>    config NET_CLS_ACT
>>>    	bool "Actions"
>>>    	select NET_CLS
>>> +	select NET_TC_SKB_EXT if OPENVSWITCH
>>
>> But how would that make much of a difference :( Distros are still going to
>> enable all of this blindlessly. Given discussion in [0], could we just get
>> rid of this tasteless hack altogether which is for such a narrow use case
>> anyway?
> 
> Agreed.  I take it you're opposed to the use of skb extensions here
> in general?  Distros would have enabled NET_TC_SKB_EXT even when it
> was a config option.

Yeah, as it stands, motivation for this extension is to tie tc [HW] offload
and OVS to work together in case of recirculation ... from commit:

   Received packets will first travel though tc, and if they aren't stolen
   by it, like in the above rule, they will continue to OvS datapath.

   Since we already did some actions (action ct in this case) which might
   modify the packets, and updated action stats, we would like to continue
   the proccessing with the correct recirc_id in OvS (here recirc_id(2))
   where we left off.

I would perhaps see more of a point in an skb extension if there is rather
generic use and also out of the SW datapath (and I really doubt anyone is
seriously using tc + OVS combo for non-HW workloads). Right now this feels
like duck taping.

Adding new skb extensions should really have a strong justification behind
it (close but slightly less strict to how we treat adding new members to
skb itself).
