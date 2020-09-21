Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6142B272988
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgIUPIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:08:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:53726 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgIUPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:08:34 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kKNQQ-0003T9-Jo; Mon, 21 Sep 2020 17:08:18 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kKNQQ-000JkV-9z; Mon, 21 Sep 2020 17:08:18 +0200
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
References: <20200917143846.37ce43a0@carbon>
 <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon>
 <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
 <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
 <20200921144953.6456d47d@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
Date:   Mon, 21 Sep 2020 17:08:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200921144953.6456d47d@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25934/Mon Sep 21 15:52:04 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/20 2:49 PM, Jesper Dangaard Brouer wrote:
> On Mon, 21 Sep 2020 11:37:18 +0100
> Lorenz Bauer <lmb@cloudflare.com> wrote:
>> On Sat, 19 Sep 2020 at 00:06, Maciej Żenczykowski <maze@google.com> wrote:
>>>   
>>>> This is a good point.  As bpf_skb_adjust_room() can just be run after
>>>> bpf_redirect() call, then a MTU check in bpf_redirect() actually
>>>> doesn't make much sense.  As clever/bad BPF program can then avoid the
>>>> MTU check anyhow.  This basically means that we have to do the MTU
>>>> check (again) on kernel side anyhow to catch such clever/bad BPF
>>>> programs.  (And I don't like wasting cycles on doing the same check two
>>>> times).
>>>
>>> If you get rid of the check in bpf_redirect() you might as well get
>>> rid of *all* the checks for excessive mtu in all the helpers that
>>> adjust packet size one way or another way.  They *all* then become
>>> useless overhead.
>>>
>>> I don't like that.  There may be something the bpf program could do to
>>> react to the error condition (for example in my case, not modify
>>> things and just let the core stack deal with things - which will
>>> probably just generate packet too big icmp error).
>>>
>>> btw. right now our forwarding programs first adjust the packet size
>>> then call bpf_redirect() and almost immediately return what it
>>> returned.
>>>
>>> but this could I think easily be changed to reverse the ordering, so
>>> we wouldn't increase packet size before the core stack was informed we
>>> would be forwarding via a different interface.
>>
>> We do the same, except that we also use XDP_TX when appropriate. This
>> complicates the matter, because there is no helper call we could
>> return an error from.
> 
> Do notice that my MTU work is focused on TC-BPF.  For XDP-redirect the
> MTU check is done in xdp_ok_fwd_dev() via __xdp_enqueue(), which also
> happens too late to give BPF-prog knowledge/feedback.  For XDP_TX I
> audited the drivers when I implemented xdp_buff.frame_sz, and they
> handled (or I added) handling against max HW MTU. E.g. mlx5 [1].
> 
> [1] https://elixir.bootlin.com/linux/v5.9-rc6/source/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c#L267
> 
>> My preference would be to have three helpers: get MTU for a device,
>> redirect ctx to a device (with MTU check), resize ctx (without MTU
>> check) but that doesn't work with XDP_TX. Your idea of doing checks
>> in redirect and adjust_room is pragmatic and seems easier to
>> implement.
>   
> I do like this plan/proposal (with 3 helpers), but it is not possible
> with current API.  The main problem is the current bpf_redirect API
> doesn't provide the ctx, so we cannot do the check in the BPF-helper.
> 
> Are you saying we should create a new bpf_redirect API (that incl packet ctx)?

Sorry for jumping in late here... one thing that is not clear to me is that if
we are fully sure that skb is dropped by stack anyway due to invalid MTU (redirect
to ingress does this via dev_forward_skb(), it's not fully clear to me whether it's
also the case for the dev_queue_xmiy()), then why not dropping all the MTU checks
aside from SKB_MAX_ALLOC sanity check for BPF helpers and have something like a
device object (similar to e.g. TCP sockets) exposed to BPF prog where we can retrieve
the object and read dev->mtu from the prog, so the BPF program could then do the
"exception" handling internally w/o extra prog needed (we also already expose whether
skb is GSO or not).

Thanks,
Daniel
