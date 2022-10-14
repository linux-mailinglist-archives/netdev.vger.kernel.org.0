Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46955FE8A7
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJNGHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJNGHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE8160EC4;
        Thu, 13 Oct 2022 23:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40FF061A14;
        Fri, 14 Oct 2022 06:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC8FC433C1;
        Fri, 14 Oct 2022 06:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665727631;
        bh=u3kGUVSwIM6aC0X/nUxTJ+dIkv4+IjwEsnePoGA23iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XjMI7T4bg9LHBu4vtbXrVl5f6pPGQ5QZfNNNaUmOka8KNXjZZOLqxJM0VbbNl435y
         V8DZdV+p88YFc6s6sotXSo81HDjXJ6Yg1eFqa+nJKb68aRgEsT6mHjey5WTby1H+ua
         a5Uds9ZzSosOF+NQr3gD21C7BXWu0whoNX49DfUxRikx/OmsOpNmg52Qw4BSe8BRrY
         qGsxbmMmW6/0mHdx2XrxjjqQSdd1Nu0KHM0ahkcVhpzVQJvfG2P/ifzCX0toDQlE+c
         e3uSnDCHg/QCjWU2eanhHr2HCSh+emn4Lt4KEmDFXlpBJ3GH3WhheQzKZ34/trhATd
         GPP1VJA8PWrGg==
Date:   Fri, 14 Oct 2022 09:07:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, isdn@linux-pingi.de, kuba@kernel.org,
        andrii@kernel.org, davem@davemloft.net, axboe@kernel.dk
Subject: Re: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_Timer
Message-ID: <Y0j8ixwitdWKuUoM@unreal>
References: <20221013125729.105652-1-duoming@zju.edu.cn>
 <Y0gQhe6EL6nDstlL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0gQhe6EL6nDstlL@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 03:20:05PM +0200, Greg KH wrote:
> On Thu, Oct 13, 2022 at 08:57:29PM +0800, Duoming Zhou wrote:
> > If the timer handler hfcpci_Timer() is running, the
> > del_timer(&hc->hw.timer) in release_io_hfcpci() could
> > not stop it. As a result, the use-after-free bug will
> > happen. The process is shown below:
> > 
> >     (cleanup routine)          |        (timer handler)
> > release_card()                 | hfcpci_Timer()
> >   release_io_hfcpci            |
> >     del_timer(&hc->hw.timer)   |
> >   ...                          |  ...
> >   kfree(hc) //[1]FREE          |
> >                                |   hc->hw.timer.expires //[2]USE
> > 
> > The hfc_pci is deallocated in position [1] and used in
> > position [2].
> > 
> > Fix by changing del_timer() in release_io_hfcpci() to
> > del_timer_sync(), which makes sure the hfcpci_Timer()
> > have finished before the hfc_pci is deallocated.
> > 
> > Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
> > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > ---
> >  drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> > index af17459c1a5..5cf37fe7de2 100644
> > --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> > +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> > @@ -157,7 +157,7 @@ release_io_hfcpci(struct hfc_pci *hc)
> >  {
> >  	/* disable memory mapped ports + busmaster */
> >  	pci_write_config_word(hc->pdev, PCI_COMMAND, 0);
> > -	del_timer(&hc->hw.timer);
> > +	del_timer_sync(&hc->hw.timer);
> 
> Nice, how did you test that this will work properly?  Do you have this
> hardware for testing?  How was this issue found and verified that this
> is the correct resolution?

According to his previous response [1], the answer will be no. I'm not
super-excited that this unmaintained and old driver chosen as playground
for new tool.

[1] https://lore.kernel.org/all/17ad6913.ff8e0.1838933840d.Coremail.duoming@zju.edu.cn/#t

> 
> thanks,
> 
> greg k-h
