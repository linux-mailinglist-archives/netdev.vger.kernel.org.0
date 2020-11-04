Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4462A7059
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgKDWYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:24:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727711AbgKDWYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604528676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=clqlzXeLo0t6szqcMAB9wsmCXUvjDkBvemFHIekCo0I=;
        b=aVmfGWbwztiPUW1Nvpw6+IDdepJ8Rwu0IMAPUN6DFtOqK4UWRolRY6k3a96vIWSRhcUA0r
        xe8rLzh+PPjsH39QT+4vTyq8p0cp53XnVdVf2SYkE03jdSfYyPEmL5Y547crYmktDUGiWT
        lQf4LKxnTmnAifkO7uv6aSB+dC4BYsc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-65PjYghCMZGHX1qbP9Gqgg-1; Wed, 04 Nov 2020 17:24:34 -0500
X-MC-Unique: 65PjYghCMZGHX1qbP9Gqgg-1
Received: by mail-io1-f70.google.com with SMTP id d202so204811iof.0
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:24:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=clqlzXeLo0t6szqcMAB9wsmCXUvjDkBvemFHIekCo0I=;
        b=FIHBGQEBMVA+jM8JVpNYkHIY5FYwiBdmJuN545e68Ouu/m22bof320sNbSqOBliaKV
         QdLAodKwlquzsZHw6Zjit9/lYuF8cf/xsXjCtR7t0So0O48N76LENhBl00LL1dvzPtyW
         imBnaAxW87JjysHBT6FcSFkOfyrKhONAY8WrzJjhVsnmxl8NHujuEaa5uI4IQ4VNvMOm
         tWW0j1ViMTB0O2iH5uGozACV0bZFkGjpw724pgK5sVZXwhIkOUadD7z8j9uVsz8U66ko
         TFQxhjzXwZJ5WCU51z8xUeDUpXPqajY13F8Hszui1hoJbp1reIJro5odPDqXS06mwAoy
         hPjA==
X-Gm-Message-State: AOAM5323TUE+n+lNuZRhS+lZnNanF00nZHm6uxVAezpdPIyXIejHFw2h
        kFodEJDcH7o8JioV+9B/CCR7DuR5WTD4IonJKOypLDB0vGzBdRvQ9rfk++h9pm0WYfA0t6I2KFY
        s4XzUvzdnrW5uQ6rm
X-Received: by 2002:a02:9f16:: with SMTP id z22mr227170jal.123.1604528673831;
        Wed, 04 Nov 2020 14:24:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO+EMSU/Ovs9Y6TQPyjPHyMOW5WGysNbk5K5Y+tHJRsHZEhxJNyyx8N1LA4XP2J83L3UtI3Q==
X-Received: by 2002:a02:9f16:: with SMTP id z22mr227150jal.123.1604528673250;
        Wed, 04 Nov 2020 14:24:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 18sm1974988ilg.3.2020.11.04.14.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 14:24:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9094E181CED; Wed,  4 Nov 2020 23:24:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
 <87zh3xv04o.fsf@toke.dk>
 <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net>
 <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Nov 2020 23:24:30 +0100
Message-ID: <87ft5ovjz5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> Some of the most important APIs of libbpf are, arguably,
> bpf_object__open() and bpf_object__load(). They accept a BPF ELF file,
> do some preprocessing and in the end load BPF instructions into the
> kernel for verification. But while API doesn't change across libbpf
> versions, BPF-side code features supported changes quite a lot.

Yes, which means that nothing has to change in iproute2 *at all* to get
this; not the version, not even a rebuild: just update the system
libbpf, and you'll automatically gain all these features. How is that an
argument for *not* linking dynamically? It's a user *benefit* to not
have to care about the iproute2 version, but only have to care about
keeping libbpf up to date.

I mean, if iproute2 had started out by linking dynamically against
libbpf (setting aside the fact that libbpf didn't exist back then), we
wouldn't even be having this conversation: In that case its support for
new features in the BPF format would just automatically have kept up
along with the rest of the system as the library got upgraded...

-Toke

