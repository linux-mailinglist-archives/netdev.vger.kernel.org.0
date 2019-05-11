Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887EE1A883
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfEKQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 12:52:27 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34675 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfEKQw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 12:52:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id j24so6786708ljg.1
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 09:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=8wz43C7jxGCUsHy9MfWjXgalwSWO3z1P/EsbM3jZ0KM=;
        b=GDi3fsBTBmf9X/8Hz0x1TQFBY0bhDBOVG947LRV8qCxSuuclixM+RZ23aQRJsD+7QL
         FFoQee+EIXhKJpQVIge77dug+vh6aZEAXj7EobIugSWNrnrQ+lfqlnR8Q37ZkFcIA5GB
         v7yQJ7MNZn/9ofUQykM+64Arse7i9M0xZTWTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=8wz43C7jxGCUsHy9MfWjXgalwSWO3z1P/EsbM3jZ0KM=;
        b=g578LeqXZILui7xyYUqrm+PXRZOWji8iiNfT7/Hq5xt7Zdk7Hc4n3zR1WL5UgE6o9v
         ww/VVCOJTeR3n4k8iQRR6sbCngC1fU4yVT6VYGbG79QvPKhwdCv3WFOO9ox6+m+XefD7
         XwhVBBIbp8Xx4Spp8sPbVeGA3IxFX6htIvws79SCfW8vqXPVP1tIuLFnoKbjSJbU2lnl
         EaU0+fPdcJ62grwN/KSpn8174mQeGCpx8o0VDQqZTAbb7ZS4TQhr7wd6P6n5/vOfSsXi
         dkACDVJty08SCYwr/k4GWJmzvguoMRziRBXUQ0QpSRA5HCm8Shm7l8n9OT9WDLE0E224
         B9mA==
X-Gm-Message-State: APjAAAUefNI7GGnqMLuv/0o/N4GkU7C7ctFm/FJ9HdyLpOLm1ez3A3w3
        OgUqPciCJZf9+05Q3z6tC+ILCJ4cQsk=
X-Google-Smtp-Source: APXvYqxnjvvvLamfJQCTx2drNeTE0+6WyXRKDNsa03MGai5/pmflKyf08Vz4Y5M0VAW/SxBl1GbrHw==
X-Received: by 2002:a2e:844a:: with SMTP id u10mr9201016ljh.41.1557593544558;
        Sat, 11 May 2019 09:52:24 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id x2sm2210691ljx.13.2019.05.11.09.52.23
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 09:52:23 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id w23so6220411lfc.9
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 09:52:23 -0700 (PDT)
X-Received: by 2002:a19:5015:: with SMTP id e21mr9229137lfb.62.1557593542751;
 Sat, 11 May 2019 09:52:22 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 May 2019 12:52:06 -0400
X-Gmail-Original-Message-ID: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Message-ID: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Subject: Annoying gcc / rdma / networking warnings
To:     Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>
Cc:     Doug Ledford <dledford@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason and Davem,
 with gcc-9, I'm now seeing a number of annoying warnings from the
rdma layer. I think it depends on the exact gcc version, because I'm
seeing them on my laptop but didn't see them on my desktop, probably
due to updating at different times.

The warning is because gcc now looks at pointer types for some
allocation sizes, and will do things like this:

In function =E2=80=98memset=E2=80=99,
    inlined from =E2=80=98rdma_gid2ip=E2=80=99 at ./include/rdma/ib_addr.h:=
168:3,
    inlined from =E2=80=98roce_resolve_route_from_path=E2=80=99 at
drivers/infiniband/core/addr.c:735:2:
./include/linux/string.h:344:9: warning: =E2=80=98__builtin_memset=E2=80=99=
 offset
[17, 28] from the object at =E2=80=98dgid=E2=80=99 is out of the bounds of =
referenced
subobject =E2=80=98_sockaddr=E2=80=99 with type =E2=80=98struct sockaddr=E2=
=80=99 at offset 0
[-Warray-bounds]
  344 |  return __builtin_memset(p, c, size);

because the "memset()" is done onto a "sockaddr_in6" (where it's not
out of bounds), but the rdma_gid2ip() function was passed a "sockaddr"
type (where it *is* out of bounds.

All the cases I found actually have good *allocations* for the
underlying storage, using a union of the different sockaddr types, and
includes a "sockaddr_in6". So the warning actually looks bogus from an
actual allocation standpoint, but at the same time, I think the
warning does show a real issue in the networking code.

In particular, a "struct sockaddr" is supposed to be a valid superset
of the different sockaddr types, and the rdma use is in that sense the
rdma use of "struct sockaddr *" is entirely sane.

BUT.

The Linux kernel sockaddr is actually just 16 bytes. While a
sockaddr_int is about twice that.

So if you look at the types like gcc does, then the rdma layer really
is passing a pointer to a 16-byte sockaddr, and then filling it with
(much bigger) sockaddr_ip6 data.

Arguably gcc is being stupid, and it should look at the actual
allocation, but that's not what it does. And I do think what gcc does
is at least understandable.

So David, arguably the kernel "struct sockaddr" is simply wrong, if it
can't contain a "struct sockaddr_in6". No? Is extending it a huge
problem for other users that don't need it (mainly stack, I assume..)?

Also equally arguably, the rdma code could just use a "struct
sockaddr_in6 for this use and avoid the gcc issue, couldn't it? It has
the type right there, and rdma_gid2ip() could just take that type
instead, since that's what it actually then uses anyway.

Comments?

               Linus
