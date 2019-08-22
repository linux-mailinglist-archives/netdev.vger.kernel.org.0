Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9371998DC9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbfHVId4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:33:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:41210 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfHVId4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 04:33:56 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0iXP-0006qM-Se; Thu, 22 Aug 2019 10:33:43 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0iXP-000JYh-DQ; Thu, 22 Aug 2019 10:33:43 +0200
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20190820114706.18546-1-toke@redhat.com>
 <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk>
 <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
Date:   Thu, 22 Aug 2019 10:33:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25548/Wed Aug 21 10:27:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 9:49 AM, Andrii Nakryiko wrote:
> On Wed, Aug 21, 2019 at 2:07 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>> On Tue, Aug 20, 2019 at 4:47 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>>
>>>> iproute2 uses its own bpf loader to load eBPF programs, which has
>>>> evolved separately from libbpf. Since we are now standardising on
>>>> libbpf, this becomes a problem as iproute2 is slowly accumulating
>>>> feature incompatibilities with libbpf-based loaders. In particular,
>>>> iproute2 has its own (expanded) version of the map definition struct,
>>>> which makes it difficult to write programs that can be loaded with both
>>>> custom loaders and iproute2.
>>>>
>>>> This series seeks to address this by converting iproute2 to using libbpf
>>>> for all its bpf needs. This version is an early proof-of-concept RFC, to
>>>> get some feedback on whether people think this is the right direction.
>>>>
>>>> What this series does is the following:
>>>>
>>>> - Updates the libbpf map definition struct to match that of iproute2
>>>>    (patch 1).
>>>
>>> Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
>>> totally in support of making iproute2 use libbpf to load/initialize
>>> BPF programs. But I'm against adding iproute2-specific fields to
>>> libbpf's bpf_map_def definitions to support this.
>>>
>>> I've proposed the plan of extending libbpf's supported features so
>>> that it can be used to load iproute2-style BPF programs earlier,
>>> please see discussions in [0] and [1].
>>
>> Yeah, I've seen that discussion, and agree that longer term this is
>> probably a better way to do map-in-map definitions.
>>
>> However, I view your proposal as complementary to this series: we'll
>> probably also want the BTF-based definition to work with iproute2, and
>> that means iproute2 needs to be ported to libbpf. But iproute2 needs to
>> be backwards compatible with the format it supports now, and, well, this
>> series is the simplest way to achieve that IMO :)
> 
> Ok, I understand that. But I'd still want to avoid adding extra cruft
> to libbpf just for backwards-compatibility with *exact* iproute2
> format. Libbpf as a whole is trying to move away from relying on
> binary bpf_map_def and into using BTF-defined map definitions, and
> this patch series is a step backwards in that regard, that adds,
> essentially, already outdated stuff that we'll need to support forever
> (I mean those extra fields in bpf_map_def, that will stay there
> forever).

Agree, adding these extensions for libbpf would be a step backwards
compared to using BTF defined map defs.

> We've discussed one way to deal with it, IMO, in a cleaner way. It can
> be done in few steps:
> 
> 1. I originally wanted BTF-defined map definitions to ignore unknown
> fields. It shouldn't be a default mode, but it should be supported
> (and of course is very easy to add). So let's add that and let libbpf
> ignore unknown stuff.
> 
> 2. Then to let iproute2 loader deal with backwards-compatibility for
> libbpf-incompatible bpf_elf_map, we need to "pass-through" all those
> fields so that users of libbpf (iproute2 loader, in this case) can
> make use of it. The easiest and cleanest way to do this is to expose
> BTF ID of a type describing each map entry and let iproute2 process
> that in whichever way it sees fit.
> 
> Luckily, bpf_elf_map is compatible in `type` field, which will let
> libbpf recognize bpf_elf_map as map definition. All the rest setup
> will be done by iproute2, by processing BTF of bpf_elf_map, which will
> let it set up map sizes, flags and do all of its map-in-map magic.
> 
> The only additions to libbpf in this case would be a new `__u32
> bpf_map__btf_id(struct bpf_map* map);` API.
> 
> I haven't written any code and haven't 100% checked that this will
> cover everything, but I think we should try. This will allow to let
> users of libbpf do custom stuff with map definitions without having to
> put all this extra logic into libbpf itself, which I think is
> desirable outcome.

Sounds reasonable in general, but all this still has the issue that we're
assuming that BTF is /always/ present. Existing object files that would load
just fine /today/ but do not have BTF attached won't be handled here. Wouldn't
it be more straight forward to allow passing callbacks to the libbpf loader
such that if the map section is not found to be bpf_map_def compatible, we
rely on external user aka callback to parse the ELF section, handle any
non-default libbpf behavior like pinning/retrieving from BPF fs, populate
related internal libbpf map data structures and pass control back to libbpf
loader afterwards. (Similar callback with prog section name handling for the
case where tail call maps get automatically populated.)

Thanks,
Daniel
