Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7669F1B38D7
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 09:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDVHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 03:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgDVHWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 03:22:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A3C03C1A6;
        Wed, 22 Apr 2020 00:22:53 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id r16so752614edw.5;
        Wed, 22 Apr 2020 00:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uG6Og2QY3Jrt6pTu1AnmMqNruS91FdRXUooE0XdBD+8=;
        b=Gpj2Gyc8l3uOMNmeMD9MdFBn6dKr8nXeTcwutYx8Lg0zJSPXXDAlQE7RI3lcNmNwfy
         mVgYkC3JV0D67+7dirmdeUFZAismXWLuYMX/Qy4mxdaPDvhzdtF2kP3LHs5fRE4LwRZj
         o66vVRkHQJFTwQ/adikAVhOxj1HvtXb9fNVGR58sK46Cztvmtd+GwcaWzcnnx518Wqrl
         oonmE0VTv8Hh0LSW01IATsV7PPePqp3tuxaFkzH2WP2MOMVBaDzLZblL8lmgfJOfflIp
         CWZNqBk4Dal8iV6YCDVxVJcAaw3GReHPLDWEOHvqU1bJVlAbUXHXsNhqRIRaLWu9CTo9
         fYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uG6Og2QY3Jrt6pTu1AnmMqNruS91FdRXUooE0XdBD+8=;
        b=VKpjofRJKBrKnptdHbd+RFC6rH4JnsMtWE01qmc1p/D7Z8YEzoFBEJcj82EQmNeaGf
         q46Cm1yn0VtjidSssMD/VjaidsJb3Qnd7Rk6OpoAvFXVKg23JiHgvFWMia9XNBvBO6ri
         SUFAy2hNsALetf8USXkh71ad1Z09oXK5DF6XjbdJP0ufILqsLpv/Fqzi1ZkcU4+V7gQs
         Z1i+Y8W+ul8VQmI7L5XK/EqAiM1CPHIbEpjBjqZ0bX7LYYzBOsMlUcpjyGjMuXN4Z9Fs
         u3oURGBWoT4f/1r8S/BmlA0PrUzsqH3b9KDFlDmkoMs97iKfkOpwF3cIi5Y9F8yT8M+R
         qZ5w==
X-Gm-Message-State: AGi0PuYBBL1XGhQpMFNXLlIzmS7RL+OilrPt8nhU9/Xk5LWOamDJmF9Q
        32aJrFLjQyHLu2dPYECpM3dGcWyc/EmLWF9Gv3E=
X-Google-Smtp-Source: APiQypK8VJELWnfcfK/wcqgx6OHAbsYMxvX/T8/hTJry7NGjmJ9koGnCvPtLY9fvIBWkpNTHkjNwsDgaMhqXDCaHw+U=
X-Received: by 2002:aa7:da8b:: with SMTP id q11mr22791260eds.359.1587540172116;
 Wed, 22 Apr 2020 00:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200421171552.28393-1-luke.r.nels@gmail.com> <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com>
 <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com> <05CE7897-C58E-40C0-8E08-C8E948B70286@zytor.com>
In-Reply-To: <05CE7897-C58E-40C0-8E08-C8E948B70286@zytor.com>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Wed, 22 Apr 2020 00:22:16 -0700
Message-ID: <CAKU6vyaHcGmgznkDav1wpkB3MiSYM9G2pqmc6DELXwUyNpHwyQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX zero-extension
To:     hpa@zytor.com
Cc:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 12:13 AM <hpa@zytor.com> wrote:
> C7 C0 0 is *not* an invalid instruction, although it is incomplete. It is a different, but arguably even more serious, problem.

Yep, it would "eat" three bytes coming after that. :)
