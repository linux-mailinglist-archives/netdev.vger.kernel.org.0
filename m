Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721B853E730
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiFFMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 08:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbiFFMch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 08:32:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A695006B;
        Mon,  6 Jun 2022 05:32:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 567FC218A0;
        Mon,  6 Jun 2022 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654518744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9PH08cMIB+cEkHAUwWnoV2Rdrv9uIuIlFs1vAUeLjT8=;
        b=kkcGeuhVE5Zp7oPO/179KJdiOaqFznXyMnLXtvm36fYBU0bVl0mvNwBtpbRJl9dfr/+RiE
        6+V2g6bvqx/sqvTs8KJxLuwtOPyRCN+64wkDcfUBnK2Kl4cuUe61yYbnAbyigE+nfD07VX
        PxiKWoJJKcspi04Ocy896GgXS5pzquw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 888FD139F5;
        Mon,  6 Jun 2022 12:32:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UhHOH9fznWIuPQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 06 Jun 2022 12:32:23 +0000
Date:   Mon, 6 Jun 2022 14:32:22 +0200
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
Message-ID: <20220606123222.GA4377@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
 <20220603162339.GA25043@blackbody.suse.cz>
 <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
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

On Fri, Jun 03, 2022 at 12:52:27PM -0700, Yosry Ahmed <yosryahmed@google.com> wrote:
> Good catch. I get confused between cgrp->subsys and
> task->cgroups->subsys sometimes because of different fallback
> behavior. IIUC cgrp->subsys should have NULL if the memory controller
> is not enabled (no nearest ancestor fallback), and hence I can use
> memory_subsys_enabled() that I defined just above task_memcg() to test
> for this (I have no idea why I am not already using it here). Is my
> understanding correct?

You're correct, css_set (task->cgroups) has a css (memcg) always defined
(be it root only (or even a css from v1 hierarchy but that should not
relevant here)). A particular cgroup can have the css set to NULL.

When I think about your stats collecting example now, task_memcg() looks
more suitable to achieve proper hierarchical counting in the end (IOW
you'd lose info from tasks who don't reside in memcg-enabled leaf).

(It's just that task_memcg won't return NULL. Unless the kernel is
compiled without memcg support completely, which makes me think how do
the config-dependent values propagate to BPF programs?)

Thanks,
Michal
