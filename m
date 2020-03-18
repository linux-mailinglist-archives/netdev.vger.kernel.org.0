Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8E2189942
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 11:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgCRKZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 06:25:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58592 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgCRKZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 06:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584527157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wvmm8cvSX4GASnaBENip1stdZK7IgfzpSVzDAOI0z/I=;
        b=IodJzz/NH/ocb+ea89lPNML8n1Uwg1lhHmoXaiuiYTyUULyRNYFqP7jdBOv789ZyGoJH7o
        RsNl6UGAMWSF5ROwqh6A5xd34G1zOueAIJIXkipHGTWK4cFEVfGyyVOxDWDKKb1lTjwUT8
        kvSJNRABq1absIipEqwkCv9gVaonxuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-ZcQyYdRXNSK1V_NGiWQOgA-1; Wed, 18 Mar 2020 06:25:53 -0400
X-MC-Unique: ZcQyYdRXNSK1V_NGiWQOgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F131107ACCA;
        Wed, 18 Mar 2020 10:25:51 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F5085D9E2;
        Wed, 18 Mar 2020 10:25:40 +0000 (UTC)
Date:   Wed, 18 Mar 2020 11:25:39 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC v1 09/15] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
Message-ID: <20200318112539.6b595142@carbon>
In-Reply-To: <87v9n2koqt.fsf@toke.dk>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
        <158446619342.702578.1522482431365026926.stgit@firesoul>
        <87v9n2koqt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 10:15:38 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > To reviewers: Need some opinions if this is needed?
> >
> > (TODO: Squash patch)
> > ---
> >  net/core/filter.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 0ceddee0c678..669f29992177 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3432,6 +3432,12 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff =
*, xdp, int, offset)
> >  	if (unlikely(data_end < xdp->data + ETH_HLEN))
> >  		return -EINVAL;
> > =20
> > +	// XXX: To reviewers: How paranoid are we? Do we really need to
> > +	/* clear memory area on grow, as in-theory can contain uninit kmem */
> > +	if (offset > 0) {
> > +		memset(xdp->data_end, 0, offset);
> > +	} =20
>=20
> This memory will usually be recycled through page_pool or equivalent,
> right? So couldn't we clear the pages when they are first allocated?
> That way, the only data that would be left there would be packet data
> from previous packets...

Yes, that is another option, to clear pages on "real" alloc (not
recycle alloc), but it is a bit harder to implement (when not using
page_pool).

And yes, this area will very likely just contain old packet data, but
we cannot be 100% sure.

Previously Alexei have argued that we should not leak pointer values in
XDP.  Which is why we have xdp_scrub_frame(), but this is not 100% the
same.  So, I would like to hear Alexei's opinion ?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

