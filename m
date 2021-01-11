Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860552F212F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbhAKUyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbhAKUyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:54:39 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D09C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 12:53:59 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id z5so1078476iob.11
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 12:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jzi+8UWRs8+BM4tJDHAE1ZIcjmIs89PyplUKD5CZZJQ=;
        b=BiGvqQo9wIXErUPCUZlKgB5V1Pakb9s1rCoIRZ/1OQXSXOW4PeGxqdtFuanHYXegKN
         Sib6QvGMRM/z0lHeHY6g1ycr3d2MkLveXyD7okVm6Zaw7lx+4UDXSShkm6Lod/7vy0HV
         UYqt+L8dD2rgvxNMhGqPrNBowor+vpBBkliovbDolXuFi/CoDAbYLawdGdZFuwJ0edK5
         291bhLJ9RlFaDL51uOu9ihOVIPGxkJr+gm489BkY3Xe5GDbg2UJfoTN4dfbxKu0tIH0t
         CPNNE55tOs85UagY5Mr+CwVt3fhJqEmHWXt4I8y1ynpv52KoaLngiBis4ntUxNNM35lV
         2OOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jzi+8UWRs8+BM4tJDHAE1ZIcjmIs89PyplUKD5CZZJQ=;
        b=CzvkK+IbpKfsfDiah+WXXM3Ji4mqtpzqdxd6Bthcaw/69hxAGw8F+YQfrcqxCRCYal
         52w8X9bpOG6WXspHs2dNZLxxmMdh6dGOWy7Ooh8jl1Tkc1kr4JQF5rJdaaZ+eS5OKQS8
         hYXf2xtF91h55VTdtUZOmdqXxfgZOL0+8gI9eNxYbBOdE9tiARRk2/hkJXuyVL+2qOpP
         GxlalT8RbOfMOsgoeRXQ4q7UfdD+YhPlzUB/zaYMczePPyZvoF274C3pbAX3Ef+i+HJE
         spRs2NzrtDq6H0hi1aFHURPj+aDYJjnwcBGbkITFbUjXVx0U8PtpHo7p5EbeEx4UbH7K
         vDlA==
X-Gm-Message-State: AOAM5313PimcuqbWDBXCv+TEd1m5ov36R+D7AxGNX6d/60NjfHVuSWe2
        81cKsmp+Uw703zvwWOvzC/aP7v+AbTo2NccRgbj9/oEQdkY=
X-Google-Smtp-Source: ABdhPJwnOk5b4D6ykoSBwRO5gqaBRbFg8RKdnNg4hGJGotw5jViL36B4DwWyVf/UGfwugU5dTD3Rv/OTB7K08cRvPNc=
X-Received: by 2002:a05:6602:152:: with SMTP id v18mr833486iot.187.1610398438359;
 Mon, 11 Jan 2021 12:53:58 -0800 (PST)
MIME-Version: 1.0
References: <1609990905-29220-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1609990905-29220-1-git-send-email-lirongqing@baidu.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jan 2021 12:53:47 -0800
Message-ID: <CAKgT0Ucar6h-V2pQK6Gx4wrwFzJqySfv-MGXtW1yEc6Jq3uNSQ@mail.gmail.com>
Subject: Re: [PATCH] igb: avoid premature Rx buffer reuse
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 7:53 PM Li RongQing <lirongqing@baidu.com> wrote:
>
> The page recycle code, incorrectly, relied on that a page fragment
> could not be freed inside xdp_do_redirect(). This assumption leads to
> that page fragments that are used by the stack/XDP redirect can be
> reused and overwritten.
>
> To avoid this, store the page count prior invoking xdp_do_redirect().
>
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

I'm not sure what you are talking about here. We allow for a 0 to 1
count difference in the pagecount bias. The idea is the driver should
be holding onto at least one reference from the driver at all times.
Are you saying that is not the case?

As far as the code itself we hold onto the page as long as our
difference does not exceed 1. So specifically if the XDP call is
freeing the page the page itself should still be valid as the
reference count shouldn't drop below 1, and in that case the driver
should be holding that one reference to the page.

When we perform our check we are performing it such at output of
either 0 if the page is freed, or 1 if the page is not freed are
acceptable for us to allow reuse. The key bit is in igb_clean_rx_irq
where we will flip the buffer for the IGB_XDP_TX | IGB_XDP_REDIR case
and just increment the pagecnt_bias indicating that the page was
dropped in the non-flipped case.

