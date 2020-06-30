Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCA720FE41
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgF3U4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgF3U4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:56:23 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03482C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:56:23 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id s1so10765304ybo.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lTz7GqcDwurWAANYbVdiGG5v7StqCSKnvTD7ZYiQAT4=;
        b=Zo5pyCgoQQhsEk+lR79XTHQe/3DF+GG97O9/mQ3PYTb4SUZ40fjJrZoVgJd+IOH5VX
         CLN7PDArP5pqpykX2PomyAxddIFF0fzfSSPSl09d2ZuieD7QrEHw9WWcURjmi4Y38PsK
         S6NETrYKOyvK85MEc9aIo7wOiq/M5d0gPj5WH1yG8Ajs67NOBMZ82AYJICY06eSZW11m
         q5QLcmfjBVgUqanwxd4u0Q6yPJ+DHRKApaFsNUcOR+UjdTo0QK3jVczenT4pRpEvzp8E
         1SyA9BXHyeN70WbNaDvJE8GMPicyyq2B5iy7ApGc9k7VMfh/Lz1RxwFaa5xuMWAHeSDa
         bJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lTz7GqcDwurWAANYbVdiGG5v7StqCSKnvTD7ZYiQAT4=;
        b=EzMg1CNqo/Xqj3vmY+0pY42J1D4WqXn0EKHvy6QWdf4KIcsXE5Ckq2RlyouqeZepDW
         ocxoIEuzn0q47tRPIKramOJTqn0sHs9cdCL2o/jYtpx+uYvfagJyDdKiw1ISvh66P1ck
         +kMtDWbmozNUXsXb5fRQt2SL85My28ZZR10jH6ZcCHKKpkUwhdhaLnb7JPKmjZ2vMBDP
         +QM8ycTLevQfsSDkb9e9328xmR4Je0JbFOxmfMxJODt6c7Vl8bYCJMVr3XNtT81+yxXB
         0D88624LkyOEA8VCN1MEaM5o7Fxub+DYwpa9+zB6UF77YPMHXPZeZztxffoqP+wtDkkG
         D6OA==
X-Gm-Message-State: AOAM531JX0b1vwYt7XDgRnZdGo1nJYkUL8XNQXzSHIrMfmE+/I4C1/3L
        6/u9Ld+U6E8tRJfavj3Rr0Jj/SKaru6ym6rVC/uyog==
X-Google-Smtp-Source: ABdhPJzTJIY/4bZuSGrofTXLrB83Ak49AR2hs1sGOhNuXjZkCj6/L3gA+M0RjOasX0deVY7WAFybgHRMeiMUpfyWKzE=
X-Received: by 2002:a25:941:: with SMTP id u1mr39107661ybm.274.1593550581808;
 Tue, 30 Jun 2020 13:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
 <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
 <CANn89iJ+rkMrLrHrKXO-57frXNb32epB93LYLRuHX00uWc-0Uw@mail.gmail.com> <20200630.134429.1590957032456466647.davem@davemloft.net>
In-Reply-To: <20200630.134429.1590957032456466647.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 13:56:10 -0700
Message-ID: <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     David Miller <davem@davemloft.net>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 1:44 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Tue, 30 Jun 2020 13:39:27 -0700
>
> > The (C) & (B) case are certainly doable.
> >
> > A) case is more complex, I have no idea of breakages of various TCP
> > stacks if a flow got SACK
> > at some point (in 3WHS) but suddenly becomes Reno.
>
> I agree that C and B are the easiest to implement without having to
> add complicated code to handle various negotiated TCP option
> scenerios.
>
> It does seem to be that some entities do A, or did I misread your
> behavioral analysis of various implementations Mathieu?
>
> Thanks.

Yes, another question about Mathieu cases is do determine the behavior
of all these stacks vs :
SACK option
TCP TS option.
