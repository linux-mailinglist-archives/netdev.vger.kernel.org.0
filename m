Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C700741C4B2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbhI2M15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343781AbhI2M14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:27:56 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F1BC06161C;
        Wed, 29 Sep 2021 05:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m5vnssJ0KM4mYSxWrXAMLthsIFQPm+npF62UAIPEcZg=; b=lysO5z74LimjxnvyIggoa9hipd
        l9Lrz8HGEvl2IDkZAe2FVoPruAjic8KvuFMGVxqZiyIeMLnC+aXwXZkl64P2NKQhZNXU6ZDupIE+N
        21OOMMsA5WXaZTKa5C4G/YYJM3DxdhkjgQQrnbgP2FJDVEq8gJO+G3/RFdhI7kV3i8Fy5U0xFXbxd
        E++BdKfEm9H8ypQs04I0vNVo73ibEt0gpFuYh260CeWPhB7kMFAr8gPmAy20EOQHaW2xpww0J64BF
        IegFyI8xDQNfmcwRN0uCKQxhJhlmOGPaf2NkWK5ORaKwUn40haLirQfIyg8rjtNY7eTTcUP7KDTEL
        E+Saw3NA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVYf2-006hv8-6W; Wed, 29 Sep 2021 12:26:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5C11F30026F;
        Wed, 29 Sep 2021 14:26:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4472120177EAF; Wed, 29 Sep 2021 14:26:07 +0200 (CEST)
Date:   Wed, 29 Sep 2021 14:26:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, like.xu@linux.intel.com
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 08:05:24PM +0800, Like Xu wrote:
> On 29/9/2021 3:35 pm, Peter Zijlstra wrote:

> > > [  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)
> 
> Uh, it uses a PEBS counter to sample or count, which is not yet upstream but
> should be soon.

Ooh that's PEBS_ENABLE

> Song, can you try to fix bpf_get_branch_snapshot on a normal PMC counter,
> or where is the src for bpf_get_branch_snapshot? I am more than happy to help.

Nah, all that code wants to do is disable PEBS... and virt being virt,
it's all sorts of weird with f/m/s :/

I so hate all that. So there's two solutions:

 - get confirmation that clearing GLOBAL_CTRL is suffient to supress
   PEBS, in which case we can simply remove the PEBS_ENABLE clear.

or

 - create another 2 intel_pmu_snapshot_{,arch_}branch_stack() copies
   that omit the PEBS thing.

