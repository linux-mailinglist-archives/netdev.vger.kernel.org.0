Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3F550B5DE
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 13:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447000AbiDVLIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 07:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245078AbiDVLIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 07:08:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D376D55238;
        Fri, 22 Apr 2022 04:05:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 85C6A1F745;
        Fri, 22 Apr 2022 11:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650625508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XTMtHe0DEbqpErS7R1TOOp7bMasIBNeqbkGsdmdc7Ko=;
        b=DmAowioWLy8q8gJS/SZc36jXbfkIdJwSSjsgJm84KkmORCTeRBGeM09xLnm2auCaldw7vo
        9TXlA5rQ653io4fIcCQIE189VIAv9PTX/BDhefqN6exSlqsaHCa8XSG7AwoAMqnsc6wRGg
        0mCC4yuHYyIqjLc3C6dpDnTg/MUIZjc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C231131BD;
        Fri, 22 Apr 2022 11:05:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9pPTCeSLYmIhNgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Fri, 22 Apr 2022 11:05:08 +0000
Date:   Fri, 22 Apr 2022 13:05:06 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>, cgroups@vger.kernel.org,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Message-ID: <20220422100400.GA29552@blackbody.suse.cz>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
 <YmHwOAdGY2Lwl+M3@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmHwOAdGY2Lwl+M3@slm.duckdns.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 02:00:56PM -1000, Tejun Heo <tj@kernel.org> wrote:
> If this is the case, we need to hold an extra reference to be put by the
> css_killed_work_fn(), right?

I looked into it a bit more lately and found that there already is such
a fuse in kill_css() [1].

At the same type syzbots stack trace demonstrates the fuse is
ineffective

> css_release+0xae/0xc0 kernel/cgroup/cgroup.c:5146                    (**)
> percpu_ref_put_many include/linux/percpu-refcount.h:322 [inline]
> percpu_ref_put include/linux/percpu-refcount.h:338 [inline]
> percpu_ref_call_confirm_rcu lib/percpu-refcount.c:162 [inline]        (*)
> percpu_ref_switch_to_atomic_rcu+0x5a2/0x5b0 lib/percpu-refcount.c:199
> rcu_do_batch+0x4f8/0xbc0 kernel/rcu/tree.c:2485
> rcu_core+0x59b/0xe30 kernel/rcu/tree.c:2722
> rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2735
> __do_softirq+0x27e/0x596 kernel/softirq.c:305

(*) this calls css_killed_ref_fn confirm_switch
(**) zero references after confirmed kill?

So, I was also looking at the possible race with css_free_rwork_fn()
(from failed css_create()) but that would likely emit a warning from
__percpu_ref_exit().

So, I still think there's something fishy (so far possible only via
artificial ENOMEM injection) that needs an explanation...

Michal

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/cgroup/cgroup.c#n5608

