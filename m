Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032EA2A3F40
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgKCIqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:46:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:34794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgKCIqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:46:48 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kZrxW-0007cZ-IC; Tue, 03 Nov 2020 09:46:30 +0100
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kZrxW-000ARu-8N; Tue, 03 Nov 2020 09:46:30 +0100
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
Date:   Tue, 3 Nov 2020 09:46:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25976/Mon Nov  2 14:23:56 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 7:58 AM, Andrii Nakryiko wrote:
> On Mon, Nov 2, 2020 at 7:47 AM David Ahern <dsahern@gmail.com> wrote:
>> On 10/29/20 9:11 AM, Hangbin Liu wrote:
>>> This series converts iproute2 to use libbpf for loading and attaching
>>> BPF programs when it is available. This means that iproute2 will
>>> correctly process BTF information and support the new-style BTF-defined
>>> maps, while keeping compatibility with the old internal map definition
>>> syntax.
>>>
>>> This is achieved by checking for libbpf at './configure' time, and using
>>> it if available. By default the system libbpf will be used, but static
>>> linking against a custom libbpf version can be achieved by passing
>>> LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
>>> abort if no suitable libbpf is found (useful for automatic packaging
>>> that wants to enforce the dependency).
>>>
>>> The old iproute2 bpf code is kept and will be used if no suitable libbpf
>>> is available. When using libbpf, wrapper code ensures that iproute2 will
>>> still understand the old map definition format, including populating
>>> map-in-map and tail call maps before load.
>>>
>>> The examples in bpf/examples are kept, and a separate set of examples
>>> are added with BTF-based map definitions for those examples where this
>>> is possible (libbpf doesn't currently support declaratively populating
>>> tail call maps).
>>>
>>> At last, Thanks a lot for Toke's help on this patch set.
>>
>> In regards to comments from v2 of the series:
>>
>> iproute2 is a stable, production package that requires minimal support
>> from external libraries. The external packages it does require are also
>> stable with few to no relevant changes.
>>
>> bpf and libbpf on the other hand are under active development and
>> rapidly changing month over month. The git submodule approach has its
>> conveniences for rapid development but is inappropriate for a package
>> like iproute2 and will not be considered.

I thought last time this discussion came up there was consensus that the
submodule could be an explicit opt in for the configure script at least?
