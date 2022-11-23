Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA003636C68
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiKWVcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiKWVcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:32:23 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555C68FE73;
        Wed, 23 Nov 2022 13:32:22 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4NHZ8d6r0zz9sQc;
        Wed, 23 Nov 2022 22:32:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669239138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bdMp3iNsz89eWNqp8pGWZH/hHxCMtNpKUEDiIKQqEFc=;
        b=cqy8UGBk3DYqtYjfvKqhJ4BNRCbidS6pSM34wLdHKu/xoN+pJ9Yywm9SiIsg0n59N2SWU3
        apCZKU6EmFiCai9GWGT8u2CBcfJD4djI4yei5DszSMsPdKBpzwL5zL1NY6kroiLE2mUEvs
        1pbWxeDTt75GcoasBgvaakDPOe30Mgdv1q/f2cUVv4J+lkJexP2FNVVLFMnB0hRCMul7ev
        d1/gy/9xiV88YG3mYH/LIMbGTU2MFF6qg2eMuq354WFdNBma2xzVNGrb0mj+EboWfeVxTB
        MNv2vWfaHy++zSxl7c5YKpgTAa0XAUwuftxFvBCSCrsyKqEebaU6ZQo8A+fCWQ==
From:   Alexander Lobakin <alobakin@mailbox.org>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexander Lobakin <alobakin@maibox.org>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kbuild@vger.kernel.org,
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Date:   Wed, 23 Nov 2022 22:31:44 +0100
Message-Id: <20221123213144.58738-1-alobakin@mailbox.org>
In-Reply-To: <Y3u/qwvLED4nE/jR@colin-ia-desktop>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-15-alobakin@pm.me> <20221121175504.qwuoyditr4xl6oew@skbuf> <Y3u/qwvLED4nE/jR@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 6oaxuytjxjineax3hrw37r1bqtxy93ex
X-MBO-RS-ID: 87f354797b3c031bd83
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@maibox.org>

From: Colin Foster <colin.foster@in-advantage.com>
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

Yes, sure. I'm totally open for renaming stuff -- usually I barely
touch most of the code from the series, so the names can make no
sense at all. _dsa_lib sounds good, I like it.

> > 
> > Adding Colin for a second opinion on the naming. I'm sure things could
> > have been done better in the first place, just not sure how.
> 
> Good catch on this patch. "mscc_ocelot_dsa_lib" makes sense. The only
> other option that might be considered would be along the lines of
> "felix_lib". While I know "Felix" is the chip, in the dsa directory it
> seems to represent the DSA lib in general.

The thing confused me is that one of the platforms is named Felix
and the other is Seville, but the file they share is also felix,
although Seville has no references to the name "felix" AFAICS :D
I thought maybe Felix is a family and Seville is a chip from this
family, dunno.

> 
> Either one seems fine for me. And thanks for the heads up, as I'll need
> to make the same changes for ocelot_ext when it is ready.
> 

Ooh, something interesting is coming, nice <.<

Thanks,
Olek
