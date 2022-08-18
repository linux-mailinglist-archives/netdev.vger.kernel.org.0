Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEDB598712
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344200AbiHRPMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344179AbiHRPMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:12:33 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC989BFA8D;
        Thu, 18 Aug 2022 08:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=IaeNReyR52ej9/tS6s/KAFhEesm0POJXHliyXuIE5Ho=; b=DFphwx+kUSC2kPYk8B5cLq0V2v
        DLWvFY8986Tb+7pbZRCd6hf5vmkAeX3AFl/mGcI0YSVwpefRCttymkqv+DxOhILfRxFQU3AcUUAIa
        cUrjm6Fu2/v4RdkBqwvWXl4l1u1wtixjWuMV/pIREomlKh1T5UyzuSYKf/UcQClWRmUY9wwsZ11kV
        s2S2cH7ZtRNmF/9VV9QCaPD9JSXOqYIVmseB4D8TGiOjCDqkYsZcxd76cQ7/7n+psKtnZGyHSYCUH
        2S7DfOX1dPPfSNLggpNtLmHkvq1aigmnddpEDnR61DYecB3tASKgwXcs+kffUyGlQYKdnl4QjJa0U
        Ow/3imWV1swdHtYBOdGFrBN65BgPaKoCr7blg5OmHECpMqwYpSL+o5kDodFawBEcCmlwgM/jcgpHi
        93fVwJObhkUoEsG4l31zN14OpP/UIBo8wZQrMxpOQxeV2OR/iiXYGuafJ+2DIkHnVJx4dnRMR0ZnO
        MBqVVDObXDyMERo9qMPNkZ2jjP7s3gqEhKeLDp96LsXZK3S4fUjrHdhspwyBXrBvW/GHPjGq4U1lu
        rzHgXYym/J96vzKHh5ckA4x8Td7IznksQpj2llWpRAhEjHRN+OPT7NyvtEEoUJK20UekpPZAtXXNT
        +6Ar+5m3839LWTt9KOi5z5RwNRzZQJ8PbvkFIibEM=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     syzbot <syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com>,
        asmadeus@codewreck.org
Cc:     davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in p9_req_put
Date:   Thu, 18 Aug 2022 17:12:17 +0200
Message-ID: <2207113.SgyDDyVIbp@silver>
In-Reply-To: <YvyD053bdbGE9xoo@codewreck.org>
References: <0000000000001c3efc05e6693f06@google.com> <YvyD053bdbGE9xoo@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 17. August 2022 07:59:47 CEST asmadeus@codewreck.org wrote:
> syzbot having a fresh look at 9p?
> 
> Well at least that one should be easy enough, the following (untested)
> probably should work around that issue:
> 
> -----
> From 433138e5d36a5b29b46b043c542e14b9dc908460 Mon Sep 17 00:00:00 2001
> From: Dominique Martinet <asmadeus@codewreck.org>
> Date: Wed, 17 Aug 2022 14:49:29 +0900
> Subject: [PATCH] 9p: p9_client_create: use p9_client_destroy on failure
> 
> If trans was connected it's somehow possible to fail with requests in
> flight that could still be accessed after free if we just free the clnt
> on failure.
> Just use p9_client_destroy instead that has proper safeguards.
> 
> Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 5bf4dfef0c70..da5d43848600 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -948,7 +948,7 @@ struct p9_client *p9_client_create(const char *dev_name,
> char *options)
> 
>  	err = parse_opts(options, clnt);
>  	if (err < 0)
> -		goto free_client;
> +		goto out;
> 
>  	if (!clnt->trans_mod)
>  		clnt->trans_mod = v9fs_get_default_trans();
> @@ -957,7 +957,7 @@ struct p9_client *p9_client_create(const char *dev_name,
> char *options) err = -EPROTONOSUPPORT;
>  		p9_debug(P9_DEBUG_ERROR,
>  			 "No transport defined or default transport\n");
> -		goto free_client;
> +		goto out;
>  	}
> 
>  	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
> @@ -965,7 +965,7 @@ struct p9_client *p9_client_create(const char *dev_name,
> char *options)
> 
>  	err = clnt->trans_mod->create(clnt, dev_name, options);
>  	if (err)
> -		goto put_trans;
> +		goto out;
> 
>  	if (clnt->msize > clnt->trans_mod->maxsize) {
>  		clnt->msize = clnt->trans_mod->maxsize;
> @@ -979,12 +979,12 @@ struct p9_client *p9_client_create(const char
> *dev_name, char *options) p9_debug(P9_DEBUG_ERROR,
>  			 "Please specify a msize of at least 4k\n");
>  		err = -EINVAL;
> -		goto close_trans;
> +		goto out;
>  	}
> 
>  	err = p9_client_version(clnt);
>  	if (err)
> -		goto close_trans;
> +		goto out;
> 
>  	/* P9_HDRSZ + 4 is the smallest packet header we can have that is
>  	 * followed by data accessed from userspace by read
> @@ -997,12 +997,8 @@ struct p9_client *p9_client_create(const char
> *dev_name, char *options)
> 
>  	return clnt;
> 
> -close_trans:
> -	clnt->trans_mod->close(clnt);
> -put_trans:
> -	v9fs_put_trans(clnt->trans_mod);
> -free_client:
> -	kfree(clnt);
> +out:
> +	p9_client_destroy(clnt);
>  	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL(p9_client_create);

Looks like a nice reduction to me!

As p9_client_destroy() is doing a bit more than current code, I would probably 
additionally do s/kmalloc/kzmalloc/ at the start of the function, which would 
add more safety & reduction.

> -----
> 
> I'll test and submit to Linus over the next few weeks.
> 
> I had a quick look at the other new syzbot warnings and:
>  - 'possible deadlock in p9_req_put' is clear enough, we can just drop
> the lock before running through the cancel list and I don't think
> that'll cause any problem as everything has been moved to a local list
> and that lock is abused by trans fd for its local stuff. I'll also send
> that after quick testing.
> ----
> From c46435a4af7c119bd040922886ed2ea3a2a842d7 Mon Sep 17 00:00:00 2001
> From: Dominique Martinet <asmadeus@codewreck.org>
> Date: Wed, 17 Aug 2022 14:58:44 +0900
> Subject: [PATCH] 9p: trans_fd/p9_conn_cancel: drop client lock earlier
> 
> syzbot reported a double-lock here and we no longer need this
> lock after requests have been moved off to local list:
> just drop the lock earlier.
> 
> Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index e758978b44be..60fcc6b30b46 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -205,6 +205,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
>  		list_move(&req->req_list, &cancel_list);
>  	}
> 
> +	spin_unlock(&m->client->lock);
> +
>  	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
>  		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
>  		list_del(&req->req_list);
> @@ -212,7 +214,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
>  			req->t_err = err;
>  		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
>  	}
> -	spin_unlock(&m->client->lock);
>  }

Are you sure that would resolve that (other) syzbot report? I just had a 
glimpse at it yet, but I don't see this list iteration portion being involved 
in the backtrace provided by the report, is it?

> 
>  static __poll_t
> ----
> 
>  - but I don't get the two 'inconsistent lock state', the hint says it's
> possibly an interrupt while the lock was held but that doesn't seem to
> be the case from the stack trace (unless we leaked the lock, at which
> point anything goes)
> I'd need to take time to look at it, feel free to beat me to these.
> 
> --
> Dominique




