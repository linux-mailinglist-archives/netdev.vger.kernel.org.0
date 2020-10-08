Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5AC2875A1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgJHOHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730175AbgJHOHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602166038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m76EiLpJczY/Spx19zifeumYiG1JLiXHloolEGCRC8M=;
        b=D7PpjRU0wW1AcGbLVwbuUr7c5l6/5VZm9+eDDa5tWv/m+fvCmxAk3XCRG2Ykj1u8J+U2rh
        40z7ONtofKcn5yGWePu+OizOUh7B1oomJc3+8s3hGn9YuOuPLu5R9BQUGOhUnKW/+fhf4Z
        6cd1hLu10c2Q2jkd7krYZ1tAc4zbdVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-eeS_Q0MKNzOUg0PtA1guAQ-1; Thu, 08 Oct 2020 10:07:14 -0400
X-MC-Unique: eeS_Q0MKNzOUg0PtA1guAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F377186DD25;
        Thu,  8 Oct 2020 14:07:12 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 943A85D9D5;
        Thu,  8 Oct 2020 14:07:05 +0000 (UTC)
Date:   Thu, 8 Oct 2020 16:07:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 1/6] bpf: Remove MTU check in
 __bpf_skb_max_len
Message-ID: <20201008160704.1da26095@carbon>
In-Reply-To: <CA+FuTSfXt3_OZD3DoO46ndkBs6y7FCQk3QwaeLkh0QYyLhLhZA@mail.gmail.com>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
        <160208776033.798237.4028465222836713720.stgit@firesoul>
        <CANP3RGeU4sMjgAjXHVRc0ES9as0tG2kBUw6jRZhz6vLTTtVEVA@mail.gmail.com>
        <20201008130632.0c407bad@carbon>
        <CA+FuTSfXt3_OZD3DoO46ndkBs6y7FCQk3QwaeLkh0QYyLhLhZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 08:33:04 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Thu, Oct 8, 2020 at 7:06 AM Jesper Dangaard Brouer <brouer@redhat.com>=
 wrote:
> >
> > On Wed, 7 Oct 2020 16:46:10 -0700
> > Maciej =C5=BBenczykowski <maze@google.com> wrote:
> > =20
> > > >  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> > > >  {
> > > > -       return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len=
 :
> > > > -                         SKB_MAX_ALLOC;
> > > > +       return IP_MAX_MTU;
> > > >  } =20
> > >
> > > Shouldn't we just delete this helper instead and replace call sites? =
=20
> >
> > It does seem wrong to pass argument skb into this function, as it is
> > no-longer used...
> >
> > Guess I can simply replace __bpf_skb_max_len with IP_MAX_MTU. =20
>=20
> Should that be IP6_MAX_MTU, which is larger than IP_MAX_MTU?

Sure I'll do that, and handle that is hides under CONFIG_IPV6.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

