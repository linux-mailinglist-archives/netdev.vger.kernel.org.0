Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704D6599E67
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349797AbiHSPgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349770AbiHSPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:36:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112AD120B6;
        Fri, 19 Aug 2022 08:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1006B82800;
        Fri, 19 Aug 2022 15:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF83C433D6;
        Fri, 19 Aug 2022 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923368;
        bh=1CeiB4K9FMDSHYlregecvn7xyN/t+buSajCbr7nqGoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtKYiVdPGXpCn3pe820y/PbYDk2D7fLcAW2IntqrbOVYlvpEYXiPpehBmqwP0cxjV
         NnjsZyrIkEPQqAJ0IQ596eb3DYZhsD6CxkHlIfhRTdwBeyAF9xOMkprgSR6qXMvvcH
         wOY/Q1HSaDfhdFvfVzVkGk10dqYs9Imi7JodyeKA=
Date:   Fri, 19 Aug 2022 17:36:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 0/1] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Message-ID: <Yv+t5fd/ge36XzNM@kroah.com>
References: <20220819103852.902332-1-dragos.panait@windriver.com>
 <Yv9ymGE9ZNPfUjBm@kroah.com>
 <57b4c8e6-4a32-cc03-f469-c4bd6dd1eaca@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b4c8e6-4a32-cc03-f469-c4bd6dd1eaca@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 03:18:26PM +0300, Dragos-Marian Panait wrote:
> Hi Greg,
> 
> On 19.08.2022 14:23, Greg KH wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Fri, Aug 19, 2022 at 01:38:51PM +0300, Dragos-Marian Panait wrote:
> > > The following commit is needed to fix CVE-2022-1679:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0ac4827f78c7ffe8eef074bc010e7e34bc22f533
> > > 
> > > Pavel Skripkin (1):
> > >    ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
> > > 
> > >   drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
> > >   drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
> > >   2 files changed, 7 insertions(+), 6 deletions(-)
> > > 
> > > 
> > > base-commit: 6eae1503ddf94b4c3581092d566b17ed12d80f20
> > > --
> > > 2.37.1
> > > 
> > This is already queued up for 5.10.  You forgot the backports to older
> > kernels, which is also already queued up.
> Are you sure of this?
> I can not find any patch for older kernels in the stable mailing list(except
> for 5.15, 5.18, 5.19).

Look in the stable-queue.git tree on git.kernel.org.

thanks,

greg k-h
