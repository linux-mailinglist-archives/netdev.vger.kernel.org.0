Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46369E212E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfJWQ65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:58:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726265AbfJWQ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571849935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=svxKy9PpZYdSp7My5GoLpaiAHrwdkyewTYZPNZNZ5xI=;
        b=gadzBxlORc3ol2qbgPvVoxlsSa4xzUCbScVECOxkB1G+x/zVoYkCCmJF9xcHyVf7h0sz+y
        1BOZvcZG3hIIwxffkSYrUmnRbiBOAcatlHSRJ9v1rJFKTpekB+hVBN9D/TP0WM/PQwa+Rc
        GIEKV59gIQqZWx4MKtj8mKlnVDgKi4U=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-vDqrVLA-N3G52MR6xwtTqQ-1; Wed, 23 Oct 2019 12:58:54 -0400
Received: by mail-lj1-f198.google.com with SMTP id w26so3707010ljh.9
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WadZePlEGvqCjR+F4g4l9zs3Tb/z+tEXc700EM0+NZE=;
        b=J6dYg3K+bzAYmbY3xrfCVwJgbrcSY5iCJCW8IvyHKdt5rmp8BWndnQdLHYGEnViIxs
         zMassvCwq6aR0QjpNF+XHyjAGNZbPdRL+YgL2fo0VGiPHdPbDpxRpyhHUm10/SrlQhRK
         eU99gFbVjV5tdMQ9Dsj5deF5jyfy7qNPQrqVvm+sOKRBGSUGn3kkmAHi4gwVkdtxQ9xH
         sjQSjEX6c+shT695bzXXY3Z6icGmIKmjX/IDZsKHs+snGh8kAFGSY/PC45BRpcfrFSlP
         zGOzgtzSWL8VWojen/4neExZ2SYAoL6JcAKo8hE4T3IWoh3iSvJzDcrMEh+SJ33WkCgd
         N49g==
X-Gm-Message-State: APjAAAUei+zaEtAPtbpWfJJMJHoY1VMhfiMWQtMGHEpSxTYh7x6O7FPc
        4x4HO2QHa6WdMHk42rSClPoqTuSylED7zzXN2l7Ul/VAVsdaT1b88lMcwWR5Ixnj8aFl5FO3AdQ
        LR/sGzjNUmEH7kK9n+uM9/zSQfemsFYzO
X-Received: by 2002:a19:f707:: with SMTP id z7mr12684771lfe.0.1571849932846;
        Wed, 23 Oct 2019 09:58:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxzuAJ3SiF0de98rFTJPLLTmMZ3yLAQ4bENcIP+wrr2Kj8d3MAxXL/CqGOvxQJUi82d4cSF+Pao0feEKCQuYsA=
X-Received: by 2002:a19:f707:: with SMTP id z7mr12684749lfe.0.1571849932584;
 Wed, 23 Oct 2019 09:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191021200948.23775-1-mcroce@redhat.com> <20191021200948.23775-5-mcroce@redhat.com>
 <20191023100132.GD8732@netronome.com>
In-Reply-To: <20191023100132.GD8732@netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 23 Oct 2019 18:58:16 +0200
Message-ID: <CAGnkfhy1rsm0Dp_jsuHhfXY0kzMc_hShYmYSX=X8=q-HMtNczg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] bonding: balance ICMP echoes in layer3+4 mode
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: vDqrVLA-N3G52MR6xwtTqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 12:01 PM Simon Horman
<simon.horman@netronome.com> wrote:
>
> On Mon, Oct 21, 2019 at 10:09:48PM +0200, Matteo Croce wrote:
> > The bonding uses the L4 ports to balance flows between slaves.
> > As the ICMP protocol has no ports, those packets are sent all to the
> > same device:
> >
> >     # tcpdump -qltnni veth0 ip |sed 's/^/0: /' &
> >     # tcpdump -qltnni veth1 ip |sed 's/^/1: /' &
> >     # ping -qc1 192.168.0.2
> >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 315, seq 1, =
length 64
> >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 315, seq 1, le=
ngth 64
> >     # ping -qc1 192.168.0.2
> >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 316, seq 1, =
length 64
> >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 316, seq 1, le=
ngth 64
> >     # ping -qc1 192.168.0.2
> >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 317, seq 1, =
length 64
> >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 317, seq 1, le=
ngth 64
> >
> > But some ICMP packets have an Identifier field which is
> > used to match packets within sessions, let's use this value in the hash
> > function to balance these packets between bond slaves:
> >
> >     # ping -qc1 192.168.0.2
> >     0: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 303, seq 1, =
length 64
> >     0: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 303, seq 1, le=
ngth 64
> >     # ping -qc1 192.168.0.2
> >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 304, seq 1, =
length 64
> >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 304, seq 1, le=
ngth 64
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>
> I see where this patch is going but it is unclear to me what problem it i=
s
> solving. I would expect ICMP traffic to be low volume and thus able to be
> handled by a single lower-device of a bond.
>
> ...

Hi,

The problem is not balancing the volume, even if it could increase due
to IoT devices pinging some well known DNS servers to check for
connection.
If a bonding slave is down, people using pings to check for
connectivity could fail to detect a broken link if all the packets are
sent to the alive link.
Anyway, although I didn't measure it, the computational overhead of
this changeset should be minimal, and only affect ICMP packets when
the ICMP dissector is used.

Regards,
--=20
Matteo Croce
per aspera ad upstream

