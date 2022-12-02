Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03F64060C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiLBLtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiLBLs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:48:59 -0500
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8D08C6B5;
        Fri,  2 Dec 2022 03:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=XcoT1gm6nJUNRjSaIxst4eK9u87wf4plSWwNL0a4U28=; b=SO/hnv4RvVNoMPYazzbaiiaK61
        R9TeNHuJiMIywlCvf6mW4BcFU9+ZagrIwICDb/sjnn6+cIbRpJQDXlh9eC4WB37MvIp7HKb0/3VvL
        CDCWkbHlJ73tpIZ9pCnD3vuHQ91QHSic4q2/hddTU0aLQ9IOQs54SI0zEXFDfbv+kH9/WELJF1sVg
        xEK80MpP+yjd200ZKamee64NYDK5t0xVRE34mqxtoxphoHjdjwLJLuRyMWX42zIUQfLXkAKnwSJgI
        m4tySeT4G/q6vecHRTI/7iKfNf/2s87CfbJa/anJgRGVIA3o6icJ8bpMV830Fq74N18lxmxxQV6N4
        OIsM/inaxt/1/V7bd1oSUiGe9NOrtzqVy1OH9ZpXsaLNGvRH+42y3Yxd6oNB+/ErnW8CUEqqjX/8R
        KRlNpK2Hs6PCr9m3uqjn0Fa34zKcjWD9Iy1XGYnXVkL8FiqGfOaCf7ZoHXjxgQUJUAcoDICMyiVX1
        5fsgIUCcJbURBEw1xV0ufHummUOajNF4Edzk8VNH5vpZWV5QXU9kA5gBx9lH9yPOqO4QnHnWuIf70
        BzJDhkuTb1HlpZPgLP6fLUMJPfbtbnDFinfyq8WkEqHooCgtQSlL1RbBhvpQ2MSPd3unOjoNp1t1v
        Pkqm2aqszym56mfvd688kRTSg99WSoTuRe+ms9UP0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Schspa Shi <schspa@gmail.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] 9p/fd: set req refcount to zero to avoid uninitialized usage
Date:   Fri, 02 Dec 2022 12:48:39 +0100
Message-ID: <4759293.MmlG3nAkEO@silver>
In-Reply-To: <20221201033310.18589-1-schspa@gmail.com>
References: <20221201033310.18589-1-schspa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, December 1, 2022 4:33:10 AM CET Schspa Shi wrote:
> When the new request allocated, the refcount will be zero if it is resued
> one. But if the request is newly allocated from slab, it is not fully
> initialized before add it to idr.
> 
> If the p9_read_work got a response before the refcount initiated. It will
> use a uninitialized req, which will result in a bad request data struct.
> 
> Here is the logs from syzbot.
> 
> Corrupted memory at 0xffff88807eade00b [ 0xff 0x07 0x00 0x00 0x00 0x00
> 0x00 0x00 . . . . . . . . ] (in kfence-#110):
>  p9_fcall_fini net/9p/client.c:248 [inline]
>  p9_req_put net/9p/client.c:396 [inline]
>  p9_req_put+0x208/0x250 net/9p/client.c:390
>  p9_client_walk+0x247/0x540 net/9p/client.c:1165
>  clone_fid fs/9p/fid.h:21 [inline]
>  v9fs_fid_xattr_set+0xe4/0x2b0 fs/9p/xattr.c:118
>  v9fs_xattr_set fs/9p/xattr.c:100 [inline]
>  v9fs_xattr_handler_set+0x6f/0x120 fs/9p/xattr.c:159
>  __vfs_setxattr+0x119/0x180 fs/xattr.c:182
>  __vfs_setxattr_noperm+0x129/0x5f0 fs/xattr.c:216
>  __vfs_setxattr_locked+0x1d3/0x260 fs/xattr.c:277
>  vfs_setxattr+0x143/0x340 fs/xattr.c:309
>  setxattr+0x146/0x160 fs/xattr.c:617
>  path_setxattr+0x197/0x1c0 fs/xattr.c:636
>  __do_sys_setxattr fs/xattr.c:652 [inline]
>  __se_sys_setxattr fs/xattr.c:648 [inline]
>  __ia32_sys_setxattr+0xc0/0x160 fs/xattr.c:648
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> 
> Below is a similar scenario, the scenario in the syzbot log looks more
> complicated than this one, but this patch can fix it.
> 
>      T21124                   p9_read_work
> ======================== second trans =================================
> p9_client_walk
>   p9_client_rpc
>     p9_client_prepare_req
>       p9_tag_alloc
>         req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
>         tag = idr_alloc
>         << preempted >>
>         req->tc.tag = tag;
>                             /* req->[refcount/tag] == uninitialized */
>                             m->rreq = p9_tag_lookup(m->client, m->rc.tag);
>                               /* increments uninitalized refcount */
> 
>         refcount_set(&req->refcount, 2);
>                             /* cb drops one ref */
>                             p9_client_cb(req)
>                             /* reader thread drops its ref:
>                                request is incorrectly freed */
>                             p9_req_put(req)
>     /* use after free and ref underflow */
>     p9_req_put(req)
> 
> To fix it, we can initize the refcount to zero before add to idr.
> 
> Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
> Signed-off-by: Schspa Shi <schspa@gmail.com>

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

> 
> --
> 
> Changelog:
> v1 -> v2:
>         - Set refcount to fix the problem.
> v2 -> v3:
>         - Comment messages improve as asmadeus suggested.
> ---
>  net/9p/client.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index aaa37b07e30a..ec74cd29d3bc 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -297,6 +297,11 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
>  	p9pdu_reset(&req->rc);
>  	req->t_err = 0;
>  	req->status = REQ_STATUS_ALLOC;
> +	/* refcount needs to be set to 0 before inserting into the idr
> +	 * so p9_tag_lookup does not accept a request that is not fully
> +	 * initialized. refcount_set to 2 below will mark request live.
> +	 */
> +	refcount_set(&req->refcount, 0);

I would s/live/ready for being used/, but comment should be clear enough
anyway.

>  	init_waitqueue_head(&req->wq);
>  	INIT_LIST_HEAD(&req->req_list);
>  
> 




