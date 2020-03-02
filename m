Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE1217654B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 21:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCBUsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 15:48:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:58558 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgCBUsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 15:48:25 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j8rzB-0006Z2-MW; Mon, 02 Mar 2020 21:48:21 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j8rzB-000UnY-Am; Mon, 02 Mar 2020 21:48:21 +0100
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to
 enums
To:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200301062405.2850114-1-andriin@fb.com>
 <20200301062405.2850114-2-andriin@fb.com>
 <b57cdf6d-0849-2d54-982e-352886f86201@fb.com>
 <CAEf4BzZspu-wXMr6v=Sd-_m-XzXJwJHyU9zd0ydEiWmch8F9GQ@mail.gmail.com>
 <af9e3e1e-e1e9-0462-88a4-93fd06c40957@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6b5d7686-428b-5812-75c7-c9d38847f48c@iogearbox.net>
Date:   Mon, 2 Mar 2020 21:48:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <af9e3e1e-e1e9-0462-88a4-93fd06c40957@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25739/Mon Mar  2 13:09:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 7:33 PM, Yonghong Song wrote:
> On 3/2/20 10:25 AM, Andrii Nakryiko wrote:
>> On Mon, Mar 2, 2020 at 8:22 AM Yonghong Song <yhs@fb.com> wrote:
>>> On 2/29/20 10:24 PM, Andrii Nakryiko wrote:
>>>> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
>>>> enum values. This preserves constants values and behavior in expressions, but
>>>> has added advantaged of being captured as part of DWARF and, subsequently, BTF
>>>> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
>>>> for BPF applications, as it will not require BPF users to copy/paste various
>>>> flags and constants, which are frequently used with BPF helpers.
>>>>
>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>> ---
>>>>    include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
>>>>    include/uapi/linux/bpf_common.h       |  86 ++++----
>>>>    include/uapi/linux/btf.h              |  60 +++---
>>>>    tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
>>>>    tools/include/uapi/linux/bpf_common.h |  86 ++++----
>>>>    tools/include/uapi/linux/btf.h        |  60 +++---
>>>>    6 files changed, 497 insertions(+), 341 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>> index 8e98ced0963b..03e08f256bd1 100644
>>>> --- a/include/uapi/linux/bpf.h
>>>> +++ b/include/uapi/linux/bpf.h
>>>> @@ -14,34 +14,36 @@
>>>>    /* Extended instruction set based on top of classic BPF */
>>>>
>>>>    /* instruction classes */
>>>> -#define BPF_JMP32    0x06    /* jmp mode in word width */
>>>> -#define BPF_ALU64    0x07    /* alu mode in double word width */
>>>> +enum {
>>>> +     BPF_JMP32       = 0x06, /* jmp mode in word width */
>>>> +     BPF_ALU64       = 0x07, /* alu mode in double word width */
>>>
>>> Not sure whether we have uapi backward compatibility or not.

We do, after all it's uapi. I think the only expectation people might have is that
if they use custom stuff with BPF_ prefix in their own code that there could potentially
be collisions with future additions to this uapi header, but otherwise existing constructs
in their own code that rely on existing (e.g.) defines in this header must not break.

>>> One possibility is to add
>>>     #define BPF_ALU64 BPF_ALU64
>>> this way, people uses macros will continue to work.

Yep. :-/

>> This is going to be a really ugly solution, though. I wonder if it was
>> ever an expected behavior of UAPI constants to be able to do #ifdef on
>> them.

Yes, that will be quite ugly. We still would have the freedom to split the giant bpf.h
into smaller chunks e.g. under include/uapi/linux/bpf/ and perhaps trying to get some
systematic order that way. Like splitting out include/uapi/linux/bpf/insns.h where we
do this enum/define only for the insns etc. While that doesn't change the fact that this
would be needed, it at least doesn't look too random/chaotic all over the place in bpf.h.

>> Do you know any existing application that relies on those constants
>> being #defines?
> 
> I did not have enough experience to work with system level applications.
> But in linux/in.h we have
> 
> #if __UAPI_DEF_IN_IPPROTO
> /* Standard well-defined IP protocols.  */
> enum {
>    IPPROTO_IP = 0,               /* Dummy protocol for TCP               */
> #define IPPROTO_IP              IPPROTO_IP
>    IPPROTO_ICMP = 1,             /* Internet Control Message Protocol    */
> #define IPPROTO_ICMP            IPPROTO_ICMP
>    IPPROTO_IGMP = 2,             /* Internet Group Management Protocol   */
> #define IPPROTO_IGMP            IPPROTO_IGMP
>    IPPROTO_IPIP = 4,             /* IPIP tunnels (older KA9Q tunnels use 94) */
> #define IPPROTO_IPIP            IPPROTO_IPIP
>    IPPROTO_TCP = 6,              /* Transmission Control Protocol        */
> #define IPPROTO_TCP             IPPROTO_TCP
>    IPPROTO_EGP = 8,              /* Exterior Gateway Protocol            */
> #define IPPROTO_EGP             IPPROTO_EGP
>    IPPROTO_PUP = 12,             /* PUP protocol                         */
> #define IPPROTO_PUP             IPPROTO_PUP
>    IPPROTO_UDP = 17,             /* User Datagram Protocol               */
> #define IPPROTO_UDP             IPPROTO_UDP
>    IPPROTO_IDP = 22,             /* XNS IDP protocol                     */
> #define IPPROTO_IDP             IPPROTO_IDP
> 
> ...
