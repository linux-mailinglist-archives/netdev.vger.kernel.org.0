Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC98C4AF614
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiBIQIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiBIQIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:08:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB864C0612BE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 08:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87B546171F
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 16:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDBEC340E7;
        Wed,  9 Feb 2022 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644422929;
        bh=sMDFhP3B88B4N6a8qt8RE7gs3+KKJYgw6LOODa3e5ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TBXJXAVJbGYCEwZ5LjmRNBo83rwTcvJLtLJ1/EsIgCm8Zt5sRsF9CQXUePNNlpOcu
         CZ/xLP6YCbLYVfVXypd9f4OYhqnDudUR82xFNMnGUbqpUxLbNfnXVufnwlkV7eJuvH
         GfBfsir5AK7tWXwopj3dzmCJ7U0h/Fq09fPZQfYCLtCx4NWlJ+dQIigpMDdhXmH/DU
         zVmTTGqaYy/KjP0FNHURHFTDdscXcQf7HWPZOeqh0rgy+SnKh51eT+MHNA7WQQlwgF
         7ZYcbfGS/OjRsQ9jJ5LJDz+R4ou/pbmMkNKe2J5fqjDGB6ZdDCQ9JjLTfDQ6To0YAO
         xMUmQr21iPf3g==
Date:   Wed, 9 Feb 2022 17:08:45 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <20220209170845.784ba000@dellmb>
In-Reply-To: <AM0PR0602MB366602FD4AB9AF518A6FBEBCF72E9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
        <YgPDjGDeg6sbUy+X@lunn.ch>
        <AM0PR0602MB366602FD4AB9AF518A6FBEBCF72E9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Feb 2022 15:04:56 +0000
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> > > +     if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> > > +             dp = dsa_to_port(ds, port);
> > > +             if (dp)
> > > +                     phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
> > > +
> > > +             if (phy_handle && !of_property_read_u32(phy_handle,
> > > +                                                     "tx-p2p-microvolt",
> > > +                                                     &tx_amp)) {
> > > +                     err = mv88e6352_serdes_set_tx_p2p_amplitude(chip, port,
> > > +                                                                 tx_amp);
> > > +                     if (err) {
> > > +                             of_node_put(phy_handle);
> > > +                             return err;
> > > +                     }  
> > 
> > You could move this test
> >   
> > > +             }
> > > +             if (phy_handle)
> > > +                     of_node_put(phy_handle);  
> > 
> > to here, since you need to put the phy_handle anyway.
> >   
> 
> ok. I think I will also rename the ...set_tx_p2p_amplitude to ...set_tx_p2p to
> shorten the function names. Makes it easier to read.

Please don't drop "amplitude". If anything, drop the "p2p".

Marek
