Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1ADE384A4
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 08:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfFGG6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 02:58:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:53763 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfFGG6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 02:58:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 23:58:04 -0700
X-ExtLoop1: 1
Received: from btopel-mobl.isw.intel.com (HELO btopel-mobl.ger.intel.com) ([10.103.211.150])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2019 23:58:01 -0700
Subject: Re: [PATCH] net: Fix hang while unregistering device bound to xdp
 socket
To:     Ilya Maximets <i.maximets@samsung.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
References: <CGME20190606124020eucas1p2007396ae8f23a426a17e0e5481636187@eucas1p2.samsung.com>
 <20190606124014.23231-1-i.maximets@samsung.com>
 <4414B6B6-3FE2-4CF2-A67A-159FCF6B9ECF@gmail.com>
 <3014f882-3042-cb6a-2356-ea3a754840a7@samsung.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a8d428ce-2539-b280-d219-6d21a500aa5c@intel.com>
Date:   Fri, 7 Jun 2019 08:58:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3014f882-3042-cb6a-2356-ea3a754840a7@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-06-07 08:36, Ilya Maximets wrote:
> On 06.06.2019 21:03, Jonathan Lemon wrote:
>> On 6 Jun 2019, at 5:40, Ilya Maximets wrote:
>>
>>> Device that bound to XDP socket will not have zero refcount until the
>>> userspace application will not close it. This leads to hang inside
>>> 'netdev_wait_allrefs()' if device unregistering requested:
>>>
>>>    # ip link del p1
>>>    < hang on recvmsg on netlink socket >
>>>
>>>    # ps -x | grep ip
>>>    5126  pts/0    D+   0:00 ip link del p1
>>>
>>>    # journalctl -b
>>>
>>>    Jun 05 07:19:16 kernel:
>>>    unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>>
>>>    Jun 05 07:19:27 kernel:
>>>    unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>>    ...
>>>
>>> Fix that by counting XDP references for the device and failing
>>> RTM_DELLINK with EBUSY if device is still in use by any XDP socket.
>>>
>>> With this change:
>>>
>>>    # ip link del p1
>>>    RTNETLINK answers: Device or resource busy
>>>
>>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>> ---
>>>
>>> Another option could be to force closing all the corresponding AF_XDP
>>> sockets, but I didn't figure out how to do this properly yet.
>>>
>>>   include/linux/netdevice.h | 25 +++++++++++++++++++++++++
>>>   net/core/dev.c            | 10 ++++++++++
>>>   net/core/rtnetlink.c      |  6 ++++++
>>>   net/xdp/xsk.c             |  7 ++++++-
>>>   4 files changed, 47 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index 44b47e9df94a..24451cfc5590 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -1705,6 +1705,7 @@ enum netdev_priv_flags {
>>>    *	@watchdog_timer:	List of timers
>>>    *
>>>    *	@pcpu_refcnt:		Number of references to this device
>>> + *	@pcpu_xdp_refcnt:	Number of XDP socket references to this device
>>>    *	@todo_list:		Delayed register/unregister
>>>    *	@link_watch_list:	XXX: need comments on this one
>>>    *
>>> @@ -1966,6 +1967,7 @@ struct net_device {
>>>   	struct timer_list	watchdog_timer;
>>>
>>>   	int __percpu		*pcpu_refcnt;
>>> +	int __percpu		*pcpu_xdp_refcnt;
>>>   	struct list_head	todo_list;
>>
>>
>> I understand the intention here, but don't think that putting a XDP reference
>> into the generic netdev structure is the right way of doing this.  Likely the
>> NETDEV_UNREGISTER notifier should be used so the socket and umem unbinds from
>> the device.
>>
> 
> Thanks for the pointer! That is exactly what I looked for.
> I'll make a new version that will unbind resources using netdevice notifier.
> 
> Best regards, Ilya Maximets.
> 

Thanks for working on this.

This would open up for supporting killing sockets via ss(8) (-K,
--kill), as well!


Björn
