Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76415BD996
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiITBpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiITBpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05192A410
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663638297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ELfVyTN4OqssHSEDiBdzMOAWCcUzIKVUfNeUrw/1VCA=;
        b=LvdTEvwui4jb76h3M/swLxyXL3EEtnRbMgQa6gu9lB+nS9txtryW/T2uoNoGzskUOdbMHi
        anqGuFmYNTXmdjjPO51R0Y1xzjeuMJF12P9ecgFcfwHVpiD6UhgUkN5ZE51D4mX+GVKEYU
        DKHUtqG18H0e55I3yN9QDKf4IAX2AD8=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-KDDie7OPN6atmAFMoAoIeQ-1; Mon, 19 Sep 2022 21:44:56 -0400
X-MC-Unique: KDDie7OPN6atmAFMoAoIeQ-1
Received: by mail-vk1-f200.google.com with SMTP id z5-20020a056122148500b003a2e0028d97so302392vkp.22
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ELfVyTN4OqssHSEDiBdzMOAWCcUzIKVUfNeUrw/1VCA=;
        b=zMwLoWTOLv/EsQOfpXONMgr4DXpndoeNhry/JGQUzAYIbMchhpzFxu2TRkIbhrCygf
         3/aaLloKASC50Yn+uPDV5LlMN7bAyoRhe1QflGtQMNcl8vXY0DgB0LTgOUJofLJMa2c/
         H1ctvDYZToQQWaH7OXmJisXLGsy1AKpcz+zVCYlm0rzoCziZPGoFUvk28RpaOXVzJVt2
         Qzzlsdz/KSeNjCrIDj5lPHHALak2WpTwtYFUXtLn2kkbBlAi0twp8xfGF48oZbSbPTfX
         AKdw4xmNXXW9azwD+0YjZdguSKSF2/3YTvOWfOiqkYBY82ekAZ0yHpLpssMvkArIvL/Z
         j9UQ==
X-Gm-Message-State: ACrzQf2eRcHm8JNYuYsewyxS3p/tGgQdTtgRSxubhp856oqsQjE/IatS
        CyGSxRyxfkXdOe7LAexHAcbvFW1LD1DIi0R2sYeuyjTe0SiQOukx4yV/DVUFHoqdBx4Uvkg9Ked
        ZDqTcGzGYvnA9L/wc1+x+d9buG9ZPafas
X-Received: by 2002:a1f:9cc5:0:b0:3a2:bd20:8fc6 with SMTP id f188-20020a1f9cc5000000b003a2bd208fc6mr7094321vke.22.1663638296202;
        Mon, 19 Sep 2022 18:44:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4OnO+KKuSj60RCAhZrF9oBkx2x/cbhHybJ8Nn5Q6Z8hrLtD4OcS03JgBKk+IxhnVwyUh3I+uAvCWROUyCc6m8=
X-Received: by 2002:a1f:9cc5:0:b0:3a2:bd20:8fc6 with SMTP id
 f188-20020a1f9cc5000000b003a2bd208fc6mr7094317vke.22.1663638296016; Mon, 19
 Sep 2022 18:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220916234552.3388360-1-prohr@google.com> <20220919101802.4f4d1a86@hermes.local>
 <CANP3RGdMEJMDcB8X_YD-PM7X6pqypvSn7_q4x=B8rzLd+CAqXA@mail.gmail.com>
In-Reply-To: <CANP3RGdMEJMDcB8X_YD-PM7X6pqypvSn7_q4x=B8rzLd+CAqXA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Sep 2022 09:44:45 +0800
Message-ID: <CACGkMEu6zBeduw9F==NWhz01FphYjkhT0Qmp+06vq6=kCx+bvA@mail.gmail.com>
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Patrick Rohr <prohr@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 8:01 AM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> On Mon, Sep 19, 2022 at 10:18 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> > On Fri, 16 Sep 2022 16:45:52 -0700
> > Patrick Rohr <prohr@google.com> wrote:
> > >  #define IFF_DETACH_QUEUE 0x0400
> > > +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> > > +#define IFF_NO_CARRIER IFF_DETACH_QUEUE
> >
> > Overloading a flag in existing user API is likely to break
> > some application somewhere...
>
> We could of course burn a bit (0x0040 and 0x0080 are both currently
> utterly unused)... but that just seemed wasteful...
> Do you think that would be better?
>
> I find it exceedingly unlikely that any application is specifying this
> flag to TUNSETIFF currently.
>
> This flag has barely any hits in the code base, indeed ignoring the
> Documentation, tests, and #define's we have:
>
> $ git grep IFF_DETACH_QUEUE
> drivers/net/tap.c:928:  else if (flags & IFF_DETACH_QUEUE)
> drivers/net/tun.c:2954: } else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
> drivers/net/tun.c:3115:                 ifr.ifr_flags |=3D IFF_DETACH_QUE=
UE;
>
> The first two implement ioctl(TUNSETQUEUE) -- that's the only spot
> where IFF_DETACH_QUEUE is currently supposed to be used.
>
> The third one is the most interesting, see drivers/net/tun.c:3111
>
>  case TUNGETIFF:
>          tun_get_iff(tun, &ifr);
>          if (tfile->detached)
>                  ifr.ifr_flags |=3D IFF_DETACH_QUEUE;
>          if (!tfile->socket.sk->sk_filter)
>                  ifr.ifr_flags |=3D IFF_NOFILTER;
>
> This means TUNGETIFF can return this flag for a detached queue.  However:
>
> (a) multiqueue tun/tap is pretty niche, and detached queues are even more=
 niche.
>
> (b) the TUNGETIFF returned ifr_flags field already cannot be safely
> used as input to TUNSETIFF,

Yes, but it could be used by userspace to recover the multiqueue state
via TUNSETQUEUE for a feature like checkpoint.

> because IFF_NOFILTER =3D=3D IFF_NO_PI =3D=3D
> 0x1000
>
> (this overlap of IFF_NO_PI and IFF_NOFILTER is why we thought it'd be
> ok to overlap here as well)
>
> (c) if this actually turns out to be a problem it shouldn't be that
> hard to fix the 1 or 2 userspace programs to mask out the flag
> and not pass in garbage... Do we really want / need to maintain
> compatibility with extremely badly written userspace?

Not sure, but instead of trying to answer this hard question, having a
new flag seems to be easier.

> It's really hard to even imagine how such code would come into existence.=
..
>
> Arguably the TUNSETIFF api should have always returned an error for
> invalid flags... should we make that change now?

Probably too late to do that.

Thanks

>

