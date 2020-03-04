Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0C2179178
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgCDNga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:36:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:59154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgCDNga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 08:36:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5287DACB1;
        Wed,  4 Mar 2020 13:36:28 +0000 (UTC)
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org,
        "ilias.apalodimas" <ilias.apalodimas@linaro.org>,
        wei.liu@kernel.org, paul@xen.org
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
 <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
 <CAOJe8K28BZCW7JDejKgDELR2WPfBgvj-0aJJXX9uCRnryGY+xg@mail.gmail.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <c5cd0349-69b3-41e9-7fb1-d7909e659717@suse.com>
Date:   Wed, 4 Mar 2020 14:36:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOJe8K28BZCW7JDejKgDELR2WPfBgvj-0aJJXX9uCRnryGY+xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.03.20 14:10, Denis Kirjanov wrote:
> On 3/2/20, Jürgen Groß <jgross@suse.com> wrote:
>> On 02.03.20 15:21, Denis Kirjanov wrote:
>>> the patch adds a basic xdo logic to the netfront driver
>>>
>>> XDP redirect is not supported yet
>>>
>>> v2:
>>> - avoid data copying while passing to XDP
>>> - tell xen-natback that we need the headroom space
>>
>> Please add the patch history below the "---" delimiter
>>
>>>
>>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>>> ---
>>>    drivers/net/xen-netback/common.h |   1 +
>>>    drivers/net/xen-netback/rx.c     |   9 ++-
>>>    drivers/net/xen-netback/xenbus.c |  21 ++++++
>>>    drivers/net/xen-netfront.c       | 157
>>> +++++++++++++++++++++++++++++++++++++++
>>>    4 files changed, 186 insertions(+), 2 deletions(-)
>>
>> You are modifying xen-netback sources. Please Cc the maintainers.
>>

...

>>>
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +abort_transaction:
>>> +	xenbus_dev_fatal(np->xbdev, err, "%s", message);
>>> +	xenbus_transaction_end(xbt, 1);
>>> +out:
>>> +	return err;
>>> +}
>>> +
>>> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>> +			struct netlink_ext_ack *extack)
>>> +{
>>> +	struct netfront_info *np = netdev_priv(dev);
>>> +	struct bpf_prog *old_prog;
>>> +	unsigned int i, err;
>>> +
>>> +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
>>> +	if (!old_prog && !prog)
>>> +		return 0;
>>> +
>>> +	if (prog)
>>> +		bpf_prog_add(prog, dev->real_num_tx_queues);
>>> +
>>> +	for (i = 0; i < dev->real_num_tx_queues; ++i)
>>> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
>>> +
>>> +	if (old_prog)
>>> +		for (i = 0; i < dev->real_num_tx_queues; ++i)
>>> +			bpf_prog_put(old_prog);
>>> +
>>> +	err = talk_to_netback_xdp(np, old_prog ? NETBACK_XDP_HEADROOM_DISABLE:
>>> +				  NETBACK_XDP_HEADROOM_ENABLE);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
>>
>> What is happening in case the backend doesn't support XDP?
> Here we just ask xen-backend to make a headroom, that's it.
> It's better to send xen-backend changes in a separate patch.

Okay, but what do you do if the backend doesn't support XDP (e.g. in
case its an older kernel)? How do you know it is supporting XDP?

> 
>>
>> Is it really a good idea to communicate xdp_set via a frontend state
>> change? This will be rather slow. OTOH I have no idea how often this
>> might happen.
> 
> I don't think that it's going to switch often and more likely it's a one shot
> action.

What do you do in case of a live migration? You need to tell the backend
about XDP again.


Juergen