Are you perhaps seeing a function that is returning an error and still
consuming the page? If so that might explain what you are seeing.
However the bug would be in the other driver not this one. The
xdp_do_redirect function is not supposed to free the page if it
returns an error. It is supposed to leave that up to the function that
called xdp_do_redirect.

> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethe=
rnet/intel/igb/igb_main.c
> index 03f78fdb0dcd..3e0d903cf919 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8232,7 +8232,8 @@ static inline bool igb_page_is_reserved(struct page=
 *page)
>         return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemall=
oc(page);
>  }
>
> -static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
> +static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer,
> +                                                                int rx_b=
uf_pgcnt)
>  {
>         unsigned int pagecnt_bias =3D rx_buffer->pagecnt_bias;
>         struct page *page =3D rx_buffer->page;
> @@ -8243,7 +8244,7 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buf=
fer *rx_buffer)
>
>  #if (PAGE_SIZE < 8192)
>         /* if we are only owner of page we can reuse it */
> -       if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
> +       if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
>                 return false;
>  #else
>  #define IGB_LAST_OFFSET \

So the difference between page_ref_count and pagecnt_bias should be 1
or 0. The 0 would assume the page fragment was freed. What is the
value you are seeing here in the error case? My concern here is that
the pagecnt_bias may be getting incremented because IGB_XDP_CONSUMED
is being returned from igb_run_xdp instead of IGB_XDP_REDIR and so it
thinks the buffer was dropped instead of being transmitted.

> @@ -8632,11 +8633,17 @@ static unsigned int igb_rx_offset(struct igb_ring=
 *rx_ring)
>  }
>
>  static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
> -                                              const unsigned int size)
> +                                              const unsigned int size, i=
nt *rx_buf_pgcnt)
>  {
>         struct igb_rx_buffer *rx_buffer;
>
>         rx_buffer =3D &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
> +       *rx_buf_pgcnt =3D
> +#if (PAGE_SIZE < 8192)
> +               page_count(rx_buffer->page);
> +#else
> +               0;
> +#endif
>         prefetchw(rx_buffer->page);
>
>         /* we are reusing so sync this buffer for CPU use */

It should be page_ref_count used here, not page_count. Also caching
this value can be problematic since the value is supposed to be an
atomic count.

> @@ -8652,9 +8659,9 @@ static struct igb_rx_buffer *igb_get_rx_buffer(stru=
ct igb_ring *rx_ring,
>  }
>
>  static void igb_put_rx_buffer(struct igb_ring *rx_ring,
> -                             struct igb_rx_buffer *rx_buffer)
> +                             struct igb_rx_buffer *rx_buffer, int rx_buf=
_pgcnt)
>  {
> -       if (igb_can_reuse_rx_page(rx_buffer)) {
> +       if (igb_can_reuse_rx_page(rx_buffer, rx_buf_pgcnt)) {
>                 /* hand second half of page back to the ring */
>                 igb_reuse_rx_page(rx_ring, rx_buffer);
>         } else {
> @@ -8681,6 +8688,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_=
vector, const int budget)
>         u16 cleaned_count =3D igb_desc_unused(rx_ring);
>         unsigned int xdp_xmit =3D 0;
>         struct xdp_buff xdp;
> +       int rx_buf_pgcnt;
>
>         xdp.rxq =3D &rx_ring->xdp_rxq;
>
> @@ -8711,7 +8719,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_=
vector, const int budget)
>                  */
>                 dma_rmb();
>
> -               rx_buffer =3D igb_get_rx_buffer(rx_ring, size);
> +               rx_buffer =3D igb_get_rx_buffer(rx_ring, size, &rx_buf_pg=
cnt);
>
>                 /* retrieve a buffer from the ring */
>                 if (!skb) {
> @@ -8754,7 +8762,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_=
vector, const int budget)
>                         break;
>                 }
>
> -               igb_put_rx_buffer(rx_ring, rx_buffer);
> +               igb_put_rx_buffer(rx_ring, rx_buffer, rx_buf_pgcnt);
>                 cleaned_count++;
>
>                 /* fetch next buffer in frame if non-eop */

After reviewing the patch I don't see what this is solving. The
buffers should be reusable as long as the refcount is 1 or 0. We
assume with 1 that the stack/XDP is holding onto the page, and with 0
the page was freed.

I would need more info on the actual issue. If nothing else it might
be useful to have an example where you print out the page_ref_count
versus the pagecnt_bias at a few points to verify exactly what is
going on. As I said before if the issue is the xdp_do_redirect
returning an error and still consuming the page then the bug is
elsewhere and not here.
