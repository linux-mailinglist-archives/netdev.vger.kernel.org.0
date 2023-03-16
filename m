Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEF66BC40A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 03:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCPCy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 22:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCPCyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 22:54:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955156589
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 19:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678935213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gdlQPC7yz/m2am6Hi3QZ8CmOMLMG1uw0u8+kdReVc7M=;
        b=JF4MfK0L7iXyLSiQpftXx1Xxg/4vl+3DpKa6QRKhLCa9c5VzJW8hDf9MVUjs2qXsr2b2QK
        VfvarzlqilvS0OuJ5mfN0jBVMy9jmMRQKMpLcEh3WRVWx13oM8vX79IhJOUfzj+mLvuPgV
        L3uyoehB97BlRUdxEuh43NS1coVlv8A=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-xXJIPXNCMyqQV8WMKWi_1Q-1; Wed, 15 Mar 2023 22:53:32 -0400
X-MC-Unique: xXJIPXNCMyqQV8WMKWi_1Q-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-17abb9d4b67so400765fac.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 19:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678935212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gdlQPC7yz/m2am6Hi3QZ8CmOMLMG1uw0u8+kdReVc7M=;
        b=KQFFaYK/y1Phq5EZDBwMCmpRhli4RlfOVXJQi6WPF77z5eP1smxiNysexTElSBQ4LZ
         iayeavzstBDtmWp8LwNIcezu06gXUnRbhJAXEeK4BEFtLcjsQPpBYwR7fOEIsN91h8SH
         oIq6281g7mr0Eyg/ZQ5757jy5euhxQGvoLXEPu0UQMstmXXvBRSG6ejADgTcy5IncXL9
         0w3HgCJjoJNaL0dGFsboG4/gzheSYai25YKSHLirSk4Icv7aGVG6N4V21106x1O79Zsn
         KPcZzoAHWtjIoDTES45y6ODyRw71puqNzONjIGfeR6KH4xKyBFHWvfQ77LZqeH2etuDT
         +1Cg==
X-Gm-Message-State: AO0yUKWGitXIYuXpz8OiZ6ACUBoevCByJkYgG+GdRbZ6iEzUStZwNPkn
        2nT4j/QHOSQUXPG+VST76mz190tfTDvdu35746mslXjfj0OaS3oa0VUKMlsN8ibMy9S6tpD0J5t
        6Gemh1OA3pAQ6UtLgkfCwt+N+JZ4CJlK7
X-Received: by 2002:a05:6870:1186:b0:177:a0bc:98a9 with SMTP id 6-20020a056870118600b00177a0bc98a9mr6699734oau.9.1678935211890;
        Wed, 15 Mar 2023 19:53:31 -0700 (PDT)
X-Google-Smtp-Source: AK7set9mpCYvaphlPTeZJOJP1a6RC9D9m33+RNA0qM1X7uQUCsLgljp0msZ/cp+9t9yokEnoSi/KsX7Dzv94vXqh9Eg=
X-Received: by 2002:a05:6870:1186:b0:177:a0bc:98a9 with SMTP id
 6-20020a056870118600b00177a0bc98a9mr6699722oau.9.1678935211629; Wed, 15 Mar
 2023 19:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-4-sgarzare@redhat.com>
 <CACGkMEs6cW7LdpCdWQnX4Pif2gGOu=f3bjNeYQ6MVcdQe=X--Q@mail.gmail.com> <1980067.5pFmK94fv0@suse>
