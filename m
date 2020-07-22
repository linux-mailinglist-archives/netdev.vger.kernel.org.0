Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC3C229BA6
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbgGVPk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgGVPk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:40:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31814C0619DC;
        Wed, 22 Jul 2020 08:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1NB2+AhHLJs3Y6RrSGLM2VUfmDEsnlWaadqEJFqCmek=; b=PIO6tPMkCQpCFV1t+UxH/t2j0J
        /TIpdOmrO/kDa57vsBhsV21iH5//KTymOVKB8o6PvWY9W6vl9fjOtk8G9OhjF+qd4XIVCktspyFLn
        vMLOaPogdUnxQK+aGcof+PYHUywD0W9KhcU3Cf6+ejC3T7VPwBmDrOD/pKdAHOL8RBYf8Eap8j/V7
        H5/6fnGCWABgPfpVi9//3vl5Yai285IUmj4/2sbThctcV29XXj6ejxecMaCU4d5kVj+Y7J/pHUSl0
        F8Wps3GKwiE1B6xZvmdHAkYN9Bx7FuqXmydd4g6vrkIT9Rep6sYB5yGu4LgDdXl4I2AMbl7DYwPzK
        tDDMTxBQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyGqo-0001QV-Sa; Wed, 22 Jul 2020 15:40:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 50B9F304E03;
        Wed, 22 Jul 2020 17:40:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3CA1B200D417A; Wed, 22 Jul 2020 17:40:10 +0200 (CEST)
Date:   Wed, 22 Jul 2020 17:40:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid]
 for perf events BPF
Message-ID: <20200722154010.GO10769@hirez.programming.kicks-ass.net>
References: <20200716225933.196342-1-songliubraving@fb.com>
 <20200716225933.196342-2-songliubraving@fb.com>
 <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
 <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:40:19PM +0000, Song Liu wrote:

> We only need to block precise_ip >= 2. precise_ip == 1 is OK. 

Uuuh, how? Anything PEBS would have the same problem. Sure, precise_ip
== 1 will not correct the IP, but the stack will not match regardless.

You need IP,SP(,BP) to be a consistent set _AND_ have it match the
current stack, PEBS simply cannot do that, because the regs get recorded
(much) earlier than the PMI and the stack can have changed in the
meantime.

