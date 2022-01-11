Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF4548B1F8
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343671AbiAKQVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:21:53 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:39459 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239725AbiAKQVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:21:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918087;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=HlWE7eH+IRtjW2+Vb37/ahftzfF/huNkWBYGStShLSM=;
    b=kkz3iQAQTlluAoMy6HrAIoW8MEZWjxoVq9uR4jTh114ofG8Dvv5BnwHa4/kq2QMdH9
    R6CL3d9v+48QIrXEv0IYkUaHt015GyCMOD5wPp5M3zv8pDBt3XgFRZEx+P+1ShN6NnfW
    OgCbGDL2q1WjuaWY9qZFgU7LWqBH0LSDadZC+uZMKLik6W7JUTHHy5YL3J6FKfWKxiIX
    aX43weuLKZnLyn6vHCCp7qudjsBjwOA/VxwFpjnvaXKie9WhVaBrGB7KarlrfedE0OFz
    t4N9SbfbhNnCgfx7hsOEq4fjV/UBOJnVfxSPxy8nEws2EdaE92cH9OJOj2P24QKsFM8y
    8nwg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCv/x28jVM="
X-RZG-CLASS-ID: mo00
Received: from oxapp06-01.back.ox.d0m.de
    by smtp.strato.de (RZmta 47.37.6 AUTH)
    with ESMTPSA id a48ca5y0BGLQHKh
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:21:26 +0100 (CET)
Date:   Tue, 11 Jan 2022 17:21:26 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net
Message-ID: <1393112852.2793965.1641918086821@webmail.strato.com>
In-Reply-To: <CAMuHMdXk2mZntTBe3skSVkcNVjC-PzMwEv_MbH85Mvn1ZkFpHw@mail.gmail.com>
References: <20210924153113.10046-1-uli+renesas@fpond.eu>
 <20210924153113.10046-2-uli+renesas@fpond.eu>
 <CAMuHMdXk2mZntTBe3skSVkcNVjC-PzMwEv_MbH85Mvn1ZkFpHw@mail.gmail.com>
Subject: Re: [PATCH 1/3] can: rcar_canfd: Add support for r8a779a0 SoC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev33
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your review.

> On 10/05/2021 3:06 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> I'm wondering if some of these IS_V3U checks can be avoided, improving
> legibility, by storing a feature struct instead of a chip_id in
> rcar_canfd_of_table[].data?

Not really. I have found perhaps three cases in which this is possible, compared to dozens where it isn't. In the end you would get virtually no change in legibility or verbosity, but an increase in complexity.

> >  /* RSCFDnCFDRFCCx / RSCFDnRFCCx */
> > -#define RCANFD_RFCC(x)                 (0x00b8 + (0x04 * (x)))
> > +#define RCANFD_RFCC(x)                 ((IS_V3U ? 0x00c0 : 0x00b8) + \
> > +                                        (0x04 * (x)))
> >  /* RSCFDnCFDRFSTSx / RSCFDnRFSTSx */
> > -#define RCANFD_RFSTS(x)                        (0x00d8 + (0x04 * (x)))
> > +#define RCANFD_RFSTS(x)                        ((IS_V3U ? 0x00e0 : 0x00d8) + \
> > +                                        (0x04 * (x)))
> >  /* RSCFDnCFDRFPCTRx / RSCFDnRFPCTRx */
> > -#define RCANFD_RFPCTR(x)               (0x00f8 + (0x04 * (x)))
> > +#define RCANFD_RFPCTR(x)               ((IS_V3U ? 0x0100 : 0x00f8) + \
> > +                                        (0x04 * (x)))
> 
> There's some logic in the offsets: they're 32 bytes apart, regardless
> of IS_V3U. Can we make use of that?

We can here...

> >  /* Common FIFO Control registers */
> >
> >  /* RSCFDnCFDCFCCx / RSCFDnCFCCx */
> > -#define RCANFD_CFCC(ch, idx)           (0x0118 + (0x0c * (ch)) + \
> > -                                        (0x04 * (idx)))
> > +#define RCANFD_CFCC(ch, idx)           ((IS_V3U ? 0x0120 : 0x0118) + \
> > +                                        (0x0c * (ch)) + (0x04 * (idx)))
> >  /* RSCFDnCFDCFSTSx / RSCFDnCFSTSx */
> > -#define RCANFD_CFSTS(ch, idx)          (0x0178 + (0x0c * (ch)) + \
> > -                                        (0x04 * (idx)))
> > +#define RCANFD_CFSTS(ch, idx)          ((IS_V3U ? 0x01e0 : 0x0178) + \
> > +                                        (0x0c * (ch)) + (0x04 * (idx)))
> >  /* RSCFDnCFDCFPCTRx / RSCFDnCFPCTRx */
> > -#define RCANFD_CFPCTR(ch, idx)         (0x01d8 + (0x0c * (ch)) + \
> > -                                        (0x04 * (idx)))
> > +#define RCANFD_CFPCTR(ch, idx)         ((IS_V3U ? 0x0240 : 0x01d8) + \
> > +                                        (0x0c * (ch)) + (0x04 * (idx)))
> 
> Same here, 96 bytes spacing.

...but not here. (0x1e0 - 0x120 != 0x60)

CU
Uli
