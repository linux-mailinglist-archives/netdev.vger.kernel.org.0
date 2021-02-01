Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F9730A44D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhBAJXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhBAJXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:23:37 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE68CC061574;
        Mon,  1 Feb 2021 01:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m4R5BkzhKMHXACC3fJ4P7syCDqSSnz8E3Zk8HUxOaOY=; b=yyfRMlS8YY3jQfMNd/jpdcqegH
        kDZU5/i3dGRzP3LOFsCgPdeDIbNJZ9VK9Y3T+n7UUKo4s46/v1Ucnv/1KnbsiEUR3BZYVwac0LtrU
        5kADJWX4sKKjCCZgcVnUQBxUWAWRluBx6q6B4/McX72rYhRKuaD/mpT2DrNH57eu001K5Pk5TwCY2
        65FNTTnuJgJmNbtFk8/WLv5YLM/2uDrO2VgVIWvQrkSxCYrqbrQC4jB33+Rb3HZlZb6D6o2wUrVK7
        9LxoY6nP5RRV2uN+ZCSSK3F842tM5YxsLcreQFXUSO9jgJFEHWbJODbFZwkdi2NkO/fqW6IClYFAF
        qEOsehFw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l6VPk-0006UK-Sw; Mon, 01 Feb 2021 09:22:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 129BF3011FE;
        Mon,  1 Feb 2021 10:22:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9AE942C10ABC9; Mon,  1 Feb 2021 10:22:27 +0100 (CET)
Date:   Mon, 1 Feb 2021 10:22:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>, kpsingh@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: extended bpf_send_signal_thread with argument
Message-ID: <YBfIUwtK+QqVlfRt@hirez.programming.kicks-ass.net>
References: <CACT4Y+a7UBQpAY4vwT8Od0JhwbwcDrbJXZ_ULpPfJZ42Ew-yCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+a7UBQpAY4vwT8Od0JhwbwcDrbJXZ_ULpPfJZ42Ew-yCQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 12:14:02PM +0100, Dmitry Vyukov wrote:
> Hi,
> 
> I would like to send a signal from a bpf program invoked from a
> perf_event. There is:

You can't. Sending signals requires sighand lock, and you're not allowed
to take locks from perf_event context.
