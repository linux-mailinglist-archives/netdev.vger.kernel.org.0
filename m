Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A892CF0F3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgLDPp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgLDPpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 10:45:55 -0500
Date:   Fri, 4 Dec 2020 07:45:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607096715;
        bh=hlxC2FJCf6bk/llMDqBF/KGpuvay6rt+yKz7CcBwdnU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uekk62PZlUmeqbhHarwlfUt3dzmak0h9S0hOF1dhAcHvpLuar9PMmcyVex/qGMTU6
         CXofqKh5qgNrfeBL+/5gCGtxMVJPI2r7LXjBMuXG3rgNJcv7kPhw2k8w35B6oEv5iw
         8sIkuxnaDFzPOBlHDGJ5dOnJyJrUgPZ6U4dOm6BduNlTwLY8IR+LslxM17O/WifJ24
         rmFgqnW41dCgUmmzJ/uZCUGNdjNmuugsLNOjOkcyzO/cGfwRjB6rQ4e3bidb27ujX4
         A+7A1AMhILCvFs/qtdqJQ1VqTwXXxV7O9eI5ti12C59gomgBoQbe8k1ndj9ndi1GBq
         TIKPAfD637/tA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3] bonding: fix feature flag setting at init time
Message-ID: <20201204074514.6a249076@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAKfmpSd7JH4Y--z=8iPxekzSeAr0AVmQFPHaOYX71dcRoJouXQ@mail.gmail.com>
References: <20201202173053.13800-1-jarod@redhat.com>
        <20201203004357.3125-1-jarod@redhat.com>
        <20201203085001.4901c97f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAKfmpSd7JH4Y--z=8iPxekzSeAr0AVmQFPHaOYX71dcRoJouXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 22:14:12 -0500 Jarod Wilson wrote:
> On Thu, Dec 3, 2020 at 11:50 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed,  2 Dec 2020 19:43:57 -0500 Jarod Wilson wrote:  
> > >       bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
> > > -#ifdef CONFIG_XFRM_OFFLOAD
> > > -     bond_dev->hw_features |= BOND_XFRM_FEATURES;
> > > -#endif /* CONFIG_XFRM_OFFLOAD */
> > >       bond_dev->features |= bond_dev->hw_features;
> > >       bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
> > >  #ifdef CONFIG_XFRM_OFFLOAD
> > > -     /* Disable XFRM features if this isn't an active-backup config */
> > > -     if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
> > > -             bond_dev->features &= ~BOND_XFRM_FEATURES;
> > > +     bond_dev->hw_features |= BOND_XFRM_FEATURES;
> > > +     /* Only enable XFRM features if this is an active-backup config */
> > > +     if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
> > > +             bond_dev->features |= BOND_XFRM_FEATURES;
> > >  #endif /* CONFIG_XFRM_OFFLOAD */  
> >
> > This makes no functional change, or am I reading it wrong?  
> 
> You are correct, there's ultimately no functional change there, it
> primarily just condenses the code down to a single #ifdef block, and
> doesn't add and then remove BOND_XFRM_FEATURES from
> bond_dev->features, instead omitting it initially and only adding it
> when in AB mode. I'd poked at the code in that area while trying to
> get to the bottom of this, thought it made it more understandable, so
> I left it in, but ultimately, it's not necessary to fix the problem
> here.

Makes sense, but please split it out and send separately to net-next.
