Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAA55676A3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiGESig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiGESif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89521EEDA;
        Tue,  5 Jul 2022 11:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845C8619AF;
        Tue,  5 Jul 2022 18:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2D4C341C7;
        Tue,  5 Jul 2022 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657046310;
        bh=n2FYaXwhaELmE4/t8hrvpE36wLbFiYnyvmWCIE9/OT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKfgh9MyAL+9CBQfpaOE+UB1LSJQLgBgwHWdRGvkoHxvwP9EJSy6b5CXBuLiZ3TQw
         HTvhCWnI7sgMKN+MenLlrM5UVl1oI8GNAZfaRV+Ib42fHvfyG3gl/MtZoBYioNxSN+
         aIBppKadfHO59uKDyPjluq5Sz2LSwAekL00+ws7cG+zPsYvkBiYYoSBswmCLKByrwk
         +o3zyar4Urcc7rcBwLta2r3mMBMrPuH9vx4cO/AntFdevfIR4sI15lyAgdnBgMezZf
         nn4aoFk4HN0QXg51XZag0l0Z+QnjzT72qgd8ht5nbXF3GBewgoIrMER11nLUYn1mQg
         o0sNESu7IZVHQ==
Date:   Tue, 5 Jul 2022 11:38:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Max Krummenacher <max.oss.09@gmail.com>,
        Mateusz =?UTF-8?B?Sm/FhGN6eWs=?= <mat.jonczyk@o2.pl>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to
 `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
Message-ID: <20220705113829.4af55980@kernel.org>
In-Reply-To: <CABBYNZJDkmU_Fgfszrau9CK6DSQM2xGaGwfVyVkjNo7MVtBd8w@mail.gmail.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
        <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
        <20220705151446.GA28605@francesco-nb.int.toradex.com>
        <CABBYNZJDkmU_Fgfszrau9CK6DSQM2xGaGwfVyVkjNo7MVtBd8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 10:26:08 -0700 Luiz Augusto von Dentz wrote:
> On Tue, Jul 5, 2022 at 8:14 AM Francesco Dolcini
> <francesco.dolcini@toradex.com> wrote:
> >
> > Hello Vasyl,
> >
> > On Tue, Jul 05, 2022 at 03:59:31PM +0300, Vasyl Vavrychuk wrote:  
> > > Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")  
> >
> > This fixes tag is broken, dd06ed7ad057 does not exist on
> > torvalds/master, and the `commit` word should be removed.
> >
> > Should be:
> >
> > Fixes: ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")  
> 
> Ive rebased the patch on top of bluetooth-next and fixed the hash,
> lets see if passes CI I might just go ahead and push it.

Thanks for pushing it along, the final version can got thru bluetooth ->
-> net and into 5.19, right?
