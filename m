Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A41528A439
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388772AbgJJWyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731273AbgJJTFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:05:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602356702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJR2aQjPR9hLNkF0eFDNd9lu/f6IXZPxNCZ5aSJuSME=;
        b=c5/0YHA3XJ9ioaccuh96pU37rmqWgneAOZpTcH7YWoRY0l5a7sLs45XXoNdTib3dGsG3uq
        WU/vj0HPKxkXIQ6C7FBD//kqMjkWxikSClHfU87BrOzCBxqJUG1kPUHeIpMceozUMuUP4n
        E7ZVHQOoYjvqog68rXjYgkb2ouZfFuY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-jh3cyaJbOZKEwxle1RHQbQ-1; Sat, 10 Oct 2020 07:09:48 -0400
X-MC-Unique: jh3cyaJbOZKEwxle1RHQbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9AF4186DD26;
        Sat, 10 Oct 2020 11:09:46 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 371485D9FC;
        Sat, 10 Oct 2020 11:09:39 +0000 (UTC)
Date:   Sat, 10 Oct 2020 13:09:38 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V3 4/6] bpf: make it possible to identify BPF
 redirected SKBs
Message-ID: <20201010130938.138c80d9@carbon>
In-Reply-To: <CANP3RGesHkCNTWsWDoU2uJsFjZ4dgnEpp+F-iEmhb9U0-rcT_w@mail.gmail.com>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <160216615767.882446.7384364280837100311.stgit@firesoul>
        <40d7af61-6840-5473-79d7-ea935f6889f4@iogearbox.net>
        <CANP3RGesHkCNTWsWDoU2uJsFjZ4dgnEpp+F-iEmhb9U0-rcT_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 11:33:33 -0700
Maciej =C5=BBenczykowski <maze@google.com> wrote:

> > > This change makes it possible to identify SKBs that have been redirec=
ted
> > > by TC-BPF (cls_act). This is needed for a number of cases.
> > >
> > > (1) For collaborating with driver ifb net_devices.
> > > (2) For avoiding starting generic-XDP prog on TC ingress redirect.
> > >
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com> =20
> >
> > Not sure if anyone actually cares about ifb devices, but my worry is th=
at the
> > generic XDP vs tc interaction has been as-is for quite some time so thi=
s change
> > in behavior could break in the wild. =20

No, I believe this happened as recent at kernel v5.2, when Stephen
Hemminger changed this in commit 458bf2f224f0 ("net: core: support XDP
generic on stacked devices.").  And for the record I think that
patch/change was a mistake, as people should not use generic-XDP for
these kind of stacked devices (they should really use TC-BPF as that is
the right tool for the job).


> I'm not at all sure of the interactions/implications here.
> But I do have a request to enable ifb on Android for ingress rate
> limiting and separately we're trying to make XDP work...
> So we might at some point end up with cellular interfaces with xdp
> ebpf (redirect for forwarding/nat/tethering) + ifb + tc ebpf (for
> device local stuff).

To me I was very surprised when I discovered tc-redirect didn't work
with ifb driver.  And it sounds like you have an actual use-case for
this on Android.

> But this is still all very vague and 'ideas only' level.
> (and in general I think I'd like to get rid of the redirect in tc
> ebpf, and leave only xlat64 translation for to-the-device traffic in
> there, so maybe there's no problem anyway??)

I know it sounds strange coming from me "Mr.XDP", but I actaully think
that in many cases you will be better off with using TC-BPF.
Especially on Android, as it will be very hard to get native-XDP
implemented in all these different drivers. (And you don't want to use
generic-XDP, because there is a high chance it causes a reallocation of
the SKB, which is a huge performance hit).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

