Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95765313E50
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhBHTAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbhBHS6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:58:05 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8E8C0617A9;
        Mon,  8 Feb 2021 10:57:05 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id m2so4098508pgq.5;
        Mon, 08 Feb 2021 10:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eq6iM3oquBlLx4FlK1IEBPE2up648tlds104Yvfh8Jw=;
        b=nFRe2vtxKOnDNeVbZ2sIf7SSPbYyM/s1K2MHz3ibXpbRn1Gv5UkxthqutQtPi8Cb9b
         /7vbDG+7Ba0mHCbroVX9saKLNYV0ciTuKg970S7HkKC/IcZd8gBZK6D1AUZIHAxtGRH5
         R7LEiTeWr9JEAq/5IZH7AnVrnG7AaZZ/gJDnlv+CsM3ty+YU8wk4Xb1+qqqo327KmSxa
         llbNprB/GAFHOZfmZFLDYmhzJomS1B8SeG3oW5hEQKcb/s0LglcPPj0eDZk+hNksQb1l
         KX1gX1j9tdgRFjte8PuSP0CK6UbDxl10DiVb8c5zwGE5eRDnDqktZyGqE1S/mkFd6lAC
         bViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eq6iM3oquBlLx4FlK1IEBPE2up648tlds104Yvfh8Jw=;
        b=cPXK+TX5i/ycLc4oaJE8ZjHxLTJUwwsvsn+w2ypxJ/kGVspjPs3OL+Q6HYzksGXIwV
         QTokIhXMsNW0NgbnjhwIbEL9mhkrp7jLxcGBLQgyCTftNFzGA9EA1pma4kOtpjcrXYyX
         EDXKrFwnWvgFF94w+7Dv5j18ZR/YG4Cj9Yy9Np2iak8X6/WWKoQ/xN4cdZ1H3DKOw/fE
         FNW8fjCsFAEsIkVQF7vz50S69miGZANTOO23wUsB1n1gc+Mqz/jVaWnnc7VuiPehPUbW
         hjRCi90MFghqmfQjkOr3xVgRCLyq19213sYJ7gUgOSJtpjyN+3M77SXS1FKcrKyEmqFc
         vcGA==
X-Gm-Message-State: AOAM531smZmEp5XhWlnhoUsX6+0YAGOAY61P8DzwLXQVjras/8J/0Gxm
        p8qWwYdDi2ccSYbB6Y30qIDxlcgt5uRtLUAYvH8=
X-Google-Smtp-Source: ABdhPJzEf0MDOhzLO1rw1iSgzhfZXvJxvwGyuBqchNTXYP0vOjFffpd/7wGSm6b3UHdYwXSOfElf2CLZjndUCXdXr6o=
X-Received: by 2002:a63:3c4e:: with SMTP id i14mr17932576pgn.266.1612810625318;
 Mon, 08 Feb 2021 10:57:05 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-4-xiyou.wangcong@gmail.com> <87eehu4157.fsf@cloudflare.com>
In-Reply-To: <87eehu4157.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 10:56:54 -0800
Message-ID: <CAM_iQpXtKisVu-QJA3=51oDJqEwEiuQu=np83RN0=r2A3wG0HA@mail.gmail.com>
Subject: Re: [Patch bpf-next 03/19] skmsg: use skb ext instead of TCP_SKB_CB
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:09 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > won't work for any other non-TCP protocols. We can move them to
> > skb ext instead of playing with skb cb, which is harder to make
> > correct.
> >
> > Of course, except ->data_end, which is used by
> > sk_skb_convert_ctx_access() to adjust compile-time constant offset.
> > Fortunately, we can reuse the anonymous union where the field
> > 'tcp_tsorted_anchor' is and save/restore the overwritten part
> > before/after a brief use.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/linux/skbuff.h |  4 ++++
> >  include/linux/skmsg.h  | 45 ++++++++++++++++++++++++++++++++++++++++++
> >  include/net/tcp.h      | 25 -----------------------
> >  net/Kconfig            |  1 +
> >  net/core/filter.c      |  3 +--
> >  net/core/skbuff.c      |  7 +++++++
> >  net/core/skmsg.c       | 44 ++++++++++++++++++++++++++++-------------
> >  net/core/sock_map.c    | 12 +++++------
> >  8 files changed, 94 insertions(+), 47 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 46f901adf1a8..12a28268233a 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -755,6 +755,7 @@ struct sk_buff {
> >                       void            (*destructor)(struct sk_buff *skb);
> >               };
> >               struct list_head        tcp_tsorted_anchor;
> > +             void                    *data_end;
> >       };
>
> I think we can avoid `data_end` by computing it in BPF with the help of
> a scratch register. Similar to how we compute skb_shinfo(skb) in
> bpf_convert_shinfo_access(). Something like:

Sounds like an excellent idea! It is certainly much better if we can just
compute it at run-time. I will give this a try.

Thanks!
