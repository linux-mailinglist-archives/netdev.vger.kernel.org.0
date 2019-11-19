Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B90100FD2
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKSAUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:20:18 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40865 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfKSAUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:20:18 -0500
Received: by mail-ed1-f65.google.com with SMTP id p59so15494665edp.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 16:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f5210yYLa9lxpLSJrZAcAm4KTwwZFDqJZGdFoygu26A=;
        b=TmTUTsFmCerMM2vYlgMtjZ6GQm0d6iG2tg+MKgCxjb2TYJ1rWmA5Qu4E740a9w/gvg
         OmqgJDuFKAvLa+oxfmgoCWSOKXDVIj3tE59j1I9G32ijFLkQLKVjvizcGFi5pFo9/SCl
         mSfpXL/YCWpFSPQx2hnUL2CPNtqWka/+7WZR0uTbgB3jDmZT+ci/g905F9L/t7ADdjN5
         MTTKRVei3OXsrgBbRVLSXXv1bSIyPsJibmaXCuHwVXU6HICJPE6YJ87UDfTRaCqfUyNI
         KLJBQ0W+FHOJc7cl2y25QSjI/Pdol27+ew3z6d9JrFoYli48SW42MwyCOUTd2WYCne++
         vqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f5210yYLa9lxpLSJrZAcAm4KTwwZFDqJZGdFoygu26A=;
        b=sHZkZ9kDlun8wtelloAbtrneUrCGaxqw7CZNozTu7Gbx7ueA0nvavw2lUIryrSH8Mg
         5I2vmBmV5/wa6LlabnuHQ6GJ2u59vQUNyi9rGQe211Nn4NvLzMGsGBXRzPLNkTmBsfHw
         WJSSqqLou/SVl0ESfAFT78QavpZwr4yZxQzH42gYI8KW5l1aqip+QpJwXlUIEM4M44KI
         n3/ZNJZXDf71KYGYGrxLKK7zPHA5FY4XvxQo/jyaG7huH2IVfzEnTAhDzsyqGPjVt1Kc
         LmO0Sjrrzs3iEYUNTsdKSKjV3TdU5l9sPmJnnq63pIQYKb6TcstEBWw/rqbySSuDSeOf
         zWkw==
X-Gm-Message-State: APjAAAWb39JjIEmA5Wu09a+YpSPzCXcsmjLi1nPHtOs8Cz+oWZv0tfDQ
        MWIk9rFhUYIbGXR+sinytqIfmN0lodV+r4r5mRviz+TQ
X-Google-Smtp-Source: APXvYqwl7kKxYBP4bFydLEuRaVgarthrBtFO7glMzJ/VeEzEm1w2P63eOu9V8IPkhTDYsG/7BWLUh+RNM4j2gnB4sGM=
X-Received: by 2002:a17:906:e297:: with SMTP id gg23mr31192460ejb.41.1574122814517;
 Mon, 18 Nov 2019 16:20:14 -0800 (PST)
MIME-Version: 1.0
References: <20191118225523.41697-1-lrizzo@google.com> <20191118151001.2f5cdcc5@cakuba.netronome.com>
In-Reply-To: <20191118151001.2f5cdcc5@cakuba.netronome.com>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Mon, 18 Nov 2019 16:20:02 -0800
Message-ID: <CAMOZA0+E0AJE3fcgtVe_NPJcSpGZHm4uFzpqH8iUHJvW4ZhnhQ@mail.gmail.com>
Subject: Re: [PATCH] net-af_xdp: use correct number of channels from ethtool
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Luigi Rizzo <rizzo@iet.unipi.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 3:10 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 18 Nov 2019 14:55:23 -0800, Luigi Rizzo wrote:
> > Drivers use different fields to report the number of channels, so take
> > the maximum of all fields (rx, tx, other, combined) when determining th=
e
> > size of the xsk map. The current code used only 'combined' which was se=
t
> > to 0 in some drivers e.g. mlx4.
> >
> > Tested: compiled and run xdpsock -q 3 -r -S on mlx4
> > Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>
> thanks, this seems mostly correct
>
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 74d84f36a5b24..8e12269428d08 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -412,6 +412,11 @@ static int xsk_load_xdp_prog(struct xsk_socket *xs=
k)
> >       return 0;
> >  }
> >
> > +static inline int max_i(int a, int b)
> > +{
> > +     return a > b ? a : b;
> > +}
>
> There's already a max in tools/lib/bpf/libbpf_internal.h, could you
> possible just use that?

Sure, will send an updated patch. Note that the compiler is actually
picking the max()
macro from tools/include/linux/kernel,h which does not lend to  nesting due=
 to
shadowing (it also requires a cast due to stricter type checking):

make: Entering directory 'upstream/tools/lib/bpf'
  CC       staticobjs/xsk.o
In file included from upstream/tools/include/uapi/linux/ethtool.h:17,
                 from xsk.c:18:
xsk.c: In function =E2=80=98xsk_get_max_queues=E2=80=99:
upstream/tools/include/linux/kernel.h:43:12: error: declaration of
=E2=80=98_max1=E2=80=99 shadows a previous local [-Werror=3Dshadow]
  typeof(x) _max1 =3D (x);   \
            ^~~~~
xsk.c:443:9: note: in expansion of macro =E2=80=98max=E2=80=99
   ret =3D max(max(channels.max_rx, channels.max_tx),

cheers
luigi
