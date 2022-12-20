Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F1651C47
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 09:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiLTIXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 03:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLTIXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 03:23:04 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55BD17884;
        Tue, 20 Dec 2022 00:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HObulU/7Fs3yB8e3lwJHXRtK0ZlIRyjZdgzRj34kWOk=; b=Y2g2957HjQw87hnzWyVfFz8azM
        EW6UuioOZy+j5HdRU1gP/i71DMMChCAsX8L05vcpTJp7SgOLy5bve/RSreDmHVsYQTFlfW1u4vfUN
        aF9qEU5za5JmbEWaPUZubjU1+Z/vcNWOJxD6J0HvNCGZQL0OSfaRxOCFtz7awtviDzLzJPsKaAn2a
        FKWTNJ1R/jc8KvcEzROc5wVJob9T6C0e5YZuUkSDfs/m2fc6xrqsBAMOYpyOlMk4kFNI4GDVaXvmp
        nAIEPNGbKxwmLc8OB2rAgV6L4OrntjewPtUb8BVpYdeNTRRA7NuJ/AgMBHv+Yblk+D3Ta7LyBSRgg
        6j3bdbfQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p7Xtg-00CvrU-38;
        Tue, 20 Dec 2022 08:22:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BED52300E86;
        Tue, 20 Dec 2022 09:22:47 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 743A820ACCA77; Tue, 20 Dec 2022 09:22:47 +0100 (CET)
Date:   Tue, 20 Dec 2022 09:22:47 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     sdf@google.com
Cc:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>,
        acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
Message-ID: <Y6Fw1ymTcFrMR3Hl@hirez.programming.kicks-ass.net>
References: <000000000000a20a2e05f029c577@google.com>
 <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
 <Y6C8iQGENUk/XY/A@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6C8iQGENUk/XY/A@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 11:33:29AM -0800, sdf@google.com wrote:
> On 12/19, Peter Zijlstra wrote:
> > On Mon, Dec 19, 2022 at 12:04:43AM -0800, syzbot wrote:

> > > HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of
> > https://git.kernel...
> > > git tree:       bpf
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df7e0480000
> > > kernel config:
> > https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
> > > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f

^ so syzbot knows what tree and config were used to trigger the report,
then why:

> Let's maybe try it this way:
> 
> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> 13e3c7793e2f

do you have to repeat that again in order for it to test something?

