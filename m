Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759222AFD4D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKLBbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:49140 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgKKXGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 18:06:30 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kczC4-0007Tc-5p; Thu, 12 Nov 2020 00:06:24 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kczC3-000XDo-Sk; Thu, 12 Nov 2020 00:06:23 +0100
Subject: Re: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
To:     Santucci Pierpaolo <santucci@epigenesys.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        sdf@google.com
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
 <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com>
 <87imacw3bh.fsf@cloudflare.com> <X6vxRV1zqn+GjLfL@santucci.pierpaolo>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <292adb9d-899a-fcb0-a37f-cd21e848fede@iogearbox.net>
Date:   Thu, 12 Nov 2020 00:06:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <X6vxRV1zqn+GjLfL@santucci.pierpaolo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25985/Wed Nov 11 14:18:01 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/20 3:12 PM, Santucci Pierpaolo wrote:
> Hi Jakub,
> 
> thanks for your reply.

(Santucci, please do not top-post but always reply inline which makes it
  easier for discussions to follow.)

> Let me explain the problem with an example.
> 
> Please consider the PCAP file:
> https://github.com/named-data/ndn-tools/blob/master/tests/dissect-wireshark/ipv6-udp-fragmented.pcap
> Let's assume that the dissector is invoked without the flag:
> BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL.
>   
> Without the proposed patch, the flow keys for the second fragment (packet
> timestamp 0.256997) will contain the value 0x6868 for the source and
> destination port fields: this is obviously wrong.
> The same happens for the third fragment (packet timestamp 0.256998) and for
> the fourth fragment (packet timestamp 0.257001).
> 
> So it seems that the correct thing to do is to stop the dissector after the
> IPV6 fragmentation header for all fragments from the second on.
> 
[...]
>>
>> I'm not initimately familiar with this test, but looking at the change
>> I'd consider that Destinations Options and encapsulation headers can
>> follow the Fragment Header.
>>
>> With enough of Dst Opts or levels of encapsulation, transport header
>> could be pushed to the 2nd fragment. So I'm not sure if the assertion
>> from the IPv4 dissector that 2nd fragment and following doesn't contain
>> any parseable header holds.

Hm, staring at rfc8200, it says that the first fragment packet must include
the upper-layer header (e.g. tcp, udp). The patch here should probably add a
comment wrt to the rfc.

Thanks,
Daniel
