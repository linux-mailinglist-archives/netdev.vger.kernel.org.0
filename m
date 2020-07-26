Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4521F22DC37
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 07:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGZFfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 01:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGZFfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 01:35:24 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01831C0619D2;
        Sat, 25 Jul 2020 22:35:24 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so10457481iln.1;
        Sat, 25 Jul 2020 22:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x1bARMh5GgpfdkzzJHqPV/cESh0NbR22EC4SzVKdkYw=;
        b=p6kSFEZYt44mpd6mt6sRfe1gbGQm+sb7NNXOGEEVW10+D6qbBWsQQ6rBnbKYaVsXKP
         C5r0Rwy0vj1kBkkeWZ9dIiXIgsZg2Ic5Ro7ojiN2qGj3nFkDTmwlEsA3D/II4kPHSYzZ
         4TgcpSJgRCVSynfB1+FO6NHRsvJLbqMA2k2QOV1Q2oAhCfFeTVLXbSh3m7tOVZHNFen5
         S3VQWtI6A+7N/gUfCmWiBfD4eL72fh9ZB1xDejmbIezHBKGlq//JTJYjSUCtBxpBrLot
         jbikCZOCwtKPswMwG6QpMb7yDOFmxhuzT2+dswy893jMoLbzhDOsdsI4GFSpdf5uYDIg
         edcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x1bARMh5GgpfdkzzJHqPV/cESh0NbR22EC4SzVKdkYw=;
        b=G1xu+UUze0iesx/hoM5pCwVjYalGEIuI1CMf5Ps/HNuT8SBJGieJhe+cH+gZ3b5MRn
         W+Tcd9p05wCMNGRJwN1p6cxBYI/NNsOA84fvh1oerQHiMRGCq4fmYCc7tkqXnWXZCz5S
         n0plf4RFQhUCEPkjVqH3sWPZDBlzlTarriZwU67nYPjylTc7nlIvWu9Stf0biNa7cRyJ
         BYxiZVoSS9VdXWIWVtTxp1wbAPw/svkaDocOwXi5XRc/VYHrpKXVVW7QVgba1ViCg878
         J+w2tYgxYEfJtvD7MOpvmQAglBfUD9W9M2Q+mnrUlqX73WrcrWBgUNyt/Lmefoam0xHY
         4Jsw==
X-Gm-Message-State: AOAM533JE5EMa2yFaAENkSAIDh56T164H8CMgauSJEs7iO3qdM251cIN
        btQnKEUtW5KbZ5GMWaz/LzkpVrpxbpX0DZwke1c=
X-Google-Smtp-Source: ABdhPJz0GntQMpIOmrj4GRVMLIZcTc3W7DE9ss2ffHETJ+m2psB6WMCmh23STzGSMAgSFeZ48bxWY3UKFovKuCJpomo=
X-Received: by 2002:a05:6e02:788:: with SMTP id q8mr9248511ils.22.1595741723422;
 Sat, 25 Jul 2020 22:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu>
In-Reply-To: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 25 Jul 2020 22:35:12 -0700
Message-ID: <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv6: fix use-after-free Read in __xfrm6_tunnel_spi_lookup
To:     B K Karthik <bkkarthik@pesu.pes.edu>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 8:09 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> @@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, u32 spi)
>  {
>         struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
>         struct xfrm6_tunnel_spi *x6spi;
> -       int index = xfrm6_tunnel_spi_hash_byspi(spi);
> +       int index = xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);
>
>         hlist_for_each_entry(x6spi,
> -                            &xfrm6_tn->spi_byspi[index],
> +                            &xfrm6_tn->spi_byaddr[index],
>                              list_byspi) {
>                 if (x6spi->spi == spi)

How did you convince yourself this is correct? This lookup is still
using spi. :)

More importantly, can you explain how UAF happens? Apparently
the syzbot stack traces you quote make no sense at all. I also
looked at other similar reports, none of them makes sense to me.

Thanks.
