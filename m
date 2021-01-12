Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B112F3D66
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407054AbhALVi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437154AbhALVXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:23:34 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B522CC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:22:53 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u17so7236815iow.1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=79RFCeMIaYDXiPI1/HqUMoFY6dJBx7Ne1PhmBLE0xOk=;
        b=DNSCUBPiBI/EdlDKAYuRWBKLNYPkwhWn2tzGj+G7JjoimR5AFrK3pnAfpa8ntE/J+/
         ykPeTw7SBAUNGT7YYuSSSq6DutaUtGDPQw26Ykar/qeRP+sPaOAOKfE8mNS+/EPs+NpU
         0UcW6i8jLtoe63eE2WG8DRKmyE8BPPU8/M+uALbRpw7Rq6M0bCgmCnNJmd4DfykSCugJ
         Ig3afwNq6qRblZ47HmGdQhJFKLYCwPd0M4UBPM2QgVUc8qcjWeImWAHNwxwnmBNlsW67
         u+LLBtmSjq0EsD6q32m68e9Crg5Lm+wSNxgx65j7NzAt2rUMlrVd50VrhG+ARs6Oa8f1
         lhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=79RFCeMIaYDXiPI1/HqUMoFY6dJBx7Ne1PhmBLE0xOk=;
        b=Fl7/56wP8B2Garpd1HbllWE/NT0UuV8qO4IJ4PJVprztPzKGWjg3CI2xsSFJm2q0NV
         X6nLtE8yIso5qhlGWZ6WoIWdzcguITQqZUPhM1+P2sBeqMnhaNeJnRW6w8QCh7NOEtNg
         6r352oChe/CG/dVunHlzLy3VDZ81OvPJk404ic3dLkMGSCUeobl9m3Zz7es/CNe6EoTO
         0nb07v6KBBqW5SwkmaDydhgfFTFVEyA271zoU58IXkZf2OxLwQEEy2WwEjARPW5/iGzg
         pyGR1N6NsYqn6+KjijNNsIiHdiZ2wk3Vt3mpWOzwpHavKuOqOm1a/DWdkBhb5XYyFcap
         fmEw==
X-Gm-Message-State: AOAM533AWnmhp1o9AtC7fJXgE2DjhN7kowunUviHYDhSLyhaMUMhfjOO
        YHOcGb1ADoBbjFleppDbienKqMiX1fpo1vZkoS0=
X-Google-Smtp-Source: ABdhPJxVm5uPMqt21c6lmlknG3ikW+Xvb66Hap1+htQk1sSK/L2PSQJGvpiynDbXrhENvgi7By+fmCrDO5WiZWK7IY0=
X-Received: by 2002:a02:5889:: with SMTP id f131mr1307261jab.121.1610486572303;
 Tue, 12 Jan 2021 13:22:52 -0800 (PST)
MIME-Version: 1.0
References: <1609990905-29220-1-git-send-email-lirongqing@baidu.com>
 <CAKgT0Ucar6h-V2pQK6Gx4wrwFzJqySfv-MGXtW1yEc6Jq3uNSQ@mail.gmail.com> <65a7da2dc20c4fa5b69270f078026100@baidu.com>
In-Reply-To: <65a7da2dc20c4fa5b69270f078026100@baidu.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 12 Jan 2021 13:22:41 -0800
Message-ID: <CAKgT0UccR7Mh4efd+d193bvQNP2-QMdBxP0uk0__0Z+dYepNjg@mail.gmail.com>
Subject: Re: [PATCH] igb: avoid premature Rx buffer reuse
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 6:54 PM Li,Rongqing <lirongqing@baidu.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Alexander Duyck [mailto:alexander.duyck@gmail.com]
> > Sent: Tuesday, January 12, 2021 4:54 AM
> > To: Li,Rongqing <lirongqing@baidu.com>
> > Cc: Netdev <netdev@vger.kernel.org>; intel-wired-lan
> > <intel-wired-lan@lists.osuosl.org>; Bj=C3=B6rn T=C3=B6pel <bjorn.topel@=
intel.com>
> > Subject: Re: [PATCH] igb: avoid premature Rx buffer reuse
> >
> > On Wed, Jan 6, 2021 at 7:53 PM Li RongQing <lirongqing@baidu.com> wrote=
:
> > >
> > > The page recycle code, incorrectly, relied on that a page fragment
> > > could not be freed inside xdp_do_redirect(). This assumption leads to
> > > that page fragments that are used by the stack/XDP redirect can be
> > > reused and overwritten.
> > >
> > > To avoid this, store the page count prior invoking xdp_do_redirect().
> > >
> > > Fixes: 9cbc948b5a20 ("igb: add XDP support")
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > I'm not sure what you are talking about here. We allow for a 0 to 1 cou=
nt
> > difference in the pagecount bias. The idea is the driver should be hold=
ing onto
> > at least one reference from the driver at all times.
> > Are you saying that is not the case?
> >
> > As far as the code itself we hold onto the page as long as our differen=
ce does
> > not exceed 1. So specifically if the XDP call is freeing the page the p=
age itself
> > should still be valid as the reference count shouldn't drop below 1, an=
d in that
> > case the driver should be holding that one reference to the page.
> >
> > When we perform our check we are performing it such at output of either=
 0 if
