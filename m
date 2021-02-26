Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0D326415
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBZOaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhBZOaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614349722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CI99ojpt3AIcHxhJSfpmSYXWrv9pfYKDI8VwEn51Ixc=;
        b=IhDBGn2IK/DReA3xsUzfBYAC7LMw2QBYG/gdUQ02ij08fr2jqbGEotADuTIcIkiusVJfQu
        yhz1Nmt2rxtOhSr3adK4QHx5lV2HwxMF7XjYPiFOdMuG4EduiYO/Kh/zlNZEyNGBwhoHg7
        9ICdRd8HHRCgNHrCHb7cupo7hDXXd74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-uK4vxZIIMxSXst_JJTcN9A-1; Fri, 26 Feb 2021 09:28:39 -0500
X-MC-Unique: uK4vxZIIMxSXst_JJTcN9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DEC0100CCC1;
        Fri, 26 Feb 2021 14:28:37 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B187E12D7E;
        Fri, 26 Feb 2021 14:28:30 +0000 (UTC)
Date:   Fri, 26 Feb 2021 15:28:27 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
Message-ID: <20210226152827.6458324b@carbon>
In-Reply-To: <87h7lzypzl.fsf@toke.dk>
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
        <20210226112322.144927-2-bjorn.topel@gmail.com>
        <87sg5jys8r.fsf@toke.dk>
        <694101a1-c8e2-538c-fdd5-c23f8e2605bb@intel.com>
        <d4910425-82ae-b1ce-68c3-fb5542f598a5@intel.com>
        <87h7lzypzl.fsf@toke.dk>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 13:26:22 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
>=20
> > On 2021-02-26 12:40, Bj=C3=B6rn T=C3=B6pel wrote: =20
> >> On 2021-02-26 12:37, Toke H=C3=B8iland-J=C3=B8rgensen wrote: =20
> >
> > [...]
> > =20
> >>>
> >>> (That last paragraph above is why I asked if you updated the performa=
nce
> >>> numbers in the cover letter; removing an additional function call sho=
uld
> >>> affect those, right?)
> >>> =20
> >>=20
> >> Yeah, it should. Let me spend some more time benchmarking on the DEVMAP
> >> scenario.
> >> =20
> >
> > I did a re-measure using samples/xdp_redirect_map.
> >
> > The setup is 64B packets blasted to an i40e. As a baseline,
> >
> >    # xdp_rxq_info --dev ens801f1 --action XDP_DROP
> >
> > gives 24.8 Mpps.
> >
> >
> > Now, xdp_redirect_map. Same NIC, two ports, receive from port A,
> > redirect to port B:
> >
> > baseline:    14.3 Mpps
> > this series: 15.4 Mpps
> >
> > which is almost 8%! =20
>=20
> Or 5 ns difference:
>=20
> 10**9/(14.3*10**6) - 10**9/(15.4*10**6)
> 4.995004995005004
>=20
> Nice :)

Yes, this is a very significant improvement at this zoom-in
benchmarking level :-)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

