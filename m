Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA1C429467
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 18:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhJKQXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 12:23:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46736 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhJKQXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 12:23:31 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BAA7722132;
        Mon, 11 Oct 2021 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633969289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j8grqsuiDa1p2LSXgYDqekInnTQ7Jhon0WjFTDwZwJs=;
        b=TQj0MIlN7mg/iFLoicMLPRRgjwJjxnKhDlzHKKsy5eqTNIlGKN4X2cGLnM6joCpLDt5M+Y
        8z3ZR6vJy9LB/YIcpGArNopx9B96owXx4jG48I2mk3pUG7kSYpzcyRk/wBJYBipHQYdVgt
        0S7T4dqGiuFhd6SlWtRhBszhQgwdkp8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 90FAA13BC0;
        Mon, 11 Oct 2021 16:21:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8ae4IolkZGGqawAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 11 Oct 2021 16:21:29 +0000
Date:   Mon, 11 Oct 2021 18:21:28 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     quanyang.wang@windriver.com
Cc:     Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Message-ID: <20211011162128.GC61605@blackbody.suse.cz>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007121603.1484881-1-quanyang.wang@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wrote:
> This is because that root_cgrp->bpf.refcnt.data is allocated by the
> function percpu_ref_init in cgroup_bpf_inherit which is called by
> cgroup_setup_root when mounting, but not freed along with root_cgrp
> when umounting.

Good catch!

> Adding cgroup_bpf_offline which calls percpu_ref_kill to
> cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.

That is sensible.

> Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")

Why this Fixes:? Is the leak absent before the percpu_ref refactoring?
I guess the embedded data are free'd together with cgroup. Makes me
wonder why struct cgroup_bpf has a separate percpu_ref counter from
struct cgroup...

> +++ b/kernel/cgroup/cgroup.c
> @@ -2147,8 +2147,10 @@ static void cgroup_kill_sb(struct super_block *sb)
>  	 * And don't kill the default root.
>  	 */
>  	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
> -	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
> +			!percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
> +		cgroup_bpf_offline(&root->cgrp);

(You made some unnecessary whitespace here breaking indention :-)

>  		percpu_ref_kill(&root->cgrp.self.refcnt);
> +	}
>  	cgroup_put(&root->cgrp);
>  	kernfs_kill_sb(sb);
>  }
