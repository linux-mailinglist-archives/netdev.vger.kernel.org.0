Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5476233BC5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:11:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:40314 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCXLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:11:52 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hXw7C-0006HK-Ew; Tue, 04 Jun 2019 01:11:42 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hXw7C-00042r-3W; Tue, 04 Jun 2019 01:11:42 +0200
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
 <20190531094215.3729-2-bjorn.topel@gmail.com>
 <E5650E49-81B5-4F36-B931-E433A0BD210D@flugsvamp.com>
 <CAJ+HfNj=h1Ns_Q4tzmK-5q8jr5icVLA9-tiH7-tQTXx0hATZ0A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a9c3be97-6c74-6491-199f-219bd4c2c631@iogearbox.net>
Date:   Tue, 4 Jun 2019 01:11:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNj=h1Ns_Q4tzmK-5q8jr5icVLA9-tiH7-tQTXx0hATZ0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25469/Mon Jun  3 09:59:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2019 10:39 AM, Björn Töpel wrote:
> On Sat, 1 Jun 2019 at 20:12, Jonathan Lemon <jlemon@flugsvamp.com> wrote:
>> On 31 May 2019, at 2:42, Björn Töpel wrote:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
>>> command of ndo_bpf. The query code is fairly generic. This commit
>>> refactors the query code up from the drivers to the netdev level.
>>>
>>> The struct net_device has gained two new members: xdp_prog_hw and
>>> xdp_flags. The former is the offloaded XDP program, if any, and the
>>> latter tracks the flags that the supplied when attaching the XDP
>>> program. The flags only apply to SKB_MODE or DRV_MODE, not HW_MODE.
>>>
>>> The xdp_prog member, previously only used for SKB_MODE, is shared with
>>> DRV_MODE. This is OK, due to the fact that SKB_MODE and DRV_MODE are
>>> mutually exclusive. To differentiate between the two modes, a new
>>> internal flag is introduced as well.
>>
>> I'm not entirely clear why this new flag is needed - GENERIC seems to
>> be an alias for SKB_MODE, so why just use SKB_MODE directly?
>>
>> If the user does not explicitly specify a type (skb|drv|hw), then the
>> command should choose the correct type and then behave as if this type
>> was specified.
> 
> Yes, this is kind of hairy.
> 
> SKB and DRV are mutually exclusive, but HW is not. IOW, valid options are:
> SKB, DRV, HW, SKB+HW DRV+HW.

Correct, HW is a bit special here in that it helps offloading parts of
the DRV XDP program to NIC, but also do RSS steering in BPF etc, hence
this combo is intentionally allowed (see also git log).

> What complicates things further, is that SKB and DRV can be implicitly
> (auto/no flags) or explicitly enabled (flags).

Mainly out of historic context: originally the fallback to SKB mode was
implicit if the ndo_bpf was missing. But there are use cases where we
want to fail if the driver does not support native XDP to avoid surprises.

> If a user doesn't pass any flags, the "best supported mode" should be
> selected. If this "auto mode" is used, it should be seen as a third
> mode. E.g.
> 
> ip link set dev eth0 xdp on -- OK
> ip link set dev eth0 xdp off -- OK
> 
> ip link set dev eth0 xdp on -- OK # generic auto selected
> ip link set dev eth0 xdpgeneric off -- NOK, bad flags

This would work if the auto selection would have selected XDP generic.

> ip link set dev eth0 xdp on -- OK # drv auto selected
> ip link set dev eth0 xdpdrv off -- NOK, bad flags

This would work if the auto selection chose native XDP previously. Are
you saying it's not the case?

Also, what is the use case in mixing these commands? It should be xdp
on+off, xdpdrv on+off, and so on. Are you saying you would prefer a
xdp{,any} off that uninstalls everything? Isn't this mostly a user space
issue to whatever orchestrates XDP?

> ...and so on. The idea is that a user should use the same set of flags always.
> 
> The internal "GENERIC" flag is only to determine if the xdp_prog
> represents a DRV version or SKB version. Maybe it would be clearer
> just to add an additional xdp_prog_drv to the net_device, instead?
> 
>> The logic in dev_change_xdp_fd() is too complicated.  It disallows
>> setting (drv|skb), but allows (hw|skb), which I'm not sure is
>> intentional.
>>
>> It should be clearer as to which combinations are allowed.
> 
> Fair point. I'll try to clean it up further.
> 