> > the page is freed, or 1 if the page is not freed are acceptable for us =
to allow
> > reuse. The key bit is in igb_clean_rx_irq where we will flip the buffer=
 for the
> > IGB_XDP_TX | IGB_XDP_REDIR case and just increment the pagecnt_bias
> > indicating that the page was dropped in the non-flipped case.
> >
> > Are you perhaps seeing a function that is returning an error and still =
consuming
> > the page? If so that might explain what you are seeing.
> > However the bug would be in the other driver not this one. The
> > xdp_do_redirect function is not supposed to free the page if it returns=
 an error.
> > It is supposed to leave that up to the function that called xdp_do_redi=
rect.
> >
> > > ---
> > >  drivers/net/ethernet/intel/igb/igb_main.c | 22 +++++++++++++++------=
-
> > >  1 file changed, 15 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > > b/drivers/net/ethernet/intel/igb/igb_main.c
> > > index 03f78fdb0dcd..3e0d903cf919 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > @@ -8232,7 +8232,8 @@ static inline bool igb_page_is_reserved(struct
> > page *page)
> > >         return (page_to_nid(page) !=3D numa_mem_id()) ||
> > > page_is_pfmemalloc(page);  }
> > >
> > > -static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
> > > +static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer,
> > > +
> > int
> > > +rx_buf_pgcnt)
> > >  {
> > >         unsigned int pagecnt_bias =3D rx_buffer->pagecnt_bias;
> > >         struct page *page =3D rx_buffer->page; @@ -8243,7 +8244,7 @@
> > > static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
> > >
> > >  #if (PAGE_SIZE < 8192)
> > >         /* if we are only owner of page we can reuse it */
> > > -       if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
> > > +       if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
> > >                 return false;
> > >  #else
> > I would need more info on the actual issue. If nothing else it might be=
 useful to
> > have an example where you print out the page_ref_count versus the
> > pagecnt_bias at a few points to verify exactly what is going on. As I s=
aid before
> > if the issue is the xdp_do_redirect returning an error and still consum=
ing the
> > page then the bug is elsewhere and not here.
>
>
> This patch is same as 75aab4e10ae6a4593a60f66d13de755d4e91f400
>
>
> commit 75aab4e10ae6a4593a60f66d13de755d4e91f400
> Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Date:   Tue Aug 25 19:27:34 2020 +0200
>
>     i40e: avoid premature Rx buffer reuse
>
>     The page recycle code, incorrectly, relied on that a page fragment
>     could not be freed inside xdp_do_redirect(). This assumption leads to
>     that page fragments that are used by the stack/XDP redirect can be
>     reused and overwritten.
>
>     To avoid this, store the page count prior invoking xdp_do_redirect().
>
>     Longer explanation:
>
>     Intel NICs have a recycle mechanism. The main idea is that a page is
>     split into two parts. One part is owned by the driver, one part might
>     be owned by someone else, such as the stack.
>
>     t0: Page is allocated, and put on the Rx ring
>                   +---------------
>     used by NIC ->| upper buffer
>     (rx_buffer)   +---------------
>                   | lower buffer
>                   +---------------
>       page count  =3D=3D USHRT_MAX
>       rx_buffer->pagecnt_bias =3D=3D USHRT_MAX
>
>     t1: Buffer is received, and passed to the stack (e.g.)
>                   +---------------
>                   | upper buff (skb)
>                   +---------------
>     used by NIC ->| lower buffer
>     (rx_buffer)   +---------------
>       page count  =3D=3D USHRT_MAX
>       rx_buffer->pagecnt_bias =3D=3D USHRT_MAX - 1
>     t2: Buffer is received, and redirected
>                   +---------------
>                   | upper buff (skb)
>                   +---------------
>     used by NIC ->| lower buffer
>     (rx_buffer)   +---------------
>
>     Now, prior calling xdp_do_redirect():
>       page count  =3D=3D USHRT_MAX
>       rx_buffer->pagecnt_bias =3D=3D USHRT_MAX - 2
>
>     This means that buffer *cannot* be flipped/reused, because the skb is
>     still using it.
>
>     The problem arises when xdp_do_redirect() actually frees the
>     segment. Then we get:
>       page count  =3D=3D USHRT_MAX - 1
>       rx_buffer->pagecnt_bias =3D=3D USHRT_MAX - 2
>
>     From a recycle perspective, the buffer can be flipped and reused,
>     which means that the skb data area is passed to the Rx HW ring!
>
>     To work around this, the page count is stored prior calling
>     xdp_do_redirect().
>
>     Note that this is not optimal, since the NIC could actually reuse the
>     "lower buffer" again. However, then we need to track whether
>     XDP_REDIRECT consumed the buffer or not.
>
>     Fixes: d9314c474d4f ("i40e: add support for XDP_REDIRECT")
>     Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
>     Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>     Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
>     Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>
>
> Thanks
>
> -Li

Okay, this explanation makes much more sense. Could you please either
include this explanation in your patch, or include a reference to this
patch as this explains clearly what the issue is while yours didn't
and led to the confusion as I was assuming the freeing was happening
closer to the t0 case, and really the problem is t1.

Thanks.

- Alex
