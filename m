Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D352B52BE
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgKPUha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:37:30 -0500
Received: from mail.efficios.com ([167.114.26.124]:44106 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730723AbgKPUh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 15:37:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6B56D2D0BB6;
        Mon, 16 Nov 2020 15:37:28 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5xVR0ch7qYPQ; Mon, 16 Nov 2020 15:37:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 094552D08E4;
        Mon, 16 Nov 2020 15:37:28 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 094552D08E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605559048;
        bh=kBFLZ9EW89Wp5uMRdFavHrh8o0YWg+z4bzCgnMbLUvE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=p390yQpgofXukqGCurhuyKHPUFZ7fvQAiDk7AT9PVmrdPy4pb10Msf3CWHTUvtZEl
         CLPowz6UgqeS9GqmGc4HBtaqo11TNvRUVGTM0jKfuwSES0Z2FO8XO5QRMN1NTNaxw9
         f5j6p6hu4Fb4Z03TCalB55QVJNw8KaiBpsnnp+viK9CyMx4cXK6S2/sDjREhS5lqdQ
         jVHujnF1syaVVOQNRcwiSrHKXbTHPvFE90Y3kkrIskyfkHfLJRg1ps1WixUAn/Eaqe
         3rnw3aC3Cb1Ogt40YG+uEcCZDH4VbAKsgghMKK/LQoWUmp3zdd+A42T2biUuWESo0e
         6OfP/ljztezdw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RGqurea8Cm3D; Mon, 16 Nov 2020 15:37:27 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id E8CC92D09C8;
        Mon, 16 Nov 2020 15:37:27 -0500 (EST)
Date:   Mon, 16 Nov 2020 15:37:27 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>, paulmck <paulmck@kernel.org>
Cc:     Matt Mullins <mmullins@mmlx.us>, Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201116121929.1a7aeb16@gandalf.local.home>
References: <00000000000004500b05b31e68ce@google.com> <20201115055256.65625-1-mmullins@mmlx.us> <20201116121929.1a7aeb16@gandalf.local.home>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: don't fail kmalloc while releasing raw_tp
Thread-Index: zn74f4GdZFZcw2xYb9djl8cQZU8krQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 16, 2020, at 12:19 PM, rostedt rostedt@goodmis.org wrote:

> On Sat, 14 Nov 2020 21:52:55 -0800
> Matt Mullins <mmullins@mmlx.us> wrote:
> 
>> bpf_link_free is always called in process context, including from a
>> workqueue and from __fput.  Neither of these have the ability to
>> propagate an -ENOMEM to the caller.
>> 
> 
> Hmm, I think the real fix is to not have unregistering a tracepoint probe
> fail because of allocation. We are removing a probe, perhaps we could just
> inject NULL pointer that gets checked via the DO_TRACE loop?
> 
> I bet failing an unregister because of an allocation failure causes
> problems elsewhere than just BPF.
> 
> Mathieu,
> 
> Can't we do something that would still allow to unregister a probe even if
> a new probe array fails to allocate? We could kick off a irq work to try to
> clean up the probe at a later time, but still, the unregister itself should
> not fail due to memory failure.

Currently, the fast path iteration looks like:

                struct tracepoint_func *it_func_ptr;
                void *it_func;

                it_func_ptr =                                           \
                        rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
                do {                                                    \
                        it_func = (it_func_ptr)->func;                  \
                        __data = (it_func_ptr)->data;                   \
                        ((void(*)(void *, proto))(it_func))(__data, args); \
                } while ((++it_func_ptr)->func); 

So we RCU dereference the array, and iterate on the array until we find a NULL
func. So you could not use NULL to skip items, but you could perhaps reserve
a (void *)0x1UL tombstone for this.

It should ideally be an unlikely branch, and it would be good to benchmark the
change when multiple tracing probes are attached to figure out whether the
overhead is significant when tracing is enabled.

I wonder whether we really mind that much about using slightly more memory
than required after a failed reallocation due to ENOMEM. Perhaps the irq work
is not even needed. Chances are that the irq work would fail again and again if
it's in low memory conditions. So maybe it's better to just keep the tombstone
in place until the next successful callback array reallocation.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
