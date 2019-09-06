Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E39ABC48
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394772AbfIFPYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:24:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57656 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFPYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:24:38 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.1 #3 (Red Hat Linux))
        id 1i6G6F-0004tJ-9r; Fri, 06 Sep 2019 15:24:35 +0000
Date:   Fri, 6 Sep 2019 16:24:35 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from  current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190906152435.GW1131@ZenIV.linux.org.uk>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906150952.23066-3-cneirabustos@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 11:09:50AM -0400, Carlos Neira wrote:

> +BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *, pidns_info, u32,
> +	 size)
> +{
> +	const char *pidns_path = "/proc/self/ns/pid";

> +	fname = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
> +	if (unlikely(!fname)) {
> +		ret = -ENOMEM;
> +		goto clear;
> +	}
> +	const size_t fnamesize = offsetof(struct filename, iname[1]);
> +	struct filename *tmp;
> +
> +	tmp = kmalloc(fnamesize, GFP_ATOMIC);
> +	if (unlikely(!tmp)) {
> +		__putname(fname);
> +		ret = -ENOMEM;
> +		goto clear;
> +	}
> +
> +	tmp->name = (char *)fname;
> +	fname = tmp;
> +	len = strlen(pidns_path) + 1;
> +	memcpy((char *)fname->name, pidns_path, len);
> +	fname->uptr = NULL;
> +	fname->aname = NULL;
> +	fname->refcnt = 1;
> +
> +	ret = filename_lookup(AT_FDCWD, fname, 0, &kp, NULL);
> +	if (ret)
> +		goto clear;

Where do I begin?
	* getname_kernel() is there for purpose
	* so's kern_path(), damnit
> +
> +	inode = d_backing_inode(kp.dentry);
> +	pidns_info->dev = (u32)inode->i_rdev;

	* ... and this is utter bollocks - userland doesn't
have to have procfs mounted anywhere; it doesn't have to
have it mounted on /proc; it can bloody well bind a symlink
to anywhere and anythin on top of /proc/self even if its
has procfs mounted there.

	This is fundamentally wrong; nothing in the kernel
(bpf very much included) has any business assuming anything
about what's mounted where.  And while we are at it,
how deep on kernel stack can that thing be called?
Because pathname resolution can bring all kinds of interesting
crap into the game - consider e.g. NFS4 referral traversal.
And it can occur - see above about the lack of warranties
that your pathwalk will go to procfs and will remain there.

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
