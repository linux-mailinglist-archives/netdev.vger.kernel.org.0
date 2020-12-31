Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617C62E81E7
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 21:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgLaUO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 15:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLaUO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 15:14:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5417BC061573
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 12:14:16 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id o8so19846717ybq.22
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 12:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=I8HcRE9PQpGzhtd57DtZYJVZUrGRfD/rQqXsgrN7czY=;
        b=TkZCSGqVVCfqJ9RZYyFppUa9sTp/R3bTHPDiP7o6WSXgD/VmlCbh6B+YgEpejah6xP
         OcfUNT4fmzH54LUpsMKjjuTCbZ70b64VZbVgPEz8fY0vFBlRVe3YNrXpShNFqRonePV5
         stkoVE5Y6/Ekv1CXUgo8M6jwBGvxmNqu0retmm5qquyp+ik4eM5QG4lDfqcoEieECOW/
         Z2Ap/QbkawrOdlEUBTlFsVVT7ZhBAXlu9n3poZC6YQbKa7UCFD+0rQaqoEF2s8rRRUqU
         rbJFPt+5YHh156b4WILT0JG7m/ojHMgruOcGn637aQjJqZtwF3f5m828IkLuw0cU2FLz
         eraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=I8HcRE9PQpGzhtd57DtZYJVZUrGRfD/rQqXsgrN7czY=;
        b=b3AP/uD6nWEUd0dlafN3nu8p53lwGwv+6VtruKjIBnBnY7p5SlOUK22UUH9diua824
         5GIHv5THkzfbIsKzVGBHkL5ysl+plfwEet4F4VRaCpOK0reYKmrJQSAsI1U1bzHyvhJG
         h6LDvkIRncZcYZJTYUbMRE+1zEKb270E/ZixQub4ERU3rEmdW6oBxDWs2SDy4339lNmg
         OuAPSEg/CetfzpoHo1iMiGd+v2//1YhYnybOJW8U88StMvGPFqRzp3Ldj4NN464v5TMu
         Gbp3ofzgfkquEzy+eWVL1BEnRRQeNs5ixjEUVNaX7GB+9CPer2bBZmxRk/7irrlb1K6Z
         hl9w==
X-Gm-Message-State: AOAM532TgR9yWUqL0l8L9Lr1CttEUAiOZu7lYxNU4DDMBpWUacWYONZl
        U/n+0O7rDgSHwpMNIhZTUyoBrRA=
X-Google-Smtp-Source: ABdhPJx9sDLKcYEG0apaN1ZIPfGcIH3WRf5WyvwwvKMPAkQkn/MpCySxagYobXHwNa6hqS8k3bTdXjo=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:ea09:: with SMTP id p9mr44588429ybd.109.1609445655377;
 Thu, 31 Dec 2020 12:14:15 -0800 (PST)
Date:   Thu, 31 Dec 2020 12:14:13 -0800
In-Reply-To: <20201231064728.x7vywfzxxn3sqq7e@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <X+4xFUuYHUIufeJ1@google.com>
Mime-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-2-sdf@google.com>
 <CAPhsuW52eTurJ4pPAgZtv0giw2C+7r6aMacZXx8XkwUxBGARAQ@mail.gmail.com> <20201231064728.x7vywfzxxn3sqq7e@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30, Martin KaFai Lau wrote:
> On Mon, Dec 21, 2020 at 02:22:41PM -0800, Song Liu wrote:
> > On Thu, Dec 17, 2020 at 9:24 AM Stanislav Fomichev <sdf@google.com>  
> wrote:
> > >
> > > When we attach a bpf program to cgroup/getsockopt any other  
> getsockopt()
> > > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > > not an issue, sometimes it is, like in the case of  
> TCP_ZEROCOPY_RECEIVE.
> > > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > > fastpath for incoming TCP, we don't want to have extra allocations in
> > > there.
> > >
> > > Let add a small buffer on the stack and use it for small (majority)
> > > {s,g}etsockopt values. I've started with 128 bytes to cover
> > > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > > currently, with some planned extension to 64 + some headroom
> > > for the future).
> >
> > I don't really know the rule of thumb, but 128 bytes on stack feels too  
> big to
> > me. I would like to hear others' opinions on this. Can we solve the  
> problem
> > with some other mechanisms, e.g. a mempool?
> It seems the do_tcp_getsockopt() is also having "struct  
> tcp_zerocopy_receive"
> in the stack.  I think the buf here is also mimicking
> "struct tcp_zerocopy_receive", so should not cause any
> new problem.
Good point!

> However, "struct tcp_zerocopy_receive" is only 40 bytes now.  I think it
> is better to have a smaller buf for now and increase it later when the
> the future needs in "struct tcp_zerocopy_receive" is also upstreamed.
I can lower it to 64. Or even 40?

I can also try to add something like BUILD_BUG_ON(sizeof(struct
tcp_zerocopy_receive) < BPF_SOCKOPT_KERN_BUF_SIZE) to make sure this
buffer gets adjusted whenever we touch tcp_zerocopy_receive.
