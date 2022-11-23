Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14466636C90
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbiKWVsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiKWVsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:48:22 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8252A32B96;
        Wed, 23 Nov 2022 13:48:20 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4NHZW46rH1z9sTm;
        Wed, 23 Nov 2022 22:48:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669240096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aw2BXawO+gI2px4foXQHN/iThcaB+rQzuEfnc8I5o8w=;
        b=sQhIOTCIFKcEXfmQZbziXRWCTJY78/QNsQfkuZNqg1w3IDW7RRjTlhGdZWNixdCGjvmg64
        MWvv100IFEWs+0bPLqESrYPLLNFDzDyC8dFxCrj0ukGJh+Yc3+RLLvhdnuno9QGaBxxH4i
        v2vAG5TrRE7jVQVIKy9nwCUOa42FNNeKsQZ+pUWhJCpIsTWfayEIV14r8QEugQB3LvjB7n
        we/bqtf2eEVBHp+icbnoxaeqIz7sxM2kaxXzm7dz72dygXMxolLzFvMzThE9C5J3Uk4AST
        iGfwYOIxVdIE7JBM141HsB2uNJ+AaTlcS1U6gtnmCPeVWm8vWlDPnJPL9u07DA==
From:   Alexander Lobakin <alobakin@mailbox.org>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Date:   Wed, 23 Nov 2022 22:47:46 +0100
Message-Id: <20221123214746.62207-1-alobakin@mailbox.org>
In-Reply-To: <Y3u/qwvLED4nE/jR@colin-ia-desktop>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-15-alobakin@pm.me> <20221121175504.qwuoyditr4xl6oew@skbuf> <Y3u/qwvLED4nE/jR@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: b7otjaeni3xsdy1qrdy9oxk4oj7b6453
X-MBO-RS-ID: d4f309bc62ba0ccc568
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Foster <colin.foster@in-advantage.com>,
Date: Mon, 21 Nov 2022 10:12:59 -0800

> On Mon, Nov 21, 2022 at 07:55:04PM +0200, Vladimir Oltean wrote:
> > On Sat, Nov 19, 2022 at 11:09:28PM +0000, Alexander Lobakin wrote:
> > > With CONFIG_NET_DSA_MSCC_FELIX=m and CONFIG_NET_DSA_MSCC_SEVILLE=y
> > > (or vice versa), felix.o are linked to a module and also to vmlinux
> > > even though the expected CFLAGS are different between builtins and
> > > modules.
> > > This is the same situation as fixed by
> > > commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> > > There's also no need to duplicate relatively big piece of object
> > > code into two modules.
> > > 
> > > Introduce the new module, mscc_core, to provide the common functions
> > > to both mscc_felix and mscc_seville.
> > > 
> > > Fixes: d60bc62de4ae ("net: dsa: seville: build as separate module")
> > > Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> > > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > > ---
> > 
> > I don't disagree with the patch, but I dislike the name chosen.
> > How about NET_DSA_OCELOT_LIB and mscc_ocelot_dsa_lib.o? The "core" of
> > the hardware support is arguably mscc_ocelot_switch_lib.o, I don't think
> > it would be good to use that word here, since the code you're moving is
> > no more than a thin glue layer with some DSA specific code.

Sure. I usually barely work with the code touched by the series, so
often the names can make no sense -- I'm open for better namings
from the real developers.
_dsa_lib sounds good, I like it.

> > 
> > Adding Colin for a second opinion on the naming. I'm sure things could
> > have been done better in the first place, just not sure how.
> 
> Good catch on this patch. "mscc_ocelot_dsa_lib" makes sense. The only
> other option that might be considered would be along the lines of
> "felix_lib". While I know "Felix" is the chip, in the dsa directory it
> seems to represent the DSA lib in general.

The thing confused me is that one chip is named Felix and the other
one is Seville, but the shared code is named felix as well. So at
first I thought maybe Felix is a family of chips and Seville is a
chip from that family, dunno :D

> 
> Either one seems fine for me. And thanks for the heads up, as I'll need
> to make the same changes for ocelot_ext when it is ready.

Something interesting is coming, nice <.<

(re "pls prefix with "net: dsa: ..."" -- roger that)

Thanks,
Olek
