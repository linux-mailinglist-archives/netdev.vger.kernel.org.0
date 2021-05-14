Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C46938039B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhENGXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:23:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhENGX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 02:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620973337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o3zquQoJDCMBHzy4G0po+Q90LPtlWKQmqRIwtyCFBzE=;
        b=dBBoR7mrTC9uYNLefplApiAF78faewn6fOFc8hJ1+vi/NYEnC+9pWT6rDkBqWNJGC1C+g+
        YyZpEnJb9q1g43d7uXvve6e6dtWIC7P3nRKZE+gyC6GN0JBleWsv1P1KWEfmUJ1YwnHM1K
        YXgu9zDgM9yBUVcAqatUmTBB4jDru6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-PJwC89gKNgyPW47yyHrA7A-1; Fri, 14 May 2021 02:22:14 -0400
X-MC-Unique: PJwC89gKNgyPW47yyHrA7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24962FC9C;
        Fri, 14 May 2021 06:22:12 +0000 (UTC)
Received: from carbon (unknown [10.36.110.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3478E5D6AC;
        Fri, 14 May 2021 06:21:57 +0000 (UTC)
Date:   Fri, 14 May 2021 08:21:56 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, brouer@redhat.com
Subject: Re: [PATCH RESEND v11 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210514082156.098a0e92@carbon>
In-Reply-To: <609d858c171bf_634432084c@john-XPS-13-9370.notmuch>
References: <20210513070447.1878448-1-liuhangbin@gmail.com>
        <20210513070447.1878448-3-liuhangbin@gmail.com>
        <609d858c171bf_634432084c@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 13:01:16 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Hangbin Liu wrote:
> > This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> > extend xdp_redirect_map for broadcast support.
> >=20
> > With BPF_F_BROADCAST the packet will be broadcasted to all the interfac=
es
> > in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
> > excluded when do broadcasting.
> >=20
> > When getting the devices in dev hash map via dev_map_hash_get_next_key(=
),
> > there is a possibility that we fall back to the first key when a device
> > was removed. This will duplicate packets on some interfaces. So just wa=
lk
> > the whole buckets to avoid this issue. For dev array map, we also walk =
the
> > whole map to find valid interfaces.
> >=20
> > Function bpf_clear_redirect_map() was removed in
> > commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
> > Add it back as we need to use ri->map again.
> >=20
> > With test topology:
> >   +-------------------+             +-------------------+
> >   | Host A (i40e 10G) |  ---------- | eno1(i40e 10G)    |
> >   +-------------------+             |                   |
> >                                     |   Host B          |
> >   +-------------------+             |                   |
> >   | Host C (i40e 10G) |  ---------- | eno2(i40e 10G)    |
> >   +-------------------+             |                   |
> >                                     |          +------+ |
> >                                     | veth0 -- | Peer | |
> >                                     | veth1 -- |      | |
> >                                     | veth2 -- |  NS  | |
> >                                     |          +------+ |
> >                                     +-------------------+
> >=20
> > On Host A:
> >  # pktgen/pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $d=
st_mac -s 64
> >=20
> > On Host B(Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz, 128G Memory):
> > Use xdp_redirect_map and xdp_redirect_map_multi in samples/bpf for test=
ing.
> > All the veth peers in the NS have a XDP_DROP program loaded. The
> > forward_map max_entries in xdp_redirect_map_multi is modify to 4.
> >=20
> > Testing the performance impact on the regular xdp_redirect path with and
> > without patch (to check impact of additional check for broadcast mode):
> >=20
> > 5.12 rc4         | redirect_map        i40e->i40e      |    2.0M |  9.7M
> > 5.12 rc4         | redirect_map        i40e->veth      |    1.7M | 11.8M
> > 5.12 rc4 + patch | redirect_map        i40e->i40e      |    2.0M |  9.6M
> > 5.12 rc4 + patch | redirect_map        i40e->veth      |    1.7M | 11.7M
> >=20
> > Testing the performance when cloning packets with the redirect_map_multi
> > test, using a redirect map size of 4, filled with 1-3 devices:
> >=20
> > 5.12 rc4 + patch | redirect_map multi  i40e->veth (x1) |    1.7M | 11.4M
> > 5.12 rc4 + patch | redirect_map multi  i40e->veth (x2) |    1.1M |  4.3M
> > 5.12 rc4 + patch | redirect_map multi  i40e->veth (x3) |    0.8M |  2.6M
> >=20
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com> =20
>=20
> [...]
>=20
> LGTM thanks for sticking with it.

+1

> Acked-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

