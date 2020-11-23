Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6732C1413
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390519AbgKWS4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbgKWS4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:56:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8931220729;
        Mon, 23 Nov 2020 18:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606157809;
        bh=k/yAq39ohVfSvWueODatF0ENLn6rpGI5SxkNSSdHS2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ASuCQVyfjOsdXnSZe2/5+jKHwfXIdIz11KB4VLWQjAB71fX9zoDk9qbPRMsl7+Hda
         bZs7uOgBrgkz8Yus50vC3zBe6tiwU5BYUVKoQotzh524sCQKZo60sdkuOwF8lhxSzS
         U5qYutVreFh7mtwu2BtRkT1fQ0KwUw9mI5mOrbFM=
Date:   Mon, 23 Nov 2020 10:56:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v3 1/5] net: implement threaded-able napi poll
 loop support
Message-ID: <20201123105647.3ae683ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_ATLr-=xQ8cZLJE3cbWn=cFx11kpWm0cV2J2hiaOVFPzg@mail.gmail.com>
References: <20201118191009.3406652-1-weiwan@google.com>
        <20201118191009.3406652-2-weiwan@google.com>
        <20201121163136.024d636c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAEA6p_ATLr-=xQ8cZLJE3cbWn=cFx11kpWm0cV2J2hiaOVFPzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 18:23:33 -0800 Wei Wang wrote:
> On Sat, Nov 21, 2020 at 4:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 18 Nov 2020 11:10:05 -0800 Wei Wang wrote:  
> > > +int napi_set_threaded(struct napi_struct *n, bool threaded)
> > > +{
> > > +     ASSERT_RTNL();
> > > +
> > > +     if (n->dev->flags & IFF_UP)
> > > +             return -EBUSY;
> > > +
> > > +     if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> > > +             return 0;
> > > +     if (threaded)
> > > +             set_bit(NAPI_STATE_THREADED, &n->state);
> > > +     else
> > > +             clear_bit(NAPI_STATE_THREADED, &n->state);  
> >
> > Do we really need the per-NAPI control here? Does anyone have use cases
> > where that makes sense? The user would be guessing which NAPI means
> > which queue and which bit, currently.  
> 
> Thanks for reviewing this.
> I think one use case might be that if the driver uses separate napi
> for tx and rx, one might want to only enable threaded mode for rx, and
> leave tx completion in interrupt mode.

Okay, but with separate IRQs/NAPIs that's really a guessing game in
terms of NAPI -> bit position. I'd rather we held off on the per-NAPI
control. 

If anyone has a strong use for it now, please let us know.
