Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092AFFAE18
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfKMKIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:08:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27190 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbfKMKIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 05:08:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573639714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5iAiTWoEzg4GUYQkCWobgITk/EP9oPO6a/TdmjXL2s=;
        b=FZs6ByKyC0G6ZYZCnLLJ/ULnrfoK2kecn5RqyazfaNaAHUaGkJXNni32iLnheD2VIWWTJa
        Q1aLrbm8RrZBrBNbpzPnU+sWxy/8epjUCjHpWn0dJLtpZjA2ThDBBnE38E+whwgLHQ1EwZ
        GHxOFdXUxP/iX8B8UO8M/rqsCTvXZDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-A4oNBqg6O8-xit-10lwqxw-1; Wed, 13 Nov 2019 05:08:31 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E3FD107ACC6;
        Wed, 13 Nov 2019 10:08:30 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 454D95DF3A;
        Wed, 13 Nov 2019 10:08:25 +0000 (UTC)
Date:   Wed, 13 Nov 2019 11:08:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Alexei Starovoitov" <ast@fb.com>, netdev@vger.kernel.org,
        davem@davemloft.net, "Kernel Team" <Kernel-team@fb.com>,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191113110823.0e1186a5@carbon>
In-Reply-To: <04EECB84-2958-4D59-BE2D-FD7ABD8E4C05@gmail.com>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
        <20191112130832.6b3d69d5@carbon>
        <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
        <20191112174822.4b635e56@carbon>
        <e4aa8923-7c81-a215-345c-a2127862048f@fb.com>
        <04EECB84-2958-4D59-BE2D-FD7ABD8E4C05@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: A4oNBqg6O8-xit-10lwqxw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 09:32:10 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> On 12 Nov 2019, at 9:23, Alexei Starovoitov wrote:
>=20
> > On 11/12/19 8:48 AM, Jesper Dangaard Brouer wrote: =20
> >>> The trace_page_pool_state_release() does not dereference pool, it=20
> >>> just
> >>> reports the pointer value, so there shouldn't be any use-after-free. =
=20
> >> In the tracepoint we can still dereference the pool object pointer.
> >> This is made easier via using bpftrace for example see[1] (and with=20
> >> BTF
> >> this will become more common to do so). =20
> >
> > bpf tracing progs cannot assume that the pointer is valid.
> > The program can remember a kernel pointer in a map and then
> > access it days later.
> > Like kretprobe on kfree_skb(). The skb is freed. 100% use-after-free.
> > Such bpf program is broken and won't be reading meaningful values,
> > but it won't crash the kernel.
> >
> > On the other side we should not be passing pointers to freed objects
> > into tracepoints. That just wrong.
> > May be simply move that questionable tracepoint? =20
>=20
> Yes, move and simplify it.  I believe this patch should resolve the=20
> issue, it just reports pages entering/exiting the pool, without
> trying to access the counters - the counters are reported through the
> inflight tracepoint.

Sorry, I don't like loosing the counter.  I have a plan for using these
counters in a bpftrace script.  (Worst case I might be able to live
without the counters). =20

The basic idea is to use these tracepoints to detect if we leak
DMA-mappings. I'll try write the bpftrace script today, and
see it I can live without the counter.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

