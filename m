Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8282D1125
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgLGM4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:56:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbgLGM4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607345690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/UDXawBbiAwmcYELjEA0HOu1lNMEHhASoAQYhol/lw=;
        b=aFUmM6wNL7gUeBnQGB3H7F0fIiSM1x0nocGDCp05tGenvEjdqKM05N5Sq/b4Y/ogqnhzJH
        b18SihJ37Ta/roCKr1z4Kh3LL5zMJ/53Lys+ZD9LepuuMkCCh7c5ArreiEex5PD0FefVcE
        d3c5p4katiraerR745cJ7ZD1qCYtiLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-bTM0Fr_nPyaSkXpTLdjtFw-1; Mon, 07 Dec 2020 07:54:46 -0500
X-MC-Unique: bTM0Fr_nPyaSkXpTLdjtFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 241A1100C60A;
        Mon,  7 Dec 2020 12:54:44 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9445A5D6AB;
        Mon,  7 Dec 2020 12:54:36 +0000 (UTC)
Date:   Mon, 7 Dec 2020 13:54:33 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20201207135433.41172202@carbon>
In-Reply-To: <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <20201204102901.109709-2-marekx.majtyka@intel.com>
        <878sad933c.fsf@toke.dk>
        <20201204124618.GA23696@ranger.igk.intel.com>
        <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 16:21:08 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 12/4/20 1:46 PM, Maciej Fijalkowski wrote:
> > On Fri, Dec 04, 2020 at 01:18:31PM +0100, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote: =20
> >> alardam@gmail.com writes: =20
> >>> From: Marek Majtyka <marekx.majtyka@intel.com>
> >>>
> >>> Implement support for checking what kind of xdp functionality a netdev
> >>> supports. Previously, there was no way to do this other than to try
> >>> to create an AF_XDP socket on the interface or load an XDP program an=
d see
> >>> if it worked. This commit changes this by adding a new variable which
> >>> describes all xdp supported functions on pretty detailed level: =20
> >>
> >> I like the direction this is going! :)

(Me too, don't get discouraged by our nitpicking, keep working on this! :-))

> >> =20
> >>>   - aborted
> >>>   - drop
> >>>   - pass
> >>>   - tx =20
>=20
> I strongly think we should _not_ merge any native XDP driver patchset
> that does not support/implement the above return codes.=20

I agree, with above statement.

> Could we instead group them together and call this something like
> XDP_BASE functionality to not give a wrong impression?

I disagree.  I can accept that XDP_BASE include aborted+drop+pass.

I think we need to keep XDP_TX action separate, because I think that
there are use-cases where the we want to disable XDP_TX due to end-user
policy or hardware limitations.

Use-case(1): Cloud-provider want to give customers (running VMs) ability
to load XDP program for DDoS protection (only), but don't want to allow
customer to use XDP_TX (that can implement LB or cheat their VM
isolation policy).

Use-case(2): Disable XDP_TX on a driver to save hardware TX-queue
resources, as the use-case is only DDoS.  Today we have this problem
with the ixgbe hardware, that cannot load XDP programs on systems with
more than 192 CPUs.


> If this is properly documented that these are basic must-have
> _requirements_, then users and driver developers both know what the
> expectations are.

We can still document that XDP_TX is a must-have requirement, when a
driver implements XDP.


> >>>   - redirect =20
> >>


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

