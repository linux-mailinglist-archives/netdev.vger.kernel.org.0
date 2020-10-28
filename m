Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F92D29DF97
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgJ1WLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730645AbgJ1WLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:11:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A4EC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:11:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v5so704788wmh.1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MrRkg6hgrIakHQHLsBsS2GEI0YeeJqZ4UdmXD7YSKjI=;
        b=YCunPHezetGcSHSlLwkXMRoDhpTX/SwcYw92RKFP3639a5z30kEZmNfvYGuxaeZiqz
         4SSFj8ZMzre3j7ayGYrX4k0Qn56aIG2ZOCrPsfhkgtx5DUS0EuCM+xBNdBS7XzwVegRb
         KElhpxmWzsdQD4jRhUo4ma+1NtGSAl3M0TdOXGnLQlRdBtIRWedN2FybLMlRvI6KbfgA
         2u3XmViuB1B7BQ1n7s4pefiBvuYgwIQ021rlsWJ2lvaTrESetIArImlWA/f3Vz9Jshx5
         Q6gCaICypb6ThZTX7DXUpn0RvsUX4VCJud8S4tliGi4Xf5gG5ctvDaunlWVswp4CKXMS
         TR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MrRkg6hgrIakHQHLsBsS2GEI0YeeJqZ4UdmXD7YSKjI=;
        b=LL/92+m1Zxd50XO28mmY4X1B9ayaqiAP5bSd2RNqW1N1jAi8d+AAYfnVuA3wv9NvSc
         wjja7tzpFB3WD/XccxCzCMx02Hv0pMKgQmJMo/SJMb2IO2PDSGicA5mHAPk1hE7AsBE8
         vUY362n5ub7XZ9PBH62ySc32QoasSKVkloshBcWc+dPRgrBlxiCLsQrgAi3CBRUeCGmL
         LGmbpxTy+YGppo+M6+ZxJwGzJn5tzb2bqE9Ou6odT7U/8QM3i4zMXF4PXCcj7JUjCeC0
         errkKi5YHrz2TygJbPFZ4kixYptSxlV1ODHlWV0TgTrtmdXuAZkClZG8R02a3j9oIfwp
         t5Ig==
X-Gm-Message-State: AOAM533a2Ust6EtUZKhZ6SDI5PJ9iEOKGKNh8CGUnReyFS34jEbH/fLs
        wQhaKIxMftCQ3XlNNNZohBJg+YZFwa5GNoLvV/zWrSwPXzQ=
X-Google-Smtp-Source: ABdhPJw+mVZZyEpmi3KZkMCcf8rrXtJsNXCp53B36dynxKI8jTc3ft8rivfJw9XMYfoE7wSnqpe+GQD/txtLTX0KNow=
X-Received: by 2002:a1c:750b:: with SMTP id o11mr6293100wmc.32.1603862488437;
 Tue, 27 Oct 2020 22:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 28 Oct 2020 13:21:17 +0800
Message-ID: <CADvbK_fPKYoyk1w4ri_oxRiutGZDE9FaE5xrx1UXgY2_gdCO0Q@mail.gmail.com>
Subject: Re: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by tipc_buf_append()
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     davem <davem@davemloft.net>, network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:25 AM Tung Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> Commit ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
> replaced skb_unshare() with skb_copy() to not reduce the data reference
> counter of the original skb intentionally. This is not the correct
> way to handle the cloned skb because it causes memory leak in 2
> following cases:
>  1/ Sending multicast messages via broadcast link
>   The original skb list is cloned to the local skb list for local
>   destination. After that, the data reference counter of each skb
>   in the original list has the value of 2. This causes each skb not
>   to be freed after receiving ACK:
>   tipc_link_advance_transmq()
>   {
>    ...
>    /* release skb */
>    __skb_unlink(skb, &l->transmq);
>    kfree_skb(skb); <-- memory exists after being freed
>   }
>
>  2/ Sending multicast messages via replicast link
>   Similar to the above case, each skb cannot be freed after purging
>   the skb list:
>   tipc_mcast_xmit()
>   {
>    ...
>    __skb_queue_purge(pkts); <-- memory exists after being freed
>   }
>
> This commit fixes this issue by using skb_unshare() instead. Besides,
> to avoid use-after-free error reported by KASAN, the pointer to the
> fragment is set to NULL before calling skb_unshare() to make sure that
> the original skb is not freed after freeing the fragment 2 times in
> case skb_unshare() returns NULL.
>
> Fixes: ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Reported-by: Thang Hoang Ngo <thang.h.ngo@dektech.com.au>
> Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Reviewed-by: Xin Long <lucien.xin@gmail.com>

> ---
>  net/tipc/msg.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index 2a78aa701572..32c79c59052b 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -150,12 +150,11 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
>         if (fragid == FIRST_FRAGMENT) {
>                 if (unlikely(head))
>                         goto err;
> -               if (skb_cloned(frag))
> -                       frag = skb_copy(frag, GFP_ATOMIC);
> +               *buf = NULL;
> +               frag = skb_unshare(frag, GFP_ATOMIC);
>                 if (unlikely(!frag))
>                         goto err;
>                 head = *headbuf = frag;
> -               *buf = NULL;
>                 TIPC_SKB_CB(head)->tail = NULL;
>                 if (skb_is_nonlinear(head)) {
>                         skb_walk_frags(head, tail) {
> --
> 2.17.1
>
>
>
> _______________________________________________
> tipc-discussion mailing list
> tipc-discussion@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tipc-discussion
