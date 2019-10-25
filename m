Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32D1E5147
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbfJYQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:32:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40213 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409512AbfJYQci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572021157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Ahj+VKUgiqpHGKzPJiSUKklwt1j1RxRMlgN5RziQc4=;
        b=e89Yd3HQIww1t+LS7ywXhTJf7PjVSGDvK6CFv8eRsVFs+wqkKRChoNgftgFuULzCLThVkD
        MUjhEvYPUlLireyBWSZRp2CAVSjshOkZ/YKWbsm0VVEFFXOMDMD/16EKOzZ746UMCTEGj3
        pwpfSOh4MekrEsnXrHtEjiRAXz0wtpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-73zKJNv4P9O7KRK6Oq3nQg-1; Fri, 25 Oct 2019 12:32:33 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38A581800E00;
        Fri, 25 Oct 2019 16:32:32 +0000 (UTC)
Received: from krava (ovpn-204-68.brq.redhat.com [10.40.204.68])
        by smtp.corp.redhat.com (Postfix) with SMTP id 855685D70E;
        Fri, 25 Oct 2019 16:32:29 +0000 (UTC)
Date:   Fri, 25 Oct 2019 18:32:28 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv2] bpftool: Try to read btf as raw data if elf read fails
Message-ID: <20191025163228.GB10170@krava>
References: <20191024132341.8943-1-jolsa@kernel.org>
 <20191024105414.65f7e323@cakuba.hsd1.ca.comcast.net>
 <aeb566cd-42a7-9b3a-d495-c71cdca08b86@fb.com>
 <20191025093116.67756660@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
In-Reply-To: <20191025093116.67756660@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 73zKJNv4P9O7KRK6Oq3nQg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 09:31:16AM -0700, Jakub Kicinski wrote:
> On Fri, 25 Oct 2019 05:01:17 +0000, Andrii Nakryiko wrote:
> > >> +static bool is_btf_raw(const char *file)
> > >> +{
> > >> +=09__u16 magic =3D 0;
> > >> +=09int fd;
> > >> +
> > >> +=09fd =3D open(file, O_RDONLY);
> > >> +=09if (fd < 0)
> > >> +=09=09return false;
> > >> +
> > >> +=09read(fd, &magic, sizeof(magic));
> > >> +=09close(fd);
> > >> +=09return magic =3D=3D BTF_MAGIC; =20
> > >=20
> > > Isn't it suspicious to read() 2 bytes into an u16 and compare to a
> > > constant like endianness doesn't matter? Quick grep doesn't reveal
> > > BTF_MAGIC being endian-aware.. =20
> >=20
> > Right now we support only loading BTF in native endianness, so I think=
=20
> > this should do. If we ever add ability to load non-native endianness,=
=20
> > then we'll have to adjust this.
>=20
> This doesn't do native endianness, this does LE-only. It will not work
> on BE machines.

hum, let me try.. I thought it would

jirka

