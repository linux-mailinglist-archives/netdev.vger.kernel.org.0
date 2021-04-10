Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9366835ACAF
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 12:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhDJKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbhDJKNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 06:13:06 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C72C061763
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 03:12:50 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g38so9344354ybi.12
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 03:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CARFTmdzvVOf8CR8k8TSb1Bj3En1zT2VabMkTx+vpaY=;
        b=TDlQvmZUjGwNXEEdC49UUFP0nlWgNVZoZCpX1EVJDcg5cOECaKzX9/dCC0OHkrEvx4
         woz3TqfsopHp4fGMFzPzvztvlcy2bUMpofjVo+v8y8/O4msdYmEeFD2y9FNpo5WLTGRD
         2/GFlvWEtZ7gFkD3FIWzvn+bqNgHqtFDhg3iUkJbI9VB95sHFYa/cu7vb2Ku5JjRCJzl
         He2PqTywv/q5pCsd5zdmG9OkjgLD/ZJ85ui3gqLLqJqMbFps/kiGUg4aZLRury5rZwKA
         qWKPTLwlibYDdag1jPj3B5b6dOIRzvg93vZI5D/zpWGCFdWSi2BTEaE9+AXX4gKXHADz
         bA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CARFTmdzvVOf8CR8k8TSb1Bj3En1zT2VabMkTx+vpaY=;
        b=WvewMHFVYzGeRxW0nEbg7bD6fH0qTTEt8U/ZgigJM+klAOGl7a1fehFGmLz6E5S6T2
         3Vnss9Bkn+q6hhiAHkeNLqId6XePwgRIyuOnFAJgZGa2jMAd6pBsVWkpyK86yAYB7WKM
         j3qzAPcW3olojgQ0/xFQmbqhSpyC55jCBpiies+3Egi6ADroV9wbRQQdjmDN0INl4URO
         e5LjA3HOuzmDZjKAJj0BcbH7UZsIZwvhy4F90/d37VCHDhDCLrosUURrQoUa62pnCFB3
         FmYeYHNTrZtnvpPZqqrjgGGBkWc+dw9IoGjyMojWfXw/MA8XMHOq5765BbQgiTG5dRpq
         rTgg==
X-Gm-Message-State: AOAM530VxegvJ4klMF1db0lEUUeyyoVnLkX+gku0J9nMkUnp5zkvx01v
        0lfoBAngL/tiuV4zX5OH597MuWy+2Nua7Gv98bKTHA==
X-Google-Smtp-Source: ABdhPJykbc2kIdAnxojWnWmjTXLCoqiYIos3RQmPBSfwujcYI0ykjnGLqgi5HdHhuXcv19zMpV1TEG7oxIWIWF+Gpak=
X-Received: by 2002:a25:7e01:: with SMTP id z1mr26393090ybc.253.1618049569299;
 Sat, 10 Apr 2021 03:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210410095149.3708143-1-phil@philpotter.co.uk>
In-Reply-To: <20210410095149.3708143-1-phil@philpotter.co.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 10 Apr 2021 12:12:38 +0200
Message-ID: <CANn89iJdoaC9P_Nd=BrXVRyMS43YOg-DX=VciDO89mH_JPVRTg@mail.gmail.com>
Subject: Re: [PATCH] net: core: sk_buff: zero-fill skb->data in __alloc_skb function
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        linmiaohe@huawei.com, linyunsheng@huawei.com, alobakin@pm.me,
        elver@google.com, gnault@redhat.com, dseok.yi@samsung.com,
        viro@zeniv.linux.org.uk, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 11:51 AM Phillip Potter <phil@philpotter.co.uk> wrote:
>
> Zero-fill skb->data in __alloc_skb function of net/core/skbuff.c,
> up to start of struct skb_shared_info bytes. Fixes a KMSAN-found
> uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f
>
> Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  net/core/skbuff.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 785daff48030..9ac26cdb5417 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -215,6 +215,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>          * to allow max possible filling before reallocation.
>          */
>         size = SKB_WITH_OVERHEAD(ksize(data));
> +       memset(data, 0, size);
>         prefetchw(data + size);


Certainly not.

There is a difference between kmalloc() and kzalloc()

Here you are basically silencing KMSAN and make it useless.

Please fix the real issue, or stop using KMSAN if it bothers you.
