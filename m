Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A4456CF80
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGJOtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 10:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJOtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 10:49:41 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C0CE09D;
        Sun, 10 Jul 2022 07:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=WJOfGDr7u/BDDToEE9Qvjgh28U6lSAYZqnZi422JXYY=; b=Sk5AKrhUTgnBq8NkdSEVntBrug
        mPi63BSKjiStajFW8QukCAZqdAsWKMB1K/phOnT5IzYZeiO2hO/17R4aLh/gl0ZQNqCvtkjPA2BCV
        7ByjyApVa9Y+nKo6MiO/4tqFmtnaMvtDeV5Ezit500f2R7aBFWxLoXph8HZlgXbrL7iiDkJhlGZa7
        oYmFd/E+7E8RpkowUfyDnj5IxvZ2Z6CDwiDfzz6rHaqLFD8PlYLjFkfA/ASs5gO0TV2UoHL0wdl77
        B7jNcRSz/N4wrmxYqd2Hs00jfiDNPRB2wxlBhcPbayAL3xxFG0nl/qQhuVtnwA1Iwv9ZqbRMh1MYz
        QWoSPIBR07rlAyOFO+vB17tTtmh6pqBA54wZPwHWIx1ofy9mimoANDsqFHp5ykaseoh47q5hekjg+
        nWudIjDbeLiwl90BZFmFOlToFGpxUh4wgR2HfEDbcX0iIqgPaJzJUatT6HMGZk3d3HX84S2M0hn0z
        8HK/yUNG8KqBG6Ocq9b3XZvtGqjNtXj70ekSUHr1CFV/E4EQ3ULqxeqTw1fsA85br1fXZWZq1BiZ/
        ZeXJYiFVciaYYBJ84Qw0R5yRH6oCtHOoT8vdKo8csT4iBb9jW9HvanNNHFcTn9pf1UNNyM64FB+M1
        2CelIqseABwnf4M+EwNZOr9wm9mSzWBc9U7G+p8rY=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/9p: Initialize the iounit field during fid creation
Date:   Sun, 10 Jul 2022 16:48:29 +0200
Message-ID: <1984068.YOKu8ataPd@silver>
In-Reply-To: <20220710141402.803295-1-tyhicks@linux.microsoft.com>
References: <20220710141402.803295-1-tyhicks@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sonntag, 10. Juli 2022 16:14:02 CEST Tyler Hicks wrote:
> Ensure that the fid's iounit field is set to zero when a new fid is
> created. Certain 9P operations, such as OPEN and CREATE, allow the
> server to reply with an iounit size which the client code assigns to the
> p9_fid struct shortly after the fid is created by p9_fid_create(). On
> the other hand, an XATTRWALK operation doesn't allow for the server to
> specify an iounit value. The iounit field of the newly allocated p9_fid
> struct remained uninitialized in that case. Depending on allocation
> patterns, the iounit value could have been something reasonable that was
> carried over from previously freed fids or, in the worst case, could
> have been arbitrary values from non-fid related usages of the memory
> location.
> 
> The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
> after the uninitialized iounit field resulted in the typical sequence of
> two getxattr(2) syscalls, one to get the size of an xattr and another
> after allocating a sufficiently sized buffer to fit the xattr value, to
> hit an unexpected ERANGE error in the second call to getxattr(2). An
> uninitialized iounit field would sometimes force rsize to be smaller
> than the xattr value size in p9_client_read_once() and the 9P server in
> WSL refused to chunk up the READ on the attr_fid and, instead, returned
> ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
> the READ and this problem goes undetected there.
> 
> Fixes: ebf46264a004 ("fs/9p: Add support user. xattr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

> ---
> 
> v2:
> - Add Fixes tag
> - Improve commit message clarity to make it clear that this only affects
>   xattr get/set
> - kzalloc() the entire fid struct instead of individually zeroing each
>   member
>   - Thanks to Christophe JAILLET for the suggestion
> v1: https://lore.kernel.org/lkml/20220710062557.GA272934@sequoia/
> 
>  net/9p/client.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 8bba0d9cf975..371519e7b885 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -889,16 +889,13 @@ static struct p9_fid *p9_fid_create(struct p9_client
> *clnt) struct p9_fid *fid;
> 
>  	p9_debug(P9_DEBUG_FID, "clnt %p\n", clnt);
> -	fid = kmalloc(sizeof(*fid), GFP_KERNEL);
> +	fid = kzalloc(sizeof(*fid), GFP_KERNEL);
>  	if (!fid)
>  		return NULL;
> 
> -	memset(&fid->qid, 0, sizeof(fid->qid));
>  	fid->mode = -1;
>  	fid->uid = current_fsuid();
>  	fid->clnt = clnt;
> -	fid->rdir = NULL;
> -	fid->fid = 0;
>  	refcount_set(&fid->count, 1);
> 
>  	idr_preload(GFP_KERNEL);


