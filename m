Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F0852F19D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352199AbiETRYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352242AbiETRYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:24:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAC518AABA
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7FC6B82BFE
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7A0C385A9;
        Fri, 20 May 2022 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653067437;
        bh=dNnx1j2OdeGoPsekKq+iljpoL8M0dyLx2lsxZzAulNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gss7MPZdZtO2/ugW+0nl8mZGiLSBo3X7oHFH1LRbpSf1xMNErk5AFqs+YDHsCCTpl
         NHGa0BDSm/m0Zwk9aUL2Ja9YIExJ1TFCTHlapHg/cKEV5yEiEjWz3kdYDr93w2fdMg
         xPesnJk4iuuFrZF4OPmXI6dB0ugMcy/WGLeopEufaMpbVhNnGO0zaV8Q6lhGgbc3S2
         6WTQ07oY2B8vS/VSBAKxncKZlgiGfJUSnak5L9xvAJxv9VjSBCzNqxRCkXJzD4ZVXL
         DbVJMscC8rj07LI0Qg+2pBndG+mjJgF3pceABDNAqX6MxXU4WOgn0TODcU5ZmaShCZ
         04aYqbeTXl2wQ==
Date:   Fri, 20 May 2022 10:23:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org
Subject: Re: GCC 12 warnings
Message-ID: <20220520102355.273cae07@kernel.org>
In-Reply-To: <202205200938.1EE1FD1@keescook>
References: <20220519193618.6539f9d9@kernel.org>
        <202205200938.1EE1FD1@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 09:46:36 -0700 Kees Cook wrote:
> > Since -Warray-bounds is included by default now this is making our
> > lives a little hard [1]. Is there a wider effort to address this?
> > If not do you have a recommendation on how to deal with it?  
> 
> Looks like the issue was this?
> https://lore.kernel.org/all/20220520145957.1ec50e44@canb.auug.org.au/
> 
> Ah, from cf2df74e202d ("net: fix dev_fill_forward_path with pppoe + bridge")
> 
> You mean you missed this particular warning because of the other GCC
> 12 warnings?

Yup :(

> > My best idea is to try to isolate the bad files and punt -Warray-bounds
> > to W=1 for those, so we can prevent more of them getting in but not
> > break WERROR builds on GCC 12. That said, I'm not sure how to achieve
> > that.. This for example did not work:
> > 
> > --- a/drivers/net/ethernet/mediatek/Makefile
> > +++ b/drivers/net/ethernet/mediatek/Makefile
> > @@ -9,5 +9,9 @@ mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o
> >  ifdef CONFIG_DEBUG_FS
> >  mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
> >  endif
> >  obj-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_ops.o
> >  obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
> > +
> > +ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
> > +CFLAGS_mtk_ppe.o += -Wno-array-bounds
> > +endif  
> 
> This worked for me:
> 
> diff --git a/drivers/net/can/usb/kvaser_usb/Makefile b/drivers/net/can/usb/kvaser_usb/Makefile
> index cf260044f0b9..43eb921f9102 100644
> --- a/drivers/net/can/usb/kvaser_usb/Makefile
> +++ b/drivers/net/can/usb/kvaser_usb/Makefile
> @@ -1,3 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb.o
>  kvaser_usb-y = kvaser_usb_core.o kvaser_usb_leaf.o kvaser_usb_hydra.o
> +
> +ifeq ($(KBUILD_EXTRA_WARN),)
> +CFLAGS_kvaser_usb_hydra.o += -Wno-array-bounds
> +endif

Ah, thanks, I must have tried -Wno-array-bounds before I figured out
the condition and reverted back to full $(call cc-disable-warning, ..)
Let me redo the patches.

Thanks!
