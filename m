Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F422414B580
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 14:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1N5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 08:57:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgA1N5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 08:57:54 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 874C92173E;
        Tue, 28 Jan 2020 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219874;
        bh=HL0lcgWOM+5WXYJru6CbR/OifIZqGLRnlFp5NoYOE0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pNLx6pOuQC2ktMsIQYcTCmiHpW8l7UgnqiieM1LOFJ5O8+JydIVc0Nxf2117gLrUo
         W5CxIEJ+n2rjflPIIHvBXvRMdvNgu7kMGnqpfVfeGzYAGqtOCa+bE8LH80NleR63h3
         i1/xXp+x+nnxbdZkz6f9YugaHLepy55j2p0kEPq8=
Date:   Tue, 28 Jan 2020 05:57:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200128055752.617aebc7@cakuba>
In-Reply-To: <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
        <20200127061623.1cf42cd0@cakuba>
        <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 20:43:09 -0700, David Ahern wrote:
> > end of whatever is doing the redirect (especially with Alexei's work  =
=20
>=20
> There are use cases where they may make sense, but this is not one.
>=20
> > on linking) and from cls_bpf =F0=9F=A4=B7=E2=80=8D=E2=99=82=EF=B8=8F
>=20
> cls_bpf is tc based =3D=3D skb, no? I want to handle any packet, regardle=
ss
> of how it arrived at the device's xmit function.

Yes, that's why I said you need the same rules in XDP before REDIRECT
and cls_bpf. Sure it's more complex, but (1) it's faster to drop in
the ingress prog before going though the entire redirect code and
without parsing the packet twice and (2) no extra kernel code necessary.

Even the VM "offload" work doesn't need this. Translating an XDP prog
into a cls_bpf one should be trivial. Slap on some prologue to linearize
the skb, move ctx offsets around, slap on an epilogue to convert exit
codes, anything else?

I'm weary of partially implemented XDP features, EGRESS prog does us=20
no good when most drivers didn't yet catch up with the REDIRECTs. And
we're adding this before we considered the queuing problem.

But if I'm alone in thinking this, and I'm not convincing anyone we can
move on :)
