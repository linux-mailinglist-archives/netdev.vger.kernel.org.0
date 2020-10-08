Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED37287B21
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgJHRpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgJHRpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:45:10 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6E4C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 10:45:08 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k25so7178901ioh.7
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 10:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7c6P9y8oZCFRMDjIeQQPduGoLHcjK1nCsIFHGMh/gMM=;
        b=XGf1phL3L92ks5nPZoiatj0bOhxvaKSRhFWZ6Bnt4a3j2YM74VXQ+3sflnEPvWAX7Z
         li9Tj7em8GONUbAozHl5a9kh54CF0wexOAO1SIycenSmYmPHCifNQFoF6BxH34uOF3VO
         8TJezo4zvnGthphAGjVrWQhwYdQATX170Qk/GoL0ELNPjg3AYaRr2+Uu9oJe4j6H9yqV
         rIs9PtzPhJpFy40vSmjc+2RX7XOXWWsWcRizXNf890lCMMOzam34sqbtqXWYLdfkA2Pe
         Cu8rjrRUUq7VIMB9gB3nEak6IiNsF5s61hUagLkz6KXItbbL7FLdu1vqtIJ4mcubuybt
         zI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7c6P9y8oZCFRMDjIeQQPduGoLHcjK1nCsIFHGMh/gMM=;
        b=uBwulgv26Nn7J/2sIlLcvzArBrmpMCbX6FFcStsmgjfBQDEFMi1EXgv033eXtY5KJX
         Z2y0f9cUgA3B38zXQhQKW7yXHKE34gX6hlE/suDC13fbmKqi2rK93eqR3qYzcPyMwc6E
         Ad4uI196GRaDsqbKEpUf0mJ9E+Zf1UcmGifkIRs8BUNAzOjx46lHrWtKLa5XH/bKVZSY
         U10Tew5VTm/2Kf+r2+fKF53H4j5hsoXzmKdNRqdm97TxVj6Q3L3PhHOgETZuk0Ig5XMK
         UHiTaR3zVWouiRvp8Tg1CltXfhlW3nFuQevGaGoxC3ZVUrezko+7RzDt1XBK3m1SEjFF
         jjzg==
X-Gm-Message-State: AOAM532fGpPwKhMpRcL6aE12MfYZAircVc/VhnRdFJM63X/qrAbJoFK7
        4JO4VSQ9zweiYyfWf+nrywNLt8R4jM325s32DYQExC6kr1yvCg==
X-Google-Smtp-Source: ABdhPJxdFfn+S77W/rpoow6//gEGrsKxV7L1Q7ExxMqfDp99/TtK93XNKpRMx8+nzg3tyBlKvCOlwOY7cubg9XtJQn4=
X-Received: by 2002:a6b:1542:: with SMTP id 63mr6722773iov.64.1602179107861;
 Thu, 08 Oct 2020 10:45:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201008041250.22642-1-xiyou.wangcong@gmail.com> <CADvbK_dwh4SFL1KbX=GhxW_O=cZLoPcXC9RjYpZd4=tWrm0LBA@mail.gmail.com>
In-Reply-To: <CADvbK_dwh4SFL1KbX=GhxW_O=cZLoPcXC9RjYpZd4=tWrm0LBA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Oct 2020 10:44:56 -0700
Message-ID: <CAM_iQpW+3w28v6VVvAPrtmKh_Y7UXfFvna9ey77f9m3mDn7tZQ@mail.gmail.com>
Subject: Re: [Patch net] tipc: fix the skb_unshare() in tipc_buf_append()
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        syzbot <syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 1:45 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 12:12 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > skb_unshare() drops a reference count on the old skb unconditionally,
> > so in the failure case, we end up freeing the skb twice here.
> > And because the skb is allocated in fclone and cloned by caller
> > tipc_msg_reassemble(), the consequence is actually freeing the
> > original skb too, thus triggered the UAF by syzbot.
> Do you mean:
>                 frag = skb_clone(skb, GFP_ATOMIC);
> frag = skb_unshare(frag) will free the 'skb' too?

Yes, more precisely, I mean:

new = skb_clone(old)
kfree_skb(new)
kfree_skb(new)

would free 'old' eventually when 'old' is a fast clone. The skb_clone()
sets ->fclone_ref to 2 and returns the clone, whose skb->fclone is
SKB_FCLONE_CLONE. So, the first call of kfree_skbmem() will
just decrease ->fclone_ref by 1, but the second call will trigger
kmem_cache_free() which frees _both_  skb's.

Thanks.
