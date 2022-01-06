Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803B14866A5
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiAFPUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240393AbiAFPUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:20:49 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9CDC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 07:20:49 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id kk22so2672201qvb.0
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 07:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v6XKL9w8DDqW134NFR0ZZiPgEt29wTgihCla/HbohNU=;
        b=ZLIC3rAXHUI6n4HrfIxZXszA/UViSub9Rhzec7ElgByhi+k2s0CeAhVqARpLk6Nd5a
         dJlfZyIJCqK+zv71c4hqBKfucuD32EPfoloN2CM+cdRIgNzizGhXO0auaRscRWhvRigR
         P5uU4dlH9zKS9EccT9V7bsCaPjkFWAvE2fFwzzYxLZXO1FuN1xkBPXJT2HcKanEfQ5UT
         EJo4PFiFOF4B8PPyLza2egDyzaXXTaMGAgVLzO7U52gCGQJnowKW0+gZ3tRB2Wojes2G
         9MgeTy/h8fdRqvLroNQYOSvaFTZ05CCTnCsVgJyLqNBUhTDQgS2gc/P07n7tPoLCLqE8
         556A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v6XKL9w8DDqW134NFR0ZZiPgEt29wTgihCla/HbohNU=;
        b=VaB4vOoPmltaSKeFs0xDtsonF/HaQ654Y/5N7ZBLjnHZtqbj4f+nAiJrnOgmjvRX98
         OYjmwTH2ntW4NKDKrFQ+6J13R0KZubAGwhGoRvNtVv132758snVKQMfNeTx3UDqfGNQN
         kHyC0fQETZ2SWZ0OCigeIb6H/Vt1NlwW3YGWYKEvYDYL4tSKi1G9I4RkGLVjUvzgApwN
         j5YoeiJWKG+H6XmxE8r+sjzubjWNvi5ykPCu9AxGS9s1KqUDtwjTZzzdTPMbuGVT9o0M
         a0jbbU1sh/LChWgLoCp/0yrOo8yfZuMYC0k8MpCHJvxyqlD/zpWPRoR6i9CDCe8MuuZw
         7+YA==
X-Gm-Message-State: AOAM533EhS15sq6YEpkZ11oWE+B+TyrX/WLkYUDxXusvVSl2DOpAH0EL
        MXQzKBEjvgz2sPam2EEeAEwQpopOhhzjlfIAorzNibc1hSzI6Q==
X-Google-Smtp-Source: ABdhPJzJzR/J5D5/3JOI8BFL1KvYXv47BWzwDXql8Tobsq32WYXRvb3gxvEIh9B2c+p+abes7an+lncEWMY1xQMEjdU=
X-Received: by 2002:a0c:f70d:: with SMTP id w13mr54399185qvn.99.1641482448446;
 Thu, 06 Jan 2022 07:20:48 -0800 (PST)
MIME-Version: 1.0
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
In-Reply-To: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 6 Jan 2022 10:20:32 -0500
Message-ID: <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
Subject: Re: Debugging stuck tcp connection across localhost
To:     Ben Greear <greearb@candelatech.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 10:06 AM Ben Greear <greearb@candelatech.com> wrote:
>
> Hello,
>
> I'm working on a strange problem, and could use some help if anyone has ideas.
>
> On a heavily loaded system (500+ wifi station devices, VRF device per 'real' netdev,
> traffic generation on the netdevs, etc), I see cases where two processes trying
> to communicate across localhost with TCP seem to get a stuck network
> connection:
>
> [greearb@bendt7 ben_debug]$ grep 4004 netstat.txt |grep 127.0.0.1
> tcp        0 7988926 127.0.0.1:4004          127.0.0.1:23184         ESTABLISHED
> tcp        0  59805 127.0.0.1:23184         127.0.0.1:4004          ESTABLISHED
>
> Both processes in question continue to execute, and as far as I can tell, they are properly
> attempting to read/write the socket, but they are reading/writing 0 bytes (these sockets
> are non blocking).  If one was stuck not reading, I would expect netstat
> to show bytes in the rcv buffer, but it is zero as you can see above.
>
> Kernel is 5.15.7+ local hacks.  I can only reproduce this in a big messy complicated
> test case, with my local ath10k-ct and other patches that enable virtual wifi stations,
> but my code can grab logs at time it sees the problem.  Is there anything
> more I can do to figure out why the TCP connection appears to be stuck?

It could be very useful to get more information about the state of all
the stuck connections (sender and receiver side) with something like:

  ss -tinmo 'sport = :4004 or sport = :4004'

I would recommend downloading and building a recent version of the
'ss' tool to maximize the information. Here is a recipe for doing
that:

 https://github.com/google/bbr/blob/master/Documentation/bbr-faq.md#how-can-i-monitor-linux-tcp-bbr-connections

It could also be very useful to collect and share packet traces, as
long as taking traces does not consume an infeasible amount of space,
or perturb timing in a way that makes the buggy behavior disappear.
For example, as root:

  tcpdump -w /tmp/trace.pcap -s 120 -c 100000000 -i any port 4004 &

If space is an issue, you might start taking traces once things get
stuck to see what the retry behavior, if any, looks like.

thanks,
neal
