Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F66A29D727
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgJ1WVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732520AbgJ1WVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:21:38 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C1EC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:21:38 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h19so710256qtq.4
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMdSxhrJYBURkqz7vuQ/0KG/bpGUcYCBVNAAU6qDxZQ=;
        b=Y61OBinf3vrIrxUP0b3awTyUHYbhIHKNhSL615f08vDDATq2jCErDu7t4x7NifJ124
         FpIxHuIt2K39TXYiCajXD9BFyLE+aGdYX68nliI/DMJyu40tJfcWVWGDr9Gu6PITtG0K
         qEfDMNgKO/x00J5PcmquADmo2sj2TttrEhVywpJPZqP8TUHu9dftG5CDBnHc+YxVwofj
         vFEjJ713Ge06k03as/PADnXXecb9f4fVXZldheEnJkyIRISS9bozvHU4I7BkRXehX4ci
         7vJ1izJfbxznt6SC9u0LlpwoEDDBb0szWJtkbepGa7EdXYeKJ1xc7k/v3nNQZeQjP4CI
         S1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMdSxhrJYBURkqz7vuQ/0KG/bpGUcYCBVNAAU6qDxZQ=;
        b=T50XMwROkEZGpgKbZQkkdj1+fjzU2syvRhAPF0uWxA9S25MJ8P3zn4pl7WxETo3N4b
         4QMy/+20QIZIG36FyczeRX0qrNtUtopDgJzWAqwRGwaqA8WvJnadotXnKAU7ou9aA3u9
         9JSP+NRpXjIs5sCGOfUcMZQMvAwAs79fYF8U3ThxaASJnYfdM7srNm0vS7G7v7AMCr5c
         VvuY4DKxiQDgB5t1cta3xEZ6/198Xadi/zU2lFd2KWtUgEqYsNgnyLfOIeG+U/s3C756
         AuhDexXP/ISyctMPvJG7eq1is1QZHPfUkmnYjvxqh5U4oL4ygi4cxKlIOzYRPjLv1hfN
         uQFQ==
X-Gm-Message-State: AOAM531ctssy1SVsDHLSBWS5Y3PorloqYDVMd8oBC4G6fs4OWLFEcMMB
        l58dqvEQRhpe9yr3O7osbhFlwkYJezlasvYOfFIzvgYRQYW1cA==
X-Google-Smtp-Source: ABdhPJxd55u39c0Y+fjKlUPCbpp318Hi8GiHmoBICHzeRWs9C1CQZMmIgR+qysjoK2GjJoN+N3ZWEHgfltIzC+OwqxU=
X-Received: by 2002:a02:b786:: with SMTP id f6mr659152jam.75.1603913501192;
 Wed, 28 Oct 2020 12:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 28 Oct 2020 12:31:30 -0700
Message-ID: <CAM_iQpU-tu39476eh_22rcNaZt8EJ3FeQJu82J4p6L26vnKcxQ@mail.gmail.com>
Subject: Re: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by tipc_buf_append()
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 1:09 PM Tung Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> Commit ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
> replaced skb_unshare() with skb_copy() to not reduce the data reference
> counter of the original skb intentionally. This is not the correct

More precisely, it is shinfo->dataref.


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

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
