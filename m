Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367AD322940
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhBWLHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhBWLH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:07:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1819C061786;
        Tue, 23 Feb 2021 03:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K2ylQVZRhghwU1ruzT40Z4+JszR4ATXnAjr+EMA5yu4=; b=NBP9tV4JPO5/VnfruO4LFjeYaJ
        3GZA7ssSASYSXNeuC1blqtsH9J0+PR5QVfvEtsfuMt3bcKFwa6TM/ZdJeff7fa1TqlCeJ240L3Vv6
        PPadV4Ub0Nl4PbeEZ9nt2Pkqx35oZm+7UGB3xzHj2naf991/OeM9JjNDGjvPaK0f4sMVmP9dAYqui
        pURY68O3Lr7IQZSASDNT2rK5GgHSiOEB+dpSSqEI0jP8xQyPRmwAKD2EdIOQHU1zUtu0KkkqVw1Br
        3ZljwcflvZ+eRCnSiVP5ZiXt13PU6gLS5qUDGQ6FmssCSKh9F45Os3+FrXg5i0iC4HVZXZq0ZqI1R
        PVdJKD9A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lEVWJ-007rop-4d; Tue, 23 Feb 2021 11:06:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A7112300DB4;
        Tue, 23 Feb 2021 12:06:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8759F2013B7C2; Tue, 23 Feb 2021 12:06:22 +0100 (CET)
Date:   Tue, 23 Feb 2021 12:06:22 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
Message-ID: <YDThrlixVqfHP7I9@hirez.programming.kicks-ass.net>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223012014.2087583-3-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 05:20:10PM -0800, Song Liu wrote:
> BPF helpers bpf_task_storage_[get|delete] could hold two locks:
> bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
> these helpers from fentry/fexit programs on functions in bpf_*_storage.c
> may cause deadlock on either locks.
> 
> Prevent such deadlock with a per cpu counter, bpf_task_storage_busy, which
> is similar to bpf_prog_active. We need this counter to be global, because

So bpf_prog_active is one of the biggest turds around, and now you're
making it worse ?!
