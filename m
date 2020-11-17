Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9E2B5C69
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgKQKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 05:00:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:20070 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgKQKAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 05:00:15 -0500
IronPort-SDR: Ib9f74fJNhbQhSSVyMY6o8ej0oI3HU4yUg4UafjOmzu6IqXQoGEB3PHm4IFPKVte/9IoQMCZ45
 HSufaRhZez/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="167385655"
X-IronPort-AV: E=Sophos;i="5.77,485,1596524400"; 
   d="scan'208";a="167385655"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 02:00:13 -0800
IronPort-SDR: FP65aetSCR/Lm30uZbIbLXVN5ZvVrep09gqVwZhMnSGu3snl3+Ibv7wfAY+yGWqo2Q9SS8SIxG
 +UHPiz0Edrcw==
X-IronPort-AV: E=Sophos;i="5.77,485,1596524400"; 
   d="scan'208";a="543978397"
Received: from wrzedzic-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.36.164])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 02:00:09 -0800
Subject: Re: [PATCH] xsk: add cq event
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <964677c6-442c-485e-9268-3a801dbd4bd3@orsmsx607.amr.corp.intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
Date:   Tue, 17 Nov 2020 11:00:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <964677c6-442c-485e-9268-3a801dbd4bd3@orsmsx607.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-16 17:12, Xuan Zhuo wrote:
> On Mon, 16 Nov 2020 15:31:20 +0100, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com> wrote:
> 
>> On 2020-11-16 09:10, Xuan Zhuo wrote:
> 
>>> When we write all cq items to tx, we have to wait for a new event based
> 
>>> on poll to indicate that it is writable. But the current writability is
> 
>>> triggered based on whether tx is full or not, and In fact, when tx is
> 
>>> dissatisfied, the user of cq's item may not necessarily get it, because it
> 
>>> may still be occupied by the network card. In this case, we need to know
> 
>>> when cq is available, so this patch adds a socket option, When the user
> 
>>> configures this option using setsockopt, when cq is available, a
> 
>>> readable event is generated for all xsk bound to this umem.
> 
>>>
> 
>>> I can't find a better description of this event,
> 
>>> I think it can also be 'readable', although it is indeed different from
> 
>>> the 'readable' of the new data. But the overhead of xsk checking whether
> 
>>> cq or rx is readable is small.
> 
>>>
> 
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> 
>>
> 
>> Thanks for the patch!
> 
>>
> 
>> I'm not a fan of having two different "readable" event (both Rx and cq).
> 
>> Could you explain a bit what the use case is, so I get a better
> 
>> understanding.
> 
>>
> 
>> The Tx queues has a back-pressure mechanism, determined of the number of
> 
>> elements in cq. Is it related to that?
> 
>>
> 
>> Please explain a bit more what you're trying to solve, and maybe we can
> 
>> figure out a better way forward!
> 
>>
> 
>>
> 
>> Thanks!
> 
>> Björn
> 
> I want to implement a tool for mass sending. For example, the size of cq is
> 
> 1024, and I set the size of tx also to 1024, so that I will put all cq in tx at
> 
> once, and then I have to wait for an event, come Indicates that there is new
> 
> write space or new cq is available.
> 
> 
> 
> At present, we can only monitor the event of write able. This indicates whether
> 
> tx is full, but in fact, tx is basically not full, because the full state is
> 
> very short, and those tx items are being used by the network card. And
> 
> epoll_wait will be awakened directly every time, without waiting, but I cannot
> 
> get the cq item, so I still cannot successfully send the package again.
> 
> 
> 
> Of course, I don't like the "readable" event very much. This is a suitable
> 
> one I found in the existing epoll event. ^_^
>

More questions! By "Mass sending" do you mean maximum throughput, or
does that mean "in very large batches"?

For the latter to do 1k batches, you could increase the Tx/cq buffer
size to say 4k.

For maximum thoughput it's better to use smaller batches (e.g. what the
txpush scenario in samples/xdpsock does).

You're right that even if there's space in the Tx ring, it wont be sent
unless there's sufficient space in the cq ring. Maybe it would make
sense to be more restrictive when triggering the "writable" socket
event? E.g. only trigger it when there's space in Tx *and* sufficient cq
space?


Björn

> 
> 
> Thanks.
> 
