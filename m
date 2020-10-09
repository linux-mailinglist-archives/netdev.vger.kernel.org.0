Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E612828809C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbgJIDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbgJIDIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:08:04 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E188C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 20:08:04 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e2so8381027wme.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sOTzLK2/d3FAodsq0P4cDlcAgX0I4W/XvmJSrRY653k=;
        b=LVAaZfoUWhh2DUHoa0Y3CCYpQiFplJl9kH0ublZGbZXLEOUEup5nwU0OTe+NLvEj8A
         yg0XXgvG5U3gZwHA/yuEIwM1Xe4BErQxsSCHfY6UghpeE2zEizeCB4B2gq8OeVBHO9xE
         AcRQ2I0zXJduzTf+YD5Db+OdhofHQKY+dabc6XkMKwmjxvevmOfp/d9Y1bqYmCSBAqhY
         hV8OnywCfAjxjQsh54pt7mGp2Vdql7tRYc0wW8gwsrzn/5ePaZ6V4p+ARtBE0aTRlZFq
         b9jOa9LfBobYdD5bvLEMTknCg7i8EPduJkjiFGJv/wvzICEKHU97idO7EyJvSuYg76LS
         DZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOTzLK2/d3FAodsq0P4cDlcAgX0I4W/XvmJSrRY653k=;
        b=FQYg/pZuy0RC6U1MtOFacUT2vxjJ73/9m2EVKpVA+DKgXLnR00L992y12bzntXXKcv
         VsmHNAec7wQW6LBW/tl//P34vpbQyeItGQ9OR03xt5RBKcpDLcL5QfCRjMZxw+k1yWLf
         dyhEBxyW8FegETzXFBS297fgATJKD6WWL7Oj8P1g2SHqGZGhvcd5nS72ECI7wzOQeimH
         If+QW2buOT4+2m8hxzhZ4fBCRlUTZpcTkBeWhclQImZUoq9zAkn0kDcZW1LVHKFIMA0N
         lxwheQIXkUaE49iciZqoPcPLQZs6NujKNGRcFQ0b95caeuN1ve/QoB1gJaczgJGtkWSk
         bRHQ==
X-Gm-Message-State: AOAM530nC5UB+V9VJYnOMR5im6ktouXpDOHX51tdNMRgLadf79grzmi3
        Sr6oC/wrUcJW53tMJeFIUFLOshjjMrasVV9KCXk=
X-Google-Smtp-Source: ABdhPJwLYeGV+ReH6P3iSIVB3EmILp4iXkzG+LnJ3qMR1wEq9KuYcZ5YHvvhsQvEkJDYaX2wK4h49TcgvzKKVv0lfVE=
X-Received: by 2002:a1c:1905:: with SMTP id 5mr12154832wmz.32.1602212882653;
 Thu, 08 Oct 2020 20:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201008041250.22642-1-xiyou.wangcong@gmail.com>
 <CADvbK_dwh4SFL1KbX=GhxW_O=cZLoPcXC9RjYpZd4=tWrm0LBA@mail.gmail.com> <CAM_iQpW+3w28v6VVvAPrtmKh_Y7UXfFvna9ey77f9m3mDn7tZQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW+3w28v6VVvAPrtmKh_Y7UXfFvna9ey77f9m3mDn7tZQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 9 Oct 2020 11:07:51 +0800
Message-ID: <CADvbK_e1A9BuNKbT_TkeWwxrZv-_jLKJduDn=8Bx24XXKA+w3A@mail.gmail.com>
Subject: Re: [Patch net] tipc: fix the skb_unshare() in tipc_buf_append()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        syzbot <syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 1:45 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 1:45 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 12:12 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > skb_unshare() drops a reference count on the old skb unconditionally,
> > > so in the failure case, we end up freeing the skb twice here.
> > > And because the skb is allocated in fclone and cloned by caller
> > > tipc_msg_reassemble(), the consequence is actually freeing the
> > > original skb too, thus triggered the UAF by syzbot.
> > Do you mean:
> >                 frag = skb_clone(skb, GFP_ATOMIC);
> > frag = skb_unshare(frag) will free the 'skb' too?
>
> Yes, more precisely, I mean:
>
> new = skb_clone(old)
> kfree_skb(new)
> kfree_skb(new)
>
> would free 'old' eventually when 'old' is a fast clone. The skb_clone()
> sets ->fclone_ref to 2 and returns the clone, whose skb->fclone is
> SKB_FCLONE_CLONE. So, the first call of kfree_skbmem() will
> just decrease ->fclone_ref by 1, but the second call will trigger
> kmem_cache_free() which frees _both_  skb's.
Thanks. Didn't notice kfree_skb 'buf' on the err path.

Reviewed-by: Xin Long <lucien.xin@gmail.com>
