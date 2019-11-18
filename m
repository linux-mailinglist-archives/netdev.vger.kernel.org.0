Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEDC100BAB
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKRSnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:43:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:55840 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfKRSnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:43:39 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWlzt-0003iO-RR; Mon, 18 Nov 2019 19:43:37 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWlzt-00062j-HA; Mon, 18 Nov 2019 19:43:37 +0100
Subject: Re: [PATCH rfc bpf-next 5/8] bpf: add jit poke descriptor mock-up for
 jit images
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <253496a26ac83e0fe7c830eb27e62ca441a38aff.1573779287.git.daniel@iogearbox.net>
 <CAEf4BzZjUvsf6wGuh2JyEBKLOsJD7ihQMwF69CbM3DsR0tN0bg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <10321d85-b9e5-e786-53eb-b4ff6d981e2c@iogearbox.net>
Date:   Mon, 18 Nov 2019 19:43:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZjUvsf6wGuh2JyEBKLOsJD7ihQMwF69CbM3DsR0tN0bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 7:17 PM, Andrii Nakryiko wrote:
> On Thu, Nov 14, 2019 at 5:05 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Add initial poke table data structures and management to the BPF
>> prog that can later be used by JITs. Also add an instance of poke
>> specific data for tail call maps. Plan for later work is to extend
>> this also for BPF static keys.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
> 
> looks good, just one more minor naming nit
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   include/linux/bpf.h    | 20 ++++++++++++++++++++
>>   include/linux/filter.h | 10 ++++++++++
>>   kernel/bpf/core.c      | 34 ++++++++++++++++++++++++++++++++++
>>   3 files changed, 64 insertions(+)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 40337fa0e463..0ff06a0d0058 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -484,6 +484,24 @@ struct bpf_func_info_aux {
>>          bool unreliable;
>>   };
>>
>> +enum bpf_jit_poke_reason {
>> +       BPF_POKE_REASON_TAIL_CALL,
>> +};
>> +
>> +/* Descriptor of pokes pointing /into/ the JITed image. */
>> +struct bpf_jit_poke_descriptor {
>> +       void *ip;
>> +       union {
>> +               struct {
>> +                       struct bpf_map *map;
>> +                       u32 key;
>> +               } tc;
> 
> tc is a bit overloaded abbreviation, tail_call would be super-clear, though ;)

Ok, sure, will include it into the non-rfc version.

>> +       };
>> +       u8 ip_stable;
>> +       u8 adj_off;
>> +       u16 reason;
>> +};
>> +
> 
> [...]
> 

