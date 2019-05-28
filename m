Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B442CED0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfE1Sls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:41:48 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:35261 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbfE1Sls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:41:48 -0400
Received: by mail-vs1-f67.google.com with SMTP id q13so951558vso.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ad1cYkMrOLmBkFfXlRPVZK14/AI50NO7QNYJ86qIXgg=;
        b=eqA120MHxFxC9dDn/R6icwh4Legj9CtWNTP1fNpuY31VaXR2JrNvkUrUmicL/Q7WDq
         bASERXEVfxypv5rkMXhK5uQK25HcAvsw0KGxIBLBy+gASYjB40+UpKX8p/4FMSIO5q9g
         +dhZkOrpnvYkslYOMME4ClkwV6W7NmiQ6XuozAMP166u810zfoQJ3Y84tpLLrhVZdB7c
         VPCqQ4B7zyXmIZUzgYsglNaa4s1OiL30unmRtAbdAiNEo2t9LE2UcFHgptLE6HGvCYqQ
         zP+K/Fd7XR6LUGdsEdeOWfNz9iER1hMyD/OHXGFbSL2E2zTOoLvdRhcp2VFPPhm6Fb/3
         NSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ad1cYkMrOLmBkFfXlRPVZK14/AI50NO7QNYJ86qIXgg=;
        b=ERIIMgNHOXFR62rjIxLNKtQ8fvazqKaw6NZZHeX6rE3UJLirrcfIN717IE2rPbU97p
         mRCFJouM1lEDkhtF2wlHffUerkGTZU6wgX/umOAOVHS2SJq+oar6SwthDWNX61UrhzHY
         saYUx2rXylEvVyfFruqvuMIkkVJ215WTAqNZEy3Y3hgcGMWb+3RofqnqmzzUxw7jhl60
         i0m3wq3f4Pan6sgmHjba3BYehdHw9g2ZfJmJqsvZ3/aXzyaK5yxrHBYagueBNMZR0Uv3
         zl6v34Kk4MMtip/XkTHmc/VSZLMIZljRWgSmzP5Yna2zO7TxIIeVlmHQQOhaKiWNju8t
         hzeQ==
X-Gm-Message-State: APjAAAWtAOovB4GsmEQuFrupWNrQa+64JI8lYzqBSBg8JJTLgezHochq
        fNPwRU0as3aT0uxh/TpJL7FCJw==
X-Google-Smtp-Source: APXvYqzn0fLfEetCoLpgYNjCQ8VY4AI3HXA9ZbyBNViobXop6Dsadvi4Mx8EJgOYzyQURcMvt0GSjw==
X-Received: by 2002:a67:ca1c:: with SMTP id z28mr25226236vsk.6.1559068907122;
        Tue, 28 May 2019 11:41:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p75sm7296133vkf.29.2019.05.28.11.41.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 11:41:46 -0700 (PDT)
Date:   Tue, 28 May 2019 11:41:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to
 netdev
Message-ID: <20190528114141.71efa269@cakuba.netronome.com>
In-Reply-To: <CAJ+HfNjFPmRuESHE0MYqQ9UUnV+szPK4du4DugUuzQJRVYWtew@mail.gmail.com>
References: <20190522125353.6106-1-bjorn.topel@gmail.com>
        <20190522125353.6106-2-bjorn.topel@gmail.com>
        <20190522113212.68aea474@cakuba.netronome.com>
        <CAJ+HfNjFPmRuESHE0MYqQ9UUnV+szPK4du4DugUuzQJRVYWtew@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 19:06:21 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> On Wed, 22 May 2019 at 20:32, Jakub Kicinski wrote:
> > You should be able to just call install with the original flags, and
> > install handler should do the right maths again to direct it either to
> > drv or generic, no?
> > =20
>=20
> On a related note: I ran the test_offload.py test (thanks for pointing
> that out!), and realized that my view of load flags was incorrect. To
> double-check:
>=20
> Given an XDP DRV capable netdev "eth0".
>=20
> # ip link set dev eth0 xdp obj foo.o sec .text
> # ip link set dev eth0 xdpdrv off
>=20
> and
>=20
> # ip link set dev eth0 xdpdrv obj foo.o sec .text
> # ip link set dev eth0 xdp off
>=20
> and
>=20
> # ip link set dev eth0 xdpdrv obj foo.o sec .text
> # ip link -force set dev eth0 xdp obj foo.o sec .text
>=20
> and
>=20
> # ip link set dev eth0 xdp obj foo.o sec .text
> # ip link -force set dev eth0 xdpdrv obj foo.o sec .text
>=20
> Should all fail. IOW, there's a distinction between explicit DRV and
> auto-detected DRV? It's considered to be different flags.
>=20
> Correct?

I think so.  That's the way drivers which implement offloads work
(netdevsim and nfp).

However:

ip link set dev eth0 xdpdrv obj foo.o sec .text
ip link set dev eth0 xdpoffload off
ip link set dev eth0 xdpgeneric off

are fine.  It's just the no flag case that's special, to avoid
confusion.  If one always uses the flags there should be no errors.

> This was *not* my view. :-)
