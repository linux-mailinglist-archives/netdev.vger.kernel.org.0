Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883D51C9CF2
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEGVGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:06:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:40234 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgEGVGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 17:06:07 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWniO-0004wi-CU; Thu, 07 May 2020 23:05:56 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWniO-0008Ol-3O; Thu, 07 May 2020 23:05:56 +0200
Subject: Re: [PATCH v3] net: bpf: permit redirect from ingress L3 to egress L2
 devices at near max mtu
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <CANP3RGduts2FJ2M5MLcf23GaRa=-fwUC7oPf-S4zp39f63jHMg@mail.gmail.com>
 <20200507023606.111650-1-zenczykowski@gmail.com>
 <ae1e5602-a2fd-661b-155c-d32ff0059ce6@iogearbox.net>
 <CANP3RGcz3VE6kS8JUNw4gR1tbCGGbF=-u99_j9QZRrz6559=kw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a711e527-5283-cf3f-6866-06ee0a010d74@iogearbox.net>
Date:   Thu, 7 May 2020 23:05:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANP3RGcz3VE6kS8JUNw4gR1tbCGGbF=-u99_j9QZRrz6559=kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25805/Thu May  7 14:14:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/20 6:46 PM, Maciej Żenczykowski wrote:
> (a) not clear why the max is SKB_MAX_ALLOC in the first place (this is
> PAGE_SIZE << 2, ie. 16K on x86), while lo mtu is 64k

Agreed, tbh, it's not clear to me either atm. :) The SKB_MAX_ALLOC constant itself
should be replaced with something more appropriate. Also as a small side note,
the !skb->dev check should be removed since in tc ingress/egress the skb->dev
is never NULL. (See also tc_cls_act_convert_ctx_access() on struct __sk_buff,
ifindex conversion.)

> (b) hmm, if we're not redirecting, then exceeding the ingress device's
> mtu doesn't seem to be a problem.
> 
> Indeed AFAIK this can already happen, some devices will round mtu up
> when they configure the device mru buffers.
> (ie. you configure L3 mtu 1500, they treat that as L2 1536 or 1532 [-4
> fcs], simply because 3 * 512 is a nice amount of buffers, or they'll
> accept not only 1514 L2, but also 1518 L2 or even 1522 L2 for VLAN and
> Q-IN-Q -- even if the packets aren't actually VLAN'ed, so your non
> VLAN mru might be 1504 or 1508)
> 
> Indeed my corp dell workstation with some standard 1 gigabit
> motherboard nic has a standard default mtu of 1500, and I've seen it
> receive L3 mtu 1520 packets (apparently due to misconfiguration in our
> hardware [cisco? juniper?] ipv4->ipv6 translator which can take 1500
> mtu ipv4 packets and convert them to 1520 mtu ipv6 packets without
> fragmenting or generating icmp too big errors).  While it's obviously
> wrong, it does just work (the network paths themselves are also
> obviously 1520 clean).

Right, agree on tc ingress side when skb goes further up the stack.

> (c) If we are redirecting we'll eventually (after bpf program returns)
> hit dev_queue_xmit(), and shouldn't that be what returns an error?

You mean whether the check should be inside __dev_queue_xmit() itself
instead? Maybe. From a cursory glance the MTU checks are spread in upper
layer protos. As mentioned, we would need to have coverage for BPF progs
attached on the tc ingress and egress (sch_handle_{ingress,egress}())
hook where for each case an skb can be just TC_ACT_OK'ed (up to stack or
down to driver), redirected via ____dev_forward_skb() or dev_queue_xmit().
The ____dev_forward_skb() has us covered and for TC_ACT_OK on tc ingress,
we'd only need a generic upper cap. So for the rest of the cases, we'd
need to have some sort of sanity check somewhere.

> btw. is_skb_forwardable() actually tests
> - device is up && (packet is gso || skb->len < dev->mtu +
> dev->hard_header_len + VLAN_HLEN);
> 
> which is also wrong and in 2 ways, cause VLAN_HLEN makes no sense on
> non ethernet, and the __bpf_skb_max_len function doesn't account for
> VLAN...  (which possibly has implications if you try to redirect to a
> vlan interface)

Yeah, it probably would for QinQ which is probably why noone was running
into it so far. At least the skb_vlan_push() would first store the tag
via __vlan_hwaccel_put_tag() in the skb itself.

> I think having an mtu check is useful, but I think the mtu should be
> selectable by the bpf program.  Because it might not even be device
> mtu at all, it might be path mtu which we should be testing against.
> It should also be checked for gso frames, since the max post
> segmentation size should be enforced.
> 
> I agree we should expose dev->mtu (and dev->hard_header_len and hatype)
> 
> I'll mull this over a bit more, but I'm not convinced this patch isn't ok as is.
> There just is probably more we should do.

Ok, makes sense. Thanks for looking into it!
