Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7044C402BB7
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345230AbhIGPZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345190AbhIGPZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 11:25:48 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C118C061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 08:24:42 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id c206so20518830ybb.12
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 08:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6hnF4rzaEcB3k0gEcqVjL/tjWG83NoIEoW0T87h7bg=;
        b=RLHio3+/t+nypb0HbIW6zWvs8ZtOTjm0TuTqXNa8GaBqgbOvRBLlRNcA1M6EO4bf1s
         9TkSzAZTxc3PdBRwhEoN6uSP1DIEpeYsNP0M/Lrntg5hfCoAeuM7FBFbIf5rA7N6RZOw
         36RQawSpxo/FCMBg9m7jfaQo1bnF5saStoD/Z3IjS5UQ04RDDkbLmqdkKUq12aANfadl
         +7YEdPHkPUvDLwhtt03iFtMMGpPyM0mxSX5/JMEUvkTDwOEqI6e+4ytXRej09tFCR/Kg
         pvIrjjgtLiD3o/DoXg9uD8nQ4AXSqRBhmSFFWqM2jOo+OkBKfHcRAIrozBvTmChpMhJy
         vaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6hnF4rzaEcB3k0gEcqVjL/tjWG83NoIEoW0T87h7bg=;
        b=PSq9v7weyv4dqDqrsChzguE+LFFj5UorS02i037sQx4Az+X9s73R8jD5VxQfNPg/Eo
         f1tAx3HXASDVO4YJ2Wq6oy/g55hRNq38+JrEP3BoVLrWYsc9EJwOK9Wf9UoqtnBM5Ba6
         NtR09rn6Di47NBIJuHytNgUbgv0vsuhIgbHgqEEntOL7ZeRg9uy6ZvyNf2obPmSLWP6r
         ZiSwiBUbCo6/93qi90TtEw7qnetdwtBvIuvk2baEtLi4nQGzKP0NU6HkwcGpRSXnacqy
         8STHW0N3uh7kbd0QILUiKlBlmhtdsNn8A0egsScyavUmGFlqhiHuk6SabDxUc8Jvk0BW
         Kscg==
X-Gm-Message-State: AOAM531By8v0fNvdSm2xYxefk3FHbYTiVDYdS6YUsjvVih3hsAHi4YQi
        H42xPu6AkrtZqJcksY1wpbMEZYiUGJQPqNFc5Cw7mA==
X-Google-Smtp-Source: ABdhPJywzMw7mWtKMQ4GK0ewd2Iz5tKKfqXK6YjsFj7kQ+VuzhQifI6vmPx12dXKIJ6B/yMG0a3FlC+1CRf7kjIrdl8=
X-Received: by 2002:a25:40b:: with SMTP id 11mr24851385ybe.398.1631028281091;
 Tue, 07 Sep 2021 08:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210904064044.125549-1-yan2228598786@gmail.com> <20210907111201.783d5ea2@gandalf.local.home>
In-Reply-To: <20210907111201.783d5ea2@gandalf.local.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Sep 2021 08:24:29 -0700
Message-ID: <CANn89iJVc3kNU+4biyHRQtUQVYQpN5sPDTW5sfpyCo8uV-uSpg@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for
 tracing v4
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, 2228598786@qq.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 8:12 AM Steven Rostedt <rostedt@goodmis.org> wrote:

> Just curious. Is "Tcp" the normal way to write "TCP" in the kernel? I see
> it in snmp_seq_show_tcp_udp() in net/ipv4/proc.c, but no where else
> (besides doing CamelCase words). Should these be written using "TCP"
> instead of "Tcp". It just looks awkward to me.
>

Yes, we prefer tcp or TCP, although SNMP counters have Tcp in them,
for some reason
( grep Tcp /proc/net/netstat /proc/net/snmp ), that can not be changed.
