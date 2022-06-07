Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B953F929
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbiFGJOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiFGJOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:14:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA7169B53;
        Tue,  7 Jun 2022 02:14:14 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654593252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bezUUwZTcrVCpPMRY2+6dN6//+KpHkGmqvWXkpIPhNU=;
        b=Cs/VMGvhIXHBotoccSXQdMLGz/D+jPs57h++NHgNdhmYEW5ts7QKRrtItm+qSQz+1X29dv
        Qrlo+ZmRSRLr9CU7iE25N049w0EYdxZQv24CY3e1r7H5Oiu9mA8fIqesjduNkOQoSoV4yA
        u/bPmRhcIB5kPNv7OO7KEd/tdjnpZJgQlGmHozAgNAzgy3DB60UzcuBQtLk4ftjYGfR6V2
        2EyMe1cKjfSVutlWvew8MLSk1v8Fre+4zON1lu25mneaSvS03xdM5nKOB5wdoAPaL0j2ht
        7fSUIR9suTfbm716bIvxDxfqCF6POnOmH+PYXblSQncHX6BS5RxSphUgkvfJ+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654593252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bezUUwZTcrVCpPMRY2+6dN6//+KpHkGmqvWXkpIPhNU=;
        b=pYAGvdTIZ9X8TbLxsUdPagFnvFAgjv9BIuXSUxHX8dsmfPgKYxwyv3gbwc9/MQhnwzVx1N
        iKb8Pc20Uyf1/NDA==
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
In-Reply-To: <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
References: <20220606103734.92423-1-kurt@linutronix.de>
 <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
Date:   Tue, 07 Jun 2022 11:14:12 +0200
Message-ID: <875ylc6djv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei,

On Mon, Jun 06 2022 at 08:57, Alexei Starovoitov wrote:
> On Mon, Jun 6, 2022 at 3:38 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>>
>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>>
>> Commit 3dc6ffae2da2 ("timekeeping: Introduce fast accessor to clock tai")
>> introduced a fast and NMI-safe accessor for CLOCK_TAI. Especially in time
>> sensitive networks (TSN), where all nodes are synchronized by Precision Time
>> Protocol (PTP), it's helpful to have the possibility to generate timestamps
>> based on CLOCK_TAI instead of CLOCK_MONOTONIC. With a BPF helper for TAI in
>> place, it becomes very convenient to correlate activity across different
>> machines in the network.
>
> That's a fresh feature. It feels risky to bake it into uapi already.

What? That's just support for a different CLOCK. What's so risky about
it?

> imo it would be better to annotate tk_core variable in vmlinux BTF.
> Then progs will be able to read all possible timekeeper offsets.

We are exposing APIs. APIs can be supported, but exposing implementation
details creates ABIs of the worst sort because that prevents the kernel
from changing the implementation. We've seen the fallout with the recent
tracepoint changes already.

Thanks,

        tglx


