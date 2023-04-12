Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741EB6DEA36
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjDLENr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLENq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4F82134;
        Tue, 11 Apr 2023 21:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38A8562CE2;
        Wed, 12 Apr 2023 04:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5379CC433EF;
        Wed, 12 Apr 2023 04:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272824;
        bh=37vF2OcLT7RuIhgdXGjyAGJ8bZa1FuPhsEVD4ej59XY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SraqQGLFIhfvJlorXj8Yqb4W9Hg/CPdqBkRf1YJpWppOfrHL1yUnZuEmkwN7PwcFc
         xzYbjov2ePto9SCOxzx3QgVYcr1kPpyc0GSWLVJZkv7Bo7EcOtzamQ4eIQJ5FWYgOk
         SXQu0MxgIp/3PMO82RjI5mLw0FE1FZRNsDMa1X/vFFFMBjuTngFrhd4WqxUi8VvV3R
         5Nqt8h7vs1OtnAzJiS1Ex2n6wJXjc8yvidva0pUguoy+kqx64Pl0IJSAUUFt59BE0t
         Zxo66omQbAkWIX0Yl7oU0N4nBFARZk9lbg0UBHuBL/hs1KLM414TePdZP85HA1pfap
         X9ZXnnFX07E1A==
Date:   Tue, 11 Apr 2023 21:13:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Lars-Peter Clausen <lars@metafoo.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Ozieblo <rafalo@cadence.com>
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Message-ID: <20230411211343.43b6833a@kernel.org>
In-Reply-To: <ZDYqIj4Fg3tlGKd5@P9FQF9L96D.corp.robot.car>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
        <20230411184814.5be340a8@kernel.org>
        <6c025530-e2f1-955f-fa5f-8779db23edde@metafoo.de>
        <ZDYqIj4Fg3tlGKd5@P9FQF9L96D.corp.robot.car>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 20:48:50 -0700 Roman Gushchin wrote:
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c
> > b/drivers/net/ethernet/cadence/macb_main.c
> > index d13fb1d31821..1a40d5a26f36 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -1042,6 +1042,10 @@ static dma_addr_t macb_get_addr(struct macb *bp,
> > struct macb_dma_desc *desc)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > =C2=A0#endif
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr |=3D MACB_BF(RX_WADDR, =
MACB_BFEXT(RX_WADDR, desc->addr));
> > +#ifdef CONFIG_MACB_USE_HWSTAMP
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bp->hw_dma_cap & HW_DMA_CAP_P=
TP)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 addr &=3D ~GEM_BIT(DMA_RXVALID_OFFSET);
> > +#endif
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return addr;
> > =C2=A0}
>=20
> I think this version is slightly worse because it adds an unconditional
> if statement, which can be removed with certain config options.
> I can master a version with a helper function, if it's preferable.
>=20
> But if you like this one, it's fine too, let me know, I'll send an updated
> version.

Yup, IMHO this looks better. More likely that someone reading the code
will spot the trickiness.

I suspect we could clear that bit unconditionally, if the branch is=20
a concern. The code seems to assume that buffers it gets are 8B aligned
already, regardless of CONFIG_MACB_USE_HWSTAMP.

Drivers commonly save the DMA address to a SW ring (here I think
rx_skbuff plays this role but only holds single ptr per entry)
so that they don't have to access potentially uncached descriptor
ring. But that'd be too large of a change for a fix.
