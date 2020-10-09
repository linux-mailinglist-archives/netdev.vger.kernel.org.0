Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE217289A33
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391245AbgJIVJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:09:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:43796 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389097AbgJIVJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:09:57 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzeC-0001Tz-Mz; Fri, 09 Oct 2020 23:09:52 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzeC-000Opb-H0; Fri, 09 Oct 2020 23:09:52 +0200
Subject: Re: [PATCH bpf-next v3 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20201009204245.27905-1-daniel@iogearbox.net>
 <20201009204245.27905-4-daniel@iogearbox.net>
 <20201009210413.kml5vfefehdzv7ub@ast-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d2fdc2d0-96cf-2cc6-6872-a7dd32bd7499@iogearbox.net>
Date:   Fri, 9 Oct 2020 23:09:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201009210413.kml5vfefehdzv7ub@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 11:04 PM, Alexei Starovoitov wrote:
> On Fri, Oct 09, 2020 at 10:42:42PM +0200, Daniel Borkmann wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index b97bc5abb3b8..593963e40956 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -435,6 +435,11 @@ enum {
>>   
>>   /* Share perf_event among processes */
>>   	BPF_F_PRESERVE_ELEMS	= (1U << 11),
>> +
>> +/* Do not inline (array) map lookups so the array map can be used for
>> + * map in map with dynamic max entries.
>> + */
>> +	BPF_F_NO_INLINE		= (1U << 12),
>>   };
> 
> I'm worried about this one.
> It exposes internal detail into uapi.
> Most users are not even aware of that map_lookup_elem() can be 'inlined'.
> 
> How about renaming the flag into BPF_F_INNER_MAP ?
> This way if we change the implementation later it will still be sane from uapi pov.
> The comment above the flag can say:
> /* Create a map that is suitable to be an inner map with dynamic max entries  */
> 
> Or some other name ?
> May be tomorrow we decide to simply load max_entries value in array_map_gen_lookup().
> The progs will become a bit slower, but it could be fine if we also do another
> optimization at the same time. Like the verifier can detect that 'key' is const
> and optimize it even further. Than slower gen_lookup for inner and all arrays
> will be mitigated by ultra fast lookup when !F_INNER_MAP and key is const.
> For F_INNER_MAP and key is const we could still do better inlining.

Hm, yes, agree. BPF_F_INNER_MAP is more generic and doesn't tell anything about
implementation, and ultimately it's only about using it as inner array. I'll take
it and do a v4.

Thanks,
Daniel
