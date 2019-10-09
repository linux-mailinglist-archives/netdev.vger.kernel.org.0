Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDB7D13D9
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbfJIQTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:19:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:26530 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731173AbfJIQTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 12:19:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:19:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="198054835"
Received: from unknown (HELO [10.241.228.165]) ([10.241.228.165])
  by orsmga006.jf.intel.com with ESMTP; 09 Oct 2019 09:19:05 -0700
Subject: Re: [PATCH bpf-next 0/4] Enable direct receive on AF_XDP sockets
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <4c316f09-0691-4a1b-f798-73299e978946@intel.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <411a0287-13fb-672b-740b-10a199e34836@intel.com>
Date:   Wed, 9 Oct 2019 09:19:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4c316f09-0691-4a1b-f798-73299e978946@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/2019 1:05 AM, Björn Töpel wrote:
> On 2019-10-08 08:16, Sridhar Samudrala wrote:
>> This is a rework of the following patch series
>> https://lore.kernel.org/netdev/1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com/#r 
>>
>> that tried to enable direct receive by bypassing XDP program attached
>> to the device.
>>
>> Based on the community feedback and some suggestions from Bjorn, changed
>> the semantics of the implementation to enable direct receive on AF_XDP
>> sockets that are bound to a queue only when there is no normal XDP 
>> program
>> attached to the device.
>>
>> This is accomplished by introducing a special BPF prog pointer 
>> (DIRECT_XSK)
>> that is attached at the time of binding an AF_XDP socket to a queue of a
>> device. This is done only if there is no other XDP program attached to
>> the device. The normal XDP program has precedence and will replace the
>> DIRECT_XSK prog if it is attached later. The main reason to introduce a
>> special BPF prog pointer is to minimize the driver changes. The only 
>> change
>> is to use the bpf_get_prog_id() helper when QUERYING the prog id.
>>
>> Any attach of a normal XDP program will take precedence and the direct 
>> xsk
>> program will be removed. The direct XSK program will be attached
>> automatically when the normal XDP program is removed when there are any
>> AF_XDP direct sockets associated with that device.
>>
>> A static key is used to control this feature in order to avoid any 
>> overhead
>> for normal XDP datapath when there are no AF_XDP sockets in direct-xsk 
>> mode.
>>
>> Here is some performance data i collected on my Intel Ivybridge based
>> development system (Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz)
>> NIC: Intel 40Gb ethernet (i40e)
>>
>> xdpsock rxdrop 1 core (both app and queue's irq pinned to the same core)
>>     default : taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1
>>     direct-xsk :taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1
>> 6.1x improvement in drop rate
>>
>> xdpsock rxdrop 2 core (app and queue's irq pinned to different cores)
>>     default : taskset -c 3 ./xdpsock -i enp66s0f0 -r -q 1
>>     direct-xsk :taskset -c 3 ./xdpsock -i enp66s0f0 -r -d -q 1
>> 6x improvement in drop rate
>>
>> xdpsock l2fwd 1 core (both app and queue's irq pinned to the same core)
>>     default : taskset -c 1 ./xdpsock -i enp66s0f0 -l -q 1
>>     direct-xsk :taskset -c 1 ./xdpsock -i enp66s0f0 -l -d -q 1
>> 3.5x improvement in l2fwd rate
>>
>> xdpsock rxdrop 2 core (app and queue'sirq pinned to different cores)
>>     default : taskset -c 3 ./xdpsock -i enp66s0f0 -l -q 1
>>     direct-xsk :taskset -c 3 ./xdpsock -i enp66s0f0 -l -d -q 1
>> 4.5x improvement in l2fwd rate
>>
>> dpdk-pktgen is used to send 64byte UDP packets from a link partner and
>> ethtool ntuple flow rule is used to redirect packets to queue 1 on the
>> system under test.
>>
> 
> Thanks for working on this Sridhar! I like this approach! Except from
> the bpf_get_prog_id() changes, no driver changes are needed.
> 
> It's also a cleaner (IMO) approach than my previous attempts [1,2,3]
> 
> Would be interesting to see NFP support AF_XDP offloading with this
> option. (nudge, nudge).
> 
> A thought: From userland, a direct AF_XDP socket will not appear as an
> XDP program is attached to the device (id == 0). Maybe show in ss(8)
> (via xsk_diag.c) that the socket is direct?

Sure. will add this in the next revision.

> 
> [1] 
> https://lore.kernel.org/netdev/CAJ+HfNj63QcLY8=y1fF93PZd3XcfiGSrbbWdiGByjTzZQydSSg@mail.gmail.com/ 
> 
> [2] 
> https://lore.kernel.org/netdev/cd952f99-6bad-e0c8-5bcd-f0010218238c@intel.com/ 
> 
> [3] 
> https://lore.kernel.org/netdev/20181207114431.18038-1-bjorn.topel@gmail.com/ 
> 
