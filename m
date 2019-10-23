Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB2DE223D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbfJWSBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:01:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51536 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfJWSBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:01:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id q70so15096410wme.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 11:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QOrRgBSXpKlQbq6/XicVegpjHbS0n3UmJLpAj4QLq40=;
        b=VNeFRUAxmOAgNGJxcnbD6ZhmgZLedJxbfGqZSPtYqNoed4gFKhPHdPGjnpMqbscH1m
         Mo4irZt3HVrKp9k+B0toVSTxl0iCzG9YdqHr68gYdBliPNQ0Oxr7j/B66X5NpZJcAycw
         vv+GnwakB5+NJEo5qa+SLodKtzdnw5s+MwzDh0JpLSeVSI8i4JJrUbYZR6wvI1yjVep5
         SVLUOA3J/24T6ssZlQqBofwNLO+Y1yN9gca9Um20XOEu1Wcj0do1YY8NbxB13hvaHJ7c
         ILxMqXpjKGaBOAu1q7Hja62cfCY5MpopgexHa8TK6mZymO3TgGbN5ghaE7dNQJoNdJ2+
         1tDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QOrRgBSXpKlQbq6/XicVegpjHbS0n3UmJLpAj4QLq40=;
        b=sgDumSWcvDRWJpiXJJKaghyGDHE5srR/P5KevnPEDMAzXRj0Eb7mWVgVsNomh21Uam
         S8mdX9ns2frRfouhczXjVqgI6GwgctfxAb3pQHMm2QSqeg+hw8t4ZUttEnlBII2RjOml
         IEwRwVMC2gzxzDGXwMfLaJkTjbKc5MWwiEZhy3mMTy7TXk2/tQ7+HpBt17TFXaq/E9qx
         /o2Ny2WWhQuqipCO9ufzGrKQPtTnMElQNU4JihWxwf9/llJauFH8YKH96YypTJRMUbqK
         0+lOerzTGBKWsQ1zYjypEcAooqhz+5yyRpulAW8JVnepNoGCnPVI23/lM2JOHSlpk4zf
         iUHg==
X-Gm-Message-State: APjAAAVi4DQ/8LhlIrkSRczL6KBF5fNLiRdlB54xLxyyzPN+AmcAAAil
        MhMwZ440mpYGYA2O/Cgmte4MWg==
X-Google-Smtp-Source: APXvYqxhJKnIt4vnRz8xIvPoBaQQL00qw5ItbjGIY1qR+2bAAiQXfPljx2AgDeTXCRC93th0RnSKqg==
X-Received: by 2002:a1c:9e0d:: with SMTP id h13mr988724wme.136.1571853660319;
        Wed, 23 Oct 2019 11:01:00 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id d199sm13125872wmd.35.2019.10.23.11.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 11:00:59 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:00:58 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
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
Subject: Re: [PATCH net-next 4/4] bonding: balance ICMP echoes in layer3+4
 mode
Message-ID: <20191023180057.GC28355@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-5-mcroce@redhat.com>
 <20191023100132.GD8732@netronome.com>
 <CAGnkfhy1rsm0Dp_jsuHhfXY0kzMc_hShYmYSX=X8=q-HMtNczg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhy1rsm0Dp_jsuHhfXY0kzMc_hShYmYSX=X8=q-HMtNczg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 06:58:16PM +0200, Matteo Croce wrote:
> On Wed, Oct 23, 2019 at 12:01 PM Simon Horman
> <simon.horman@netronome.com> wrote:
> >
> > On Mon, Oct 21, 2019 at 10:09:48PM +0200, Matteo Croce wrote:
> > > The bonding uses the L4 ports to balance flows between slaves.
> > > As the ICMP protocol has no ports, those packets are sent all to the
> > > same device:
> > >
> > >     # tcpdump -qltnni veth0 ip |sed 's/^/0: /' &
> > >     # tcpdump -qltnni veth1 ip |sed 's/^/1: /' &
> > >     # ping -qc1 192.168.0.2
> > >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 315, seq 1, length 64
> > >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 315, seq 1, length 64
> > >     # ping -qc1 192.168.0.2
> > >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 316, seq 1, length 64
> > >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 316, seq 1, length 64
> > >     # ping -qc1 192.168.0.2
> > >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 317, seq 1, length 64
> > >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 317, seq 1, length 64
> > >
> > > But some ICMP packets have an Identifier field which is
> > > used to match packets within sessions, let's use this value in the hash
> > > function to balance these packets between bond slaves:
> > >
> > >     # ping -qc1 192.168.0.2
> > >     0: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 303, seq 1, length 64
> > >     0: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 303, seq 1, length 64
> > >     # ping -qc1 192.168.0.2
> > >     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 304, seq 1, length 64
> > >     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 304, seq 1, length 64
> > >
> > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> >
> > I see where this patch is going but it is unclear to me what problem it is
> > solving. I would expect ICMP traffic to be low volume and thus able to be
> > handled by a single lower-device of a bond.
> >
> > ...
> 
> Hi,
> 
> The problem is not balancing the volume, even if it could increase due
> to IoT devices pinging some well known DNS servers to check for
> connection.
> If a bonding slave is down, people using pings to check for
> connectivity could fail to detect a broken link if all the packets are
> sent to the alive link.
> Anyway, although I didn't measure it, the computational overhead of
> this changeset should be minimal, and only affect ICMP packets when
> the ICMP dissector is used.

So the idea is that by using different id values ping could be used
to probe all lower-devices of a bond? If so then I understand why
you want this and have no particular objection.
