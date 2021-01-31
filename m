Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA5309C1E
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhAaMtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhAaLg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 06:36:58 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3E7C061786
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 03:14:15 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id j4so6779772qvk.6
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 03:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=M6FYv2E9knGDI0iH5735540Zhg7wHmzZM3kiJ0bDwD8=;
        b=kdAJi0ttpQ2n0qnKhIK0PLMC+m6DJUNgxjpcbTKjTE6lM3zj0UL7zhRVEwgIAm4G34
         ENbHTaggz1X9MPXhlyoGaH8PVPS9s1JMoE3nVw9Ez/Nf0GAdWmFy7VIeQs+LyAtED47U
         amEOHoXcK6qp/aEU3+9zbeLnjXedMYDHOj6+nA53IgrEHIV+xzZE9LI/MaEvCZBQAOBQ
         dX1I1bKCqcOAHPcCbf3mmwVUS3qXbG2kBzltodoEiaQ17i2N5LjyONOAVVPw92BOu3fF
         Y4n73EDxa81fXu2KoFaf0DTwopN9dj9SoVNDzbnbRyPi2DCnoAzxi6njPL3Zn7Z+qy9p
         GyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=M6FYv2E9knGDI0iH5735540Zhg7wHmzZM3kiJ0bDwD8=;
        b=ZlvGFqbC9BEcnA+GQn65zsmNK0zliwlw43mf2AUSDsJh4ybXQyVXnxznbwl/DQahAR
         mN24IGr39vdi50+IWoAK58TjiEWoQddFFFVwhHvu7zsr+1kep6JbwTSupyzXBcxAgeyg
         lB+k4OnxkRBBVKqXfe/EkWZxO8xw3jX+QYMedrkPpYm94xBhlN9zISoomglmKND/uhuw
         oWN442jGsKiD6P1hzBECAzPXPo49fQRIoJsPYWakx66p/7hsi0CaMtWzY3OwCId0T9yO
         +pSGEXr4U/3iS28HQ/mEf4ArHrbB/GaE8a50G8xEOQaOR7nuOzJ1Fwcj2CWvsRI7/J76
         GUag==
X-Gm-Message-State: AOAM531UTpihc0Sru5RJwZpzhSXYe5Gv3Jj4xuTVLHeiIqdhOrYiV5ue
        05WjgXTlwfqt6OWDEyczEAGoWd/RN4e1JEJKsAhYMQ==
X-Google-Smtp-Source: ABdhPJzAOYh6Z+vnGrWEgn3eJO0QOVKZGIK+91A/+wCbtzCZpJMtO2ghtP9/7nfcXhMpvwMO9YniWvCQcfbLsrKHuVE=
X-Received: by 2002:a0c:8304:: with SMTP id j4mr11269583qva.18.1612091653636;
 Sun, 31 Jan 2021 03:14:13 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 31 Jan 2021 12:14:02 +0100
Message-ID: <CACT4Y+a7UBQpAY4vwT8Od0JhwbwcDrbJXZ_ULpPfJZ42Ew-yCQ@mail.gmail.com>
Subject: extended bpf_send_signal_thread with argument
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>, kpsingh@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I would like to send a signal from a bpf program invoked from a
perf_event. There is:

// kernel/trace/bpf_trace.c
BPF_CALL_1(bpf_send_signal_thread, u32, sig)

which is nice, but it does not allow me to pass any arguments.
I can use a bpf map indexed by pid to "pass" some additional info, but
it's messy and slow (and may cause some synchronization issues, I am
not sure yet).

Signals allow to pass additional arguments, it would be nice to expose
this to bpf programs as well. Any objections? Do you see any potential
issues with this? On the implementation side it seems to be almost
trivial to add something like this:

BPF_CALL_2(bpf_send_signal_thread_ex, u32, sig, uintptr_t sival)

However, siginfo_t is way larger and allows to pass a whole lot of
info, and the latest user-space APIs pidfd_send_signal just directly
accepts siginfo_t (and rt_tgsigqueueinfo as well). But I am not sure
how to expose it according to bpf rules. Could we do something like
(pass whatever you want, it's your business)?

BPF_CALL_2(bpf_send_signal_thread_ex, u32, sig, char siginfo[sizeof(siginfo_t)])

Does it make sense? If yes, what would be the best way to expose this?

Thanks
