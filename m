Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558453FE73
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242944AbiFGMMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiFGMMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:12:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB1377F0;
        Tue,  7 Jun 2022 05:12:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A4E341F964;
        Tue,  7 Jun 2022 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654603959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5DKSdr4Gj2oo6TtyI9YrO3jghnkl94Qx+e8RKCbCpw=;
        b=GAqhOXDyliufamObMsP/nMztpzHEfqALmosSEVPYqW/eoQJNEGyE+zheWED8UGnAl7Uji/
        ucSOe+6SxcekvCd9cczcsAJ7hrTy7eXKiGcN4paEvai1jJ29vAW5PWpN/QbOjkcyYjCy4O
        e6KLGgG5uIhGUHFEFRGLl93o+O2ase0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 324EC13638;
        Tue,  7 Jun 2022 12:12:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6pdhC7dAn2I/AgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 07 Jun 2022 12:12:39 +0000
Date:   Tue, 7 Jun 2022 14:12:37 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Message-ID: <20220607121237.GC31717@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
 <20220603162339.GA25043@blackbody.suse.cz>
 <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
 <20220606123222.GA4377@blackbody.suse.cz>
 <CAJD7tkbi7Gnnf4NiUt-J61G7185NsRcySvP6qOQsFKMou7qZJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbi7Gnnf4NiUt-J61G7185NsRcySvP6qOQsFKMou7qZJg@mail.gmail.com>
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

On Mon, Jun 06, 2022 at 12:41:06PM -0700, Yosry Ahmed <yosryahmed@google.com> wrote:
> I don't know if there is a standard way to handle this, but I think
> you should know the configs of your kernel when you are loading a bpf
> program?

Isn't this one of purposes of BTF? (I don't know, I'm genuinely asking.)

> If the CONFIG_CGROUPS=1 but CONFIG_MEMCG=0 I think everything will
> work normally except that task_memcg() will always return NULL so no
> stats will be collected, which makes sense.

I was not able to track down what is the include chain to
tools/testing/selftests/bpf/progs/cgroup_vmscan.c, i.e. how is the enum
value memory_cgrp_id defined.

(A custom kernel module build requires target kernel's header files, I
could understand that compiling a BPF program requires them likewise and
that's how this could work.
Although, it goes against my undestanding of the CO-RE principle.)

> There will be some overhead to running bpf programs that will always
> do nothing, but I would argue that it's the userspace's fault here for
> loading bpf programs on a non-compatible kernel.

Yeah, running an empty program is non-issue in my eyes, I was rather
considering whether the program uses proper offsets.

Michal

