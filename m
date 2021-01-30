Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403DD3090D4
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 01:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhA3AJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 19:09:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:42750 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhA3AJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 19:09:00 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5doI-0004cZ-DI; Sat, 30 Jan 2021 01:08:18 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5doI-000RaO-5F; Sat, 30 Jan 2021 01:08:18 +0100
Subject: Re: [PATCH bpf-next V13 4/7] bpf: add BPF-helper for MTU checking
To:     John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
 <161159457239.321749.9067604476261493815.stgit@firesoul>
 <6013b06b83ae2_2683c2085d@john-XPS-13-9370.notmuch>
 <20210129083654.14f343fa@carbon>
 <60142eae7cd59_11fd208f1@john-XPS-13-9370.notmuch>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4965401d-c461-15f6-2068-6cefb6c145ba@iogearbox.net>
Date:   Sat, 30 Jan 2021 01:08:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <60142eae7cd59_11fd208f1@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26064/Fri Jan 29 13:25:14 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/21 4:50 PM, John Fastabend wrote:
> Jesper Dangaard Brouer wrote:
>> On Thu, 28 Jan 2021 22:51:23 -0800
>> John Fastabend <john.fastabend@gmail.com> wrote:
>>> Jesper Dangaard Brouer wrote:
>>>> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
>>>>
>>>> The SKB object is complex and the skb->len value (accessible from
>>>> BPF-prog) also include the length of any extra GRO/GSO segments, but
>>>> without taking into account that these GRO/GSO segments get added
>>>> transport (L4) and network (L3) headers before being transmitted. Thus,
>>>> this BPF-helper is created such that the BPF-programmer don't need to
>>>> handle these details in the BPF-prog.
>>>>
>>>> The API is designed to help the BPF-programmer, that want to do packet
>>>> context size changes, which involves other helpers. These other helpers
>>>> usually does a delta size adjustment. This helper also support a delta
>>>> size (len_diff), which allow BPF-programmer to reuse arguments needed by
>>>> these other helpers, and perform the MTU check prior to doing any actual
>>>> size adjustment of the packet context.
>>>>
>>>> It is on purpose, that we allow the len adjustment to become a negative
>>>> result, that will pass the MTU check. This might seem weird, but it's not
>>>> this helpers responsibility to "catch" wrong len_diff adjustments. Other
>>>> helpers will take care of these checks, if BPF-programmer chooses to do
>>>> actual size adjustment.
>>
>> The nitpick below about len adjust can become negative, is on purpose
>> and why is described in above.
> 
> following up on a nitpick :)
> 
> What is the use case to allow users to push a negative len_diff with
> abs(len_diff) > skb_diff and not throw an error. I would understand if it
> was a pain to catch the case, but below is fairly straightforward. Of
> course if user really tries to truncate the packet like this later it
> will also throw an error, but still missing why we don't throw an error
> here.
> 
> Anyways its undefined if len_diff is truely bogus. Its not really a
> problem I guess because garbage in (bogus len_diff) garbage out is OK I
> think.

What's the rationale to not sanity check for it? I just double checked
the UAPI helper description comment ... at minimum this behavior would
need to be documented there to avoid confusion.

> For the patch,
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 

