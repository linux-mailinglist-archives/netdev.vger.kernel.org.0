Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE43928B1BA
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgJLJlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:41:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgJLJls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602495707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXG7a4scq98B/dcQv1Tv8obxT4AXo5Cn9drh+K4TB8w=;
        b=IJudUdIsmnv1Kfe0/eIFVaE9iuagfSI4RIGzu7Lo/gZbAv6Xs2gAyVjuOtl/hl2h8sP5G0
        d+dCB1NkgnYjpQOfQX9RXgK1UlR8hEynKCAuRRlD1QfVSwRmt9ok6m3cFK0aAIO3cT8t2b
        7EaX2v3esUKtWv/UOrcmyXoRfKzTm3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-HWxQc-35M7mW9lzoqNnSLA-1; Mon, 12 Oct 2020 05:41:45 -0400
X-MC-Unique: HWxQc-35M7mW9lzoqNnSLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BFD310054FF;
        Mon, 12 Oct 2020 09:41:44 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA71B76666;
        Mon, 12 Oct 2020 09:41:32 +0000 (UTC)
Date:   Mon, 12 Oct 2020 11:41:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        john.fastabend@gmail.com, yhs@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com, Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH bpf-next v6 2/6] bpf: add redirect_peer helper
Message-ID: <20201012114130.6f57247f@carbon>
In-Reply-To: <1992820b-4916-ed42-e1e2-8e37ae67c92f@gmail.com>
References: <20201010234006.7075-1-daniel@iogearbox.net>
        <20201010234006.7075-3-daniel@iogearbox.net>
        <20201011112213.7e542de7@carbon>
        <aadbb662-bb42-05be-0943-d59ba0d3f60c@iogearbox.net>
        <1992820b-4916-ed42-e1e2-8e37ae67c92f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 20:50:12 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 10/11/20 10:16 AM, Daniel Borkmann wrote:
> >>
> >> This is awesome results and great work Daniel! :-) =20
>=20
> +1
>=20
> >>
> >> I wonder if we can also support this from XDP, which can also native
> >> redirect into veth.=C2=A0 Originally I though we could add the peer ne=
tdev
> >> in the devmap, but AFAIK Toke showed me that this was not possible. =20
> >=20
> > I think it should be possible with similar principle. What was the
> > limitation that you ran into with devmap for XDP? =20

If you add a device to devmap and afterwards move this device into a
namespace, then the device is removed from the devmap.  This is because
devmap detect/react on NETDEV_UNREGISTER and remove the net_device.


> Should just need an API to set the namespace of the redirect device -
> something that devmap can be extended to include now.

Perhaps for other devices being moved into a namespace.

Specifically for veth the XDP redirect (veth_ndo_xdp_xmit) already
pickup the peer net_device, and *queue* the xdp_frame, thus it's not
directly relevant for the XDP redirect (except we also have an
intermediate queue which is likely bad for the TCP_RR test).

I just tried to test native-XDP redirect into a veth with samples/bpf/
xdp_redirect_map, which doesn't work.  Packets are actually getting
silently dropped.  After digging into the kernel code, I realized this
is because the *peer*-veth device didn't have a XDP-prog loaded.  The
xdp_redirect_map loads a dummy-XDP prog on the veth-device (it can
see), as a way to enable the ndo_xdp_xmit (which we have discussed
before it a broken way to do this, but it have become a defacto way).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

