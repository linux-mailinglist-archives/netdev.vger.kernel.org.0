Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375DE636657
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiKWQ7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238060AbiKWQ7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:59:10 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79AB66CA6;
        Wed, 23 Nov 2022 08:59:08 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8613060009;
        Wed, 23 Nov 2022 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669222747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocNle5svEAfXW7cmp/QTXhOMQIMNm/+sptjua2c54SA=;
        b=BwZ/6py/00KDo4z2J4uVsGL5bF1dU/Y9qkLDjp0zhlqj5DBhmsT4hq0N5batrHuJWtaBw9
        bu1U74/50NDjhFlGFJ1gujiBCwxR0QpFnYA/sHOi1AYrEVqLjlZZ06rnqLEUy0mw3p+WCJ
        QIP4ZfYPU+67clvVll1t/iRLH7OBc9mq49Bm/ccosWMuC1LQo92VQv3zMdlpfCwIkahg8h
        iB8fLPmo7ROEfIJpAqeoLupgsgH0TDImjo4LtjvHOhgyOu552uMqTQv8S85BgZUwQ1j3vD
        zWlrTmTQv/6Zs3IEKcdQKoR/6eqAuJkmX07hjWXjA71xhFlPWVAAjhwGfMFv7Q==
Date:   Wed, 23 Nov 2022 17:59:00 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/18] mtd: tests: fix object shared between several
 modules
Message-ID: <20221123175900.4e05a0f2@xps-13>
In-Reply-To: <CAK7LNASni5uNFOtR-6VykBHX1Wgg-rOt=q0Lk+H2Vbn7pCsBDQ@mail.gmail.com>
References: <20221119225650.1044591-1-alobakin@pm.me>
        <20221119225650.1044591-13-alobakin@pm.me>
        <CAK7LNASni5uNFOtR-6VykBHX1Wgg-rOt=q0Lk+H2Vbn7pCsBDQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

masahiroy@kernel.org wrote on Wed, 23 Nov 2022 22:11:49 +0900:

> On Sun, Nov 20, 2022 at 8:08 AM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > mtd_test.o is linked to 8(!) different test modules:
> > =20
> > > scripts/Makefile.build:252: ./drivers/mtd/tests/Makefile: mtd_test.o
> > > is added to multiple modules: mtd_nandbiterrs mtd_oobtest mtd_pagetest
> > > mtd_readtest mtd_speedtest mtd_stresstest mtd_subpagetest mtd_torture=
test =20
> >
> > Although all of them share one Kconfig option
> > (CONFIG_MTD_TESTS), it's better to not link one object file into
> > several modules (and/or vmlinux).
> > Under certain circumstances, such can lead to the situation fixed by
> > commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> > In this particular case, there's also no need to duplicate the very
> > same object code 8 times.
> >
> > Convert mtd_test.o to a standalone module which will export its
> > functions to the rest.
> >
> > Fixes: a995c792280d ("mtd: tests: rename sources in order to link a hel=
per object")
> > Suggested-by: Masahiro Yamada <masahiroy@kernel.org> =20
>=20
> IMHO, Reported-by might be a better fit.
>=20
>=20
> I think they can become static inline functions in mtd_test.h
> (at least, mtdtest_relax() is a static inline there), but I am not sure.
>=20
> Please send this to the MTD list, and consult the maintainer(s).

TBH I don't really mind. These are test modules that you insert to
harden and profile the stack, so whatever makes the robots happy is
fine. Anyway, they are being slowly replaced by userspace tools so we
might eventually get rid of them.

Thanks,
Miqu=C3=A8l
