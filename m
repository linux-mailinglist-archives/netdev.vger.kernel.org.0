Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC93A309803
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 20:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhA3TXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 14:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232164AbhA3TXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 14:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B41C64E11;
        Sat, 30 Jan 2021 19:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612034573;
        bh=TOszrn+PW/rGlqmIUF/GM39AiWhtl1ww2m/a3RSYNFk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r4IPVJMXW1t9Q78NZ40jKC7Q9hlsCPa3Ag01jSS/EfG9aLg1GgGW/4TX1LfJBdvD5
         ZtSlQKwHHN0b+nzqdiz4DXOBnJpZ0HZ6YAA/VYT/UnZNL0f+elkDyARQRQLqe4Mtqk
         QiNBASkArMAtcgiBe+hi68kdeho6cMNi6BSjmXw8r3MJG6dbDQeozhV26V9sGbU4Yv
         KGnIfpCT6uJjPKVSNgiFGsxpmmEKcMDn87lXyQe2bL+0QRhGO7XTV+icwDjxSVxSpm
         y+82YFxOuemGtUVlg1D2JirhcdojoJ0jJ9KvIsrig9ChcbQ+xLVfKzAoA659Bi+ke/
         n1eV0C/xpx4og==
Date:   Sat, 30 Jan 2021 11:22:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Alex Elder <elder@linaro.org>, David Miller <davem@davemloft.net>,
        elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 9/9] net: ipa: don't disable NAPI in suspend
Message-ID: <20210130112252.131ead6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
References: <20210129202019.2099259-1-elder@linaro.org>
        <20210129202019.2099259-10-elder@linaro.org>
        <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 10:25:16 -0500 Willem de Bruijn wrote:
> > @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
> >         struct gsi_channel *channel = &gsi->channel[channel_id];
> >         int ret;
> >
> > -       /* Enable the completion interrupt */
> > +       /* Enable NAPI and the completion interrupt */
> > +       napi_enable(&channel->napi);
> >         gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
> >
> >         ret = __gsi_channel_start(channel, true);
> > -       if (ret)
> > -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> > +       if (!ret)
> > +               return 0;
> > +
> > +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> > +       napi_disable(&channel->napi);
> >
> >         return ret;
> >  }  
> 
> subjective, but easier to parse when the normal control flow is linear
> and the error path takes a branch (or goto, if reused).

FWIW - fully agreed, I always thought this was part of the kernel
coding style.
