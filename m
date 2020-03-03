Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6141770E3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 09:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgCCIMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 03:12:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:52414 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbgCCIMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 03:12:52 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j92fX-0000pi-6q; Tue, 03 Mar 2020 09:12:47 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j92fW-000MjX-Si; Tue, 03 Mar 2020 09:12:46 +0100
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
Date:   Tue, 3 Mar 2020 09:12:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87imjms8cm.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25739/Mon Mar  2 13:09:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 11:24 PM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> On Mon, Mar 2, 2020 at 2:12 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>> Andrii Nakryiko <andriin@fb.com> writes:
>>>
>>>> This patch series adds bpf_link abstraction, analogous to libbpf's already
>>>> existing bpf_link abstraction. This formalizes and makes more uniform existing
>>>> bpf_link-like BPF program link (attachment) types (raw tracepoint and tracing
>>>> links), which are FD-based objects that are automatically detached when last
>>>> file reference is closed. These types of BPF program links are switched to
>>>> using bpf_link framework.
>>>>
>>>> FD-based bpf_link approach provides great safety guarantees, by ensuring there
>>>> is not going to be an abandoned BPF program attached, if user process suddenly
>>>> exits or forgets to clean up after itself. This is especially important in
>>>> production environment and is what all the recent new BPF link types followed.
>>>>
>>>> One of the previously existing  inconveniences of FD-based approach, though,
>>>> was the scenario in which user process wants to install BPF link and exit, but
>>>> let attached BPF program run. Now, with bpf_link abstraction in place, it's
>>>> easy to support pinning links in BPF FS, which is done as part of the same
>>>> patch #1. This allows FD-based BPF program links to survive exit of a user
>>>> process and original file descriptor being closed, by creating an file entry
>>>> in BPF FS. This provides great safety by default, with simple way to opt out
>>>> for cases where it's needed.

I can see the motivation for this abstraction in particular for tracing, but given
the goal of bpf_link is to formalize and make the various program attachment types
more uniform, how is this going to solve e.g. the tc/BPF case? There is no guarantee
that while you create a link with the prog attached to cls_bpf that someone else is
going to replace that qdisc underneath you, and hence you end up with the same case
as if you would have only pinned the program itself (and not a link). So bpf_link
then gives a wrong impression that something is still attached and active while it
is not. What is the plan for these types?
