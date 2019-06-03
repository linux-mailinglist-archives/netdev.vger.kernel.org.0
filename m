Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53139332D9
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfFCO6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:58:09 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:28417 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbfFCO6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:58:08 -0400
Received: (qmail 40787 invoked by uid 89); 3 Jun 2019 14:58:07 -0000
Received: from unknown (HELO ?172.20.92.49?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4y) (POLARISLOCAL)  
  by smtp6.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 3 Jun 2019 14:58:07 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Saeed Mahameed" <saeedm@mellanox.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Date:   Mon, 03 Jun 2019 07:58:02 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <65A0C25F-D4EA-4DCC-951E-2A196F80270F@flugsvamp.com>
In-Reply-To: <CAJ+HfNj=h1Ns_Q4tzmK-5q8jr5icVLA9-tiH7-tQTXx0hATZ0A@mail.gmail.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
 <20190531094215.3729-2-bjorn.topel@gmail.com>
 <E5650E49-81B5-4F36-B931-E433A0BD210D@flugsvamp.com>
 <CAJ+HfNj=h1Ns_Q4tzmK-5q8jr5icVLA9-tiH7-tQTXx0hATZ0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3 Jun 2019, at 1:39, Björn Töpel wrote:

> On Sat, 1 Jun 2019 at 20:12, Jonathan Lemon <jlemon@flugsvamp.com> 
> wrote:
>>
>> On 31 May 2019, at 2:42, Björn Töpel wrote:
>>
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
>>> The xdp_prog member, previously only used for SKB_MODE, is shared 
>>> with
>>> DRV_MODE. This is OK, due to the fact that SKB_MODE and DRV_MODE are
>>> mutually exclusive. To differentiate between the two modes, a new
>>> internal flag is introduced as well.
>>
>> I'm not entirely clear why this new flag is needed - GENERIC seems to
>> be an alias for SKB_MODE, so why just use SKB_MODE directly?
>>
>> If the user does not explicitly specify a type (skb|drv|hw), then the
>> command should choose the correct type and then behave as if this 
>> type
>> was specified.
>>
>
> Yes, this is kind of hairy.
>
> SKB and DRV are mutually exclusive, but HW is not. IOW, valid options 
> are:
> SKB, DRV, HW, SKB+HW DRV+HW.

Fair enough, that was the understanding that I had from the code, 
although I'm not sure about the usage of SKB+HW mode.



>
> What complicates things further, is that SKB and DRV can be implicitly
> (auto/no flags) or explicitly enabled (flags).
>
> If a user doesn't pass any flags, the "best supported mode" should be
> selected. If this "auto mode" is used, it should be seen as a third
> mode. E.g.
>
> ip link set dev eth0 xdp on -- OK
> ip link set dev eth0 xdp off -- OK
>
> ip link set dev eth0 xdp on -- OK # generic auto selected
> ip link set dev eth0 xdpgeneric off -- NOK, bad flags
>
> ip link set dev eth0 xdp on -- OK # drv auto selected
> ip link set dev eth0 xdpdrv off -- NOK, bad flags
>
> ...and so on. The idea is that a user should use the same set of flags 
> always.

I'm not sure about this.  The "xdp" mode shouldn't be treated as a 
separate mode, it should be "best supported mode", as indicated above.  
 From my view, it should select the appropriate mode, and then proceed 
as if the user had specified that mode, rather than being treated as an 
independent mode.

ip link set dev eth0 xdp on		- OK
ip link set dev eth0 xdp off	- OK

ip link set dev eth0 xdp on 	- OK, selected dev
ip link set dev eth0 xdpgeneric off - NOK, not running
ip link set dev eth0 xdpdrv off	- OK




> The internal "GENERIC" flag is only to determine if the xdp_prog
> represents a DRV version or SKB version. Maybe it would be clearer
> just to add an additional xdp_prog_drv to the net_device, instead?

I'd go the other way, and remove GENERIC, leaving only SKB, DRV, and HW.
The appropriate mode flag (SKB|DRV) is enough to indicate the type of 
xdp_prog.
-- 
Jonathan
