Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200EE1B389F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 09:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgDVHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 03:14:25 -0400
Received: from terminus.zytor.com ([198.137.202.136]:53581 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgDVHOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 03:14:25 -0400
Received: from [IPv6:2601:646:8600:3281:6143:342c:a7b5:2aff] ([IPv6:2601:646:8600:3281:6143:342c:a7b5:2aff])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 03M7DDeA1574159
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 22 Apr 2020 00:13:13 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 03M7DDeA1574159
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020032201; t=1587539595;
        bh=lH8gR7qP0904USQOkMbGHlaYsVmsBUEDU6HZANY9l5Q=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=E6E9K5GNGb5YxI5PCvOZ+/KVS5+26zVj/lL9RqmhUTHnQUZ70CaW44z6C8uycRn09
         zTooMqwQej182vKDbvkfs1MpBRLW3z3aMhFlfU3V40b/JnZu5pEsbkD0IMlJErJtRE
         HszNcds2h7TV4CRAIjOvYlJzyPdKVQn6sza1s5jUxNXu6jzqN+sr8cF4ssUigAH0Kk
         4JdiZM+6gUH+5cRO6TuvASOgWef4OneknTNlvzRGAyjHS4TXd9bIav3JpTCq2dmbtZ
         gopDzQNo+/fhXzjF5XsJAScgfRo6UUzFKz0xCuLNQnhNjkV9w/jYdkt5lZc5ZiXt4C
         XMoNzHfAA63wQ==
Date:   Wed, 22 Apr 2020 00:13:05 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com>
References: <20200421171552.28393-1-luke.r.nels@gmail.com> <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com> <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX zero-extension
To:     Xi Wang <xi.wang@gmail.com>
CC:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
        Luke Nelson <luke.r.nels@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   hpa@zytor.com
Message-ID: <05CE7897-C58E-40C0-8E08-C8E948B70286@zytor.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On April 21, 2020 12:26:12 PM PDT, Xi Wang <xi=2Ewang@gmail=2Ecom> wrote:
>On Tue, Apr 21, 2020 at 10:39 AM H=2E Peter Anvin <hpa@zytor=2Ecom> wrote=
:
>> x32 is not x86-32=2E  In Linux we generally call the latter "i386"=2E
>
>Agreed=2E  Most of the previous patches to this file use "x32" and this
>one just wanted to be consistent=2E
>
>> C7 /0 imm32 is a valid instruction on i386=2E However, it is also
>> inefficient when the destination is a register, because B8+r imm32 is
>> equivalent, and when the value is zero, XOR is indeed more efficient=2E
>>
>> The real error is using EMIT3() instead of EMIT2_off32(), but XOR is
>> more efficient=2E However, let's make the bug statement *correct*, or
>it
>> is going to confuse the Hades out of people in the future=2E
>
>I don't see how the bug statement is incorrect, which merely points
>out that "C7 C0 0" is an invalid instruction, regardless of whether
>the JIT intended to emit C7 /0 imm32, B8+r imm32, 31 /r, 33 /r, or any
>other equivalent form=2E

C7 C0 0 is *not* an invalid instruction, although it is incomplete=2E It i=
s a different, but arguably even more serious, problem=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
