Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86E143344
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgATVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:11:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:47586 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATVLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:11:54 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iteKb-0003tQ-OR; Mon, 20 Jan 2020 22:11:33 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iteKa-00019l-UX; Mon, 20 Jan 2020 22:11:33 +0100
Subject: Re: [PATCH bpf-next] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
To:     Matt Cover <werekraken@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jiong Wang <jiong.wang@netronome.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <5e23c773d7a67_13602b2359ea05b824@john-XPS-13-9370.notmuch>
 <CAGyo_hrUXWzui9FNiZpNGXjsphSreLEYYm4K7xkp+H+de=QKSA@mail.gmail.com>
 <CAGyo_hpcO-f9uxQFDfKZNz=1t6Yux+LzxN1qLHKf6PXMAtWQ-w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <360a11cd-2c41-159e-b92a-c7c1ec42767f@iogearbox.net>
Date:   Mon, 20 Jan 2020 22:11:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAGyo_hpcO-f9uxQFDfKZNz=1t6Yux+LzxN1qLHKf6PXMAtWQ-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25701/Mon Jan 20 12:41:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/20 9:10 PM, Matt Cover wrote:
> On Mon, Jan 20, 2020 at 11:11 AM Matt Cover <werekraken@gmail.com> wrote:
>> On Sat, Jan 18, 2020 at 8:05 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>> Matthew Cover wrote:
>>>> Allow looking up an nf_conn. This allows eBPF programs to leverage
>>>> nf_conntrack state for similar purposes to socket state use cases,
>>>> as provided by the socket lookup helpers. This is particularly
>>>> useful when nf_conntrack state is locally available, but socket
>>>> state is not.
>>>>
>>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
>>>> ---
>>>
>>> Couple coding comments below. Also looks like a couple build errors
>>> so fix those up. I'm still thinking over this though.
>>
>> Thank you for taking the time to look this over. I will be looking
>> into the build issues.
> 
> Looks like I missed static inline on a couple functions when
> nf_conntrack isn't builtin. I'll include the fix in v2.

One of the big issues I'd see with this integration is that literally no-one
will be able to use it unless they manually recompile their distro kernel with
ct as builtin instead of module .. Have you considered writing a tcp/udp ct in
plain bpf? Perhaps would make sense to have some sort of tools/lib/bpf/util/
with bpf prog library code that can be included.
