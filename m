Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D632501995
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiDNRGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242707AbiDNRFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:05:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C903EFE430;
        Thu, 14 Apr 2022 09:44:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7CDCF1F747;
        Thu, 14 Apr 2022 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649954651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fAh1doWqdu+T5/UcndhANWk7kmOrXizHJ0CC+YKJ3Ek=;
        b=ItvkKqTJave9fRovg0ydCzfpuP8dusozKz3WSWTw4xyCZGYtm401PRaOw3A7tKtn195ttV
        70Iq3LASPYGaaQFBLo3dZiZFNeqlNkqtTdFBwMkiE/Frdb4DB0+Mp2kc/s0DQAGgLyu5/I
        Vu6vxdwLlPRhTE1WJ+UxARYAK7bzTjw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 30A0813A86;
        Thu, 14 Apr 2022 16:44:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Rl0ZC1tPWGKBDgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Thu, 14 Apr 2022 16:44:11 +0000
Date:   Thu, 14 Apr 2022 18:44:09 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
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
Message-ID: <20220414164409.GA5404@blackbody.suse.cz>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412192459.227740-1-tadeusz.struk@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tadeusz.

Thanks for analyzing this syzbot report. Let me provide my understanding
of the test case and explanation why I think your patch fixes it but is
not fully correct.

On Tue, Apr 12, 2022 at 12:24:59PM -0700, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> Syzbot found a corrupted list bug scenario that can be triggered from
> cgroup css_create(). The reproduces writes to cgroup.subtree_control
> file, which invokes cgroup_apply_control_enable(), css_create(), and
> css_populate_dir(), which then randomly fails with a fault injected -ENOMEM.

The reproducer code makes it hard for me to understand which function
fails with ENOMEM.
But I can see your patch fixes the reproducer and your additional debug
patch which proves that css->destroy_work is re-queued.

> In such scenario the css_create() error path rcu enqueues css_free_rwork_fn
> work for an css->refcnt initialized with css_release() destructor,

Note that css_free_rwork_fn() utilizes css->destroy_*r*work.
The error path in css_create() open codes relevant parts of
css_release_work_fn() so that css_release() can be skipped and the
refcnt is eventually just percpu_ref_exit()'d.

> and there is a chance that the css_release() function will be invoked
> for a cgroup_subsys_state, for which a destroy_work has already been
> queued via css_create() error path.

But I think the problem is css_populate_dir() failing in
cgroup_apply_control_enable(). (Is this what you actually meant?
css_create() error path is then irrelevant, no?)

The already created csses should then be rolled back via 
	cgroup_restore_control(cgrp);
	cgroup_apply_control_disable(cgrp);
	   ...
	   kill_css(css)

I suspect the double-queuing is a result of the fact that there exists
only the single reference to the css->refcnt. I.e. it's
percpu_ref_kill_and_confirm()'d and released both at the same time.

(Normally (when not killing the last reference), css->destroy_work reuse
is not a problem because of the sequenced chain
css_killed_work_fn()->css_put()->css_release().)

> This can be avoided by adding a check to css_release() that checks
> if it has already been enqueued.

If that's what's happening, then your patch omits the final
css_release_work_fn() in favor of css_killed_work_fn() but both should
be run during the rollback upon css_populate_dir() failure.

So an alternative approach to tackle this situation would be to split
css->destroy_work into two work work_structs (one for killing, one for
releasing) at the cost of inflating cgroup_subsys_state.

Take my hypothesis with a grain of salt maybe the assumption (last
reference == initial reference) is not different from normal operation.

Regards,
Michal
