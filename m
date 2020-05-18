Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C65C1D8A01
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 23:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgERVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 17:23:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:47828 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERVXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 17:23:51 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1janEh-0001DH-2F; Mon, 18 May 2020 23:23:47 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1janEg-000VPI-Gq; Mon, 18 May 2020 23:23:46 +0200
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f82c224f-f556-cf15-e8de-d725c4f21df9@iogearbox.net>
Date:   Mon, 18 May 2020 23:23:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 4:44 PM, David Ahern wrote:
> On 5/18/20 3:08 AM, Toke Høiland-Jørgensen wrote:
>> I can see your point that fixing up the whole skb after the program has
>> run is not a good idea. But to me that just indicates that the hook is
>> in the wrong place: that it really should be in the driver, executed at
>> a point where the skb data structure is no longer necessary (similar to
>> how the ingress hook is before the skb is generated).
> 
> Have you created a cls_bpf program to modify skbs? Have you looked at
> the helpers, the restrictions and the tight management of skb changes?
> Have you followed the skb from create to device handoff through the
> drivers? Have you looked at the history of encapsulations, gso handling,
> offloads, ...? I have and it drove home that the skb path and xdp paths
> are radically different. XDP is meant to be light and fast, and trying
> to cram an skb down the xdp path is a dead end.

Agree, it's already challenging in itself to abstract the skb internals and
protocol specifics away for tc BPF programs while keeping them reasonably
fast (e.g. not destroying skb GSO specifics, etc). Good example is the whole
bpf_skb_adjust_room() flags mess. :/ The buffer would have to be an XDP
one straight from socket layer and stay that way as an xdp-buff down to the
driver, not the other way around where you'd pay the price of back'n'forth
conversion to xdp-buff and then passing it to the driver while handling/
fixing up all the skb details after the BPF prog was run. AF_XDP's xmit would
be more suited for something like that.

Thanks,
Daniel
