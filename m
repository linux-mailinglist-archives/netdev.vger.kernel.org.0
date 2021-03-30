Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A794634EF4A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhC3RWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhC3RVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:21:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAF92619D1;
        Tue, 30 Mar 2021 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617124914;
        bh=nSaGH7C9DUjUEnfkusf81FHqtFMRbAkQ/UgYZAa6Ppo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j0a38Q2k1qEt78uJy13CZJDOL0woTB+7TTJqOJ6soPlTMPruKK/fojdsqAvfGc0vA
         nfKhsQ7EKtE+WU+eBxG9qu/zi2ZGOGeOKXF8xISl1QJQnJ2a/z44dnPSeAWYMdGU/8
         PSAoJKK5+VrShSPMwJsLOS3IpC8OsGx/wdSqev1gjVvNM3Qf5eM0Zar0Ck/2CeIRyF
         tRQPb2NkZZ8Fk9kSJjJrJSqHY98+EazrEnATpIt/WwJl1iesHdAsCJ4PmyT39ynONC
         rmSkyKrADZbZNi2m2ZfZnQtLD9qcjoRDeY7bXKtWvyxDsXROFfnu11Mt62J0WyXR61
         35uYb0atbVw/Q==
Received: by mail-wr1-f52.google.com with SMTP id j7so17028096wrd.1;
        Tue, 30 Mar 2021 10:21:53 -0700 (PDT)
X-Gm-Message-State: AOAM533ufFS91Go2iHboFrtdwmOlFg7CWol345WjnddNP6wvUEQORpxB
        XIzYQtZIeOthfPAcssVT1uvzlqeUjN+N74zhBSQ=
X-Google-Smtp-Source: ABdhPJwn4UhqepnyMOcLeTKmfHMiYbPExjGA1cUOw+nU37Rv5ms4Cueb/m7qtnZJAE4aNKmjKbFqK+bD6XPdrbqlX60=
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr7671314wrx.52.1617124912552;
 Tue, 30 Mar 2021 10:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210330113419.4616-1-ciara.loftus@intel.com> <20210330113419.4616-3-ciara.loftus@intel.com>
 <CAADnVQ+jr2WG4FF3GoPt==tOkOb72bd7Zhkk5iy4omCJ3=qLJQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+jr2WG4FF3GoPt==tOkOb72bd7Zhkk5iy4omCJ3=qLJQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Date:   Tue, 30 Mar 2021 19:21:41 +0200
X-Gmail-Original-Message-ID: <CAJ+HfNh_brhM5C1jModyUPibps2ouPcfGfYscavoqBFCLmWj7Q@mail.gmail.com>
Message-ID: <CAJ+HfNh_brhM5C1jModyUPibps2ouPcfGfYscavoqBFCLmWj7Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf 2/3] libbpf: restore umem state after socket create failure
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Ciara Loftus <ciara.loftus@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Mar 2021 at 17:08, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 30, 2021 at 5:06 AM Ciara Loftus <ciara.loftus@intel.com> wro=
te:
> >

[...]

> >         if (--ctx->refcount =3D=3D 0) {
> > -               err =3D xsk_get_mmap_offsets(umem->fd, &off);
> > -               if (!err) {
> > -                       munmap(ctx->fill->ring - off.fr.desc,
> > -                              off.fr.desc + umem->config.fill_size *
> > -                              sizeof(__u64));
> > -                       munmap(ctx->comp->ring - off.cr.desc,
> > -                              off.cr.desc + umem->config.comp_size *
> > -                              sizeof(__u64));
> > +               if (unmap) {
> > +                       err =3D xsk_get_mmap_offsets(umem->fd, &off);
> > +                       if (!err) {
> > +                               munmap(ctx->fill->ring - off.fr.desc,
> > +                                      off.fr.desc + umem->config.fill_=
size *
> > +                               sizeof(__u64));
> > +                               munmap(ctx->comp->ring - off.cr.desc,
> > +                                      off.cr.desc + umem->config.comp_=
size *
> > +                               sizeof(__u64));
> > +                       }
>
> The whole function increases indent, since it changes anyway
> could you write it as:
> {
> if (--ctx->refcount)
>   return;
> if (!unmap)
>   goto out_free;
> err =3D xsk_get
> if (err)
>  goto out_free;
> munmap();
> out_free:
> list_del
> free
> }
>

Yes, please try to reduce the nesting, and while at it try to expand
the as much as possible of the munmap arguments to the full 100 chars.


Bj=C3=B6rn