In-Reply-To: <1980067.5pFmK94fv0@suse>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 16 Mar 2023 10:53:20 +0800
Message-ID: <CACGkMEuTrqvBs3tn8_LQo-Trn0nZdT4sDRiVNR0xt4zaoyMFEw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] vringh: replace kmap_atomic() with kmap_local_page()
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 5:12=E2=80=AFAM Fabio M. De Francesco
<fmdefrancesco@gmail.com> wrote:
>
> On marted=C3=AC 14 marzo 2023 04:56:08 CET Jason Wang wrote:
> > On Thu, Mar 2, 2023 at 7:34=E2=80=AFPM Stefano Garzarella <sgarzare@red=
hat.com>
> wrote:
> > > kmap_atomic() is deprecated in favor of kmap_local_page().
> >
> > It's better to mention the commit or code that introduces this.
> >
> > > With kmap_local_page() the mappings are per thread, CPU local, can ta=
ke
> > > page-faults, and can be called from any context (including interrupts=
).
> > > Furthermore, the tasks can be preempted and, when they are scheduled =
to
> > > run again, the kernel virtual addresses are restored and still valid.
> > >
> > > kmap_atomic() is implemented like a kmap_local_page() which also disa=
bles
> > > page-faults and preemption (the latter only for !PREEMPT_RT kernels,
> > > otherwise it only disables migration).
> > >
> > > The code within the mappings/un-mappings in getu16_iotlb() and
> > > putu16_iotlb() don't depend on the above-mentioned side effects of
> > > kmap_atomic(),
> >
> > Note we used to use spinlock to protect simulators (at least until
> > patch 7, so we probably need to re-order the patches at least) so I
> > think this is only valid when:
> >
> > The vringh IOTLB helpers are not used in atomic context (e.g spinlock,
> > interrupts).
>
> I'm probably missing some context but it looks that you are saying that
> kmap_local_page() is not suited for any use in atomic context (you are
> mentioning spinlocks).
>
> The commit message (that I know pretty well since it's the exact copy, wo=
rd by
> word, of my boiler plate commits) explains that kmap_local_page() is perf=
ectly
> usable in atomic context (including interrupts).

Thanks for the confirmation, I misread the change log and thought it
said it can't be used in interrupts.

>
> I don't know this code, however I am not able to see why these vringh IOT=
LB
> helpers cannot work if used under spinlocks. Can you please elaborate a l=
ittle
> more?

My fault, see above.

>
> > If yes, should we document this? (Or should we introduce a boolean to
> > say whether an IOTLB variant can be used in an atomic context)?
>
> Again, you'll have no problems from the use of kmap_local_page() and so y=
ou
> don't need any boolean to tell whether or not the code is running in atom=
ic
> context.
>
> Please take a look at the Highmem documentation which has been recently
> reworked and extended by me: https://docs.kernel.org/mm/highmem.html

This is really helpful.

>
> Anyway, I have been ATK 12 or 13 hours in a row. So I'm probably missing =
the
> whole picture.

It's me that misses the movitiation of kmap_local().

Thanks

>
> Thanks,
>
> Fabio
>
> > Thanks
> >
> > > so that mere replacements of the old API with the new one
> > > is all that is required (i.e., there is no need to explicitly add cal=
ls
> > > to pagefault_disable() and/or preempt_disable()).
> > >
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >
> > > Notes:
> > >     v2:
> > >     - added this patch since checkpatch.pl complained about deprecati=
on
> > >
> > >       of kmap_atomic() touched by next patch
> > >
> > >  drivers/vhost/vringh.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index a1e27da54481..0ba3ef809e48 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct v=
ringh
> > > *vrh,>
> > >         if (ret < 0)
> > >
> > >                 return ret;
> > >
> > > -       kaddr =3D kmap_atomic(iov.bv_page);
> > > +       kaddr =3D kmap_local_page(iov.bv_page);
> > >
> > >         from =3D kaddr + iov.bv_offset;
> > >         *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from))=
;
> > >
> > > -       kunmap_atomic(kaddr);
> > > +       kunmap_local(kaddr);
> > >
> > >         return 0;
> > >
> > >  }
> > >
> > > @@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct v=
ringh
> > > *vrh,>
> > >         if (ret < 0)
> > >
> > >                 return ret;
> > >
> > > -       kaddr =3D kmap_atomic(iov.bv_page);
> > > +       kaddr =3D kmap_local_page(iov.bv_page);
> > >
> > >         to =3D kaddr + iov.bv_offset;
> > >         WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> > >
> > > -       kunmap_atomic(kaddr);
> > > +       kunmap_local(kaddr);
> > >
> > >         return 0;
> > >
> > >  }
> > >
> > > --
> > > 2.39.2
>
>
>
>

