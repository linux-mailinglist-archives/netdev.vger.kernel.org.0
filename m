Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A0A2E0445
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 03:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgLVCMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 21:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgLVCMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 21:12:15 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C500C061793
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 18:11:35 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id n137so10473715qkn.10
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 18:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=u9bhubHGPCKwnhuj4Z1f+x++7A1NpBDFvDr8v2clFkE=;
        b=OQNLI4j5Wwj7z1Oc+L21N7yQ6s0pNKWyH3g7U/nVEJs9GlIzsfpEOwhBCt2PgDQXVX
         FC5HGELAw63O1CqtBNju3UXQqVLMXavDJF0o80lulnvCS1fRPvTaS6J2u78Ozw0sGIsS
         Oa8fapS//2MJBCRTsjYN7sLEZ3pDjjHLA/HGCvCOS4olx1NqgyoH9V2nW/pWvfvcwrX9
         56/gmShIhBgBJ0r3r3ezMx9hDVhv6ZQyMp9bYVBOrpRPxfkbsofygndiP6vrSL+mzrg6
         fil9A/DzzS4vJJ0zh+dmHh4zPrsqprIf/cBzSYl5SGwkxgYiIZJ/Vd7kHFZV4f3vaIdJ
         j5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u9bhubHGPCKwnhuj4Z1f+x++7A1NpBDFvDr8v2clFkE=;
        b=rgxX7VZGeZolH6KwQ+9/3CONnMDBXUQFpvi4eaDE3fEOPGDVLUYVhKEa21C149qsoA
         R6jqj8cY49v5VO1pT4j9ne/297gpNkyO+wiuITMPotD18dS/taNJ0QjIRsxS0cFQd3/b
         gGR1qx+2nKzTbydlZEy5RvwXdmm/8s+h1GUUif4jUKJghbeY/klcH+CHHlgKEuEmi/i/
         qWRcvUoVPBbmKP61PhSMk/hzzArd/bqmo3kSQQs+dQpKBWWxFkuB9juEI/Gvs4qYIQEF
         P4S39Msq1Hcn106+uEs3UpAjMDlLG/wpyjw1k3Vg6WM5TclihX9RN/+VYy6XN183Aa+z
         9yVA==
X-Gm-Message-State: AOAM531tJxyZ7QkIwSG3+poxT3pikXkTpyRFhPxq7mxmWEByIY77Lr2Z
        5Jg99C29jziyJbcCrffcd7+yv4A=
X-Google-Smtp-Source: ABdhPJyZFSpKibArdqcHHr50RjEEqZfv/T0LIXudd/2Fl8G84BpqBNPWcnxA1+dR6fWiy+b92ZLyVVo=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:b82:: with SMTP id
 fe2mr20192544qvb.3.1608603094171; Mon, 21 Dec 2020 18:11:34 -0800 (PST)
Date:   Mon, 21 Dec 2020 18:11:32 -0800
In-Reply-To: <CAPhsuW6KPF6J9Q6P-g6LQGBjwP_cGdM+VPGgYfOZ8pTkwShqaQ@mail.gmail.com>
Message-Id: <X+FV1EETHu9nO+kp@google.com>
Mime-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-2-sdf@google.com>
 <CAPhsuW6KPF6J9Q6P-g6LQGBjwP_cGdM+VPGgYfOZ8pTkwShqaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   sdf@google.com
To:     Song Liu <song@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21, Song Liu wrote:
> On Thu, Dec 17, 2020 at 9:24 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > fastpath for incoming TCP, we don't want to have extra allocations in
> > there.
> >
> > Let add a small buffer on the stack and use it for small (majority)
> > {s,g}etsockopt values. I've started with 128 bytes to cover
> > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > currently, with some planned extension to 64 + some headroom
> > for the future).
> >
> > It seems natural to do the same for setsockopt, but it's a bit more
> > involved when the BPF program modifies the data (where we have to
> > kmalloc). The assumption is that for the majority of setsockopt
> > calls (which are doing pure BPF options or apply policy) this
> > will bring some benefit as well.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>

> Could you please share some performance numbers for this optimization?
We've found out about this problem by looking at our global google
profiler, where TCP_ZEROCOPY_RECEIVE was showing up higher than usual.

So I don't really have a nice reproducer, but I would assume I can try
to run something like tools/testing/selftests/net/tcp_mmap.c under perf
and see if there is a clear difference.
