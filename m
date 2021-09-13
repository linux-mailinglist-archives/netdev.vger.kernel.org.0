Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44AB408620
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbhIMIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbhIMIMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 04:12:46 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA851C061760;
        Mon, 13 Sep 2021 01:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zj9bDVh8bECevuh3HQ4f7aL+kfMosy058ZyQYs/papg=; b=lcO2BiA5Fd8VL1xe9MvMXEHx0w
        rkHg+B7zS01dliDC40Yb8MlXRuOACJ36VL/2WIDM5863mBT3TcGl3uCANsjvCrk7HRNcRTcGA+XBn
        v0dWdjYT9r8dc1typAVrUTzDL5PmPHtwjP8rWP3ojKpQvQW40qsI8mLL6ka/d47QChXc/AQORHlqA
        D1S7byoUL3xy5fUc16UxdWU2I2YUYnXRMOVg7A0Y2CE8fl7z1K/zsOj+mpoXC9GDDIcjFqtNUV/GK
        kWadPBi0BW8I2cgnAjAIVg4K5KxEIh7dYtdZQ3VBh9FBVEsCQtQMYQiGQi4HHlM19c2rKdBJOVmaP
        ulVwuDNg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPh3Y-002mSL-PU; Mon, 13 Sep 2021 08:11:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0F81530003A;
        Mon, 13 Sep 2021 10:11:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A02B72BD296B7; Mon, 13 Sep 2021 10:11:10 +0200 (CEST)
Date:   Mon, 13 Sep 2021 10:11:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     acme@kernel.org, linux-perf-users@vger.kernel.org,
        mingo@redhat.com, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, namhyung@kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: Re: possible deadlock in __perf_event_task_sched_out
Message-ID: <YT8HngbIcqA4Tfac@hirez.programming.kicks-ass.net>
References: <CACkBjsYnr4_uucVqvBpfDAgcnQqA6oneD1mHYe-TcLtDxuUs2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACkBjsYnr4_uucVqvBpfDAgcnQqA6oneD1mHYe-TcLtDxuUs2A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 10:39:10AM +0800, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1Gy99NMo9JxZF6dHPdxnnb91n_jPJUQnA/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing
> 
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:

This reads like a very badly configured VM, in part because the console
output is partial. That first Call trace: is ex_handler_wrmsr_unsafe,
but it is truncated, also the pr_warn_once() went missing.

Please take more care in configuring your VM before sending out more
bogus messages like this.
