Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFB162D410
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbiKQH3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiKQH3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:29:54 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2C538BB
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:29:52 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 34863C023; Thu, 17 Nov 2022 08:29:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668670197; bh=SWElJ8vtTRkRZrwBaPPTOgrSoKbRZvznzYk3yhSldIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOp7chA/T2OO1XqJkRsF3CgpBpppUs2y7UpdgW83Bw2kUQ7RZ+OyQoMolu90WY9R9
         utsj1lMmfFoaw1EGa1DCnVb+ogIy5ZFd8H3p7T+xL7sMjUGUtQ2Z3d1BaTLCU4Aaf7
         +6lAjqT8i6KJKownLP2Zebj4NMAkwvlD79JuJfWJnyLpZp7CV8zWK+2tJ5BFQaV/T0
         1TxWduPFc69lnyfWRB8T64B8rH9vO7tAlgrwyVarQULT87Id06Bt38orPYp1rRiDGB
         6y3OtWbJx5optzX4hrLf+L7n7qn2WwD8BCtyIE1jtzUtdLiNQfBtkkzAq7dga7dY9V
         k7MRdJdOzim6g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 67C05C009;
        Thu, 17 Nov 2022 08:29:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668670195; bh=SWElJ8vtTRkRZrwBaPPTOgrSoKbRZvznzYk3yhSldIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LrBMSaeFUuSOPi84gfWo+Vfw8/398wMqsefd2Dm9m09giYHHlWbjeI68Doa5y9NZ/
         ttGF18UlHJIXFtiHfxGROqSjiO1HB1Tc5XN+YqtDksrAUCNBzYfyMVbGlrgNn0BMwN
         FMXo7v/E/zgHnxLksmgOaj8Fm39ANKuHyEMYBREPyTkc3/YL/we4WfMrrxpc76ZvxQ
         63v0NbqWHmVBD+zy/eXcX0+EYCkhaS2G/eSGQ1V5u37pVke+P4Rrq0inVkJdK7nVLx
         qyIPlFdpw2LqkUh5ycXBYScG/NM+kVMnN8s9CXF77/LMg89yPfJm4Bid8a4lgwo8ku
         sPY8kS0JOXWsA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id cb1a3746;
        Thu, 17 Nov 2022 07:29:43 +0000 (UTC)
Date:   Thu, 17 Nov 2022 16:29:28 +0900
From:   asmadeus@codewreck.org
To:     GUO Zihua <guozihua@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] 9p: Fix write overflow in p9_read_work
Message-ID: <Y3Xi2PmyglEzH5/u@codewreck.org>
References: <20221117061444.27287-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221117061444.27287-1-guozihua@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GUO Zihua wrote on Thu, Nov 17, 2022 at 02:14:44PM +0800:
> The root cause of this issue is that we check the size of the message
> received against the msize of the client in p9_read_work. However, this
> msize could be lager than the capacity of the sdata buffer. Thus,
> the message size should also be checked against sdata capacity.

Thanks for the fix!

I'm picky, so a few remarks below.

> 
> Reported-by: syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com
> Fixes: 1b0a763bdd5e ("9p: use the rcall structure passed in the request in trans_fd read_work")
> Signed-off-by: GUO Zihua <guozihua@huawei.com>
> ---
>  net/9p/trans_fd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index 56a186768750..bc131a21c098 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -342,6 +342,14 @@ static void p9_read_work(struct work_struct *work)
>  			goto error;
>  		}
>  
> +		if (m->rc.size > m->rreq->rc.capacity - m->rc.offset) {

Ah, it took me a while to understand but capacity here is no longer the
same as msize since commit 60ece0833b6c ("net/9p: allocate appropriate
reduced message buffers")

If you have time to test the reproducer, please check with any commit
before 60ece0833b6c if you can still reproduce. If not please fix your
Fixes tag to this commit.
I'd appreciate a word in the commit message saying that message capacity
is no longer constant here and needs a more subtle check than msize.


Also:
 - We can remove the msize check, it's redundant with this; it doesn't
matter if we don't check for msize before doing the tag lookup as tag
has already been read
 - While the `- offset` part of the check is correct (rc.size does
not include headers, and the current offset must be 7 here) I'd prefer
if you woud use P9_HDRSZ as that's defined in the protocol and using
macros will be easier to check if that ever evolves.
 - (I'd also appreciate if you could update the capacity = 7 next to the
'start by reading header' comment above while you're here so we use the
same macro in both place)


> +			p9_debug(P9_DEBUG_ERROR,
> +				 "requested packet size too big: %d\n",
> +				 m->rc.size);

Please log m->rc.tag, m->rc.id and m->rreq->rc.capacity as well for
debugging if that happens.

> +			err = -EIO;
> +			goto error;
> +		}
> +
>  		if (!m->rreq->rc.sdata) {
>  			p9_debug(P9_DEBUG_ERROR,
> 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
--
Dominique
